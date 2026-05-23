// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DepartmentTable extends Department
    with ResultSet<DepartmentData, $DepartmentTable>
    implements GeneratedTable<DepartmentData, $DepartmentTable> {
  @override
  final String? alias;
  $DepartmentTable([this.alias]);
  @override
  late final TableColumn<int> id = TableColumn<int>(
    name: 'id',
    sqlType: BuiltinDriftType.int,
    requiredDuringInsert: false,
    constraints: () => [
      const ColumnPrimaryKeyConstraint(isAutoIncrementing: true),
      const ColumnNotNullConstraint(),
    ],
  )..owningResultSet = this;
  @override
  late final TableColumn<String> name = TableColumn<String>(
    name: 'name',
    sqlType: BuiltinDriftType.text,
    requiredDuringInsert: false,
  )..owningResultSet = this;
  @override
  List<TableColumn> get columns => [id, name];
  @override
  String get entityName => $name;
  static const String $name = 'department';
  @override
  $DepartmentTable asSelfType() => this;

  @override
  Set<TableColumn> get primaryKey => {id};
  @override
  DepartmentData? Function(RawRow) createMapperFromPositions(
    DriftDialect dialect,
    List<ColumnPosition> positions,
  ) {
    final pos$id = positions[0].index;
    final type$0 = BuiltinDriftType.int.resolveIn(dialect);
    final pos$name = positions[1].index;
    final type$1 = BuiltinDriftType.text.resolveIn(dialect);
    return (RawRow row) {
      // Not part of row if non-nullable column "id" is missing
      if (row[pos$id] == null) {
        return null;
      }
      return DepartmentData(
        id: type$0.dartValue(row[pos$id]!),
        name: type$1.nullableDartValue(row[pos$name]),
      );
    };
  }

  @override
  $DepartmentTable withAlias(String alias) {
    return $DepartmentTable(alias);
  }
}

class DepartmentData extends LegacyDataClass
    implements Insertable<DepartmentData> {
  final int id;
  final String? name;
  const DepartmentData({required this.id, this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id, BuiltinDriftType.int);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name, BuiltinDriftType.text);
    }
    return map;
  }

  DepartmentCompanion toCompanion(bool nullToAbsent) {
    return DepartmentCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory DepartmentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DepartmentData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
    };
  }

  DepartmentData copyWith({
    int? id,
    Value<String?> name = const Value.absent(),
  }) => DepartmentData(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
  );
  DepartmentData copyWithCompanion(DepartmentCompanion data) {
    return DepartmentData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DepartmentData(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DepartmentData &&
          other.id == this.id &&
          other.name == this.name);
}

class DepartmentCompanion extends UpdateCompanion<DepartmentData> {
  final Value<int> id;
  final Value<String?> name;
  const DepartmentCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  DepartmentCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  static Insertable<DepartmentData> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  DepartmentCompanion copyWith({Value<int>? id, Value<String?>? name}) {
    return DepartmentCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value, BuiltinDriftType.int);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value, BuiltinDriftType.text);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepartmentCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ProductTable extends Product
    with ResultSet<ProductData, $ProductTable>
    implements GeneratedTable<ProductData, $ProductTable> {
  @override
  final String? alias;
  $ProductTable([this.alias]);
  @override
  late final TableColumn<String> sku = TableColumn<String>(
    name: 'sku',
    sqlType: BuiltinDriftType.text,
    requiredDuringInsert: true,
    constraints: () => [const ColumnNotNullConstraint()],
  )..owningResultSet = this;
  @override
  late final TableColumn<String> name = TableColumn<String>(
    name: 'name',
    sqlType: BuiltinDriftType.text,
    requiredDuringInsert: false,
  )..owningResultSet = this;
  @override
  late final TableColumn<int> department = TableColumn<int>(
    name: 'department',
    sqlType: BuiltinDriftType.int,
    requiredDuringInsert: false,
    constraints: () => [
      const ColumnForeignKeyConstraint(
        otherTableName: 'department',
        otherColumnName: 'id',
      ),
    ],
  )..owningResultSet = this;
  @override
  List<TableColumn> get columns => [sku, name, department];
  @override
  String get entityName => $name;
  static const String $name = 'product';
  @override
  $ProductTable asSelfType() => this;

  @override
  Set<TableColumn> get primaryKey => const {};
  @override
  ProductData? Function(RawRow) createMapperFromPositions(
    DriftDialect dialect,
    List<ColumnPosition> positions,
  ) {
    final pos$sku = positions[0].index;
    final type$0 = BuiltinDriftType.text.resolveIn(dialect);
    final pos$name = positions[1].index;
    final pos$department = positions[2].index;
    final type$1 = BuiltinDriftType.int.resolveIn(dialect);
    return (RawRow row) {
      // Not part of row if non-nullable column "sku" is missing
      if (row[pos$sku] == null) {
        return null;
      }
      return ProductData(
        sku: type$0.dartValue(row[pos$sku]!),
        name: type$0.nullableDartValue(row[pos$name]),
        department: type$1.nullableDartValue(row[pos$department]),
      );
    };
  }

  @override
  $ProductTable withAlias(String alias) {
    return $ProductTable(alias);
  }
}

