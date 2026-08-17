import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/database/database_provider.dart';
import 'package:knosis/core/database/knosis_database.dart';
import 'package:knosis/core/theme/app_theme.dart';
import 'package:knosis/features/reader/data/reader_repository.dart';
import 'package:knosis/features/reader/data/sample_library.dart';
import 'package:knosis/features/reader/domain/chunk_summary.dart';
import 'package:knosis/features/reader/ui/reader_screen.dart';
import 'package:knosis/shared/strings/app_strings.dart';

Future<void> _pumpReader(
  WidgetTester tester,
  KnosisDatabase db, {
  String bookId = SampleLibrary.bookId,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[databaseProvider.overrideWithValue(db)],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: ReaderScreen(bookId: bookId),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tapContinue(WidgetTester tester) async {
  final Finder button = find.text(AppStrings.readerContinue);
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  late KnosisDatabase db;
  late ReaderRepository repository;

  setUp(() async {
    db = KnosisDatabase(NativeDatabase.memory());
    repository = ReaderRepository(db);
    await SampleLibrary.ensureSeeded(db);
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('opens the book at its first passage', (tester) async {
    await _pumpReader(tester, db);

    expect(find.textContaining('lighthouse'), findsOneWidget);
    expect(find.text(AppStrings.readerContinue), findsOneWidget);
  });

  testWidgets('remembers the position as soon as it opens', (tester) async {
    final BookRow? before = await repository.book(SampleLibrary.bookId);
    expect(before!.currentChunkId, isNull);

    await _pumpReader(tester, db);

    final BookRow? after = await repository.book(SampleLibrary.bookId);
    expect(after!.currentChunkId, isNotNull);
    expect(after.lastReadAt, isNotNull);
  });

  testWidgets('continuing moves on and records the new place', (tester) async {
    await _pumpReader(tester, db);
    final BookRow? opened = await repository.book(SampleLibrary.bookId);

    await _tapContinue(tester);

    final BookRow? moved = await repository.book(SampleLibrary.bookId);
    expect(moved!.currentChunkId, isNot(opened!.currentChunkId));
  });

  testWidgets('reopening resumes where the reader stopped', (tester) async {
    final List<ChunkSummary> chunks = await repository.chunkIndex(
      SampleLibrary.bookId,
    );
    await repository.savePosition(
      bookId: SampleLibrary.bookId,
      chapterId: chunks.last.chapterId,
      chunkId: chunks.last.id,
    );

    await _pumpReader(tester, db);

    // The saved chunk is the very last one, so the reader lands on the
    // final passage: no way onward, and the closing note instead.
    expect(find.text(AppStrings.readerEndOfText), findsOneWidget);
    expect(find.text(AppStrings.readerContinue), findsNothing);
  });

  testWidgets('says so plainly when there is nothing to read', (tester) async {
    await _pumpReader(tester, db, bookId: 'a-book-that-is-not-there');

    expect(find.text(AppStrings.readerEmpty), findsOneWidget);
  });
}
