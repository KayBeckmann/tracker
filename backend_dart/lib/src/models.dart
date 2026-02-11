class UserRecord {
  UserRecord({
    required this.id,
    required this.email,
    required this.encryptionSalt,
    required this.createdAt,
    this.displayName,
    this.syncEnabled = true,
    this.membershipLevel = 'free',
    this.membershipExpiresAt,
    this.lastPaymentMethod,
    this.syncRetentionUntil,
    this.lastActivityAt,
  });

  final int id;
  final String email;
  final String encryptionSalt;
  final DateTime createdAt;
  final String? displayName;
  final bool syncEnabled;
  final String membershipLevel;
  final DateTime? membershipExpiresAt;
  final String? lastPaymentMethod;
  final DateTime? syncRetentionUntil;
  final DateTime? lastActivityAt;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'email': email,
      'display_name': displayName,
      'created_at': createdAt.toIso8601String(),
      'encryption_salt': encryptionSalt,
      'sync_enabled': syncEnabled,
      'membership_level': membershipLevel,
      'membership_expires_at': membershipExpiresAt?.toIso8601String(),
      'last_payment_method': lastPaymentMethod,
      'sync_retention_until': syncRetentionUntil?.toIso8601String(),
      'last_activity_at': lastActivityAt?.toIso8601String(),
    };
  }
}

class AuthResponse {
  AuthResponse({
    required this.accessToken,
    required this.user,
    this.tokenType = 'bearer',
  });

  final String accessToken;
  final String tokenType;
  final UserRecord user;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'access_token': accessToken,
      'token_type': tokenType,
      'user': user.toJson(),
    };
  }
}

class SyncItemRecord {
  SyncItemRecord({
    required this.id,
    required this.collection,
    required this.ciphertext,
    required this.version,
    required this.updatedAt,
    required this.deleted,
    this.clientUpdatedAt,
  });

  final String id;
  final String collection;
  final String ciphertext;
  final int version;
  final DateTime updatedAt;
  final bool deleted;
  final DateTime? clientUpdatedAt;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'collection': collection,
      'ciphertext': ciphertext,
      'version': version,
      'updatedAt': updatedAt.toIso8601String(),
      if (clientUpdatedAt != null)
        'clientUpdatedAt': clientUpdatedAt!.toIso8601String(),
      'deleted': deleted,
    };
  }
}

class ConflictEntry {
  ConflictEntry({
    required this.id,
    required this.collection,
    required this.server,
    required this.client,
  });

  final String id;
  final String collection;
  final SyncItemRecord server;
  final Map<String, Object?> client;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'collection': collection,
      'server': server.toJson(),
      'client': client,
    };
  }
}

class SyncUpsertResult {
  SyncUpsertResult({required this.items});

  final List<SyncItemRecord> items;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