class ProductData extends LegacyDataClass implements Insertable<ProductData> {
  final String sku;
  final String? name;
  final int? department;
  const ProductData({required this.sku, this.name, this.department});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sku'] = Variable<String>(sku, BuiltinDriftType.text);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name, BuiltinDriftType.text);
    }
    if (!nullToAbsent || department != null) {
      map['department'] = Variable<int>(department, BuiltinDriftType.int);
    }
    return map;
  }

  ProductCompanion toCompanion(bool nullToAbsent) {
    return ProductCompanion(
      sku: Value(sku),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      department: department == null && nullToAbsent
          ? const Value.absent()
          : Value(department),
    );
  }

  factory ProductData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductData(
      sku: serializer.fromJson<String>(json['sku']),
      name: serializer.fromJson<String?>(json['name']),
      department: serializer.fromJson<int?>(json['department']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sku': serializer.toJson<String>(sku),
      'name': serializer.toJson<String?>(name),
      'department': serializer.toJson<int?>(department),
    };
  }

  ProductData copyWith({
    String? sku,
    Value<String?> name = const Value.absent(),
    Value<int?> department = const Value.absent(),
  }) => ProductData(
    sku: sku ?? this.sku,
    name: name.present ? name.value : this.name,
    department: department.present ? department.value : this.department,
  );
  ProductData copyWithCompanion(ProductCompanion data) {
    return ProductData(
      sku: data.sku.present ? data.sku.value : this.sku,
      name: data.name.present ? data.name.value : this.name,
      department: data.department.present
          ? data.department.value
          : this.department,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductData(')
          ..write('sku: $sku, ')
          ..write('name: $name, ')
          ..write('department: $department')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sku, name, department);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductData &&
          other.sku == this.sku &&
          other.name == this.name &&
          other.department == this.department);
}

