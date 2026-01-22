import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'app_database.dart';

Future<void> deleteEverythingImpl(AppDatabase db) async {
  await db.close();

  final completer = Completer<void>();
  final request = web.window.indexedDB.deleteDatabase('tracker_database');

  request.onsuccess = ((web.Event event) {
    completer.complete();
  }).toJS;

  request.onerror = ((web.Event event) {
    completer.completeError('Failed to delete database');
  }).toJS;

  request.onblocked = ((web.Event event) {
    completer.completeError('Database deletion blocked. Please close other tabs.');
  }).toJS;

  return completer.future;
}
