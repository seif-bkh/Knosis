import 'package:drift/drift.dart';

import '../../../core/database/id_generator.dart';
import '../../../core/database/knosis_database.dart';
import '../../../core/text/chunk_boundary.dart';
import '../../../core/text/chunk_size_policy.dart';
import '../../../core/text/text_chunker.dart';
import '../../../shared/models/book_format.dart';
import 'sample_book.dart';

/// Puts the bundled sample text into the library.
///
/// Temporary: it stands in for the import pipeline so the reader can be used
/// end to end. Everything downstream of it - chunk rows, passages, saved
/// positions - is the real path an imported book will take.
abstract final class SampleLibrary {
  static const String bookId = 'sample-keeper-of-small-lights';

  /// Stored chunks are small and fixed, and are never sized by reading
  /// speed. Passages are composed from them at read time, so changing pace
  /// rewrites nothing and invalidates no saved position.
  static const ChunkSizePolicy chunkPolicy = ChunkSizePolicy(
    minWords: 40,
    maxWords: 90,
  );

  /// Seeds the sample once. Safe to call on every launch.
  static Future<void> ensureSeeded(KnosisDatabase database) async {
    final query = database.select(database.books);
    query.where((t) => t.id.equals(bookId));
    final BookRow? existing = await query.getSingleOrNull();
    if (existing != null) {
      return;
    }
    await _seed(database);
  }

  static Future<void> _seed(KnosisDatabase database) async {
    const String text = SampleBook.text;
    final TextChunker chunker = TextChunker(chunkPolicy);
    final List<ChunkBoundary> boundaries = chunker.chunk(text);
    final String chapterId = IdGenerator.uuidV4();

    int totalWords = 0;
    for (final ChunkBoundary boundary in boundaries) {
      totalWords += boundary.wordCount;
    }

    final List<ChunksCompanion> chunkRows = <ChunksCompanion>[];
    for (int i = 0; i < boundaries.length; i++) {
      final ChunkBoundary boundary = boundaries[i];
      // A chunk carries the whitespace that follows it, up to the next one,
      // so consecutive chunks recompose into the original text with its
      // paragraph breaks intact.
      final int contentEnd = i + 1 < boundaries.length
          ? boundaries[i + 1].start
          : text.length;
      chunkRows.add(
        ChunksCompanion.insert(
          id: IdGenerator.uuidV4(),
          bookId: bookId,
          chapterId: chapterId,
          orderIndex: i,
          content: text.substring(boundary.start, contentEnd),
          startOffset: boundary.start,
          endOffset: boundary.end,
          wordCount: Value<int>(boundary.wordCount),
        ),
      );
    }

    final BooksCompanion book = BooksCompanion.insert(
      id: bookId,
      title: SampleBook.title,
      languageCode: 'en',
      sourceFilePath: 'bundled://sample',
      format: BookFormat.txt,
      totalWords: Value<int>(totalWords),
      totalChapters: const Value<int>(1),
    );
    final ChaptersCompanion chapter = ChaptersCompanion.insert(
      id: chapterId,
      bookId: bookId,
      title: const Value<String?>('One'),
      orderIndex: 0,
      startOffset: 0,
      endOffset: text.length,
      wordCount: Value<int>(totalWords),
    );

    await database.transaction(() async {
      await database.into(database.books).insert(book);
      await database.into(database.chapters).insert(chapter);
      await database.batch((Batch batch) {
        batch.insertAll(database.chunks, chunkRows);
      });
    });
  }
}
