import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/text/reading_speed.dart';
import 'package:knosis/features/reader/domain/reading_speed_estimate.dart';

SpeedSample _sample(int words, int seconds) {
  return SpeedSample(
    words: words,
    time: Duration(seconds: seconds),
  );
}

int? _wpm(List<SpeedSample> samples) {
  return ReadingSpeedEstimate.fromSamples(samples)?.wordsPerMinute;
}

void main() {
  group('ReadingSpeedEstimate', () {
    test('has no opinion until there is enough evidence', () {
      final List<SpeedSample> none = <SpeedSample>[];
      final List<SpeedSample> thin = <SpeedSample>[];
      thin.add(_sample(100, 60));

      expect(_wpm(none), isNull);
      expect(_wpm(thin), isNull);
    });

    test('measures the obvious case', () {
      // 300 words in two minutes is 150 words per minute.
      final List<SpeedSample> samples = <SpeedSample>[];
      samples.add(_sample(150, 60));
      samples.add(_sample(150, 60));

      expect(_wpm(samples), 150);
    });

    test('a slow reader measures slow', () {
      final List<SpeedSample> samples = <SpeedSample>[];
      samples.add(_sample(80, 60));
      samples.add(_sample(80, 60));
      samples.add(_sample(80, 60));

      expect(_wpm(samples), 80);
    });

    test('ignores a glance too short to be reading', () {
      final List<SpeedSample> samples = <SpeedSample>[];
      samples.add(_sample(200, 100));
      samples.add(_sample(30, 2));

      expect(_wpm(samples), 120);
    });

    test('a skipped passage does not inflate the estimate', () {
      // 200 words in six seconds is skipping, not reading.
      final List<SpeedSample> read = <SpeedSample>[];
      read.add(_sample(200, 100));

      final List<SpeedSample> mixed = <SpeedSample>[];
      mixed.add(_sample(200, 100));
      mixed.add(_sample(200, 6));

      expect(_wpm(mixed), _wpm(read));
    });

    test('stays inside plausible human limits', () {
      final List<SpeedSample> samples = <SpeedSample>[];
      samples.add(_sample(160, 3600));

      expect(_wpm(samples), ReadingSpeed.slowest);
    });

    test('needs time as well as words', () {
      final List<SpeedSample> samples = <SpeedSample>[];
      samples.add(_sample(160, 20));

      expect(_wpm(samples), isNull);
    });
  });
}
