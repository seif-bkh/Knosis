import '../../../core/text/chunk_boundary.dart';
import '../../../core/text/chunk_size_policy.dart';
import '../../../core/text/text_chunker.dart';

/// One passage: what the reader sees between two pauses.
class Passage {
  const Passage({required this.text, required this.wordCount});

  final String text;
  final int wordCount;
}

/// A document already split into passages.
///
/// This type holds every passage in memory, which is fine for a short text
/// and wrong for a 2,000 page book. It exists so the reader experience can
/// be built and tested before the import pipeline lands. The book-scale
/// version reads one chunk row at a time from the database (AGENTS.md
/// section 10) and will implement the same surface the reader already uses.
class ReaderDocument {
  const ReaderDocument({required this.title, required this.passages});

  /// Splits [text] into passages, never cutting a sentence.
  static ReaderDocument fromText({
    required String title,
    required String text,
    required ChunkSizePolicy policy,
  }) {
    final List<Passage> passages = <Passage>[];
    for (final ChunkBoundary boundary in TextChunker(policy).split(text)) {
      passages.add(
        Passage(
          text: text.substring(boundary.start, boundary.end),
          wordCount: boundary.wordCount,
        ),
      );
    }
    return ReaderDocument(title: title, passages: passages);
  }

  final String title;
  final List<Passage> passages;

  int get passageCount => passages.length;

  bool get isEmpty => passages.isEmpty;
}
