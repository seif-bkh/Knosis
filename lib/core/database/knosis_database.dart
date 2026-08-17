import 'package:drift/drift.dart';

import 'tables.dart';

part 'knosis_database.g.dart';

/// The local database.
///
/// Everything Knosis knows lives here, on the device, with no account and no
/// network (AGENTS.md sections 11 and 12).
///
/// Schema rules, from AGENTS.md section 15:
///
/// * the schema is versioned and migrated forward, never reset;
/// * `onUpgrade` must preserve user data - annotations and reading positions
///   are the most valuable thing in the app;
/// * every migration gets a test before it ships.
@DriftDatabase(tables: <Type>[Books, Chapters, Chunks])
class KnosisDatabase extends _$KnosisDatabase {
  KnosisDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Schema v1 is the first shipped schema, so there is nothing to
        // migrate yet. When a v2 arrives, add ordered, tested steps here.
        // Never drop or recreate a table to fix a schema problem.
      },
      beforeOpen: (OpeningDetails details) async {
        // SQLite disables foreign keys per connection by default, so the
        // cascade rules declared on the tables would silently not apply.
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
