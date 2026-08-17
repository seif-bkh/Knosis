import 'chunk_boundary.dart';
import 'chunk_size_policy.dart';

/// Splits plain text into reading chunks (PRODUCT_REPORT.md section 8.3).
///
/// Rules honoured, in priority order:
///
/// 1. never cut in the middle of a sentence;
/// 2. prefer cutting at a paragraph break;
/// 3. aim for the level's word range;
/// 4. never build an unbounded chunk, whatever the file contains.
///
/// Rule 1 wins over rule 3: a chunk may overshoot [ChunkSizePolicy.maxWords]
/// rather than split a sentence. Only [ChunkSizePolicy.hardMaxWords] can
/// force a cut at a word boundary, which protects the app from a "book" that
/// is one endless line without punctuation.
///
/// The chunker never copies the text: it walks the string once, in O(n), and
/// emits offsets lazily so a huge book can be processed without holding a
/// second copy in memory (AGENTS.md section 10).
///
/// Known limitation: sentence detection is punctuation based, so an
/// abbreviation such as "Mr. Smith" ends a sentence early. That produces a
/// slightly short chunk, never a mid-word cut. Languages without spaces
/// between words (for example Chinese) are word-counted as very long
/// sentences and rely on [ChunkSizePolicy.hardMaxWords]; proper support is a
/// later task.
class TextChunker {
  const TextChunker(this.policy);

  final ChunkSizePolicy policy;

  /// Chunk boundaries for [text], produced lazily.
  Iterable<ChunkBoundary> split(String text) sync* {
    int index = 0;
    int start = -1;
    int end = -1;
    int words = 0;

    for (final _Sentence sentence in _scan(text)) {
      final bool overflows = words + sentence.words > policy.maxWords;
      if (start >= 0 && overflows && words >= policy.minWords) {
        yield ChunkBoundary(
          index: index,
          start: start,
          end: end,
          wordCount: words,
        );
        index++;
        start = -1;
        words = 0;
      }

      if (start < 0) {
        start = sentence.start;
      }
      end = sentence.end;
      words += sentence.words;

      final bool atParagraphEnd = sentence.endsParagraph;
      final bool longEnough = words >= policy.minWords;
      if ((atParagraphEnd && longEnough) || words >= policy.hardMaxWords) {
        yield ChunkBoundary(
          index: index,
          start: start,
          end: end,
          wordCount: words,
        );
        index++;
        start = -1;
        words = 0;
      }
    }

    if (start >= 0) {
      yield ChunkBoundary(
        index: index,
        start: start,
        end: end,
        wordCount: words,
      );
    }
  }

  /// Convenience wrapper around [split] for callers that want a list.
  List<ChunkBoundary> chunk(String text) => split(text).toList();

  /// Walks [text] once and emits sentences with their word counts.
  ///
  /// A sentence also ends at a paragraph break, and is cut at a word
  /// boundary if it grows past [ChunkSizePolicy.hardMaxWords].
  Iterable<_Sentence> _scan(String text) sync* {
    final int length = text.length;
    int i = 0;
    int start = -1;
    int end = -1;
    int words = 0;
    bool inWord = false;

    // A finished sentence is held back for one step: whether it ends a
    // paragraph is only known once the following whitespace is seen.
    _Sentence? pending;

    while (i < length) {
      final int code = text.codeUnitAt(i);

      if (_isWhitespace(code)) {
        if (inWord) {
          words++;
          inWord = false;
        }

        // Consume the whole whitespace run at once, counting newlines: two
        // newlines mean a paragraph break.
        int j = i;
        int newlines = 0;
        while (j < length && _isWhitespace(text.codeUnitAt(j))) {
          final int run = text.codeUnitAt(j);
          if (run == 0x0A || run == 0x2029) {
            newlines++;
          }
          j++;
        }

        if (start >= 0 && (newlines >= 2 || words >= policy.hardMaxWords)) {
          yield _Sentence(start, end + 1, words, newlines >= 2);
          start = -1;
          end = -1;
          words = 0;
        } else if (newlines >= 2 && pending != null) {
          yield _Sentence(pending.start, pending.end, pending.words, true);
          pending = null;
        }

        i = j;
        continue;
      }

      if (start < 0) {
        start = i;
        if (pending != null) {
          yield pending;
          pending = null;
        }
      }
      inWord = true;
      end = i;

      if (_isTerminator(code)) {
        // Absorb "?!", "..." and any closing quote or bracket that belongs
        // to the same sentence.
        int j = i + 1;
        while (j < length && _isTrailingPunctuation(text.codeUnitAt(j))) {
          end = j;
          j++;
        }

        // A terminator only ends a sentence when whitespace or the end of
        // the text follows it, so "3.14" stays one word.
        if (j >= length || _isWhitespace(text.codeUnitAt(j))) {
          words++;
          inWord = false;
          pending = _Sentence(start, end + 1, words, false);
          start = -1;
          end = -1;
          words = 0;
        }

        i = j;
        continue;
      }

      i++;
    }

    if (inWord) {
      words++;
    }
    if (pending != null) {
      yield pending;
    }
    if (start >= 0) {
      yield _Sentence(start, end + 1, words, true);
    }
  }

  static bool _isWhitespace(int code) {
    return code == 0x20 ||
        code == 0x09 ||
        code == 0x0A ||
        code == 0x0B ||
        code == 0x0C ||
        code == 0x0D ||
        code == 0xA0 ||
        code == 0x2028 ||
        code == 0x2029 ||
        code == 0x3000 ||
        (code >= 0x2000 && code <= 0x200A);
  }

  static bool _isTerminator(int code) {
    return code == 0x2E || // .
        code == 0x21 || // !
        code == 0x3F || // ?
        code == 0x2026 || // …
        code == 0x061F || // ؟
        code == 0x3002 || // 。
        code == 0xFF01 || // ！
        code == 0xFF1F; // ？
  }

  static bool _isTrailingPunctuation(int code) {
    if (_isTerminator(code)) {
      return true;
    }
    return code == 0x22 || // "
        code == 0x27 || // '
        code == 0x29 || // )
        code == 0x5D || // ]
        code == 0x201D || // ”
        code == 0x2019 || // ’
        code == 0xBB; // »
  }
}

/// One sentence found by the scanner. [end] is exclusive.
class _Sentence {
  const _Sentence(this.start, this.end, this.words, this.endsParagraph);

  final int start;
  final int end;
  final int words;
  final bool endsParagraph;
}
