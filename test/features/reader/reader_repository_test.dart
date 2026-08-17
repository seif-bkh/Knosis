import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/database/knosis_database.dart';
import 'package:knosis/features/reader/data/reader_repository.dart';
import 'package:knosis/features/reader/data/sample_book.dart';
import 'package:knosis/features/reader/data/sample_library.dart';
import 'package:knosis/features/reader/domain/chunk_summary.dart';
import 'package:knosis/shared/models/book_status.dart';

void main() {
  late KnosisDatabase db;
  late ReaderRepository repository;

  setUp(() async {
    db = KnosisDatabase(NativeDatabase.memory());
    repository = ReaderRepository(db);
    await SampleLibrary.ensureSeeded(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('SampleLibrary', () {
    test('seeds a book, a chapter and its chunks', () async {
      final BookRow? book = await repository.book(SampleLibrary.bookId);
      final List<ChunkSummary> chunks = await repository.chunkIndex(
        SampleLibrary.bookId,
      );

      expect(book, isNotNull);
      expect(book!.title, SampleBook.title);
      expect(book.totalWords, greaterThan(0));
      expect(chunks.length, greaterThan(1));
    });

    test('seeding twice does not duplicate the book', () async {
      final List<ChunkSummary> before = await repository.chunkIndex(
        SampleLibrary.bookId,
      );

      await SampleLibrary.ensureSeeded(db);

      final List<ChunkSummary> after = await repository.chunkIndex(
        SampleLibrary.bookId,
      );

      expect(after.length, before.length);
    });

    test('the stored word count matches the chunks', () async {
      final BookRow? book = await repository.book(SampleLibrary.bookId);
      final List<ChunkSummary> chunks = await repository.chunkIndex(
        SampleLibrary.bookId,
      );

      int sum = 0;
      for (final ChunkSummary chunk in chunks) {
        sum += chunk.wordCount;
      }

      expect(book!.totalWords, sum);
    });
  });

  group('chunk index', () {
    test('comes back in reading order', () async {
      final List<ChunkSummary> chunks = await repository.chunkIndex(
        SampleLibrary.bookId,
      );

      for (int i = 0; i < chunks.length; i++) {
        expect(chunks[i].orderIndex, i);
        expect(chunks[i].id, isNotEmpty);
        expect(chunks[i].wordCount, greaterThan(0));
      }
    });

    test('is empty for a book that does not exist', () async {
      final List<ChunkSummary> chunks = await repository.chunkIndex('nope');

      expect(chunks, isEmpty);
    });
  });

  group('passage text', () {
    test('all chunks together recompose the original text', () async {
      final List<ChunkSummary> chunks = await repository.chunkIndex(
        SampleLibrary.bookId,
      );

      final String whole = await repository.passageText(
        SampleLibrary.bookId,
        0,
        chunks.last.orderIndex,
      );

      expect(whole, SampleBook.text.trim());
    });

    test('a range returns only its own chunks', () async {
      final String first = await repository.passageText(
        SampleLibrary.bookId,
        0,
        0,
      );
      final String firstTwo = await repository.passageText(
        SampleLibrary.bookId,
        0,
        1,
      );

      expect(first, isNotEmpty);
      expect(firstTwo.length, greaterThan(first.length));
      expect(firstTwo, startsWith(first));
    });

    test('keeps paragraph breaks between chunks', () async {
      final List<ChunkSummary> chunks = await repository.chunkIndex(
        SampleLibrary.bookId,
      );

      final String whole = await repository.passageText(
        SampleLibrary.bookId,
        0,
        chunks.last.orderIndex,
      );

      expect(whole, contains('\n\n'));
    });
  });

  group('reading position', () {
    test('is saved and read back', () async {
      final List<ChunkSummary> chunks = await repository.chunkIndex(
        SampleLibrary.bookId,
      );
      final BookRow? before = await repository.book(SampleLibrary.bookId);

      await repository.savePosition(
        bookId: SampleLibrary.bookId,
        chapterId: 'chapter-1',
        chunkId: chunks[2].id,
        charOffset: 17,
      );

      final BookRow? after = await repository.book(SampleLibrary.bookId);

      expect(before!.currentChunkId, isNull);
      expect(after!.currentChunkId, chunks[2].id);
      expect(after.currentChapterId, 'chapter-1');
      expect(after.currentCharOffset, 17);
    });

    test('marks the book as being read and stamps the time', () async {
      final List<ChunkSummary> chunks = await repository.chunkIndex(
        SampleLibrary.bookId,
      );

      await repository.savePosition(
        bookId: SampleLibrary.bookId,
        chapterId: 'chapter-1',
        chunkId: chunks.first.id,
      );

      final BookRow? book = await repository.book(SampleLibrary.bookId);

      expect(book!.status, BookStatus.reading);
      expect(book.lastReadAt, isNotNull);
    });
  });

  test('an unknown book has no row', () async {
    expect(await repository.book('missing'), isNull);
  });
}
