import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/text/chunk_size_policy.dart';
import 'package:knosis/core/text/reading_speed.dart';
import 'package:knosis/features/reader/domain/chunk_summary.dart';
import 'package:knosis/features/reader/domain/passage_plan.dart';

List<ChunkSummary> _chunks(int count, {int words = 60}) {
  final List<ChunkSummary> chunks = <ChunkSummary>[];
  for (int i = 0; i < count; i++) {
    chunks.add(ChunkSummary(id: 'chunk-$i', orderIndex: i, wordCount: words));
  }
  return chunks;
}

void main() {
  group('PassagePlan', () {
    test('groups chunks into about a minute of reading', () {
      final ChunkSizePolicy policy = ChunkSizePolicy.forReadingSpeed(
        const ReadingSpeed(180),
      );

      final PassagePlan plan = PassagePlan.from(_chunks(20), policy);

      expect(plan.isEmpty, isFalse);
      for (int i = 0; i < plan.length - 1; i++) {
        expect(plan.at(i).wordCount, greaterThanOrEqualTo(policy.minWords));
      }
    });

    test('a slower reader gets more passages from the same chunks', () {
      final List<ChunkSummary> chunks = _chunks(30);
      final PassagePlan slow = PassagePlan.from(
        chunks,
        ChunkSizePolicy.forReadingSpeed(const ReadingSpeed(60)),
      );
      final PassagePlan fast = PassagePlan.from(
        chunks,
        ChunkSizePolicy.forReadingSpeed(const ReadingSpeed(300)),
      );

      expect(slow.length, greaterThan(fast.length));
    });

    test('changing pace never loses a chunk', () {
      final List<ChunkSummary> chunks = _chunks(30);

      for (final int wpm in <int>[60, 150, 300]) {
        final PassagePlan plan = PassagePlan.from(
          chunks,
          ChunkSizePolicy.forReadingSpeed(ReadingSpeed(wpm)),
        );

        expect(plan.at(0).firstOrder, 0);
        expect(plan.at(plan.length - 1).lastOrder, 29);
        expect(plan.sliceOfChunk, hasLength(30));
      }
    });

    test('passages follow each other without a gap', () {
      final PassagePlan plan = PassagePlan.from(
        _chunks(25),
        ChunkSizePolicy.forReadingSpeed(const ReadingSpeed(150)),
      );

      for (int i = 1; i < plan.length; i++) {
        expect(plan.at(i).firstOrder, plan.at(i - 1).lastOrder + 1);
      }
    });

    test('resumes at the passage holding the saved chunk', () {
      final PassagePlan plan = PassagePlan.from(
        _chunks(20),
        ChunkSizePolicy.forReadingSpeed(const ReadingSpeed(150)),
      );
      final PassageSlice third = plan.at(2);

      expect(plan.indexForChunk(third.firstChunkId), 2);
      expect(plan.indexForChunk('chunk-${third.lastOrder}'), 2);
    });

    test('starts over when the saved chunk is unknown or missing', () {
      final PassagePlan plan = PassagePlan.from(
        _chunks(10),
        ChunkSizePolicy.forReadingSpeed(const ReadingSpeed(150)),
      );

      expect(plan.indexForChunk(null), 0);
      expect(plan.indexForChunk('chunk-from-another-book'), 0);
    });

    test('keeps an oversized chunk in a passage of its own', () {
      final List<ChunkSummary> chunks = <ChunkSummary>[
        const ChunkSummary(id: 'a', orderIndex: 0, wordCount: 40),
        const ChunkSummary(id: 'giant', orderIndex: 1, wordCount: 4000),
        const ChunkSummary(id: 'b', orderIndex: 2, wordCount: 40),
      ];

      final PassagePlan plan = PassagePlan.from(
        chunks,
        ChunkSizePolicy.forReadingSpeed(const ReadingSpeed(150)),
      );

      expect(plan.sliceOfChunk['giant'], isNot(plan.sliceOfChunk['b']));
      expect(plan.at(plan.sliceOfChunk['giant']!).wordCount, 4040);
    });

    test('an empty book plans to nothing', () {
      final PassagePlan plan = PassagePlan.from(
        <ChunkSummary>[],
        ChunkSizePolicy.forReadingSpeed(const ReadingSpeed(150)),
      );

      expect(plan.isEmpty, isTrue);
      expect(plan.length, 0);
      expect(plan.progressAfter(0), 0);
    });

    test('progress reaches one on the last passage', () {
      final PassagePlan plan = PassagePlan.from(
        _chunks(12),
        ChunkSizePolicy.forReadingSpeed(const ReadingSpeed(150)),
      );

      expect(plan.progressAfter(plan.length - 1), 1);
    });
  });
}
