import 'app_database.dart';
import 'database_deleter_io.dart' if (dart.library.html) 'database_deleter_web.dart';

/// Deletes all local data by closing and removing the database.
Future<void> deleteEverything(AppDatabase db) => deleteEverythingImpl(db);
