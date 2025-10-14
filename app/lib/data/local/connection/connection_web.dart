import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor openConnectionImpl() {
  return WebDatabase.withStorage(DriftWebStorage.indexedDb('tracker_database'));
}

QueryExecutor openInMemoryConnectionImpl() {
  return WebDatabase.withStorage(DriftWebStorage.volatile());
}
