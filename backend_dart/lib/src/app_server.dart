import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'auth_service.dart';
import 'exceptions.dart';
import 'middleware.dart';
import 'models.dart';
import 'sync_service.dart';

class AppServer {
  AppServer({required this.authService, required this.syncService});

  final AuthService authService;
  final SyncService syncService;

  Router buildRouter() {
    final router = Router()
      ..get('/', _handleHealth)
      ..post('/api/auth/register', _handleRegister)
      ..post('/api/auth/login', _handleLogin)
      ..get('/api/auth/me', _handleMe)
      ..get('/api/membership', _handleMembershipStatus)
      ..post('/api/membership/subscribe', _handleMembershipAction)
      ..post('/api/membership/cancel', _handleMembershipAction)
      ..post('/api/membership/delete_synced_data', _handleDeleteSyncedData)
      ..get('/api/sync/items', _handleSyncFetch)
      ..post('/api/sync/items', _handleSyncUpsert);
    return router;
  }

  Future<Response> _handleHealth(Request request) async {
    return _jsonResponse(<String, Object?>{'status': 'ok'});
  }

  Future<Response> _handleRegister(Request request) async {
    try {
      final body = await _decodeJson(request);
      final email = (body['email'] as String?) ?? '';
      final password = (body['password'] as String?) ?? '';
      final displayName = body['display_name'] as String?;
      final result = await authService.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      return _jsonResponse(result.toJson(), status: 201);
    } on ApiException catch (error) {
      return _errorResponse(error.statusCode, error.message);
    } on FormatException catch (error) {
      return _errorResponse(400, error.message);
    }
  }

  Future<Response> _handleLogin(Request request) async {
    try {
      final body = await _decodeJson(request);
      final email = (body['email'] as String?) ?? '';
      final password = (body['password'] as String?) ?? '';
      final result = await authService.login(email: email, password: password);
      return _jsonResponse(result.toJson());
    } on ApiException catch (error) {
      return _errorResponse(error.statusCode, error.message);
    } on FormatException catch (error) {
      return _errorResponse(400, error.message);
    }
  }

  Future<Response> _handleMe(Request request) async {
    final userId = userIdFromContext(request);
    if (userId == null) {
      return _errorResponse(401, 'Nicht autorisiert.');
    }
    final user = await authService.getUserById(userId);
    if (user == null) {
      return _errorResponse(401, 'Nicht autorisiert.');
    }
    return _jsonResponse(user.toJson());
  }

  Future<Response> _handleMembershipStatus(Request request) async {
    final userId = userIdFromContext(request);
    if (userId == null) {
      return _errorResponse(401, 'Nicht autorisiert.');
    }
    final user = await authService.getUserById(userId);
    if (user == null) {
      return _errorResponse(401, 'Nicht autorisiert.');
    }
    return _jsonResponse(_membershipJson(user));
  }

  Future<Response> _handleMembershipAction(Request request) async {
    final userId = userIdFromContext(request);
    if (userId == null) {
      return _errorResponse(401, 'Nicht autorisiert.');
    }
    final user = await authService.getUserById(userId);
    if (user == null) {
      return _errorResponse(401, 'Nicht autorisiert.');
    }
    // Sync is currently free. We simply echo the membership status.
    return _jsonResponse(_membershipJson(user));
  }

  Future<Response> _handleDeleteSyncedData(Request request) async {
    final userId = userIdFromContext(request);
    if (userId == null) {
      return _errorResponse(401, 'Nicht autorisiert.');
    }
    final user = await authService.getUserById(userId);
    if (user == null) {
      return _errorResponse(401, 'Nicht autorisiert.');
    }

    await syncService.deleteAllForUser(userId);
    return _jsonResponse(_membershipJson(user));
  }

  Future<Response> _handleSyncFetch(Request request) async {
    final userId = userIdFromContext(request);
    if (userId == null) {
      return _errorResponse(401, 'Nicht autorisiert.');
    }

    final collection = request.url.queryParameters['collection'];
    if (collection == null || collection.trim().isEmpty) {
      return _errorResponse(400, 'Parameter "collection" wird benötigt.');
    }

    DateTime? since;
    final sinceParam = request.url.queryParameters['since'];
    if (sinceParam != null && sinceParam.isNotEmpty) {
      since = DateTime.tryParse(sinceParam)?.toUtc();
      if (since == null) {
        return _errorResponse(400, 'Parameter "since" ist ungültig.');
      }
    }

    final items = await syncService.fetchItems(
      userId: userId,
      collection: collection,
      since: since,
    );
    return _jsonResponse(<String, Object?>{
      'items': items.map((item) => item.toJson()).toList(),
    });
  }

  Future<Response> _handleSyncUpsert(Request request) async {
    final userId = userIdFromContext(request);
    if (userId == null) {
      return _errorResponse(401, 'Nicht autorisiert.');
    }

    try {
      final body = await _decodeJson(request);
      final collection = (body['collection'] as String?) ?? '';
      final rawItems = body['items'];
      if (collection.trim().isEmpty || rawItems is! List) {
        return _errorResponse(400, 'Ungültige Synchronisierungsdaten.');
      }
      if (rawItems.any((item) => item is! Map)) {
        return _errorResponse(400, 'Ungültige Synchronisierungsdaten.');
      }
      final items = rawItems
          .cast<Map>()
          .map((raw) => raw.map((key, value) => MapEntry('$key', value)))
          .toList();

      final result = await syncService.upsertItems(
        userId: userId,
        collection: collection,
        items: items,
      );

      return _jsonResponse(result.toJson());
    } on ConflictException catch (conflict) {
      return _jsonResponse(<String, Object?>{
        'detail': 'conflict',
        'conflicts': conflict.conflicts.map((c) => c.toJson()).toList(),
      }, status: 409);
    } on ApiException catch (error) {
      return _errorResponse(error.statusCode, error.message);
    } on FormatException catch (error) {
      return _errorResponse(400, error.message);
    }
  }

  Map<String, Object?> _membershipJson(UserRecord user) {
    return <String, Object?>{
      'membership_level': user.membershipLevel,
      'membership_expires_at': user.membershipExpiresAt?.toIso8601String(),
      'sync_enabled': true,
      'last_payment_method': user.lastPaymentMethod,
      'sync_retention_until': user.syncRetentionUntil?.toIso8601String(),
      'price_monthly': 0.0,
      'price_yearly': 0.0,
    };
  }

  Future<Map<String, dynamic>> _decodeJson(Request request) async {
    final body = await request.readAsString();
    if (body.isEmpty) {
      return <String, dynamic>{};
    }
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    if (decoded is Map) {
      return decoded.map((key, value) => MapEntry('$key', value));
    }
    throw const FormatException('Ungültiger JSON-Body.');
  }

  Response _jsonResponse(Map<String, Object?> body, {int status = 200}) {
    return Response(
      status,
      body: jsonEncode(body),
      headers: const <String, String>{'Content-Type': 'application/json'},
    );
  }

  Response _errorResponse(int statusCode, String message) {
    return Response(
      statusCode,
      body: jsonEncode(<String, Object?>{'detail': message}),
      headers: const <String, String>{'Content-Type': 'application/json'},
    );
  }
}
