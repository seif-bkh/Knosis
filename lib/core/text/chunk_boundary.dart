/// Where one chunk begins and ends inside a source text.
///
/// A boundary deliberately carries **no text**. A 2,000 page book must never
/// be duplicated in memory (AGENTS.md section 10), so chunking produces
/// offsets and the caller decides what to read or persist.
///
/// [start] and [end] are UTF-16 code unit offsets into the text that was
/// chunked, usable directly with `String.substring(start, end)`. [end] is
/// exclusive and points just past the last non-whitespace character.
class ChunkBoundary {
  const ChunkBoundary({
    required this.index,
    required this.start,
    required this.end,
    required this.wordCount,
  });

  /// Position of this chunk in its source, starting at 0.
  final int index;
  final int start;
  final int end;
  final int wordCount;

  int get length => end - start;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ChunkBoundary &&
        other.index == index &&
        other.start == start &&
        other.end == end &&
        other.wordCount == wordCount;
  }

  @override
  int get hashCode => Object.hash(index, start, end, wordCount);

  @override
  String toString() {
    return 'ChunkBoundary(index: $index, start: $start, end: $end, '
        'wordCount: $wordCount)';
  }
}
