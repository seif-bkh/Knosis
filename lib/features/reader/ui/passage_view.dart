import 'package:flutter/material.dart';

import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/reading_theme.dart';

/// How tall the softening at each edge of the passage is.
const double _fadeHeight = 72;

/// Less hidden content than this and a fade would be noise.
const double _fadeThreshold = 8;

/// A passage: scrollable text that dissolves at its edges.
///
/// The bottom fade is the point of this screen. Text that stops at a hard
/// edge reads as finished; text that dissolves reads as continuing, so the
/// reader keeps going on their own. No popup, no countdown, no nudge
/// (AGENTS.md section 9).
///
/// The fade is a gradient painted over the text, not a ShaderMask. A shader
/// would force a saveLayer over the whole scrolling viewport on every frame,
/// which is the one cost long-form reading cannot afford.
class PassageView extends StatefulWidget {
  const PassageView({required this.text, required this.footer, super.key});

  final String text;

  /// What follows the text: the way onward, or the end of the document.
  final Widget footer;

  @override
  State<PassageView> createState() => _PassageViewState();
}

class _PassageViewState extends State<PassageView> {
  final ScrollController _controller = ScrollController();

  bool _fadeTop = false;
  bool _fadeBottom = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_syncFades);
  }

  @override
  void didUpdateWidget(PassageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      if (_controller.hasClients) {
        _controller.jumpTo(0);
      }
      WidgetsBinding.instance.addPostFrameCallback(_syncFades);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncFades([Duration? _]) {
    if (!mounted || !_controller.hasClients) {
      return;
    }
    _applyMetrics(_controller.position);
  }

  bool _onScroll(ScrollNotification notification) {
    _applyMetrics(notification.metrics);
    return false;
  }

  /// Only rebuilds when a fade actually appears or disappears, so scrolling
  /// does not rebuild this subtree on every frame.
  void _applyMetrics(ScrollMetrics metrics) {
    final bool top = metrics.extentBefore > _fadeThreshold;
    final bool bottom = metrics.extentAfter > _fadeThreshold;
    if (top == _fadeTop && bottom == _fadeBottom) {
      return;
    }
    setState(() {
      _fadeTop = top;
      _fadeBottom = bottom;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ReadingTheme reading =
        Theme.of(context).extension<ReadingTheme>() ?? ReadingTheme.light;
    final TextStyle readingStyle = AppTypography.reading(reading.ink);

    return Stack(
      children: <Widget>[
        NotificationListener<ScrollNotification>(
          onNotification: _onScroll,
          child: SelectionArea(
            child: SingleChildScrollView(
              controller: _controller,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.text, style: readingStyle),
                  const SizedBox(height: AppSpacing.xxl),
                  widget.footer,
                ],
              ),
            ),
          ),
        ),
        _EdgeFade(
          key: const Key('reader.fade.top'),
          color: reading.surface,
          visible: _fadeTop,
          alignToTop: true,
        ),
        _EdgeFade(
          key: const Key('reader.fade.bottom'),
          color: reading.surface,
          visible: _fadeBottom,
          alignToTop: false,
        ),
      ],
    );
  }
}

class _EdgeFade extends StatelessWidget {
  const _EdgeFade({
    required this.color,
    required this.visible,
    required this.alignToTop,
    super.key,
  });

  final Color color;
  final bool visible;
  final bool alignToTop;

  @override
  Widget build(BuildContext context) {
    final Duration duration = AppMotion.respectingReducedMotion(
      context,
      AppMotion.medium,
    );

    return Positioned(
      top: alignToTop ? 0 : null,
      bottom: alignToTop ? null : 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: duration,
          curve: AppMotion.standard,
          child: Container(
            height: _fadeHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: alignToTop
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
                end: alignToTop
                    ? Alignment.bottomCenter
                    : Alignment.topCenter,
                colors: <Color>[color, color.withValues(alpha: 0)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
