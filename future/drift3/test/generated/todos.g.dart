// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with ResultSet<Category, $CategoriesTable>
    implements GeneratedTable<Category, $CategoriesTable> {
  @override
  final String? alias;
  $CategoriesTable([this.alias]);
  @override
  late final TableColumnWithTypeConverter<RowId, int> id = TableColumn<int>(
    name: 'id',
    sqlType: BuiltinDriftType.int,
    requiredDuringInsert: false,
    constraints: () => [
      const ColumnPrimaryKeyConstraint(isAutoIncrementing: true),
      const ColumnNotNullConstraint(),
    ],
  ).withConverter<RowId>($CategoriesTable.$converterid)..owningResultSet = this;
  @override
  late final TableColumn<String> description = TableColumn<String>(
    name: 'desc',
    sqlType: BuiltinDriftType.text,
    requiredDuringInsert: true,
    constraints: () => [ColumnConstraint.customSql('NOT NULL UNIQUE')],
  )..owningResultSet = this;
  @override
  late final TableColumnWithTypeConverter<CategoryPriority, int> priority =
      TableColumn<int>(
          name: 'priority',
          sqlType: BuiltinDriftType.int,
          requiredDuringInsert: false,
          constraints: () => [
            const ColumnNotNullConstraint(),
            ColumnDefaultConstraint<int>(const Literal(0)),
          ],
        ).withConverter<CategoryPriority>($CategoriesTable.$converterpriority)
        ..owningResultSet = this;
  @override
  late final TableColumn<String> descriptionInUpperCase = TableColumn<String>(
    name: 'description_in_upper_case',
    sqlType: BuiltinDriftType.text,
    requiredDuringInsert: false,
    constraints: () => [
      const ColumnNotNullConstraint(),
      ColumnGeneratedAs(
        StringExpressionOperators(description).upper(),
        stored: false,
      ),
    ],
  )..owningResultSet = this;
  @override
  List<TableColumn> get columns => [
    id,
    description,
    priority,
    descriptionInUpperCase,
  ];
  @override
  String get entityName => $name;
  static const String $name = 'categories';
  @override
  $CategoriesTable asSelfType() => this;

  @override
  Set<TableColumn> get primaryKey => {id};
  @override
  Category? Function(RawRow) createMapperFromPositions(
    DriftDialect dialect,
    List<ColumnPosition> positions,
  ) {
    final pos$id = positions[0].index;
    final type$0 = BuiltinDriftType.int.resolveIn(dialect);
    final pos$description = positions[1].index;
    final type$1 = BuiltinDriftType.text.resolveIn(dialect);
    final pos$priority = positions[2].index;
    final pos$descriptionInUpperCase = positions[3].index;
    return (RawRow row) {
      // Not part of row if non-nullable column "id" is missing
      if (row[pos$id] == null) {
        return null;
      }
      return Category(
        id: $CategoriesTable.$converterid.fromSql(
          type$0.dartValue(row[pos$id]!),
        ),
        description: type$1.dartValue(row[pos$description]!),
        priority: $CategoriesTable.$converterpriority.fromSql(
          type$0.dartValue(row[pos$priority]!),
        ),
        descriptionInUpperCase: type$1.dartValue(
          row[pos$descriptionInUpperCase]!,
        ),
      );
    };
  }

  @override
  $CategoriesTable withAlias(String alias) {
    return $CategoriesTable(alias);
  }

  static JsonTypeConverter2<RowId, int, int> $converterid =
      TypeConverter.extensionType<RowId, int>();
  static JsonTypeConverter2<CategoryPriority, int, int> $converterpriority =
      const EnumIndexConverter<CategoryPriority>(CategoryPriority.values);
}

