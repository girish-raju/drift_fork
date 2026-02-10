import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart';
import 'package:drift3/drift.dart';

import 'array_access_expression.dart';
import 'type.dart';

/// A [DriftDialect] using postgres-compatible type mappings and SQL.
final class PostgresDialect extends DriftDialect {
  /// Whether to use `JSONB` by default for drift JSON columns.
  final bool useJsonb;

  /// @nodoc
  const PostgresDialect({this.useJsonb = true});

  @override
  PhysicalSqlType<bool> get boolType =>
      const PhysicalPostgresType(Type.boolean, 'boolean');

  @override
  PhysicalSqlType<Uint8List> get byteArrayType =>
      const PhysicalPostgresType(Type.byteArray, 'bytea');

  @override
  PhysicalSqlType<DateTime> get dateTimeType =>
      PhysicalPostgresType(Type.timestampTz, 'timestamptz');

  @override
  PhysicalSqlType<double> get doubleType =>
      const PhysicalPostgresType(Type.double, 'double');

  @override
  PhysicalSqlType<BigInt> get int64Type => const DartBigIntType();

  @override
  PhysicalSqlType<int> get intType =>
      const PhysicalPostgresType(Type.bigInteger, 'bigint');

  @override
  PhysicalSqlType<DatabaseJson> get jsonType => useJsonb
      ? const PhysicalPostgresType(Type.jsonb, 'jsonb')
      : const PhysicalPostgresType(Type.json, 'json');

  @override
  KnownSqlDialect get known => KnownSqlDialect.postgres;

  @override
  PhysicalSqlType<String> get textType =>
      const PhysicalPostgresType(Type.text, 'text');

  @override
  StatementCompiler createCompiler() => PostgresSqlCompiler._(this);
}

@internal
final class PostgresSqlCompiler extends StatementCompiler {
  final PostgresDialect _dialect;

  PostgresSqlCompiler._(this._dialect);

  @override
  void addDateExtractionOperator(DateExtractionOperator<Object> e) {
    throw UnsupportedError('date extraction operators in postgres');
  }

  @override
  void addPositionalVariable(int index) {
    statement.buffer.write('\$$index');
  }

  @override
  void addUnixTimestampToDateTime(UnixTimestampToDateTime e) {
    throw UnsupportedError('mapping unix timestamps to date time');
  }

  @override
  PostgresDialect get dialect => _dialect;

  void addArrayAccessExpression(ArrayAccessExpression expr) {
    writeExpression(expr, () {
      expr.array.compileWith(this);
      statement.buffer.write('[');
      expr.index.compileWith(this);
      statement.buffer.write(']');
    });
  }
}
