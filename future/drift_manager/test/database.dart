import 'package:drift3/drift.dart';
import 'package:drift_manager/drift_manager.dart';

part 'database.g.dart';

class Department extends Table {
  IntColumn get id => integer().autoIncrement();
  TextColumn get name => text().nullable();
}

class Product extends Table {
  TextColumn get sku => text();
  TextColumn get name => text().nullable();
  IntColumn get department => integer().references(Department, #id).nullable();
}

class Listing extends Table {
  IntColumn get id => integer().autoIncrement();
  @ReferenceName('listings')
  TextColumn get product => text().references(Product, #sku);
  @ReferenceName('listings')
  IntColumn get store => integer().references(Store, #id).nullable();
  RealColumn get price => real().nullable();
}

class Store extends Table {
  IntColumn get id => integer().autoIncrement();
  TextColumn get name => text().nullable();
}

@DriftDatabase(tables: [Department, Product, Listing, Store])
final class TestDatabase extends _$TestDatabase {
  TestDatabase(super.implementation);

  @override
  int get schemaVersion => 1;
}
