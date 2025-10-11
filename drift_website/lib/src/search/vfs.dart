import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:sqlite3/common.dart';

final class AsyncVfsDatabase {
  final CommonDatabase _db;
  final HttpFileSystem _vfs;

  AsyncVfsDatabase._(this._db, this._vfs);

  static Future<AsyncVfsDatabase> open(
    CommonSqlite3 sqlite3,
    Uri databaseUri,
  ) async {
    final vfs = HttpFileSystem(name: 'http', uri: databaseUri);
    sqlite3.registerVirtualFileSystem(vfs);

    final db = await vfs.asyncify(() {
      return sqlite3.open('/database', vfs: 'http', mode: OpenMode.readOnly);
    });

    return AsyncVfsDatabase._(db, vfs);
  }

  Future<T> _useDb<T>(T Function() inner) async {
    return _vfs.asyncify(inner);
  }

  Stream<SearchResult> search(String term) async* {
    final stmt = await _useDb(
      () => _db.prepare(
        'SELECT title, path, snippet(content, 1, ?2, ?3, ?4, 5) FROM content(?1) ORDER BY rank',
      ),
    );
    final cursor = await _useDb(
      () => stmt.selectCursor([
        term,
        SearchResult.startMarker,
        SearchResult.endMarker,
        '',
      ]),
    );

    try {
      while (await _useDb(cursor.moveNext)) {
        final title = cursor.current.columnAt(0) as String;
        final path = cursor.current.columnAt(1) as String;
        final snippet = cursor.current.columnAt(2) as String;

        yield SearchResult(path, title, snippet);
      }
    } finally {
      stmt.dispose();
    }
  }

  void close() {
    _db.dispose();
    _vfs._cache._client.close();
  }
}

final class SearchResult {
  final String path;
  final String title;
  final String highlight;

  SearchResult(this.path, this.title, this.highlight);

  static const startMarker = 'SNIPSTART';
  static const endMarker = 'SNIPEND';
}

final class HttpFileSystem extends BaseVirtualFileSystem {
  final _BlockCache _cache;
  Future<void>? _waitingFor;

  HttpFileSystem({required super.name, required Uri uri})
    : _cache = _BlockCache(Client(), uri);

  @override
  int xAccess(String path, int flags) {
    return path == '/database' ? 1 : 0;
  }

  @override
  void xDelete(String path, int syncDir) {
    throw VfsException(21);
  }

  @override
  String xFullPathName(String path) {
    return path;
  }

  @override
  XOpenResult xOpen(Sqlite3Filename path, int flags) {
    return (outFlags: 0, file: _HttpFile(this));
  }

  @override
  void xSleep(Duration duration) {}

  /// "Synchronously" runs a potentially asynchronous operation.
  ///
  /// This implements a clever trick taken from Roy Hashimoto's work on
  /// wa-sqlite: We're not asyncifyng SQLite itself, but we can rely on the fact
  /// that SQLite statements are, essentially, coroutines that advance by
  /// calling `sqlite3_step`. In a sense, SQLite is asynchronous already!
  ///
  /// So here, when we need to do something asynchronous like fetching blocks
  /// for the search index from the remote server, we:
  ///
  ///   1. Return `SQLITE_BUSY` from the VFS layer.
  ///   2. SQLite will forward that error to the `sqlite3_step()` invocation.
  ///   3. We catch the error and await [_waitingFor], a future that
  ///      completes with the asynchronous operation.
  ///   4. After the future has completed, we try again.
  Never blockOn(Future<void> pendingWork) {
    assert(_waitingFor == null);
    _waitingFor = pendingWork;
    _busy();
  }

  /// The other, higher-level part of the [syncify] stack.
  ///
  /// This tries running a database operation and retries if it fails because
  /// the VFS would like to run an asynchronous operation.
  Future<T> asyncify<T>(T Function() operation) async {
    while (true) {
      try {
        return operation();
      } on SqliteException catch (e) {
        if (e.resultCode == 5 && _waitingFor != null) {
          await _waitingFor;
          _waitingFor = null;
          continue;
        }

        rethrow;
      }
    }
  }