class Category extends LegacyDataClass implements Insertable<Category> {
  final RowId id;
  final String description;
  final CategoryPriority priority;
  final String descriptionInUpperCase;
  const Category({
    required this.id,
    required this.description,
    required this.priority,
    required this.descriptionInUpperCase,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      map['id'] = Variable<int>(
        $CategoriesTable.$converterid.toSql(id),
        BuiltinDriftType.int,
      );
    }
    map['desc'] = Variable<String>(description, BuiltinDriftType.text);
    {
      map['priority'] = Variable<int>(
        $CategoriesTable.$converterpriority.toSql(priority),
        BuiltinDriftType.int,
      );
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      description: Value(description),
      priority: Value(priority),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: $CategoriesTable.$converterid.fromJson(
        serializer.fromJson<int>(json['id']),
      ),
      description: serializer.fromJson<String>(json['description']),
      priority: $CategoriesTable.$converterpriority.fromJson(
        serializer.fromJson<int>(json['priority']),
      ),
      descriptionInUpperCase: serializer.fromJson<String>(
        json['descriptionInUpperCase'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>($CategoriesTable.$converterid.toJson(id)),
      'description': serializer.toJson<String>(description),
      'priority': serializer.toJson<int>(
        $CategoriesTable.$converterpriority.toJson(priority),
      ),
      'descriptionInUpperCase': serializer.toJson<String>(
        descriptionInUpperCase,
      ),
    };
  }

  Category copyWith({
    RowId? id,
    String? description,
    CategoryPriority? priority,
    String? descriptionInUpperCase,
  }) => Category(
    id: id ?? this.id,
    description: description ?? this.description,
    priority: priority ?? this.priority,
    descriptionInUpperCase:
        descriptionInUpperCase ?? this.descriptionInUpperCase,
  );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('priority: $priority, ')
          ..write('descriptionInUpperCase: $descriptionInUpperCase')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, description, priority, descriptionInUpperCase);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.description == this.description &&
          other.priority == this.priority &&
          other.descriptionInUpperCase == this.descriptionInUpperCase);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<RowId> id;
  final Value<String> description;
  final Value<CategoryPriority> priority;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.priority = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String description,
    this.priority = const Value.absent(),
  }) : description = Value(description);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? description,
    Expression<int>? priority,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'desc': description,
      if (priority != null) 'priority': priority,
    });
  }

  CategoriesCompanion copyWith({
    Value<RowId>? id,
    Value<String>? description,
    Value<CategoryPriority>? priority,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
      priority: priority ?? this.priority,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(
        $CategoriesTable.$converterid.toSql(id.value),
        BuiltinDriftType.int,
      );
    }
    if (description.present) {
      map['desc'] = Variable<String>(description.value, BuiltinDriftType.text);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(
        $CategoriesTable.$converterpriority.toSql(priority.value),
        BuiltinDriftType.int,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('priority: $priority')
          ..write(')'))
        .toString();
  }
}

class $TodosTableTable extends TodosTable
    with ResultSet<TodoEntry, $TodosTableTable>
    implements GeneratedTable<TodoEntry, $TodosTableTable> {
  @override
  final String? alias;
  $TodosTableTable([this.alias]);
  @override
  late final TableColumnWithTypeConverter<RowId, int> id = TableColumn<int>(
    name: 'id',
    sqlType: BuiltinDriftType.int,
    requiredDuringInsert: false,
    constraints: () => [
      const ColumnPrimaryKeyConstraint(isAutoIncrementing: true),
      const ColumnNotNullConstraint(),
    ],
  ).withConverter<RowId>($TodosTableTable.$converterid)..owningResultSet = this;
  @override
  late final TableColumn<String> title = TableColumn<String>(
    name: 'title',
    sqlType: BuiltinDriftType.text,
    requiredDuringInsert: false,
  )..owningResultSet = this;
  @override
  late final TableColumn<String> content = TableColumn<String>(
    name: 'content',
    sqlType: BuiltinDriftType.text,
    requiredDuringInsert: true,
    constraints: () => [const ColumnNotNullConstraint()],
  )..owningResultSet = this;
  @override
  late final TableColumn<DateTime> targetDate = TableColumn<DateTime>(
    name: 'target_date',
    sqlType: BuiltinDriftType.dateTime,
    requiredDuringInsert: false,
    constraints: () => [const ColumnUniqueConstraint()],
  )..owningResultSet = this;
  @override
  late final TableColumnWithTypeConverter<RowId?, int> category =
      TableColumn<int>(
          name: 'category',
          sqlType: BuiltinDriftType.int,
          requiredDuringInsert: false,
          constraints: () => [
            const ColumnForeignKeyConstraint(
              otherTableName: 'categories',
              otherColumnName: 'id',
              initiallyDeferred: true,
            ),
          ],
        ).withConverter<RowId?>($TodosTableTable.$convertercategoryn)
        ..owningResultSet = this;
  @override
  late final TableColumnWithTypeConverter<TodoStatus?, String> status =
      TableColumn<String>(
          name: 'status',
          sqlType: BuiltinDriftType.text,
          requiredDuringInsert: false,
        ).withConverter<TodoStatus?>($TodosTableTable.$converterstatusn)
        ..owningResultSet = this;
  @override
  List<TableColumn> get columns => [
    id,
    title,
    content,
    targetDate,
    category,
    status,
  ];
  @override
  String get entityName => $name;
  static const String $name = 'todos';
  @override
  $TodosTableTable asSelfType() => this;

  @override
  Set<TableColumn> get primaryKey => {id};
  @override
  List<Set<TableColumn>> get uniqueKeys => [
    {title, category},
    {title, targetDate},
  ];
  @override
  TodoEntry? Function(RawRow) createMapperFromPositions(
    DriftDialect dialect,
    List<ColumnPosition> positions,
  ) {
    final pos$id = positions[0].index;
    final type$0 = BuiltinDriftType.int.resolveIn(dialect);
    final pos$title = positions[1].index;
    final type$1 = BuiltinDriftType.text.resolveIn(dialect);
    final pos$content = positions[2].index;
    final pos$targetDate = positions[3].index;
    final type$2 = BuiltinDriftType.dateTime.resolveIn(dialect);
    final pos$category = positions[4].index;
    final pos$status = positions[5].index;
    return (RawRow row) {
      // Not part of row if non-nullable column "id" is missing
      if (row[pos$id] == null) {
        return null;
      }
      return TodoEntry(
        id: $TodosTableTable.$converterid.fromSql(
          type$0.dartValue(row[pos$id]!),
        ),
        title: type$1.nullableDartValue(row[pos$title]),
        content: type$1.dartValue(row[pos$content]!),
        targetDate: type$2.nullableDartValue(row[pos$targetDate]),
        category: $TodosTableTable.$convertercategoryn.fromSql(
          type$0.nullableDartValue(row[pos$category]),
        ),
        status: $TodosTableTable.$converterstatusn.fromSql(
          type$1.nullableDartValue(row[pos$status]),
        ),
      );
    };
  }

  @override
  $TodosTableTable withAlias(String alias) {
    return $TodosTableTable(alias);
  }

  static JsonTypeConverter2<RowId, int, int> $converterid =
      TypeConverter.extensionType<RowId, int>();
  static JsonTypeConverter2<RowId, int, int> $convertercategory =
      TypeConverter.extensionType<RowId, int>();
  static JsonTypeConverter2<RowId?, int?, int?> $convertercategoryn =
      JsonTypeConverter2.asNullable($convertercategory);
  static JsonTypeConverter2<TodoStatus, String, String> $converterstatus =
      const EnumNameConverter<TodoStatus>(TodoStatus.values);
  static JsonTypeConverter2<TodoStatus?, String?, String?> $converterstatusn =
      JsonTypeConverter2.asNullable($converterstatus);
}

