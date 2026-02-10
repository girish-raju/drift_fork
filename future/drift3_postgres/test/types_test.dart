import 'package:drift3/drift.dart';
import 'package:drift3_postgres/drift_postgres.dart';
import 'package:drift3_postgres/src/type.dart';
import 'package:postgres/postgres.dart';
import 'package:test/test.dart';

void main() {
  const dialect = PostgresDialect();

  group('boolean', () {
    final type = BuiltinDriftType.bool.resolveIn(dialect);

    test('read', () {
      expect(type.dartValue(fakeValue(Type.boolean, true)), true);
      expect(type.dartValue(fakeValue(Type.boolean, false)), false);
    });

    test('to postgres constant', () {
      expect(type.sqlLiteral(true), 'TRUE::boolean');
      expect(type.sqlLiteral(false), 'FALSE::boolean');
    });

    test('to postgres variable', () {
      expect(type.sqlParameter(true), TypedValue(Type.boolean, true));
      expect(type.sqlParameter(false), TypedValue(Type.boolean, false));
    });
  });
}

PostgresDatabaseValue fakeValue(Type type, Object value) {
  return PostgresDatabaseValue(
    column: ResultSchemaColumn(typeOid: 0, type: type),
    value: value,
  );
}
