import 'package:drift3/drift.dart';
import 'package:test/test.dart';

import '../../generated/converter.dart';
import '../../test_utils.dart';

void main() {
  const converter = NullAwareTypeConverter.wrap(SyncTypeConverter());
  final column = TableColumn(
    name: 'sync_state',
    sqlType: BuiltinDriftType.int,
  ).withConverter(converter);

  test('isInValues', () async {
    expect(
      column.isInValues([SyncType.synchronized, SyncType.locallyCreated]),
      generates('"sync_state" IN (?1, ?2) AND "sync_state" IS NOT NULL', [
        converter.toSql(SyncType.synchronized),
        converter.toSql(SyncType.locallyCreated),
      ]),
    );
    expect(
      column.isInValues([SyncType.synchronized, SyncType.locallyCreated, null]),
      generates('"sync_state" IN (?1, ?2) OR "sync_state" IS NULL', [
        converter.toSql(SyncType.synchronized),
        converter.toSql(SyncType.locallyCreated),
      ]),
    );
  });

  test('isNotInValues', () async {
    expect(
      column.isNotInValues([SyncType.synchronized, SyncType.locallyCreated]),
      generates('"sync_state" IN (?1, ?2) OR "sync_state" IS NULL', [
        converter.toSql(SyncType.synchronized),
        converter.toSql(SyncType.locallyCreated),
      ]),
    );
    expect(
      column.isNotInValues([
        SyncType.synchronized,
        SyncType.locallyCreated,
        null,
      ]),
      generates('"sync_state" NOT IN (?1, ?2) AND "sync_state" IS NOT NULL', [
        converter.toSql(SyncType.synchronized),
        converter.toSql(SyncType.locallyCreated),
      ]),
    );
  });
}