class TodoEntry extends LegacyDataClass implements Insertable<TodoEntry> {
  final RowId id;
  final String? title;
  final String content;
  final DateTime? targetDate;
  final RowId? category;
  final TodoStatus? status;
  const TodoEntry({
    required this.id,
    this.title,
    required this.content,
    this.targetDate,
    this.category,
    this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      map['id'] = Variable<int>(
        $TodosTableTable.$converterid.toSql(id),
        BuiltinDriftType.int,
      );
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title, BuiltinDriftType.text);
    }
    map['content'] = Variable<String>(content, BuiltinDriftType.text);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(
        targetDate,
        BuiltinDriftType.dateTime,
      );
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<int>(
        $TodosTableTable.$convertercategoryn.toSql(category),
        BuiltinDriftType.int,
      );
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(
        $TodosTableTable.$converterstatusn.toSql(status),
        BuiltinDriftType.text,
      );
    }
    return map;
  }

  TodosTableCompanion toCompanion(bool nullToAbsent) {
    return TodosTableCompanion(
      id: Value(id),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      content: Value(content),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
    );
  }

  factory TodoEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoEntry(
      id: $TodosTableTable.$converterid.fromJson(
        serializer.fromJson<int>(json['id']),
      ),
      title: serializer.fromJson<String?>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      category: $TodosTableTable.$convertercategoryn.fromJson(
        serializer.fromJson<int?>(json['category']),
      ),
      status: $TodosTableTable.$converterstatusn.fromJson(
        serializer.fromJson<String?>(json['status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>($TodosTableTable.$converterid.toJson(id)),
      'title': serializer.toJson<String?>(title),
      'content': serializer.toJson<String>(content),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'category': serializer.toJson<int?>(
        $TodosTableTable.$convertercategoryn.toJson(category),
      ),
      'status': serializer.toJson<String?>(
        $TodosTableTable.$converterstatusn.toJson(status),
      ),
    };
  }

  TodoEntry copyWith({
    RowId? id,
    Value<String?> title = const Value.absent(),
    String? content,
    Value<DateTime?> targetDate = const Value.absent(),
    Value<RowId?> category = const Value.absent(),
    Value<TodoStatus?> status = const Value.absent(),
  }) => TodoEntry(
    id: id ?? this.id,
    title: title.present ? title.value : this.title,
    content: content ?? this.content,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    category: category.present ? category.value : this.category,
    status: status.present ? status.value : this.status,
  );
  TodoEntry copyWithCompanion(TodosTableCompanion data) {
    return TodoEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      category: data.category.present ? data.category.value : this.category,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('targetDate: $targetDate, ')
          ..write('category: $category, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, content, targetDate, category, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.targetDate == this.targetDate &&
          other.category == this.category &&
          other.status == this.status);
}

class TodosTableCompanion extends UpdateCompanion<TodoEntry> {
  final Value<RowId> id;
  final Value<String?> title;
  final Value<String> content;
  final Value<DateTime?> targetDate;
  final Value<RowId?> category;
  final Value<TodoStatus?> status;
  const TodosTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.category = const Value.absent(),
    this.status = const Value.absent(),
  });
  TodosTableCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    required String content,
    this.targetDate = const Value.absent(),
    this.category = const Value.absent(),
    this.status = const Value.absent(),
  }) : content = Value(content);
  static Insertable<TodoEntry> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? targetDate,
    Expression<int>? category,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (targetDate != null) 'target_date': targetDate,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
    });
  }

  TodosTableCompanion copyWith({
    Value<RowId>? id,
    Value<String?>? title,
    Value<String>? content,
    Value<DateTime?>? targetDate,
    Value<RowId?>? category,
    Value<TodoStatus?>? status,
  }) {
    return TodosTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      targetDate: targetDate ?? this.targetDate,
      category: category ?? this.category,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(
        $TodosTableTable.$converterid.toSql(id.value),
        BuiltinDriftType.int,
      );
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value, BuiltinDriftType.text);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value, BuiltinDriftType.text);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(
        targetDate.value,
        BuiltinDriftType.dateTime,
      );
    }
    if (category.present) {
      map['category'] = Variable<int>(
        $TodosTableTable.$convertercategoryn.toSql(category.value),
        BuiltinDriftType.int,
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $TodosTableTable.$converterstatusn.toSql(status.value),
        BuiltinDriftType.text,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('targetDate: $targetDate, ')
          ..write('category: $category, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users
    with ResultSet<User, $UsersTable>
    implements GeneratedTable<User, $UsersTable> {
  @override
  final String? alias;
  $UsersTable([this.alias]);
  @override
  late final TableColumnWithTypeConverter<RowId, int> id = TableColumn<int>(
    name: 'id',
    sqlType: BuiltinDriftType.int,
    requiredDuringInsert: false,
    constraints: () => [
      const ColumnPrimaryKeyConstraint(isAutoIncrementing: true),
      const ColumnNotNullConstraint(),
    ],
  ).withConverter<RowId>($UsersTable.$converterid)..owningResultSet = this;
  @override
  late final TableColumn<String> name = TableColumn<String>(
    name: 'name',
    sqlType: BuiltinDriftType.text,
    requiredDuringInsert: true,
    constraints: () => [
      const ColumnNotNullConstraint(),
      const ColumnUniqueConstraint(),
    ],
  )..owningResultSet = this;
  @override
  late final TableColumn<bool> isAwesome = TableColumn<bool>(
    name: 'is_awesome',
    sqlType: BuiltinDriftType.bool,
    requiredDuringInsert: false,
    constraints: () => [
      const ColumnNotNullConstraint(),
      ColumnDefaultConstraint<bool>(const Literal(true)),
    ],
  )..owningResultSet = this;
  @override
  late final TableColumn<Uint8List> profilePicture = TableColumn<Uint8List>(
    name: 'profile_picture',
    sqlType: BuiltinDriftType.byteArray,
    requiredDuringInsert: true,
    constraints: () => [const ColumnNotNullConstraint()],
  )..owningResultSet = this;
  @override
  late final TableColumn<DateTime> creationTime = TableColumn<DateTime>(
    name: 'creation_time',
    sqlType: BuiltinDriftType.dateTime,
    requiredDuringInsert: false,
    constraints: () => [
      const ColumnNotNullConstraint(),
      ColumnDefaultConstraint<DateTime>(currentDateAndTime),
      ColumnCheckConstraint(
        ComparableExpr(creationTime).isGreaterThan(Literal(DateTime.utc(1950))),
      ),
    ],
  )..owningResultSet = this;
  @override
  List<TableColumn> get columns => [
    id,
    name,
    isAwesome,
    profilePicture,
    creationTime,
  ];
  @override
  String get entityName => $name;
  static const String $name = 'users';
  @override
  $UsersTable asSelfType() => this;

  @override
  Set<TableColumn> get primaryKey => {id};
  @override
  User? Function(RawRow) createMapperFromPositions(
    DriftDialect dialect,
    List<ColumnPosition> positions,
  ) {
    final pos$id = positions[0].index;
    final type$0 = BuiltinDriftType.int.resolveIn(dialect);
    final pos$name = positions[1].index;
    final type$1 = BuiltinDriftType.text.resolveIn(dialect);
    final pos$isAwesome = positions[2].index;
    final type$2 = BuiltinDriftType.bool.resolveIn(dialect);
    final pos$profilePicture = positions[3].index;
    final type$3 = BuiltinDriftType.byteArray.resolveIn(dialect);
    final pos$creationTime = positions[4].index;
    final type$4 = BuiltinDriftType.dateTime.resolveIn(dialect);
    return (RawRow row) {
      // Not part of row if non-nullable column "id" is missing
      if (row[pos$id] == null) {
        return null;
      }
      return User(
        id: $UsersTable.$converterid.fromSql(type$0.dartValue(row[pos$id]!)),
        name: type$1.dartValue(row[pos$name]!),
        isAwesome: type$2.dartValue(row[pos$isAwesome]!),
        profilePicture: type$3.dartValue(row[pos$profilePicture]!),
        creationTime: type$4.dartValue(row[pos$creationTime]!),
      );
    };
  }

  @override
  $UsersTable withAlias(String alias) {
    return $UsersTable(alias);
  }

  static JsonTypeConverter2<RowId, int, int> $converterid =
      TypeConverter.extensionType<RowId, int>();
}

class User extends LegacyDataClass implements Insertable<User> {
  final RowId id;
  final String name;
  final bool isAwesome;
  final Uint8List profilePicture;
  final DateTime creationTime;
  const User({
    required this.id,
    required this.name,
    required this.isAwesome,
    required this.profilePicture,
    required this.creationTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      map['id'] = Variable<int>(
        $UsersTable.$converterid.toSql(id),
        BuiltinDriftType.int,
      );
    }
    map['name'] = Variable<String>(name, BuiltinDriftType.text);
    map['is_awesome'] = Variable<bool>(isAwesome, BuiltinDriftType.bool);
    map['profile_picture'] = Variable<Uint8List>(
      profilePicture,
      BuiltinDriftType.byteArray,
    );
    map['creation_time'] = Variable<DateTime>(
      creationTime,
      BuiltinDriftType.dateTime,
    );
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      isAwesome: Value(isAwesome),
      profilePicture: Value(profilePicture),
      creationTime: Value(creationTime),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: $UsersTable.$converterid.fromJson(
        serializer.fromJson<int>(json['id']),
      ),
      name: serializer.fromJson<String>(json['name']),
      isAwesome: serializer.fromJson<bool>(json['isAwesome']),
      profilePicture: serializer.fromJson<Uint8List>(json['profilePicture']),
      creationTime: serializer.fromJson<DateTime>(json['creationTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>($UsersTable.$converterid.toJson(id)),
      'name': serializer.toJson<String>(name),
      'isAwesome': serializer.toJson<bool>(isAwesome),
      'profilePicture': serializer.toJson<Uint8List>(profilePicture),
      'creationTime': serializer.toJson<DateTime>(creationTime),
    };
  }

  User copyWith({
    RowId? id,
    String? name,
    bool? isAwesome,
    Uint8List? profilePicture,
    DateTime? creationTime,
  }) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    isAwesome: isAwesome ?? this.isAwesome,
    profilePicture: profilePicture ?? this.profilePicture,
    creationTime: creationTime ?? this.creationTime,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isAwesome: data.isAwesome.present ? data.isAwesome.value : this.isAwesome,
      profilePicture: data.profilePicture.present
          ? data.profilePicture.value
          : this.profilePicture,
      creationTime: data.creationTime.present
          ? data.creationTime.value
          : this.creationTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isAwesome: $isAwesome, ')
          ..write('profilePicture: $profilePicture, ')
          ..write('creationTime: $creationTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    isAwesome,
    $driftBlobEquality.hash(profilePicture),
    creationTime,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.isAwesome == this.isAwesome &&
          $driftBlobEquality.equals(
            other.profilePicture,
            this.profilePicture,
          ) &&
          other.creationTime == this.creationTime);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<RowId> id;
  final Value<String> name;
  final Value<bool> isAwesome;
  final Value<Uint8List> profilePicture;
  final Value<DateTime> creationTime;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isAwesome = const Value.absent(),
    this.profilePicture = const Value.absent(),
    this.creationTime = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isAwesome = const Value.absent(),
    required Uint8List profilePicture,
    this.creationTime = const Value.absent(),
  }) : name = Value(name),
       profilePicture = Value(profilePicture);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isAwesome,
    Expression<Uint8List>? profilePicture,
    Expression<DateTime>? creationTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isAwesome != null) 'is_awesome': isAwesome,
      if (profilePicture != null) 'profile_picture': profilePicture,
      if (creationTime != null) 'creation_time': creationTime,
    });
  }

  UsersCompanion copyWith({
    Value<RowId>? id,
    Value<String>? name,
    Value<bool>? isAwesome,
    Value<Uint8List>? profilePicture,
    Value<DateTime>? creationTime,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isAwesome: isAwesome ?? this.isAwesome,
      profilePicture: profilePicture ?? this.profilePicture,
      creationTime: creationTime ?? this.creationTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(
        $UsersTable.$converterid.toSql(id.value),
        BuiltinDriftType.int,
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value, BuiltinDriftType.text);
    }
    if (isAwesome.present) {
      map['is_awesome'] = Variable<bool>(
        isAwesome.value,
        BuiltinDriftType.bool,
      );
    }
    if (profilePicture.present) {
      map['profile_picture'] = Variable<Uint8List>(
        profilePicture.value,
        BuiltinDriftType.byteArray,
      );
    }
    if (creationTime.present) {
      map['creation_time'] = Variable<DateTime>(
        creationTime.value,
        BuiltinDriftType.dateTime,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isAwesome: $isAwesome, ')
          ..write('profilePicture: $profilePicture, ')
          ..write('creationTime: $creationTime')
          ..write(')'))
        .toString();
  }
}

