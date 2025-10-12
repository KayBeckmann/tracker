import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class GreetingEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get message => text()();

  TextColumn get source => text().withDefault(const Constant('unbekannt'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class NoteEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  TextColumn get tags => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationSupportDirectory();
    final file = File(p.join(directory.path, 'tracker.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [GreetingEntries, NoteEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // ignore: use_super_parameters
  AppDatabase.test(QueryExecutor executor) : super(executor);

  factory AppDatabase.inMemory() {
    return AppDatabase.test(NativeDatabase.memory());
  }

  @override
  int get schemaVersion => 2;

  Stream<List<GreetingEntry>> watchGreetingEntries() {
    return (select(greetingEntries)..orderBy([
          (tbl) => OrderingTerm.desc(tbl.createdAt),
          (tbl) => OrderingTerm.desc(tbl.id),
        ]))
        .watch();
  }

  Future<int> insertGreetingEntry({
    required String name,
    required String message,
    required String source,
    required DateTime createdAt,
  }) {
    final companion = GreetingEntriesCompanion.insert(
      name: name,
      message: message,
      source: Value(source),
      createdAt: Value(createdAt),
    );
    return into(greetingEntries).insert(companion);
  }

  Future<int> clearGreetingEntries() {
    return delete(greetingEntries).go();
  }

  Stream<List<NoteEntry>> watchNoteEntries({
    String? contentFilter,
    String? tagFilter,
  }) {
    final query = select(noteEntries);

    if (contentFilter != null && contentFilter.isNotEmpty) {
      query.where((tbl) => tbl.content.like('%$contentFilter%'));
    }

    if (tagFilter != null && tagFilter.isNotEmpty) {
      query.where((tbl) => tbl.tags.like('%$tagFilter%'));
    }

    query.orderBy([
      (tbl) => OrderingTerm.desc(tbl.createdAt),
      (tbl) => OrderingTerm.desc(tbl.id),
    ]);

    return query.watch();
  }

  Future<int> insertNoteEntry({
    required String content,
    required String tags,
  }) {
    final companion = NoteEntriesCompanion.insert(
      content: content,
      tags: tags,
    );
    return into(noteEntries).insert(companion);
  }

  Future<int> updateNoteEntry(NoteEntry entry) {
    return update(noteEntries).replace(entry);
  }

  Future<int> deleteNoteEntry(int id) {
    return (delete(noteEntries)..where((tbl) => tbl.id.equals(id))).go();
  }
}
