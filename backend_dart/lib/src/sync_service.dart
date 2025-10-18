import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

import 'database.dart';
import 'exceptions.dart';
import 'models.dart';

class SyncService {
  SyncService(this._database);

  final DatabaseManager _database;
  final Uuid _uuid = const Uuid();

  Future<List<SyncItemRecord>> fetchItems({
    required int userId,
    required String collection,
    DateTime? since,
  }) async {
    final DateTime? normalizedSince = since?.toUtc();
    final String query = normalizedSince == null
        ? '''
SELECT id,
       collection,
       ciphertext,
       version,
       updated_at,
       client_updated_at,
       deleted
FROM sync_items
WHERE user_id = @user_id
  AND collection = @collection
ORDER BY updated_at ASC;
'''
        : '''
SELECT id,
       collection,
       ciphertext,
       version,
       updated_at,
       client_updated_at,
       deleted
FROM sync_items
WHERE user_id = @user_id
  AND collection = @collection
  AND updated_at >= @since
ORDER BY updated_at ASC;
''';

    final result = await _database.run((session) {
      return session.execute(
        Sql.named(query),
        parameters: <String, Object?>{
          'user_id': userId,
          'collection': collection,
          if (normalizedSince != null) 'since': normalizedSince,
        },
      );
    });

    return result.map(_mapRow).toList(growable: false);
  }

  Future<SyncUpsertResult> upsertItems({
    required int userId,
    required String collection,
    required List<Map<String, Object?>> items,
  }) async {
    if (items.isEmpty) {
      return SyncUpsertResult(items: const <SyncItemRecord>[]);
    }

    final updatedItems = <SyncItemRecord>[];
    final conflicts = <ConflictEntry>[];

    await _database.runTx((session) async {
      for (final raw in items) {
        final parsed = _parseIncoming(raw, fallbackCollection: collection);
        final existingResult = await session.execute(
          Sql.named('''
SELECT id,
       collection,
       ciphertext,
       version,
       updated_at,
       client_updated_at,
       deleted
FROM sync_items
WHERE id = @id AND user_id = @user_id
FOR UPDATE;
'''),
          parameters: <String, Object?>{'id': parsed.id, 'user_id': userId},
        );

        if (existingResult.isEmpty) {
          final inserted = await session.execute(
            Sql.named('''
INSERT INTO sync_items (
  id,
  user_id,
  collection,
  ciphertext,
  version,
  client_updated_at,
  deleted
) VALUES (
  @id,
  @user_id,
  @collection,
  @ciphertext,
  @version,
  @client_updated_at,
  @deleted
)
RETURNING id,
          collection,
          ciphertext,
          version,
          updated_at,
          client_updated_at,
          deleted;
'''),
            parameters: <String, Object?>{
              'id': parsed.id,
              'user_id': userId,
              'collection': parsed.collection,
              'ciphertext': parsed.ciphertext,
              'version': parsed.version,
              'client_updated_at': parsed.clientUpdatedAt,
              'deleted': parsed.deleted,
            },
          );
          updatedItems.add(_mapRow(inserted.single));
        } else {
          final existing = _mapRow(existingResult.single);
          if (parsed.version <= existing.version) {
            conflicts.add(
              ConflictEntry(
                id: existing.id,
                collection: existing.collection,
                server: existing,
                client: <String, Object?>{
                  'id': parsed.id,
                  'collection': parsed.collection,
                  'ciphertext': parsed.ciphertext,
                  'version': parsed.version,
                  'clientUpdatedAt': parsed.clientUpdatedAt?.toIso8601String(),
                  'deleted': parsed.deleted,
                },
              ),
            );
            continue;
          }

          final updated = await session.execute(
            Sql.named('''
UPDATE sync_items
SET ciphertext = @ciphertext,
    version = @version,
    client_updated_at = @client_updated_at,
    deleted = @deleted,
    updated_at = NOW()
WHERE id = @id AND user_id = @user_id
RETURNING id,
          collection,
          ciphertext,
          version,
          updated_at,
          client_updated_at,
          deleted;
'''),
            parameters: <String, Object?>{
              'id': parsed.id,
              'user_id': userId,
              'ciphertext': parsed.ciphertext,
              'version': parsed.version,
              'client_updated_at': parsed.clientUpdatedAt,
              'deleted': parsed.deleted,
            },
          );
          updatedItems.add(_mapRow(updated.single));
        }
      }

      if (conflicts.isNotEmpty) {
        throw ConflictException(conflicts: conflicts);
      }
    });

    return SyncUpsertResult(items: updatedItems);
  }

