import '../../shared/models/cefr_level.dart';

/// How many words a chunk should hold, per reader level.
///
/// Values come from PRODUCT_REPORT.md section 8.3. They are a target, not a
/// guarantee: the chunker will overshoot [minWords] rather than cut a
/// sentence in half.
class ChunkSizePolicy {
  const ChunkSizePolicy({required this.minWords, required this.maxWords});

  factory ChunkSizePolicy.forLevel(CefrLevel level) {
    return switch (level) {
      CefrLevel.a1 => const ChunkSizePolicy(minWords: 80, maxWords: 150),
      CefrLevel.a2 => const ChunkSizePolicy(minWords: 150, maxWords: 250),
      CefrLevel.b1 => const ChunkSizePolicy(minWords: 250, maxWords: 500),
      CefrLevel.b2 => const ChunkSizePolicy(minWords: 500, maxWords: 900),
      CefrLevel.c1 => const ChunkSizePolicy(minWords: 900, maxWords: 1500),
    };
  }

  final int minWords;
  final int maxWords;

  /// Safety valve for pathological input.
  ///
  /// Imported files are untrusted (AGENTS.md section 26): a "book" may be one
  /// multi-megabyte line with no punctuation at all. Past this many words the
  /// chunker cuts at a word boundary rather than build an unbounded chunk.
  int get hardMaxWords => maxWords * 2;
}
