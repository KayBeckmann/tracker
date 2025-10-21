import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../time_tracking/time_tracking_types.dart';
import 'connection/connection.dart';

part 'app_database.g.dart';

enum NoteKind { markdown, drawing }

enum TaskStatus { todo, inProgress, done }

enum TaskPriority { low, medium, high }

enum JournalTrackerKind { checkbox, rating }

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

class TimeEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get startedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get endedAt => dateTime().nullable()();

  IntColumn get durationMinutes => integer().withDefault(const Constant(0))();

  TextColumn get note => text().withDefault(const Constant(''))();

  TextColumn get kind => textEnum<TimeEntryKind>().withDefault(
    Constant(TimeEntryKind.work.name),
  )();

  IntColumn get taskId => integer().nullable().references(
    TaskEntries,
    #id,
    onDelete: KeyAction.setNull,
  )();

  BoolColumn get isManual => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get entryDate => dateTime().unique()();

  TextColumn get content => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class JournalTrackers extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get description => text().withDefault(const Constant(''))();

  TextColumn get kind => textEnum<JournalTrackerKind>().withDefault(
    Constant(JournalTrackerKind.checkbox.name),
  )();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class JournalTrackerValues extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get trackerId =>
      integer().references(JournalTrackers, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get entryDate => dateTime()();

  IntColumn get value => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => const [
    'UNIQUE(tracker_id, entry_date)',
  ];
}

