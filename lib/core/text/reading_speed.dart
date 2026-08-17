/// How fast a reader gets through text, in words per minute.
///
/// This is the unit passages are sized in: a passage is "about a minute of
/// your reading", not an arbitrary word count. Slower readers therefore get
/// shorter passages for the same sense of progress, which is the point.
///
/// The value is a plain number for now. Measuring it from real reading
/// sessions, and letting the reader adjust it in settings, comes with the
/// session tracking work; nothing here assumes it stays constant.
class ReadingSpeed {
  const ReadingSpeed(this.wordsPerMinute);

  /// Clamped to a sane range so a bad measurement or a stray setting cannot
  /// produce one-word or ten-thousand-word passages.
  factory ReadingSpeed.clamped(int wordsPerMinute) {
    if (wordsPerMinute < slowest) {
      return const ReadingSpeed(slowest);
    }
    if (wordsPerMinute > fastest) {
      return const ReadingSpeed(fastest);
    }
    return ReadingSpeed(wordsPerMinute);
  }

  static const int slowest = 40;
  static const int fastest = 600;

  /// Starting point for someone reading in a language they are learning.
  /// Deliberately below a native-language pace.
  static const ReadingSpeed comfortable = ReadingSpeed(150);

  final int wordsPerMinute;

  /// How long [words] should take at this speed.
  Duration timeFor(int words) {
    final int seconds = (words * 60 / wordsPerMinute).round();
    return Duration(seconds: seconds);
  }

  /// How many words fit in [duration] at this speed.
  int wordsIn(Duration duration) {
    return (wordsPerMinute * duration.inSeconds / 60).round();
  }
}
