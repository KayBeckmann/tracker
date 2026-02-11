import 'dart:async';

import 'package:drift/drift.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../data/local/app_database.dart';
import '../settings/settings_keys.dart';
import '../time_tracking/time_tracking_types.dart';
import 'encryption_service.dart';
import 'sync_api_client.dart';

const String encryptionKeyStorageKey = 'encryption_key';
const String encryptionSaltStorageKey = 'encryption_salt';
const String lastSyncNotesKey = 'sync_notes_last';
const String lastSyncTasksKey = 'sync_tasks_last';
const String lastSyncTimeEntriesKey = 'sync_time_entries_last';
const String lastSyncJournalEntriesKey = 'sync_journal_entries_last';
const String lastSyncJournalTrackersKey = 'sync_journal_trackers_last';
const String lastSyncJournalTrackerValuesKey =
    'sync_journal_tracker_values_last';
const String lastSyncHabitDefinitionsKey = 'sync_habits_last';
const String lastSyncHabitLogsKey = 'sync_habit_logs_last';
const String lastSyncLedgerAccountsKey = 'sync_ledger_accounts_last';
const String lastSyncLedgerCategoriesKey = 'sync_ledger_categories_last';
const String lastSyncLedgerTransactionsKey = 'sync_ledger_transactions_last';
const String lastSyncLedgerRecurringKey = 'sync_ledger_recurring_last';
const String lastSyncLedgerBudgetsKey = 'sync_ledger_budgets_last';

class SyncEngine {
  SyncEngine({
    required this.database,
    required this.apiClient,
    required this.encryptionService,
    required this.storageBox,
  });

  final AppDatabase database;
  final SyncApiClient apiClient;
  final EncryptionService encryptionService;
  final Box<dynamic> storageBox;
  final Uuid _uuid = const Uuid();

  String? authToken;

  bool get isReady => authToken != null && encryptionService.hasKey;

  DateTime? get lastNotesSync => _readTimestamp(lastSyncNotesKey);

  DateTime? get lastTasksSync => _readTimestamp(lastSyncTasksKey);

  DateTime? get lastTimeEntriesSync => _readTimestamp(lastSyncTimeEntriesKey);

  DateTime? get lastSettingsSync => _readTimestamp(lastSyncSettingsKey);

  DateTime? get lastJournalEntriesSync =>
      _readTimestamp(lastSyncJournalEntriesKey);

  DateTime? get lastJournalTrackersSync =>
      _readTimestamp(lastSyncJournalTrackersKey);

  DateTime? get lastJournalTrackerValuesSync =>
      _readTimestamp(lastSyncJournalTrackerValuesKey);

  DateTime? get lastHabitDefinitionsSync =>
      _readTimestamp(lastSyncHabitDefinitionsKey);

  DateTime? get lastHabitLogsSync => _readTimestamp(lastSyncHabitLogsKey);

  DateTime? get lastLedgerAccountsSync =>
      _readTimestamp(lastSyncLedgerAccountsKey);

  DateTime? get lastLedgerCategoriesSync =>
      _readTimestamp(lastSyncLedgerCategoriesKey);

  DateTime? get lastLedgerTransactionsSync =>
      _readTimestamp(lastSyncLedgerTransactionsKey);

  DateTime? get lastLedgerRecurringSync =>
      _readTimestamp(lastSyncLedgerRecurringKey);

  DateTime? get lastLedgerBudgetsSync =>
      _readTimestamp(lastSyncLedgerBudgetsKey);

  void loadStoredKey() {
    encryptionService.loadKeyFromStorage(
      storageBox.get(encryptionKeyStorageKey) as String?,
    );
  }

  void storeDerivedKey() {
    final encoded = encryptionService.exportKeyToStorage();
    if (encoded == null) {
      storageBox.delete(encryptionKeyStorageKey);
    } else {
      storageBox.put(encryptionKeyStorageKey, encoded);
    }
  }

  void storeEncryptionSalt(String salt) {
    storageBox.put(encryptionSaltStorageKey, salt);
  }

  String? loadEncryptionSalt() {
    final raw = storageBox.get(encryptionSaltStorageKey);
    return raw is String ? raw : null;
  }

  Future<SyncResult> synchronize({
    ConflictResolutionStrategy strategy = ConflictResolutionStrategy.askUser,
  }) async {
    if (!isReady) {
      throw const SyncStateException('Synchronisation nicht vorbereitet.');
    }

    final token = authToken!;
    final conflicts = <SyncConflictData>[];

    await _pushTombstones(token);

    final noteConflicts = await _pushNotes(token, strategy: strategy);
    conflicts.addAll(noteConflicts);
    final taskConflicts = await _pushTasks(token, strategy: strategy);
    conflicts.addAll(taskConflicts);
    final timeConflicts = await _pushTimeEntries(token, strategy: strategy);
    conflicts.addAll(timeConflicts);
    final settingsConflicts = await _pushSettings(token, strategy: strategy);
    conflicts.addAll(settingsConflicts);
    final journalEntryConflicts = await _pushJournalEntries(token);
    conflicts.addAll(journalEntryConflicts);
    final journalTrackerConflicts = await _pushJournalTrackers(token);
    conflicts.addAll(journalTrackerConflicts);
    final journalValueConflicts = await _pushJournalTrackerValues(token);
    conflicts.addAll(journalValueConflicts);
    final habitConflicts = await _pushHabitDefinitions(token);
    conflicts.addAll(habitConflicts);
    final habitLogConflicts = await _pushHabitLogs(token);
    conflicts.addAll(habitLogConflicts);
    final ledgerAccountConflicts = await _pushLedgerAccounts(token);
    conflicts.addAll(ledgerAccountConflicts);
    final ledgerCategoryConflicts = await _pushLedgerCategories(token);
    conflicts.addAll(ledgerCategoryConflicts);
    final ledgerBudgetConflicts = await _pushLedgerBudgets(token);
    conflicts.addAll(ledgerBudgetConflicts);
    final ledgerTransactionConflicts = await _pushLedgerTransactions(token);
    conflicts.addAll(ledgerTransactionConflicts);
    final ledgerRecurringConflicts = await _pushLedgerRecurringTransactions(
      token,
    );
    conflicts.addAll(ledgerRecurringConflicts);

    // Always pull from server, even if there are conflicts.
    // This ensures deletions and updates from server are applied.
    await _pullNotes(token);
    await _pullTasks(token);
    await _pullTimeEntries(token);
    await _pullSettings(token);
    await _pullLedgerAccounts(token);
    await _pullLedgerCategories(token);
    await _pullLedgerBudgets(token);
    await _pullLedgerTransactions(token);
    await _pullLedgerRecurringTransactions(token);
    await _pullJournalEntries(token);
    await _pullJournalTrackers(token);
    await _pullJournalTrackerValues(token);
    await _pullHabitDefinitions(token);
    await _pullHabitLogs(token);

    final now = DateTime.now().toUtc();
    storageBox
      ..put(lastSyncNotesKey, now.toIso8601String())
      ..put(lastSyncTasksKey, now.toIso8601String())
      ..put(lastSyncTimeEntriesKey, now.toIso8601String())
      ..put(lastSyncSettingsKey, now.toIso8601String())
      ..put(lastSyncJournalEntriesKey, now.toIso8601String())
      ..put(lastSyncJournalTrackersKey, now.toIso8601String())
      ..put(lastSyncJournalTrackerValuesKey, now.toIso8601String())
      ..put(lastSyncHabitDefinitionsKey, now.toIso8601String())
      ..put(lastSyncHabitLogsKey, now.toIso8601String())
      ..put(lastSyncLedgerAccountsKey, now.toIso8601String())
      ..put(lastSyncLedgerCategoriesKey, now.toIso8601String())
      ..put(lastSyncLedgerBudgetsKey, now.toIso8601String())
      ..put(lastSyncLedgerTransactionsKey, now.toIso8601String())
      ..put(lastSyncLedgerRecurringKey, now.toIso8601String());

    // Return conflicts for resolution, but sync completed
    return SyncResult(conflicts: conflicts);
  }

  Future<void> applyResolution(
    SyncConflictData conflict,
    ConflictDecision decision,
  ) async {
    switch (conflict.collection) {
      case 'notes':
        final note = conflict.note;
        if (note == null) {
          return;
        }
        if (decision == ConflictDecision.keepServer) {
          await _applyServerNote(conflict);
        } else {
          await database.updateNoteEntry(
            note.copyWith(remoteVersion: conflict.server.version),
          );
        }
        break;
      case 'tasks':
        final task = conflict.task;
        if (task == null) {
          return;
        }
        if (decision == ConflictDecision.keepServer) {
          await _applyServerTask(conflict);
        } else {
          await database.updateTaskEntry(
            task.copyWith(remoteVersion: conflict.server.version),
          );
        }
        break;
      case 'time_entries':
        final entry = conflict.timeEntry;
        if (entry == null) {
          return;
        }
        if (decision == ConflictDecision.keepServer) {
          await _applyServerTimeEntry(conflict);
        } else {
          await database.updateTimeEntry(
            entry.copyWith(remoteVersion: conflict.server.version),
          );
        }
        break;
      case 'settings':
        if (decision == ConflictDecision.keepServer) {
          await _applyRemoteSettings(conflict.server, conflict.serverPayload);
        } else {
          final updatedAt =
              conflict.settingsUpdatedAt ?? DateTime.now().toUtc();
          _storeSettingsMetadata(
            remoteId: conflict.remoteId,
            remoteVersion: conflict.server.version,
            updatedAt: updatedAt,
            markDirty: true,
          );
        }
        break;
    }
  }

  Future<void> clearState() async {
    authToken = null;
    encryptionService.loadKeyFromStorage(null);
    await storageBox.delete(encryptionKeyStorageKey);
    await storageBox.delete(encryptionSaltStorageKey);
    await storageBox.delete(lastSyncNotesKey);
    await storageBox.delete(lastSyncTasksKey);
    await storageBox.delete(lastSyncTimeEntriesKey);
    await storageBox.delete(lastSyncSettingsKey);
    await storageBox.delete(lastSyncJournalEntriesKey);
    await storageBox.delete(lastSyncJournalTrackersKey);
    await storageBox.delete(lastSyncJournalTrackerValuesKey);
    await storageBox.delete(lastSyncHabitDefinitionsKey);
    await storageBox.delete(lastSyncHabitLogsKey);
    await storageBox.delete(lastSyncLedgerAccountsKey);
    await storageBox.delete(lastSyncLedgerCategoriesKey);
    await storageBox.delete(lastSyncLedgerBudgetsKey);
    await storageBox.delete(lastSyncLedgerTransactionsKey);
    await storageBox.delete(lastSyncLedgerRecurringKey);
    await storageBox.delete(settingsRemoteIdKey);
    await storageBox.delete(settingsRemoteVersionKey);
    await storageBox.delete(settingsLastUpdatedAtKey);
    await storageBox.delete(settingsDirtyKey);
  }

  Future<List<SyncConflictData>> _pushNotes(
    String token, {
    ConflictResolutionStrategy strategy = ConflictResolutionStrategy.askUser,
  }) async {
    final notes = await database.getNotesNeedingSync();
    if (notes.isEmpty) {
      return const [];
    }

    final outgoing = <Map<String, Object?>>[];
    final localPayloads = <String, Map<String, Object?>>{};
    final noteByRemoteId = <String, NoteEntry>{};

    for (var note in notes) {
      if (note.remoteId == null || note.remoteId!.isEmpty) {
        final generatedId = _uuid.v4();
        await database.assignNoteRemoteId(id: note.id, remoteId: generatedId);
        note = note.copyWith(remoteId: Value(generatedId));
      }
      final payload = _serializeNote(note);
      final ciphertext = await encryptionService.encryptMap(payload);
      final version = note.remoteVersion + 1;
      final remoteId = note.remoteId!;
      outgoing.add(<String, Object?>{
        'id': remoteId,
        'collection': 'notes',
        'ciphertext': ciphertext,
        'version': version,
        'clientUpdatedAt': note.updatedAt.toUtc().toIso8601String(),
        'deleted': false,
      });
      localPayloads[remoteId] = payload;
      noteByRemoteId[remoteId] = note;
    }

    try {
      final response = await apiClient.upsertItems(
        token: token,
        collection: 'notes',
        items: outgoing,
      );
      for (final item in response.items) {
        final note = noteByRemoteId[item.id];
        if (note != null) {
          await database.markNoteSynced(
            id: note.id,
            remoteVersion: item.version,
            syncedAt: item.updatedAt,
          );
        }
      }
      return const [];
    } on SyncConflictException catch (conflict) {
      final conflicts = <SyncConflictData>[];
      for (final entry in conflict.conflicts) {
        final serverPayload = await encryptionService.decryptToMap(
          entry.server.ciphertext,
        );
        final local =
            noteByRemoteId[entry.id] ??
            await database.getNoteByRemoteId(entry.id);
        final localPayload =
            localPayloads[entry.id] ??
            (local != null ? _serializeNote(local) : <String, Object?>{});

        final conflictData = SyncConflictData(
          collection: 'notes',
          remoteId: entry.id,
          server: entry.server,
          serverPayload: serverPayload,
          localPayload: localPayload,
          note: local,
        );

        // Auto-resolve basierend auf Strategie
        if (strategy == ConflictResolutionStrategy.serverWins) {
          await _applyServerNote(conflictData);
        } else if (strategy == ConflictResolutionStrategy.localWins) {
          if (local != null) {
            // remoteVersion aktualisieren, damit nächster Push erfolgreich ist
            await database.updateNoteEntry(
              local.copyWith(remoteVersion: entry.server.version),
            );
          }
        } else {
          conflicts.add(conflictData);
        }
      }
      return conflicts;
    }
  }

