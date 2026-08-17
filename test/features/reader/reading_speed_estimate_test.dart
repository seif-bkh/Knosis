import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/text/reading_speed.dart';
import 'package:knosis/features/reader/domain/reading_speed_estimate.dart';

SpeedSample _sample(int words, int seconds) {
  return SpeedSample(words: words, time: Duration(seconds: seconds));
}

void main() {
  group('ReadingSpeedEstimate', () {
    test('has no opinion until there is enough evidence', () {
      final List<SpeedSample> nothing = <SpeedSample>[];
      final List<SpeedSample> tooLittle = <SpeedSample>[_sample(100, 60)];

      expect(ReadingSpeedEstimate.fromSamples(nothing), isNull);
      expect(ReadingSpeedEstimate.fromSamples(tooLittle), isNull);
    });

    test('measures the obvious case', () {
      // 300 words in two minutes is 150 words per minute.
      final List<SpeedSample> samples = <SpeedSample>[
        _sample(150, 60),
        _sample(150, 60),
      ];

      final ReadingSpeed? speed = ReadingSpeedEstimate.fromSamples(samples);

      expect(speed, isNotNull);
      expect(speed!.wordsPerMinute, 150);
    });

    test('a slow reader measures slow', () {
      final List<SpeedSample> samples = <SpeedSample>[
        _sample(80, 60),
        _sample(80, 60),
        _sample(80, 60),
      ];

      final ReadingSpeed? speed = ReadingSpeedEstimate.fromSamples(samples);

      expect(speed!.wordsPerMinute, 80);
    });

    test('ignores a glance too short to be reading', () {
      final List<SpeedSample> samples = <SpeedSample>[
        _sample(200, 100),
        _sample(30, 2),
      ];

      final ReadingSpeed? speed = ReadingSpeedEstimate.fromSamples(samples);

      expect(speed!.wordsPerMinute, 120);
    });

    test('a skipped passage does not inflate the estimate', () {
      // 200 words in six seconds is skipping, not reading.
      final List<SpeedSample> read = <SpeedSample>[_sample(200, 100)];
      final List<SpeedSample> readAndSkipped = <SpeedSample>[
        _sample(200, 100),
        _sample(200, 6),
      ];

      final ReadingSpeed? honest = ReadingSpeedEstimate.fromSamples(read);
      final ReadingSpeed? withSkip = ReadingSpeedEstimate.fromSamples(
        readAndSkipped,
      );

      expect(withSkip!.wordsPerMinute, honest!.wordsPerMinute);
    });

    test('stays inside plausible human limits', () {
      final List<SpeedSample> samples = <SpeedSample>[_sample(160, 3600)];

      final ReadingSpeed? speed = ReadingSpeedEstimate.fromSamples(samples);

      expect(speed!.wordsPerMinute, ReadingSpeed.slowest);
    });

    test('needs time as well as words', () {
      final List<SpeedSample> samples = <SpeedSample>[_sample(160, 20)];

      expect(ReadingSpeedEstimate.fromSamples(samples), isNull);
    });
  });
}
