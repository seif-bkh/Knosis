import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/database/id_generator.dart';
import '../../../core/database/knosis_database.dart';
import '../../../shared/models/book_status.dart';
import '../../../shared/models/reading_mode.dart';
import '../domain/chunk_summary.dart';
import '../domain/reading_speed_estimate.dart';

/// Everything the reader needs from storage.
///
/// Two deliberate rules live here:
///
/// * the chunk *index* (ids and word counts) may be read whole, because it
///   is small; the chunk *text* is only ever read for the passage on screen;
/// * the reading position is written as chapter, chunk and offset, so it
///   survives anything that does not move the chunks themselves.
class ReaderRepository {
  ReaderRepository(this._database);

  final KnosisDatabase _database;

  Future<BookRow?> book(String bookId) {
    final query = _database.select(_database.books);
    query.where((t) => t.id.equals(bookId));
    return query.getSingleOrNull();
  }

  /// Ids and lengths of every chunk in the book, in reading order.
  Future<List<ChunkSummary>> chunkIndex(String bookId) async {
    const String sql =
        'SELECT id, chapter_id, order_index, word_count FROM chunks '
        'WHERE book_id = ? ORDER BY order_index ASC';
    final query = _database.customSelect(
      sql,
      variables: [Variable<String>(bookId)],
    );
    final List<QueryRow> rows = await query.get();

    final List<ChunkSummary> summaries = <ChunkSummary>[];
    for (final QueryRow row in rows) {
      summaries.add(
        ChunkSummary(
          id: row.read<String>('id'),
          chapterId: row.read<String>('chapter_id'),
          orderIndex: row.read<int>('order_index'),
          wordCount: row.read<int>('word_count'),
        ),
      );
    }
    return summaries;
  }

  /// The text of one passage: only the chunks it actually covers.
  Future<String> passageText(String bookId, int fromOrder, int toOrder) async {
    final query = _database.select(_database.chunks);
    query.where((t) => t.bookId.equals(bookId));
    query.where((t) => t.orderIndex.isBiggerOrEqualValue(fromOrder));
    query.where((t) => t.orderIndex.isSmallerOrEqualValue(toOrder));
    query.orderBy([(t) => OrderingTerm.asc(t.orderIndex)]);
    final List<ChunkRow> rows = await query.get();

    final StringBuffer buffer = StringBuffer();
    for (final ChunkRow row in rows) {
      buffer.write(row.content);
    }
    // Chunks carry the whitespace that followed them so passages recompose
    // exactly; the tail of the last one is not wanted on screen.
    return buffer.toString().trimRight();
  }

  /// Records where the reader stopped.
  Future<void> savePosition({
    required String bookId,
    required String chapterId,
    required String chunkId,
    int charOffset = 0,
  }) async {
    final statement = _database.update(_database.books);
    statement.where((t) => t.id.equals(bookId));
    await statement.write(
      BooksCompanion(
        currentChapterId: Value<String?>(chapterId),
        currentChunkId: Value<String?>(chunkId),
        currentCharOffset: Value<int?>(charOffset),
        lastReadAt: Value<DateTime?>(DateTime.now()),
        status: const Value<BookStatus>(BookStatus.reading),
      ),
    );
  }

  /// Opens a reading session and returns its id.
  Future<String> startSession({
    required String bookId,
    String? chapterId,
    String? chunkStartId,
    ReadingMode mode = ReadingMode.flow,
  }) async {
    final String id = IdGenerator.uuidV4();
    final ReadingSessionsCompanion session = ReadingSessionsCompanion.insert(
      id: id,
      bookId: bookId,
      chapterId: Value<String?>(chapterId),
      chunkStartId: Value<String?>(chunkStartId),
      mode: Value<ReadingMode>(mode),
      startedAt: Value<DateTime>(DateTime.now()),
    );
    await _database.into(_database.readingSessions).insert(session);
    return id;
  }

  /// Adds a finished passage to a session.
  ///
  /// Accumulated in SQL rather than read-modify-write, so two passages
  /// finishing close together cannot lose one another's words.
  Future<void> recordPassage({
    required String sessionId,
    required int words,
    required Duration elapsed,
    required String chunkEndId,
  }) async {
    const String sql =
        'UPDATE reading_sessions SET words_read = words_read + ?, '
        'duration_seconds = duration_seconds + ?, chunk_end_id = ?, '
        'ended_at = ? WHERE id = ?';
    await _database.customUpdate(
      sql,
      variables: [
        Variable<int>(words),
        Variable<int>(elapsed.inSeconds),
        Variable<String>(chunkEndId),
        Variable<DateTime>(DateTime.now()),
        Variable<String>(sessionId),
      ],
      updates: {_database.readingSessions},
    );
  }

  /// Recent evidence of how fast this reader actually reads.
  Future<List<SpeedSample>> recentSpeedSamples({int limit = 20}) async {
    const String sql =
        'SELECT words_read, duration_seconds FROM reading_sessions '
        'WHERE duration_seconds > 0 ORDER BY started_at DESC LIMIT ?';
    final query = _database.customSelect(
      sql,
      variables: [Variable<int>(limit)],
    );
    final List<QueryRow> rows = await query.get();

    final List<SpeedSample> samples = <SpeedSample>[];
    for (final QueryRow row in rows) {
      samples.add(
        SpeedSample(
          words: row.read<int>('words_read'),
          time: Duration(seconds: row.read<int>('duration_seconds')),
        ),
      );
    }
    return samples;
  }
}

ReaderRepository _createRepository(Ref ref) {
  return ReaderRepository(ref.watch(databaseProvider));
}

final Provider<ReaderRepository> readerRepositoryProvider =
    Provider<ReaderRepository>(_createRepository);
