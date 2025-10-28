import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../time_tracking/time_tracking_types.dart';
import 'connection/connection.dart';

part 'app_database.g.dart';

enum NoteKind { markdown, drawing }

enum TaskStatus { todo, inProgress, done }

enum TaskPriority { low, medium, high }

enum JournalTrackerKind { checkbox, rating }

enum HabitIntervalKind { daily, multiplePerDay, weekly, multiplePerWeek }

enum HabitValueKind { boolean, integer, decimal }

enum LedgerAccountKind { cash, bankAccount, depot, asset, crypto }

enum LedgerCategoryKind { income, expense }

enum LedgerTransactionKind { income, expense, transfer, cryptoPurchase }

enum LedgerBudgetPeriodKind { monthly, quarterly, yearly }

enum LedgerRecurringIntervalKind {
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
  custom,
}

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

  TextColumn get remoteId => text().nullable()();

  IntColumn get remoteVersion => integer().withDefault(const Constant(0))();

  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();

  DateTimeColumn get syncedAt => dateTime().nullable()();
}

class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get entryDate => dateTime().unique()();

  TextColumn get content => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  TextColumn get remoteId => text().nullable()();

  IntColumn get remoteVersion => integer().withDefault(const Constant(0))();

  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();

  DateTimeColumn get syncedAt => dateTime().nullable()();
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

  TextColumn get remoteId => text().nullable()();

  IntColumn get remoteVersion => integer().withDefault(const Constant(0))();

  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();

  DateTimeColumn get syncedAt => dateTime().nullable()();
}

class JournalTrackerValues extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get trackerId =>
      integer().references(JournalTrackers, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get entryDate => dateTime()();

  IntColumn get value => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  TextColumn get remoteId => text().nullable()();

  IntColumn get remoteVersion => integer().withDefault(const Constant(0))();

  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  List<String> get customConstraints => const [
    'UNIQUE(tracker_id, entry_date)',
  ];
}

class HabitDefinitions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get description => text().withDefault(const Constant(''))();

  TextColumn get interval => textEnum<HabitIntervalKind>().withDefault(
    Constant(HabitIntervalKind.daily.name),
  )();

  IntColumn get targetOccurrences => integer().withDefault(const Constant(1))();

  TextColumn get measurementKind => textEnum<HabitValueKind>().withDefault(
    Constant(HabitValueKind.boolean.name),
  )();

  RealColumn get targetValue => real().nullable()();

  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  TextColumn get remoteId => text().nullable()();

  IntColumn get remoteVersion => integer().withDefault(const Constant(0))();

  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();

  DateTimeColumn get syncedAt => dateTime().nullable()();
}

class HabitLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get habitId => integer().references(
    HabitDefinitions,
    #id,
    onDelete: KeyAction.cascade,
  )();

  DateTimeColumn get occurredAt => dateTime()();

  RealColumn get value => real().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  TextColumn get remoteId => text().nullable()();

  IntColumn get remoteVersion => integer().withDefault(const Constant(0))();

  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();

  DateTimeColumn get syncedAt => dateTime().nullable()();
}

class LedgerAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get accountKind => textEnum<LedgerAccountKind>().withDefault(
    Constant(LedgerAccountKind.cash.name),
  )();

  TextColumn get currencyCode =>
      text().withLength(min: 3, max: 3).withDefault(const Constant('EUR'))();

  BoolColumn get includeInNetWorth =>
      boolean().withDefault(const Constant(true))();

  RealColumn get initialBalance => real().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class LedgerCategories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get categoryKind => textEnum<LedgerCategoryKind>().withDefault(
    Constant(LedgerCategoryKind.expense.name),
  )();

  IntColumn get parentId => integer().nullable().customConstraint(
    'NULL REFERENCES ledger_categories(id) ON DELETE SET NULL',
  )();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class LedgerBudgets extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get categoryId => integer().references(
    LedgerCategories,
    #id,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get periodKind => textEnum<LedgerBudgetPeriodKind>().withDefault(
    Constant(LedgerBudgetPeriodKind.monthly.name),
  )();

  IntColumn get year => integer()();

  IntColumn get month => integer().nullable()();

  RealColumn get amount => real().withDefault(const Constant(0))();

  TextColumn get currencyCode =>
      text().withLength(min: 3, max: 3).withDefault(const Constant('EUR'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => const [
    'UNIQUE(category_id, period_kind, year, month)',
  ];
}

class LedgerTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get transactionKind => textEnum<LedgerTransactionKind>()
      .withDefault(Constant(LedgerTransactionKind.expense.name))();

  IntColumn get accountId => integer().nullable().references(
    LedgerAccounts,
    #id,
    onDelete: KeyAction.setNull,
  )();

  IntColumn get targetAccountId => integer().nullable().references(
    LedgerAccounts,
    #id,
    onDelete: KeyAction.setNull,
  )();

  IntColumn get categoryId => integer().nullable().references(
    LedgerCategories,
    #id,
    onDelete: KeyAction.setNull,
  )();

  IntColumn get subcategoryId => integer().nullable().references(
    LedgerCategories,
    #id,
    onDelete: KeyAction.setNull,
  )();

  RealColumn get amount => real().withDefault(const Constant(0))();

  TextColumn get currencyCode =>
      text().withLength(min: 3, max: 3).withDefault(const Constant('EUR'))();

  DateTimeColumn get bookingDate =>
      dateTime().withDefault(currentDateAndTime)();

  BoolColumn get isPlanned => boolean().withDefault(const Constant(false))();

  TextColumn get description => text().withDefault(const Constant(''))();

  TextColumn get cryptoSymbol => text().nullable()();

  RealColumn get cryptoQuantity => real().nullable()();

  RealColumn get pricePerUnit => real().nullable()();

  RealColumn get feeAmount => real().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class LedgerRecurringTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get transactionKind => textEnum<LedgerTransactionKind>()
      .withDefault(Constant(LedgerTransactionKind.expense.name))();

  IntColumn get accountId => integer().nullable().references(
    LedgerAccounts,
    #id,
    onDelete: KeyAction.setNull,
  )();

  IntColumn get targetAccountId => integer().nullable().references(
    LedgerAccounts,
    #id,
    onDelete: KeyAction.setNull,
  )();

  IntColumn get categoryId => integer().nullable().references(
    LedgerCategories,
    #id,
    onDelete: KeyAction.setNull,
  )();

  IntColumn get subcategoryId => integer().nullable().references(
    LedgerCategories,
    #id,
    onDelete: KeyAction.setNull,
  )();

  RealColumn get amount => real().withDefault(const Constant(0))();

  TextColumn get currencyCode =>
      text().withLength(min: 3, max: 3).withDefault(const Constant('EUR'))();

  TextColumn get intervalKind => textEnum<LedgerRecurringIntervalKind>()
      .withDefault(Constant(LedgerRecurringIntervalKind.monthly.name))();

  IntColumn get intervalCount => integer().withDefault(const Constant(1))();

  DateTimeColumn get startedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get nextOccurrence =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get endedAt => dateTime().nullable()();

  BoolColumn get autoApply => boolean().withDefault(const Constant(false))();

  TextColumn get metadataJson => text().withDefault(const Constant('{}'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class CryptoPriceEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get symbol => text()();

  TextColumn get currencyCode =>
      text().withLength(min: 3, max: 3).withDefault(const Constant('EUR'))();

  RealColumn get price => real().withDefault(const Constant(0))();

  DateTimeColumn get fetchedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => const ['UNIQUE(symbol, currency_code)'];
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
    HabitDefinitions,
    HabitLogs,
    LedgerAccounts,
    LedgerCategories,
    LedgerBudgets,
    LedgerTransactions,
    LedgerRecurringTransactions,
    CryptoPriceEntries,
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
  int get schemaVersion => 11;

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
      if (from < 8) {
        await m.createTable(habitDefinitions);
        await m.createTable(habitLogs);
      }
      if (from < 9) {
        await m.createTable(ledgerAccounts);
        await m.createTable(ledgerCategories);
        await m.createTable(ledgerBudgets);
        await m.createTable(ledgerTransactions);
        await m.createTable(ledgerRecurringTransactions);
        await m.createTable(cryptoPriceEntries);
      }
      if (from < 10) {
        await m.addColumn(timeEntries, timeEntries.remoteId);
        await m.addColumn(timeEntries, timeEntries.remoteVersion);
        await m.addColumn(timeEntries, timeEntries.needsSync);
        await m.addColumn(timeEntries, timeEntries.syncedAt);
      }
      if (from < 11) {
        await m.addColumn(journalEntries, journalEntries.remoteId);
        await m.addColumn(journalEntries, journalEntries.remoteVersion);
        await m.addColumn(journalEntries, journalEntries.needsSync);
        await m.addColumn(journalEntries, journalEntries.syncedAt);
        await m.addColumn(journalTrackers, journalTrackers.remoteId);
        await m.addColumn(journalTrackers, journalTrackers.remoteVersion);
        await m.addColumn(journalTrackers, journalTrackers.needsSync);
        await m.addColumn(journalTrackers, journalTrackers.syncedAt);
        await m.addColumn(journalTrackerValues, journalTrackerValues.remoteId);
        await m.addColumn(
          journalTrackerValues,
          journalTrackerValues.remoteVersion,
        );
        await m.addColumn(journalTrackerValues, journalTrackerValues.needsSync);
        await m.addColumn(journalTrackerValues, journalTrackerValues.syncedAt);
        await m.addColumn(habitDefinitions, habitDefinitions.remoteId);
        await m.addColumn(habitDefinitions, habitDefinitions.remoteVersion);
        await m.addColumn(habitDefinitions, habitDefinitions.needsSync);
        await m.addColumn(habitDefinitions, habitDefinitions.syncedAt);
        await m.addColumn(habitLogs, habitLogs.remoteId);
        await m.addColumn(habitLogs, habitLogs.remoteVersion);
        await m.addColumn(habitLogs, habitLogs.needsSync);
        await m.addColumn(habitLogs, habitLogs.syncedAt);
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
    String? remoteId,
    int remoteVersion = 0,
    bool needsSync = true,
    DateTime? syncedAt,
  }) {
    final now = DateTime.now().toUtc();
    final resolvedRemoteId = remoteId ?? _uuid.v4();
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
      remoteId: Value(resolvedRemoteId),
      remoteVersion: Value(remoteVersion),
      needsSync: Value(needsSync),
      syncedAt: syncedAt == null
          ? const Value.absent()
          : Value(syncedAt.toUtc()),
    );
    return into(timeEntries).insert(companion);
  }

  Future<void> updateTimeEntry(TimeEntry entry) async {
    final updated = entry.copyWith(
      updatedAt: DateTime.now().toUtc(),
      needsSync: true,
    );
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
      needsSync: const Value(true),
    );
    await (update(
      timeEntries,
    )..where((tbl) => tbl.id.equals(id))).write(companion);
  }

  Future<int> deleteTimeEntry(int id) {
    return (delete(timeEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<TimeEntry?> getTimeEntryByRemoteId(String remoteId) {
    return (select(
      timeEntries,
    )..where((tbl) => tbl.remoteId.equals(remoteId))).getSingleOrNull();
  }

  Future<List<TimeEntry>> getTimeEntriesNeedingSync() {
    return (select(
      timeEntries,
    )..where((tbl) => tbl.needsSync.equals(true))).get();
  }

  Future<void> assignTimeEntryRemoteId({
    required int id,
    required String remoteId,
  }) async {
    await (update(timeEntries)..where((tbl) => tbl.id.equals(id))).write(
      TimeEntriesCompanion(
        remoteId: Value(remoteId),
        needsSync: const Value(true),
      ),
    );
  }

  Future<void> markTimeEntrySynced({
    required int id,
    required int remoteVersion,
    required DateTime syncedAt,
  }) async {
    final utc = syncedAt.toUtc();
    await (update(timeEntries)..where((tbl) => tbl.id.equals(id))).write(
      TimeEntriesCompanion(
        remoteVersion: Value(remoteVersion),
        needsSync: const Value(false),
        syncedAt: Value(utc),
        updatedAt: Value(utc),
      ),
    );
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
      final remoteId = _uuid.v4();
      final companion = JournalEntriesCompanion.insert(
        entryDate: normalized,
        content: Value(content),
        createdAt: Value(now),
        updatedAt: Value(now),
        remoteId: Value(remoteId),
        remoteVersion: const Value(0),
        needsSync: const Value(true),
        syncedAt: const Value.absent(),
      );
      return into(journalEntries).insert(companion);
    }
    if (existing.remoteId == null || existing.remoteId!.isEmpty) {
      await assignJournalEntryRemoteId(id: existing.id, remoteId: _uuid.v4());
    }
    final companion = JournalEntriesCompanion(
      content: Value(content),
      updatedAt: Value(now),
      needsSync: const Value(true),
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

  Future<JournalEntry?> getJournalEntryByRemoteId(String remoteId) {
    return (select(
      journalEntries,
    )..where((tbl) => tbl.remoteId.equals(remoteId))).getSingleOrNull();
  }

  Future<List<JournalEntry>> getJournalEntriesNeedingSync() {
    return (select(
      journalEntries,
    )..where((tbl) => tbl.needsSync.equals(true))).get();
  }

  Future<void> assignJournalEntryRemoteId({
    required int id,
    required String remoteId,
  }) async {
    await (update(journalEntries)..where((tbl) => tbl.id.equals(id))).write(
      JournalEntriesCompanion(
        remoteId: Value(remoteId),
        needsSync: const Value(true),
      ),
    );
  }

  Future<void> markJournalEntrySynced({
    required int id,
    required int remoteVersion,
    required DateTime syncedAt,
  }) async {
    final utc = syncedAt.toUtc();
    await (update(journalEntries)..where((tbl) => tbl.id.equals(id))).write(
      JournalEntriesCompanion(
        remoteVersion: Value(remoteVersion),
        needsSync: const Value(false),
        syncedAt: Value(utc),
        updatedAt: Value(utc),
      ),
    );
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
    final remoteId = _uuid.v4();
    final companion = JournalTrackersCompanion.insert(
      name: name,
      description: Value(description),
      kind: Value(kind),
      sortOrder: Value(maxSortOrder + 1),
      createdAt: Value(now),
      updatedAt: Value(now),
      remoteId: Value(remoteId),
      remoteVersion: const Value(0),
      needsSync: const Value(true),
      syncedAt: const Value.absent(),
    );
    return into(journalTrackers).insert(companion);
  }

  Future<void> updateJournalTracker(JournalTracker tracker) async {
    if (tracker.remoteId == null || tracker.remoteId!.isEmpty) {
      await assignJournalTrackerRemoteId(id: tracker.id, remoteId: _uuid.v4());
    }
    final updated = tracker.copyWith(
      updatedAt: DateTime.now().toUtc(),
      needsSync: true,
    );
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
          JournalTrackersCompanion(
            sortOrder: Value(i),
            updatedAt: Value(now),
            needsSync: const Value(true),
          ),
        );
      }
    });
  }

  Future<JournalTracker?> getJournalTrackerById(int id) {
    return (select(
      journalTrackers,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<JournalTracker?> getJournalTrackerByRemoteId(String remoteId) {
    return (select(
      journalTrackers,
    )..where((tbl) => tbl.remoteId.equals(remoteId))).getSingleOrNull();
  }

  Future<List<JournalTracker>> getJournalTrackersNeedingSync() {
    return (select(
      journalTrackers,
    )..where((tbl) => tbl.needsSync.equals(true))).get();
  }

  Future<void> assignJournalTrackerRemoteId({
    required int id,
    required String remoteId,
  }) async {
    await (update(journalTrackers)..where((tbl) => tbl.id.equals(id))).write(
      JournalTrackersCompanion(
        remoteId: Value(remoteId),
        needsSync: const Value(true),
      ),
    );
  }

  Future<void> markJournalTrackerSynced({
    required int id,
    required int remoteVersion,
    required DateTime syncedAt,
  }) async {
    final utc = syncedAt.toUtc();
    await (update(journalTrackers)..where((tbl) => tbl.id.equals(id))).write(
      JournalTrackersCompanion(
        remoteVersion: Value(remoteVersion),
        needsSync: const Value(false),
        syncedAt: Value(utc),
        updatedAt: Value(utc),
      ),
    );
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
        remoteId: Value(_uuid.v4()),
        remoteVersion: const Value(0),
        needsSync: const Value(true),
        syncedAt: const Value.absent(),
      );
      await into(journalTrackerValues).insert(companion);
      return;
    }
    if (existing.remoteId == null || existing.remoteId!.isEmpty) {
      await assignJournalTrackerValueRemoteId(
        id: existing.id,
        remoteId: _uuid.v4(),
      );
    }
    await (update(
      journalTrackerValues,
    )..where((tbl) => tbl.id.equals(existing.id))).write(
      JournalTrackerValuesCompanion(
        value: Value(sanitized),
        updatedAt: Value(now),
        needsSync: const Value(true),
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

  Future<void> deleteJournalTrackerValueById(int id) async {
    await (delete(
      journalTrackerValues,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<JournalTrackerValue?> getJournalTrackerValueByRemoteId(
    String remoteId,
  ) {
    return (select(
      journalTrackerValues,
    )..where((tbl) => tbl.remoteId.equals(remoteId))).getSingleOrNull();
  }

  Future<List<JournalTrackerValue>> getJournalTrackerValuesNeedingSync() {
    return (select(
      journalTrackerValues,
    )..where((tbl) => tbl.needsSync.equals(true))).get();
  }

  Future<void> assignJournalTrackerValueRemoteId({
    required int id,
    required String remoteId,
  }) async {
    await (update(
      journalTrackerValues,
    )..where((tbl) => tbl.id.equals(id))).write(
      JournalTrackerValuesCompanion(
        remoteId: Value(remoteId),
        needsSync: const Value(true),
      ),
    );
  }

  Future<void> markJournalTrackerValueSynced({
    required int id,
    required int remoteVersion,
    required DateTime syncedAt,
  }) async {
    final utc = syncedAt.toUtc();
    await (update(
      journalTrackerValues,
    )..where((tbl) => tbl.id.equals(id))).write(
      JournalTrackerValuesCompanion(
        remoteVersion: Value(remoteVersion),
        needsSync: const Value(false),
        syncedAt: Value(utc),
        updatedAt: Value(utc),
      ),
    );
  }

  Stream<List<HabitDefinition>> watchHabits({bool includeArchived = false}) {
    final query = select(habitDefinitions)
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);
    if (!includeArchived) {
      query.where((tbl) => tbl.archived.equals(false));
    }
    return query.watch();
  }

  Future<int> createHabit({
    required String name,
    String description = '',
    HabitIntervalKind interval = HabitIntervalKind.daily,
    int targetOccurrences = 1,
    HabitValueKind measurementKind = HabitValueKind.boolean,
    double? targetValue,
  }) async {
    final now = DateTime.now().toUtc();
    final Value<double?> resolvedTargetValue = targetValue == null
        ? const Value.absent()
        : Value(targetValue);
    final remoteId = _uuid.v4();
    final companion = HabitDefinitionsCompanion.insert(
      name: name,
      description: Value(description),
      interval: Value(interval),
      targetOccurrences: Value(targetOccurrences),
      measurementKind: Value(measurementKind),
      targetValue: resolvedTargetValue,
      archived: const Value(false),
      createdAt: Value(now),
      updatedAt: Value(now),
      remoteId: Value(remoteId),
      remoteVersion: const Value(0),
      needsSync: const Value(true),
      syncedAt: const Value.absent(),
    );
    return into(habitDefinitions).insert(companion);
  }

  Future<void> updateHabit(HabitDefinition habit) async {
    if (habit.remoteId == null || habit.remoteId!.isEmpty) {
      await assignHabitRemoteId(id: habit.id, remoteId: _uuid.v4());
    }
    final updated = habit.copyWith(
      updatedAt: DateTime.now().toUtc(),
      needsSync: true,
    );
    await update(habitDefinitions).replace(updated);
  }

  Future<void> setHabitArchived({
    required int id,
    required bool archived,
  }) async {
    final current = await getHabitById(id);
    if (current != null &&
        (current.remoteId == null || current.remoteId!.isEmpty)) {
      await assignHabitRemoteId(id: id, remoteId: _uuid.v4());
    }
    await (update(habitDefinitions)..where((tbl) => tbl.id.equals(id))).write(
      HabitDefinitionsCompanion(
        archived: Value(archived),
        updatedAt: Value(DateTime.now().toUtc()),
        needsSync: const Value(true),
      ),
    );
  }

  Future<void> deleteHabit(int id) async {
    await (delete(habitDefinitions)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<HabitDefinition?> getHabitById(int id) {
    return (select(
      habitDefinitions,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<HabitDefinition?> getHabitByRemoteId(String remoteId) {
    return (select(
      habitDefinitions,
    )..where((tbl) => tbl.remoteId.equals(remoteId))).getSingleOrNull();
  }

  Future<List<HabitDefinition>> getHabitsNeedingSync() {
    return (select(
      habitDefinitions,
    )..where((tbl) => tbl.needsSync.equals(true))).get();
  }

  Future<void> assignHabitRemoteId({
    required int id,
    required String remoteId,
  }) async {
    await (update(habitDefinitions)..where((tbl) => tbl.id.equals(id))).write(
      HabitDefinitionsCompanion(
        remoteId: Value(remoteId),
        needsSync: const Value(true),
      ),
    );
  }

  Future<void> markHabitSynced({
    required int id,
    required int remoteVersion,
    required DateTime syncedAt,
  }) async {
    final utc = syncedAt.toUtc();
    await (update(habitDefinitions)..where((tbl) => tbl.id.equals(id))).write(
      HabitDefinitionsCompanion(
        remoteVersion: Value(remoteVersion),
        needsSync: const Value(false),
        syncedAt: Value(utc),
        updatedAt: Value(utc),
      ),
    );
  }

  Stream<List<HabitLog>> watchAllHabitLogs() {
    return (select(habitLogs)..orderBy([
          (tbl) => OrderingTerm.desc(tbl.occurredAt),
          (tbl) => OrderingTerm.desc(tbl.id),
        ]))
        .watch();
  }

  Stream<List<HabitLog>> watchHabitLogs(int habitId) {
    return (select(habitLogs)
          ..where((tbl) => tbl.habitId.equals(habitId))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.occurredAt),
            (tbl) => OrderingTerm.asc(tbl.id),
          ]))
        .watch();
  }

  Future<int> insertHabitLog({
    required int habitId,
    required double value,
    DateTime? occurredAt,
  }) async {
    final now = DateTime.now().toUtc();
    final timestamp = (occurredAt ?? DateTime.now()).toUtc();
    final companion = HabitLogsCompanion.insert(
      habitId: habitId,
      occurredAt: timestamp,
      value: Value(value),
      createdAt: Value(now),
      updatedAt: Value(now),
      remoteId: Value(_uuid.v4()),
      remoteVersion: const Value(0),
      needsSync: const Value(true),
      syncedAt: const Value.absent(),
    );
    final id = await into(habitLogs).insert(companion);
    final habit = await getHabitById(habitId);
    if (habit != null && (habit.remoteId == null || habit.remoteId!.isEmpty)) {
      await assignHabitRemoteId(id: habit.id, remoteId: _uuid.v4());
    }
    await (update(habitDefinitions)..where((tbl) => tbl.id.equals(habitId)))
        .write(HabitDefinitionsCompanion(updatedAt: Value(now)));
    return id;
  }

  Future<void> updateHabitLog(HabitLog log) async {
    if (log.remoteId == null || log.remoteId!.isEmpty) {
      await assignHabitLogRemoteId(id: log.id, remoteId: _uuid.v4());
    }
    final updated = log.copyWith(
      updatedAt: DateTime.now().toUtc(),
      needsSync: true,
    );
    await update(habitLogs).replace(updated);
  }

  Future<void> deleteHabitLog(int id) async {
    await (delete(habitLogs)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> deleteHabitLogsForRange({
    required int habitId,
    required DateTime start,
    required DateTime end,
  }) async {
    final utcStart = start.toUtc();
    final utcEnd = end.toUtc();
    await (delete(habitLogs)
          ..where((tbl) => tbl.habitId.equals(habitId))
          ..where((tbl) => tbl.occurredAt.isBiggerOrEqualValue(utcStart))
          ..where((tbl) => tbl.occurredAt.isSmallerThanValue(utcEnd)))
        .go();
  }

  Future<List<HabitLog>> getHabitLogsForRange({
    required int habitId,
    required DateTime start,
    required DateTime end,
  }) {
    final utcStart = start.toUtc();
    final utcEnd = end.toUtc();
    return (select(habitLogs)
          ..where((tbl) => tbl.habitId.equals(habitId))
          ..where((tbl) => tbl.occurredAt.isBiggerOrEqualValue(utcStart))
          ..where((tbl) => tbl.occurredAt.isSmallerThanValue(utcEnd))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.occurredAt),
            (tbl) => OrderingTerm.asc(tbl.id),
          ]))
        .get();
  }

  Future<HabitLog?> getHabitLogByRemoteId(String remoteId) {
    return (select(
      habitLogs,
    )..where((tbl) => tbl.remoteId.equals(remoteId))).getSingleOrNull();
  }

  Future<List<HabitLog>> getHabitLogsNeedingSync() {
    return (select(
      habitLogs,
    )..where((tbl) => tbl.needsSync.equals(true))).get();
  }

  Future<void> assignHabitLogRemoteId({
    required int id,
    required String remoteId,
  }) async {
    await (update(habitLogs)..where((tbl) => tbl.id.equals(id))).write(
      HabitLogsCompanion(
        remoteId: Value(remoteId),
        needsSync: const Value(true),
      ),
    );
  }

  Future<void> markHabitLogSynced({
    required int id,
    required int remoteVersion,
    required DateTime syncedAt,
  }) async {
    final utc = syncedAt.toUtc();
    await (update(habitLogs)..where((tbl) => tbl.id.equals(id))).write(
      HabitLogsCompanion(
        remoteVersion: Value(remoteVersion),
        needsSync: const Value(false),
        syncedAt: Value(utc),
        updatedAt: Value(utc),
      ),
    );
  }

  Stream<List<LedgerAccount>> watchLedgerAccounts() {
    return (select(
      ledgerAccounts,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.name)])).watch();
  }

  Future<int> createLedgerAccount({
    required String name,
    LedgerAccountKind accountKind = LedgerAccountKind.cash,
    String currencyCode = 'EUR',
    bool includeInNetWorth = true,
    double initialBalance = 0,
  }) async {
    final now = DateTime.now().toUtc();
    final companion = LedgerAccountsCompanion.insert(
      name: name,
      accountKind: Value(accountKind),
      currencyCode: Value(currencyCode.toUpperCase()),
      includeInNetWorth: Value(includeInNetWorth),
      initialBalance: Value(initialBalance),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    return into(ledgerAccounts).insert(companion);
  }

  Future<void> updateLedgerAccount(LedgerAccount account) async {
    final updated = account.copyWith(
      currencyCode: account.currencyCode.toUpperCase(),
      updatedAt: DateTime.now().toUtc(),
    );
    await update(ledgerAccounts).replace(updated);
  }

  Future<void> setLedgerAccountIncludeInNetWorth({
    required int id,
    required bool includeInNetWorth,
  }) async {
    await (update(ledgerAccounts)..where((tbl) => tbl.id.equals(id))).write(
      LedgerAccountsCompanion(
        includeInNetWorth: Value(includeInNetWorth),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> deleteLedgerAccount(int id) async {
    await (delete(ledgerAccounts)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<LedgerAccount?> getLedgerAccountById(int id) {
    return (select(
      ledgerAccounts,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Stream<List<LedgerCategory>> watchLedgerCategories({
    LedgerCategoryKind? categoryKind,
    int? parentId,
    bool includeArchived = false,
  }) {
    final query = select(ledgerCategories)
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.parentId),
        (tbl) => OrderingTerm.asc(tbl.name),
      ]);
    if (!includeArchived) {
      query.where((tbl) => tbl.isArchived.equals(false));
    }
    if (categoryKind != null) {
      query.where((tbl) => tbl.categoryKind.equalsValue(categoryKind));
    }
    if (parentId != null) {
      query.where((tbl) => tbl.parentId.equals(parentId));
    } else {
      query.where((tbl) => tbl.parentId.isNull());
    }
    return query.watch();
  }

  Stream<List<LedgerCategory>> watchAllLedgerCategories({
    LedgerCategoryKind? categoryKind,
    bool includeArchived = false,
  }) {
    final query = select(ledgerCategories)
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.categoryKind),
        (tbl) => OrderingTerm.asc(tbl.parentId),
        (tbl) => OrderingTerm.asc(tbl.name),
      ]);
    if (!includeArchived) {
      query.where((tbl) => tbl.isArchived.equals(false));
    }
    if (categoryKind != null) {
      query.where((tbl) => tbl.categoryKind.equalsValue(categoryKind));
    }
    return query.watch();
  }

  Stream<List<LedgerCategory>> watchLedgerSubcategories({
    required int parentId,
    bool includeArchived = false,
  }) {
    final query = select(ledgerCategories)
      ..where((tbl) => tbl.parentId.equals(parentId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);
    if (!includeArchived) {
      query.where((tbl) => tbl.isArchived.equals(false));
    }
    return query.watch();
  }

  Future<int> createLedgerCategory({
    required String name,
    required LedgerCategoryKind categoryKind,
    int? parentId,
  }) async {
    final now = DateTime.now().toUtc();
    final Value<int?> resolvedParent = parentId == null
        ? const Value.absent()
        : Value(parentId);
    final companion = LedgerCategoriesCompanion.insert(
      name: name,
      categoryKind: Value(categoryKind),
      parentId: resolvedParent,
      isArchived: const Value(false),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    return into(ledgerCategories).insert(companion);
  }

  Future<void> updateLedgerCategory(LedgerCategory category) async {
    final updated = category.copyWith(
      name: category.name.trim(),
      updatedAt: DateTime.now().toUtc(),
    );
    await update(ledgerCategories).replace(updated);
  }

  Future<void> setLedgerCategoryArchived({
    required int id,
    required bool archived,
  }) async {
    await (update(ledgerCategories)..where((tbl) => tbl.id.equals(id))).write(
      LedgerCategoriesCompanion(
        isArchived: Value(archived),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> deleteLedgerCategory(int id) async {
    await (delete(ledgerCategories)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<LedgerCategory?> getLedgerCategoryById(int id) {
    return (select(
      ledgerCategories,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Stream<List<LedgerBudget>> watchLedgerBudgets({
    LedgerBudgetPeriodKind? periodKind,
  }) {
    final query = select(ledgerBudgets)
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.year),
        (tbl) => OrderingTerm.desc(tbl.month),
        (tbl) => OrderingTerm.asc(tbl.categoryId),
      ]);
    if (periodKind != null) {
      query.where((tbl) => tbl.periodKind.equalsValue(periodKind));
    }
    return query.watch();
  }

  Future<int> upsertLedgerBudget({
    required int categoryId,
    LedgerBudgetPeriodKind periodKind = LedgerBudgetPeriodKind.monthly,
    required int year,
    int? month,
    required double amount,
    String currencyCode = 'EUR',
  }) async {
    final now = DateTime.now().toUtc();
    final Value<int?> resolvedMonth = month == null
        ? const Value.absent()
        : Value(month);
    final entry = LedgerBudgetsCompanion.insert(
      categoryId: categoryId,
      periodKind: Value(periodKind),
      year: year,
      month: resolvedMonth,
      amount: Value(amount),
      currencyCode: Value(currencyCode.toUpperCase()),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    return into(ledgerBudgets).insertOnConflictUpdate(entry);
  }

  Future<void> deleteLedgerBudget(int id) async {
    await (delete(ledgerBudgets)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<List<LedgerTransaction>> watchLedgerTransactions({
    LedgerTransactionKind? kind,
    DateTime? start,
    DateTime? end,
    bool? isPlanned,
  }) {
    final query = select(ledgerTransactions)
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.bookingDate),
        (tbl) => OrderingTerm.desc(tbl.createdAt),
      ]);
    if (kind != null) {
      query.where((tbl) => tbl.transactionKind.equalsValue(kind));
    }
    if (start != null) {
      query.where((tbl) => tbl.bookingDate.isBiggerOrEqualValue(start.toUtc()));
    }
    if (end != null) {
      query.where((tbl) => tbl.bookingDate.isSmallerOrEqualValue(end.toUtc()));
    }
    if (isPlanned != null) {
      query.where((tbl) => tbl.isPlanned.equals(isPlanned));
    }
    return query.watch();
  }

  Future<LedgerTransaction?> getLedgerTransaction(int id) {
    return (select(
      ledgerTransactions,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertLedgerTransaction({
    required LedgerTransactionKind transactionKind,
    required double amount,
    required String currencyCode,
    DateTime? bookingDate,
    bool isPlanned = false,
    int? accountId,
    int? targetAccountId,
    int? categoryId,
    int? subcategoryId,
    String description = '',
    String? cryptoSymbol,
    double? cryptoQuantity,
    double? pricePerUnit,
    double? feeAmount,
  }) {
    assert(amount >= 0, 'Amount must be positive.');
    final now = DateTime.now().toUtc();
    final Value<int?> resolvedAccount = accountId == null
        ? const Value.absent()
        : Value(accountId);
    final Value<int?> resolvedTarget = targetAccountId == null
        ? const Value.absent()
        : Value(targetAccountId);
    final Value<int?> resolvedCategory = categoryId == null
        ? const Value.absent()
        : Value(categoryId);
    final Value<int?> resolvedSubcategory = subcategoryId == null
        ? const Value.absent()
        : Value(subcategoryId);
    final Value<String?> resolvedSymbol =
        cryptoSymbol == null || cryptoSymbol.isEmpty
        ? const Value.absent()
        : Value(cryptoSymbol.toUpperCase());
    final Value<double?> resolvedQuantity = cryptoQuantity == null
        ? const Value.absent()
        : Value(cryptoQuantity);
    final Value<double?> resolvedPrice = pricePerUnit == null
        ? const Value.absent()
        : Value(pricePerUnit);
    final Value<double?> resolvedFee = feeAmount == null
        ? const Value.absent()
        : Value(feeAmount);
    final companion = LedgerTransactionsCompanion.insert(
      transactionKind: Value(transactionKind),
      amount: Value(amount),
      currencyCode: Value(currencyCode.toUpperCase()),
      bookingDate: Value((bookingDate ?? DateTime.now()).toUtc()),
      isPlanned: Value(isPlanned),
      description: Value(description),
      accountId: resolvedAccount,
      targetAccountId: resolvedTarget,
      categoryId: resolvedCategory,
      subcategoryId: resolvedSubcategory,
      cryptoSymbol: resolvedSymbol,
      cryptoQuantity: resolvedQuantity,
      pricePerUnit: resolvedPrice,
      feeAmount: resolvedFee,
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    return into(ledgerTransactions).insert(companion);
  }

  Future<void> updateLedgerTransaction(LedgerTransaction transaction) async {
    final updated = transaction.copyWith(
      currencyCode: transaction.currencyCode.toUpperCase(),
      description: transaction.description.trim(),
      cryptoSymbol: Value(transaction.cryptoSymbol?.toUpperCase()),
      updatedAt: DateTime.now().toUtc(),
    );
    await update(ledgerTransactions).replace(updated);
  }

  Future<void> deleteLedgerTransaction(int id) async {
    await (delete(ledgerTransactions)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<List<LedgerRecurringTransaction>> watchLedgerRecurringTransactions() {
    return (select(ledgerRecurringTransactions)..orderBy([
          (tbl) => OrderingTerm.asc(tbl.nextOccurrence),
          (tbl) => OrderingTerm.asc(tbl.createdAt),
        ]))
        .watch();
  }

  Future<int> createLedgerRecurringTransaction({
    required String name,
    required LedgerTransactionKind transactionKind,
    required double amount,
    required String currencyCode,
    DateTime? startedAt,
    DateTime? nextOccurrence,
    int intervalCount = 1,
    LedgerRecurringIntervalKind intervalKind =
        LedgerRecurringIntervalKind.monthly,
    int? accountId,
    int? targetAccountId,
    int? categoryId,
    int? subcategoryId,
    bool autoApply = false,
    String metadataJson = '{}',
  }) {
    assert(amount >= 0, 'Amount must be positive.');
    final now = DateTime.now().toUtc();
    final Value<int?> resolvedAccount = accountId == null
        ? const Value.absent()
        : Value(accountId);
    final Value<int?> resolvedTarget = targetAccountId == null
        ? const Value.absent()
        : Value(targetAccountId);
    final Value<int?> resolvedCategory = categoryId == null
        ? const Value.absent()
        : Value(categoryId);
    final Value<int?> resolvedSubcategory = subcategoryId == null
        ? const Value.absent()
        : Value(subcategoryId);
    final companion = LedgerRecurringTransactionsCompanion.insert(
      name: name,
      transactionKind: Value(transactionKind),
      amount: Value(amount),
      currencyCode: Value(currencyCode.toUpperCase()),
      startedAt: Value((startedAt ?? DateTime.now()).toUtc()),
      nextOccurrence: Value((nextOccurrence ?? DateTime.now()).toUtc()),
      intervalCount: Value(intervalCount),
      intervalKind: Value(intervalKind),
      accountId: resolvedAccount,
      targetAccountId: resolvedTarget,
      categoryId: resolvedCategory,
      subcategoryId: resolvedSubcategory,
      autoApply: Value(autoApply),
      metadataJson: Value(metadataJson),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    return into(ledgerRecurringTransactions).insert(companion);
  }

  Future<void> updateLedgerRecurringTransaction(
    LedgerRecurringTransaction recurring,
  ) async {
    final updated = recurring.copyWith(
      currencyCode: recurring.currencyCode.toUpperCase(),
      metadataJson: recurring.metadataJson.trim().isEmpty
          ? '{}'
          : recurring.metadataJson,
      updatedAt: DateTime.now().toUtc(),
    );
    await update(ledgerRecurringTransactions).replace(updated);
  }

  Future<void> setRecurringNextOccurrence({
    required int id,
    required DateTime nextOccurrence,
  }) async {
    await (update(
      ledgerRecurringTransactions,
    )..where((tbl) => tbl.id.equals(id))).write(
      LedgerRecurringTransactionsCompanion(
        nextOccurrence: Value(nextOccurrence.toUtc()),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> deleteLedgerRecurringTransaction(int id) async {
    await (delete(
      ledgerRecurringTransactions,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  DateTime _calculateNextOccurrence(LedgerRecurringTransaction recurring) {
    final base = recurring.nextOccurrence.toUtc();
    switch (recurring.intervalKind) {
      case LedgerRecurringIntervalKind.daily:
        return base.add(Duration(days: recurring.intervalCount));
      case LedgerRecurringIntervalKind.weekly:
        return base.add(Duration(days: 7 * recurring.intervalCount));
      case LedgerRecurringIntervalKind.monthly:
        return DateTime.utc(
          base.year,
          base.month + recurring.intervalCount,
          base.day,
          base.hour,
          base.minute,
          base.second,
          base.millisecond,
          base.microsecond,
        );
      case LedgerRecurringIntervalKind.quarterly:
        return DateTime.utc(
          base.year,
          base.month + 3 * recurring.intervalCount,
          base.day,
          base.hour,
          base.minute,
          base.second,
          base.millisecond,
          base.microsecond,
        );
      case LedgerRecurringIntervalKind.yearly:
        return DateTime.utc(
          base.year + recurring.intervalCount,
          base.month,
          base.day,
          base.hour,
          base.minute,
          base.second,
          base.millisecond,
          base.microsecond,
        );
      case LedgerRecurringIntervalKind.custom:
        return base.add(Duration(days: recurring.intervalCount));
    }
  }

  Future<int> applyRecurringTransaction({
    required LedgerRecurringTransaction recurring,
    DateTime? bookingDate,
    bool isPlanned = false,
  }) async {
    final createdId = await insertLedgerTransaction(
      transactionKind: recurring.transactionKind,
      amount: recurring.amount,
      currencyCode: recurring.currencyCode,
      bookingDate: bookingDate ?? recurring.nextOccurrence,
      isPlanned: isPlanned,
      accountId: recurring.accountId,
      targetAccountId: recurring.targetAccountId,
      categoryId: recurring.categoryId,
      subcategoryId: recurring.subcategoryId,
      description: recurring.name,
    );
    final next = _calculateNextOccurrence(recurring);
    await setRecurringNextOccurrence(id: recurring.id, nextOccurrence: next);
    return createdId;
  }

  Stream<List<CryptoPriceEntry>> watchCryptoPriceEntries() {
    return (select(cryptoPriceEntries)..orderBy([
          (tbl) => OrderingTerm.asc(tbl.symbol),
          (tbl) => OrderingTerm.asc(tbl.currencyCode),
        ]))
        .watch();
  }

  Future<CryptoPriceEntry?> getCachedCryptoPrice({
    required String symbol,
    required String currencyCode,
  }) {
    final normalizedSymbol = symbol.toUpperCase();
    final normalizedCurrency = currencyCode.toUpperCase();
    return (select(cryptoPriceEntries)
          ..where((tbl) => tbl.symbol.equals(normalizedSymbol))
          ..where((tbl) => tbl.currencyCode.equals(normalizedCurrency))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> upsertCryptoPrice({
    required String symbol,
    required String currencyCode,
    required double price,
    required DateTime fetchedAt,
  }) async {
    final normalizedSymbol = symbol.toUpperCase();
    final normalizedCurrency = currencyCode.toUpperCase();
    final existing = await getCachedCryptoPrice(
      symbol: normalizedSymbol,
      currencyCode: normalizedCurrency,
    );
    final companion = CryptoPriceEntriesCompanion(
      symbol: Value(normalizedSymbol),
      currencyCode: Value(normalizedCurrency),
      price: Value(price),
      fetchedAt: Value(fetchedAt.toUtc()),
    );
    if (existing == null) {
      await into(cryptoPriceEntries).insert(companion);
      return;
    }
    await (update(
      cryptoPriceEntries,
    )..where((tbl) => tbl.id.equals(existing.id))).write(companion.copyWith());
  }

  Future<Map<int, double>> calculateAccountBalances({
    bool includePlanned = false,
  }) async {
    final accounts = await select(ledgerAccounts).get();
    final transactions = await select(ledgerTransactions).get();
    final Map<int, double> result = {
      for (final account in accounts) account.id: account.initialBalance,
    };
    for (final transaction in transactions) {
      if (!includePlanned && transaction.isPlanned) {
        continue;
      }
      final amount = transaction.amount;
      switch (transaction.transactionKind) {
        case LedgerTransactionKind.income:
          if (transaction.accountId != null) {
            result.update(
              transaction.accountId!,
              (value) => value + amount,
              ifAbsent: () => amount,
            );
          }
          break;
        case LedgerTransactionKind.expense:
          if (transaction.accountId != null) {
            result.update(
              transaction.accountId!,
              (value) => value - amount,
              ifAbsent: () => -amount,
            );
          }
          break;
        case LedgerTransactionKind.transfer:
          if (transaction.accountId != null) {
            result.update(
              transaction.accountId!,
              (value) => value - amount,
              ifAbsent: () => -amount,
            );
          }
          if (transaction.targetAccountId != null) {
            result.update(
              transaction.targetAccountId!,
              (value) => value + amount,
              ifAbsent: () => amount,
            );
          }
          break;
        case LedgerTransactionKind.cryptoPurchase:
          if (transaction.accountId != null) {
            result.update(
              transaction.accountId!,
              (value) => value - amount,
              ifAbsent: () => -amount,
            );
          }
          break;
      }
    }
    return result;
  }

  Future<Map<String, double>> calculateNetWorthByCurrency({
    bool includePlanned = false,
  }) async {
    final accounts = await select(ledgerAccounts).get();
    final balances = await calculateAccountBalances(
      includePlanned: includePlanned,
    );
    final Map<String, double> sums = {};
    for (final account in accounts) {
      if (!account.includeInNetWorth) {
        continue;
      }
      final balance = balances[account.id] ?? account.initialBalance;
      sums.update(
        account.currencyCode.toUpperCase(),
        (value) => value + balance,
        ifAbsent: () => balance,
      );
    }
    return sums;
  }
}
