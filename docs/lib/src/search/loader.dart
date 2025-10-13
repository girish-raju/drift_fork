import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:jaspr/jaspr.dart';

import 'web_cache_loader.dart';

abstract interface class SearchIndexLoader {
  factory SearchIndexLoader.http(Uri metaUri) {
    final loader = HttpSearchIndexLoader(metaUri);

    if (kIsWeb) {
      return CachedIndexLoader(loader);
    } else {
      return loader;
    }
  }

  /// Resolves meta information (size and hash) of the search database.
  Future<SearchDatabaseInfo> fetchMeta();

  /// Fetches a database page based on its index.
  ///
  /// Returns whether range requests are supported and contents. If range
  /// requests are not supported, the response is for the entire database.
  Future<(bool, Uint8List)> fetchPage(SearchDatabaseInfo info, int pageNo);

  void close();

  static const pageSize = 4096;
}

typedef SearchDatabaseInfo = ({String hash, int blocks});

/// A [SearchIndexLoader] implemented by one HTTP request per page.
final class HttpSearchIndexLoader implements SearchIndexLoader {
  final Client _client = Client();
  final Uri metaUri;

  HttpSearchIndexLoader(this.metaUri);

  @override
  Future<SearchDatabaseInfo> fetchMeta() async {
    final response = await _client.get(metaUri);
    if (response.statusCode != 200) {
      throw ClientException('Unexpected result code ${response.statusCode}');
    }

    final parsed = json.decode(response.body);
    return (hash: parsed['hash'] as String, blocks: parsed['blocks'] as int);
  }

  @override
  Future<(bool, Uint8List)> fetchPage(
    SearchDatabaseInfo info,
    int pageNo,
  ) async {
    final startOffset = pageNo * SearchIndexLoader.pageSize;
    final endOffset = (pageNo + 1) * SearchIndexLoader.pageSize - 1;
    final response = await _client.get(
      metaUri.resolve('./${info.hash}.db'),
      headers: {'Range': 'bytes=$startOffset-$endOffset'},
    );

    return switch (response.statusCode) {
      200 => (false, response.bodyBytes),
      206 => (true, response.bodyBytes),
      final status => throw ClientException('Unexpected result code $status'),
    };
  }

  @override
  void close() {
    _client.close();
  }
}
