import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/reading_theme.dart';
import '../../../shared/strings/app_strings.dart';
import '../domain/reader_session.dart';
import 'passage_view.dart';

/// The reading surface.
///
/// Deliberately quiet: a way back, the title, a hairline of progress, and
/// the text. Everything a learner might want to do to a word happens on
/// request, never on the app's initiative (AGENTS.md section 9).
class ReaderScreen extends StatefulWidget {
  const ReaderScreen({required this.session, super.key});

  final ReaderSession session;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  void _advance() {
    setState(widget.session.advance);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ReadingTheme reading =
        theme.extension<ReadingTheme>() ?? ReadingTheme.light;
    final ReaderSession session = widget.session;
    final TextStyle? titleStyle = theme.textTheme.titleMedium;

    if (session.document.isEmpty) {
      return Scaffold(
        backgroundColor: reading.surface,
        appBar: AppBar(backgroundColor: reading.surface),
        body: Center(child: Text(AppStrings.readerEmpty)),
      );
    }

    return Scaffold(
      backgroundColor: reading.surface,
      appBar: AppBar(
        backgroundColor: reading.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(session.document.title, style: titleStyle),
        bottom: _ProgressHairline(
          fraction: session.progress,
          color: theme.colorScheme.primary,
        ),
      ),
      body: SafeArea(
        top: false,
        // A fresh state per passage: the next one always starts at its
        // first line rather than inheriting the previous scroll offset.
        child: PassageView(
          key: ValueKey<int>(session.index),
          text: session.current.text,
          footer: _PassageFooter(session: session, onContinue: _advance),
        ),
      ),
    );
  }
}

/// Two pixels of progress. Enough to orient, too little to nag.
class _ProgressHairline extends StatelessWidget
    implements PreferredSizeWidget {
  const _ProgressHairline({required this.fraction, required this.color});

  final double fraction;
  final Color color;

  @override
  Size get preferredSize => const Size.fromHeight(2);

  @override
  Widget build(BuildContext context) {
    double width = fraction;
    if (width < 0) {
      width = 0;
    }
    if (width > 1) {
      width = 1;
    }

    return SizedBox(
      height: 2,
      width: double.infinity,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: width,
        heightFactor: 1,
        child: ColoredBox(color: color),
      ),
    );
  }
}

/// What waits at the end of a passage: the way onward, or the end.
class _PassageFooter extends StatelessWidget {
  const _PassageFooter({required this.session, required this.onContinue});

  final ReaderSession session;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final TextStyle? muted = Theme.of(context).textTheme.bodyMedium;
    final String position = AppStrings.passageProgress(
      session.displayIndex,
      session.document.passageCount,
    );

    if (session.isLast) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(position, style: muted),
          const SizedBox(height: AppSpacing.sm),
          Text(AppStrings.readerEndOfText, style: muted),
        ],
      );
    }

    final Duration next = session.nextPassageDuration ?? Duration.zero;
    final String estimate = AppStrings.aboutMinutes(_minutesOf(next));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('$position  ·  $estimate', style: muted),
        const SizedBox(height: AppSpacing.md),
        FilledButton.tonal(
          onPressed: onContinue,
          child: const Text(AppStrings.readerContinue),
        ),
      ],
    );
  }
}

int _minutesOf(Duration duration) {
  final int minutes = (duration.inSeconds / 60).round();
  return minutes < 1 ? 1 : minutes;
}
