import 'package:drift/drift.dart';

import 'connection_io.dart' if (dart.library.html) 'connection_web.dart';

/// Provides the default database connection for the current platform.
QueryExecutor openConnection() => openConnectionImpl();

/// Provides an in-memory database connection used in tests.
QueryExecutor openInMemoryConnection() => openInMemoryConnectionImpl();
