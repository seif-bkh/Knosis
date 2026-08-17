import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/theme/app_colors.dart';
import 'package:knosis/core/theme/app_motion.dart';
import 'package:knosis/core/theme/app_theme.dart';
import 'package:knosis/core/theme/reading_theme.dart';

void main() {
  group('AppTheme', () {
    test('light theme uses the paper palette from the spec', () {
      final ThemeData theme = AppTheme.light();

      expect(theme.colorScheme.brightness, Brightness.light);
      expect(theme.colorScheme.surface, AppColors.lightPaper);
      expect(theme.colorScheme.onSurface, AppColors.lightInk);
      expect(theme.colorScheme.primary, AppColors.primaryTeal);
      expect(theme.scaffoldBackgroundColor, AppColors.lightPaper);
    });

    test('dark theme uses the night palette from the spec', () {
      final ThemeData theme = AppTheme.dark();

      expect(theme.colorScheme.brightness, Brightness.dark);
      expect(theme.colorScheme.surface, AppColors.darkBackground);
      expect(theme.colorScheme.onSurface, AppColors.darkInk);
      expect(theme.colorScheme.primary, AppColors.darkTeal);
      expect(theme.scaffoldBackgroundColor, AppColors.darkBackground);
    });

    test('both themes carry reading tokens', () {
      final List<ThemeData> themes = <ThemeData>[
        AppTheme.light(),
        AppTheme.dark(),
      ];

      for (final ThemeData theme in themes) {
        expect(theme.extension<ReadingTheme>(), isNotNull);
      }
    });

    test('body text stays comfortably readable', () {
      final TextTheme text = AppTheme.light().textTheme;

      expect(text.bodyLarge?.fontSize, greaterThanOrEqualTo(16));
      expect(text.bodyLarge?.height, greaterThanOrEqualTo(1.4));
    });
  });

  group('ReadingTheme', () {
    test('sepia matches the reading palette in the spec', () {
      expect(ReadingTheme.sepia.surface, AppColors.sepiaBackground);
      expect(ReadingTheme.sepia.ink, AppColors.sepiaInk);
      expect(ReadingTheme.sepia.highlight, AppColors.highlight);
    });

    test('copyWith replaces only the token it is given', () {
      final ReadingTheme changed = ReadingTheme.light.copyWith(
        highlight: AppColors.gold,
      );

      expect(changed.highlight, AppColors.gold);
      expect(changed.surface, ReadingTheme.light.surface);
      expect(changed.ink, ReadingTheme.light.ink);
    });

    test('lerp returns itself when there is nothing to blend into', () {
      expect(ReadingTheme.light.lerp(null, 0.5), same(ReadingTheme.light));
    });

    test('lerp reaches the other theme at t = 1', () {
      const ReadingTheme target = ReadingTheme.dark;

      final ReadingTheme blended = ReadingTheme.light.lerp(target, 1);

      expect(blended.surface, target.surface);
      expect(blended.ink, target.ink);
    });
  });

  group('AppMotion', () {
    testWidgets('reduced motion collapses a duration to zero', (tester) async {
      late Duration reduced;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (BuildContext context) {
              reduced = AppMotion.respectingReducedMotion(
                context,
                AppMotion.medium,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(reduced, Duration.zero);
    });

    testWidgets('normal motion keeps the requested duration', (tester) async {
      late Duration kept;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: Builder(
            builder: (BuildContext context) {
              kept = AppMotion.respectingReducedMotion(
                context,
                AppMotion.medium,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(kept, AppMotion.medium);
    });
  });
}
