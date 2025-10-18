import 'models.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;
}

class ConflictException extends ApiException {
  ConflictException({required this.conflicts})
    : super(409, 'Sync conflict detected.');

  final List<ConflictEntry> conflicts;
}
