import 'dart:io';

import 'package:drift3/drift.dart';
import 'package:drift_sqlite/native.dart';
import 'package:drift_sqlite/src/dialect/dialect.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  test('schema version', () async {
    final session = await _openPool();
    final version = session.persistentSchemaVersion!;
    expect(await version.schemaVersion, 0);

    for (var i = 1; i < 10; i++) {
      await version.writeSchemaVersion(i);
      expect(await version.schemaVersion, i);
    }
  });

  test('queries', () async {
    final session = await _openPool();
    await session.execute(
      StatementInfo('CREATE TABLE users (id INTEGER NOT NULL PRIMARY KEY)'),
    );
    await session.execute(StatementInfo('INSERT INTO users DEFAULT VALUES'));

    final rs = await session.execute(
      StatementInfo(
        'SELECT * FROM users',
        isReadOnly: true,
        needsResultSet: true,
      ),
    );
    expect(rs.resultSet!.columnNames, ['id']);
    expect(rs.resultSet!, [
      [1],
    ]);
  });

  test('returns new columns after recompilation', () async {
    // https://github.com/simolus3/drift/issues/2454
    final file = File(d.path('test.db'));
    final session = await sqliteConnectionPool(file, amountOfReaders: 1);
    addTearDown(session.close);

    await session.execute(StatementInfo('create table t (c1)'));
    await session.execute(StatementInfo('insert into t values (1)'));

    final before = await session.execute(
      StatementInfo('select * from t', needsResultSet: true),
    );
    expect(before.resultSet, [
      [1],
    ]);

    await session.execute(StatementInfo('alter table t add column c2'));

    final after = await session.execute(
      StatementInfo('select * from t', needsResultSet: true),
    );
    expect(after.resultSet, [
      [1, null],
    ]);
  });

  test('can use a custom setup function', () async {
    final file = File(d.path('test.db'));
    final session = await sqliteConnectionPool(
      file,
      amountOfReaders: 1,
      configureDatabase: (db, {required bool isWriter}) {
        db.execute('CREATE TEMPORARY TABLE conn_info(info text);');
        db.execute('INSERT INTO conn_info(info) VALUES (?)', [
          isWriter ? 'writer' : 'reader',
        ]);
      },
    );
    addTearDown(session.close);

    final writeResult = await session.execute(
      StatementInfo('SELECT * FROM conn_info', needsResultSet: true),
    );
    expect(writeResult.resultSet, [
      ['writer'],
    ]);

    final readResult = await session.execute(
      StatementInfo(
        'SELECT * FROM conn_info',
        needsResultSet: true,
        isReadOnly: true,
      ),
    );
    expect(readResult.resultSet, [
      ['reader'],
    ]);
  });

  test(
    'throwing in setup prevents the database from being opened',
    () async {
      const exception = 'exception';
      expect(
        await sqliteConnectionPool(
          File(d.path('test.db')),
          configureDatabase: (db, {required bool isWriter}) => throw exception,
        ),
        throwsA(exception),
      );
    },
    skip: 'will be fixed in sqlite3_connection_pool 0.2.1',
  );

  test('does not cache explain statements', () async {
    final db = await _openPool();

    await db.execute(
      StatementInfo(
        'create table test(id integer primary key, description text)',
      ),
    );
    await db.execute(StatementInfo('create index i1 on test(description)'));
    // The schema is locked while an explain is active, so caching this
    // statement makes the test fail at the `drop index` statement.
    await db.execute(
      StatementInfo(
        "explain query plan select * from test where description = ?",
        variables: [MappedValue.raw(const SqliteDialect().textType, 't')],
      ),
    );
    await db.execute(StatementInfo('drop index i1'));
    await db.execute(
      StatementInfo(
        "explain query plan select * from test where description = ?",
        variables: [MappedValue.raw(const SqliteDialect().textType, 't')],
      ),
    );
  });
}

Future<DriftSession> _openPool() async {
  final file = File(d.path('test.db'));
  final pool = await sqliteConnectionPool(file);
  addTearDown(pool.close);
  return pool;
}
