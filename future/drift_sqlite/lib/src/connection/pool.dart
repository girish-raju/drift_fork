import 'dart:async';

import 'package:drift3/drift.dart' hide ResultSet;
import 'package:meta/meta.dart';
import 'package:sqlite3_connection_pool/sqlite3_connection_pool.dart';
// ignore: implementation_imports
import 'package:sqlite3_connection_pool/src/connection.dart'
    show PoolConnection;
import 'package:sqlite3/sqlite3.dart';

import 'shared.dart';

/// A [DriftSession] implemented over a native connection pool.
@internal
final class SqlitePoolSession
    implements
        DriftSession,
        PersistentSchemaVersion,
        DriftTransactionParent,
        DriftSessionWithInternalLocks {
  final SqliteConnectionPool pool;
  final Completer<void> _closed = Completer();

  SqlitePoolSession(this.pool);

  @override
  Future<void> close() async {
    if (!isClosed) {
      pool.close();
      _closed.complete();
    }
  }

  @override
  Future<void> get closed => _closed.future;

  @override
  bool get isClosed => _closed.isCompleted;

  @override
  Future<QueryResult> execute(StatementInfo statement) async {
    final connection = await (statement.isReadOnly
        ? pool.reader()
        : pool.writer());
    try {
      return await _runStatementOnConnection(connection, statement);
    } finally {
      connection.returnLease();
    }
  }

  @override
  Future<List<QueryResult>> executeBatch(StatementBatch batch) async {
    final writer = await pool.writer();
    try {
      return await _runBatchOnConnection(writer, batch);
    } finally {
      writer.returnLease();
    }
  }

  @override
  DriftSessionWithInternalLocks? get locks => this;

  @override
  PersistentSchemaVersion? get persistentSchemaVersion => this;

  @override
  Object? get tag => null;

  @override
  // The root pool itself is never in a transaction, we'd hand out connection
  // leases to implement those.
  DriftTransactionSession? get transaction => null;

  @override
  DriftTransactionParent? get transactionParent => this;

  @override
  Future<DriftSession> begin(TransactionOptions options) async {
    // TODO: Read-only transactions?
    final connection = await pool.writer();

    assert(await connection.autocommit);
    await connection.execute('BEGIN IMMEDIATE;');
    assert(!await connection.autocommit);
    return _TransactionPoolConnection(connection);
  }

  @override
  Future<DriftSession> exclusive() async {
    final access = await pool.exclusiveAccess();
    return _ExclusivePoolConnection(access);
  }

  @override
  Future<int> get schemaVersion async {
    final writer = await pool.writer();
    try {
      final (rs, _) = await writer.select('PRAGMA user_version');
      return rs.rows[0][0] as int;
    } finally {
      writer.returnLease();
    }
  }

  @override
  Future<void> writeSchemaVersion(int version) async {
    final writer = await pool.writer();
    try {
      await writer.execute('PRAGMA user_version = $version;');
    } finally {
      writer.returnLease();
    }
  }
}

List<Object?> _preparedStatementValues(Iterable<MappedValue> values) {
  return values.map((e) => e.rawValue).toList();
}

Future<QueryResult> _runStatementOnConnection(
  AsyncConnection connection,
  StatementInfo statement,
) async {
  final values = _preparedStatementValues(statement.variables);
  ExecuteResult execResult;
  RawResultSet? resultSet;

  if (statement.needsResultSet) {
    final (sqliteResultSet, res) = await connection.select(
      statement.sql,
      values,
    );
    execResult = res;
    resultSet = RawResultSet.fromRows(
      columnNames: sqliteResultSet.columnNames,
      rows: sqliteResultSet.rows,
    );
  } else {
    execResult = await connection.execute(statement.sql, values);
  }

  return QueryResult(
    resultSet: resultSet,
    affectedRows: execResult.changes,
    lastInsertRowId: execResult.lastInsertRowId,
  );
}

Future<List<QueryResult>> _runBatchOnConnection(
  AsyncConnection connection,
  StatementBatch batch,
) async {
  return await connection.unsafeAccessOnIsolate(_runBatch(batch));
}

List<QueryResult> Function(PoolConnection) _runBatch(StatementBatch batch) {
  return (connection) {
    final database = connection.database;
    final results = <QueryResult>[];
    final prepared = <PreparedStatement>[];

    try {
      for (final sql in batch.sql) {
        prepared.add(database.prepare(sql));
      }

      for (final stmt in batch.statements) {
        results.add(
          executeWithStatement(database, prepared[stmt.sqlIndex], stmt.info),
        );
      }
    } finally {
      for (final stmt in prepared) {
        stmt.close();
      }
    }

    return [];
  };
}

abstract class _LeasedPoolConnection implements DriftSession {
  final Completer<void> _closed = Completer();
  final AsyncConnection _connection;

  _LeasedPoolConnection(this._connection);

  void _returnConnection();

  @override
  Future<void> close() async {
    if (!isClosed) {
      _returnConnection();
      _closed.complete();
    }
  }

  @override
  Future<void> get closed => _closed.future;

  @override
  bool get isClosed => _closed.isCompleted;

  @override
  Future<QueryResult> execute(StatementInfo statement) async {
    return await _runStatementOnConnection(_connection, statement);
  }

  @override
  Future<List<QueryResult>> executeBatch(StatementBatch batch) async {
    return await _runBatchOnConnection(_connection, batch);
  }

  @override
  DriftSessionWithInternalLocks? get locks => null;

  @override
  PersistentSchemaVersion? get persistentSchemaVersion => null;

  @override
  Object? get tag => null;

  @override
  DriftTransactionSession? get transaction => null;

  @override
  DriftTransactionParent? get transactionParent => null;
}

final class _TransactionPoolConnection extends _LeasedPoolConnection
    implements DriftTransactionSession {
  final ConnectionLease _lease;

  _TransactionPoolConnection(this._lease) : super(_lease);

  @override
  void _returnConnection() {
    _lease.returnLease();
  }

  @override
  Future<void> commit() async {
    await _connection.execute('COMMIT');
    await close();
  }

  @override
  Future<void> rollback() async {
    await _connection.execute('ROLLBACK');
    await close();
  }
}

final class _ExclusivePoolConnection extends _LeasedPoolConnection {
  final ExclusivePoolAccess _access;

  _ExclusivePoolConnection(this._access) : super(_access.writer);

  @override
  void _returnConnection() {
    _access.close();
  }
}
