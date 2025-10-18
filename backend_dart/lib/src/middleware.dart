import 'package:shelf/shelf.dart';

import 'auth_service.dart';

Middleware createCorsMiddleware(List<String> allowedOrigins) {
  final allowAll = allowedOrigins.contains('*');

  return (Handler handler) {
    return (Request request) async {
      final origin = request.headers['origin'];
      String? allowedOrigin;
      if (allowAll) {
        allowedOrigin = origin ?? '*';
      } else if (origin != null &&
          allowedOrigins.any((allowed) => allowed == origin)) {
        allowedOrigin = origin;
      }

      if (request.method == 'OPTIONS') {
        final headers = <String, String>{
          if (allowedOrigin != null)
            'Access-Control-Allow-Origin': allowedOrigin,
          'Access-Control-Allow-Methods': 'GET,POST,PUT,PATCH,DELETE,OPTIONS',
          'Access-Control-Allow-Headers':
              request.headers['access-control-request-headers'] ??
              'Content-Type, Authorization',
          'Access-Control-Max-Age': '86400',
        };
        if (!allowAll && allowedOrigin != null) {
          headers['Access-Control-Allow-Credentials'] = 'true';
        }
        return Response.ok('', headers: headers);
      }

      final response = await handler(request);
      if (allowedOrigin == null) {
        return response;
      }

      final updatedHeaders = Map<String, String>.from(response.headers);
      updatedHeaders['Access-Control-Allow-Origin'] = allowedOrigin;
      updatedHeaders['Access-Control-Allow-Methods'] =
          'GET,POST,PUT,PATCH,DELETE,OPTIONS';
      updatedHeaders['Access-Control-Allow-Headers'] =
          request.headers['access-control-request-headers'] ??
          'Content-Type, Authorization';
      if (!allowAll) {
        updatedHeaders['Access-Control-Allow-Credentials'] = 'true';
      }
      return response.change(headers: updatedHeaders);
    };
  };
}

Middleware createAuthContextMiddleware(AuthService authService) {
  return (Handler handler) {
    return (Request request) async {
      final authHeader = request.headers['authorization'];
      if (authHeader != null &&
          authHeader.toLowerCase().startsWith('bearer ')) {
        final token = authHeader.substring(7).trim();
        final userId = authService.verifyToken(token);
        if (userId != null) {
          final updated = request.change(
            context: {...request.context, 'userId': userId, 'token': token},
          );
          return handler(updated);
        }
      }
      return handler(request);
    };
  };
}

int? userIdFromContext(Request request) {
  final id = request.context['userId'];
  if (id is int) {
    return id;
  }
  if (id is String) {
    return int.tryParse(id);
  }
  return null;
}
