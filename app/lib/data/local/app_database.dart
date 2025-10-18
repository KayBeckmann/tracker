import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'connection/connection.dart';

part 'app_database.g.dart';

enum NoteKind { markdown, drawing }

enum TaskStatus { todo, inProgress, done }

enum TaskPriority { low, medium, high }

const Uuid _uuid = Uuid();

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

  TextColumn get remoteId => text().nullable()();

  IntColumn get remoteVersion => integer().withDefault(const Constant(0))();

  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();

  DateTimeColumn get syncedAt => dateTime().nullable()();
}

class TaskEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get status =>
      textEnum<TaskStatus>().withDefault(Constant(TaskStatus.todo.name))();

  TextColumn get priority => textEnum<TaskPriority>().withDefault(
    Constant(TaskPriority.medium.name),
  )();

  DateTimeColumn get dueDate => dateTime()();

  IntColumn get noteId => integer().nullable().references(
    NoteEntries,
    #id,
    onDelete: KeyAction.setNull,
  )();

  TextColumn get tags => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get reminderAt => dateTime().nullable()();

  TextColumn get remoteId => text().nullable()();

  IntColumn get remoteVersion => integer().withDefault(const Constant(0))();

  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();

  DateTimeColumn get syncedAt => dateTime().nullable()();
}

