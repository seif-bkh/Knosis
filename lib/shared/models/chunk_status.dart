/// How well a chunk is known (PRODUCT_REPORT.md section 8.3).
///
/// Stored as the enum name, so adding a value later does not renumber
/// existing rows.
enum ChunkStatus { unread, readOnce, reviewed, mastered }
