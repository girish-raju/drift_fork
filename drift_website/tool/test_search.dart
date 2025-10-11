import 'package:drift_website/src/search/database.dart';
import 'package:sqlite3/sqlite3.dart';

/// Testing the `AsyncVfsDatabase` by running a search. To test this,
///
///  1. Run `dart run tool/build_search_index.dart`.
///  2. Serve web (e.g. with `dhttpd --port 8080`).
void main(List<String> args) async {
  final db = await SearchDatabase.open(
    sqlite3,
    Uri.parse('http://localhost:8080/search.db.json'),
  );
  final term = 'test';
  args.join(' ');

  await for (final result in db.search(term).take(5)) {
    print('${result.title}: ${result.highlight}');
  }

  db.close();
}
