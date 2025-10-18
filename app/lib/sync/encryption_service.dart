import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

class EncryptionService {
  EncryptionService();

  final Pbkdf2 _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 150000,
    bits: 256,
  );
  final Random _random = Random.secure();
  List<int>? _currentKey;

  bool get hasKey => _currentKey != null;

  List<int>? get currentKey => _currentKey;

  Future<List<int>> deriveKey({
    required String password,
    required String saltBase64,
  }) async {
    final salt = base64Decode(saltBase64);
    final secretKey = SecretKey(utf8.encode(password));
    final derived = await _pbkdf2.deriveKey(secretKey: secretKey, nonce: salt);
    final keyBytes = await derived.extractBytes();
    _currentKey = keyBytes;
    return keyBytes;
  }

  void loadKeyFromStorage(String? base64Key) {
    if (base64Key == null || base64Key.isEmpty) {
      _currentKey = null;
      return;
    }
    _currentKey = base64Decode(base64Key);
  }

  String? exportKeyToStorage() {
    final key = _currentKey;
    if (key == null) {
      return null;
    }
    return base64Encode(key);
  }

  Future<String> encryptMap(Map<String, Object?> payload) async {
    final keyBytes = _currentKey;
    if (keyBytes == null) {
      throw StateError('Encryption key has not been initialised.');
    }
    final jsonPayload = jsonEncode(payload);
    final algorithm = AesGcm.with256bits();
    final nonce = _randomBytes(12);
    final secretKey = SecretKey(keyBytes);
    final secretBox = await algorithm.encrypt(
      utf8.encode(jsonPayload),
      secretKey: secretKey,
      nonce: nonce,
    );
    final envelope = <String, String>{
      'nonce': base64Encode(secretBox.nonce),
      'ciphertext': base64Encode(secretBox.cipherText),
      'mac': base64Encode(secretBox.mac.bytes),
    };
    return jsonEncode(envelope);
  }

  Future<Map<String, dynamic>> decryptToMap(String encrypted) async {
    final keyBytes = _currentKey;
    if (keyBytes == null) {
      throw StateError('Encryption key has not been initialised.');
    }
    final envelope = jsonDecode(encrypted);
    if (envelope is! Map<String, dynamic>) {
      throw const FormatException('Ungültiges Verschlüsselungsformat.');
    }
    final nonceBase64 = envelope['nonce'] as String?;
    final ciphertextBase64 = envelope['ciphertext'] as String?;
    final macBase64 = envelope['mac'] as String?;
    if (nonceBase64 == null || ciphertextBase64 == null || macBase64 == null) {
      throw const FormatException('Ungültiges Verschlüsselungsformat.');
    }
    final algorithm = AesGcm.with256bits();
    final secretKey = SecretKey(keyBytes);
    final secretBox = SecretBox(
      base64Decode(ciphertextBase64),
      nonce: base64Decode(nonceBase64),
      mac: Mac(base64Decode(macBase64)),
    );
    final clearBytes = await algorithm.decrypt(secretBox, secretKey: secretKey);
    final decoded = jsonDecode(utf8.decode(clearBytes));
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    if (decoded is Map) {
      return decoded.map((key, value) => MapEntry('$key', value));
    }
    throw const FormatException('Ungültige Nutzlast nach Entschlüsselung.');
  }

  List<int> _randomBytes(int length) {
    return List<int>.generate(length, (_) => _random.nextInt(256));
  }
}
