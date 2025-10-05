import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker_backend_client/tracker_backend_client.dart';

final serverpodClientProvider = Provider<Client>((ref) {
  return Client('http://localhost:8080/');
});
