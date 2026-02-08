import 'dart:async';

import 'package:drift3/src/connection/streams/store.dart';
import 'package:drift3/src/connection/streams/update_rules.dart';

final class TestStreamQueryStore extends StreamQueryStore {
  final Set<TableUpdate> recordedUpdates = {};
  final StreamController<Set<TableUpdate>> _updates = StreamController(
    sync: true,
  );

  @override
  void handleTableUpdates(Set<TableUpdate> updates) {
    recordedUpdates.addAll(updates);
    _updates.add(updates);
  }

  @override
  Stream<Set<TableUpdate>> updatesForSync(TableUpdateQuery query) {
    return _updates.stream.where((update) => update.any(query.matches));
  }
}
