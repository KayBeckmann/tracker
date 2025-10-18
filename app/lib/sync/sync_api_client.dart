import 'dart:convert';

import 'package:http/http.dart' as http;

class SyncApiClient {
  SyncApiClient({required this.baseUrl, http.Client? httpClient})
    : _client = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Uri _resolve(String path, [Map<String, String>? query]) {
    final uri = Uri.parse(baseUrl);
    return uri.replace(
      path: _joinPaths(uri.path, path),
      queryParameters: query,
    );
  }

  Future<List<RemoteSyncItem>> fetchItems({
    required String token,
    required String collection,
    DateTime? since,
  }) async {
    final query = <String, String>{'collection': collection};
    if (since != null) {
      query['since'] = since.toUtc().toIso8601String();
    }

    final response = await _client.get(
      _resolve('/api/sync/items', query),
      headers: _headers(token: token),
    );

    if (response.statusCode != 200) {
      throw SyncApiException(
        response.statusCode,
        _extractError(response.body) ?? 'Synchronisation fehlgeschlagen.',
      );
    }

    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw const SyncApiException(500, 'Ungültige Antwort vom Server.');
    }
    final items = body['items'];
    if (items is! List) {
      return const <RemoteSyncItem>[];
    }

    return items
        .whereType<Map>()
        .map(
          (raw) => RemoteSyncItem.fromJson(
            raw.map((key, value) => MapEntry('$key', value)),
          ),
        )
        .toList();
  }

  Future<UpsertResponse> upsertItems({
    required String token,
    required String collection,
    required List<Map<String, Object?>> items,
  }) async {
    final response = await _client.post(
      _resolve('/api/sync/items'),
      headers: _headers(token: token),
      body: jsonEncode(<String, Object?>{
        'collection': collection,
        'items': items,
      }),
    );

    if (response.statusCode == 409) {
      final body = jsonDecode(response.body);
      if (body is Map && body['conflicts'] is List) {
        final conflictsRaw = body['conflicts'] as List;
        final conflicts = conflictsRaw
            .whereType<Map>()
            .map(
              (raw) => SyncConflict.fromJson(
                raw.map((key, value) => MapEntry('$key', value)),
              ),
            )
            .toList();
        throw SyncConflictException(conflicts);
      }
      throw SyncApiException(409, _extractError(response.body) ?? 'Konflikt.');
    }

    if (response.statusCode != 200) {
      throw SyncApiException(
        response.statusCode,
        _extractError(response.body) ?? 'Synchronisation fehlgeschlagen.',
      );
    }

    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw const SyncApiException(500, 'Ungültige Antwort vom Server.');
    }
    final itemsJson = body['items'];
    final updatedItems = itemsJson is List
        ? itemsJson
              .whereType<Map>()
              .map(
                (raw) => RemoteSyncItem.fromJson(
                  raw.map((key, value) => MapEntry('$key', value)),
                ),
              )
              .toList()
        : const <RemoteSyncItem>[];
    return UpsertResponse(updatedItems);
  }

  Map<String, String> _headers({String? token}) {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  String _joinPaths(String base, String path) {
    final buffer = StringBuffer();
    if (base.isNotEmpty && !base.endsWith('/')) {
      buffer.write(base);
      buffer.write('/');
    } else if (base.isNotEmpty) {
      buffer.write(base);
    }
    if (path.startsWith('/')) {
      buffer.write(path.substring(1));
    } else {
      buffer.write(path);
    }
    return buffer.toString();
  }

  String? _extractError(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['detail'] is String) {
        return decoded['detail'] as String;
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}

class RemoteSyncItem {
  RemoteSyncItem({
    required this.id,
    required this.collection,
    required this.ciphertext,
    required this.version,
    required this.updatedAt,
    this.clientUpdatedAt,
    this.deleted = false,
  });

  factory RemoteSyncItem.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(Object? value) {
      if (value is String) {
        return DateTime.parse(value).toUtc();
      }
      if (value is DateTime) {
        return value.toUtc();
      }
      throw const FormatException('Ungültiges Datumsformat.');
    }

    DateTime? parseDateNullable(Object? value) {
      if (value == null) {
        return null;
      }
      try {
        return parseDate(value);
      } catch (_) {
        return null;
      }
    }

    return RemoteSyncItem(
      id: json['id'] as String,
      collection: json['collection'] as String,
      ciphertext: json['ciphertext'] as String,
      version: (json['version'] as num).toInt(),
      updatedAt: parseDate(json['updatedAt']),
      clientUpdatedAt: parseDateNullable(json['clientUpdatedAt']),
      deleted: json['deleted'] as bool? ?? false,
    );
  }

  final String id;
  final String collection;
  final String ciphertext;
  final int version;
  final DateTime updatedAt;
  final DateTime? clientUpdatedAt;
  final bool deleted;
}

class UpsertResponse {
  UpsertResponse(this.items);

  final List<RemoteSyncItem> items;
}

class SyncConflict {
  SyncConflict({
    required this.id,
    required this.collection,
    required this.server,
    required this.client,
  });

  factory SyncConflict.fromJson(Map<String, dynamic> json) {
    return SyncConflict(
      id: json['id'] as String,
      collection: json['collection'] as String,
      server: RemoteSyncItem.fromJson(
        (json['server'] as Map).map((key, value) => MapEntry('$key', value)),
      ),
      client: json['client'] as Map<String, Object?>? ?? const {},
    );
  }

  final String id;
  final String collection;
  final RemoteSyncItem server;
  final Map<String, Object?> client;
}

class SyncApiException implements Exception {
  const SyncApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;
}

class SyncConflictException implements Exception {
  SyncConflictException(this.conflicts);

  final List<SyncConflict> conflicts;
}
