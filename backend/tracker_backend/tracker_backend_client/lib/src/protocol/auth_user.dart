/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class AuthUser implements _i1.SerializableModel {
  AuthUser._({
    this.id,
    required this.email,
    required this.passwordHash,
    required this.salt,
    required this.createdAt,
  });

  factory AuthUser({
    int? id,
    required String email,
    required String passwordHash,
    required String salt,
    required DateTime createdAt,
  }) = _AuthUserImpl;

  factory AuthUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthUser(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
      salt: jsonSerialization['salt'] as String,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String email;

  String passwordHash;

  String salt;

  DateTime createdAt;

  /// Returns a shallow copy of this [AuthUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthUser copyWith({
    int? id,
    String? email,
    String? passwordHash,
    String? salt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'passwordHash': passwordHash,
      'salt': salt,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthUserImpl extends AuthUser {
  _AuthUserImpl({
    int? id,
    required String email,
    required String passwordHash,
    required String salt,
    required DateTime createdAt,
  }) : super._(
          id: id,
          email: email,
          passwordHash: passwordHash,
          salt: salt,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [AuthUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthUser copyWith({
    Object? id = _Undefined,
    String? email,
    String? passwordHash,
    String? salt,
    DateTime? createdAt,
  }) {
    return AuthUser(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
