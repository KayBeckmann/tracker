import 'dart:io';

class AppConfig {
  AppConfig({
    required this.databaseUrl,
    required this.jwtSecret,
    required this.tokenExpiry,
    required this.allowOrigins,
  });

  final String databaseUrl;
  final String jwtSecret;
  final Duration tokenExpiry;
  final List<String> allowOrigins;

  static AppConfig fromEnv() {
    final env = Platform.environment;
    final databaseUrl = _normaliseDatabaseUrl(
      env['DATABASE_URL'] ??
          'postgres://tracker:tracker@localhost:5432/tracker',
    );
    final jwtSecret = env['AUTH_SECRET_KEY'] ?? 'change-this-secret';
    final expiryMinutes =
        int.tryParse(env['ACCESS_TOKEN_EXPIRE_MINUTES'] ?? '') ?? 60 * 24 * 3;
    final originsRaw = env['CORS_ALLOW_ORIGINS'] ?? '*';
    final allowOrigins = originsRaw
        .split(',')
        .map((origin) => origin.trim())
        .where((origin) => origin.isNotEmpty)
        .toList();

    return AppConfig(
      databaseUrl: databaseUrl,
      jwtSecret: jwtSecret,
      tokenExpiry: Duration(minutes: expiryMinutes),
      allowOrigins: allowOrigins,
    );
  }

  static String _normaliseDatabaseUrl(String url) {
    if (url.startsWith('postgresql+psycopg')) {
      return url.replaceFirst('postgresql+psycopg', 'postgres');
    }
    if (url.startsWith('postgresql://')) {
      return url.replaceFirst('postgresql://', 'postgres://');
    }
    if (!url.contains('sslmode=')) {
      final separator = url.contains('?') ? '&' : '?';
      return '$url${separator}sslmode=disable';
    }
    return url;
  }
}
