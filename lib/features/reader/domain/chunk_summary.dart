/// Id and length of one stored chunk.
///
/// Deliberately without text: planning passages needs only how long each
/// chunk is, and a 2,000 page book is thousands of chunks. Ids and integers
/// for all of them cost a few hundred kilobytes; their text would be the
/// whole book (AGENTS.md section 10).
class ChunkSummary {
  const ChunkSummary({
    required this.id,
    required this.orderIndex,
    required this.wordCount,
  });

  final String id;
  final int orderIndex;
  final int wordCount;
}