  Future<List<SyncConflictData>> _pushTasks(
    String token, {
    ConflictResolutionStrategy strategy = ConflictResolutionStrategy.askUser,
  }) async {
    final tasks = await database.getTasksNeedingSync();
    if (tasks.isEmpty) {
      return const [];
    }

    final outgoing = <Map<String, Object?>>[];
    final localPayloads = <String, Map<String, Object?>>{};
    final taskByRemoteId = <String, TaskEntry>{};

    for (var task in tasks) {
      if (task.remoteId == null || task.remoteId!.isEmpty) {
        final generatedId = _uuid.v4();
        await database.assignTaskRemoteId(id: task.id, remoteId: generatedId);
        task = task.copyWith(remoteId: Value(generatedId));
      }
      final payload = await _serializeTask(task);
      final ciphertext = await encryptionService.encryptMap(payload);
      final version = task.remoteVersion + 1;
      final remoteId = task.remoteId!;
      outgoing.add(<String, Object?>{
        'id': remoteId,
        'collection': 'tasks',
        'ciphertext': ciphertext,
        'version': version,
        'clientUpdatedAt': task.updatedAt.toUtc().toIso8601String(),
        'deleted': false,
      });
      localPayloads[remoteId] = payload;
      taskByRemoteId[remoteId] = task;
    }

    try {
      final response = await apiClient.upsertItems(
        token: token,
        collection: 'tasks',
        items: outgoing,
      );
      for (final item in response.items) {
        final task = taskByRemoteId[item.id];
        if (task != null) {
          await database.markTaskSynced(
            id: task.id,
            remoteVersion: item.version,
            syncedAt: item.updatedAt,
          );
        }
      }
      return const [];
    } on SyncConflictException catch (conflict) {
      final conflicts = <SyncConflictData>[];
      for (final entry in conflict.conflicts) {
        final serverPayload = await encryptionService.decryptToMap(
          entry.server.ciphertext,
        );
        final local =
            taskByRemoteId[entry.id] ??
            await database.getTaskByRemoteId(entry.id);
        final localPayload =
            localPayloads[entry.id] ??
            (local != null ? await _serializeTask(local) : <String, Object?>{});

        final conflictData = SyncConflictData(
          collection: 'tasks',
          remoteId: entry.id,
          server: entry.server,
          serverPayload: serverPayload,
          localPayload: localPayload,
          task: local,
        );

        // Auto-resolve basierend auf Strategie
        if (strategy == ConflictResolutionStrategy.serverWins) {
          await _applyServerTask(conflictData);
        } else if (strategy == ConflictResolutionStrategy.localWins) {
          if (local != null) {
            await database.updateTaskEntry(
              local.copyWith(remoteVersion: entry.server.version),
            );
          }
        } else {
          conflicts.add(conflictData);
        }
      }
      return conflicts;
    }
  }

  Future<List<SyncConflictData>> _pushTimeEntries(
    String token, {
    ConflictResolutionStrategy strategy = ConflictResolutionStrategy.askUser,
  }) async {
    final entries = await database.getTimeEntriesNeedingSync();
    if (entries.isEmpty) {
      return const [];
    }

    final outgoing = <Map<String, Object?>>[];
    final localPayloads = <String, Map<String, Object?>>{};
    final entryByRemoteId = <String, TimeEntry>{};

    for (var entry in entries) {
      if (entry.remoteId == null || entry.remoteId!.isEmpty) {
        final generatedId = _uuid.v4();
        await database.assignTimeEntryRemoteId(
          id: entry.id,
          remoteId: generatedId,
        );
        entry = entry.copyWith(remoteId: Value(generatedId));
      }
      final payload = await _serializeTimeEntry(entry);
      final ciphertext = await encryptionService.encryptMap(payload);
      final version = entry.remoteVersion + 1;
      final remoteId = entry.remoteId!;
      outgoing.add(<String, Object?>{
        'id': remoteId,
        'collection': 'time_entries',
        'ciphertext': ciphertext,
        'version': version,
        'clientUpdatedAt': entry.updatedAt.toUtc().toIso8601String(),
        'deleted': false,
      });
      localPayloads[remoteId] = payload;
      entryByRemoteId[remoteId] = entry;
    }

    try {
      final response = await apiClient.upsertItems(
        token: token,
        collection: 'time_entries',
        items: outgoing,
      );
      for (final item in response.items) {
        final entry = entryByRemoteId[item.id];
        if (entry != null) {
          await database.markTimeEntrySynced(
            id: entry.id,
            remoteVersion: item.version,
            syncedAt: item.updatedAt,
          );
        }
      }
      return const [];
    } on SyncConflictException catch (conflict) {
      final conflicts = <SyncConflictData>[];
      for (final entry in conflict.conflicts) {
        final serverPayload = await encryptionService.decryptToMap(
          entry.server.ciphertext,
        );
        final local =
            entryByRemoteId[entry.id] ??
            await database.getTimeEntryByRemoteId(entry.id);
        final localPayload =
            localPayloads[entry.id] ??
            (local != null
                ? await _serializeTimeEntry(local)
                : <String, Object?>{});

        final conflictData = SyncConflictData(
          collection: 'time_entries',
          remoteId: entry.id,
          server: entry.server,
          serverPayload: serverPayload,
          localPayload: localPayload,
          timeEntry: local,
        );

        // Auto-resolve basierend auf Strategie
        if (strategy == ConflictResolutionStrategy.serverWins) {
          await _applyServerTimeEntry(conflictData);
        } else if (strategy == ConflictResolutionStrategy.localWins) {
          if (local != null) {
            await database.updateTimeEntry(
              local.copyWith(remoteVersion: entry.server.version),
            );
          }
        } else {
          conflicts.add(conflictData);
        }
      }
      return conflicts;
    }
  }

  Future<List<SyncConflictData>> _pushSettings(
    String token, {
    ConflictResolutionStrategy strategy = ConflictResolutionStrategy.askUser,
  }) async {
    if (!_isSettingsDirty) {
      return const [];
    }

    final DateTime updatedAt = _ensureSettingsUpdatedAt();
    final payload = _serializeSettingsPayload(updatedAt: updatedAt);
    final ciphertext = await encryptionService.encryptMap(payload);
    final String remoteId = _settingsRemoteId ?? _uuid.v4();
    final int version = _settingsRemoteVersion + 1;

    final outgoing = <String, Object?>{
      'id': remoteId,
      'collection': 'settings',
      'ciphertext': ciphertext,
      'version': version,
      'clientUpdatedAt': updatedAt.toIso8601String(),
      'deleted': false,
    };

    try {
      final response = await apiClient.upsertItems(
        token: token,
        collection: 'settings',
        items: <Map<String, Object?>>[outgoing],
      );
      if (response.items.isNotEmpty) {
        final item = response.items.first;
        _storeSettingsMetadata(
          remoteId: item.id,
          remoteVersion: item.version,
          updatedAt: item.updatedAt,
        );
      } else {
        _storeSettingsMetadata(
          remoteId: remoteId,
          remoteVersion: version,
          updatedAt: updatedAt,
        );
      }
      return const [];
    } on SyncConflictException catch (conflict) {
      final conflicts = <SyncConflictData>[];
      for (final entry in conflict.conflicts) {
        final serverPayload = await encryptionService.decryptToMap(
          entry.server.ciphertext,
        );

        final conflictData = SyncConflictData(
          collection: 'settings',
          remoteId: entry.id,
          server: entry.server,
          serverPayload: serverPayload,
          localPayload: payload,
          settingsUpdatedAt: updatedAt,
        );

        // Auto-resolve basierend auf Strategie
        if (strategy == ConflictResolutionStrategy.serverWins) {
          await _applyRemoteSettings(entry.server, serverPayload);
        } else if (strategy == ConflictResolutionStrategy.localWins) {
          // remoteVersion aktualisieren, damit nächster Push erfolgreich ist
          _storeSettingsMetadata(
            remoteId: entry.id,
            remoteVersion: entry.server.version,
            updatedAt: updatedAt,
            markDirty: true,
          );
        } else {
          conflicts.add(conflictData);
        }
      }
      return conflicts;
    }
  }

  Future<void> _pushTombstones(String token) async {
    final tombstones = await database.getPendingTombstones();
    if (tombstones.isEmpty) {
      return;
    }

    final Map<String, List<_PendingTombstone>> grouped =
        <String, List<_PendingTombstone>>{};
    for (final tombstone in tombstones) {
      final ciphertext = await encryptionService.encryptMap(<String, Object?>{
        'deleted': true,
      });
      grouped
          .putIfAbsent(tombstone.collection, () => <_PendingTombstone>[])
          .add(_PendingTombstone(tombstone: tombstone, ciphertext: ciphertext));
    }

    for (final entry in grouped.entries) {
      final collection = entry.key;
      final attempts = entry.value;
      if (attempts.isEmpty) {
        continue;
      }
      final items = <Map<String, Object?>>[];
      final tombstoneIds = <int>[];
      for (final pending in attempts) {
        items.add(<String, Object?>{
          'id': pending.tombstone.remoteId,
          'collection': collection,
          'ciphertext': pending.ciphertext,
          'version': pending.tombstone.version,
          'clientUpdatedAt': pending.tombstone.clientUpdatedAt
              .toUtc()
              .toIso8601String(),
          'deleted': true,
        });
        tombstoneIds.add(pending.tombstone.id);
      }

      try {
        await apiClient.upsertItems(
          token: token,
          collection: collection,
          items: items,
        );
        await database.deleteTombstonesByIds(tombstoneIds);
      } on SyncConflictException catch (conflict) {
        for (final entryConflict in conflict.conflicts) {
          final payload = await encryptionService.decryptToMap(
            entryConflict.server.ciphertext,
          );
          await _applyRemoteForCollection(
            collection: collection,
            item: entryConflict.server,
            payload: payload,
          );
        }
        await database.deleteTombstonesByIds(tombstoneIds);
      }
    }
  }

  Future<List<SyncConflictData>> _pushJournalEntries(String token) async {
    final entries = await database.getJournalEntriesNeedingSync();
    if (entries.isEmpty) {
      return const [];
    }

    final outgoing = <Map<String, Object?>>[];
    final entryByRemoteId = <String, JournalEntry>{};

    for (var entry in entries) {
      if (entry.remoteId == null || entry.remoteId!.isEmpty) {
        final generatedId = _uuid.v4();
        await database.assignJournalEntryRemoteId(
          id: entry.id,
          remoteId: generatedId,
        );
        entry = entry.copyWith(remoteId: Value(generatedId));
      }
      final payload = _serializeJournalEntry(entry);
      final ciphertext = await encryptionService.encryptMap(payload);
      final version = entry.remoteVersion + 1;
      final remoteId = entry.remoteId!;
      outgoing.add(<String, Object?>{
        'id': remoteId,
        'collection': 'journal_entries',
        'ciphertext': ciphertext,
        'version': version,
        'clientUpdatedAt': entry.updatedAt.toUtc().toIso8601String(),
        'deleted': false,
      });
      entryByRemoteId[remoteId] = entry;
    }

    try {
      final response = await apiClient.upsertItems(
        token: token,
        collection: 'journal_entries',
        items: outgoing,
      );
      for (final item in response.items) {
        final entry = entryByRemoteId[item.id];
        if (entry != null) {
          await database.markJournalEntrySynced(
            id: entry.id,
            remoteVersion: item.version,
            syncedAt: item.updatedAt,
          );
        }
      }
    } on SyncConflictException catch (conflict) {
      for (final entry in conflict.conflicts) {
        final payload = await encryptionService.decryptToMap(
          entry.server.ciphertext,
        );
        await _applyRemoteJournalEntry(entry.server, payload);
      }
    }

    return const [];
  }

  Future<List<SyncConflictData>> _pushJournalTrackers(String token) async {
    final trackers = await database.getJournalTrackersNeedingSync();
    if (trackers.isEmpty) {
      return const [];
    }

    final outgoing = <Map<String, Object?>>[];
    final trackerByRemoteId = <String, JournalTracker>{};

    for (var tracker in trackers) {
      if (tracker.remoteId == null || tracker.remoteId!.isEmpty) {
        final generatedId = _uuid.v4();
        await database.assignJournalTrackerRemoteId(
          id: tracker.id,
          remoteId: generatedId,
        );
        tracker = tracker.copyWith(remoteId: Value(generatedId));
      }
      final payload = _serializeJournalTracker(tracker);
      final ciphertext = await encryptionService.encryptMap(payload);
      final version = tracker.remoteVersion + 1;
      final remoteId = tracker.remoteId!;
      outgoing.add(<String, Object?>{
        'id': remoteId,
        'collection': 'journal_trackers',
        'ciphertext': ciphertext,
        'version': version,
        'clientUpdatedAt': tracker.updatedAt.toUtc().toIso8601String(),
        'deleted': false,
      });
      trackerByRemoteId[remoteId] = tracker;
    }

    try {
      final response = await apiClient.upsertItems(
        token: token,
        collection: 'journal_trackers',
        items: outgoing,
      );
      for (final item in response.items) {
        final tracker = trackerByRemoteId[item.id];
        if (tracker != null) {
          await database.markJournalTrackerSynced(
            id: tracker.id,
            remoteVersion: item.version,
            syncedAt: item.updatedAt,
          );
        }
      }
    } on SyncConflictException catch (conflict) {
      for (final entry in conflict.conflicts) {
        final payload = await encryptionService.decryptToMap(
          entry.server.ciphertext,
        );
        await _applyRemoteJournalTracker(entry.server, payload);
      }
    }

    return const [];
  }

  Future<List<SyncConflictData>> _pushJournalTrackerValues(String token) async {
    final values = await database.getJournalTrackerValuesNeedingSync();
    if (values.isEmpty) {
      return const [];
    }

    final outgoing = <Map<String, Object?>>[];
    final valueByRemoteId = <String, JournalTrackerValue>{};

    for (var value in values) {
      if (value.remoteId == null || value.remoteId!.isEmpty) {
        final generatedId = _uuid.v4();
        await database.assignJournalTrackerValueRemoteId(
          id: value.id,
          remoteId: generatedId,
        );
        value = value.copyWith(remoteId: Value(generatedId));
      }
      var tracker = await database.getJournalTrackerById(value.trackerId);
      if (tracker == null) {
        continue;
      }
      if (tracker.remoteId == null || tracker.remoteId!.isEmpty) {
        await database.assignJournalTrackerRemoteId(
          id: tracker.id,
          remoteId: _uuid.v4(),
        );
        tracker = await database.getJournalTrackerById(tracker.id);
        if (tracker == null) {
          continue;
        }
      }
      final trackerRemoteId = tracker.remoteId;
      if (trackerRemoteId == null || trackerRemoteId.isEmpty) {
        continue;
      }

      final payload = _serializeJournalTrackerValue(value, trackerRemoteId);
      final ciphertext = await encryptionService.encryptMap(payload);
      final version = value.remoteVersion + 1;
      final remoteId = value.remoteId!;
      outgoing.add(<String, Object?>{
        'id': remoteId,
        'collection': 'journal_tracker_values',
        'ciphertext': ciphertext,
        'version': version,
        'clientUpdatedAt': value.updatedAt.toUtc().toIso8601String(),
        'deleted': false,
      });
      valueByRemoteId[remoteId] = value;
    }

    try {
      final response = await apiClient.upsertItems(
        token: token,
        collection: 'journal_tracker_values',
        items: outgoing,
      );
      for (final item in response.items) {
        final value = valueByRemoteId[item.id];
        if (value != null) {
          await database.markJournalTrackerValueSynced(
            id: value.id,
            remoteVersion: item.version,
            syncedAt: item.updatedAt,
          );
        }
      }
    } on SyncConflictException catch (conflict) {
      for (final entry in conflict.conflicts) {
        final payload = await encryptionService.decryptToMap(
          entry.server.ciphertext,
        );
        await _applyRemoteJournalTrackerValue(entry.server, payload);
      }
    }

    return const [];
  }