@DriftDatabase(
  tables: [
    GreetingEntries,
    NoteEntries,
    TaskEntries,
    TimeEntries,
    JournalEntries,
    JournalTrackers,
    JournalTrackerValues,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  // ignore: use_super_parameters
  AppDatabase.test(QueryExecutor executor) : super(executor);

  factory AppDatabase.inMemory() {
    return AppDatabase.test(openInMemoryConnection());
  }

  @override
  int get schemaVersion => 7;

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
      if (from < 6) {
        await m.createTable(timeEntries);
      }
      if (from < 7) {
        await m.createTable(journalEntries);
        await m.createTable(journalTrackers);
        await m.createTable(journalTrackerValues);
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

  Stream<List<TimeEntry>> watchAllTimeEntries() {
    return (select(timeEntries)..orderBy([
          (tbl) => OrderingTerm.desc(tbl.startedAt),
          (tbl) => OrderingTerm.desc(tbl.id),
        ]))
        .watch();
  }

  Stream<TimeEntry?> watchActiveTimeEntry() {
    return (select(timeEntries)
          ..where((tbl) => tbl.endedAt.isNull())
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.startedAt),
            (tbl) => OrderingTerm.desc(tbl.id),
          ])
          ..limit(1))
        .watchSingleOrNull();
  }

  Stream<List<TimeEntry>> watchTimeEntriesForDay(DateTime day) {
    final start = DateTime.utc(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (select(timeEntries)
          ..where(
            (tbl) =>
                tbl.startedAt.isBiggerOrEqualValue(start) &
                tbl.startedAt.isSmallerThanValue(end),
          )
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.startedAt),
            (tbl) => OrderingTerm.desc(tbl.id),
          ]))
        .watch();
  }

  Stream<List<TimeEntry>> watchTimeEntriesForTask(int taskId) {
    return (select(timeEntries)
          ..where((tbl) => tbl.taskId.equals(taskId))
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.startedAt),
            (tbl) => OrderingTerm.desc(tbl.id),
          ]))
        .watch();
  }

  Stream<List<TimeEntry>> watchTimeEntriesInRange(
    DateTime start,
    DateTime end,
  ) {
    final startUtc = start.toUtc();
    final endUtc = end.toUtc();
    return (select(timeEntries)
          ..where(
            (tbl) =>
                tbl.startedAt.isBiggerOrEqualValue(startUtc) &
                tbl.startedAt.isSmallerThanValue(endUtc),
          )
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.startedAt),
            (tbl) => OrderingTerm.desc(tbl.id),
          ]))
        .watch();
  }

  Future<TimeEntry?> getActiveTimeEntry() {
    return (select(timeEntries)
          ..where((tbl) => tbl.endedAt.isNull())
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.startedAt),
            (tbl) => OrderingTerm.desc(tbl.id),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> insertTimeEntry({
    required DateTime startedAt,
    DateTime? endedAt,
    required int durationMinutes,
    required TimeEntryKind kind,
    String note = '',
    int? taskId,
    bool isManual = false,
  }) {
    final now = DateTime.now().toUtc();
    final companion = TimeEntriesCompanion.insert(
      startedAt: Value(startedAt.toUtc()),
      endedAt: endedAt == null ? const Value.absent() : Value(endedAt.toUtc()),
      durationMinutes: Value(durationMinutes),
      note: Value(note),
      kind: Value(kind),
      taskId: taskId == null ? const Value.absent() : Value(taskId),
      isManual: Value(isManual),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    return into(timeEntries).insert(companion);
  }

  Future<void> updateTimeEntry(TimeEntry entry) async {
    final updated = entry.copyWith(updatedAt: DateTime.now().toUtc());
    await update(timeEntries).replace(updated);
  }

  Future<void> completeTimeEntry({
    required int id,
    required DateTime endedAt,
    required int durationMinutes,
    int? taskId,
    String? note,
  }) async {
    final companion = TimeEntriesCompanion(
      endedAt: Value(endedAt.toUtc()),
      durationMinutes: Value(durationMinutes),
      taskId: taskId == null ? const Value.absent() : Value(taskId),
      note: note == null ? const Value.absent() : Value(note),
      updatedAt: Value(DateTime.now().toUtc()),
    );
    await (update(
      timeEntries,
    )..where((tbl) => tbl.id.equals(id))).write(companion);
  }

  Future<int> deleteTimeEntry(int id) {
    return (delete(timeEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  DateTime _normalizeDate(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  Stream<List<JournalEntry>> watchJournalEntries() {
    return (select(journalEntries)..orderBy([
          (tbl) => OrderingTerm.desc(tbl.entryDate),
          (tbl) => OrderingTerm.desc(tbl.id),
        ]))
        .watch();
  }

  Stream<JournalEntry?> watchJournalEntryForDate(DateTime date) {
    final normalized = _normalizeDate(date);
    return (select(journalEntries)
          ..where((tbl) => tbl.entryDate.equals(normalized))
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<JournalEntry?> getJournalEntryForDate(DateTime date) {
    final normalized = _normalizeDate(date);
    return (select(journalEntries)
          ..where((tbl) => tbl.entryDate.equals(normalized))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> upsertJournalEntry({
    required DateTime date,
    required String content,
  }) async {
    final normalized = _normalizeDate(date);
    final now = DateTime.now().toUtc();
    final existing = await getJournalEntryForDate(normalized);
    if (existing == null) {
      final companion = JournalEntriesCompanion.insert(
        entryDate: normalized,
        content: Value(content),
        createdAt: Value(now),
        updatedAt: Value(now),
      );
      return into(journalEntries).insert(companion);
    }
    final companion = JournalEntriesCompanion(
      content: Value(content),
      updatedAt: Value(now),
    );
    await (update(
      journalEntries,
    )..where((tbl) => tbl.entryDate.equals(normalized))).write(companion);
    return existing.id;
  }

  Future<int> deleteJournalEntry(DateTime date) {
    final normalized = _normalizeDate(date);
    return (delete(
      journalEntries,
    )..where((tbl) => tbl.entryDate.equals(normalized))).go();
  }

  Stream<List<JournalTracker>> watchJournalTrackers() {
    return (select(journalTrackers)..orderBy([
          (tbl) => OrderingTerm.asc(tbl.sortOrder),
          (tbl) => OrderingTerm.asc(tbl.createdAt),
        ]))
        .watch();
  }

  Future<int> insertJournalTracker({
    required String name,
    String description = '',
    required JournalTrackerKind kind,
  }) async {
    final now = DateTime.now().toUtc();
    final latest =
        await (select(journalTrackers)
              ..orderBy([(tbl) => OrderingTerm.desc(tbl.sortOrder)])
              ..limit(1))
            .getSingleOrNull();
    final int maxSortOrder = latest?.sortOrder ?? -1;
    final companion = JournalTrackersCompanion.insert(
      name: name,
      description: Value(description),
      kind: Value(kind),
      sortOrder: Value(maxSortOrder + 1),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    return into(journalTrackers).insert(companion);
  }

  Future<void> updateJournalTracker(JournalTracker tracker) async {
    final updated = tracker.copyWith(updatedAt: DateTime.now().toUtc());
    await update(journalTrackers).replace(updated);
  }

  Future<int> deleteJournalTracker(int id) {
    return (delete(journalTrackers)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> reorderJournalTrackers(List<int> orderedIds) async {
    await transaction(() async {
      final now = DateTime.now().toUtc();
      for (var i = 0; i < orderedIds.length; i++) {
        final id = orderedIds[i];
        await (update(
          journalTrackers,
        )..where((tbl) => tbl.id.equals(id))).write(
          JournalTrackersCompanion(sortOrder: Value(i), updatedAt: Value(now)),
        );
      }
    });
  }

  Stream<List<JournalTrackerValue>> watchJournalTrackerValues() {
    return (select(journalTrackerValues)..orderBy([
          (tbl) => OrderingTerm.desc(tbl.entryDate),
          (tbl) => OrderingTerm.asc(tbl.trackerId),
        ]))
        .watch();
  }

  Stream<List<JournalTrackerValue>> watchJournalTrackerValuesForDate(
    DateTime date,
  ) {
    final normalized = _normalizeDate(date);
    return (select(journalTrackerValues)
          ..where((tbl) => tbl.entryDate.equals(normalized))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.trackerId),
            (tbl) => OrderingTerm.desc(tbl.updatedAt),
          ]))
        .watch();
  }

  Future<void> setJournalTrackerValue({
    required int trackerId,
    required DateTime date,
    required int value,
  }) async {
    final normalized = _normalizeDate(date);
    final now = DateTime.now().toUtc();
    final sanitized = value.clamp(0, 5);
    final existing =
        await (select(journalTrackerValues)
              ..where(
                (tbl) =>
                    tbl.trackerId.equals(trackerId) &
                    tbl.entryDate.equals(normalized),
              )
              ..limit(1))
            .getSingleOrNull();
    if (existing == null) {
      final companion = JournalTrackerValuesCompanion.insert(
        trackerId: trackerId,
        entryDate: normalized,
        value: Value(sanitized),
        createdAt: Value(now),
        updatedAt: Value(now),
      );
      await into(journalTrackerValues).insert(companion);
      return;
    }
    await (update(
      journalTrackerValues,
    )..where((tbl) => tbl.id.equals(existing.id))).write(
      JournalTrackerValuesCompanion(
        value: Value(sanitized),
        updatedAt: Value(now),
      ),
    );
  }

  Future<int> clearJournalTrackerValue({
    required int trackerId,
    required DateTime date,
  }) {
    final normalized = _normalizeDate(date);
    return (delete(journalTrackerValues)..where(
          (tbl) =>
              tbl.trackerId.equals(trackerId) &
              tbl.entryDate.equals(normalized),
        ))
        .go();
  }
}
