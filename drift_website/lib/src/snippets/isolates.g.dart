// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isolates.dart';

// ignore_for_file: type=lint
class $SomeTableTable extends SomeTable
    with TableInfo<$SomeTableTable, SomeTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SomeTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'some_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SomeTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SomeTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SomeTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
    );
  }

  @override
  $SomeTableTable createAlias(String alias) {
    return $SomeTableTable(attachedDatabase, alias);
  }
}

class SomeTableData extends DataClass implements Insertable<SomeTableData> {
  final int id;
  final String content;
  const SomeTableData({required this.id, required this.content});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    return map;
  }

  SomeTableCompanion toCompanion(bool nullToAbsent) {
    return SomeTableCompanion(id: Value(id), content: Value(content));
  }

  factory SomeTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SomeTableData(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
    };
  }

  SomeTableData copyWith({int? id, String? content}) =>
      SomeTableData(id: id ?? this.id, content: content ?? this.content);
  SomeTableData copyWithCompanion(SomeTableCompanion data) {
    return SomeTableData(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SomeTableData(')
          ..write('id: $id, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SomeTableData &&
          other.id == this.id &&
          other.content == this.content);
}

class SomeTableCompanion extends UpdateCompanion<SomeTableData> {
  final Value<int> id;
  final Value<String> content;
  const SomeTableCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
  });
  SomeTableCompanion.insert({
    this.id = const Value.absent(),
    required String content,
  }) : content = Value(content);
  static Insertable<SomeTableData> custom({
    Expression<int>? id,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
    });
  }

  SomeTableCompanion copyWith({Value<int>? id, Value<String>? content}) {
    return SomeTableCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SomeTableCompanion(')
          ..write('id: $id, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  $MyDatabaseManager get managers => $MyDatabaseManager(this);
  late final $SomeTableTable someTable = $SomeTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [someTable];
}

typedef $$SomeTableTableCreateCompanionBuilder =
    SomeTableCompanion Function({Value<int> id, required String content});
typedef $$SomeTableTableUpdateCompanionBuilder =
    SomeTableCompanion Function({Value<int> id, Value<String> content});

class $$SomeTableTableFilterComposer
    extends Composer<_$MyDatabase, $SomeTableTable> {
  $$SomeTableTableFilterComposer({
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

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SomeTableTableOrderingComposer
    extends Composer<_$MyDatabase, $SomeTableTable> {
  $$SomeTableTableOrderingComposer({
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

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SomeTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $SomeTableTable> {
  $$SomeTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);
}

class $$SomeTableTableTableManager
    extends
        RootTableManager<
          _$MyDatabase,
          $SomeTableTable,
          SomeTableData,
          $$SomeTableTableFilterComposer,
          $$SomeTableTableOrderingComposer,
          $$SomeTableTableAnnotationComposer,
          $$SomeTableTableCreateCompanionBuilder,
          $$SomeTableTableUpdateCompanionBuilder,
          (
            SomeTableData,
            BaseReferences<_$MyDatabase, $SomeTableTable, SomeTableData>,
          ),
          SomeTableData,
          PrefetchHooks Function()
        > {
  $$SomeTableTableTableManager(_$MyDatabase db, $SomeTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SomeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SomeTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SomeTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
              }) => SomeTableCompanion(id: id, content: content),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
              }) => SomeTableCompanion.insert(id: id, content: content),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SomeTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyDatabase,
      $SomeTableTable,
      SomeTableData,
      $$SomeTableTableFilterComposer,
      $$SomeTableTableOrderingComposer,
      $$SomeTableTableAnnotationComposer,
      $$SomeTableTableCreateCompanionBuilder,
      $$SomeTableTableUpdateCompanionBuilder,
      (
        SomeTableData,
        BaseReferences<_$MyDatabase, $SomeTableTable, SomeTableData>,
      ),
      SomeTableData,
      PrefetchHooks Function()
    >;

class $MyDatabaseManager {
  final _$MyDatabase _db;
  $MyDatabaseManager(this._db);
  $$SomeTableTableTableManager get someTable =>
      $$SomeTableTableTableManager(_db, _db.someTable);
}