  Future<List<SyncConflictData>> _pushHabitDefinitions(String token) async {
    final habits = await database.getHabitsNeedingSync();
    if (habits.isEmpty) {
      return const [];
    }

    final outgoing = <Map<String, Object?>>[];
    final habitByRemoteId = <String, HabitDefinition>{};

    for (var habit in habits) {
      if (habit.remoteId == null || habit.remoteId!.isEmpty) {
        final generatedId = _uuid.v4();
        await database.assignHabitRemoteId(id: habit.id, remoteId: generatedId);
        habit = habit.copyWith(remoteId: Value(generatedId));
      }
      final payload = _serializeHabitDefinition(habit);
      final ciphertext = await encryptionService.encryptMap(payload);
      final version = habit.remoteVersion + 1;
      final remoteId = habit.remoteId!;
      outgoing.add(<String, Object?>{
        'id': remoteId,
        'collection': 'habits',
        'ciphertext': ciphertext,
        'version': version,
        'clientUpdatedAt': habit.updatedAt.toUtc().toIso8601String(),
        'deleted': false,
      });
      habitByRemoteId[remoteId] = habit;
    }

    try {
      final response = await apiClient.upsertItems(
        token: token,
        collection: 'habits',
        items: outgoing,
      );
      for (final item in response.items) {
        final habit = habitByRemoteId[item.id];
        if (habit != null) {
          await database.markHabitSynced(
            id: habit.id,
            remoteVersion: item.version,
            syncedAt: item.updatedAt,
          );
        }
      }
    } on SyncConflictException catch (conflict) {
      for (final entry in conflict.conflicts) {
        final payload = await encryptionService.decryptToMap(
          entry.server.ciphertext,
        );
        await _applyRemoteHabit(entry.server, payload);
      }
    }

    return const [];
  }

  Future<List<SyncConflictData>> _pushHabitLogs(String token) async {
    final logs = await database.getHabitLogsNeedingSync();
    if (logs.isEmpty) {
      return const [];
    }

    final outgoing = <Map<String, Object?>>[];
    final logByRemoteId = <String, HabitLog>{};

    for (var log in logs) {
      if (log.remoteId == null || log.remoteId!.isEmpty) {
        final generatedId = _uuid.v4();
        await database.assignHabitLogRemoteId(
          id: log.id,
          remoteId: generatedId,
        );
        log = log.copyWith(remoteId: Value(generatedId));
      }
      var habit = await database.getHabitById(log.habitId);
      if (habit == null) {
        continue;
      }
      if (habit.remoteId == null || habit.remoteId!.isEmpty) {
        await database.assignHabitRemoteId(id: habit.id, remoteId: _uuid.v4());
        habit = await database.getHabitById(habit.id);
        if (habit == null) {
          continue;
        }
      }
      final habitRemoteId = habit.remoteId;
      if (habitRemoteId == null || habitRemoteId.isEmpty) {
        continue;
      }
      final payload = _serializeHabitLog(log, habitRemoteId);
      final ciphertext = await encryptionService.encryptMap(payload);
      final version = log.remoteVersion + 1;
      final remoteId = log.remoteId!;
      outgoing.add(<String, Object?>{
        'id': remoteId,
        'collection': 'habit_logs',
        'ciphertext': ciphertext,
        'version': version,
        'clientUpdatedAt': log.updatedAt.toUtc().toIso8601String(),
        'deleted': false,
      });
      logByRemoteId[remoteId] = log;
    }

    try {
      final response = await apiClient.upsertItems(
        token: token,
        collection: 'habit_logs',
        items: outgoing,
      );
      for (final item in response.items) {
        final log = logByRemoteId[item.id];
        if (log != null) {
          await database.markHabitLogSynced(
            id: log.id,
            remoteVersion: item.version,
            syncedAt: item.updatedAt,
          );
        }
      }
    } on SyncConflictException catch (conflict) {
      for (final entry in conflict.conflicts) {
        final payload = await encryptionService.decryptToMap(
          entry.server.ciphertext,
        );
        await _applyRemoteHabitLog(entry.server, payload);
      }
    }

    return const [];
  }

  Future<List<SyncConflictData>> _pushLedgerAccounts(String token) async {
    final accounts = await database.getLedgerAccountsNeedingSync();
    if (accounts.isEmpty) {
      return const [];
    }

    final outgoing = <Map<String, Object?>>[];
    final accountByRemoteId = <String, LedgerAccount>{};

    for (var account in accounts) {
      if (account.remoteId == null || account.remoteId!.isEmpty) {
        final generatedId = _uuid.v4();
        await database.assignLedgerAccountRemoteId(
          id: account.id,
          remoteId: generatedId,
        );
        account = account.copyWith(remoteId: Value(generatedId));
      }
      final payload = _serializeLedgerAccount(account);
      final ciphertext = await encryptionService.encryptMap(payload);
      final version = account.remoteVersion + 1;
      final remoteId = account.remoteId!;
      outgoing.add(<String, Object?>{
        'id': remoteId,
        'collection': 'ledger_accounts',
        'ciphertext': ciphertext,
        'version': version,
        'clientUpdatedAt': account.updatedAt.toUtc().toIso8601String(),
        'deleted': false,
      });
      accountByRemoteId[remoteId] = account;
    }

    try {
      final response = await apiClient.upsertItems(
        token: token,
        collection: 'ledger_accounts',
        items: outgoing,
      );
      for (final item in response.items) {
        final account = accountByRemoteId[item.id];
        if (account != null) {
          await database.markLedgerAccountSynced(
            id: account.id,
            remoteVersion: item.version,
            syncedAt: item.updatedAt,
          );
        }
      }
    } on SyncConflictException catch (conflict) {
      for (final entry in conflict.conflicts) {
        final payload = await encryptionService.decryptToMap(
          entry.server.ciphertext,
        );
        await _applyRemoteLedgerAccount(entry.server, payload);
      }
    }

    return const [];
  }

  Future<List<SyncConflictData>> _pushLedgerCategories(String token) async {
    final categories = await database.getLedgerCategoriesNeedingSync();
    if (categories.isEmpty) {
      return const [];
    }

    final outgoing = <Map<String, Object?>>[];
    final categoryByRemoteId = <String, LedgerCategory>{};

    for (var category in categories) {
      if (category.remoteId == null || category.remoteId!.isEmpty) {
        final generatedId = _uuid.v4();
        await database.assignLedgerCategoryRemoteId(
          id: category.id,
          remoteId: generatedId,
        );
        category = category.copyWith(remoteId: Value(generatedId));
      }
      if (category.parentId != null) {
        final parent = await database.getLedgerCategoryById(category.parentId!);
        if (parent != null &&
            (parent.remoteId == null || parent.remoteId!.isEmpty)) {
          await database.assignLedgerCategoryRemoteId(
            id: parent.id,
            remoteId: _uuid.v4(),
          );
        }
      }
      final payload = await _serializeLedgerCategory(category);
      final ciphertext = await encryptionService.encryptMap(payload);
      final version = category.remoteVersion + 1;
      final remoteId = category.remoteId!;
      outgoing.add(<String, Object?>{
        'id': remoteId,
        'collection': 'ledger_categories',
        'ciphertext': ciphertext,
        'version': version,
        'clientUpdatedAt': category.updatedAt.toUtc().toIso8601String(),
        'deleted': false,
      });
      categoryByRemoteId[remoteId] = category;
    }

    try {
      final response = await apiClient.upsertItems(
        token: token,
        collection: 'ledger_categories',
        items: outgoing,
      );
      for (final item in response.items) {
        final category = categoryByRemoteId[item.id];
        if (category != null) {
          await database.markLedgerCategorySynced(
            id: category.id,
            remoteVersion: item.version,
            syncedAt: item.updatedAt,
          );
        }
      }
    } on SyncConflictException catch (conflict) {
      for (final entry in conflict.conflicts) {
        final payload = await encryptionService.decryptToMap(
          entry.server.ciphertext,
        );
        await _applyRemoteLedgerCategory(entry.server, payload);
      }
    }

    return const [];
  }

  Future<List<SyncConflictData>> _pushLedgerBudgets(String token) async {
    final budgets = await database.getLedgerBudgetsNeedingSync();
    if (budgets.isEmpty) {
      return const [];
    }

    final outgoing = <Map<String, Object?>>[];
    final budgetByRemoteId = <String, LedgerBudget>{};

    for (var budget in budgets) {
      if (budget.remoteId == null || budget.remoteId!.isEmpty) {
        final generatedId = _uuid.v4();
        await database.assignLedgerBudgetRemoteId(
          id: budget.id,
          remoteId: generatedId,
        );
        budget = budget.copyWith(remoteId: Value(generatedId));
      }
      final payload = await _serializeLedgerBudget(budget);
      if (payload == null) {
        continue;
      }
      final ciphertext = await encryptionService.encryptMap(payload);
      final version = budget.remoteVersion + 1;
      final remoteId = budget.remoteId!;
      outgoing.add(<String, Object?>{
        'id': remoteId,
        'collection': 'ledger_budgets',
        'ciphertext': ciphertext,
        'version': version,
        'clientUpdatedAt': budget.updatedAt.toUtc().toIso8601String(),
        'deleted': false,
      });
      budgetByRemoteId[remoteId] = budget;
    }

    if (outgoing.isEmpty) {
      return const [];
    }

    try {
      final response = await apiClient.upsertItems(
        token: token,
        collection: 'ledger_budgets',
        items: outgoing,
      );
      for (final item in response.items) {
        final budget = budgetByRemoteId[item.id];
        if (budget != null) {
          await database.markLedgerBudgetSynced(
            id: budget.id,
            remoteVersion: item.version,
            syncedAt: item.updatedAt,
          );
        }
      }
    } on SyncConflictException catch (conflict) {
      for (final entry in conflict.conflicts) {
        final payload = await encryptionService.decryptToMap(
          entry.server.ciphertext,
        );
        await _applyRemoteLedgerBudget(entry.server, payload);
      }
    }

    return const [];
  }

  Future<List<SyncConflictData>> _pushLedgerTransactions(String token) async {
    final transactions = await database.getLedgerTransactionsNeedingSync();
    if (transactions.isEmpty) {
      return const [];
    }

    final outgoing = <Map<String, Object?>>[];
    final transactionByRemoteId = <String, LedgerTransaction>{};

    for (var transaction in transactions) {
      if (transaction.remoteId == null || transaction.remoteId!.isEmpty) {
        final generatedId = _uuid.v4();
        await database.assignLedgerTransactionRemoteId(
          id: transaction.id,
          remoteId: generatedId,
        );
        transaction = transaction.copyWith(remoteId: Value(generatedId));
      }
      if (transaction.accountId != null) {
        final account = await database.getLedgerAccountById(
          transaction.accountId!,
        );
        if (account != null &&
            (account.remoteId == null || account.remoteId!.isEmpty)) {
          await database.assignLedgerAccountRemoteId(
            id: account.id,
            remoteId: _uuid.v4(),
          );
        }
      }
      if (transaction.targetAccountId != null) {
        final account = await database.getLedgerAccountById(
          transaction.targetAccountId!,
        );
        if (account != null &&
            (account.remoteId == null || account.remoteId!.isEmpty)) {
          await database.assignLedgerAccountRemoteId(
            id: account.id,
            remoteId: _uuid.v4(),
          );
        }
      }
      if (transaction.categoryId != null) {
        final category = await database.getLedgerCategoryById(
          transaction.categoryId!,
        );
        if (category != null &&
            (category.remoteId == null || category.remoteId!.isEmpty)) {
          await database.assignLedgerCategoryRemoteId(
            id: category.id,
            remoteId: _uuid.v4(),
          );
        }
      }
      if (transaction.subcategoryId != null) {
        final category = await database.getLedgerCategoryById(
          transaction.subcategoryId!,
        );
        if (category != null &&
            (category.remoteId == null || category.remoteId!.isEmpty)) {
          await database.assignLedgerCategoryRemoteId(
            id: category.id,
            remoteId: _uuid.v4(),
          );
        }
      }
      final payload = await _serializeLedgerTransaction(transaction);
      final ciphertext = await encryptionService.encryptMap(payload);
      final version = transaction.remoteVersion + 1;
      final remoteId = transaction.remoteId!;
      outgoing.add(<String, Object?>{
        'id': remoteId,
        'collection': 'ledger_transactions',
        'ciphertext': ciphertext,
        'version': version,
        'clientUpdatedAt': transaction.updatedAt.toUtc().toIso8601String(),
        'deleted': false,
      });
      transactionByRemoteId[remoteId] = transaction;
    }

    try {
      final response = await apiClient.upsertItems(
        token: token,
        collection: 'ledger_transactions',
        items: outgoing,
      );
      for (final item in response.items) {
        final transaction = transactionByRemoteId[item.id];
        if (transaction != null) {
          await database.markLedgerTransactionSynced(
            id: transaction.id,
            remoteVersion: item.version,
            syncedAt: item.updatedAt,
          );
        }
      }
    } on SyncConflictException catch (conflict) {
      for (final entry in conflict.conflicts) {
        final payload = await encryptionService.decryptToMap(
          entry.server.ciphertext,
        );
        await _applyRemoteLedgerTransaction(entry.server, payload);
      }
    }

    return const [];
  }

