import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/text/chunk_size_policy.dart';
import 'package:knosis/core/text/reading_speed.dart';
import 'package:knosis/features/reader/data/sample_book.dart';
import 'package:knosis/features/reader/domain/reader_document.dart';
import 'package:knosis/features/reader/domain/reader_session.dart';

ReaderDocument _sampleDocument(ReadingSpeed speed) {
  return ReaderDocument.fromText(
    title: SampleBook.title,
    text: SampleBook.text,
    policy: ChunkSizePolicy.forReadingSpeed(speed),
  );
}

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

  group('ReaderDocument', () {
    test('splits the sample into several passages', () {
      final ReaderDocument doc = _sampleDocument(ReadingSpeed.comfortable);

      expect(doc.passageCount, greaterThan(1));
      expect(doc.isEmpty, isFalse);
    });

    test('every passage ends on a finished sentence', () {
      final ReaderDocument doc = _sampleDocument(ReadingSpeed.comfortable);

      for (final Passage passage in doc.passages) {
        expect(passage.text.trim(), endsWith('.'));
      }
    });

    test('a slower reader gets more, shorter passages', () {
      final ReaderDocument slow = _sampleDocument(const ReadingSpeed(60));
      final ReaderDocument fast = _sampleDocument(const ReadingSpeed(300));

      expect(slow.passageCount, greaterThan(fast.passageCount));
    });

    test('keeps the whole text, in order, with nothing lost', () {
      final ReaderDocument doc = _sampleDocument(ReadingSpeed.comfortable);
      final StringBuffer buffer = StringBuffer();
      for (final Passage passage in doc.passages) {
        buffer.write(passage.text);
        buffer.write(' ');
      }

      final String joined = _words(buffer.toString());

      expect(joined, _words(SampleBook.text));
    });
  });

  group('ReaderSession', () {
    test('starts at the first passage', () {
      final ReaderSession session = _session();

      expect(session.index, 0);
      expect(session.displayIndex, 1);
      expect(session.isLast, isFalse);
    });

    test('advances and stops at the end', () {
      final ReaderSession session = _session();
      final int count = session.document.passageCount;

      for (int i = 0; i < count + 5; i++) {
        session.advance();
      }

      expect(session.index, count - 1);
      expect(session.isLast, isTrue);
      expect(session.nextPassageDuration, isNull);
    });

    test('estimates the next passage from the reader speed', () {
      final ReaderSession session = _session();

      final Duration? next = session.nextPassageDuration;

      expect(next, isNotNull);
      expect(next!.inSeconds, greaterThan(0));
    });

    test('progress grows towards one', () {
      final ReaderSession session = _session();
      final double first = session.progress;

      session.advance();

      expect(session.progress, greaterThan(first));
      expect(session.progress, lessThanOrEqualTo(1));
    });
  });
}

ReaderSession _session() {
  const ReadingSpeed speed = ReadingSpeed.comfortable;
  return ReaderSession(document: _sampleDocument(speed), speed: speed);
}

String _words(String text) {
  final List<String> parts = text.split(RegExp(r'\s+'));
  parts.removeWhere((String word) => word.isEmpty);
  return parts.join(' ');
}
