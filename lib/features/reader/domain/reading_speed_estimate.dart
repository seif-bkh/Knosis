import '../../../core/text/reading_speed.dart';

/// One observation: how many words were read, and how long it took.
class SpeedSample {
  const SpeedSample({required this.words, required this.time});

  final int words;
  final Duration time;
}

/// Turns real reading into a reading speed.
///
/// The estimate exists to size passages, so it errs towards caution: with
/// too little evidence it returns null and the caller keeps the current
/// pace. A wrong guess here makes every future passage the wrong length.
abstract final class ReadingSpeedEstimate {
  /// Below this much evidence, any number would be noise.
  static const int minimumWords = 150;
  static const Duration minimumTime = Duration(seconds: 30);

  /// A glance, not reading.
  static const int shortestSampleSeconds = 5;
  static const int smallestSampleWords = 20;

  /// Faster than this is skipping ahead, not reading, and must not drag the
  /// estimate up: the next passage would then be too long for real reading.
  static const int impliedCeiling = 800;

  /// The measured speed, or null when there is not enough evidence yet.
  static ReadingSpeed? fromSamples(Iterable<SpeedSample> samples) {
    int words = 0;
    int seconds = 0;

    for (final SpeedSample sample in samples) {
      final int sampleSeconds = sample.time.inSeconds;
      if (sampleSeconds < shortestSampleSeconds) {
        continue;
      }
      if (sample.words < smallestSampleWords) {
        continue;
      }
      final double implied = sample.words * 60 / sampleSeconds;
      if (implied > impliedCeiling) {
        continue;
      }
      words += sample.words;
      seconds += sampleSeconds;
    }

    if (words < minimumWords || seconds < minimumTime.inSeconds) {
      return null;
    }
    return ReadingSpeed.clamped((words * 60 / seconds).round());
  }
}
