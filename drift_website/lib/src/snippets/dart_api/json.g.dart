// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json.dart';

// ignore_for_file: type=lint
class $ContactsTable extends Contacts with TableInfo<$ContactsTable, Contact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactsTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<ContactData, String> data =
      GeneratedColumn<String>(
        'data',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ContactData>($ContactsTable.$converterdata);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    generatedAs: GeneratedAs(
      JsonExtensions(data).jsonExtract(r'$.name'),
      false,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, data, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Contact> instance, {
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contact(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      data: $ContactsTable.$converterdata.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}data'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $ContactsTable createAlias(String alias) {
    return $ContactsTable(attachedDatabase, alias);
  }

  static TypeConverter<ContactData, String> $converterdata =
      _ContactsConverter();
}

class Contact extends DataClass implements Insertable<Contact> {
  final int id;
  final ContactData data;
  final String name;
  const Contact({required this.id, required this.data, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['data'] = Variable<String>($ContactsTable.$converterdata.toSql(data));
    }
    return map;
  }

  ContactsCompanion toCompanion(bool nullToAbsent) {
    return ContactsCompanion(id: Value(id), data: Value(data));
  }

  factory Contact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contact(
      id: serializer.fromJson<int>(json['id']),
      data: serializer.fromJson<ContactData>(json['data']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'data': serializer.toJson<ContactData>(data),
      'name': serializer.toJson<String>(name),
    };
  }

  Contact copyWith({int? id, ContactData? data, String? name}) => Contact(
    id: id ?? this.id,
    data: data ?? this.data,
    name: name ?? this.name,
  );
  @override
  String toString() {
    return (StringBuffer('Contact(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, data, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contact &&
          other.id == this.id &&
          other.data == this.data &&
          other.name == this.name);
}

class ContactsCompanion extends UpdateCompanion<Contact> {
  final Value<int> id;
  final Value<ContactData> data;
  const ContactsCompanion({
    this.id = const Value.absent(),
    this.data = const Value.absent(),
  });
  ContactsCompanion.insert({
    this.id = const Value.absent(),
    required ContactData data,
  }) : data = Value(data);
  static Insertable<Contact> custom({
    Expression<int>? id,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (data != null) 'data': data,
    });
  }

  ContactsCompanion copyWith({Value<int>? id, Value<ContactData>? data}) {
    return ContactsCompanion(id: id ?? this.id, data: data ?? this.data);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(
        $ContactsTable.$converterdata.toSql(data.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactsCompanion(')
          ..write('id: $id, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $CallsTable extends Calls with TableInfo<$CallsTable, Call> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CallsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _incomingMeta = const VerificationMeta(
    'incoming',
  );
  @override
  late final GeneratedColumn<bool> incoming = GeneratedColumn<bool>(
    'incoming',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("incoming" IN (0, 1))',
    ),
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _callTimeMeta = const VerificationMeta(
    'callTime',
  );
  @override
  late final GeneratedColumn<DateTime> callTime = GeneratedColumn<DateTime>(
    'call_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, incoming, phoneNumber, callTime];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calls';
  @override
  VerificationContext validateIntegrity(
    Insertable<Call> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('incoming')) {
      context.handle(
        _incomingMeta,
        incoming.isAcceptableOrUnknown(data['incoming']!, _incomingMeta),
      );
    } else if (isInserting) {
      context.missing(_incomingMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('call_time')) {
      context.handle(
        _callTimeMeta,
        callTime.isAcceptableOrUnknown(data['call_time']!, _callTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_callTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Call map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Call(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      incoming: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}incoming'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      callTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}call_time'],
      )!,
    );
  }

  @override
  $CallsTable createAlias(String alias) {
    return $CallsTable(attachedDatabase, alias);
  }
}

class Call extends DataClass implements Insertable<Call> {
  final int id;
  final bool incoming;
  final String phoneNumber;
  final DateTime callTime;
  const Call({
    required this.id,
    required this.incoming,
    required this.phoneNumber,
    required this.callTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['incoming'] = Variable<bool>(incoming);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['call_time'] = Variable<DateTime>(callTime);
    return map;
  }

  CallsCompanion toCompanion(bool nullToAbsent) {
    return CallsCompanion(
      id: Value(id),
      incoming: Value(incoming),
      phoneNumber: Value(phoneNumber),
      callTime: Value(callTime),
    );
  }

  factory Call.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Call(
      id: serializer.fromJson<int>(json['id']),
      incoming: serializer.fromJson<bool>(json['incoming']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      callTime: serializer.fromJson<DateTime>(json['callTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'incoming': serializer.toJson<bool>(incoming),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'callTime': serializer.toJson<DateTime>(callTime),
    };
  }

  Call copyWith({
    int? id,
    bool? incoming,
    String? phoneNumber,
    DateTime? callTime,
  }) => Call(
    id: id ?? this.id,
    incoming: incoming ?? this.incoming,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    callTime: callTime ?? this.callTime,
  );
  Call copyWithCompanion(CallsCompanion data) {
    return Call(
      id: data.id.present ? data.id.value : this.id,
      incoming: data.incoming.present ? data.incoming.value : this.incoming,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      callTime: data.callTime.present ? data.callTime.value : this.callTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Call(')
          ..write('id: $id, ')
          ..write('incoming: $incoming, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('callTime: $callTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, incoming, phoneNumber, callTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Call &&
          other.id == this.id &&
          other.incoming == this.incoming &&
          other.phoneNumber == this.phoneNumber &&
          other.callTime == this.callTime);
}

class CallsCompanion extends UpdateCompanion<Call> {
  final Value<int> id;
  final Value<bool> incoming;
  final Value<String> phoneNumber;
  final Value<DateTime> callTime;
  const CallsCompanion({
    this.id = const Value.absent(),
    this.incoming = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.callTime = const Value.absent(),
  });
  CallsCompanion.insert({
    this.id = const Value.absent(),
    required bool incoming,
    required String phoneNumber,
    required DateTime callTime,
  }) : incoming = Value(incoming),
       phoneNumber = Value(phoneNumber),
       callTime = Value(callTime);
  static Insertable<Call> custom({
    Expression<int>? id,
    Expression<bool>? incoming,
    Expression<String>? phoneNumber,
    Expression<DateTime>? callTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (incoming != null) 'incoming': incoming,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (callTime != null) 'call_time': callTime,
    });
  }

  CallsCompanion copyWith({
    Value<int>? id,
    Value<bool>? incoming,
    Value<String>? phoneNumber,
    Value<DateTime>? callTime,
  }) {
    return CallsCompanion(
      id: id ?? this.id,
      incoming: incoming ?? this.incoming,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      callTime: callTime ?? this.callTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (incoming.present) {
      map['incoming'] = Variable<bool>(incoming.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (callTime.present) {
      map['call_time'] = Variable<DateTime>(callTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CallsCompanion(')
          ..write('id: $id, ')
          ..write('incoming: $incoming, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('callTime: $callTime')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  $MyDatabaseManager get managers => $MyDatabaseManager(this);
  late final $ContactsTable contacts = $ContactsTable(this);
  late final $CallsTable calls = $CallsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [contacts, calls];
}

typedef $$ContactsTableCreateCompanionBuilder =
    ContactsCompanion Function({Value<int> id, required ContactData data});
typedef $$ContactsTableUpdateCompanionBuilder =
    ContactsCompanion Function({Value<int> id, Value<ContactData> data});

class $$ContactsTableFilterComposer
    extends Composer<_$MyDatabase, $ContactsTable> {
  $$ContactsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<ContactData, ContactData, String> get data =>
      $composableBuilder(
        column: $table.data,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContactsTableOrderingComposer
    extends Composer<_$MyDatabase, $ContactsTable> {
  $$ContactsTableOrderingComposer({
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

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContactsTableAnnotationComposer
    extends Composer<_$MyDatabase, $ContactsTable> {
  $$ContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ContactData, String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$ContactsTableTableManager
    extends
        RootTableManager<
          _$MyDatabase,
          $ContactsTable,
          Contact,
          $$ContactsTableFilterComposer,
          $$ContactsTableOrderingComposer,
          $$ContactsTableAnnotationComposer,
          $$ContactsTableCreateCompanionBuilder,
          $$ContactsTableUpdateCompanionBuilder,
          (Contact, BaseReferences<_$MyDatabase, $ContactsTable, Contact>),
          Contact,
          PrefetchHooks Function()
        > {
  $$ContactsTableTableManager(_$MyDatabase db, $ContactsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<ContactData> data = const Value.absent(),
              }) => ContactsCompanion(id: id, data: data),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required ContactData data,
              }) => ContactsCompanion.insert(id: id, data: data),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$MyDatabase,
      $ContactsTable,
      Contact,
      $$ContactsTableFilterComposer,
      $$ContactsTableOrderingComposer,
      $$ContactsTableAnnotationComposer,
      $$ContactsTableCreateCompanionBuilder,
      $$ContactsTableUpdateCompanionBuilder,
      (Contact, BaseReferences<_$MyDatabase, $ContactsTable, Contact>),
      Contact,
      PrefetchHooks Function()
    >;
typedef $$CallsTableCreateCompanionBuilder =
    CallsCompanion Function({
      Value<int> id,
      required bool incoming,
      required String phoneNumber,
      required DateTime callTime,
    });
typedef $$CallsTableUpdateCompanionBuilder =
    CallsCompanion Function({
      Value<int> id,
      Value<bool> incoming,
      Value<String> phoneNumber,
      Value<DateTime> callTime,
    });

class $$CallsTableFilterComposer extends Composer<_$MyDatabase, $CallsTable> {
  $$CallsTableFilterComposer({
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

  ColumnFilters<bool> get incoming => $composableBuilder(
    column: $table.incoming,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get callTime => $composableBuilder(
    column: $table.callTime,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CallsTableOrderingComposer extends Composer<_$MyDatabase, $CallsTable> {
  $$CallsTableOrderingComposer({
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

  ColumnOrderings<bool> get incoming => $composableBuilder(
    column: $table.incoming,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get callTime => $composableBuilder(
    column: $table.callTime,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CallsTableAnnotationComposer
    extends Composer<_$MyDatabase, $CallsTable> {
  $$CallsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get incoming =>
      $composableBuilder(column: $table.incoming, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get callTime =>
      $composableBuilder(column: $table.callTime, builder: (column) => column);
}

class $$CallsTableTableManager
    extends
        RootTableManager<
          _$MyDatabase,
          $CallsTable,
          Call,
          $$CallsTableFilterComposer,
          $$CallsTableOrderingComposer,
          $$CallsTableAnnotationComposer,
          $$CallsTableCreateCompanionBuilder,
          $$CallsTableUpdateCompanionBuilder,
          (Call, BaseReferences<_$MyDatabase, $CallsTable, Call>),
          Call,
          PrefetchHooks Function()
        > {
  $$CallsTableTableManager(_$MyDatabase db, $CallsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CallsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CallsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CallsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> incoming = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<DateTime> callTime = const Value.absent(),
              }) => CallsCompanion(
                id: id,
                incoming: incoming,
                phoneNumber: phoneNumber,
                callTime: callTime,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required bool incoming,
                required String phoneNumber,
                required DateTime callTime,
              }) => CallsCompanion.insert(
                id: id,
                incoming: incoming,
                phoneNumber: phoneNumber,
                callTime: callTime,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CallsTableProcessedTableManager =
    ProcessedTableManager<
      _$MyDatabase,
      $CallsTable,
      Call,
      $$CallsTableFilterComposer,
      $$CallsTableOrderingComposer,
      $$CallsTableAnnotationComposer,
      $$CallsTableCreateCompanionBuilder,
      $$CallsTableUpdateCompanionBuilder,
      (Call, BaseReferences<_$MyDatabase, $CallsTable, Call>),
      Call,
      PrefetchHooks Function()
    >;

class $MyDatabaseManager {
  final _$MyDatabase _db;
  $MyDatabaseManager(this._db);
  $$ContactsTableTableManager get contacts =>
      $$ContactsTableTableManager(_db, _db.contacts);
  $$CallsTableTableManager get calls =>
      $$CallsTableTableManager(_db, _db.calls);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactData _$ContactDataFromJson(Map<String, dynamic> json) => ContactData(
  json['name'] as String,
  (json['phoneNumbers'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$ContactDataToJson(ContactData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phoneNumbers': instance.phoneNumbers,
    };
