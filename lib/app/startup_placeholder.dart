import 'package:flutter/material.dart';

import '../core/theme/app_spacing.dart';

/// Temporary landing surface for the app shell.
///
/// This is deliberately *not* the Welcome or Home screen from
/// PRODUCT_REPORT.md section 7. It exists only so the shell, themes and
/// system insets are exercised end to end, and it will be replaced by real
/// navigation once the data layer lands.
class StartupPlaceholder extends StatelessWidget {
  const StartupPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Knosis', style: theme.textTheme.displaySmall),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'From words to worlds.',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
