import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:drift3/drift.dart';
import 'package:postgres/postgres.dart';

import 'type.dart';

/// A drift database implementation that talks to a postgres database.
final class PostgresSession implements DriftSession {
  final Session _session;
  final Completer<void>? _closeCompleter;
  final _PgVersionDelegate? _versionDelegate;

  PostgresSession._(this._session, [this._versionDelegate])
    : _closeCompleter = _session is SessionExecutor ? null : Completer();

  /// Wraps an opened [Session] as a drift implementation.
  ///
  /// The session will be closed when this database is closed.
  factory PostgresSession.opened(
    Session session, {

    /// Enable migrations on this database.
    bool enableMigrations = true,
  }) {
    final delegate = enableMigrations ? _PgVersionDelegate(session) : null;
    return PostgresSession._(session, delegate);
  }

  @override
  Future<void> close() async {
    if (_session case final SessionExecutor e) {
      await e.close();
    } else {
      _closeCompleter!.complete();
    }
  }

  @override
  Future<void> get closed => _closeCompleter?.future ?? _session.closed;

  @override
  bool get isClosed => _closeCompleter?.isCompleted ?? !_session.isOpen;

  @override
  Future<QueryResult> execute(StatementInfo statement) async {
    final parameters = statement.variables.map((e) => e as TypedValue).toList();
    final result = await _session.execute(
      statement.sql,
      parameters: parameters,
      ignoreRows: !statement.needsResultSet,
    );

    return _mapResult(statement, result);
  }

  @override
  Future<List<QueryResult>> executeBatch(StatementBatch batch) async {
    final prepared = await Future.wait(batch.sql.map(_session.prepare));

    final results = <QueryResult>[];
    for (final instr in batch.statements) {
      final stmt = prepared[instr.sqlIndex];
      final parameters = instr.info.variables
          .map((e) => e as TypedValue)
          .toList();

      final result = await stmt.run(parameters);
      results.add(_mapResult(instr.info, result));
    }

    return results;
  }

  QueryResult _mapResult(StatementInfo statement, Result result) {
    return QueryResult(
      resultSet: statement.needsResultSet ? _PostgresResultSet(result) : null,
      affectedRows: result.affectedRows,
      lastInsertRowId: -1,
    );
  }

  @override
  DriftSessionWithInternalLocks? get locks => null;

  @override
  PersistentSchemaVersion? get persistentSchemaVersion => _versionDelegate;

  @override
  Object? get tag => null;

  @override
  DriftTransactionSession? get transaction => switch (_session) {
    final TxSession tx => _TransactionSession(tx),
    _ => null,
  };

  @override
  DriftTransactionParent? get transactionParent => switch (_session) {
    final SessionExecutor ex => _TransactionParent(ex),
    _ => null,
  };
}

final class _PgVersionDelegate implements PersistentSchemaVersion {
  final Session database;

  final Completer<void> _init = Completer();

  _PgVersionDelegate(this.database);

  Future<void> _waitInitialized() {
    if (!_init.isCompleted) {
      _init.complete(_initialize());
    }

    return _init.future;
  }

  Future<void> _initialize() async {
    await database.execute(
      Sql(
        'CREATE TABLE IF NOT EXISTS __schema ('
        'version integer NOT NULL DEFAULT 0)',
      ),
    );

    final count = await database.execute(Sql('SELECT COUNT(*) FROM __schema'));
    if (count[0][0] as int == 0) {
      await database.execute(Sql('INSERT INTO __schema (version) VALUES (0)'));
    }
  }

  @override
  Future<int> get schemaVersion async {
    await _waitInitialized();

    final result = await database.execute(Sql('SELECT version FROM __schema'));
    return result[0][0] as int;
  }

  @override
  Future<void> writeSchemaVersion(int version) async {
    await _waitInitialized();

    await database.execute(
      Sql(r'UPDATE __schema SET version = $1', types: [Type.integer]),
      parameters: [TypedValue(Type.integer, version)],
    );
  }
}

final class _TransactionParent implements DriftTransactionParent {
  final SessionExecutor _ex;

  _TransactionParent(this._ex);

  @override
  Future<DriftSession> begin(TransactionOptions options) async {
    final transactionStarted = Completer<DriftSession>();

    _ex
        .runTx((tx) async {
          final session = PostgresSession._(tx);
          transactionStarted.complete(session);

          await session.closed;
        })
        // Ensure we don't return without completing the transactionStarted
        // completer.
        .then(
          (_) {
            if (!transactionStarted.isCompleted) {
              transactionStarted.completeError(
                StateError('Transaction never started'),
              );
            }
          },
          onError: (Object e, StackTrace s) {
            if (!transactionStarted.isCompleted) {
              transactionStarted.completeError(e, s);
            }
          },
        );

    return await transactionStarted.future;
  }
}

final class _TransactionSession implements DriftTransactionSession {
  final TxSession _tx;

  _TransactionSession(this._tx);

  @override
  Future<void> commit() async {}

  @override
  Future<void> rollback() async {
    await _tx.rollback();
  }
}

final class _PostgresResultSet extends RawResultSet {
  final Result _result;

  _PostgresResultSet(this._result)
    : super(
        columnNames: [
          for (final column in _result.schema.columns) column.columnName ?? '',
        ],
      );

  @override
  int get length => _result.length;

  @override
  RawRow operator [](int index) {
    final sourceRow = _result[index];
    return _PostgresRow(sourceRow);
  }
}

final class _PostgresRow
    with ListMixin<Object?>, NonGrowableListMixin<Object?>
    implements RawRow {
  final ResultRow _postgresRow;

  _PostgresRow(this._postgresRow);

  @override
  Object? operator [](int index) {
    if (_postgresRow.isSqlNull(index)) {
      return null;
    }

    return PostgresDatabaseValue(
      column: _postgresRow.schema.columns[index],
      value: _postgresRow[index],
    );
  }

  @override
  void operator []=(int index, Object? value) {
    throw UnsupportedError('Modifying postgres row');
  }

  @override
  int get length => _postgresRow.length;
}
