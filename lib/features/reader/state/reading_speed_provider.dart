import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/text/reading_speed.dart';

ReadingSpeed _defaultSpeed(Ref ref) => ReadingSpeed.comfortable;

/// The reader's pace, which decides how long a passage is.
///
/// A fixed comfortable default for now. Two things will replace it: a
/// setting, and a measurement taken from real reading sessions. Because
/// passages are composed at read time, either can change without touching
/// stored data.
final Provider<ReadingSpeed> readingSpeedProvider = Provider<ReadingSpeed>(
  _defaultSpeed,
);
