import 'package:drift/drift.dart';

import '../../shared/models/book_format.dart';
import '../../shared/models/book_status.dart';
import '../../shared/models/chunk_status.dart';
import '../../shared/models/reading_mode.dart';

/// An imported book (PRODUCT_REPORT.md section 13.3).
///
/// The reading position lives here as three separate columns rather than one
/// opaque value: chapter identity, chunk identity and a character offset
/// inside the chunk. AGENTS.md section 16 requires a position that survives
/// restarts and reimports, which a bare list index cannot do.
@DataClassName('BookRow')
class Books extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 1000)();
  TextColumn get author => text().nullable()();

  /// BCP-47 language tag of the book text, for example `en` or `fr`.
  TextColumn get languageCode => text().withLength(min: 2, max: 35)();

  /// Location of the imported copy inside the app's own storage. Books are
  /// copied in on import so the library keeps working if the original file
  /// is moved or deleted.
  TextColumn get sourceFilePath => text()();
  TextColumn get coverPath => text().nullable()();

  TextColumn get format => textEnum<BookFormat>()();
  TextColumn get status =>
      textEnum<BookStatus>().withDefault(const Constant('notStarted'))();

  DateTimeColumn get importedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastReadAt => dateTime().nullable()();

  IntColumn get totalWords => integer().withDefault(const Constant(0))();
  IntColumn get totalChapters => integer().withDefault(const Constant(0))();
  RealColumn get difficultyScore => real().nullable()();

  TextColumn get currentChapterId => text().nullable()();
  TextColumn get currentChunkId => text().nullable()();
  IntColumn get currentCharOffset => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

/// A chapter of a book (PRODUCT_REPORT.md section 13.4).
@DataClassName('ChapterRow')
class Chapters extends Table {
  TextColumn get id => text()();
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().nullable()();

  /// Position of the chapter inside the book, starting at 0.
  IntColumn get orderIndex => integer()();

  IntColumn get startOffset => integer()();
  IntColumn get endOffset => integer()();
  IntColumn get wordCount => integer().withDefault(const Constant(0))();
  RealColumn get difficultyScore => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

/// A readable unit of text (PRODUCT_REPORT.md section 13.5).
///
/// The chunk text is stored here on purpose. It costs disk space next to the
/// imported file, and it buys the two things the reader depends on: loading a
/// single chunk without touching the rest of a 2,000 page book, and full text
/// search over SQLite later. [startOffset] and [endOffset] keep the link back
/// to the source text.
@DataClassName('ChunkRow')
class Chunks extends Table {
  TextColumn get id => text()();
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get chapterId =>
      text().references(Chapters, #id, onDelete: KeyAction.cascade)();

  /// Position of the chunk inside the book, starting at 0.
  IntColumn get orderIndex => integer()();

  /// The chunk text. Named `content` because `text` collides with the
  /// column builder inherited from [Table].
  TextColumn get content => text()();

  IntColumn get startOffset => integer()();
  IntColumn get endOffset => integer()();
  IntColumn get wordCount => integer().withDefault(const Constant(0))();
  RealColumn get difficultyScore => real().nullable()();

  TextColumn get status =>
      textEnum<ChunkStatus>().withDefault(const Constant('unread'))();
  IntColumn get readCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReadAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

/// A stretch of reading (PRODUCT_REPORT.md section 13.6).
///
/// There is no userId column: the MVP has no accounts, and everything here
/// belongs to the one person holding the phone. Adding one later is an
/// additive migration.
///
/// [wordsRead] and [durationSeconds] accumulate as the reader moves through
/// passages. Together they are the evidence behind a measured reading speed,
/// which is what sizes future passages.
@DataClassName('ReadingSessionRow')
class ReadingSessions extends Table {
  TextColumn get id => text()();
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get chapterId => text().nullable()();
  TextColumn get chunkStartId => text().nullable()();
  TextColumn get chunkEndId => text().nullable()();

  TextColumn get mode =>
      textEnum<ReadingMode>().withDefault(const Constant('flow'))();

  DateTimeColumn get startedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
  IntColumn get wordsRead => integer().withDefault(const Constant(0))();

  /// Filled in at the end of a session, when the reader is asked. Never
  /// demanded mid-reading.
  IntColumn get comprehensionRating => integer().nullable()();
  IntColumn get flowRating => integer().nullable()();
  TextColumn get summary => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
