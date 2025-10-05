import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:serverpod/serverpod.dart';

import 'generated/protocol.dart';

class AuthEndpoint extends Endpoint {
  static const _saltLength = 16;

  Future<AuthResponse> register(
      Session session, String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();

    if (normalizedEmail.isEmpty || password.isEmpty) {
      return AuthResponse(
          success: false,
          message: 'E-Mail und Passwort dürfen nicht leer sein.');
    }

    final existing = await AuthUser.db.findFirstRow(
      session,
      where: (user) => user.email.equals(normalizedEmail),
    );

    if (existing != null) {
      return AuthResponse(
          success: false,
          message: 'Ein Benutzer mit dieser E-Mail existiert bereits.');
    }

    final salt = _generateSalt();
    final hash = _hashPassword(password, salt);

    final user = AuthUser(
      email: normalizedEmail,
      passwordHash: hash,
      salt: salt,
      createdAt: DateTime.now().toUtc(),
    );

    final inserted = await AuthUser.db.insertRow(session, user);

    return AuthResponse(
      success: true,
      message: 'Registrierung erfolgreich.',
      userId: inserted.id,
    );
  }

  Future<AuthResponse> login(
      Session session, String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();

    final user = await AuthUser.db.findFirstRow(
      session,
      where: (row) => row.email.equals(normalizedEmail),
    );

    if (user == null) {
      return AuthResponse(
          success: false, message: 'Unbekannte E-Mail-Adresse.');
    }

    final hash = _hashPassword(password, user.salt);
    if (hash != user.passwordHash) {
      return AuthResponse(success: false, message: 'Passwort ist ungültig.');
    }

    return AuthResponse(
      success: true,
      message: 'Anmeldung erfolgreich.',
      userId: user.id,
    );
  }

  String _hashPassword(String password, String salt) {
    final bytes = <int>[
      ...salt.codeUnits,
      ...password.codeUnits,
    ];
    final digest = crypto.sha256.convert(bytes);
    return digest.toString();
  }

  String _generateSalt() {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rnd = Random.secure();
    return List.generate(
      _saltLength,
      (_) => characters[rnd.nextInt(characters.length)],
    ).join();
  }
}
