import 'package:flutter/material.dart';

/// Raw brand palette, taken verbatim from PRODUCT_REPORT.md section 10.
///
/// These constants are the only place a hard-coded color may appear.
/// Widgets must read semantic colors from `Theme.of(context)` (or the
/// [ReadingTheme] extension) so that light, dark and sepia surfaces stay
/// consistent without touching feature code.
abstract final class AppColors {
  // Light theme.
  static const Color lightPaper = Color(0xFFFAF7F0);
  static const Color lightInk = Color(0xFF18202F);
  static const Color lightMuted = Color(0xFF6D7280);
  static const Color lightBorder = Color(0xFFE7DED1);
  static const Color primaryTeal = Color(0xFF2F8C87);
  static const Color deepNavy = Color(0xFF14213D);
  static const Color gold = Color(0xFFD6A94A);

  // Dark theme.
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF172033);
  static const Color darkInk = Color(0xFFE5E7EB);
  static const Color darkMuted = Color(0xFF9CA3AF);
  static const Color darkTeal = Color(0xFF4DB6AC);
  static const Color darkGold = Color(0xFFE0B85A);
  static const Color darkBorder = Color(0xFF2A3547);

  // Sepia reading surface.
  static const Color sepiaBackground = Color(0xFFF4ECD8);
  static const Color sepiaInk = Color(0xFF2D2417);
  static const Color sepiaMuted = Color(0xFF6B5D45);
  static const Color highlight = Color(0xFFFFE08A);

  // Feedback. Not in the report; kept here so no widget invents its own.
  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
}
