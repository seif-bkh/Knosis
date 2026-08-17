import 'package:flutter/material.dart';

/// Motion tokens.
///
/// Animation stays subtle, short, purposeful and interruptible
/// (AGENTS.md section 18). Nothing decorative may delay reading or
/// navigation, so these durations are intentionally small.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration medium = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 320);

  static const Curve standard = Curves.easeOutCubic;

  /// Returns [duration], or [Duration.zero] when the user has asked the
  /// system to reduce motion.
  ///
  /// Accessibility settings win over visual polish: an animation the user
  /// disabled must not merely be shorter, it must not run at all.
  static Duration respectingReducedMotion(
    BuildContext context,
    Duration duration,
  ) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return Duration.zero;
    }
    return duration;
  }
}
