import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/text/chunk_size_policy.dart';
import 'package:knosis/core/text/reading_speed.dart';
import 'package:knosis/core/theme/app_theme.dart';
import 'package:knosis/features/reader/domain/reader_document.dart';
import 'package:knosis/features/reader/domain/reader_session.dart';
import 'package:knosis/features/reader/ui/reader_screen.dart';
import 'package:knosis/shared/strings/app_strings.dart';

/// Paragraphs of a known length, each tagged so a test can tell which
/// passage is on screen.
String _markedText(int paragraphs) {
  final List<String> parts = <String>[];
  for (int i = 1; i <= paragraphs; i++) {
    parts.add('Marker$i ${List<String>.filled(24, 'word').join(' ')}.');
  }
  return parts.join('\n\n');
}

ReaderSession _session({
  int paragraphs = 6,
  int minWords = 20,
  int maxWords = 30,
}) {
  final ReaderDocument document = ReaderDocument.fromText(
    title: 'Test Book',
    text: _markedText(paragraphs),
    policy: ChunkSizePolicy(minWords: minWords, maxWords: maxWords),
  );
  return ReaderSession(document: document, speed: ReadingSpeed.comfortable);
}

Widget _app(ReaderSession session) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: ReaderScreen(session: session),
  );
}

double _fadeOpacity(WidgetTester tester, String key) {
  final Finder finder = find.descendant(
    of: find.byKey(Key(key)),
    matching: find.byType(AnimatedOpacity),
  );
  return tester.widget<AnimatedOpacity>(finder).opacity;
}

Future<void> _tapContinue(WidgetTester tester) async {
  final Finder button = find.text(AppStrings.readerContinue);
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows one passage at a time', (tester) async {
    await tester.pumpWidget(_app(_session()));
    await tester.pumpAndSettle();

    expect(find.textContaining('Marker1'), findsOneWidget);
    expect(find.textContaining('Marker2'), findsNothing);
  });

  testWidgets('continuing moves to the next passage', (tester) async {
    await tester.pumpWidget(_app(_session()));
    await tester.pumpAndSettle();

    await _tapContinue(tester);

    expect(find.textContaining('Marker2'), findsOneWidget);
    expect(find.textContaining('Marker1'), findsNothing);
  });

  testWidgets('the end of the text offers no continue', (tester) async {
    final ReaderSession session = _session(paragraphs: 3);
    await tester.pumpWidget(_app(session));
    await tester.pumpAndSettle();

    await _tapContinue(tester);
    await _tapContinue(tester);

    expect(session.isLast, isTrue);
    expect(find.text(AppStrings.readerEndOfText), findsOneWidget);
    expect(find.text(AppStrings.readerContinue), findsNothing);
  });

  testWidgets('fades the bottom edge while text continues below', (
    tester,
  ) async {
    final ReaderSession session = _session(
      paragraphs: 20,
      minWords: 400,
      maxWords: 800,
    );
    await tester.pumpWidget(_app(session));
    await tester.pumpAndSettle();

    expect(_fadeOpacity(tester, 'reader.fade.bottom'), 1);
    expect(_fadeOpacity(tester, 'reader.fade.top'), 0);
  });

  testWidgets('no fade when the passage fits on screen', (tester) async {
    await tester.pumpWidget(_app(_session(paragraphs: 1, minWords: 5)));
    await tester.pumpAndSettle();

    expect(_fadeOpacity(tester, 'reader.fade.bottom'), 0);
    expect(_fadeOpacity(tester, 'reader.fade.top'), 0);
  });

  testWidgets('the passage text stays selectable', (tester) async {
    await tester.pumpWidget(_app(_session()));
    await tester.pumpAndSettle();

    expect(find.byType(SelectionArea), findsOneWidget);
  });

  testWidgets('shows where the reader is and what is next', (tester) async {
    await tester.pumpWidget(_app(_session()));
    await tester.pumpAndSettle();

    expect(
      find.textContaining(AppStrings.passageProgress(1, 6)),
      findsOneWidget,
    );
    expect(find.textContaining('about a minute'), findsOneWidget);
  });
}
