import 'package:drift/drift.dart';
import 'package:drift/web.dart'; // ignore: deprecated_member_use

QueryExecutor openConnectionImpl() {
  return WebDatabase.withStorage(DriftWebStorage.indexedDb('tracker_database'));
}

QueryExecutor openInMemoryConnectionImpl() {
  return WebDatabase.withStorage(DriftWebStorage.volatile());
}