  static Never _busy() {
    throw VfsException(5); // SQLITE_BUSY
  }
}

final class _HttpFile extends BaseVfsFile {
  final HttpFileSystem _vfs;

  _HttpFile(this._vfs);

  @override
  int readInto(Uint8List buffer, int offset) {
    try {
      return _tryReadInto(buffer, offset);
    } on VfsException {
      rethrow;
    } on Object catch (e, s) {
      Zone.current.handleUncaughtError(e, s);
      rethrow;
    }
  }

  int _tryReadInto(Uint8List buffer, int offset) {
    final resolvedSize = xFileSize();
    final end = min(resolvedSize, offset + buffer.length);
    var remainingBytes = end - offset;
    if (_vfs._cache.ensureHasRange(offset, remainingBytes) case Future f) {
      return _vfs.blockOn(f);
    }

    var bytesRead = 0;
    while (remainingBytes > 0) {
      final page = (offset + bytesRead) ~/ _BlockCache._pageSize;
      final offsetInPage = (offset + bytesRead) % _BlockCache._pageSize;
      final bytesToReadFromPage = min(
        _BlockCache._pageSize - offsetInPage,
        remainingBytes,
      );

      buffer.setRange(
        bytesRead,
        bytesRead + bytesToReadFromPage,
        _vfs._cache._cachedPages![page]!,
        offsetInPage,
      );
      remainingBytes -= bytesToReadFromPage;
      bytesRead += bytesToReadFromPage;
    }

    return bytesRead;
  }

  @override
  int xCheckReservedLock() {
    return 0;
  }

  @override
  void xClose() {}

  @override
  int xFileSize() {
    if (_vfs._cache.totalSize case final knownSize?) {
      return knownSize;
    }

    _vfs.blockOn(_vfs._cache.resolveTotalSize());
  }

  @override
  void xLock(int mode) {}

  @override
  void xSync(int flags) {
    _unsupportedReadonly();
  }

  @override
  void xTruncate(int size) {
    _unsupportedReadonly();
  }

  @override
  void xUnlock(int mode) {}

  @override
  void xWrite(Uint8List buffer, int fileOffset) {
    _unsupportedReadonly();
  }
}

Never _unsupportedReadonly() {
  throw VfsException(8); // SQLITE_READONLY
}

final class _BlockCache {
  final Client _client;
  final Uri uri;

  int? totalSize;
  List<Uint8List?>? _cachedPages;

  _BlockCache(this._client, this.uri);

  Future<void> resolveTotalSize() {
    return Future(() async {
      final response = await _client.head(uri);
      if (response.statusCode != 200) {
        throw ClientException('Unexpected result code ${response.statusCode}');
      }

      final length = response.headers['content-length'];
      if (length == null) {
        throw ClientException('Missing content-length header');
      }

      final size = int.parse(length);
      _cachedPages = List.filled((size + _pageSize - 1) ~/ _pageSize, null);
      totalSize = size;
    });
  }

  /// Ensures that the range from `offset` until `offset + length` (exclusive)
  /// is cached.
  FutureOr<void> ensureHasRange(int offset, int length) {
    var page = _pageIndex(offset);
    var endPageInclusive = _pageIndex(offset + length - 1);

    for (var i = page; i <= endPageInclusive; i++) {
      if (_cachedPages![page] == null) {
        // We could fetch multiple pages concurrently, but most of the time
        // SQLite will only read a single page at the time anyway.
        return _fetchPage(i);
      }
    }

    return null;
  }

  Future<void> _fetchPage(int index) async {
    final startOffset = index * _pageSize;
    final endOffset = (index + 1) * _pageSize - 1;
    final response = await _client.get(
      uri,
      headers: {'Range': 'bytes=$startOffset-$endOffset'},
    );

    if (response.statusCode != 206) {
      throw ClientException('Unexpected result code ${response.statusCode}');
    }

    _cachedPages![index] = response.bodyBytes;
  }

  int _pageIndex(int offset) {
    return offset ~/ _pageSize;
  }

  static const _pageSize = 4096;
}
