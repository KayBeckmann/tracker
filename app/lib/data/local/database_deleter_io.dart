import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app_database.dart';

Future<void> deleteEverythingImpl(AppDatabase db) async {
  await db.close();
  final directory = await getApplicationSupportDirectory();
  final file = File(p.join(directory.path, 'tracker.sqlite'));
  if (await file.exists()) {
    await file.delete();
  }
}
