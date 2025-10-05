/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class AuthResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AuthResponse._({
    required this.success,
    required this.message,
    this.userId,
  });

  factory AuthResponse({
    required bool success,
    required String message,
    int? userId,
  }) = _AuthResponseImpl;

  factory AuthResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthResponse(
      success: jsonSerialization['success'] as bool,
      message: jsonSerialization['message'] as String,
      userId: jsonSerialization['userId'] as int?,
    );
  }

  bool success;

  String message;

  int? userId;

  /// Returns a shallow copy of this [AuthResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthResponse copyWith({
    bool? success,
    String? message,
    int? userId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (userId != null) 'userId': userId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'success': success,
      'message': message,
      if (userId != null) 'userId': userId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthResponseImpl extends AuthResponse {
  _AuthResponseImpl({
    required bool success,
    required String message,
    int? userId,
  }) : super._(
          success: success,
          message: message,
          userId: userId,
        );

  /// Returns a shallow copy of this [AuthResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthResponse copyWith({
    bool? success,
    String? message,
    Object? userId = _Undefined,
  }) {
    return AuthResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      userId: userId is int? ? userId : this.userId,
    );
  }
}
