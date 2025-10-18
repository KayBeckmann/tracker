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
    await server.close(force: true);
    await database.close();
    exit(0);
  }

  ProcessSignal.sigint.watch().listen((_) => shutdown());
  ProcessSignal.sigterm.watch().listen((_) => shutdown());
}
