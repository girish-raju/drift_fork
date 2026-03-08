import 'dart:io';

import 'package:drift3/drift.dart';
import 'package:drift_sqlite/native.dart';
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
}

Future<DriftSession> _openPool() async {
  final file = File(d.path('test.db'));
  final pool = await sqliteConnectionPool(file);
  addTearDown(pool.close);
  return pool;
}
