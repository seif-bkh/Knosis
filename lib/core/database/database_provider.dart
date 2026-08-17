import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'knosis_database.dart';

/// Opens the on-device database file.
///
/// [NativeDatabase.createInBackground] runs SQLite on its own isolate, so a
/// slow query can never stutter the reader (AGENTS.md section 10).
/// [LazyDatabase] defers the work until the first actual query, keeping it
/// off app startup.
QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/knosis.sqlite');
    return NativeDatabase.createInBackground(file);
  });
}

KnosisDatabase _createDatabase(Ref ref) {
  final KnosisDatabase database = KnosisDatabase(_openConnection());
  ref.onDispose(database.close);
  return database;
}

/// The app's single database handle.
///
/// Tests override this with an in-memory database, which is the only reason
/// the reader can be tested without touching the file system.
final Provider<KnosisDatabase> databaseProvider = Provider<KnosisDatabase>(
  _createDatabase,
);
