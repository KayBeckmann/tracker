import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

class PasswordHasher {
  PasswordHasher({this.iterations = 150000, this.keyLength = 32});

  final int iterations;
  final int keyLength;
  final Random _random = Random.secure();

  Future<String> hash(String password) async {
    final salt = _randomBytes(16);
    final hashBytes = await _derive(password, salt, iterations, keyLength);
    final saltB64 = base64Encode(salt);
    final hashB64 = base64Encode(hashBytes);
    return 'pbkdf2_sha256\$$iterations\$$saltB64\$$hashB64';
  }

  Future<bool> verify(String password, String stored) async {
    final parts = stored.split(r'$');
    if (parts.length != 4 || parts[0] != 'pbkdf2_sha256') {
      return false;
    }
    final iterations = int.tryParse(parts[1]);
    if (iterations == null || iterations <= 0) {
      return false;
    }
    final salt = base64Decode(parts[2]);
    final expectedHash = base64Decode(parts[3]);
    final calculated = await _derive(
      password,
      salt,
      iterations,
      expectedHash.length,
    );
    return _constantTimeEquals(calculated, expectedHash);
  }

  List<int> _randomBytes(int length) {
    return List<int>.generate(length, (_) => _random.nextInt(256));
  }

  Future<List<int>> _derive(
    String password,
    List<int> salt,
    int iterations,
    int outputLength,
  ) async {
    final algorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: iterations,
      bits: outputLength * 8,
    );
    final secretKey = SecretKey(utf8.encode(password));
    final newKey = await algorithm.deriveKey(secretKey: secretKey, nonce: salt);
    return newKey.extractBytes();
  }

  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) {
      return false;
    }
    int diff = 0;
    for (int i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