  Future<List<SyncConflictData>> _pushLedgerRecurringTransactions(
    String token,
  ) async {
    final recurring = await database
        .getLedgerRecurringTransactionsNeedingSync();
    if (recurring.isEmpty) {
      return const [];
    }

    final outgoing = <Map<String, Object?>>[];
    final recurringByRemoteId = <String, LedgerRecurringTransaction>{};

    for (var entry in recurring) {
      if (entry.remoteId == null || entry.remoteId!.isEmpty) {
        final generatedId = _uuid.v4();
        await database.assignLedgerRecurringRemoteId(
          id: entry.id,
          remoteId: generatedId,
        );
        entry = entry.copyWith(remoteId: Value(generatedId));
      }
      if (entry.accountId != null) {
        final account = await database.getLedgerAccountById(entry.accountId!);
        if (account != null &&
            (account.remoteId == null || account.remoteId!.isEmpty)) {
          await database.assignLedgerAccountRemoteId(
            id: account.id,
            remoteId: _uuid.v4(),
          );
        }
      }
      if (entry.targetAccountId != null) {
        final account = await database.getLedgerAccountById(
          entry.targetAccountId!,
        );
        if (account != null &&
            (account.remoteId == null || account.remoteId!.isEmpty)) {
          await database.assignLedgerAccountRemoteId(
            id: account.id,
            remoteId: _uuid.v4(),
          );
        }
      }
      if (entry.categoryId != null) {
        final category = await database.getLedgerCategoryById(
          entry.categoryId!,
        );
        if (category != null &&
            (category.remoteId == null || category.remoteId!.isEmpty)) {
          await database.assignLedgerCategoryRemoteId(
            id: category.id,
            remoteId: _uuid.v4(),
          );
        }
      }
      if (entry.subcategoryId != null) {
        final category = await database.getLedgerCategoryById(
          entry.subcategoryId!,
        );
        if (category != null &&
            (category.remoteId == null || category.remoteId!.isEmpty)) {
          await database.assignLedgerCategoryRemoteId(
            id: category.id,
            remoteId: _uuid.v4(),
          );
        }
      }
      final payload = await _serializeLedgerRecurringTransaction(entry);
      final ciphertext = await encryptionService.encryptMap(payload);
      final version = entry.remoteVersion + 1;
      final remoteId = entry.remoteId!;
      outgoing.add(<String, Object?>{
        'id': remoteId,
        'collection': 'ledger_recurring_transactions',
        'ciphertext': ciphertext,
        'version': version,
        'clientUpdatedAt': entry.updatedAt.toUtc().toIso8601String(),
        'deleted': false,
      });
      recurringByRemoteId[remoteId] = entry;
    }

    try {
      final response = await apiClient.upsertItems(
        token: token,
        collection: 'ledger_recurring_transactions',
        items: outgoing,
      );
      for (final item in response.items) {
        final entry = recurringByRemoteId[item.id];
        if (entry != null) {
          await database.markLedgerRecurringTransactionSynced(
            id: entry.id,
            remoteVersion: item.version,
            syncedAt: item.updatedAt,
          );
        }
      }
    } on SyncConflictException catch (conflict) {
      for (final entry in conflict.conflicts) {
        final payload = await encryptionService.decryptToMap(
          entry.server.ciphertext,
        );
        await _applyRemoteLedgerRecurringTransaction(entry.server, payload);
      }
    }

    return const [];
  }

  Future<void> _pullNotes(String token) async {
    final since = lastNotesSync;
    final remoteItems = await apiClient.fetchItems(
      token: token,
      collection: 'notes',
      since: since,
    );
    for (final item in remoteItems) {
      if (item.deleted) {
        final local = await database.getNoteByRemoteId(item.id);
        if (local != null) {
          await database.deleteNoteEntry(local.id);
        }
        continue;
      }
      final payload = await encryptionService.decryptToMap(item.ciphertext);
      await _applyRemoteNote(item, payload);
    }
  }

  Future<void> _pullTasks(String token) async {
    final since = lastTasksSync;
    final remoteItems = await apiClient.fetchItems(
      token: token,
      collection: 'tasks',
      since: since,
    );
    for (final item in remoteItems) {
      if (item.deleted) {
        final local = await database.getTaskByRemoteId(item.id);
        if (local != null) {
          await database.deleteTaskEntry(local.id);
        }
        continue;
      }
      final payload = await encryptionService.decryptToMap(item.ciphertext);
      await _applyRemoteTask(item, payload);
    }
  }

  Future<void> _pullTimeEntries(String token) async {
    final since = lastTimeEntriesSync;
    final remoteItems = await apiClient.fetchItems(
      token: token,
      collection: 'time_entries',
      since: since,
    );
    for (final item in remoteItems) {
      if (item.deleted) {
        final local = await database.getTimeEntryByRemoteId(item.id);
        if (local != null) {
          await database.deleteTimeEntry(local.id);
        }
        continue;
      }
      final payload = await encryptionService.decryptToMap(item.ciphertext);
      await _applyRemoteTimeEntry(item, payload);
    }
  }

  Future<void> _pullSettings(String token) async {
    final since = lastSettingsSync;
    final remoteItems = await apiClient.fetchItems(
      token: token,
      collection: 'settings',
      since: since,
    );
    for (final item in remoteItems) {
      if (item.deleted) {
        storageBox
          ..delete(settingsRemoteIdKey)
          ..delete(settingsRemoteVersionKey)
          ..put(settingsDirtyKey, true)
          ..put(settingsLastUpdatedAtKey, item.updatedAt.toIso8601String());
        continue;
      }
      final payload = await encryptionService.decryptToMap(item.ciphertext);
      await _applyRemoteSettings(item, payload);
    }
  }

  Future<void> _pullLedgerAccounts(String token) async {
    final since = lastLedgerAccountsSync;
    final remoteItems = await apiClient.fetchItems(
      token: token,
      collection: 'ledger_accounts',
      since: since,
    );
    for (final item in remoteItems) {
      if (item.deleted) {
        final local = await database.getLedgerAccountByRemoteId(item.id);
        if (local != null) {
          await database.deleteLedgerAccount(local.id, recordTombstone: false);
        }
        continue;
      }
      final payload = await encryptionService.decryptToMap(item.ciphertext);
      await _applyRemoteLedgerAccount(item, payload);
    }
  }

  Future<void> _pullLedgerCategories(String token) async {
    final since = lastLedgerCategoriesSync;
    final remoteItems = await apiClient.fetchItems(
      token: token,
      collection: 'ledger_categories',
      since: since,
    );
    for (final item in remoteItems) {
      if (item.deleted) {
        final local = await database.getLedgerCategoryByRemoteId(item.id);
        if (local != null) {
          await database.deleteLedgerCategory(local.id, recordTombstone: false);
        }
        continue;
      }
      final payload = await encryptionService.decryptToMap(item.ciphertext);
      await _applyRemoteLedgerCategory(item, payload);
    }
  }

  Future<void> _pullLedgerBudgets(String token) async {
    final since = lastLedgerBudgetsSync;
    final remoteItems = await apiClient.fetchItems(
      token: token,
      collection: 'ledger_budgets',
      since: since,
    );
    for (final item in remoteItems) {
      if (item.deleted) {
        final local = await database.getLedgerBudgetByRemoteId(item.id);
        if (local != null) {
          await database.deleteLedgerBudget(local.id, recordTombstone: false);
        }
        continue;
      }
      final payload = await encryptionService.decryptToMap(item.ciphertext);
      await _applyRemoteLedgerBudget(item, payload);
    }
  }

  Future<void> _pullLedgerTransactions(String token) async {
    final since = lastLedgerTransactionsSync;
    final remoteItems = await apiClient.fetchItems(
      token: token,
      collection: 'ledger_transactions',
      since: since,
    );
    for (final item in remoteItems) {
      if (item.deleted) {
        final local = await database.getLedgerTransactionByRemoteId(item.id);
        if (local != null) {
          await database.deleteLedgerTransaction(
            local.id,
            recordTombstone: false,
          );
        }
        continue;
      }
      final payload = await encryptionService.decryptToMap(item.ciphertext);
      await _applyRemoteLedgerTransaction(item, payload);
    }
  }

  Future<void> _pullLedgerRecurringTransactions(String token) async {
    final since = lastLedgerRecurringSync;
    final remoteItems = await apiClient.fetchItems(
      token: token,
      collection: 'ledger_recurring_transactions',
      since: since,
    );
    for (final item in remoteItems) {
      if (item.deleted) {
        final local = await database.getLedgerRecurringTransactionByRemoteId(
          item.id,
        );
        if (local != null) {
          await database.deleteLedgerRecurringTransaction(
            local.id,
            recordTombstone: false,
          );
        }
        continue;
      }
      final payload = await encryptionService.decryptToMap(item.ciphertext);
      await _applyRemoteLedgerRecurringTransaction(item, payload);
    }
  }

  Future<void> _pullJournalEntries(String token) async {
    final since = lastJournalEntriesSync;
    final remoteItems = await apiClient.fetchItems(
      token: token,
      collection: 'journal_entries',
      since: since,
    );
    for (final item in remoteItems) {
      if (item.deleted) {
        final local = await database.getJournalEntryByRemoteId(item.id);
        if (local != null) {
          await database.deleteJournalEntry(local.entryDate, local.category);
        }
        continue;
      }
      final payload = await encryptionService.decryptToMap(item.ciphertext);
      await _applyRemoteJournalEntry(item, payload);
    }
  }

  Future<void> _pullJournalTrackers(String token) async {
    final since = lastJournalTrackersSync;
    final remoteItems = await apiClient.fetchItems(
      token: token,
      collection: 'journal_trackers',
      since: since,
    );
    for (final item in remoteItems) {
      if (item.deleted) {
        final local = await database.getJournalTrackerByRemoteId(item.id);
        if (local != null) {
          await database.deleteJournalTracker(local.id);
        }
        continue;
      }
      final payload = await encryptionService.decryptToMap(item.ciphertext);
      await _applyRemoteJournalTracker(item, payload);
    }
  }

  Future<void> _pullJournalTrackerValues(String token) async {
    final since = lastJournalTrackerValuesSync;
    final remoteItems = await apiClient.fetchItems(
      token: token,
      collection: 'journal_tracker_values',
      since: since,
    );
    for (final item in remoteItems) {
      if (item.deleted) {
        final local = await database.getJournalTrackerValueByRemoteId(item.id);
        if (local != null) {
          await database.deleteJournalTrackerValueById(local.id);
        }
        continue;
      }
      final payload = await encryptionService.decryptToMap(item.ciphertext);
      await _applyRemoteJournalTrackerValue(item, payload);
    }
  }

  Future<void> _pullHabitDefinitions(String token) async {
    final since = lastHabitDefinitionsSync;
    final remoteItems = await apiClient.fetchItems(
      token: token,
      collection: 'habits',
      since: since,
    );
    for (final item in remoteItems) {
      if (item.deleted) {
        final local = await database.getHabitByRemoteId(item.id);
        if (local != null) {
          await database.deleteHabit(local.id);
        }
        continue;
      }
      final payload = await encryptionService.decryptToMap(item.ciphertext);
      await _applyRemoteHabit(item, payload);
    }
  }

  Future<void> _pullHabitLogs(String token) async {
    final since = lastHabitLogsSync;
    final remoteItems = await apiClient.fetchItems(
      token: token,
      collection: 'habit_logs',
      since: since,
    );
    for (final item in remoteItems) {
      if (item.deleted) {
        final local = await database.getHabitLogByRemoteId(item.id);
        if (local != null) {
          await database.deleteHabitLog(local.id);
        }
        continue;
      }
      final payload = await encryptionService.decryptToMap(item.ciphertext);
      await _applyRemoteHabitLog(item, payload);
    }
  }

  Map<String, Object?> _serializeNote(NoteEntry note) {
    return <String, Object?>{
      'kind': note.kind.name,
      'title': note.title,
      'content': note.content,
      'drawingJson': note.drawingJson,
      'tags': note.tags,
      'createdAt': note.createdAt.toUtc().toIso8601String(),
      'updatedAt': note.updatedAt.toUtc().toIso8601String(),
      'archived': note.archived,
    };
  }

  Future<Map<String, Object?>> _serializeTask(TaskEntry task) async {
    String? noteRemoteId;
    if (task.noteId != null) {
      final note = await database.getNoteEntryById(task.noteId!);
      noteRemoteId = note?.remoteId;
    }
    return <String, Object?>{
      'title': task.title,
      'status': task.status.name,
      'priority': task.priority.name,
      'dueDate': task.dueDate.toUtc().toIso8601String(),
      'tags': task.tags,
      'noteRemoteId': noteRemoteId,
      'reminderAt': task.reminderAt?.toUtc().toIso8601String(),
      'createdAt': task.createdAt.toUtc().toIso8601String(),
      'updatedAt': task.updatedAt.toUtc().toIso8601String(),
      'archived': task.archived,
    };
  }

  Future<Map<String, Object?>> _serializeTimeEntry(TimeEntry entry) async {
    String? taskRemoteId;
    if (entry.taskId != null) {
      final task = await database.getTaskById(entry.taskId!);
      taskRemoteId = task?.remoteId;
    }
    return <String, Object?>{
      'startedAt': entry.startedAt.toUtc().toIso8601String(),
      'endedAt': entry.endedAt?.toUtc().toIso8601String(),
      'durationMinutes': entry.durationMinutes,
      'note': entry.note,
      'kind': entry.kind.name,
      'taskRemoteId': taskRemoteId,
      'isManual': entry.isManual,
      'createdAt': entry.createdAt.toUtc().toIso8601String(),
      'updatedAt': entry.updatedAt.toUtc().toIso8601String(),
    };
  }

  Map<String, Object?> _serializeJournalEntry(JournalEntry entry) {
    return <String, Object?>{
      'entryDate': entry.entryDate.toUtc().toIso8601String(),
      'content': entry.content,
      'category': entry.category.name,
      'createdAt': entry.createdAt.toUtc().toIso8601String(),
      'updatedAt': entry.updatedAt.toUtc().toIso8601String(),
    };
  }

  Map<String, Object?> _serializeJournalTracker(JournalTracker tracker) {
    return <String, Object?>{
      'name': tracker.name,
      'description': tracker.description,
      'kind': tracker.kind.name,
      'sortOrder': tracker.sortOrder,
      'createdAt': tracker.createdAt.toUtc().toIso8601String(),
      'updatedAt': tracker.updatedAt.toUtc().toIso8601String(),
    };
  }

