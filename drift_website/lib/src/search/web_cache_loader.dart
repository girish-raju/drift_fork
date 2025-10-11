import 'dart:js_interop';
import 'dart:typed_data';

import 'package:universal_web/web.dart' as web;

import 'loader.dart';

/// A [SearchIndexLoader] storing partial responses in the `window.cache` API.
///
/// Because that API can't index partial responses, we use fake requests
/// containing the page id in its URL.
final class CachedIndexLoader implements SearchIndexLoader {
  final SearchIndexLoader _fallback;
  web.Cache? _cache;

  CachedIndexLoader(this._fallback);

  @override
  void close() {
    _fallback.close();
  }

  @override
  Future<SearchDatabaseInfo> fetchMeta() async {
    final meta = await _fallback.fetchMeta();
    try {
      _cache = await _openCache(meta.hash);
    } on Object catch (e) {
      print('Could not open search cache: $e');
    }

    return meta;
  }

  @override
  Future<Uint8List> fetchPage(SearchDatabaseInfo info, int pageNo) async {
    JSString? cacheKey;

    if (_cache case final cache?) {
      cacheKey = '/${info.hash}/$pageNo'.toJS;
      final cached = await cache.match(cacheKey).toDart;
      if (cached case final response?) {
        final bytes = await response.bytes().toDart;
        return bytes.toDart;
      }
    }

    final source = await _fallback.fetchPage(info, pageNo);
    if (_cache case final cache?) {
      cache.put(cacheKey!, web.Response(source.toJS));
    }
    return source;
  }

  Future<web.Cache> _openCache(String hash) async {
    const prefix = 'search-';
    final targetKey = '$prefix$hash';
    final opened = await cache.open(targetKey).toDart;

    // Delete all others.
    for (final existing in (await cache.keys().toDart).toDart) {
      final key = existing.toDart;
      if (key.startsWith('search-') && key != targetKey) {
        print('Deleting outdated search cache $key');
        await cache.delete(key).toDart;
      }
    }

    return opened;
  }
}

@JS()
external web.CacheStorage get cache;
