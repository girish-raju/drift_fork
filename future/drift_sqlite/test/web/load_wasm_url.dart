import 'package:test/test.dart';

Future<Uri> loadWasmUrl() async {
  final channel = spawnHybridUri('/test/web/sqlite_server.dart');
  final port = (await channel.stream.first as num).toInt();

  return Uri.parse('http://localhost:$port/sqlite3.wasm');
}
