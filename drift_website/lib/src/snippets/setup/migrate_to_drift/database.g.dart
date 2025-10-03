// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
abstract class _$HackToIncludePartialAnnotationInDocs
    extends GeneratedDatabase {
  _$HackToIncludePartialAnnotationInDocs(QueryExecutor e) : super(e);
  $HackToIncludePartialAnnotationInDocsManager get managers =>
      $HackToIncludePartialAnnotationInDocsManager(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [];
}

class $HackToIncludePartialAnnotationInDocsManager {
  final _$HackToIncludePartialAnnotationInDocs _db;
  $HackToIncludePartialAnnotationInDocsManager(this._db);
}

class Test extends Table with TableInfo<Test, TestData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Test(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _numMeta = const VerificationMeta('num');
  late final GeneratedColumn<double> num = GeneratedColumn<double>(
    'num',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, value, num];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'Test';
  @override
  VerificationContext validateIntegrity(
    Insertable<TestData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('num')) {
      context.handle(
        _numMeta,
        num.isAcceptableOrUnknown(data['num']!, _numMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TestData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TestData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      ),
      num: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}num'],
      ),
    );
  }

  @override
  Test createAlias(String alias) {
    return Test(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class TestData extends DataClass implements Insertable<TestData> {
  final int id;
  final String? name;
  final int? value;
  final double? num;
  const TestData({required this.id, this.name, this.value, this.num});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<int>(value);
    }
    if (!nullToAbsent || num != null) {
      map['num'] = Variable<double>(num);
    }
    return map;
  }

  TestCompanion toCompanion(bool nullToAbsent) {
    return TestCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
      num: num == null && nullToAbsent ? const Value.absent() : Value(num),
    );
  }

  factory TestData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TestData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      value: serializer.fromJson<int?>(json['value']),
      num: serializer.fromJson<double?>(json['num']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'value': serializer.toJson<int?>(value),
      'num': serializer.toJson<double?>(num),
    };
  }

  TestData copyWith({
    int? id,
    Value<String?> name = const Value.absent(),
    Value<int?> value = const Value.absent(),
    Value<double?> num = const Value.absent(),
  }) => TestData(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    value: value.present ? value.value : this.value,
    num: num.present ? num.value : this.num,
  );
  TestData copyWithCompanion(TestCompanion data) {
    return TestData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      value: data.value.present ? data.value.value : this.value,
      num: data.num.present ? data.num.value : this.num,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TestData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('num: $num')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, value, num);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TestData &&
          other.id == this.id &&
          other.name == this.name &&
          other.value == this.value &&
          other.num == this.num);
}

class TestCompanion extends UpdateCompanion<TestData> {
  final Value<int> id;
  final Value<String?> name;
  final Value<int?> value;
  final Value<double?> num;
  const TestCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    this.num = const Value.absent(),
  });
  TestCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    this.num = const Value.absent(),
  });
  static Insertable<TestData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? value,
    Expression<double>? num,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (value != null) 'value': value,
      if (num != null) 'num': num,
    });
  }

  TestCompanion copyWith({
    Value<int>? id,
    Value<String?>? name,
    Value<int?>? value,
    Value<double?>? num,
  }) {
    return TestCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      num: num ?? this.num,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (num.present) {
      map['num'] = Variable<double>(num.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('num: $num')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final Test test = Test(this);
  Selectable<TestData> findWithValue(int? var1) {
    return customSelect(
      'SELECT * FROM Test WHERE value > ?1',
      variables: [Variable<int>(var1)],
      readsFrom: {test},
    ).asyncMap(test.mapFromRow);
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [test];
}

typedef $TestCreateCompanionBuilder =
    TestCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<int?> value,
      Value<double?> num,
    });
typedef $TestUpdateCompanionBuilder =
    TestCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<int?> value,
      Value<double?> num,
    });

class $TestFilterComposer extends Composer<_$AppDatabase, Test> {
  $TestFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get num => $composableBuilder(
    column: $table.num,
    builder: (column) => ColumnFilters(column),
  );
}

class $TestOrderingComposer extends Composer<_$AppDatabase, Test> {
  $TestOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get num => $composableBuilder(
    column: $table.num,
    builder: (column) => ColumnOrderings(column),
  );
}

class $TestAnnotationComposer extends Composer<_$AppDatabase, Test> {
  $TestAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<double> get num =>
      $composableBuilder(column: $table.num, builder: (column) => column);
}

class $TestTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Test,
          TestData,
          $TestFilterComposer,
          $TestOrderingComposer,
          $TestAnnotationComposer,
          $TestCreateCompanionBuilder,
          $TestUpdateCompanionBuilder,
          (TestData, BaseReferences<_$AppDatabase, Test, TestData>),
          TestData,
          PrefetchHooks Function()
        > {
  $TestTableManager(_$AppDatabase db, Test table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $TestFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $TestOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $TestAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int?> value = const Value.absent(),
                Value<double?> num = const Value.absent(),
              }) => TestCompanion(id: id, name: name, value: value, num: num),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int?> value = const Value.absent(),
                Value<double?> num = const Value.absent(),
              }) => TestCompanion.insert(
                id: id,
                name: name,
                value: value,
                num: num,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $TestProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Test,
      TestData,
      $TestFilterComposer,
      $TestOrderingComposer,
      $TestAnnotationComposer,
      $TestCreateCompanionBuilder,
      $TestUpdateCompanionBuilder,
      (TestData, BaseReferences<_$AppDatabase, Test, TestData>),
      TestData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $TestTableManager get test => $TestTableManager(_db, _db.test);
}
