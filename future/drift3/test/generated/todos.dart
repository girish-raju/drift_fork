import 'dart:typed_data';

import 'package:drift3/drift.dart';
import 'package:drift_sqlite/drift_sqlite.dart';
import 'package:uuid/uuid.dart';

part 'todos.g.dart';

extension type RowId._(int id) {
  const RowId(this.id);
}

mixin AutoIncrement on Table {
  IntColumn get id =>
      integer().autoIncrement().map(TypeConverter.extensionType<RowId, int>());
}

@DataClassName('TodoEntry')
class TodosTable extends Table with AutoIncrement {
  @override
  String get tableName => 'todos';

  TextColumn get title => text().withLength(min: 4, max: 16).nullable();
  TextColumn get content => text();
  DateTimeColumn get targetDate => dateTime().nullable().unique();
  @ReferenceName("todos")
  IntColumn get category => integer()
      .references(Categories, #id, initiallyDeferred: true)
      .map(TypeConverter.extensionType<RowId, int>())
      .nullable();

  TextColumn get status => textEnum<TodoStatus>().nullable();

  @override
  List<Set<Column>>? get uniqueKeys => [
    {title, category},
    {title, targetDate},
  ];
}

enum TodoStatus { open, workInProgress, done }

class Users extends Table with AutoIncrement {
  TextColumn get name => text().withLength(min: 6, max: 32).unique();
  BoolColumn get isAwesome => boolean().withDefault(const Literal(true));

  BlobColumn get profilePicture => blob();
  DateTimeColumn get creationTime => dateTime()
      // ignore: recursive_getters
      .check(creationTime.isGreaterThan(Literal(DateTime.utc(1950))))
      .withDefault(currentDateAndTime);
}

@DataClassName('Category')
@TableIndex(
  name: 'categories_desc',
  columns: {
    IndexedColumn(#description, orderBy: OrderingMode.desc),
    #priority,
  },
)
class Categories extends Table with AutoIncrement {
  TextColumn get description =>
      text().named('desc').customConstraint('NOT NULL UNIQUE');
  IntColumn get priority =>
      intEnum<CategoryPriority>().withDefault(const Literal(0));

  TextColumn get descriptionInUpperCase =>
      text().generatedAs(description.upper());
}

enum CategoryPriority { low, medium, high }

class SharedTodos extends Table {
  IntColumn get todo => integer();
  IntColumn get user => integer();

  @override
  Set<Column> get primaryKey => {todo, user};

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (todo) REFERENCES todos(id)',
    'FOREIGN KEY (user) REFERENCES users(id)',
  ];
}

class CustomRowClass {
  final int notReallyAnId;
  final double anotherName;
  final BigInt? webSafeInt;
  final MyCustomObject custom;

  final String? notFromDb;

  double get someFloat => anotherName;

  CustomRowClass._(
    this.notReallyAnId,
    this.anotherName,
    this.webSafeInt,
    this.custom,
    this.notFromDb,
  );

  factory CustomRowClass.map(
    int notReallyAnId,
    double someFloat, {
    required MyCustomObject custom,
    BigInt? webSafeInt,
    String? notFromDb,
  }) {
    return CustomRowClass._(
      notReallyAnId,
      someFloat,
      webSafeInt,
      custom,
      notFromDb,
    );
  }
}

// example object used for custom mapping
class MyCustomObject {
  final String data;

  MyCustomObject(this.data);

  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(Object other) {
    return other is MyCustomObject && other.data == data;
  }
}

const _uuid = Uuid();

@UseRowClass(CustomRowClass, constructor: 'map', generateInsertable: true)
class TableWithoutPK extends Table {
  IntColumn get notReallyAnId => integer();
  RealColumn get someFloat => real();
  Int64Column get webSafeInt => int64().nullable();

  TextColumn get custom =>
      text().map(const CustomConverter()).clientDefault(_uuid.v4);
}

class CustomConverter extends TypeConverter<MyCustomObject, String> {
  const CustomConverter();

  @override
  MyCustomObject fromSql(String fromDb) {
    return MyCustomObject(fromDb);
  }

  @override
  String toSql(MyCustomObject value) {
    return value.data;
  }
}

class CustomJsonConverter extends CustomConverter
    with JsonTypeConverter2<MyCustomObject, String, Map<String, Object?>> {
  const CustomJsonConverter();

  @override
  MyCustomObject fromJson(Map<String, Object?> json) {
    return MyCustomObject(json['data'] as String);
  }

  @override
  Map<String, Object?> toJson(MyCustomObject value) {
    return {'data': value.data};
  }
}

@DriftDatabase(
  tables: [Categories, SharedTodos, Users, TodosTable, TableWithoutPK],
  views: [],
  daos: [],
  queries: {},
)
final class TodoDb extends _$TodoDb {
  TodoDb([DriftConnection? e]) : super(e ?? _nullConnection) {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  @override
  int get schemaVersion => 1;
}

DriftConnection get _nullConnection => DriftConnection(
  dialect: SqliteDialect(),
  openConnection: () => throw UnsupportedError('stub'),
);
