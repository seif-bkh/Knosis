import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/database/knosis_database.dart';
import 'package:sqlite3/sqlite3.dart';

/// A hand-maintained snapshot of schema v1.
///
/// The point of this test is that a database created by a *shipped* version
/// of Knosis still opens, keeps its data and gains the new table. So the
/// starting state is built with raw SQL rather than with today's drift
/// classes, which would only ever produce today's schema.
const List<String> _schemaV1 = <String>[
  '''
CREATE TABLE books (
  id TEXT NOT NULL,
  title TEXT NOT NULL,
  author TEXT NULL,
  language_code TEXT NOT NULL,
  source_file_path TEXT NOT NULL,
  cover_path TEXT NULL,
  format TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'notStarted',
  imported_at INTEGER NOT NULL DEFAULT 0,
  last_read_at INTEGER NULL,
  total_words INTEGER NOT NULL DEFAULT 0,
  total_chapters INTEGER NOT NULL DEFAULT 0,
  difficulty_score REAL NULL,
  current_chapter_id TEXT NULL,
  current_chunk_id TEXT NULL,
  current_char_offset INTEGER NULL,
  PRIMARY KEY (id)
)''',
  '''
CREATE TABLE chapters (
  id TEXT NOT NULL,
  book_id TEXT NOT NULL REFERENCES books (id) ON DELETE CASCADE,
  title TEXT NULL,
  order_index INTEGER NOT NULL,
  start_offset INTEGER NOT NULL,
  end_offset INTEGER NOT NULL,
  word_count INTEGER NOT NULL DEFAULT 0,
  difficulty_score REAL NULL,
  PRIMARY KEY (id)
)''',
  '''
CREATE TABLE chunks (
  id TEXT NOT NULL,
  book_id TEXT NOT NULL REFERENCES books (id) ON DELETE CASCADE,
  chapter_id TEXT NOT NULL REFERENCES chapters (id) ON DELETE CASCADE,
  order_index INTEGER NOT NULL,
  content TEXT NOT NULL,
  start_offset INTEGER NOT NULL,
  end_offset INTEGER NOT NULL,
  word_count INTEGER NOT NULL DEFAULT 0,
  difficulty_score REAL NULL,
  status TEXT NOT NULL DEFAULT 'unread',
  read_count INTEGER NOT NULL DEFAULT 0,
  last_read_at INTEGER NULL,
  PRIMARY KEY (id)
)''',
];

/// A reader mid-book: a saved position, a highlighted-and-read chunk.
const List<String> _dataV1 = <String>[
  '''
INSERT INTO books (
  id, title, author, language_code, source_file_path, format, status,
  imported_at, total_words, total_chapters,
  current_chapter_id, current_chunk_id, current_char_offset
) VALUES (
  'book-1', 'A Book Someone Was Reading', 'A. Writer', 'en',
  '/books/book-1.txt', 'txt', 'reading', 1700000000, 240, 1,
  'chapter-1', 'chunk-2', 118
)''',
  '''
INSERT INTO chapters (
  id, book_id, title, order_index, start_offset, end_offset, word_count
) VALUES ('chapter-1', 'book-1', 'One', 0, 0, 1200, 240)''',
  '''
INSERT INTO chunks (
  id, book_id, chapter_id, order_index, content, start_offset, end_offset,
  word_count, status, read_count
) VALUES (
  'chunk-1', 'book-1', 'chapter-1', 0, 'The first chunk. ', 0, 17, 3,
  'readOnce', 2
)''',
  '''
INSERT INTO chunks (
  id, book_id, chapter_id, order_index, content, start_offset, end_offset,
  word_count, status, read_count
) VALUES (
  'chunk-2', 'book-1', 'chapter-1', 1, 'The second chunk.', 17, 34, 3,
  'unread', 0
)''',
];

void main() {
  late Directory directory;
  late File file;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('knosis-migration');
    file = File('${directory.path}/knosis.sqlite');
  });

  tearDown(() async {
    await directory.delete(recursive: true);
  });

  void writeSchemaV1() {
    final Database raw = sqlite3.open(file.path);
    for (final String statement in _schemaV1) {
      raw.execute(statement);
    }
    for (final String statement in _dataV1) {
      raw.execute(statement);
    }
    raw.execute('PRAGMA user_version = 1');
    raw.close();
  }

  test('a v1 database keeps every row when it becomes v2', () async {
    writeSchemaV1();

    final KnosisDatabase db = KnosisDatabase(NativeDatabase(file));
    addTearDown(db.close);

    final BookRow book = await db.select(db.books).getSingle();
    final List<ChunkRow> chunks = await db.select(db.chunks).get();

    expect(book.id, 'book-1');
    expect(book.title, 'A Book Someone Was Reading');
    expect(book.totalWords, 240);
    expect(chunks, hasLength(2));
    expect(await db.select(db.chapters).get(), hasLength(1));
  });

  test('the reading position survives the upgrade', () async {
    writeSchemaV1();

    final KnosisDatabase db = KnosisDatabase(NativeDatabase(file));
    addTearDown(db.close);

    final BookRow book = await db.select(db.books).getSingle();

    expect(book.currentChapterId, 'chapter-1');
    expect(book.currentChunkId, 'chunk-2');
    expect(book.currentCharOffset, 118);
  });

  test('per chunk reading state survives the upgrade', () async {
    writeSchemaV1();

    final KnosisDatabase db = KnosisDatabase(NativeDatabase(file));
    addTearDown(db.close);

    final List<ChunkRow> chunks = await db.select(db.chunks).get();
    final ChunkRow first = chunks.firstWhere((ChunkRow c) => c.id == 'chunk-1');

    expect(first.readCount, 2);
    expect(first.content, 'The first chunk. ');
  });

  test('the upgraded database has a usable reading_sessions table', () async {
    writeSchemaV1();

    final KnosisDatabase db = KnosisDatabase(NativeDatabase(file));
    addTearDown(db.close);

    final ReadingSessionsCompanion session = ReadingSessionsCompanion.insert(
      id: 'session-1',
      bookId: 'book-1',
    );
    await db.into(db.readingSessions).insert(session);

    final query = db.select(db.readingSessions);
    final List<ReadingSessionRow> sessions = await query.get();

    expect(db.schemaVersion, 2);
    expect(sessions, hasLength(1));
    expect(sessions.single.bookId, 'book-1');
  });

  test('a fresh database is created at the current version', () async {
    final KnosisDatabase db = KnosisDatabase(NativeDatabase(file));
    addTearDown(db.close);

    await db.customSelect('SELECT 1').get();

    expect(db.schemaVersion, 2);
    expect(await db.select(db.readingSessions).get(), isEmpty);
    expect(await db.select(db.books).get(), isEmpty);
  });
}
