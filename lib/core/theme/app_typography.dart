import 'package:flutter/material.dart';

/// Type scale for Knosis (PRODUCT_REPORT.md section 11).
///
/// No font assets are bundled yet, so the Android system family is used and
/// the app inherits the user's font settings. Bundling Inter (UI) and
/// Literata (reading) is a later task that requires shipping the files with
/// the APK: the `google_fonts` package is deliberately avoided because it
/// downloads fonts over the network at runtime, which would break the
/// offline-first rule (AGENTS.md section 11).
///
/// Sizes are logical pixels and are multiplied by the platform text scale,
/// so no layout here may assume a fixed text height.
abstract final class AppTypography {
  /// Comfortable default line height for long-form reading.
  static const double readingLineHeight = 1.6;

  /// Default body size for the reader, before user preferences apply.
  static const double readingFontSize = 18;

  static TextTheme uiTextTheme(Color ink, Color muted) {
    return TextTheme(
      displaySmall: TextStyle(
        fontSize: 34,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: ink,
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: ink,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: muted,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
    );
  }

  /// Base style for book text. The reader owns size and spacing overrides;
  /// this is only the starting point.
  static TextStyle reading(Color ink) {
    return TextStyle(
      fontSize: readingFontSize,
      height: readingLineHeight,
      fontWeight: FontWeight.w400,
      color: ink,
    );
  }
}