  Map<String, Object?> _serializeJournalTrackerValue(
    JournalTrackerValue value,
    String trackerRemoteId,
  ) {
    return <String, Object?>{
      'trackerRemoteId': trackerRemoteId,
      'entryDate': value.entryDate.toUtc().toIso8601String(),
      'value': value.value,
      'createdAt': value.createdAt.toUtc().toIso8601String(),
      'updatedAt': value.updatedAt.toUtc().toIso8601String(),
    };
  }

  Map<String, Object?> _serializeHabitDefinition(HabitDefinition habit) {
    return <String, Object?>{
      'name': habit.name,
      'description': habit.description,
      'interval': habit.interval.name,
      'targetOccurrences': habit.targetOccurrences,
      'measurementKind': habit.measurementKind.name,
      'targetValue': habit.targetValue,
      'archived': habit.archived,
      'createdAt': habit.createdAt.toUtc().toIso8601String(),
      'updatedAt': habit.updatedAt.toUtc().toIso8601String(),
    };
  }

  Map<String, Object?> _serializeHabitLog(HabitLog log, String habitRemoteId) {
    return <String, Object?>{
      'habitRemoteId': habitRemoteId,
      'occurredAt': log.occurredAt.toUtc().toIso8601String(),
      'value': log.value,
      'createdAt': log.createdAt.toUtc().toIso8601String(),
      'updatedAt': log.updatedAt.toUtc().toIso8601String(),
    };
  }

  Map<String, Object?> _serializeLedgerAccount(LedgerAccount account) {
    return <String, Object?>{
      'name': account.name,
      'accountKind': account.accountKind.name,
      'currencyCode': account.currencyCode.toUpperCase(),
      'includeInNetWorth': account.includeInNetWorth,
      'initialBalance': account.initialBalance,
      'createdAt': account.createdAt.toUtc().toIso8601String(),
      'updatedAt': account.updatedAt.toUtc().toIso8601String(),
    };
  }

  Future<Map<String, Object?>> _serializeLedgerCategory(
    LedgerCategory category,
  ) async {
    String? parentRemoteId;
    if (category.parentId != null) {
      final parent = await database.getLedgerCategoryById(category.parentId!);
      parentRemoteId = parent?.remoteId;
    }
    return <String, Object?>{
      'name': category.name,
      'categoryKind': category.categoryKind.name,
      'parentRemoteId': parentRemoteId,
      'isArchived': category.isArchived,
      'createdAt': category.createdAt.toUtc().toIso8601String(),
      'updatedAt': category.updatedAt.toUtc().toIso8601String(),
    };
  }

  Future<Map<String, Object?>?> _serializeLedgerBudget(
    LedgerBudget budget,
  ) async {
    final category = await database.getLedgerCategoryById(budget.categoryId);
    if (category == null) {
      return null;
    }
    String? categoryRemoteId = category.remoteId;
    if (categoryRemoteId == null || categoryRemoteId.isEmpty) {
      await database.assignLedgerCategoryRemoteId(
        id: category.id,
        remoteId: _uuid.v4(),
      );
      final refreshed = await database.getLedgerCategoryById(category.id);
      categoryRemoteId = refreshed?.remoteId;
      if (categoryRemoteId == null || categoryRemoteId.isEmpty) {
        return null;
      }
    }

    return <String, Object?>{
      'categoryRemoteId': categoryRemoteId,
      'periodKind': budget.periodKind.name,
      'year': budget.year,
      'month': budget.month,
      'amount': budget.amount,
      'currencyCode': budget.currencyCode.toUpperCase(),
      'createdAt': budget.createdAt.toUtc().toIso8601String(),
      'updatedAt': budget.updatedAt.toUtc().toIso8601String(),
    };
  }

  Future<Map<String, Object?>> _serializeLedgerTransaction(
    LedgerTransaction transaction,
  ) async {
    Future<String?> accountRemoteId(int? accountId) async {
      if (accountId == null) {
        return null;
      }
      final account = await database.getLedgerAccountById(accountId);
      return account?.remoteId;
    }

    Future<String?> categoryRemoteId(int? categoryId) async {
      if (categoryId == null) {
        return null;
      }
      final category = await database.getLedgerCategoryById(categoryId);
      return category?.remoteId;
    }

    final accountRemote = await accountRemoteId(transaction.accountId);
    final targetAccountRemote = await accountRemoteId(
      transaction.targetAccountId,
    );
    final categoryRemote = await categoryRemoteId(transaction.categoryId);
    final subcategoryRemote = await categoryRemoteId(transaction.subcategoryId);

    return <String, Object?>{
      'transactionKind': transaction.transactionKind.name,
      'amount': transaction.amount,
      'currencyCode': transaction.currencyCode.toUpperCase(),
      'bookingDate': transaction.bookingDate.toUtc().toIso8601String(),
      'isPlanned': transaction.isPlanned,
      'description': transaction.description,
      'accountRemoteId': accountRemote,
      'targetAccountRemoteId': targetAccountRemote,
      'categoryRemoteId': categoryRemote,
      'subcategoryRemoteId': subcategoryRemote,
      'cryptoSymbol': transaction.cryptoSymbol?.toUpperCase(),
      'cryptoQuantity': transaction.cryptoQuantity,
      'pricePerUnit': transaction.pricePerUnit,
      'feeAmount': transaction.feeAmount,
      'createdAt': transaction.createdAt.toUtc().toIso8601String(),
      'updatedAt': transaction.updatedAt.toUtc().toIso8601String(),
    };
  }

  Future<Map<String, Object?>> _serializeLedgerRecurringTransaction(
    LedgerRecurringTransaction entry,
  ) async {
    Future<String?> accountRemoteId(int? accountId) async {
      if (accountId == null) {
        return null;
      }
      final account = await database.getLedgerAccountById(accountId);
      return account?.remoteId;
    }

    Future<String?> categoryRemoteId(int? categoryId) async {
      if (categoryId == null) {
        return null;
      }
      final category = await database.getLedgerCategoryById(categoryId);
      return category?.remoteId;
    }

    final accountRemote = await accountRemoteId(entry.accountId);
    final targetAccountRemote = await accountRemoteId(entry.targetAccountId);
    final categoryRemote = await categoryRemoteId(entry.categoryId);
    final subcategoryRemote = await categoryRemoteId(entry.subcategoryId);

    return <String, Object?>{
      'name': entry.name,
      'transactionKind': entry.transactionKind.name,
      'amount': entry.amount,
      'currencyCode': entry.currencyCode.toUpperCase(),
      'startedAt': entry.startedAt.toUtc().toIso8601String(),
      'nextOccurrence': entry.nextOccurrence.toUtc().toIso8601String(),
      'intervalCount': entry.intervalCount,
      'intervalKind': entry.intervalKind.name,
      'accountRemoteId': accountRemote,
      'targetAccountRemoteId': targetAccountRemote,
      'categoryRemoteId': categoryRemote,
      'subcategoryRemoteId': subcategoryRemote,
      'autoApply': entry.autoApply,
      'metadataJson': entry.metadataJson,
      'createdAt': entry.createdAt.toUtc().toIso8601String(),
      'updatedAt': entry.updatedAt.toUtc().toIso8601String(),
    };
  }

  Future<void> _applyRemoteNote(
    RemoteSyncItem item,
    Map<String, dynamic> payload,
  ) async {
    final existing = await database.getNoteByRemoteId(item.id);
    final kindRaw = payload['kind'] as String? ?? NoteKind.markdown.name;
    final kind = NoteKind.values.firstWhere(
      (value) => value.name == kindRaw,
      orElse: () => NoteKind.markdown,
    );
    final title = payload['title'] as String? ?? '';
    final content = payload['content'] as String?;
    final drawingJson = payload['drawingJson'] as String?;
    final tags = payload['tags'] as String? ?? '';
    final createdAt = _parseDate(payload['createdAt']) ?? item.updatedAt;
    final updatedAt = _parseDate(payload['updatedAt']) ?? item.updatedAt;
    final archived = payload['archived'] as bool? ?? false;

    if (existing == null) {
      await database.insertNoteEntry(
        kind: kind,
        title: title,
        content: content,
        drawingJson: drawingJson,
        tags: tags,
        remoteId: item.id,
      );
      final inserted = await database.getNoteByRemoteId(item.id);
      if (inserted != null) {
        await database.markNoteSynced(
          id: inserted.id,
          remoteVersion: item.version,
          syncedAt: updatedAt,
        );
        await (database.update(
          database.noteEntries,
        )..where((tbl) => tbl.id.equals(inserted.id))).write(
          NoteEntriesCompanion(
            createdAt: Value(createdAt.toUtc()),
            updatedAt: Value(updatedAt.toUtc()),
            needsSync: const Value(false),
            remoteVersion: Value(item.version),
            syncedAt: Value(updatedAt.toUtc()),
            archived: Value(archived),
          ),
        );
      }
      return;
    }

    await (database.update(
      database.noteEntries,
    )..where((tbl) => tbl.id.equals(existing.id))).write(
      NoteEntriesCompanion(
        title: Value(title),
        content: Value(content),
        drawingJson: Value(drawingJson),
        tags: Value(tags),
        kind: Value(kind),
        updatedAt: Value(updatedAt.toUtc()),
        createdAt: Value(createdAt.toUtc()),
        remoteVersion: Value(item.version),
        needsSync: const Value(false),
        syncedAt: Value(updatedAt.toUtc()),
        archived: Value(archived),
      ),
    );
  }

  Future<void> _applyRemoteTask(
    RemoteSyncItem item,
    Map<String, dynamic> payload,
  ) async {
    final existing = await database.getTaskByRemoteId(item.id);
    final title = payload['title'] as String? ?? '';
    final statusRaw = payload['status'] as String? ?? TaskStatus.todo.name;
    final priorityRaw =
        payload['priority'] as String? ?? TaskPriority.medium.name;
    final status = TaskStatus.values.firstWhere(
      (value) => value.name == statusRaw,
      orElse: () => TaskStatus.todo,
    );
    final priority = TaskPriority.values.firstWhere(
      (value) => value.name == priorityRaw,
      orElse: () => TaskPriority.medium,
    );
    final dueDate = _parseDate(payload['dueDate']) ?? DateTime.now().toUtc();
    final tags = payload['tags'] as String? ?? '';
    final noteRemoteId = payload['noteRemoteId'] as String?;
    final reminderAt = _parseDate(payload['reminderAt']);
    final createdAt =
        _parseDate(payload['createdAt']) ?? item.updatedAt.toUtc();
    final updatedAt =
        _parseDate(payload['updatedAt']) ?? item.updatedAt.toUtc();
    final archived = payload['archived'] as bool? ?? false;
    int? noteId;
    if (noteRemoteId != null) {
      final note = await database.getNoteByRemoteId(noteRemoteId);
      noteId = note?.id;
    }

    if (existing == null) {
      await database.insertTaskEntry(
        title: title,
        status: status,
        priority: priority,
        dueDate: dueDate.toUtc(),
        noteId: noteId,
        tags: tags,
        reminderAt: reminderAt?.toUtc(),
        remoteId: item.id,
      );
      final inserted = await database.getTaskByRemoteId(item.id);
      if (inserted != null) {
        await database.markTaskSynced(
          id: inserted.id,
          remoteVersion: item.version,
          syncedAt: updatedAt,
        );
        await (database.update(
          database.taskEntries,
        )..where((tbl) => tbl.id.equals(inserted.id))).write(
          TaskEntriesCompanion(
            createdAt: Value(createdAt.toUtc()),
            updatedAt: Value(updatedAt.toUtc()),
            needsSync: const Value(false),
            remoteVersion: Value(item.version),
            syncedAt: Value(updatedAt.toUtc()),
            noteId: noteId == null ? const Value.absent() : Value(noteId),
            archived: Value(archived),
          ),
        );
      }
      return;
    }

    await (database.update(
      database.taskEntries,
    )..where((tbl) => tbl.id.equals(existing.id))).write(
      TaskEntriesCompanion(
        title: Value(title),
        status: Value(status),
        priority: Value(priority),
        dueDate: Value(dueDate.toUtc()),
        tags: Value(tags),
        reminderAt: reminderAt == null
            ? const Value.absent()
            : Value(reminderAt.toUtc()),
        noteId: noteId == null ? const Value.absent() : Value(noteId),
        updatedAt: Value(updatedAt.toUtc()),
        createdAt: Value(createdAt.toUtc()),
        remoteVersion: Value(item.version),
        needsSync: const Value(false),
        syncedAt: Value(updatedAt.toUtc()),
        archived: Value(archived),
      ),
    );
  }

  Future<void> _applyServerNote(SyncConflictData conflict) async {
    await _applyRemoteNote(conflict.server, conflict.serverPayload);
  }

  Future<void> _applyServerTask(SyncConflictData conflict) async {
    await _applyRemoteTask(conflict.server, conflict.serverPayload);
  }

  Future<void> _applyRemoteJournalEntry(
    RemoteSyncItem item,
    Map<String, dynamic> payload,
  ) async {
    final existing = await database.getJournalEntryByRemoteId(item.id);
    final entryDateRaw = _parseDate(payload['entryDate']) ?? item.updatedAt;
    final normalized = DateTime.utc(
      entryDateRaw.year,
      entryDateRaw.month,
      entryDateRaw.day,
    );
    final content = payload['content'] as String? ?? '';
    final categoryRaw = payload['category'] as String?;
    final category = JournalCategory.values.firstWhere(
      (value) => value.name == categoryRaw,
      orElse: () => JournalCategory.personal,
    );
    final createdAt =
        _parseDate(payload['createdAt']) ?? item.updatedAt.toUtc();
    final updatedAt =
        _parseDate(payload['updatedAt']) ?? item.updatedAt.toUtc();

    if (existing == null) {
      await database
          .into(database.journalEntries)
          .insert(
            JournalEntriesCompanion.insert(
              entryDate: normalized,
              category: Value(category),
              content: Value(content),
              createdAt: Value(createdAt.toUtc()),
              updatedAt: Value(updatedAt.toUtc()),
              remoteId: Value(item.id),
              remoteVersion: Value(item.version),
              needsSync: const Value(false),
              syncedAt: Value(updatedAt.toUtc()),
            ),
            mode: InsertMode.insertOrReplace,
          );
      return;
    }

    await (database.update(
      database.journalEntries,
    )..where((tbl) => tbl.id.equals(existing.id))).write(
      JournalEntriesCompanion(
        entryDate: Value(normalized),
        category: Value(category),
        content: Value(content),
        createdAt: Value(createdAt.toUtc()),
        updatedAt: Value(updatedAt.toUtc()),
        remoteVersion: Value(item.version),
        needsSync: const Value(false),
        syncedAt: Value(updatedAt.toUtc()),
      ),
    );
  }

