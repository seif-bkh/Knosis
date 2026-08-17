import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/database/knosis_database.dart';
import 'package:knosis/shared/models/book_format.dart';
import 'package:knosis/shared/models/book_status.dart';
import 'package:knosis/shared/models/chunk_status.dart';

Future<void> _insertBook(KnosisDatabase db, String id) async {
  final BooksCompanion row = BooksCompanion.insert(
    id: id,
    title: 'A Book',
    languageCode: 'en',
    sourceFilePath: '/books/$id.txt',
    format: BookFormat.txt,
  );
  await db.into(db.books).insert(row);
}

Future<void> _insertChapter(
  KnosisDatabase db,
  String id,
  String bookId,
) async {
  final ChaptersCompanion row = ChaptersCompanion.insert(
    id: id,
    bookId: bookId,
    orderIndex: 0,
    startOffset: 0,
    endOffset: 100,
  );
  await db.into(db.chapters).insert(row);
}

Future<void> _insertChunk(
  KnosisDatabase db,
  String id,
  String chapterId,
  int orderIndex,
) async {
  final ChunksCompanion row = ChunksCompanion.insert(
    id: id,
    bookId: 'book-1',
    chapterId: chapterId,
    orderIndex: orderIndex,
    content: 'Some text.',
    startOffset: orderIndex * 10,
    endOffset: orderIndex * 10 + 10,
  );
  await db.into(db.chunks).insert(row);
}

Future<List<String>> _tableNames(KnosisDatabase db) async {
  const String sql = "SELECT name FROM sqlite_master WHERE type = 'table'";
  final Selectable<QueryRow> query = db.customSelect(sql);
  final List<QueryRow> rows = await query.get();
  return rows.map((QueryRow row) => row.read<String>('name')).toList();
}

Future<void> _deleteBook(KnosisDatabase db, String id) async {
  final DeleteStatement<Books, BookRow> statement = db.delete(db.books);
  statement.where((Books b) => b.id.equals(id));
  await statement.go();
}

Future<void> _setPosition(KnosisDatabase db, String id) async {
  final UpdateStatement<Books, BookRow> statement = db.update(db.books);
  statement.where((Books b) => b.id.equals(id));
  await statement.write(
    const BooksCompanion(
      currentChapterId: Value<String?>('chapter-1'),
      currentChunkId: Value<String?>('chunk-1'),
      currentCharOffset: Value<int?>(42),
    ),
  );
}

Future<List<ChunkRow>> _chunksInOrder(KnosisDatabase db) {
  final SimpleSelectStatement<Chunks, ChunkRow> query = db.select(db.chunks);
  query.orderBy(<OrderClauseGenerator<Chunks>>[
    (Chunks c) => OrderingTerm.asc(c.orderIndex),
  ]);
  return query.get();
}

void main() {
  late KnosisDatabase db;

  setUp(() {
    db = KnosisDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('schema', () {
    test('starts at version 1', () {
      expect(db.schemaVersion, 1);
    });

    test('creates every table of the reading core', () async {
      final List<String> names = await _tableNames(db);

      expect(names, contains('books'));
      expect(names, contains('chapters'));
      expect(names, contains('chunks'));
    });
  });

  group('books', () {
    test('round trips a book with its defaults', () async {
      await _insertBook(db, 'book-1');

      final BookRow book = await db.select(db.books).getSingle();

      expect(book.id, 'book-1');
      expect(book.title, 'A Book');
      expect(book.format, BookFormat.txt);
      expect(book.status, BookStatus.notStarted);
      expect(book.totalWords, 0);
      expect(book.totalChapters, 0);
      expect(book.author, isNull);
      expect(book.lastReadAt, isNull);
    });

    test('stores the reading position in recoverable parts', () async {
      await _insertBook(db, 'book-1');
      await _insertChapter(db, 'chapter-1', 'book-1');
      await _insertChunk(db, 'chunk-1', 'chapter-1', 0);

      await _setPosition(db, 'book-1');

      final BookRow book = await db.select(db.books).getSingle();

      expect(book.currentChapterId, 'chapter-1');
      expect(book.currentChunkId, 'chunk-1');
      expect(book.currentCharOffset, 42);
    });
  });

  group('referential integrity', () {
    test('rejects a chapter that belongs to no book', () async {
      await expectLater(
        _insertChapter(db, 'chapter-1', 'missing-book'),
        throwsA(isA<Exception>()),
      );
    });

    test('deleting a book removes its chapters and chunks', () async {
      await _insertBook(db, 'book-1');
      await _insertChapter(db, 'chapter-1', 'book-1');
      await _insertChunk(db, 'chunk-1', 'chapter-1', 0);

      await _deleteBook(db, 'book-1');

      expect(await db.select(db.chapters).get(), isEmpty);
      expect(await db.select(db.chunks).get(), isEmpty);
    });
  });

  group('chunks', () {
    test('read back in reading order', () async {
      await _insertBook(db, 'book-1');
      await _insertChapter(db, 'chapter-1', 'book-1');
      await _insertChunk(db, 'chunk-c', 'chapter-1', 2);
      await _insertChunk(db, 'chunk-a', 'chapter-1', 0);
      await _insertChunk(db, 'chunk-b', 'chapter-1', 1);

      final List<ChunkRow> chunks = await _chunksInOrder(db);
      final List<String> ids = chunks.map((ChunkRow c) => c.id).toList();

      expect(ids, <String>['chunk-a', 'chunk-b', 'chunk-c']);
    });

    test('starts unread with no reads recorded', () async {
      await _insertBook(db, 'book-1');
      await _insertChapter(db, 'chapter-1', 'book-1');
      await _insertChunk(db, 'chunk-1', 'chapter-1', 0);

      final ChunkRow chunk = await db.select(db.chunks).getSingle();

      expect(chunk.status, ChunkStatus.unread);
      expect(chunk.readCount, 0);
      expect(chunk.lastReadAt, isNull);
      expect(chunk.content, 'Some text.');
    });
  });
}