class $SharedTodosTable extends SharedTodos
    with ResultSet<SharedTodo, $SharedTodosTable>
    implements GeneratedTable<SharedTodo, $SharedTodosTable> {
  @override
  final String? alias;
  $SharedTodosTable([this.alias]);
  @override
  late final TableColumn<int> todo = TableColumn<int>(
    name: 'todo',
    sqlType: BuiltinDriftType.int,
    requiredDuringInsert: true,
    constraints: () => [const ColumnNotNullConstraint()],
  )..owningResultSet = this;
  @override
  late final TableColumn<int> user = TableColumn<int>(
    name: 'user',
    sqlType: BuiltinDriftType.int,
    requiredDuringInsert: true,
    constraints: () => [const ColumnNotNullConstraint()],
  )..owningResultSet = this;
  @override
  List<TableColumn> get columns => [todo, user];
  @override
  String get entityName => $name;
  static const String $name = 'shared_todos';
  @override
  $SharedTodosTable asSelfType() => this;

  @override
  Set<TableColumn> get primaryKey => {todo, user};
  @override
  SharedTodo? Function(RawRow) createMapperFromPositions(
    DriftDialect dialect,
    List<ColumnPosition> positions,
  ) {
    final pos$todo = positions[0].index;
    final type$0 = BuiltinDriftType.int.resolveIn(dialect);
    final pos$user = positions[1].index;
    return (RawRow row) {
      // Not part of row if non-nullable column "todo" is missing
      if (row[pos$todo] == null) {
        return null;
      }
      return SharedTodo(
        todo: type$0.dartValue(row[pos$todo]!),
        user: type$0.dartValue(row[pos$user]!),
      );
    };
  }

  @override
  $SharedTodosTable withAlias(String alias) {
    return $SharedTodosTable(alias);
  }
}

