import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/text/chunk_size_policy.dart';
import 'package:knosis/core/text/reading_speed.dart';

void main() {
  group('ReadingSpeed', () {
    test('converts words to time and back', () {
      const ReadingSpeed speed = ReadingSpeed(120);

      expect(speed.wordsIn(const Duration(minutes: 1)), 120);
      expect(speed.wordsIn(const Duration(seconds: 30)), 60);
      expect(speed.timeFor(120), const Duration(minutes: 1));
      expect(speed.timeFor(60), const Duration(seconds: 30));
    });

    test('refuses implausible speeds', () {
      expect(ReadingSpeed.clamped(0).wordsPerMinute, ReadingSpeed.slowest);
      expect(ReadingSpeed.clamped(99999).wordsPerMinute, ReadingSpeed.fastest);
      expect(ReadingSpeed.clamped(180).wordsPerMinute, 180);
    });

    test('starts below a native pace, for a learner', () {
      expect(ReadingSpeed.comfortable.wordsPerMinute, lessThan(250));
      expect(ReadingSpeed.comfortable.wordsPerMinute, greaterThan(60));
    });
  });

  group('ChunkSizePolicy.forReadingSpeed', () {
    test('sizes a passage around one minute of this reader', () {
      final ChunkSizePolicy fast = ChunkSizePolicy.forReadingSpeed(
        const ReadingSpeed(200),
      );

      expect(fast.minWords, 150);
      expect(fast.maxWords, 250);
    });

    test('a slower reader gets shorter passages', () {
      final ChunkSizePolicy slow = ChunkSizePolicy.forReadingSpeed(
        const ReadingSpeed(80),
      );
      final ChunkSizePolicy fast = ChunkSizePolicy.forReadingSpeed(
        const ReadingSpeed(200),
      );

      expect(slow.maxWords, lessThan(fast.maxWords));
    });

    test('honours a custom passage length', () {
      final ChunkSizePolicy policy = ChunkSizePolicy.forReadingSpeed(
        const ReadingSpeed(200),
        passageDuration: const Duration(seconds: 30),
      );

      expect(policy.minWords, 75);
      expect(policy.maxWords, 125);
    });

    test('never produces a passage too short to be one', () {
      final ChunkSizePolicy tiny = ChunkSizePolicy.forReadingSpeed(
        const ReadingSpeed(40),
        passageDuration: const Duration(seconds: 5),
      );

      expect(tiny.minWords, ChunkSizePolicy.shortestPassage);
      expect(tiny.maxWords, greaterThanOrEqualTo(tiny.minWords));
    });
  });
}