@DriftDatabase(tables: [GreetingEntries, NoteEntries, TaskEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  // ignore: use_super_parameters
  AppDatabase.test(QueryExecutor executor) : super(executor);

  factory AppDatabase.inMemory() {
    return AppDatabase.test(openInMemoryConnection());
  }

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(noteEntries);
      }
      if (from < 3) {
        await m.createTable(taskEntries);
      }
      if (from < 4) {
        await m.addColumn(taskEntries, taskEntries.reminderAt);
      }
      if (from < 5) {
        await m.addColumn(noteEntries, noteEntries.remoteId);
        await m.addColumn(noteEntries, noteEntries.remoteVersion);
        await m.addColumn(noteEntries, noteEntries.needsSync);
        await m.addColumn(noteEntries, noteEntries.syncedAt);
        await m.addColumn(taskEntries, taskEntries.remoteId);
        await m.addColumn(taskEntries, taskEntries.remoteVersion);
        await m.addColumn(taskEntries, taskEntries.needsSync);
        await m.addColumn(taskEntries, taskEntries.syncedAt);
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
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.updatedAt),
        (tbl) => OrderingTerm.desc(tbl.id),
      ]);

    if (contentFilter.trim().isNotEmpty) {
      final pattern = '%${contentFilter.trim()}%';
      query.where((tbl) {
        final titleMatch = tbl.title.collate(Collate.noCase).like(pattern);
        final contentMatch =
            tbl.content.isNotNull() &
            tbl.content.collate(Collate.noCase).like(pattern);
        return titleMatch | contentMatch;
      });
    }

    if (tagFilter.trim().isNotEmpty) {
      final pattern = '%${tagFilter.trim()}%';
      query.where((tbl) => tbl.tags.collate(Collate.noCase).like(pattern));
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
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      return result;
    });
  }

  Future<int> insertNoteEntry({
    required NoteKind kind,
    String title = '',
    String? content,
    String? drawingJson,
    String tags = '',
    String? remoteId,
  }) async {
    assert(
      kind == NoteKind.markdown ? content != null : drawingJson != null,
      'Note content must match the selected kind.',
    );
    final now = DateTime.now().toUtc();
    final resolvedRemoteId = remoteId ?? _uuid.v4();
    final companion = NoteEntriesCompanion.insert(
      kind: Value(kind),
      title: Value(title),
      content: Value(content),
      drawingJson: Value(drawingJson),
      tags: Value(tags),
      createdAt: Value(now),
      updatedAt: Value(now),
      remoteId: Value(resolvedRemoteId),
      remoteVersion: const Value(0),
      needsSync: const Value(true),
      syncedAt: const Value.absent(),
    );
    return into(noteEntries).insert(companion);
  }

  Future<void> updateNoteEntry(NoteEntry note) async {
    final updated = note.copyWith(
      updatedAt: DateTime.now().toUtc(),
      needsSync: true,
    );
    await update(noteEntries).replace(updated);
  }

  Future<int> deleteNoteEntry(int id) {
    return (delete(noteEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<NoteEntry?> getNoteEntryById(int id) {
    return (select(
      noteEntries,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<NoteEntry?> getNoteByRemoteId(String remoteId) {
    return (select(
      noteEntries,
    )..where((tbl) => tbl.remoteId.equals(remoteId))).getSingleOrNull();
  }

  Future<List<NoteEntry>> getNotesNeedingSync() {
    return (select(
      noteEntries,
    )..where((tbl) => tbl.needsSync.equals(true))).get();
  }

  Future<void> markNoteSynced({
    required int id,
    required int remoteVersion,
    required DateTime syncedAt,
  }) async {
    final utc = syncedAt.toUtc();
    await (update(noteEntries)..where((tbl) => tbl.id.equals(id))).write(
      NoteEntriesCompanion(
        remoteVersion: Value(remoteVersion),
        needsSync: const Value(false),
        syncedAt: Value(utc),
        updatedAt: Value(utc),
      ),
    );
  }

  Future<void> assignNoteRemoteId({
    required int id,
    required String remoteId,
  }) async {
    await (update(noteEntries)..where((tbl) => tbl.id.equals(id))).write(
      NoteEntriesCompanion(
        remoteId: Value(remoteId),
        needsSync: const Value(true),
      ),
    );
  }

  Stream<List<TaskEntry>> watchTaskEntries() {
    return (select(taskEntries)..orderBy([
          (tbl) => OrderingTerm.asc(tbl.dueDate),
          (tbl) => OrderingTerm.desc(tbl.updatedAt),
          (tbl) => OrderingTerm.desc(tbl.id),
        ]))
        .watch();
  }

  Stream<List<TaskEntry>> watchTasksForDay(DateTime day) {
    final DateTime start = DateTime.utc(day.year, day.month, day.day);
    final DateTime end = start.add(const Duration(days: 1));
    return (select(taskEntries)
          ..where(
            (tbl) =>
                tbl.dueDate.isBiggerOrEqualValue(start) &
                tbl.dueDate.isSmallerThanValue(end),
          )
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.dueDate),
            (tbl) => OrderingTerm.desc(tbl.updatedAt),
          ]))
        .watch();
  }

  Future<int> insertTaskEntry({
    required String title,
    required TaskStatus status,
    required TaskPriority priority,
    required DateTime dueDate,
    int? noteId,
    String tags = '',
    DateTime? reminderAt,
    String? remoteId,
  }) {
    final now = DateTime.now().toUtc();
    final resolvedRemoteId = remoteId ?? _uuid.v4();
    final companion = TaskEntriesCompanion.insert(
      title: title,
      status: Value(status),
      priority: Value(priority),
      dueDate: dueDate.toUtc(),
      noteId: noteId == null ? const Value.absent() : Value(noteId),
      tags: Value(tags),
      createdAt: Value(now),
      updatedAt: Value(now),
      reminderAt: reminderAt == null
          ? const Value.absent()
          : Value(reminderAt.toUtc()),
      remoteId: Value(resolvedRemoteId),
      remoteVersion: const Value(0),
      needsSync: const Value(true),
      syncedAt: const Value.absent(),
    );
    return into(taskEntries).insert(companion);
  }

  Future<void> updateTaskEntry(TaskEntry task) {
    final updated = task.copyWith(
      updatedAt: DateTime.now().toUtc(),
      needsSync: true,
    );
    return update(taskEntries).replace(updated);
  }

  Future<int> deleteTaskEntry(int id) {
    return (delete(taskEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<TaskEntry?> getTaskById(int id) {
    return (select(
      taskEntries,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<TaskEntry?> getTaskByRemoteId(String remoteId) {
    return (select(
      taskEntries,
    )..where((tbl) => tbl.remoteId.equals(remoteId))).getSingleOrNull();
  }

  Future<List<TaskEntry>> getTasksNeedingSync() {
    return (select(
      taskEntries,
    )..where((tbl) => tbl.needsSync.equals(true))).get();
  }

  Future<void> markTaskSynced({
    required int id,
    required int remoteVersion,
    required DateTime syncedAt,
  }) async {
    final utc = syncedAt.toUtc();
    await (update(taskEntries)..where((tbl) => tbl.id.equals(id))).write(
      TaskEntriesCompanion(
        remoteVersion: Value(remoteVersion),
        needsSync: const Value(false),
        syncedAt: Value(utc),
        updatedAt: Value(utc),
      ),
    );
  }

  Future<void> assignTaskRemoteId({
    required int id,
    required String remoteId,
  }) async {
    await (update(taskEntries)..where((tbl) => tbl.id.equals(id))).write(
      TaskEntriesCompanion(
        remoteId: Value(remoteId),
        needsSync: const Value(true),
      ),
    );
  }

  Stream<List<String>> watchAllTaskTags() {
    return select(taskEntries).watch().map((rows) {
      final tags = <String>{};
      for (final task in rows) {
        final parts = task.tags
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty);
        tags.addAll(parts);
      }
      final result = tags.toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      return result;
    });
  }
}
