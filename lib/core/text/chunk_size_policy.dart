import '../../shared/models/cefr_level.dart';
import 'reading_speed.dart';

/// How many words a chunk should hold.
///
/// Two ways to size a passage:
///
/// * [ChunkSizePolicy.forReadingSpeed] - the one the reader uses. A passage
///   is roughly one [defaultPassageDuration] of *this* reader's pace, so
///   finishing one always feels like the same small effort.
/// * [ChunkSizePolicy.forLevel] - the CEFR word ranges from
///   PRODUCT_REPORT.md section 8.3, useful before a reading speed is known.
///
/// Values are a target, not a guarantee: the chunker will overshoot rather
/// than cut a sentence in half.
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

  /// Sizes a passage as about [passageDuration] of reading at [speed].
  factory ChunkSizePolicy.forReadingSpeed(
    ReadingSpeed speed, {
    Duration passageDuration = defaultPassageDuration,
  }) {
    final int target = speed.wordsIn(passageDuration);
    int minWords = (target * 3 / 4).round();
    if (minWords < shortestPassage) {
      minWords = shortestPassage;
    }
    int maxWords = (target * 5 / 4).round();
    if (maxWords < minWords) {
      maxWords = minWords;
    }
    return ChunkSizePolicy(minWords: minWords, maxWords: maxWords);
  }

  /// A passage should feel like a sip of reading, not a chapter.
  static const Duration defaultPassageDuration = Duration(minutes: 1);

  /// Below this, a passage stops being a passage and starts being a line.
  static const int shortestPassage = 20;

  final int minWords;
  final int maxWords;

  /// Safety valve for pathological input.
  ///
  /// Imported files are untrusted (AGENTS.md section 26): a "book" may be one
  /// multi-megabyte line with no punctuation at all. Past this many words the
  /// chunker cuts at a word boundary rather than build an unbounded chunk.
  int get hardMaxWords => maxWords * 2;
}
