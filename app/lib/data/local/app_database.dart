import 'package:drift/drift.dart';
import 'connection/connection.dart';

part 'app_database.g.dart';

class GreetingEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get message => text()();

  TextColumn get source => text().withDefault(const Constant('unbekannt'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [GreetingEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  // ignore: use_super_parameters
  AppDatabase.test(QueryExecutor executor) : super(executor);

  factory AppDatabase.inMemory() {
    return AppDatabase.test(openInMemoryConnection());
  }

  @override
  int get schemaVersion => 1;

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
}