  Future<void> _applyRemoteJournalTracker(
    RemoteSyncItem item,
    Map<String, dynamic> payload,
  ) async {
    final existing = await database.getJournalTrackerByRemoteId(item.id);
    final name = payload['name'] as String? ?? '';
    final description = payload['description'] as String? ?? '';
    final kindRaw =
        payload['kind'] as String? ?? JournalTrackerKind.checkbox.name;
    final kind = JournalTrackerKind.values.firstWhere(
      (value) => value.name == kindRaw,
      orElse: () => JournalTrackerKind.checkbox,
    );
    final sortOrder = (payload['sortOrder'] as num?)?.toInt() ?? 0;
    final createdAt =
        _parseDate(payload['createdAt']) ?? item.updatedAt.toUtc();
    final updatedAt =
        _parseDate(payload['updatedAt']) ?? item.updatedAt.toUtc();

    if (existing == null) {
      await database
          .into(database.journalTrackers)
          .insert(
            JournalTrackersCompanion.insert(
              name: name,
              description: Value(description),
              kind: Value(kind),
              sortOrder: Value(sortOrder),
              createdAt: Value(createdAt.toUtc()),
              updatedAt: Value(updatedAt.toUtc()),
              remoteId: Value(item.id),
              remoteVersion: Value(item.version),
              needsSync: const Value(false),
              syncedAt: Value(updatedAt.toUtc()),
            ),
            mode: InsertMode.insertOrReplace,
          );
      return;
    }

    await (database.update(
      database.journalTrackers,
    )..where((tbl) => tbl.id.equals(existing.id))).write(
      JournalTrackersCompanion(
        name: Value(name),
        description: Value(description),
        kind: Value(kind),
        sortOrder: Value(sortOrder),
        createdAt: Value(createdAt.toUtc()),
        updatedAt: Value(updatedAt.toUtc()),
        remoteVersion: Value(item.version),
        needsSync: const Value(false),
        syncedAt: Value(updatedAt.toUtc()),
      ),
    );
  }

  Future<void> _applyRemoteJournalTrackerValue(
    RemoteSyncItem item,
    Map<String, dynamic> payload,
  ) async {
    final trackerRemoteId = payload['trackerRemoteId'] as String?;
    if (trackerRemoteId == null || trackerRemoteId.isEmpty) {
      return;
    }
    final tracker = await database.getJournalTrackerByRemoteId(trackerRemoteId);
    if (tracker == null) {
      return;
    }

    final entryDateRaw = _parseDate(payload['entryDate']) ?? item.updatedAt;
    final normalized = DateTime.utc(
      entryDateRaw.year,
      entryDateRaw.month,
      entryDateRaw.day,
    );
    final valueRaw = (payload['value'] as num?)?.toInt() ?? 0;
    final createdAt =
        _parseDate(payload['createdAt']) ?? item.updatedAt.toUtc();
    final updatedAt =
        _parseDate(payload['updatedAt']) ?? item.updatedAt.toUtc();

    JournalTrackerValue? existing = await database
        .getJournalTrackerValueByRemoteId(item.id);
    existing ??=
        await (database.select(database.journalTrackerValues)
              ..where(
                (tbl) =>
                    tbl.trackerId.equals(tracker.id) &
                    tbl.entryDate.equals(normalized),
              )
              ..limit(1))
            .getSingleOrNull();

    if (existing == null) {
      await database
          .into(database.journalTrackerValues)
          .insert(
            JournalTrackerValuesCompanion.insert(
              trackerId: tracker.id,
              entryDate: normalized,
              value: Value(valueRaw),
              createdAt: Value(createdAt.toUtc()),
              updatedAt: Value(updatedAt.toUtc()),
              remoteId: Value(item.id),
              remoteVersion: Value(item.version),
              needsSync: const Value(false),
              syncedAt: Value(updatedAt.toUtc()),
            ),
            mode: InsertMode.insertOrReplace,
          );
      return;
    }

    final targetValue = existing;
    await (database.update(
      database.journalTrackerValues,
    )..where((tbl) => tbl.id.equals(targetValue.id))).write(
      JournalTrackerValuesCompanion(
        trackerId: Value(tracker.id),
        entryDate: Value(normalized),
        value: Value(valueRaw),
        createdAt: Value(createdAt.toUtc()),
        updatedAt: Value(updatedAt.toUtc()),
        remoteId: Value(item.id),
        remoteVersion: Value(item.version),
        needsSync: const Value(false),
        syncedAt: Value(updatedAt.toUtc()),
      ),
    );
  }

  Future<void> _applyRemoteHabit(
    RemoteSyncItem item,
    Map<String, dynamic> payload,
  ) async {
    final existing = await database.getHabitByRemoteId(item.id);
    final name = payload['name'] as String? ?? '';
    final description = payload['description'] as String? ?? '';
    final intervalRaw =
        payload['interval'] as String? ?? HabitIntervalKind.daily.name;
    final interval = HabitIntervalKind.values.firstWhere(
      (value) => value.name == intervalRaw,
      orElse: () => HabitIntervalKind.daily,
    );
    final targetOccurrences =
        (payload['targetOccurrences'] as num?)?.toInt() ?? 1;
    final measurementRaw =
        payload['measurementKind'] as String? ?? HabitValueKind.boolean.name;
    final measurementKind = HabitValueKind.values.firstWhere(
      (value) => value.name == measurementRaw,
      orElse: () => HabitValueKind.boolean,
    );
    final targetValueRaw = payload['targetValue'];
    final double? targetValue = targetValueRaw is num
        ? targetValueRaw.toDouble()
        : null;
    final archived = payload['archived'] as bool? ?? false;
    final createdAt =
        _parseDate(payload['createdAt']) ?? item.updatedAt.toUtc();
    final updatedAt =
        _parseDate(payload['updatedAt']) ?? item.updatedAt.toUtc();

    if (existing == null) {
      await database
          .into(database.habitDefinitions)
          .insert(
            HabitDefinitionsCompanion.insert(
              name: name,
              description: Value(description),
              interval: Value(interval),
              targetOccurrences: Value(targetOccurrences),
              measurementKind: Value(measurementKind),
              targetValue: targetValue == null
                  ? const Value.absent()
                  : Value(targetValue),
              archived: Value(archived),
              createdAt: Value(createdAt.toUtc()),
              updatedAt: Value(updatedAt.toUtc()),
              remoteId: Value(item.id),
              remoteVersion: Value(item.version),
              needsSync: const Value(false),
              syncedAt: Value(updatedAt.toUtc()),
            ),
            mode: InsertMode.insertOrReplace,
          );
      return;
    }

    await (database.update(
      database.habitDefinitions,
    )..where((tbl) => tbl.id.equals(existing.id))).write(
      HabitDefinitionsCompanion(
        name: Value(name),
        description: Value(description),
        interval: Value(interval),
        targetOccurrences: Value(targetOccurrences),
        measurementKind: Value(measurementKind),
        targetValue: targetValue == null
            ? const Value.absent()
            : Value(targetValue),
        archived: Value(archived),
        createdAt: Value(createdAt.toUtc()),
        updatedAt: Value(updatedAt.toUtc()),
        remoteVersion: Value(item.version),
        needsSync: const Value(false),
        syncedAt: Value(updatedAt.toUtc()),
      ),
    );
  }

  Future<void> _applyRemoteHabitLog(
    RemoteSyncItem item,
    Map<String, dynamic> payload,
  ) async {
    final habitRemoteId = payload['habitRemoteId'] as String?;
    if (habitRemoteId == null || habitRemoteId.isEmpty) {
      return;
    }
    final habit = await database.getHabitByRemoteId(habitRemoteId);
    if (habit == null) {
      return;
    }

    final occurredAt =
        _parseDate(payload['occurredAt']) ?? item.updatedAt.toUtc();
    final value = (payload['value'] as num?)?.toDouble() ?? 0;
    final createdAt =
        _parseDate(payload['createdAt']) ?? item.updatedAt.toUtc();
    final updatedAt =
        _parseDate(payload['updatedAt']) ?? item.updatedAt.toUtc();

    HabitLog? existing = await database.getHabitLogByRemoteId(item.id);
    existing ??=
        await (database.select(database.habitLogs)
              ..where(
                (tbl) =>
                    tbl.habitId.equals(habit.id) &
                    tbl.occurredAt.equals(occurredAt.toUtc()),
              )
              ..limit(1))
            .getSingleOrNull();

    if (existing == null) {
      await database
          .into(database.habitLogs)
          .insert(
            HabitLogsCompanion.insert(
              habitId: habit.id,
              occurredAt: occurredAt.toUtc(),
              value: Value(value),
              createdAt: Value(createdAt.toUtc()),
              updatedAt: Value(updatedAt.toUtc()),
              remoteId: Value(item.id),
              remoteVersion: Value(item.version),
              needsSync: const Value(false),
              syncedAt: Value(updatedAt.toUtc()),
            ),
            mode: InsertMode.insertOrReplace,
          );
      return;
    }

    final targetLog = existing;
    await (database.update(
      database.habitLogs,
    )..where((tbl) => tbl.id.equals(targetLog.id))).write(
      HabitLogsCompanion(
        habitId: Value(habit.id),
        occurredAt: Value(occurredAt.toUtc()),
        value: Value(value),
        createdAt: Value(createdAt.toUtc()),
        updatedAt: Value(updatedAt.toUtc()),
        remoteId: Value(item.id),
        remoteVersion: Value(item.version),
        needsSync: const Value(false),
        syncedAt: Value(updatedAt.toUtc()),
      ),
    );
  }

  Future<void> _applyRemoteForCollection({
    required String collection,
    required RemoteSyncItem item,
    required Map<String, dynamic> payload,
  }) async {
    switch (collection) {
      case 'ledger_accounts':
        await _applyRemoteLedgerAccount(item, payload);
        break;
      case 'ledger_categories':
        await _applyRemoteLedgerCategory(item, payload);
        break;
      case 'ledger_budgets':
        await _applyRemoteLedgerBudget(item, payload);
        break;
      case 'ledger_transactions':
        await _applyRemoteLedgerTransaction(item, payload);
        break;
      case 'ledger_recurring_transactions':
        await _applyRemoteLedgerRecurringTransaction(item, payload);
        break;
      default:
        break;
    }
  }

  Future<void> _applyRemoteLedgerAccount(
    RemoteSyncItem item,
    Map<String, dynamic> payload,
  ) async {
    final existing = await database.getLedgerAccountByRemoteId(item.id);
    final name = payload['name'] as String? ?? '';
    final kindRaw =
        payload['accountKind'] as String? ?? LedgerAccountKind.cash.name;
    final kind = LedgerAccountKind.values.firstWhere(
      (value) => value.name == kindRaw,
      orElse: () => LedgerAccountKind.cash,
    );
    final currencyCode = (payload['currencyCode'] as String? ?? 'EUR')
        .toUpperCase();
    final includeInNetWorth = payload['includeInNetWorth'] as bool? ?? true;
    final initialBalance = (payload['initialBalance'] as num?)?.toDouble() ?? 0;
    final createdAt =
        _parseDate(payload['createdAt']) ?? item.updatedAt.toUtc();
    final updatedAt =
        _parseDate(payload['updatedAt']) ?? item.updatedAt.toUtc();

    if (existing == null) {
      await database
          .into(database.ledgerAccounts)
          .insert(
            LedgerAccountsCompanion.insert(
              name: name,
              accountKind: Value(kind),
              currencyCode: Value(currencyCode),
              includeInNetWorth: Value(includeInNetWorth),
              initialBalance: Value(initialBalance),
              createdAt: Value(createdAt.toUtc()),
              updatedAt: Value(updatedAt.toUtc()),
              remoteId: Value(item.id),
              remoteVersion: Value(item.version),
              needsSync: const Value(false),
              syncedAt: Value(updatedAt.toUtc()),
            ),
            mode: InsertMode.insertOrReplace,
          );
      return;
    }

    await (database.update(
      database.ledgerAccounts,
    )..where((tbl) => tbl.id.equals(existing.id))).write(
      LedgerAccountsCompanion(
        name: Value(name),
        accountKind: Value(kind),
        currencyCode: Value(currencyCode),
        includeInNetWorth: Value(includeInNetWorth),
        initialBalance: Value(initialBalance),
        createdAt: Value(createdAt.toUtc()),
        updatedAt: Value(updatedAt.toUtc()),
        remoteVersion: Value(item.version),
        needsSync: const Value(false),
        syncedAt: Value(updatedAt.toUtc()),
      ),
    );
  }

  Future<void> _applyRemoteLedgerCategory(
    RemoteSyncItem item,
    Map<String, dynamic> payload,
  ) async {
    final existing = await database.getLedgerCategoryByRemoteId(item.id);
    final name = payload['name'] as String? ?? '';
    final kindRaw =
        payload['categoryKind'] as String? ?? LedgerCategoryKind.expense.name;
    final kind = LedgerCategoryKind.values.firstWhere(
      (value) => value.name == kindRaw,
      orElse: () => LedgerCategoryKind.expense,
    );
    final parentRemoteId = payload['parentRemoteId'] as String?;
    final isArchived = payload['isArchived'] as bool? ?? false;
    final createdAt =
        _parseDate(payload['createdAt']) ?? item.updatedAt.toUtc();
    final updatedAt =
        _parseDate(payload['updatedAt']) ?? item.updatedAt.toUtc();

    int? parentId;
    if (parentRemoteId != null && parentRemoteId.isNotEmpty) {
      final parent = await database.getLedgerCategoryByRemoteId(parentRemoteId);
      parentId = parent?.id;
    }

    final Value<int?> parentValue = parentId == null
        ? const Value<int?>.absent()
        : Value<int?>(parentId);

    if (existing == null) {
      await database
          .into(database.ledgerCategories)
          .insert(
            LedgerCategoriesCompanion.insert(
              name: name,
              categoryKind: Value(kind),
              parentId: parentValue,
              isArchived: Value(isArchived),
              createdAt: Value(createdAt.toUtc()),
              updatedAt: Value(updatedAt.toUtc()),
              remoteId: Value(item.id),
              remoteVersion: Value(item.version),
              needsSync: const Value(false),
              syncedAt: Value(updatedAt.toUtc()),
            ),
            mode: InsertMode.insertOrReplace,
          );
      return;
    }

    await (database.update(
      database.ledgerCategories,
    )..where((tbl) => tbl.id.equals(existing.id))).write(
      LedgerCategoriesCompanion(
        name: Value(name),
        categoryKind: Value(kind),
        parentId: parentValue,
        isArchived: Value(isArchived),
        createdAt: Value(createdAt.toUtc()),
        updatedAt: Value(updatedAt.toUtc()),
        remoteVersion: Value(item.version),
        needsSync: const Value(false),
        syncedAt: Value(updatedAt.toUtc()),
      ),
    );
  }

