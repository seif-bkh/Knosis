import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Colors that belong to the reading surface itself.
///
/// The reader is the most important screen (AGENTS.md section 9), and its
/// surface is not always the app surface: sepia is a reading theme, not an
/// app theme. Exposing these as a [ThemeExtension] means switching light /
/// dark / sepia never requires touching reader widgets.
@immutable
class ReadingTheme extends ThemeExtension<ReadingTheme> {
  const ReadingTheme({
    required this.surface,
    required this.ink,
    required this.muted,
    required this.highlight,
  });

  static const ReadingTheme light = ReadingTheme(
    surface: AppColors.lightPaper,
    ink: AppColors.lightInk,
    muted: AppColors.lightMuted,
    highlight: AppColors.highlight,
  );

  static const ReadingTheme dark = ReadingTheme(
    surface: AppColors.darkBackground,
    ink: AppColors.darkInk,
    muted: AppColors.darkMuted,
    highlight: AppColors.darkGold,
  );

  static const ReadingTheme sepia = ReadingTheme(
    surface: AppColors.sepiaBackground,
    ink: AppColors.sepiaInk,
    muted: AppColors.sepiaMuted,
    highlight: AppColors.highlight,
  );

  final Color surface;
  final Color ink;
  final Color muted;
  final Color highlight;

  @override
  ReadingTheme copyWith({
    Color? surface,
    Color? ink,
    Color? muted,
    Color? highlight,
  }) {
    return ReadingTheme(
      surface: surface ?? this.surface,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      highlight: highlight ?? this.highlight,
    );
  }

  @override
  ReadingTheme lerp(covariant ReadingTheme? other, double t) {
    if (other == null) {
      return this;
    }
    return ReadingTheme(
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      ink: Color.lerp(ink, other.ink, t) ?? ink,
      muted: Color.lerp(muted, other.muted, t) ?? muted,
      highlight: Color.lerp(highlight, other.highlight, t) ?? highlight,
    );
  }
}
