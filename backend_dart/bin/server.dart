import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'package:backend_dart/src/app_server.dart';
import 'package:backend_dart/src/auth_service.dart';
import 'package:backend_dart/src/config.dart';
import 'package:backend_dart/src/database.dart';
import 'package:backend_dart/src/middleware.dart';
import 'package:backend_dart/src/password_hasher.dart';
import 'package:backend_dart/src/sync_service.dart';

/// Duration of inactivity after which user accounts are deleted.
const inactivityThreshold = Duration(days: 90);

/// Interval for running the cleanup task.
const cleanupInterval = Duration(hours: 24);

Future<void> main(List<String> args) async {
  final config = AppConfig.fromEnv();
  final database = DatabaseManager(config.databaseUrl);
  await database.open();

  final passwordHasher = PasswordHasher();
  final authService = AuthService(
    database: database,
    passwordHasher: passwordHasher,
    jwtSecret: config.jwtSecret,
    tokenExpiry: config.tokenExpiry,
  );
  final syncService = SyncService(database);
  final appServer = AppServer(
    authService: authService,
    syncService: syncService,
  );

  // Run cleanup of inactive accounts on startup
  await _runCleanup(authService);

  // Schedule periodic cleanup every 24 hours
  final cleanupTimer = Timer.periodic(cleanupInterval, (_) {
    _runCleanup(authService);
  });

  final router = appServer.buildRouter();
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(createCorsMiddleware(config.allowOrigins))
      .addMiddleware(createAuthContextMiddleware(authService))
      .addHandler(router.call);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, InternetAddress.anyIPv4, port);
  stdout.writeln('Backend listening on port ${server.port}');

  // Ensure clean shutdown.
  var shuttingDown = false;
  Future<void> shutdown() async {
    if (shuttingDown) {
      return;
    }
    shuttingDown = true;
    stdout.writeln('Shutting down...');
    cleanupTimer.cancel();
    await server.close(force: true);
    await database.close();
    exit(0);
  }

  ProcessSignal.sigint.watch().listen((_) => shutdown());
  ProcessSignal.sigterm.watch().listen((_) => shutdown());
}

/// Runs the cleanup task to delete inactive user accounts.
Future<void> _runCleanup(AuthService authService) async {
  try {
    final deletedCount = await authService.deleteInactiveUsers(
      inactivityThreshold: inactivityThreshold,
    );
    if (deletedCount > 0) {
      stdout.writeln(
        'Cleanup: Deleted $deletedCount inactive user account(s) '
        '(inactive for more than ${inactivityThreshold.inDays} days).',
      );
    }
  } catch (error) {
    stderr.writeln('Cleanup error: $error');
  }
}