  Future<void> _applyRemoteLedgerBudget(
    RemoteSyncItem item,
    Map<String, dynamic> payload,
  ) async {
    final existing = await database.getLedgerBudgetByRemoteId(item.id);
    final categoryRemoteId = payload['categoryRemoteId'] as String?;
    if (categoryRemoteId == null || categoryRemoteId.isEmpty) {
      return;
    }
    final category = await database.getLedgerCategoryByRemoteId(
      categoryRemoteId,
    );
    if (category == null) {
      return;
    }

    final periodKindRaw =
        payload['periodKind'] as String? ?? LedgerBudgetPeriodKind.monthly.name;
    final periodKind = LedgerBudgetPeriodKind.values.firstWhere(
      (value) => value.name == periodKindRaw,
      orElse: () => LedgerBudgetPeriodKind.monthly,
    );
    final year = (payload['year'] as num?)?.toInt() ?? DateTime.now().year;
    final monthRaw = payload['month'];
    final int? month = monthRaw is num ? monthRaw.toInt() : null;
    final amount = (payload['amount'] as num?)?.toDouble() ?? 0;
    final currencyCode = (payload['currencyCode'] as String? ?? 'EUR')
        .toUpperCase();
    final createdAt =
        _parseDate(payload['createdAt']) ?? item.updatedAt.toUtc();
    final updatedAt =
        _parseDate(payload['updatedAt']) ?? item.updatedAt.toUtc();

    final Value<int?> monthValue = month == null
        ? const Value<int?>.absent()
        : Value<int?>(month);

    if (existing == null) {
      await database
          .into(database.ledgerBudgets)
          .insert(
            LedgerBudgetsCompanion.insert(
              categoryId: category.id,
              periodKind: Value(periodKind),
              year: year,
              month: monthValue,
              amount: Value(amount),
              currencyCode: Value(currencyCode),
              createdAt: Value(createdAt.toUtc()),
              updatedAt: Value(updatedAt.toUtc()),
              remoteId: Value(item.id),
              remoteVersion: Value(item.version),
              needsSync: const Value(false),
              syncedAt: Value(updatedAt.toUtc()),
            ),
            mode: InsertMode.insertOrReplace,
          );
      return;
    }

    await (database.update(
      database.ledgerBudgets,
    )..where((tbl) => tbl.id.equals(existing.id))).write(
      LedgerBudgetsCompanion(
        categoryId: Value(category.id),
        periodKind: Value(periodKind),
        year: Value(year),
        month: monthValue,
        amount: Value(amount),
        currencyCode: Value(currencyCode),
        createdAt: Value(createdAt.toUtc()),
        updatedAt: Value(updatedAt.toUtc()),
        remoteVersion: Value(item.version),
        needsSync: const Value(false),
        syncedAt: Value(updatedAt.toUtc()),
      ),
    );
  }

  Future<void> _applyRemoteLedgerTransaction(
    RemoteSyncItem item,
    Map<String, dynamic> payload,
  ) async {
    final existing = await database.getLedgerTransactionByRemoteId(item.id);
    final kindRaw =
        payload['transactionKind'] as String? ??
        LedgerTransactionKind.expense.name;
    final kind = LedgerTransactionKind.values.firstWhere(
      (value) => value.name == kindRaw,
      orElse: () => LedgerTransactionKind.expense,
    );
    final amount = (payload['amount'] as num?)?.toDouble() ?? 0;
    final currencyCode = (payload['currencyCode'] as String? ?? 'EUR')
        .toUpperCase();
    final bookingDate =
        _parseDate(payload['bookingDate']) ?? item.updatedAt.toUtc();
    final isPlanned = payload['isPlanned'] as bool? ?? false;
    final description = payload['description'] as String? ?? '';
    final accountRemoteId = payload['accountRemoteId'] as String?;
    final targetAccountRemoteId = payload['targetAccountRemoteId'] as String?;
    final categoryRemoteId = payload['categoryRemoteId'] as String?;
    final subcategoryRemoteId = payload['subcategoryRemoteId'] as String?;
    final cryptoSymbol = (payload['cryptoSymbol'] as String?)?.toUpperCase();
    final cryptoQuantity = (payload['cryptoQuantity'] as num?)?.toDouble();
    final pricePerUnit = (payload['pricePerUnit'] as num?)?.toDouble();
    final feeAmount = (payload['feeAmount'] as num?)?.toDouble();
    final createdAt =
        _parseDate(payload['createdAt']) ?? item.updatedAt.toUtc();
    final updatedAt =
        _parseDate(payload['updatedAt']) ?? item.updatedAt.toUtc();

    Future<Value<int?>> resolveAccount(String? remoteId) async {
      if (remoteId == null || remoteId.isEmpty) {
        return const Value<int?>.absent();
      }
      final account = await database.getLedgerAccountByRemoteId(remoteId);
      return account == null
          ? const Value<int?>.absent()
          : Value<int?>(account.id);
    }

    Future<Value<int?>> resolveCategory(String? remoteId) async {
      if (remoteId == null || remoteId.isEmpty) {
        return const Value<int?>.absent();
      }
      final category = await database.getLedgerCategoryByRemoteId(remoteId);
      return category == null
          ? const Value<int?>.absent()
          : Value<int?>(category.id);
    }

    final accountIdValue = await resolveAccount(accountRemoteId);
    final targetAccountIdValue = await resolveAccount(targetAccountRemoteId);
    final categoryIdValue = await resolveCategory(categoryRemoteId);
    final subcategoryIdValue = await resolveCategory(subcategoryRemoteId);

    final Value<double?> cryptoQuantityValue = cryptoQuantity == null
        ? const Value<double?>.absent()
        : Value<double?>(cryptoQuantity);
    final Value<double?> pricePerUnitValue = pricePerUnit == null
        ? const Value<double?>.absent()
        : Value<double?>(pricePerUnit);
    final Value<double?> feeAmountValue = feeAmount == null
        ? const Value<double?>.absent()
        : Value<double?>(feeAmount);
    final Value<String?> cryptoSymbolValue =
        cryptoSymbol == null || cryptoSymbol.isEmpty
        ? const Value<String?>.absent()
        : Value<String?>(cryptoSymbol);

    if (existing == null) {
      await database
          .into(database.ledgerTransactions)
          .insert(
            LedgerTransactionsCompanion.insert(
              transactionKind: Value(kind),
              amount: Value(amount),
              currencyCode: Value(currencyCode),
              bookingDate: Value(bookingDate.toUtc()),
              isPlanned: Value(isPlanned),
              description: Value(description),
              accountId: accountIdValue,
              targetAccountId: targetAccountIdValue,
              categoryId: categoryIdValue,
              subcategoryId: subcategoryIdValue,
              cryptoSymbol: cryptoSymbolValue,
              cryptoQuantity: cryptoQuantityValue,
              pricePerUnit: pricePerUnitValue,
              feeAmount: feeAmountValue,
              createdAt: Value(createdAt.toUtc()),
              updatedAt: Value(updatedAt.toUtc()),
              remoteId: Value(item.id),
              remoteVersion: Value(item.version),
              needsSync: const Value(false),
              syncedAt: Value(updatedAt.toUtc()),
            ),
            mode: InsertMode.insertOrReplace,
          );
      return;
    }

    await (database.update(
      database.ledgerTransactions,
    )..where((tbl) => tbl.id.equals(existing.id))).write(
      LedgerTransactionsCompanion(
        transactionKind: Value(kind),
        amount: Value(amount),
        currencyCode: Value(currencyCode),
        bookingDate: Value(bookingDate.toUtc()),
        isPlanned: Value(isPlanned),
        description: Value(description),
        accountId: accountIdValue,
        targetAccountId: targetAccountIdValue,
        categoryId: categoryIdValue,
        subcategoryId: subcategoryIdValue,
        cryptoSymbol: cryptoSymbolValue,
        cryptoQuantity: cryptoQuantityValue,
        pricePerUnit: pricePerUnitValue,
        feeAmount: feeAmountValue,
        createdAt: Value(createdAt.toUtc()),
        updatedAt: Value(updatedAt.toUtc()),
        remoteVersion: Value(item.version),
        needsSync: const Value(false),
        syncedAt: Value(updatedAt.toUtc()),
      ),
    );
  }

  Future<void> _applyRemoteLedgerRecurringTransaction(
    RemoteSyncItem item,
    Map<String, dynamic> payload,
  ) async {
    final existing = await database.getLedgerRecurringTransactionByRemoteId(
      item.id,
    );
    final name = payload['name'] as String? ?? '';
    final kindRaw =
        payload['transactionKind'] as String? ??
        LedgerTransactionKind.expense.name;
    final kind = LedgerTransactionKind.values.firstWhere(
      (value) => value.name == kindRaw,
      orElse: () => LedgerTransactionKind.expense,
    );
    final amount = (payload['amount'] as num?)?.toDouble() ?? 0;
    final currencyCode = (payload['currencyCode'] as String? ?? 'EUR')
        .toUpperCase();
    final startedAt =
        _parseDate(payload['startedAt']) ?? item.updatedAt.toUtc();
    final nextOccurrence =
        _parseDate(payload['nextOccurrence']) ?? item.updatedAt.toUtc();
    final intervalCount = (payload['intervalCount'] as num?)?.toInt() ?? 1;
    final intervalKindRaw =
        payload['intervalKind'] as String? ??
        LedgerRecurringIntervalKind.monthly.name;
    final intervalKind = LedgerRecurringIntervalKind.values.firstWhere(
      (value) => value.name == intervalKindRaw,
      orElse: () => LedgerRecurringIntervalKind.monthly,
    );
    final accountRemoteId = payload['accountRemoteId'] as String?;
    final targetAccountRemoteId = payload['targetAccountRemoteId'] as String?;
    final categoryRemoteId = payload['categoryRemoteId'] as String?;
    final subcategoryRemoteId = payload['subcategoryRemoteId'] as String?;
    final autoApply = payload['autoApply'] as bool? ?? false;
    final rawMetadata = payload['metadataJson'] as String?;
    final metadataJson = rawMetadata == null || rawMetadata.trim().isEmpty
        ? '{}'
        : rawMetadata;
    final createdAt =
        _parseDate(payload['createdAt']) ?? item.updatedAt.toUtc();
    final updatedAt =
        _parseDate(payload['updatedAt']) ?? item.updatedAt.toUtc();

    Future<Value<int?>> resolveAccount(String? remoteId) async {
      if (remoteId == null || remoteId.isEmpty) {
        return const Value<int?>.absent();
      }
      final account = await database.getLedgerAccountByRemoteId(remoteId);
      return account == null
          ? const Value<int?>.absent()
          : Value<int?>(account.id);
    }

    Future<Value<int?>> resolveCategory(String? remoteId) async {
      if (remoteId == null || remoteId.isEmpty) {
        return const Value<int?>.absent();
      }
      final category = await database.getLedgerCategoryByRemoteId(remoteId);
      return category == null
          ? const Value<int?>.absent()
          : Value<int?>(category.id);
    }

    final accountIdValue = await resolveAccount(accountRemoteId);
    final targetAccountIdValue = await resolveAccount(targetAccountRemoteId);
    final categoryIdValue = await resolveCategory(categoryRemoteId);
    final subcategoryIdValue = await resolveCategory(subcategoryRemoteId);

    if (existing == null) {
      await database
          .into(database.ledgerRecurringTransactions)
          .insert(
            LedgerRecurringTransactionsCompanion.insert(
              name: name,
              transactionKind: Value(kind),
              amount: Value(amount),
              currencyCode: Value(currencyCode),
              startedAt: Value(startedAt.toUtc()),
              nextOccurrence: Value(nextOccurrence.toUtc()),
              intervalCount: Value(intervalCount),
              intervalKind: Value(intervalKind),
              accountId: accountIdValue,
              targetAccountId: targetAccountIdValue,
              categoryId: categoryIdValue,
              subcategoryId: subcategoryIdValue,
              autoApply: Value(autoApply),
              metadataJson: Value(metadataJson),
              createdAt: Value(createdAt.toUtc()),
              updatedAt: Value(updatedAt.toUtc()),
              remoteId: Value(item.id),
              remoteVersion: Value(item.version),
              needsSync: const Value(false),
              syncedAt: Value(updatedAt.toUtc()),
            ),
            mode: InsertMode.insertOrReplace,
          );
      return;
    }

    await (database.update(
      database.ledgerRecurringTransactions,
    )..where((tbl) => tbl.id.equals(existing.id))).write(
      LedgerRecurringTransactionsCompanion(
        name: Value(name),
        transactionKind: Value(kind),
        amount: Value(amount),
        currencyCode: Value(currencyCode),
        startedAt: Value(startedAt.toUtc()),
        nextOccurrence: Value(nextOccurrence.toUtc()),
        intervalCount: Value(intervalCount),
        intervalKind: Value(intervalKind),
        accountId: accountIdValue,
        targetAccountId: targetAccountIdValue,
        categoryId: categoryIdValue,
        subcategoryId: subcategoryIdValue,
        autoApply: Value(autoApply),
        metadataJson: Value(metadataJson),
        createdAt: Value(createdAt.toUtc()),
        updatedAt: Value(updatedAt.toUtc()),
        remoteVersion: Value(item.version),
        needsSync: const Value(false),
        syncedAt: Value(updatedAt.toUtc()),
      ),
    );
  }

