import 'dart:async';

import 'package:drift/drift.dart' show Value;
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

  Future<SyncResult> synchronize() async {
    if (!isReady) {
      throw const SyncStateException('Synchronisation nicht vorbereitet.');
    }

    final token = authToken!;
    final conflicts = <SyncConflictData>[];

    final noteConflicts = await _pushNotes(token);
    conflicts.addAll(noteConflicts);
    final taskConflicts = await _pushTasks(token);
    conflicts.addAll(taskConflicts);
    final timeConflicts = await _pushTimeEntries(token);
    conflicts.addAll(timeConflicts);
    final settingsConflicts = await _pushSettings(token);
    conflicts.addAll(settingsConflicts);

    if (conflicts.isNotEmpty) {
      return SyncResult(conflicts: conflicts);
    }

    await _pullNotes(token);
    await _pullTasks(token);
    await _pullTimeEntries(token);
    await _pullSettings(token);

    final now = DateTime.now().toUtc();
    storageBox.put(lastSyncNotesKey, now.toIso8601String());
    storageBox.put(lastSyncTasksKey, now.toIso8601String());
    storageBox.put(lastSyncTimeEntriesKey, now.toIso8601String());
    storageBox.put(lastSyncSettingsKey, now.toIso8601String());

    return const SyncResult(conflicts: <SyncConflictData>[]);
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
    await storageBox.delete(settingsRemoteIdKey);
    await storageBox.delete(settingsRemoteVersionKey);
    await storageBox.delete(settingsLastUpdatedAtKey);
    await storageBox.delete(settingsDirtyKey);
  }

  Future<List<SyncConflictData>> _pushNotes(String token) async {
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
        conflicts.add(
          SyncConflictData(
            collection: 'notes',
            remoteId: entry.id,
            server: entry.server,
            serverPayload: serverPayload,
            localPayload: localPayload,
            note: local,
          ),
        );
      }
      return conflicts;
    }
  }

  Future<List<SyncConflictData>> _pushTasks(String token) async {
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
        conflicts.add(
          SyncConflictData(
            collection: 'tasks',
            remoteId: entry.id,
            server: entry.server,
            serverPayload: serverPayload,
            localPayload: localPayload,
            task: local,
          ),
        );
      }
      return conflicts;
    }
  }

  Future<List<SyncConflictData>> _pushTimeEntries(String token) async {
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
            (local != null ? await _serializeTimeEntry(local) : <String, Object?>{});
        conflicts.add(
          SyncConflictData(
            collection: 'time_entries',
            remoteId: entry.id,
            server: entry.server,
            serverPayload: serverPayload,
            localPayload: localPayload,
            timeEntry: local,
          ),
        );
      }
      return conflicts;
    }
  }

  Future<List<SyncConflictData>> _pushSettings(String token) async {
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
        conflicts.add(
          SyncConflictData(
            collection: 'settings',
            remoteId: entry.id,
            server: entry.server,
            serverPayload: serverPayload,
            localPayload: payload,
            settingsUpdatedAt: updatedAt,
          ),
        );
      }
      return conflicts;
    }
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

  Map<String, Object?> _serializeNote(NoteEntry note) {
    return <String, Object?>{
      'kind': note.kind.name,
      'title': note.title,
      'content': note.content,
      'drawingJson': note.drawingJson,
      'tags': note.tags,
      'createdAt': note.createdAt.toUtc().toIso8601String(),
      'updatedAt': note.updatedAt.toUtc().toIso8601String(),
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
      ),
    );
  }

  Future<void> _applyServerNote(SyncConflictData conflict) async {
    await _applyRemoteNote(conflict.server, conflict.serverPayload);
  }

  Future<void> _applyServerTask(SyncConflictData conflict) async {
    await _applyRemoteTask(conflict.server, conflict.serverPayload);
  }

  Future<void> _applyRemoteTimeEntry(
    RemoteSyncItem item,
    Map<String, dynamic> payload,
  ) async {
    final existing = await database.getTimeEntryByRemoteId(item.id);
    final startedAt =
        _parseDate(payload['startedAt']) ?? item.updatedAt.toUtc();
    final endedAt = _parseDate(payload['endedAt']);
    final durationMinutes =
        (payload['durationMinutes'] as num?)?.toInt() ?? 0;
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
            endedAt:
                endedAt == null ? const Value.absent() : Value(endedAt.toUtc()),
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
        endedAt: endedAt == null ? const Value.absent() : Value(endedAt.toUtc()),
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
    _writeStringPreference(
      storageKey: journalTemplateKey,
      raw: payload['journalTemplate'],
      allowEmpty: true,
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

    final DateTime updatedAt =
        _parseDate(payload['updatedAt']) ?? item.clientUpdatedAt ??
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

    final Object? templateRaw = storageBox.get(journalTemplateKey);
    final Object? pinHashRaw = storageBox.get(journalPinHashKey);
    final Object? pinSaltRaw = storageBox.get(journalPinSaltKey);

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
      'timeTrackingDailyTargetMinutes':
          readInt(timeTrackingDailyTargetMinutesKey),
      'timeTrackingWeeklyTargetMinutes':
          readInt(timeTrackingWeeklyTargetMinutesKey),
      'journalTemplate': templateRaw is String ? templateRaw : null,
      'journalPinHash': pinHashRaw is String ? pinHashRaw : null,
      'journalPinSalt': pinSaltRaw is String ? pinSaltRaw : null,
      'journalBiometricEnabled': readBool(journalBiometricEnabledKey),
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

class SyncStateException implements Exception {
  const SyncStateException(this.message);

  final String message;
}
