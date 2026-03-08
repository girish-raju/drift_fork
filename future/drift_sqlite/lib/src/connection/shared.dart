import 'package:drift3/drift.dart';
import 'package:meta/meta.dart';
import 'package:sqlite3/common.dart' as sqlite;

@internal
QueryResult executeWithStatement(
  sqlite.CommonDatabase database,
  sqlite.CommonPreparedStatement stmt,
  StatementInfo info,
) {
  final variables = info.variables.map((e) => e.rawValue).toList();
  RawResultSet? resultSet;

  if (info.needsResultSet) {
    resultSet = SqliteResultSet(resultSet: stmt.select(variables));
  } else {
    stmt.execute(variables);
  }

  return QueryResult(
    affectedRows: database.updatedRows,
    resultSet: resultSet,
    lastInsertRowId: database.lastInsertRowId,
  );
}

@internal
final class SqliteResultSet extends RawResultSet {
  final sqlite.ResultSet resultSet;

  SqliteResultSet({required this.resultSet})
    : super(columnNames: resultSet.columnNames);

  @override
  RawRow operator [](int index) {
    return resultSet[index].values;
  }

  @override
  int get length => resultSet.length;
}
