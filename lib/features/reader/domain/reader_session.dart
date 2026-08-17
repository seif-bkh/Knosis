import '../../../core/text/reading_speed.dart';
import 'reader_document.dart';

/// Where the reader currently is in a document.
///
/// Advancing lives here rather than in the widget so it can be tested
/// without pumping a frame. The position is in-memory only for now;
/// persisting it to the book row is part of the import and session work.
class ReaderSession {
  ReaderSession({required this.document, required this.speed});

  final ReaderDocument document;
  final ReadingSpeed speed;

  int _index = 0;

  int get index => _index;

  /// 1-based position, for display.
  int get displayIndex => _index + 1;

  bool get isLast => _index >= document.passageCount - 1;

  Passage get current => document.passages[_index];

  /// Fraction of the document read once the current passage is done.
  double get progress {
    if (document.isEmpty) {
      return 0;
    }
    return displayIndex / document.passageCount;
  }

  /// How long the next passage should take at this reader's pace.
  Duration? get nextPassageDuration {
    if (isLast) {
      return null;
    }
    return speed.timeFor(document.passages[_index + 1].wordCount);
  }

  void advance() {
    if (!isLast) {
      _index++;
    }
  }
}