  Future<void> deleteAllForUser(int userId) async {
    await _database.run((session) async {
      await session.execute(
        Sql.named('DELETE FROM sync_items WHERE user_id = @user_id;'),
        parameters: <String, Object?>{'user_id': userId},
      );
    });
  }

  _IncomingItem _parseIncoming(
    Map<String, Object?> raw, {
    required String fallbackCollection,
  }) {
    final idValue = raw['id'];
    final id = idValue is String && idValue.isNotEmpty ? idValue : _uuid.v4();

    final collection = (raw['collection'] as String?)?.trim().isNotEmpty == true
        ? (raw['collection'] as String).trim()
        : fallbackCollection;

    final ciphertext = raw['ciphertext'] as String?;
    if (ciphertext == null || ciphertext.isEmpty) {
      throw const ApiException(400, 'Ciphertext is required for sync items.');
    }

    final versionValue = raw['version'];
    int version;
    if (versionValue is int) {
      version = versionValue;
    } else if (versionValue is num) {
      version = versionValue.toInt();
    } else {
      version = 1;
    }
    if (version < 1) {
      version = 1;
    }

    final deleted = raw['deleted'] is bool ? raw['deleted'] as bool : false;

    DateTime? clientUpdatedAt;
    final clientUpdatedValue = raw['clientUpdatedAt'] ?? raw['updatedAt'];
    if (clientUpdatedValue is DateTime) {
      clientUpdatedAt = clientUpdatedValue.toUtc();
    } else if (clientUpdatedValue is String &&
        clientUpdatedValue.trim().isNotEmpty) {
      clientUpdatedAt = DateTime.tryParse(clientUpdatedValue)?.toUtc();
    }

    return _IncomingItem(
      id: id,
      collection: collection,
      ciphertext: ciphertext,
      version: version,
      clientUpdatedAt: clientUpdatedAt,
      deleted: deleted,
    );
  }

  SyncItemRecord _mapRow(ResultRow row) {
    final map = row.toColumnMap();
    return SyncItemRecord(
      id: map['id'] as String,
      collection: map['collection'] as String,
      ciphertext: map['ciphertext'] as String,
      version: (map['version'] as int?) ?? 1,
      updatedAt: _parseDate(map['updated_at']),
      clientUpdatedAt: _tryParseDate(map['client_updated_at']),
      deleted: (map['deleted'] as bool?) ?? false,
    );
  }

  DateTime _parseDate(Object? value) {
    if (value is DateTime) {
      return value.toUtc();
    }
    if (value is String) {
      return DateTime.parse(value).toUtc();
    }
    throw StateError('Cannot parse date from "$value"');
  }

  DateTime? _tryParseDate(Object? value) {
    if (value == null) {
      return null;
    }
    try {
      return _parseDate(value);
    } catch (_) {
      return null;
    }
  }
}

class _IncomingItem {
  _IncomingItem({
    required this.id,
    required this.collection,
    required this.ciphertext,
    required this.version,
    required this.clientUpdatedAt,
    required this.deleted,
  });

  final String id;
  final String collection;
  final String ciphertext;
  final int version;
  final DateTime? clientUpdatedAt;
  final bool deleted;
}
