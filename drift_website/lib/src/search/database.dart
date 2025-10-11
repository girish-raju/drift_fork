import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:sqlite3/common.dart';

import 'loader.dart';

final class SearchDatabase {
  final CommonDatabase _db;
  final HttpFileSystem _vfs;

  SearchDatabase._(this._db, this._vfs);

  static Future<SearchDatabase> open(
    CommonSqlite3 sqlite3,
    Uri databaseUri,
  ) async {
    final vfs = HttpFileSystem(name: 'http', uri: databaseUri);
    sqlite3.registerVirtualFileSystem(vfs);

    final db = await vfs.asyncify(() {
      return sqlite3.open('/database', vfs: 'http', mode: OpenMode.readOnly);
    });

    return SearchDatabase._(db, vfs);
  }

  Future<T> _useDb<T>(T Function() inner) async {
    return _vfs.asyncify(inner);
  }

  Stream<SearchResult> search(String term) async* {
    final stmt = await _useDb(
      () => _db.prepare(
        'SELECT title, path, snippet(content, 1, ?2, ?3, ?4, 10) FROM content(?1) ORDER BY rank',
      ),
    );

    var cursor = await _useDb(
      () => stmt.selectCursor([
        term,
        SearchResult.startMarker,
        SearchResult.endMarker,
        '',
      ]),
    );

    try {
      // The SQLITE_BUSY hack seems to cause duplicate rows to get reported,
      // which we simply filter out. This kind of corruption definitely isn't
      // concerning at all.
      final knownPaths = <String>{};

      while (await _useDb(cursor.moveNext)) {
        final path = cursor.current.columnAt(1) as String;
        if (!knownPaths.add(path)) {
          continue;
        }

        final title = cursor.current.columnAt(0) as String;
        final snippet = cursor.current.columnAt(2) as String;

        yield SearchResult(path, title, snippet);
      }
    } finally {
      stmt.dispose();
    }
  }

  void close() {
    _db.dispose();
    _vfs._cache.loader.close();
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
    : _cache = _BlockCache(HttpSearchIndexLoader(uri));

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
    if (_vfs._cache._info case final info?) {
      return info.blocks * SearchIndexLoader.pageSize;
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
  final SearchIndexLoader loader;

  SearchDatabaseInfo? _info;
  List<Uint8List?>? _cachedPages;

  _BlockCache(this.loader);

  Future<void> resolveTotalSize() async {
    final meta = _info = await loader.fetchMeta();
    _cachedPages = List.filled(meta.blocks, null);
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
        return loader.fetchPage(_info!, i).then((bytes) {
          _cachedPages![i] = bytes;
        });
      }
    }

    return null;
  }

  int _pageIndex(int offset) {
    return offset ~/ _pageSize;
  }

  static const _pageSize = SearchIndexLoader.pageSize;
}
