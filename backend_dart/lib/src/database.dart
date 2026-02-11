import 'package:postgres/postgres.dart';

class DatabaseManager {
  DatabaseManager(this.connectionString);

  final String connectionString;
  late final Pool _pool;
  bool _opened = false;

  Future<void> open() async {
    _pool = Pool.withUrl(connectionString);
    _opened = true;
    await _runMigrations();
  }

  Future<T> run<T>(Future<T> Function(Session session) fn) {
    if (!_opened) {
      throw StateError('Database has not been opened.');
    }
    return _pool.run(fn);
  }

  Future<T> runTx<T>(Future<T> Function(TxSession session) fn) {
    if (!_opened) {
      throw StateError('Database has not been opened.');
    }
    return _pool.runTx(fn);
  }

  Future<void> close() async {
    if (_opened) {
      await _pool.close();
      _opened = false;
    }
  }

  Future<void> _runMigrations() async {
    await run((session) async {
      await session.execute('''
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  encryption_salt TEXT,
  display_name TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  sync_enabled BOOLEAN NOT NULL DEFAULT TRUE,
  membership_level TEXT NOT NULL DEFAULT 'free',
  membership_expires_at TIMESTAMPTZ,
  last_payment_method TEXT,
  sync_retention_until TIMESTAMPTZ
);
''');

      await session.execute(
        'ALTER TABLE users ADD COLUMN IF NOT EXISTS encryption_salt TEXT;',
      );
      await session.execute(
        'ALTER TABLE users ALTER COLUMN encryption_salt DROP NOT NULL;',
      );
      await session.execute(
        'ALTER TABLE users ADD COLUMN IF NOT EXISTS sync_enabled BOOLEAN NOT NULL DEFAULT TRUE;',
      );
      await session.execute(
        "ALTER TABLE users ADD COLUMN IF NOT EXISTS membership_level TEXT NOT NULL DEFAULT 'free';",
      );
      await session.execute(
        'ALTER TABLE users ADD COLUMN IF NOT EXISTS membership_expires_at TIMESTAMPTZ;',
      );
      await session.execute(
        'ALTER TABLE users ADD COLUMN IF NOT EXISTS last_payment_method TEXT;',
      );
      await session.execute(
        'ALTER TABLE users ADD COLUMN IF NOT EXISTS sync_retention_until TIMESTAMPTZ;',
      );
      await session.execute(
        'ALTER TABLE users ADD COLUMN IF NOT EXISTS last_activity_at TIMESTAMPTZ;',
      );
      // Set last_activity_at to created_at for existing users without activity
      await session.execute(
        'UPDATE users SET last_activity_at = created_at WHERE last_activity_at IS NULL;',
      );

      await session.execute('''
CREATE TABLE IF NOT EXISTS sync_items (
  id TEXT PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  collection TEXT NOT NULL,
  ciphertext TEXT NOT NULL,
  version INTEGER NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  client_updated_at TIMESTAMPTZ,
  deleted BOOLEAN NOT NULL DEFAULT FALSE
);
''');

      await session.execute('''
CREATE INDEX IF NOT EXISTS idx_sync_items_user_collection
ON sync_items (user_id, collection);
''');

      await session.execute('''
CREATE INDEX IF NOT EXISTS idx_sync_items_user_updated
ON sync_items (user_id, updated_at DESC);
''');
    });
  }
}
