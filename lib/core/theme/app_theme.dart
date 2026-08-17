import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';
import 'reading_theme.dart';

/// Builds the app themes from the design tokens.
///
/// Feature code never constructs a [ThemeData] and never hard-codes a color:
/// it reads `Theme.of(context)` or the [ReadingTheme] extension.
abstract final class AppTheme {
  static ThemeData light() {
    return _build(_lightScheme, ReadingTheme.light, AppColors.lightMuted);
  }

  static ThemeData dark() {
    return _build(_darkScheme, ReadingTheme.dark, AppColors.darkMuted);
  }

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryTeal,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.gold,
    onSecondary: AppColors.deepNavy,
    error: AppColors.error,
    onError: AppColors.onError,
    surface: AppColors.lightPaper,
    onSurface: AppColors.lightInk,
    outline: AppColors.lightBorder,
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkTeal,
    onPrimary: AppColors.deepNavy,
    secondary: AppColors.darkGold,
    onSecondary: AppColors.deepNavy,
    error: AppColors.error,
    onError: AppColors.onError,
    surface: AppColors.darkBackground,
    onSurface: AppColors.darkInk,
    outline: AppColors.darkBorder,
    surfaceContainerHighest: AppColors.darkSurface,
  );

  static ThemeData _build(
    ColorScheme scheme,
    ReadingTheme reading,
    Color muted,
  ) {
    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: AppTypography.uiTextTheme(scheme.onSurface, muted),
      extensions: <ThemeExtension<dynamic>>[reading],
    );
  }
}