class ProductCompanion extends UpdateCompanion<ProductData> {
  final Value<String> sku;
  final Value<String?> name;
  final Value<int?> department;
  final Value<int> rowid;
  const ProductCompanion({
    this.sku = const Value.absent(),
    this.name = const Value.absent(),
    this.department = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductCompanion.insert({
    required String sku,
    this.name = const Value.absent(),
    this.department = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sku = Value(sku);
  static Insertable<ProductData> custom({
    Expression<String>? sku,
    Expression<String>? name,
    Expression<int>? department,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sku != null) 'sku': sku,
      if (name != null) 'name': name,
      if (department != null) 'department': department,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductCompanion copyWith({
    Value<String>? sku,
    Value<String?>? name,
    Value<int?>? department,
    Value<int>? rowid,
  }) {
    return ProductCompanion(
      sku: sku ?? this.sku,
      name: name ?? this.name,
      department: department ?? this.department,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value, BuiltinDriftType.text);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value, BuiltinDriftType.text);
    }
    if (department.present) {
      map['department'] = Variable<int>(department.value, BuiltinDriftType.int);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value, BuiltinDriftType.int);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductCompanion(')
          ..write('sku: $sku, ')
          ..write('name: $name, ')
          ..write('department: $department, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoreTable extends Store
    with ResultSet<StoreData, $StoreTable>
    implements GeneratedTable<StoreData, $StoreTable> {
  @override
  final String? alias;
  $StoreTable([this.alias]);
  @override
  late final TableColumn<int> id = TableColumn<int>(
    name: 'id',
    sqlType: BuiltinDriftType.int,
    requiredDuringInsert: false,
    constraints: () => [
      const ColumnPrimaryKeyConstraint(isAutoIncrementing: true),
      const ColumnNotNullConstraint(),
    ],
  )..owningResultSet = this;
  @override
  late final TableColumn<String> name = TableColumn<String>(
    name: 'name',
    sqlType: BuiltinDriftType.text,
    requiredDuringInsert: false,
  )..owningResultSet = this;
  @override
  List<TableColumn> get columns => [id, name];
  @override
  String get entityName => $name;
  static const String $name = 'store';
  @override
  $StoreTable asSelfType() => this;

  @override
  Set<TableColumn> get primaryKey => {id};
  @override
  StoreData? Function(RawRow) createMapperFromPositions(
    DriftDialect dialect,
    List<ColumnPosition> positions,
  ) {
    final pos$id = positions[0].index;
    final type$0 = BuiltinDriftType.int.resolveIn(dialect);
    final pos$name = positions[1].index;
    final type$1 = BuiltinDriftType.text.resolveIn(dialect);
    return (RawRow row) {
      // Not part of row if non-nullable column "id" is missing
      if (row[pos$id] == null) {
        return null;
      }
      return StoreData(
        id: type$0.dartValue(row[pos$id]!),
        name: type$1.nullableDartValue(row[pos$name]),
      );
    };
  }

  @override
  $StoreTable withAlias(String alias) {
    return $StoreTable(alias);
  }
}

class StoreData extends LegacyDataClass implements Insertable<StoreData> {
  final int id;
  final String? name;
  const StoreData({required this.id, this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id, BuiltinDriftType.int);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name, BuiltinDriftType.text);
    }
    return map;
  }

  StoreCompanion toCompanion(bool nullToAbsent) {
    return StoreCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory StoreData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoreData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
    };
  }

  StoreData copyWith({int? id, Value<String?> name = const Value.absent()}) =>
      StoreData(id: id ?? this.id, name: name.present ? name.value : this.name);
  StoreData copyWithCompanion(StoreCompanion data) {
    return StoreData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoreData(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoreData && other.id == this.id && other.name == this.name);
}

class StoreCompanion extends UpdateCompanion<StoreData> {
  final Value<int> id;
  final Value<String?> name;
  const StoreCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  StoreCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  static Insertable<StoreData> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  StoreCompanion copyWith({Value<int>? id, Value<String?>? name}) {
    return StoreCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value, BuiltinDriftType.int);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value, BuiltinDriftType.text);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoreCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ListingTable extends Listing
    with ResultSet<ListingData, $ListingTable>
    implements GeneratedTable<ListingData, $ListingTable> {
  @override
  final String? alias;
  $ListingTable([this.alias]);
  @override
  late final TableColumn<int> id = TableColumn<int>(
    name: 'id',
    sqlType: BuiltinDriftType.int,
    requiredDuringInsert: false,
    constraints: () => [
      const ColumnPrimaryKeyConstraint(isAutoIncrementing: true),
      const ColumnNotNullConstraint(),
    ],
  )..owningResultSet = this;
  @override
  late final TableColumn<String> product = TableColumn<String>(
    name: 'product',
    sqlType: BuiltinDriftType.text,
    requiredDuringInsert: true,
    constraints: () => [
      const ColumnNotNullConstraint(),
      const ColumnForeignKeyConstraint(
        otherTableName: 'product',
        otherColumnName: 'sku',
      ),
    ],
  )..owningResultSet = this;
  @override
  late final TableColumn<int> store = TableColumn<int>(
    name: 'store',
    sqlType: BuiltinDriftType.int,
    requiredDuringInsert: false,
    constraints: () => [
      const ColumnForeignKeyConstraint(
        otherTableName: 'store',
        otherColumnName: 'id',
      ),
    ],
  )..owningResultSet = this;
  @override
  late final TableColumn<double> price = TableColumn<double>(
    name: 'price',
    sqlType: BuiltinDriftType.double,
    requiredDuringInsert: false,
  )..owningResultSet = this;
  @override
  List<TableColumn> get columns => [id, product, store, price];
  @override
  String get entityName => $name;
  static const String $name = 'listing';
  @override
  $ListingTable asSelfType() => this;

  @override
  Set<TableColumn> get primaryKey => {id};
  @override
  ListingData? Function(RawRow) createMapperFromPositions(
    DriftDialect dialect,
    List<ColumnPosition> positions,
  ) {
    final pos$id = positions[0].index;
    final type$0 = BuiltinDriftType.int.resolveIn(dialect);
    final pos$product = positions[1].index;
    final type$1 = BuiltinDriftType.text.resolveIn(dialect);
    final pos$store = positions[2].index;
    final pos$price = positions[3].index;
    final type$2 = BuiltinDriftType.double.resolveIn(dialect);
    return (RawRow row) {
      // Not part of row if non-nullable column "id" is missing
      if (row[pos$id] == null) {
        return null;
      }
      return ListingData(
        id: type$0.dartValue(row[pos$id]!),
        product: type$1.dartValue(row[pos$product]!),
        store: type$0.nullableDartValue(row[pos$store]),
        price: type$2.nullableDartValue(row[pos$price]),
      );
    };
  }

  @override
  $ListingTable withAlias(String alias) {
    return $ListingTable(alias);
  }
}

class ListingData extends LegacyDataClass implements Insertable<ListingData> {
  final int id;
  final String product;
  final int? store;
  final double? price;
  const ListingData({
    required this.id,
    required this.product,
    this.store,
    this.price,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id, BuiltinDriftType.int);
    map['product'] = Variable<String>(product, BuiltinDriftType.text);
    if (!nullToAbsent || store != null) {
      map['store'] = Variable<int>(store, BuiltinDriftType.int);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price, BuiltinDriftType.double);
    }
    return map;
  }

  ListingCompanion toCompanion(bool nullToAbsent) {
    return ListingCompanion(
      id: Value(id),
      product: Value(product),
      store: store == null && nullToAbsent
          ? const Value.absent()
          : Value(store),
      price: price == null && nullToAbsent
          ? const Value.absent()
          : Value(price),
    );
  }

  factory ListingData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListingData(
      id: serializer.fromJson<int>(json['id']),
      product: serializer.fromJson<String>(json['product']),
      store: serializer.fromJson<int?>(json['store']),
      price: serializer.fromJson<double?>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'product': serializer.toJson<String>(product),
      'store': serializer.toJson<int?>(store),
      'price': serializer.toJson<double?>(price),
    };
  }

  ListingData copyWith({
    int? id,
    String? product,
    Value<int?> store = const Value.absent(),
    Value<double?> price = const Value.absent(),
  }) => ListingData(
    id: id ?? this.id,
    product: product ?? this.product,
    store: store.present ? store.value : this.store,
    price: price.present ? price.value : this.price,
  );
  ListingData copyWithCompanion(ListingCompanion data) {
    return ListingData(
      id: data.id.present ? data.id.value : this.id,
      product: data.product.present ? data.product.value : this.product,
      store: data.store.present ? data.store.value : this.store,
      price: data.price.present ? data.price.value : this.price,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListingData(')
          ..write('id: $id, ')
          ..write('product: $product, ')
          ..write('store: $store, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, product, store, price);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListingData &&
          other.id == this.id &&
          other.product == this.product &&
          other.store == this.store &&
          other.price == this.price);
}

class ListingCompanion extends UpdateCompanion<ListingData> {
  final Value<int> id;
  final Value<String> product;
  final Value<int?> store;
  final Value<double?> price;
  const ListingCompanion({
    this.id = const Value.absent(),
    this.product = const Value.absent(),
    this.store = const Value.absent(),
    this.price = const Value.absent(),
  });
  ListingCompanion.insert({
    this.id = const Value.absent(),
    required String product,
    this.store = const Value.absent(),
    this.price = const Value.absent(),
  }) : product = Value(product);
  static Insertable<ListingData> custom({
    Expression<int>? id,
    Expression<String>? product,
    Expression<int>? store,
    Expression<double>? price,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (product != null) 'product': product,
      if (store != null) 'store': store,
      if (price != null) 'price': price,
    });
  }

  ListingCompanion copyWith({
    Value<int>? id,
    Value<String>? product,
    Value<int?>? store,
    Value<double?>? price,
  }) {
    return ListingCompanion(
      id: id ?? this.id,
      product: product ?? this.product,
      store: store ?? this.store,
      price: price ?? this.price,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value, BuiltinDriftType.int);
    }
    if (product.present) {
      map['product'] = Variable<String>(product.value, BuiltinDriftType.text);
    }
    if (store.present) {
      map['store'] = Variable<int>(store.value, BuiltinDriftType.int);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value, BuiltinDriftType.double);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListingCompanion(')
          ..write('id: $id, ')
          ..write('product: $product, ')
          ..write('store: $store, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }
}

abstract base class _$TestDatabase extends GeneratedDatabase {
  _$TestDatabase(super.implementation);
  $TestDatabaseManager get managers => $TestDatabaseManager(this);
  late final $DepartmentTable department = $DepartmentTable();
  late final $ProductTable product = $ProductTable();
  late final $StoreTable store = $StoreTable();
  late final $ListingTable listing = $ListingTable();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    department,
    product,
    store,
    listing,
  ];
}

typedef $$DepartmentTableCreateCompanionBuilder =
    DepartmentCompanion Function({Value<int> id, Value<String?> name});
typedef $$DepartmentTableUpdateCompanionBuilder =
    DepartmentCompanion Function({Value<int> id, Value<String?> name});

final class $$DepartmentTableReferences
    extends BaseReferences<_$TestDatabase, $DepartmentTable, DepartmentData> {
  $$DepartmentTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<List<ProductData>> _productRefsTable(
    _$TestDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.product,
    aliasName: 'department__id__product__department',
  );

  $$ProductTableProcessedTableManager get productRefs {
    final manager = $$ProductTableTableManager(
      $_db,
      $_db.product,
    ).filter((f) => f.department.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DepartmentTableFilterComposer
    extends Composer<_$TestDatabase, $DepartmentTable> {
  $$DepartmentTableFilterComposer({
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

  Expression<bool> productRefs(
    Expression<bool> Function($$ProductTableFilterComposer f) f,
  ) {
    final $$ProductTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.product,
      getReferencedColumn: (t) => t.department,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductTableFilterComposer(
            $db: $db,
            $table: $db.product,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DepartmentTableOrderingComposer
    extends Composer<_$TestDatabase, $DepartmentTable> {
  $$DepartmentTableOrderingComposer({
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
}

class $$DepartmentTableAnnotationComposer
    extends Composer<_$TestDatabase, $DepartmentTable> {
  $$DepartmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  TableColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  TableColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> productRefs<T extends Object>(
    Expression<T> Function($$ProductTableAnnotationComposer a) f,
  ) {
    final $$ProductTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.product,
      getReferencedColumn: (t) => t.department,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductTableAnnotationComposer(
            $db: $db,
            $table: $db.product,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DepartmentTableTableManager
    extends
        RootTableManager<
          _$TestDatabase,
          $DepartmentTable,
          DepartmentData,
          $$DepartmentTableFilterComposer,
          $$DepartmentTableOrderingComposer,
          $$DepartmentTableAnnotationComposer,
          $$DepartmentTableCreateCompanionBuilder,
          $$DepartmentTableUpdateCompanionBuilder,
          (DepartmentData, $$DepartmentTableReferences),
          DepartmentData,
          PrefetchHooks Function({bool productRefs})
        > {
  $$DepartmentTableTableManager(_$TestDatabase db, $DepartmentTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepartmentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepartmentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DepartmentTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
              }) => DepartmentCompanion(id: id, name: name),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
              }) => DepartmentCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DepartmentTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productRefs) db.product],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productRefs)
                    await $_getPrefetchedData<
                      DepartmentData,
                      $DepartmentTable,
                      ProductData
                    >(
                      currentTable: table,
                      referencedTable: $$DepartmentTableReferences
                          ._productRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DepartmentTableReferences(
                            db,
                            table,
                            p0,
                          ).productRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.department == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DepartmentTableProcessedTableManager =
    ProcessedTableManager<
      _$TestDatabase,
      $DepartmentTable,
      DepartmentData,
      $$DepartmentTableFilterComposer,
      $$DepartmentTableOrderingComposer,
      $$DepartmentTableAnnotationComposer,
      $$DepartmentTableCreateCompanionBuilder,
      $$DepartmentTableUpdateCompanionBuilder,
      (DepartmentData, $$DepartmentTableReferences),
      DepartmentData,
      PrefetchHooks Function({bool productRefs})
    >;
typedef $$ProductTableCreateCompanionBuilder =
    ProductCompanion Function({
      required String sku,
      Value<String?> name,
      Value<int?> department,
      Value<int> rowid,
    });
typedef $$ProductTableUpdateCompanionBuilder =
    ProductCompanion Function({
      Value<String> sku,
      Value<String?> name,
      Value<int?> department,
      Value<int> rowid,
    });

final class $$ProductTableReferences
    extends BaseReferences<_$TestDatabase, $ProductTable, ProductData> {
  $$ProductTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DepartmentTable _departmentTable(_$TestDatabase db) =>
      db.department.withAlias('product__department__department__id');

  $$DepartmentTableProcessedTableManager? get department {
    final $_column = $_itemColumn<int>('department');
    if ($_column == null) return null;
    final manager = $$DepartmentTableTableManager(
      $_db,
      $_db.department,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_departmentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<List<ListingData>> _listingsTable(
    _$TestDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.listing,
    aliasName: 'product__sku__listing__product',
  );

  $$ListingTableProcessedTableManager get listings {
    final manager = $$ListingTableTableManager(
      $_db,
      $_db.listing,
    ).filter((f) => f.product.sku.sqlEquals($_itemColumn<String>('sku')!));

    final cache = $_typedResult.readTableOrNull(_listingsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductTableFilterComposer
    extends Composer<_$TestDatabase, $ProductTable> {
  $$ProductTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$DepartmentTableFilterComposer get department {
    final $$DepartmentTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.department,
      referencedTable: $db.department,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentTableFilterComposer(
            $db: $db,
            $table: $db.department,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> listings(
    Expression<bool> Function($$ListingTableFilterComposer f) f,
  ) {
    final $$ListingTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sku,
      referencedTable: $db.listing,
      getReferencedColumn: (t) => t.product,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListingTableFilterComposer(
            $db: $db,
            $table: $db.listing,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductTableOrderingComposer
    extends Composer<_$TestDatabase, $ProductTable> {
  $$ProductTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$DepartmentTableOrderingComposer get department {
    final $$DepartmentTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.department,
      referencedTable: $db.department,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentTableOrderingComposer(
            $db: $db,
            $table: $db.department,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductTableAnnotationComposer
    extends Composer<_$TestDatabase, $ProductTable> {
  $$ProductTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  TableColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  TableColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$DepartmentTableAnnotationComposer get department {
    final $$DepartmentTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.department,
      referencedTable: $db.department,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentTableAnnotationComposer(
            $db: $db,
            $table: $db.department,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> listings<T extends Object>(
    Expression<T> Function($$ListingTableAnnotationComposer a) f,
  ) {
    final $$ListingTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sku,
      referencedTable: $db.listing,
      getReferencedColumn: (t) => t.product,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListingTableAnnotationComposer(
            $db: $db,
            $table: $db.listing,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductTableTableManager
    extends
        RootTableManager<
          _$TestDatabase,
          $ProductTable,
          ProductData,
          $$ProductTableFilterComposer,
          $$ProductTableOrderingComposer,
          $$ProductTableAnnotationComposer,
          $$ProductTableCreateCompanionBuilder,
          $$ProductTableUpdateCompanionBuilder,
          (ProductData, $$ProductTableReferences),
          ProductData,
          PrefetchHooks Function({bool department, bool listings})
        > {
  $$ProductTableTableManager(_$TestDatabase db, $ProductTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sku = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int?> department = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductCompanion(
                sku: sku,
                name: name,
                department: department,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sku,
                Value<String?> name = const Value.absent(),
                Value<int?> department = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductCompanion.insert(
                sku: sku,
                name: name,
                department: department,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({department = false, listings = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (listings) db.listing],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (department) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.department,
                                referencedTable: $$ProductTableReferences
                                    ._departmentTable(db),
                                referencedColumn: $$ProductTableReferences
                                    ._departmentTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (listings)
                    await $_getPrefetchedData<
                      ProductData,
                      $ProductTable,
                      ListingData
                    >(
                      currentTable: table,
                      referencedTable: $$ProductTableReferences._listingsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$ProductTableReferences(db, table, p0).listings,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.product == item.sku),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductTableProcessedTableManager =
    ProcessedTableManager<
      _$TestDatabase,
      $ProductTable,
      ProductData,
      $$ProductTableFilterComposer,
      $$ProductTableOrderingComposer,
      $$ProductTableAnnotationComposer,
      $$ProductTableCreateCompanionBuilder,
      $$ProductTableUpdateCompanionBuilder,
      (ProductData, $$ProductTableReferences),
      ProductData,
      PrefetchHooks Function({bool department, bool listings})
    >;
typedef $$StoreTableCreateCompanionBuilder =
    StoreCompanion Function({Value<int> id, Value<String?> name});
typedef $$StoreTableUpdateCompanionBuilder =
    StoreCompanion Function({Value<int> id, Value<String?> name});

final class $$StoreTableReferences
    extends BaseReferences<_$TestDatabase, $StoreTable, StoreData> {
  $$StoreTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<List<ListingData>> _listingsTable(
    _$TestDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.listing,
    aliasName: 'store__id__listing__store',
  );

  $$ListingTableProcessedTableManager get listings {
    final manager = $$ListingTableTableManager(
      $_db,
      $_db.listing,
    ).filter((f) => f.store.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_listingsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StoreTableFilterComposer extends Composer<_$TestDatabase, $StoreTable> {
  $$StoreTableFilterComposer({
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

  Expression<bool> listings(
    Expression<bool> Function($$ListingTableFilterComposer f) f,
  ) {
    final $$ListingTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.listing,
      getReferencedColumn: (t) => t.store,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListingTableFilterComposer(
            $db: $db,
            $table: $db.listing,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StoreTableOrderingComposer
    extends Composer<_$TestDatabase, $StoreTable> {
  $$StoreTableOrderingComposer({
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
}

class $$StoreTableAnnotationComposer
    extends Composer<_$TestDatabase, $StoreTable> {
  $$StoreTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  TableColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  TableColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> listings<T extends Object>(
    Expression<T> Function($$ListingTableAnnotationComposer a) f,
  ) {
    final $$ListingTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.listing,
      getReferencedColumn: (t) => t.store,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListingTableAnnotationComposer(
            $db: $db,
            $table: $db.listing,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StoreTableTableManager
    extends
        RootTableManager<
          _$TestDatabase,
          $StoreTable,
          StoreData,
          $$StoreTableFilterComposer,
          $$StoreTableOrderingComposer,
          $$StoreTableAnnotationComposer,
          $$StoreTableCreateCompanionBuilder,
          $$StoreTableUpdateCompanionBuilder,
          (StoreData, $$StoreTableReferences),
          StoreData,
          PrefetchHooks Function({bool listings})
        > {
  $$StoreTableTableManager(_$TestDatabase db, $StoreTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoreTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoreTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoreTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
              }) => StoreCompanion(id: id, name: name),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
              }) => StoreCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$StoreTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({listings = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (listings) db.listing],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (listings)
                    await $_getPrefetchedData<
                      StoreData,
                      $StoreTable,
                      ListingData
                    >(
                      currentTable: table,
                      referencedTable: $$StoreTableReferences._listingsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$StoreTableReferences(db, table, p0).listings,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.store == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StoreTableProcessedTableManager =
    ProcessedTableManager<
      _$TestDatabase,
      $StoreTable,
      StoreData,
      $$StoreTableFilterComposer,
      $$StoreTableOrderingComposer,
      $$StoreTableAnnotationComposer,
      $$StoreTableCreateCompanionBuilder,
      $$StoreTableUpdateCompanionBuilder,
      (StoreData, $$StoreTableReferences),
      StoreData,
      PrefetchHooks Function({bool listings})
    >;
typedef $$ListingTableCreateCompanionBuilder =
    ListingCompanion Function({
      Value<int> id,
      required String product,
      Value<int?> store,
      Value<double?> price,
    });
typedef $$ListingTableUpdateCompanionBuilder =
    ListingCompanion Function({
      Value<int> id,
      Value<String> product,
      Value<int?> store,
      Value<double?> price,
    });

final class $$ListingTableReferences
    extends BaseReferences<_$TestDatabase, $ListingTable, ListingData> {
  $$ListingTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductTable _productTable(_$TestDatabase db) =>
      db.product.withAlias('listing__product__product__sku');

  $$ProductTableProcessedTableManager get product {
    final $_column = $_itemColumn<String>('product')!;

    final manager = $$ProductTableTableManager(
      $_db,
      $_db.product,
    ).filter((f) => f.sku.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StoreTable _storeTable(_$TestDatabase db) =>
      db.store.withAlias('listing__store__store__id');

  $$StoreTableProcessedTableManager? get store {
    final $_column = $_itemColumn<int>('store');
    if ($_column == null) return null;
    final manager = $$StoreTableTableManager(
      $_db,
      $_db.store,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_storeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ListingTableFilterComposer
    extends Composer<_$TestDatabase, $ListingTable> {
  $$ListingTableFilterComposer({
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

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductTableFilterComposer get product {
    final $$ProductTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.product,
      referencedTable: $db.product,
      getReferencedColumn: (t) => t.sku,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductTableFilterComposer(
            $db: $db,
            $table: $db.product,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StoreTableFilterComposer get store {
    final $$StoreTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.store,
      referencedTable: $db.store,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoreTableFilterComposer(
            $db: $db,
            $table: $db.store,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ListingTableOrderingComposer
    extends Composer<_$TestDatabase, $ListingTable> {
  $$ListingTableOrderingComposer({
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

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductTableOrderingComposer get product {
    final $$ProductTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.product,
      referencedTable: $db.product,
      getReferencedColumn: (t) => t.sku,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductTableOrderingComposer(
            $db: $db,
            $table: $db.product,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StoreTableOrderingComposer get store {
    final $$StoreTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.store,
      referencedTable: $db.store,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoreTableOrderingComposer(
            $db: $db,
            $table: $db.store,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ListingTableAnnotationComposer
    extends Composer<_$TestDatabase, $ListingTable> {
  $$ListingTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  TableColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  TableColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  $$ProductTableAnnotationComposer get product {
    final $$ProductTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.product,
      referencedTable: $db.product,
      getReferencedColumn: (t) => t.sku,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductTableAnnotationComposer(
            $db: $db,
            $table: $db.product,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StoreTableAnnotationComposer get store {
    final $$StoreTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.store,
      referencedTable: $db.store,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoreTableAnnotationComposer(
            $db: $db,
            $table: $db.store,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ListingTableTableManager
    extends
        RootTableManager<
          _$TestDatabase,
          $ListingTable,
          ListingData,
          $$ListingTableFilterComposer,
          $$ListingTableOrderingComposer,
          $$ListingTableAnnotationComposer,
          $$ListingTableCreateCompanionBuilder,
          $$ListingTableUpdateCompanionBuilder,
          (ListingData, $$ListingTableReferences),
          ListingData,
          PrefetchHooks Function({bool product, bool store})
        > {
  $$ListingTableTableManager(_$TestDatabase db, $ListingTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListingTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListingTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListingTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> product = const Value.absent(),
                Value<int?> store = const Value.absent(),
                Value<double?> price = const Value.absent(),
              }) => ListingCompanion(
                id: id,
                product: product,
                store: store,
                price: price,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String product,
                Value<int?> store = const Value.absent(),
                Value<double?> price = const Value.absent(),
              }) => ListingCompanion.insert(
                id: id,
                product: product,
                store: store,
                price: price,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ListingTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({product = false, store = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (product) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.product,
                                referencedTable: $$ListingTableReferences
                                    ._productTable(db),
                                referencedColumn: $$ListingTableReferences
                                    ._productTable(db)
                                    .sku,
                              )
                              as T;
                    }
                    if (store) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.store,
                                referencedTable: $$ListingTableReferences
                                    ._storeTable(db),
                                referencedColumn: $$ListingTableReferences
                                    ._storeTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ListingTableProcessedTableManager =
    ProcessedTableManager<
      _$TestDatabase,
      $ListingTable,
      ListingData,
      $$ListingTableFilterComposer,
      $$ListingTableOrderingComposer,
      $$ListingTableAnnotationComposer,
      $$ListingTableCreateCompanionBuilder,
      $$ListingTableUpdateCompanionBuilder,
      (ListingData, $$ListingTableReferences),
      ListingData,
      PrefetchHooks Function({bool product, bool store})
    >;

class $TestDatabaseManager {
  final _$TestDatabase _db;
  $TestDatabaseManager(this._db);
  $$DepartmentTableTableManager get department =>
      $$DepartmentTableTableManager(_db, _db.department);
  $$ProductTableTableManager get product =>
      $$ProductTableTableManager(_db, _db.product);
  $$StoreTableTableManager get store =>
      $$StoreTableTableManager(_db, _db.store);
  $$ListingTableTableManager get listing =>
      $$ListingTableTableManager(_db, _db.listing);
}
