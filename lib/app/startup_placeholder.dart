import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/database_provider.dart';
import '../core/database/knosis_database.dart';
import '../core/theme/app_spacing.dart';
import '../features/reader/data/sample_library.dart';
import '../features/reader/ui/reader_screen.dart';
import '../shared/strings/app_strings.dart';

/// Temporary landing surface for the app shell.
///
/// This is deliberately *not* the Welcome or Home screen from
/// PRODUCT_REPORT.md section 7. It exists only so the shell, themes and
/// system insets are exercised end to end, and it will be replaced by the
/// library once books can be imported.
class StartupPlaceholder extends ConsumerWidget {
  const StartupPlaceholder({super.key});

  /// Puts the sample book in the library, then opens it. Seeding is
  /// idempotent, so this is safe to tap twice.
  Future<void> _openReader(BuildContext context, WidgetRef ref) async {
    final KnosisDatabase database = ref.read(databaseProvider);
    await SampleLibrary.ensureSeeded(database);
    if (!context.mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            const ReaderScreen(bookId: SampleLibrary.bookId),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(AppStrings.appName, style: theme.textTheme.displaySmall),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  AppStrings.tagline,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: () => _openReader(context, ref),
                  child: const Text(AppStrings.readerStart),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
