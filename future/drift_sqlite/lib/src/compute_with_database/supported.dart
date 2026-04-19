import 'dart:async';
import 'dart:isolate';

import 'package:drift3/drift.dart';
import 'package:sqlite3_connection_pool/sqlite3_connection_pool.dart';

import '../connection/pool.dart';
import 'unsupported.dart' as fallback;

/// Spawns a short-lived isolate to run the [computation] with a drift
/// database.
Future<Ret>
computeWithDatabaseImplementation<Ret, DB extends GeneratedDatabase>({
  required FutureOr<Ret> Function(DB) computation,
  required DB Function(DriftConnection) connect,
  required DB database,
}) async {
  final session = await database.currentSession();
  final dialect = database.dialect;

  if (session.tag case final SqlitePoolSession pool) {
    final name = pool.pool.name;
    final receiveUpdates = ReceivePort();
    final receiveUpdatesSendPort = receiveUpdates.sendPort;
    StreamSubscription<void>? updateSubscription;

    receiveUpdates.listen((message) {
      if (message is SendPort) {
        updateSubscription = database.tableUpdates().listen(message.send);
      } else if (message is Set<TableUpdate>) {
        database.notifyUpdates(message);
      }
    });

    try {
      return await _runWithDatabase(
        computation: computation,
        connect: connect,
        dialect: dialect,
        name: name,
        receiveUpdatesSendPort: receiveUpdatesSendPort,
      );
    } finally {
      updateSubscription?.cancel();
      receiveUpdates.close();
    }
  } else {
    return fallback.computeWithDatabaseImplementation(
      computation: computation,
      connect: connect,
      database: database,
    );
  }
}

Future<T> _runWithDatabase<T, DB extends GeneratedDatabase>({
  required FutureOr<T> Function(DB) computation,
  required DB Function(DriftConnection) connect,
  required DriftDialect dialect,
  required String name,
  required SendPort receiveUpdatesSendPort,
}) {
  return Isolate.run(() async {
    final queries = _RemoteStreamQueries(receiveUpdatesSendPort);
    receiveUpdatesSendPort.send(queries._receiveUpdates.sendPort);

    final database = connect(
      DriftConnection(
        dialect: dialect,
        streamQueries: queries,
        openConnection: () async {
          return SqlitePoolSession(
            SqliteConnectionPool.open(
              name: name,
              openConnections: () => throw StateError(
                'Pool should still be open for original database',
              ),
            ),
            // Don't try to re-run migrations here, the database is already
            // open.
            includePersistentSchemaVersion: false,
          );
        },
      ),
    );
    try {
      return await computation(database);
    } finally {
      await database.close();
    }
  });
}

final class _RemoteStreamQueries extends StreamQueryStore {
  final SendPort _port;
  final ReceivePort _receiveUpdates = ReceivePort(
    'drift table update notifications',
  );
  late final _updates = _receiveUpdates
      .cast<Set<TableUpdate>>()
      .asBroadcastStream();

  _RemoteStreamQueries(this._port);

  @override
  void handleTableUpdates(Set<TableUpdate> updates) {
    _port.send(updates);
  }

  @override
  Stream<Set<TableUpdate>> updatesForSync(TableUpdateQuery query) {
    return _updates
        .map((e) => e.where(query.matches).toSet())
        .where((e) => e.isNotEmpty);
  }

  @override
  Future<void> close() {
    _receiveUpdates.close();
    return super.close();
  }
}