class SharedTodo extends LegacyDataClass implements Insertable<SharedTodo> {
  final int todo;
  final int user;
  const SharedTodo({required this.todo, required this.user});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['todo'] = Variable<int>(todo, BuiltinDriftType.int);
    map['user'] = Variable<int>(user, BuiltinDriftType.int);
    return map;
  }

  SharedTodosCompanion toCompanion(bool nullToAbsent) {
    return SharedTodosCompanion(todo: Value(todo), user: Value(user));
  }

  factory SharedTodo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SharedTodo(
      todo: serializer.fromJson<int>(json['todo']),
      user: serializer.fromJson<int>(json['user']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'todo': serializer.toJson<int>(todo),
      'user': serializer.toJson<int>(user),
    };
  }

  SharedTodo copyWith({int? todo, int? user}) =>
      SharedTodo(todo: todo ?? this.todo, user: user ?? this.user);
  SharedTodo copyWithCompanion(SharedTodosCompanion data) {
    return SharedTodo(
      todo: data.todo.present ? data.todo.value : this.todo,
      user: data.user.present ? data.user.value : this.user,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SharedTodo(')
          ..write('todo: $todo, ')
          ..write('user: $user')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(todo, user);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SharedTodo &&
          other.todo == this.todo &&
          other.user == this.user);
}

class SharedTodosCompanion extends UpdateCompanion<SharedTodo> {
  final Value<int> todo;
  final Value<int> user;
  final Value<int> rowid;
  const SharedTodosCompanion({
    this.todo = const Value.absent(),
    this.user = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SharedTodosCompanion.insert({
    required int todo,
    required int user,
    this.rowid = const Value.absent(),
  }) : todo = Value(todo),
       user = Value(user);
  static Insertable<SharedTodo> custom({
    Expression<int>? todo,
    Expression<int>? user,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (todo != null) 'todo': todo,
      if (user != null) 'user': user,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SharedTodosCompanion copyWith({
    Value<int>? todo,
    Value<int>? user,
    Value<int>? rowid,
  }) {
    return SharedTodosCompanion(
      todo: todo ?? this.todo,
      user: user ?? this.user,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (todo.present) {
      map['todo'] = Variable<int>(todo.value, BuiltinDriftType.int);
    }
    if (user.present) {
      map['user'] = Variable<int>(user.value, BuiltinDriftType.int);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value, BuiltinDriftType.int);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SharedTodosCompanion(')
          ..write('todo: $todo, ')
          ..write('user: $user, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TableWithoutPKTable extends TableWithoutPK
    with ResultSet<CustomRowClass, $TableWithoutPKTable>
    implements GeneratedTable<CustomRowClass, $TableWithoutPKTable> {
  @override
  final String? alias;
  $TableWithoutPKTable([this.alias]);
  @override
  late final TableColumn<int> notReallyAnId = TableColumn<int>(
    name: 'not_really_an_id',
    sqlType: BuiltinDriftType.int,
    requiredDuringInsert: true,
    constraints: () => [const ColumnNotNullConstraint()],
  )..owningResultSet = this;
  @override
  late final TableColumn<double> someFloat = TableColumn<double>(
    name: 'some_float',
    sqlType: BuiltinDriftType.double,
    requiredDuringInsert: true,
    constraints: () => [const ColumnNotNullConstraint()],
  )..owningResultSet = this;
  @override
  late final TableColumn<BigInt> webSafeInt = TableColumn<BigInt>(
    name: 'web_safe_int',
    sqlType: BuiltinDriftType.int64,
    requiredDuringInsert: false,
  )..owningResultSet = this;
  @override
  late final TableColumnWithTypeConverter<MyCustomObject, String> custom =
      TableColumn<String>(
          name: 'custom',
          sqlType: BuiltinDriftType.text,
          requiredDuringInsert: false,
          constraints: () => [const ColumnNotNullConstraint()],
          clientDefault: _uuid.v4,
        ).withConverter<MyCustomObject>($TableWithoutPKTable.$convertercustom)
        ..owningResultSet = this;
  @override
  List<TableColumn> get columns => [
    notReallyAnId,
    someFloat,
    webSafeInt,
    custom,
  ];
  @override
  String get entityName => $name;
  static const String $name = 'table_without_p_k';
  @override
  $TableWithoutPKTable asSelfType() => this;

  @override
  Set<TableColumn> get primaryKey => const {};
  @override
  CustomRowClass? Function(RawRow) createMapperFromPositions(
    DriftDialect dialect,
    List<ColumnPosition> positions,
  ) {
    final pos$notReallyAnId = positions[0].index;
    final type$0 = BuiltinDriftType.int.resolveIn(dialect);
    final pos$someFloat = positions[1].index;
    final type$1 = BuiltinDriftType.double.resolveIn(dialect);
    final pos$webSafeInt = positions[2].index;
    final type$2 = BuiltinDriftType.int64.resolveIn(dialect);
    final pos$custom = positions[3].index;
    final type$3 = BuiltinDriftType.text.resolveIn(dialect);
    return (RawRow row) {
      // Not part of row if non-nullable column "notReallyAnId" is missing
      if (row[pos$notReallyAnId] == null) {
        return null;
      }
      return CustomRowClass.map(
        type$0.dartValue(row[pos$notReallyAnId]!),
        type$1.dartValue(row[pos$someFloat]!),
        custom: $TableWithoutPKTable.$convertercustom.fromSql(
          type$3.dartValue(row[pos$custom]!),
        ),
        webSafeInt: type$2.nullableDartValue(row[pos$webSafeInt]),
      );
    };
  }

  @override
  $TableWithoutPKTable withAlias(String alias) {
    return $TableWithoutPKTable(alias);
  }

  static TypeConverter<MyCustomObject, String> $convertercustom =
      const CustomConverter();
}

class TableWithoutPKCompanion extends UpdateCompanion<CustomRowClass> {
  final Value<int> notReallyAnId;
  final Value<double> someFloat;
  final Value<BigInt?> webSafeInt;
  final Value<MyCustomObject> custom;
  final Value<int> rowid;
  const TableWithoutPKCompanion({
    this.notReallyAnId = const Value.absent(),
    this.someFloat = const Value.absent(),
    this.webSafeInt = const Value.absent(),
    this.custom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TableWithoutPKCompanion.insert({
    required int notReallyAnId,
    required double someFloat,
    this.webSafeInt = const Value.absent(),
    this.custom = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : notReallyAnId = Value(notReallyAnId),
       someFloat = Value(someFloat);
  static Insertable<CustomRowClass> createCustom({
    Expression<int>? notReallyAnId,
    Expression<double>? someFloat,
    Expression<BigInt>? webSafeInt,
    Expression<String>? custom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (notReallyAnId != null) 'not_really_an_id': notReallyAnId,
      if (someFloat != null) 'some_float': someFloat,
      if (webSafeInt != null) 'web_safe_int': webSafeInt,
      if (custom != null) 'custom': custom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TableWithoutPKCompanion copyWith({
    Value<int>? notReallyAnId,
    Value<double>? someFloat,
    Value<BigInt?>? webSafeInt,
    Value<MyCustomObject>? custom,
    Value<int>? rowid,
  }) {
    return TableWithoutPKCompanion(
      notReallyAnId: notReallyAnId ?? this.notReallyAnId,
      someFloat: someFloat ?? this.someFloat,
      webSafeInt: webSafeInt ?? this.webSafeInt,
      custom: custom ?? this.custom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (notReallyAnId.present) {
      map['not_really_an_id'] = Variable<int>(
        notReallyAnId.value,
        BuiltinDriftType.int,
      );
    }
    if (someFloat.present) {
      map['some_float'] = Variable<double>(
        someFloat.value,
        BuiltinDriftType.double,
      );
    }
    if (webSafeInt.present) {
      map['web_safe_int'] = Variable<BigInt>(
        webSafeInt.value,
        BuiltinDriftType.int64,
      );
    }
    if (custom.present) {
      map['custom'] = Variable<String>(
        $TableWithoutPKTable.$convertercustom.toSql(custom.value),
        BuiltinDriftType.text,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value, BuiltinDriftType.int);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TableWithoutPKCompanion(')
          ..write('notReallyAnId: $notReallyAnId, ')
          ..write('someFloat: $someFloat, ')
          ..write('webSafeInt: $webSafeInt, ')
          ..write('custom: $custom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$CustomRowClassInsertable implements Insertable<CustomRowClass> {
  CustomRowClass _object;
  _$CustomRowClassInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return TableWithoutPKCompanion(
      notReallyAnId: Value(_object.notReallyAnId),
      someFloat: Value(_object.someFloat),
      webSafeInt: Value(_object.webSafeInt),
      custom: Value(_object.custom),
    ).toColumns(false);
  }
}

extension CustomRowClassToInsertable on CustomRowClass {
  _$CustomRowClassInsertable toInsertable() {
    return _$CustomRowClassInsertable(this);
  }
}

abstract base class _$TodoDb extends GeneratedDatabase {
  _$TodoDb(super.implementation);
  late final $CategoriesTable categories = $CategoriesTable();
  late final $TodosTableTable todosTable = $TodosTableTable();
  late final $UsersTable users = $UsersTable();
  late final $SharedTodosTable sharedTodos = $SharedTodosTable();
  late final $TableWithoutPKTable tableWithoutPK = $TableWithoutPKTable();
  late final Index categoriesDesc = Index(
    'categories_desc',
    CustomComponent(
      'CREATE INDEX categories_desc ON categories ("desc" DESC, priority)',
      dialectSpecificSql: {
        KnownSqlDialect.sqlite: '',
        KnownSqlDialect.postgres: '',
      },
    ),
  );
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    todosTable,
    users,
    sharedTodos,
    tableWithoutPK,
    categoriesDesc,
  ];
}
