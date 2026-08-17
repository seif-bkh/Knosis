/// Where a book sits in the reader's journey.
///
/// Stored as the enum name, so adding a value later does not renumber
/// existing rows.
enum BookStatus { notStarted, reading, paused, finished }