  Future<void> _applyRemoteTimeEntry(
    RemoteSyncItem item,
    Map<String, dynamic> payload,
  ) async {
    final existing = await database.getTimeEntryByRemoteId(item.id);
    final startedAt =
        _parseDate(payload['startedAt']) ?? item.updatedAt.toUtc();
    final endedAt = _parseDate(payload['endedAt']);
    final durationMinutes = (payload['durationMinutes'] as num?)?.toInt() ?? 0;
    final note = payload['note'] as String? ?? '';
    final kindRaw = payload['kind'] as String? ?? TimeEntryKind.work.name;
    final kind = TimeEntryKind.values.firstWhere(
      (value) => value.name == kindRaw,
      orElse: () => TimeEntryKind.work,
    );
    final taskRemoteId = payload['taskRemoteId'] as String?;
    final isManual = payload['isManual'] as bool? ?? false;
    final createdAt =
        _parseDate(payload['createdAt']) ?? item.updatedAt.toUtc();
    final updatedAt =
        _parseDate(payload['updatedAt']) ?? item.updatedAt.toUtc();

    int? taskId;
    if (taskRemoteId != null) {
      final task = await database.getTaskByRemoteId(taskRemoteId);
      taskId = task?.id;
    }

    if (existing == null) {
      await database.insertTimeEntry(
        startedAt: startedAt.toUtc(),
        endedAt: endedAt?.toUtc(),
        durationMinutes: durationMinutes,
        kind: kind,
        note: note,
        taskId: taskId,
        isManual: isManual,
        remoteId: item.id,
        remoteVersion: item.version,
        needsSync: false,
        syncedAt: updatedAt,
      );
      final inserted = await database.getTimeEntryByRemoteId(item.id);
      if (inserted != null) {
        await (database.update(
          database.timeEntries,
        )..where((tbl) => tbl.id.equals(inserted.id))).write(
          TimeEntriesCompanion(
            createdAt: Value(createdAt.toUtc()),
            updatedAt: Value(updatedAt.toUtc()),
            needsSync: const Value(false),
            remoteVersion: Value(item.version),
            syncedAt: Value(updatedAt.toUtc()),
            taskId: taskId == null ? const Value.absent() : Value(taskId),
            endedAt: endedAt == null
                ? const Value.absent()
                : Value(endedAt.toUtc()),
          ),
        );
      }
      return;
    }

    await (database.update(
      database.timeEntries,
    )..where((tbl) => tbl.id.equals(existing.id))).write(
      TimeEntriesCompanion(
        startedAt: Value(startedAt.toUtc()),
        endedAt: endedAt == null
            ? const Value.absent()
            : Value(endedAt.toUtc()),
        durationMinutes: Value(durationMinutes),
        note: Value(note),
        kind: Value(kind),
        taskId: taskId == null ? const Value.absent() : Value(taskId),
        isManual: Value(isManual),
        createdAt: Value(createdAt.toUtc()),
        updatedAt: Value(updatedAt.toUtc()),
        remoteVersion: Value(item.version),
        needsSync: const Value(false),
        syncedAt: Value(updatedAt.toUtc()),
      ),
    );
  }

  Future<void> _applyRemoteSettings(
    RemoteSyncItem item,
    Map<String, dynamic> payload,
  ) async {
    _writeStringPreference(
      storageKey: preferredLocaleKey,
      raw: payload['locale'],
    );
    _writeStringPreference(
      storageKey: preferredThemeModeKey,
      raw: payload['themeMode'],
    );
    _writeIntPreference(
      storageKey: preferredSeedColorKey,
      raw: payload['seedColor'],
    );
    _writeStringListPreference(
      storageKey: moduleOrderKey,
      raw: payload['moduleOrder'],
    );
    _writeStringListPreference(
      storageKey: enabledModulesKey,
      raw: payload['enabledModules'],
    );
    _writeStringPreference(
      storageKey: timeTrackingRoundingKey,
      raw: payload['timeTrackingRounding'],
    );
    _writeStringPreference(
      storageKey: timeTrackingTargetModeKey,
      raw: payload['timeTrackingTargetMode'],
    );
    _writeIntPreference(
      storageKey: timeTrackingDailyTargetMinutesKey,
      raw: payload['timeTrackingDailyTargetMinutes'],
    );
    _writeIntPreference(
      storageKey: timeTrackingWeeklyTargetMinutesKey,
      raw: payload['timeTrackingWeeklyTargetMinutes'],
    );
    final Object? personalTemplateRaw = payload.containsKey('journalTemplatePersonal')
        ? payload['journalTemplatePersonal']
        : payload['journalTemplate'];
    _writeStringPreference(
      storageKey: journalTemplatePersonalKey,
      raw: personalTemplateRaw,
      allowEmpty: true,
    );
    _writeStringPreference(
      storageKey: journalTemplateKey,
      raw: personalTemplateRaw,
      allowEmpty: true,
    );
    _writeStringPreference(
      storageKey: journalTemplateWorkKey,
      raw: payload['journalTemplateWork'],
      allowEmpty: true,
    );
    _writeStringListPreference(
      storageKey: journalEnabledCategoriesKey,
      raw: payload['journalEnabledCategories'],
    );
    _writeStringPreference(
      storageKey: journalPinHashKey,
      raw: payload['journalPinHash'],
      allowEmpty: true,
    );
    _writeStringPreference(
      storageKey: journalPinSaltKey,
      raw: payload['journalPinSalt'],
      allowEmpty: true,
    );
    _writeBoolPreference(
      storageKey: journalBiometricEnabledKey,
      raw: payload['journalBiometricEnabled'],
    );
    _writeStringPreference(
      storageKey: notesDefaultOpenModeKey,
      raw: payload['notesDefaultOpenMode'],
    );

    // Dashboard Card Settings anwenden
    final dashboardCardSettingsRaw = payload['dashboardCardSettings'];
    if (dashboardCardSettingsRaw is Map) {
      final cardSettings = <String, Map<String, dynamic>>{};
      for (final entry in dashboardCardSettingsRaw.entries) {
        if (entry.key is String && entry.value is Map) {
          cardSettings[entry.key as String] =
              Map<String, dynamic>.from(entry.value as Map);
        }
      }
      if (cardSettings.isNotEmpty) {
        storageBox.put(dashboardCardSettingsKey, cardSettings);
      }
    }

    final DateTime updatedAt =
        _parseDate(payload['updatedAt']) ??
        item.clientUpdatedAt ??
        item.updatedAt;
    _storeSettingsMetadata(
      remoteId: item.id,
      remoteVersion: item.version,
      updatedAt: updatedAt,
    );
  }

  Map<String, Object?> _serializeSettingsPayload({
    required DateTime updatedAt,
  }) {
    List<String>? readList(String key) {
      final raw = storageBox.get(key);
      if (raw is List) {
        return raw
            .map((value) => value is String ? value : '$value')
            .cast<String>()
            .toList(growable: false);
      }
      return null;
    }

    int? readInt(String key) {
      final raw = storageBox.get(key);
      if (raw is int) {
        return raw;
      }
      if (raw is num) {
        return raw.toInt();
      }
      return null;
    }

    bool? readBool(String key) {
      final raw = storageBox.get(key);
      return raw is bool ? raw : null;
    }

    String? readTemplate(String key) {
      final raw = storageBox.get(key);
      return raw is String && raw.isNotEmpty ? raw : raw is String ? '' : null;
    }

    final String? personalTemplate =
        readTemplate(journalTemplatePersonalKey) ?? readTemplate(journalTemplateKey);
    final String? workTemplate = readTemplate(journalTemplateWorkKey);
    final Object? pinHashRaw = storageBox.get(journalPinHashKey);
    final Object? pinSaltRaw = storageBox.get(journalPinSaltKey);

    // Dashboard Card Settings lesen
    Map<String, Map<String, dynamic>>? readCardSettings() {
      final raw = storageBox.get(dashboardCardSettingsKey);
      if (raw is Map) {
        final result = <String, Map<String, dynamic>>{};
        for (final entry in raw.entries) {
          if (entry.key is String && entry.value is Map) {
            result[entry.key as String] =
                Map<String, dynamic>.from(entry.value as Map);
          }
        }
        return result.isNotEmpty ? result : null;
      }
      return null;
    }

    return <String, Object?>{
      'locale': storageBox.get(preferredLocaleKey) as String?,
      'themeMode': storageBox.get(preferredThemeModeKey) as String?,
      'seedColor': readInt(preferredSeedColorKey),
      'moduleOrder': readList(moduleOrderKey),
      'enabledModules': readList(enabledModulesKey),
      'timeTrackingRounding':
          storageBox.get(timeTrackingRoundingKey) as String?,
      'timeTrackingTargetMode':
          storageBox.get(timeTrackingTargetModeKey) as String?,
      'timeTrackingDailyTargetMinutes': readInt(
        timeTrackingDailyTargetMinutesKey,
      ),
      'timeTrackingWeeklyTargetMinutes': readInt(
        timeTrackingWeeklyTargetMinutesKey,
      ),
      'journalTemplate': personalTemplate,
      'journalTemplatePersonal': personalTemplate,
      'journalTemplateWork': workTemplate,
      'journalPinHash': pinHashRaw is String ? pinHashRaw : null,
      'journalPinSalt': pinSaltRaw is String ? pinSaltRaw : null,
      'journalBiometricEnabled': readBool(journalBiometricEnabledKey),
      'journalEnabledCategories': readList(journalEnabledCategoriesKey),
      'notesDefaultOpenMode':
          storageBox.get(notesDefaultOpenModeKey) as String?,
      'dashboardCardSettings': readCardSettings(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  void _writeStringPreference({
    required String storageKey,
    Object? raw,
    bool allowEmpty = false,
  }) {
    final value = _parseString(raw, allowEmpty: allowEmpty);
    if (value == null) {
      storageBox.delete(storageKey);
    } else {
      storageBox.put(storageKey, value);
    }
  }

  void _writeIntPreference({required String storageKey, Object? raw}) {
    final value = _parseInt(raw);
    if (value == null) {
      storageBox.delete(storageKey);
    } else {
      storageBox.put(storageKey, value);
    }
  }

  void _writeStringListPreference({required String storageKey, Object? raw}) {
    final list = _parseStringList(raw);
    if (list == null) {
      storageBox.delete(storageKey);
    } else {
      storageBox.put(storageKey, list);
    }
  }

  void _writeBoolPreference({required String storageKey, Object? raw}) {
    final value = _parseBool(raw);
    if (value == null) {
      storageBox.delete(storageKey);
    } else {
      storageBox.put(storageKey, value);
    }
  }

  String? _parseString(Object? value, {bool allowEmpty = false}) {
    if (value is String) {
      if (allowEmpty) {
        return value;
      }
      final trimmed = value.trim();
      if (trimmed.isEmpty) {
        return null;
      }
      return value;
    }
    return null;
  }

  int? _parseInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }

  bool? _parseBool(Object? value) {
    if (value is bool) {
      return value;
    }
    return null;
  }

  List<String>? _parseStringList(Object? value) {
    if (value is List) {
      return value
          .map((entry) => entry is String ? entry : '$entry')
          .map((entry) => entry.trim())
          .where((entry) => entry.isNotEmpty)
          .cast<String>()
          .toList(growable: false);
    }
    return null;
  }

  void _storeSettingsMetadata({
    required String remoteId,
    required int remoteVersion,
    required DateTime updatedAt,
    bool markDirty = false,
  }) {
    storageBox
      ..put(settingsRemoteIdKey, remoteId)
      ..put(settingsRemoteVersionKey, remoteVersion)
      ..put(settingsLastUpdatedAtKey, updatedAt.toIso8601String())
      ..put(settingsDirtyKey, markDirty);
  }

  bool get _isSettingsDirty {
    final raw = storageBox.get(settingsDirtyKey);
    if (raw is bool) {
      return raw;
    }
    return true;
  }

  String? get _settingsRemoteId {
    final raw = storageBox.get(settingsRemoteIdKey);
    if (raw is String && raw.isNotEmpty) {
      return raw;
    }
    return null;
  }

  int get _settingsRemoteVersion {
    final raw = storageBox.get(settingsRemoteVersionKey);
    if (raw is int) {
      return raw;
    }
    if (raw is num) {
      return raw.toInt();
    }
    return 0;
  }

  DateTime _ensureSettingsUpdatedAt() {
    final raw = storageBox.get(settingsLastUpdatedAtKey);
    if (raw is String && raw.isNotEmpty) {
      final parsed = DateTime.tryParse(raw);
      if (parsed != null) {
        return parsed.toUtc();
      }
    }
    final now = DateTime.now().toUtc();
    storageBox.put(settingsLastUpdatedAtKey, now.toIso8601String());
    return now;
  }

  Future<void> _applyServerTimeEntry(SyncConflictData conflict) async {
    await _applyRemoteTimeEntry(conflict.server, conflict.serverPayload);
  }

  DateTime? _parseDate(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is DateTime) {
      return value.toUtc();
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value)?.toUtc();
    }
    return null;
  }

  DateTime? _readTimestamp(String key) {
    final raw = storageBox.get(key);
    if (raw is String && raw.isNotEmpty) {
      final parsed = DateTime.tryParse(raw);
      return parsed?.toUtc();
    }
    return null;
  }
}

class SyncResult {
  const SyncResult({required this.conflicts});

  final List<SyncConflictData> conflicts;

  bool get hasConflicts => conflicts.isNotEmpty;
}

class SyncConflictData {
  SyncConflictData({
    required this.collection,
    required this.remoteId,
    required this.server,
    required this.serverPayload,
    required this.localPayload,
    this.note,
    this.task,
    this.timeEntry,
    this.settingsUpdatedAt,
  });

  final String collection;
  final String remoteId;
  final RemoteSyncItem server;
  final Map<String, dynamic> serverPayload;
  final Map<String, Object?> localPayload;
  final NoteEntry? note;
  final TaskEntry? task;
  final TimeEntry? timeEntry;
  final DateTime? settingsUpdatedAt;
}

enum ConflictDecision { keepLocal, keepServer }

/// Strategie für automatische Konfliktauflösung bei der Synchronisation.
enum ConflictResolutionStrategy {
  /// Benutzer fragen (aktuelles Verhalten) - Konflikte werden in SyncResult zurückgegeben
  askUser,

  /// Server-Daten gewinnen - Server-Daten werden automatisch angewendet
  serverWins,

  /// Lokale Daten gewinnen - remoteVersion wird aktualisiert und erneut gepusht
  localWins,
}

class SyncStateException implements Exception {
  const SyncStateException(this.message);

  final String message;
}

class _PendingTombstone {
  _PendingTombstone({required this.tombstone, required this.ciphertext});

  final SyncTombstone tombstone;
  final String ciphertext;
}
