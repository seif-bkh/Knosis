import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/database/knosis_database.dart';
import 'package:knosis/features/reader/data/reader_repository.dart';
import 'package:knosis/features/reader/data/sample_library.dart';
import 'package:knosis/features/reader/domain/chunk_summary.dart';
import 'package:knosis/features/reader/domain/reading_speed_estimate.dart';
import 'package:knosis/shared/models/reading_mode.dart';

void main() {
  late KnosisDatabase db;
  late ReaderRepository repository;
  late List<ChunkSummary> chunks;

  setUp(() async {
    db = KnosisDatabase(NativeDatabase.memory());
    repository = ReaderRepository(db);
    await SampleLibrary.ensureSeeded(db);
    chunks = await repository.chunkIndex(SampleLibrary.bookId);
  });

  tearDown(() async {
    await db.close();
  });

  test('a new session starts empty and in flow mode', () async {
    final String id = await repository.startSession(
      bookId: SampleLibrary.bookId,
      chapterId: chunks.first.chapterId,
      chunkStartId: chunks.first.id,
    );

    final query = db.select(db.readingSessions);
    final ReadingSessionRow session = await query.getSingle();

    expect(session.id, id);
    expect(session.bookId, SampleLibrary.bookId);
    expect(session.chunkStartId, chunks.first.id);
    expect(session.mode, ReadingMode.flow);
    expect(session.wordsRead, 0);
    expect(session.durationSeconds, 0);
    expect(session.endedAt, isNull);
  });

  test('finished passages accumulate into the session', () async {
    final String id = await repository.startSession(
      bookId: SampleLibrary.bookId,
    );

    await repository.recordPassage(
      sessionId: id,
      words: 140,
      elapsed: const Duration(seconds: 55),
      chunkEndId: chunks[1].id,
    );
    await repository.recordPassage(
      sessionId: id,
      words: 160,
      elapsed: const Duration(seconds: 65),
      chunkEndId: chunks[2].id,
    );

    final query = db.select(db.readingSessions);
    final ReadingSessionRow session = await query.getSingle();

    expect(session.wordsRead, 300);
    expect(session.durationSeconds, 120);
    expect(session.chunkEndId, chunks[2].id);
    expect(session.endedAt, isNotNull);
  });

  test('recent samples describe how fast the reader actually read', () async {
    final String id = await repository.startSession(
      bookId: SampleLibrary.bookId,
    );
    await repository.recordPassage(
      sessionId: id,
      words: 300,
      elapsed: const Duration(minutes: 2),
      chunkEndId: chunks.last.id,
    );

    final List<SpeedSample> samples = await repository.recentSpeedSamples();

    expect(samples, hasLength(1));
    expect(samples.single.words, 300);
    expect(samples.single.time, const Duration(minutes: 2));
    expect(ReadingSpeedEstimate.fromSamples(samples)!.wordsPerMinute, 150);
  });

  test('a session with no reading time is not evidence', () async {
    await repository.startSession(bookId: SampleLibrary.bookId);

    final List<SpeedSample> samples = await repository.recentSpeedSamples();

    expect(samples, isEmpty);
  });

  test('removing a book removes its sessions', () async {
    final String id = await repository.startSession(
      bookId: SampleLibrary.bookId,
    );
    await repository.recordPassage(
      sessionId: id,
      words: 100,
      elapsed: const Duration(seconds: 60),
      chunkEndId: chunks.first.id,
    );

    final statement = db.delete(db.books);
    statement.where((t) => t.id.equals(SampleLibrary.bookId));
    await statement.go();

    expect(await db.select(db.readingSessions).get(), isEmpty);
  });
}
