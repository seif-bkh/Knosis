import '../../../core/text/chunk_size_policy.dart';
import 'chunk_summary.dart';

/// One passage: a run of consecutive chunks read in one sitting.
class PassageSlice {
  const PassageSlice({
    required this.index,
    required this.firstOrder,
    required this.lastOrder,
    required this.firstChunkId,
    required this.firstChapterId,
    required this.wordCount,
  });

  final int index;
  final int firstOrder;
  final int lastOrder;

  /// Where a saved position points when this passage is open.
  final String firstChunkId;
  final String firstChapterId;

  final int wordCount;
}

/// How a book's chunks are grouped into passages for one reader.
///
/// Chunks are the persisted unit and never move. A passage is a *runtime*
/// grouping of them, rebuilt whenever the reader's pace changes.
///
/// That split is the whole point. Reading speed is expected to change - it
/// will be measured from real sessions, and the reader can adjust it - and
/// none of that may rewrite a row, orphan a highlight, or invalidate a saved
/// position. Sizing the stored chunks by speed would do all three
/// (AGENTS.md section 15).
class PassagePlan {
  const PassagePlan({required this.slices, required this.sliceOfChunk});

  /// Greedy grouping: keep adding chunks until one more would overshoot the
  /// reader's minute, provided the passage is already long enough to count.
  ///
  /// Every chunk already ends on a finished sentence, so any run of them
  /// does too.
  factory PassagePlan.from(List<ChunkSummary> chunks, ChunkSizePolicy policy) {
    final List<PassageSlice> slices = <PassageSlice>[];
    final Map<String, int> sliceOfChunk = <String, int>{};

    List<ChunkSummary> current = <ChunkSummary>[];
    int words = 0;

    void close() {
      if (current.isEmpty) {
        return;
      }
      final int index = slices.length;
      for (final ChunkSummary chunk in current) {
        sliceOfChunk[chunk.id] = index;
      }
      slices.add(
        PassageSlice(
          index: index,
          firstOrder: current.first.orderIndex,
          lastOrder: current.last.orderIndex,
          firstChunkId: current.first.id,
          firstChapterId: current.first.chapterId,
          wordCount: words,
        ),
      );
      current = <ChunkSummary>[];
      words = 0;
    }

    for (final ChunkSummary chunk in chunks) {
      final bool overshoots = words + chunk.wordCount > policy.maxWords;
      if (current.isNotEmpty && overshoots && words >= policy.minWords) {
        close();
      }
      current.add(chunk);
      words += chunk.wordCount;
      if (words >= policy.maxWords) {
        close();
      }
    }
    close();

    return PassagePlan(slices: slices, sliceOfChunk: sliceOfChunk);
  }

  final List<PassageSlice> slices;

  /// Which passage a given chunk belongs to, for resuming.
  final Map<String, int> sliceOfChunk;

  int get length => slices.length;

  bool get isEmpty => slices.isEmpty;

  PassageSlice at(int index) => slices[index];

  /// The passage holding [chunkId], or the beginning if it is unknown.
  ///
  /// An unknown chunk is not an error: the book may have been reimported, or
  /// the position may predate a change. Starting over beats crashing.
  int indexForChunk(String? chunkId) {
    if (chunkId == null) {
      return 0;
    }
    return sliceOfChunk[chunkId] ?? 0;
  }

  /// Fraction read once passage [index] is finished.
  double progressAfter(int index) {
    if (isEmpty) {
      return 0;
    }
    return (index + 1) / length;
  }
}
