/// `drift_sqlite` features that only work on native platforms.
///
/// Importantly, this includes.
library;

import 'dart:io';

import 'package:drift3/drift.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_connection_pool/sqlite3_connection_pool.dart';

import 'src/connection/pool.dart';

/// Opens a pool of SQLite connection for high-performance and concurrent
/// queries.
///
/// This opens a single connnection for writes and additional [amountOfReaders]
/// connections for reads.
/// The [configureDatabase] callback can be used to run custom pragmas on the
/// database. This method will configure the database to run in the `WAL`
/// journal mode.
///
/// The [preparedStatementCacheSize] parameter can be used to configure a cache
/// of prepared statements to avoid compiling the same statements (by their
/// SQL text) frequently. By default, 16 statements are cached per connection in
/// the pool. The value can be set to `0` to disable the statement cache.
///
/// Two isolates calling [sqliteConnectionPool] with the same path will
/// implicitly use the same connection pool without conflict.
Future<DriftSession> sqliteConnectionPool(
  File file, {
  int amountOfReaders = 4,
  int preparedStatementCacheSize = 16,
  void Function(Database, {required bool isWriter})? configureDatabase,
}) async {
  final path = file.absolute.path;

  final pool = await SqliteConnectionPool.openAsync(
    name: path,
    openConnections: () {
      void configureConnection(Database db, bool isWriter) {
        configureDatabase?.call(db, isWriter: isWriter);

        if (isWriter) {
          db.execute('PRAGMA journal_mode = WAL;');
        }
      }

      final writer = sqlite3.open(path);
      final readers = <Database>[];
      try {
        configureConnection(writer, true);

        for (var i = 0; i < amountOfReaders; i++) {
          final reader = sqlite3.open(path);
          configureConnection(reader, false);
          readers.add(reader);
        }
      } on Object {
        writer.close();
        for (final reader in readers) {
          reader.close();
        }

        rethrow;
      }

      return PoolConnections(writer, readers);
    },
  );

  return SqlitePoolSession(pool);
}
