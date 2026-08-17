import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// TEMPORARY TOOL - delete once the layout question is answered.
//
// This workspace has no Dart SDK, so `dart format` cannot be run before
// pushing and a formatting mistake costs a whole CI cycle to discover.
// CI does have a Dart SDK, so this test formats the snippet below and
// prints the canonical result into the job log.

const String _subject = r'''
import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/text/reading_speed.dart';
import 'package:knosis/features/reader/domain/reading_speed_estimate.dart';

// Every statement here is deliberately short enough to fit on one line.
// This workspace has no Dart SDK, so `dart format` cannot be run before
// pushing; single-line statements leave the formatter nothing to decide.

SpeedSample _sample(int words, int seconds) {
  return SpeedSample(words: words, time: Duration(seconds: seconds));
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
''';

void main() {
  test('prints how dart format wants the subject laid out', () async {
    final Directory dir = await Directory.systemTemp.createTemp('fmt');
    final File file = File('${dir.path}/subject.dart');
    await file.writeAsString(_subject);

    final List<String> args = <String>['format', file.path];
    final ProcessResult result = await Process.run('dart', args);
    final String formatted = await file.readAsString();

    stdout.writeln('FORMAT_EXIT ${result.exitCode}');
    stdout.writeln('FORMAT_STDOUT ${result.stdout}');
    stdout.writeln('FORMAT_STDERR ${result.stderr}');
    stdout.writeln('=====FORMATTED_BEGIN=====');
    stdout.writeln(formatted);
    stdout.writeln('=====FORMATTED_END=====');

    await dir.delete(recursive: true);

    expect(result.exitCode, 0);
  });
}
