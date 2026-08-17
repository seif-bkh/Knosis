import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/text/reading_speed.dart';
import 'package:knosis/features/reader/domain/reading_speed_estimate.dart';

SpeedSample _sample(int words, int seconds) {
  return SpeedSample(words: words, time: Duration(seconds: seconds));
}

void main() {
  group('ReadingSpeedEstimate', () {
    test('has no opinion until there is enough evidence', () {
      expect(ReadingSpeedEstimate.fromSamples(<SpeedSample>[]), isNull);
      expect(
        ReadingSpeedEstimate.fromSamples(<SpeedSample>[_sample(100, 60)]),
        isNull,
      );
    });

    test('measures the obvious case', () {
      // 300 words in two minutes is 150 words per minute.
      final ReadingSpeed? speed = ReadingSpeedEstimate.fromSamples(
        <SpeedSample>[_sample(150, 60), _sample(150, 60)],
      );

      expect(speed, isNotNull);
      expect(speed!.wordsPerMinute, 150);
    });

    test('a slow reader measures slow', () {
      final ReadingSpeed? speed = ReadingSpeedEstimate.fromSamples(
        <SpeedSample>[_sample(80, 60), _sample(80, 60), _sample(80, 60)],
      );

      expect(speed!.wordsPerMinute, 80);
    });

    test('ignores a glance too short to be reading', () {
      final ReadingSpeed? speed = ReadingSpeedEstimate.fromSamples(
        <SpeedSample>[_sample(200, 100), _sample(30, 2)],
      );

      expect(speed!.wordsPerMinute, 120);
    });

    test('a skipped passage does not inflate the estimate', () {
      // 200 words in six seconds is skipping, not reading.
      final ReadingSpeed? honest = ReadingSpeedEstimate.fromSamples(
        <SpeedSample>[_sample(200, 100)],
      );
      final ReadingSpeed? withSkip = ReadingSpeedEstimate.fromSamples(
        <SpeedSample>[_sample(200, 100), _sample(200, 6)],
      );

      expect(withSkip!.wordsPerMinute, honest!.wordsPerMinute);
    });

    test('stays inside plausible human limits', () {
      final ReadingSpeed? crawling = ReadingSpeedEstimate.fromSamples(
        <SpeedSample>[_sample(160, 3600)],
      );

      expect(crawling!.wordsPerMinute, ReadingSpeed.slowest);
    });

    test('needs time as well as words', () {
      final ReadingSpeed? speed = ReadingSpeedEstimate.fromSamples(
        <SpeedSample>[_sample(160, 20)],
      );

      expect(speed, isNull);
    });
  });
}
