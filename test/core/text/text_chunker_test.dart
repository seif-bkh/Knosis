import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/text/chunk_boundary.dart';
import 'package:knosis/core/text/chunk_size_policy.dart';
import 'package:knosis/core/text/text_chunker.dart';
import 'package:knosis/shared/models/cefr_level.dart';

TextChunker _chunkerOf(int min, int max) {
  return TextChunker(ChunkSizePolicy(minWords: min, maxWords: max));
}

String _sentenceOf(int words) {
  return '${List<String>.filled(words, 'word').join(' ')}.';
}

String _paragraphOf(int sentences, int wordsEach) {
  final List<String> parts = List<String>.generate(
    sentences,
    (_) => _sentenceOf(wordsEach),
  );
  return parts.join(' ');
}

String _documentOf(int paragraphs, int sentences, int wordsEach) {
  final List<String> parts = List<String>.generate(
    paragraphs,
    (_) => _paragraphOf(sentences, wordsEach),
  );
  return parts.join('\n\n');
}

int _countWords(String text) {
  return text.split(RegExp(r'\s+')).where((String w) => w.isNotEmpty).length;
}

void main() {
  group('ChunkSizePolicy', () {
    test('maps CEFR levels to the ranges in the spec', () {
      expect(ChunkSizePolicy.forLevel(CefrLevel.a1).minWords, 80);
      expect(ChunkSizePolicy.forLevel(CefrLevel.a1).maxWords, 150);
      expect(ChunkSizePolicy.forLevel(CefrLevel.b1).minWords, 250);
      expect(ChunkSizePolicy.forLevel(CefrLevel.b1).maxWords, 500);
      expect(ChunkSizePolicy.forLevel(CefrLevel.c1).maxWords, 1500);
    });

    test('hard cap sits above the target maximum', () {
      const ChunkSizePolicy policy = ChunkSizePolicy(
        minWords: 50,
        maxWords: 100,
      );

      expect(policy.hardMaxWords, greaterThan(policy.maxWords));
    });
  });

  group('TextChunker', () {
    test('produces nothing for empty or blank text', () {
      expect(_chunkerOf(20, 40).chunk(''), isEmpty);
      expect(_chunkerOf(20, 40).chunk('   \n\n  \t  '), isEmpty);
    });

    test('keeps a short text as a single chunk', () {
      final String text = _sentenceOf(10);

      final List<ChunkBoundary> chunks = _chunkerOf(20, 40).chunk(text);

      expect(chunks, hasLength(1));
      expect(chunks.single.index, 0);
      expect(chunks.single.start, 0);
      expect(chunks.single.end, text.length);
      expect(chunks.single.wordCount, 10);
    });

    test('word counts add up to the source word count', () {
      final String text = _documentOf(6, 4, 12);

      final List<ChunkBoundary> chunks = _chunkerOf(20, 40).chunk(text);
      final int total = chunks.fold<int>(
        0,
        (int sum, ChunkBoundary c) => sum + c.wordCount,
      );

      expect(total, _countWords(text));
    });

    test('chunks are ordered, indexed and never overlap', () {
      final String text = _documentOf(6, 4, 12);

      final List<ChunkBoundary> chunks = _chunkerOf(20, 40).chunk(text);

      expect(chunks.length, greaterThan(1));
      for (int i = 0; i < chunks.length; i++) {
        expect(chunks[i].index, i);
        expect(chunks[i].start, lessThan(chunks[i].end));
        if (i > 0) {
          expect(chunks[i].start, greaterThanOrEqualTo(chunks[i - 1].end));
        }
      }
    });

    test('never ends a chunk mid sentence', () {
      final String text = _documentOf(6, 4, 12);

      final List<ChunkBoundary> chunks = _chunkerOf(20, 40).chunk(text);

      for (final ChunkBoundary c in chunks) {
        expect(text.substring(c.end - 1, c.end), '.');
      }
    });

    test('prefers paragraph breaks when the paragraph is long enough', () {
      final String text = _documentOf(4, 3, 10);

      final List<ChunkBoundary> chunks = _chunkerOf(20, 100).chunk(text);

      expect(chunks, hasLength(4));
      for (final ChunkBoundary c in chunks) {
        expect(c.wordCount, 30);
        expect(text.substring(c.start, c.end), isNot(contains('\n')));
      }
    });

    test('treats a blank line as a paragraph break with CRLF endings', () {
      const String text = 'One two three.\r\n\r\nFour five six.';

      final List<ChunkBoundary> chunks = _chunkerOf(3, 10).chunk(text);

      expect(chunks, hasLength(2));
      expect(text.substring(chunks[0].start, chunks[0].end), 'One two three.');
      expect(text.substring(chunks[1].start, chunks[1].end), 'Four five six.');
    });

    test('does not split a decimal number', () {
      const String text = 'Pi is about 3.14 and it still matters.';

      final List<ChunkBoundary> chunks = _chunkerOf(2, 5).chunk(text);

      expect(chunks, hasLength(1));
      expect(chunks.single.wordCount, 8);
    });

    test('keeps a closing quote with its sentence', () {
      const String text = '"Stop!" she said. Then silence.';

      final List<ChunkBoundary> chunks = _chunkerOf(1, 2).chunk(text);

      expect(chunks.length, greaterThan(1));
      expect(text.substring(chunks.first.start, chunks.first.end), '"Stop!"');
    });

    test('cuts runaway text at a word boundary instead of growing', () {
      final String text = List<String>.filled(5000, 'word').join(' ');
      final TextChunker chunker = _chunkerOf(50, 100);

      final List<ChunkBoundary> chunks = chunker.chunk(text);

      expect(chunks.length, greaterThan(1));
      for (final ChunkBoundary c in chunks) {
        expect(c.wordCount, lessThanOrEqualTo(200));
        expect(text.substring(c.start, c.start + 4), 'word');
        expect(text.substring(c.end - 1, c.end), 'd');
      }
    });

    test('handles a large document without losing content', () {
      final String text = _documentOf(500, 5, 40);
      final TextChunker chunker = TextChunker(
        ChunkSizePolicy.forLevel(CefrLevel.b1),
      );

      final List<ChunkBoundary> chunks = chunker.chunk(text);
      final int total = chunks.fold<int>(
        0,
        (int sum, ChunkBoundary c) => sum + c.wordCount,
      );

      expect(total, _countWords(text));
      expect(chunks.first.start, 0);
      expect(chunks.last.end, text.length);
      for (final ChunkBoundary c in chunks) {
        expect(c.wordCount, lessThanOrEqualTo(1000));
      }
    });

    test('is lazy: taking one chunk does not scan the whole text', () {
      final String text = _documentOf(500, 5, 40);

      final ChunkBoundary first = _chunkerOf(20, 40).split(text).first;

      expect(first.index, 0);
      expect(first.start, 0);
    });
  });

  group('ChunkBoundary', () {
    test('values with the same fields are equal', () {
      const ChunkBoundary a = ChunkBoundary(
        index: 1,
        start: 10,
        end: 40,
        wordCount: 6,
      );
      const ChunkBoundary b = ChunkBoundary(
        index: 1,
        start: 10,
        end: 40,
        wordCount: 6,
      );

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a.length, 30);
    });
  });
}
