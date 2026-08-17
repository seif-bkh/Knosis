import 'package:flutter/material.dart';

import '../core/text/chunk_size_policy.dart';
import '../core/text/reading_speed.dart';
import '../core/theme/app_spacing.dart';
import '../features/reader/data/sample_book.dart';
import '../features/reader/domain/reader_document.dart';
import '../features/reader/domain/reader_session.dart';
import '../features/reader/ui/reader_screen.dart';
import '../shared/strings/app_strings.dart';

/// Temporary landing surface for the app shell.
///
/// This is deliberately *not* the Welcome or Home screen from
/// PRODUCT_REPORT.md section 7. It exists only so the shell, themes and
/// system insets are exercised end to end, and it will be replaced by real
/// navigation once the data layer lands.
class StartupPlaceholder extends StatelessWidget {
  const StartupPlaceholder({super.key});

  /// Opens the bundled sample text. The library will replace this once books
  /// can be imported; the reader itself does not care where a document came
  /// from.
  void _openReader(BuildContext context) {
    const ReadingSpeed speed = ReadingSpeed.comfortable;
    final ReaderDocument document = ReaderDocument.fromText(
      title: SampleBook.title,
      text: SampleBook.text,
      policy: ChunkSizePolicy.forReadingSpeed(speed),
    );
    final ReaderSession session = ReaderSession(
      document: document,
      speed: speed,
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ReaderScreen(session: session),
      ),
    );
  }

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
                Text(AppStrings.appName, style: theme.textTheme.displaySmall),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  AppStrings.tagline,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: () => _openReader(context),
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
