import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

LazyDatabase _openLazyDatabase() {
  return LazyDatabase(() async {
    final directory = await getApplicationSupportDirectory();
    final file = File(p.join(directory.path, 'tracker.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

QueryExecutor openConnectionImpl() => _openLazyDatabase();

QueryExecutor openInMemoryConnectionImpl() => NativeDatabase.memory();
