import 'package:drift/drift.dart';
import 'connection/connection.dart';

part 'app_database.g.dart';

enum NoteKind { markdown, drawing }

class GreetingEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get message => text()();

  TextColumn get source => text().withDefault(const Constant('unbekannt'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class NoteEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withDefault(const Constant(''))();

  TextColumn get content => text().nullable()();

  TextColumn get drawingJson => text().nullable()();

  TextColumn get tags => text().withDefault(const Constant(''))();

  TextColumn get kind =>
      textEnum<NoteKind>().withDefault(Constant(NoteKind.markdown.name))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [GreetingEntries, NoteEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  // ignore: use_super_parameters
  AppDatabase.test(QueryExecutor executor) : super(executor);

  factory AppDatabase.inMemory() {
    return AppDatabase.test(openInMemoryConnection());
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(noteEntries);
          }
        },
      );

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

  Selectable<NoteEntry> _baseNoteQuery({
    String contentFilter = '',
    String tagFilter = '',
  }) {
    final query = select(noteEntries)
      ..orderBy(
        [
          (tbl) => OrderingTerm.desc(tbl.updatedAt),
          (tbl) => OrderingTerm.desc(tbl.id),
        ],
      );

    if (contentFilter.trim().isNotEmpty) {
      final pattern = '%${contentFilter.trim()}%';
      query.where(
        (tbl) {
          final titleMatch =
              tbl.title.collate(Collate.noCase).like(pattern);
          final contentMatch = tbl.content.isNotNull() &
              tbl.content.collate(Collate.noCase).like(pattern);
          return titleMatch | contentMatch;
        },
      );
    }

    if (tagFilter.trim().isNotEmpty) {
      final pattern = '%${tagFilter.trim()}%';
      query.where(
        (tbl) => tbl.tags.collate(Collate.noCase).like(pattern),
      );
    }

    return query;
  }

  Stream<List<NoteEntry>> watchNoteEntries({
    String contentFilter = '',
    String tagFilter = '',
  }) {
    return _baseNoteQuery(
      contentFilter: contentFilter,
      tagFilter: tagFilter,
    ).watch();
  }

  Stream<List<String>> watchAllNoteTags() {
    return select(noteEntries).watch().map((rows) {
      final tags = <String>{};
      for (final note in rows) {
        final parts = note.tags
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty);
        tags.addAll(parts);
      }
      final result = tags.toList()
        ..sort(
          (a, b) => a.toLowerCase().compareTo(b.toLowerCase()),
        );
      return result;
    });
  }

  Future<int> insertNoteEntry({
    required NoteKind kind,
    String title = '',
    String? content,
    String? drawingJson,
    String tags = '',
  }) async {
    assert(
      kind == NoteKind.markdown ? content != null : drawingJson != null,
      'Note content must match the selected kind.',
    );
    final now = DateTime.now().toUtc();
    final companion = NoteEntriesCompanion.insert(
      kind: Value(kind),
      title: Value(title),
      content: Value(content),
      drawingJson: Value(drawingJson),
      tags: Value(tags),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    return into(noteEntries).insert(companion);
  }

  Future<void> updateNoteEntry(NoteEntry note) async {
    final updated = note.copyWith(updatedAt: DateTime.now().toUtc());
    await update(noteEntries).replace(updated);
  }

  Future<int> deleteNoteEntry(int id) {
    return (delete(noteEntries)..where((tbl) => tbl.id.equals(id))).go();
  }
}
