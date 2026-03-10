import 'dart:async';

import 'package:drift3/drift.dart';
import 'package:sqlite3/common.dart' as sqlite;

import '../dialect/dialect.dart';
import 'native_functions.dart';
import 'shared.dart';

/// A [DriftSession] implemented by synchronously running queries against a
/// [sqlite.CommonDatabase].
///
/// This is not a recommended implementation to use directly. Instead, use
/// packages like `drift_flutter` or utilities provided in this package to setup
/// a background pool of isolate to run queries.
final class SqliteConnection implements DriftSession, PersistentSchemaVersion {
  /// The database used for the connection.
  final sqlite.CommonDatabase database;

  /// Whether the [database] should be closed when [close] is called on this
  /// instance.
  ///
  /// This defaults to `true`, but can be disabled to virtually open multiple
  /// connections to the same database.
  final bool closeUnderlyingWhenClosed;

  /// Whether this connection implementation will cache prepared statements to
  /// re-use them when used frequently (as opposed to re-compiling them every
  /// time they're executed).
  final bool cachePreparedStatements;

  /// For non-durable file systems, an explicit callback to flush pending
  /// writes.
  final Future<void> Function()? flush;

  final Completer<void> _closedCompleter = Completer();

  /// Wrap a [database] as a [DriftSession].
  SqliteConnection(
    this.database, {
    this.cachePreparedStatements = true,
    this.closeUnderlyingWhenClosed = true,
    this.flush,
  }) {
    database.useNativeFunctions();
  }

  @override
  Object? get tag => null;

  @override
  PersistentSchemaVersion? get persistentSchemaVersion => this;

  @override
  DriftTransactionSession? get transaction => null;

  @override
  DriftTransactionParent? get transactionParent => null;

  @override
  DriftSessionWithInternalLocks? get locks => null;

  @override
  Future<QueryResult> execute(StatementInfo statement) async {
    final sql = statement.sql;
    if (statement.variables.isEmpty && !statement.needsResultSet) {
      // Do this because it allows running multiple statements at once
      database.execute(sql);

      return QueryResult(
        affectedRows: database.updatedRows,
        resultSet: null,
        lastInsertRowId: database.lastInsertRowId,
      );
    }

    final stmt = database.prepare(sql, checkNoTail: true);
    try {
      return _executeWithStatement(stmt, statement);
    } finally {
      await _maybeFlush();
      stmt.close();
    }
  }

  QueryResult _executeWithStatement(
    sqlite.CommonPreparedStatement stmt,
    StatementInfo info,
  ) {
    return executeWithStatement(database, stmt, info);
  }

  @override
  Future<List<QueryResult>> executeBatch(StatementBatch batch) async {
    final results = <QueryResult>[];
    final prepared = <sqlite.CommonPreparedStatement>[];

    try {
      for (final sql in batch.sql) {
        prepared.add(database.prepare(sql, checkNoTail: true));
      }

      for (final stmt in batch.statements) {
        results.add(_executeWithStatement(prepared[stmt.sqlIndex], stmt.info));
      }
    } finally {
      for (final stmt in prepared) {
        stmt.close();
      }
    }

    await _maybeFlush();
    return results;
  }

  @override
  bool get isClosed => _closedCompleter.isCompleted;

  @override
  Future<void> get closed => _closedCompleter.future;

  @override
  Future<void> close() async {
    if (!_closedCompleter.isCompleted) {
      if (closeUnderlyingWhenClosed) {
        database.close();
      }
      _closedCompleter.complete(_maybeFlush());
    }

    return closed;
  }

  Future<void> _maybeFlush() async {
    if (flush != null && database.autocommit) {
      await flush!();
    }
  }

  @override
  Future<int> get schemaVersion async => database.userVersion;

  @override
  Future<void> writeSchemaVersion(int version) async {
    database.userVersion = version;
  }

  /// Returns a [DriftConnection] backed by a SQLite
  /// [sqlite.CommonDatabase] obtained by calling [open].
  ///
  /// Closing this [SqliteConnection] will close the database.
  static DriftConnection synchronous({
    required sqlite.CommonDatabase Function() open,
    SqliteDialect dialect = const SqliteDialect(),
  }) {
    return DriftConnection(
      dialect: dialect,
      openConnection: () async => SqliteConnection(open()),
    );
  }
}
