import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/knosis_database.dart';
import '../../../core/text/chunk_size_policy.dart';
import '../../../core/text/reading_speed.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/reading_theme.dart';
import '../../../shared/strings/app_strings.dart';
import '../data/reader_repository.dart';
import '../domain/chunk_summary.dart';
import '../domain/passage_plan.dart';
import '../state/reading_speed_provider.dart';
import 'passage_view.dart';

/// The reading surface.
///
/// Deliberately quiet: a way back, the title, a hairline of progress, and
/// the text. It opens where the reader left off and records where they stop,
/// so closing the app mid-passage costs nothing.
class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({required this.bookId, super.key});

  final String bookId;

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  PassagePlan? _plan;
  String _title = '';
  String _text = '';
  int _index = 0;
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _open();
  }

  Future<void> _open() async {
    final ReaderRepository repository = ref.read(readerRepositoryProvider);
    final ReadingSpeed speed = ref.read(readingSpeedProvider);

    try {
      final BookRow? book = await repository.book(widget.bookId);
      final List<ChunkSummary> chunks = await repository.chunkIndex(
        widget.bookId,
      );
      if (book == null || chunks.isEmpty) {
        _giveUp();
        return;
      }

      final PassagePlan plan = PassagePlan.from(
        chunks,
        ChunkSizePolicy.forReadingSpeed(speed),
      );
      // Where the reader stopped last time, or the beginning.
      final int index = plan.indexForChunk(book.currentChunkId);
      final String text = await _textFor(repository, plan.at(index));
      if (!mounted) {
        return;
      }

      setState(() {
        _plan = plan;
        _title = book.title;
        _index = index;
        _text = text;
        _loading = false;
      });
      await _remember(repository, plan.at(index));
    } catch (_) {
      _giveUp();
    }
  }

  void _giveUp() {
    if (!mounted) {
      return;
    }
    setState(() {
      _loading = false;
      _failed = true;
    });
  }

  Future<String> _textFor(ReaderRepository repository, PassageSlice slice) {
    return repository.passageText(
      widget.bookId,
      slice.firstOrder,
      slice.lastOrder,
    );
  }

  Future<void> _remember(ReaderRepository repository, PassageSlice slice) {
    return repository.savePosition(
      bookId: widget.bookId,
      chapterId: slice.firstChapterId,
      chunkId: slice.firstChunkId,
    );
  }

  Future<void> _advance() async {
    final PassagePlan? plan = _plan;
    if (plan == null || _index >= plan.length - 1) {
      return;
    }
    final ReaderRepository repository = ref.read(readerRepositoryProvider);
    final PassageSlice next = plan.at(_index + 1);
    final String text = await _textFor(repository, next);
    if (!mounted) {
      return;
    }

    setState(() {
      _index = next.index;
      _text = text;
    });
    await _remember(repository, next);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ReadingTheme reading =
        theme.extension<ReadingTheme>() ?? ReadingTheme.light;
    final PassagePlan? plan = _plan;

    return Scaffold(
      backgroundColor: reading.surface,
      appBar: AppBar(
        backgroundColor: reading.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(_title, style: theme.textTheme.titleMedium),
        bottom: _ProgressHairline(
          fraction: plan == null ? 0 : plan.progressAfter(_index),
          color: theme.colorScheme.primary,
        ),
      ),
      body: SafeArea(top: false, child: _body(plan)),
    );
  }

  Widget _body(PassagePlan? plan) {
    if (_loading) {
      // Nothing rather than a spinner: reading a passage from SQLite takes
      // milliseconds, and a flash of chrome is worse than a blank moment.
      return const SizedBox.shrink();
    }
    if (_failed || plan == null || plan.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(child: Text(AppStrings.readerEmpty)),
      );
    }

    int? nextWords;
    if (_index < plan.length - 1) {
      nextWords = plan.at(_index + 1).wordCount;
    }

    return PassageView(
      key: ValueKey<int>(_index),
      text: _text,
      footer: _Footer(
        position: _index + 1,
        total: plan.length,
        nextWords: nextWords,
        speed: ref.watch(readingSpeedProvider),
        onContinue: _advance,
      ),
    );
  }
}

/// Two pixels of progress. Enough to orient, too little to nag.
class _ProgressHairline extends StatelessWidget implements PreferredSizeWidget {
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
class _Footer extends StatelessWidget {
  const _Footer({
    required this.position,
    required this.total,
    required this.speed,
    required this.onContinue,
    this.nextWords,
  });

  final int position;
  final int total;
  final ReadingSpeed speed;
  final VoidCallback onContinue;

  /// Length of the next passage, or null at the end of the text.
  final int? nextWords;

  @override
  Widget build(BuildContext context) {
    final TextStyle? muted = Theme.of(context).textTheme.bodyMedium;
    final String where = AppStrings.passageProgress(position, total);
    final int? words = nextWords;

    if (words == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(where, style: muted),
          const SizedBox(height: AppSpacing.sm),
          Text(AppStrings.readerEndOfText, style: muted),
        ],
      );
    }

    final int minutes = _minutesOf(speed.timeFor(words));
    final String estimate = AppStrings.aboutMinutes(minutes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('$where  ·  $estimate', style: muted),
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
