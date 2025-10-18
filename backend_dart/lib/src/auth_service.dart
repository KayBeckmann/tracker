import 'dart:convert';
import 'dart:math';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:postgres/postgres.dart';

import 'database.dart';
import 'exceptions.dart';
import 'models.dart';
import 'password_hasher.dart';

class AuthService {
  AuthService({
    required DatabaseManager database,
    required PasswordHasher passwordHasher,
    required String jwtSecret,
    required Duration tokenExpiry,
  }) : _database = database,
       _passwordHasher = passwordHasher,
       _jwtSecret = jwtSecret,
       _tokenExpiry = tokenExpiry;

  final DatabaseManager _database;
  final PasswordHasher _passwordHasher;
  final String _jwtSecret;
  final Duration _tokenExpiry;
  final Random _random = Random.secure();

  Future<AuthResponse> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty || password.length < 8) {
      throw const ApiException(400, 'E-Mail und Passwort müssen gültig sein.');
    }

    final passwordHash = await _passwordHasher.hash(password);
    final encryptionSalt = _generateEncryptionSalt();

    try {
      final result = await _database.run((session) async {
        final rows = await session.execute(
          Sql.named('''
INSERT INTO users (
  email, password_hash, encryption_salt, display_name
) VALUES (
  @email, @password_hash, @encryption_salt, @display_name
)
RETURNING id,
          email,
          display_name,
          encryption_salt,
          created_at,
          sync_enabled,
          membership_level,
          membership_expires_at,
          last_payment_method,
          sync_retention_until;
'''),
          parameters: <String, Object?>{
            'email': normalizedEmail,
            'password_hash': passwordHash,
            'encryption_salt': encryptionSalt,
            'display_name': displayName?.trim().isEmpty == true
                ? null
                : displayName?.trim(),
          },
        );
        return rows;
      });

      final user = _mapUser(result.single);
      final token = _generateToken(user.id);
      return AuthResponse(accessToken: token, user: user);
    } on ServerException catch (error) {
      if (error.code == '23505') {
        throw const ApiException(
          409,
          'Die E-Mail-Adresse wird bereits genutzt.',
        );
      }
      rethrow;
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty || password.isEmpty) {
      throw const ApiException(400, 'Bitte E-Mail und Passwort angeben.');
    }

    final result = await _database.run((session) async {
      return session.execute(
        Sql.named('''
SELECT id,
       email,
       display_name,
       password_hash,
       encryption_salt,
       created_at,
       sync_enabled,
       membership_level,
       membership_expires_at,
       last_payment_method,
       sync_retention_until
FROM users
WHERE email = @email
LIMIT 1;
'''),
        parameters: <String, Object?>{'email': normalizedEmail},
      );
    });

    if (result.isEmpty) {
      throw const ApiException(401, 'Die Zugangsdaten sind ungültig.');
    }

    final row = result.single;
    final map = row.toColumnMap();
    final passwordHash = map['password_hash'] as String?;
    if (passwordHash == null) {
      throw const ApiException(401, 'Die Zugangsdaten sind ungültig.');
    }

    final isValid = await _passwordHasher.verify(password, passwordHash);
    if (!isValid) {
      throw const ApiException(401, 'Die Zugangsdaten sind ungültig.');
    }

    final user = _mapUser(row);
    final token = _generateToken(user.id);
    return AuthResponse(accessToken: token, user: user);
  }

  Future<UserRecord?> getUserById(int userId) async {
    final result = await _database.run((session) async {
      return session.execute(
        Sql.named('''
SELECT id,
       email,
       display_name,
       encryption_salt,
       created_at,
       sync_enabled,
       membership_level,
       membership_expires_at,
       last_payment_method,
       sync_retention_until
FROM users
WHERE id = @id
LIMIT 1;
'''),
        parameters: <String, Object?>{'id': userId},
      );
    });

    if (result.isEmpty) {
      return null;
    }
    return _mapUser(result.single);
  }

  String _generateToken(int userId) {
    final jwt = JWT(
      <String, Object?>{'sub': userId.toString()},
      issuer: 'tracker-backend',
      subject: userId.toString(),
    );
    final key = SecretKey(_jwtSecret);
    return jwt.sign(key, expiresIn: _tokenExpiry, noIssueAt: false);
  }

  String _generateEncryptionSalt() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    return base64Encode(bytes);
  }

  UserRecord _mapUser(ResultRow row) {
    final map = row.toColumnMap();
    return UserRecord(
      id: (map['id'] as num).toInt(),
      email: map['email'] as String,
      displayName: map['display_name'] as String?,
      encryptionSalt: map['encryption_salt'] as String? ?? '',
      createdAt: _parseDate(map['created_at']),
      syncEnabled: (map['sync_enabled'] as bool?) ?? true,
      membershipLevel: (map['membership_level'] as String?) ?? 'free',
      membershipExpiresAt: _tryParseDate(map['membership_expires_at']),
      lastPaymentMethod: map['last_payment_method'] as String?,
      syncRetentionUntil: _tryParseDate(map['sync_retention_until']),
    );
  }

  DateTime _parseDate(Object? value) {
    if (value is DateTime) {
      return value.toUtc();
    }
    if (value is String) {
      return DateTime.parse(value).toUtc();
    }
    throw StateError('Unexpected date value: $value');
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

  int? verifyToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(_jwtSecret));
      String? rawSubject;
      if (jwt.payload is Map<String, dynamic>) {
        final payload = jwt.payload as Map<String, dynamic>;
        final subject = payload['sub'] ?? payload['subject'];
        if (subject is String && subject.isNotEmpty) {
          rawSubject = subject;
        }
      }
      rawSubject ??= jwt.subject;
      if (rawSubject == null) {
        return null;
      }
      return int.tryParse(rawSubject);
    } catch (_) {
      return null;
    }
  }
}
