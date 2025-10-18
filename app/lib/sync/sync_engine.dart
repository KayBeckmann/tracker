import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../data/local/app_database.dart';
import 'encryption_service.dart';
import 'sync_api_client.dart';

const String encryptionKeyStorageKey = 'encryption_key';
const String encryptionSaltStorageKey = 'encryption_salt';
const String lastSyncNotesKey = 'sync_notes_last';
const String lastSyncTasksKey = 'sync_tasks_last';

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

    if (conflicts.isNotEmpty) {
      return SyncResult(conflicts: conflicts);
    }

    await _pullNotes(token);
    await _pullTasks(token);

    final now = DateTime.now().toUtc();
    storageBox.put(lastSyncNotesKey, now.toIso8601String());
    storageBox.put(lastSyncTasksKey, now.toIso8601String());

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
    }
  }

  Future<void> clearState() async {
    authToken = null;
    encryptionService.loadKeyFromStorage(null);
    await storageBox.delete(encryptionKeyStorageKey);
    await storageBox.delete(encryptionSaltStorageKey);
    await storageBox.delete(lastSyncNotesKey);
    await storageBox.delete(lastSyncTasksKey);
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
  });

  final String collection;
  final String remoteId;
  final RemoteSyncItem server;
  final Map<String, dynamic> serverPayload;
  final Map<String, Object?> localPayload;
  final NoteEntry? note;
  final TaskEntry? task;
}

enum ConflictDecision { keepLocal, keepServer }

class SyncStateException implements Exception {
  const SyncStateException(this.message);

  final String message;
}
