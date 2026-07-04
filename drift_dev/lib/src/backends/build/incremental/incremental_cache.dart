import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

import '../../../analysis/driver/driver.dart';
import '../../../analysis/driver/state.dart';
import '../../../analysis/options.dart';
import '../../../analysis/results/results.dart';
import '../../../analysis/serializer.dart';
import 'source_hasher.dart';

/// Version stamp for the fork's incremental cache format and generation logic.
///
/// Bump this whenever the cache layout or the code generation logic changes in
/// a way that should invalidate previously written caches.
const String incrementalCacheRevision = 'drift_dev-2.34.0-fork.1';

/// A sidecar cache holding serialized analysis results per table, keyed by a
/// content hash of the table's source.
///
/// Motivation: drift's build-system cache (`.drift_module.json` files) is
/// written by the analyzer build phase, and builders cannot read outputs of
/// their own phase. As a consequence, every analyzer build step re-resolves
/// every table reachable from its input - for databases importing hundreds of
/// tables, this dominates build times. This cache lives outside the build
/// system (plain files on disk), deliberately trading build hermeticity for
/// the ability to reuse analysis results across build steps and across builds.
///
/// Safety model: entries are only ever served when the hash of the table's
/// current source (including all same-file declarations it references and the
/// library's directives) matches the hash stored alongside the entry, and the
/// whole cache is discarded when the drift_dev revision, build options or SDK
/// change. A stale, deleted or foreign cache can therefore never change what
/// is generated - it only changes how much work is needed to generate it.
/// Every failure path (IO errors, malformed JSON, hash mismatches) degrades to
/// a cache miss and thus to drift's stock full resolution.
class IncrementalDriftCache {
  final Directory _root;

  /// Hash over the cache revision, build options and SDK version. Mixed into
  /// every source hash so that entries written under a different configuration
  /// never validate.
  final String contextHash;

  /// The name of the package being built; imports of this package make a
  /// library unsafe to cache (see [LibraryClassHashes.onlySafeImports]).
  final String selfPackage;

  IncrementalDriftCache._(this._root, this.contextHash, this.selfPackage);

  /// Opens the sidecar cache for [package], creating the directory if needed
  /// and discarding stale contents written under a different configuration.
  ///
  /// Returns null (disabling the cache) on any IO error.
  static IncrementalDriftCache? open(DriftOptions options, String package) {
    try {
      final root = Directory(
        options.incrementalCacheDir ??
            p.join('.dart_tool', 'drift_incremental_cache'),
      );
      final context = sha256
          .convert(
            utf8.encode(
              json.encode({
                'revision': incrementalCacheRevision,
                'sdk': Platform.version,
                'options': options.toJson(),
              }),
            ),
          )
          .toString();

      final metaFile = File(p.join(root.path, 'meta.json'));
      if (metaFile.existsSync()) {
        String? existing;
        try {
          existing =
              (json.decode(metaFile.readAsStringSync())
                      as Map<String, Object?>)['context']
                  as String?;
        } on Object {
          existing = null;
        }

        if (existing != context) {
          root.deleteSync(recursive: true);
        }
      }

      root.createSync(recursive: true);
      if (!metaFile.existsSync()) {
        _writeAtomically(metaFile, json.encode({'context': context}));
      }

      return IncrementalDriftCache._(root, context, package);
    } on Object {
      return null;
    }
  }

  String _libraryPath(Uri uri) {
    final digest = sha256.convert(utf8.encode(uri.toString())).toString();
    return p.join(_root.path, 'lib_$digest.json');
  }

  /// Synthesizes the contents of a `.drift_module.json` for [uri] from cached
  /// entries whose source hashes still match the current source of the
  /// library, or returns null when nothing can be served.
  ///
  /// The returned string has the same shape as the module files written by the
  /// analyzer builder (`{'imports': [...], 'elements': {name: data}}`), except
  /// that elements whose sources changed are simply absent - readers fall back
  /// to full resolution for those.
  Future<String?> validatedModuleJsonFor(
    Uri uri,
    Future<String?> Function() readSource,
  ) async {
    try {
      final file = File(_libraryPath(uri));
      if (!file.existsSync()) return null;

      final record =
          json.decode(await file.readAsString()) as Map<String, Object?>;
      final source = await readSource();
      if (source == null) return null;

      final hashes = hashLibraryClasses(
        source: source,
        selfPackage: selfPackage,
        context: contextHash,
      );
      if (hashes == null || !hashes.onlySafeImports) return null;

      final stored = (record['elements'] as Map).cast<String, Object?>();
      final validated = <String, Object?>{};

      stored.forEach((elementName, rawEntry) {
        final entry = (rawEntry as Map).cast<String, Object?>();
        final dartName = entry['dart_name'] as String?;
        final expectedHash = entry['source_hash'] as String?;

        if (dartName != null &&
            expectedHash != null &&
            hashes.classHashes[dartName] == expectedHash) {
          validated[elementName] = entry['data'];
        }
      });

      if (validated.isEmpty) return null;

      return json.encode({
        'imports': record['imports'] ?? const <String>[],
        'elements': validated,
      });
    } on Object {
      return null;
    }
  }

  /// Stores serialized analysis results for the tables defined in [state],
  /// replacing any previous record for the library (which also prunes entries
  /// for deleted or renamed tables).
  ///
  /// Only plain tables whose serialized form is self-contained (no references
  /// to resolved Dart types, as used by type converters or custom row classes)
  /// are stored; everything else is re-resolved on every build as usual.
  Future<void> storeLibrary(FileState state, {required String source}) async {
    try {
      final file = File(_libraryPath(state.ownUri));

      final hashes = hashLibraryClasses(
        source: source,
        selfPackage: selfPackage,
        context: contextHash,
      );
      if (hashes == null || !hashes.onlySafeImports) {
        // The library can't be cached; drop any stale record.
        if (file.existsSync()) file.deleteSync();
        return;
      }

      final dartNames = <DriftElementId, String>{
        for (final element in state.definedElements)
          if (element.dartElementName != null)
            element.ownId: element.dartElementName!,
      };

      final elements = <String, Object?>{};
      for (final analysis in state.analysis.values) {
        final result = analysis.result;
        if (result is! DriftTable) continue;
        if (analysis.errorsDuringAnalysis.isNotEmpty) continue;

        final dartName = dartNames[result.id];
        final hash = dartName == null ? null : hashes.classHashes[dartName];
        if (hash == null) continue;

        final serialized = ElementSerializer.serialize([result]);
        if (serialized.dartTypes.isNotEmpty) {
          // The serialized form references Dart types through a per-file
          // helper library and is not self-contained; don't cache it.
          continue;
        }

        final data =
            (serialized.serializedData['elements'] as Map)[result.id.name];
        if (data == null) continue;

        elements[result.id.name] = {
          'dart_name': dartName,
          'source_hash': hash,
          'data': data,
        };
      }

      if (elements.isEmpty) {
        if (file.existsSync()) file.deleteSync();
        return;
      }

      _writeAtomically(
        file,
        json.encode({
          'uri': state.ownUri.toString(),
          'imports': [
            for (final import in state.imports ?? const <DriftImport>[])
              import.uri.toString(),
          ],
          'elements': elements,
        }),
      );
    } on Object {
      // Failing to update the cache must never fail the build.
    }
  }

  static void _writeAtomically(File file, String contents) {
    final temp = File('${file.path}.tmp${pid.toRadixString(16)}');
    temp.writeAsStringSync(contents);
    temp.renameSync(file.path);
  }
}

/// An [AnalysisResultCacheReader] that first consults the build system (like
/// drift's stock [AnalysisResultCacheReader] implementations do) and falls
/// back to the [IncrementalDriftCache] when the build system cannot provide
/// analysis results - typically because they would be produced by the same
/// build phase that is asking for them.
class IncrementalCacheReader implements AnalysisResultCacheReader {
  final AnalysisResultCacheReader _inner;
  final IncrementalDriftCache _cache;
  final BuildStep _buildStep;

  IncrementalCacheReader(this._inner, this._cache, this._buildStep);

  @override
  bool get findsLocalElementsReliably => _inner.findsLocalElementsReliably;

  @override
  bool get findsResolvedElementsReliably => _inner.findsResolvedElementsReliably;

  @override
  Future<CachedDiscoveryResults?> readDiscovery(Uri uri) =>
      _inner.readDiscovery(uri);

  @override
  Future<LibraryElement?> readTypeHelperFor(Uri uri) =>
      _inner.readTypeHelperFor(uri);

  @override
  Future<String?> readElementCacheFor(Uri uri) async {
    final fromBuild = await _inner.readElementCacheFor(uri);
    if (fromBuild != null) return fromBuild;

    return _cache.validatedModuleJsonFor(uri, () => _readSource(uri));
  }

  /// Reads the current source of [uri] through the build step, which also
  /// registers it as an input: when the file changes, the build step serving
  /// cached elements for it correctly re-runs.
  Future<String?> _readSource(Uri uri) async {
    if (!uri.path.endsWith('.dart')) return null;

    try {
      final assetId = AssetId.resolve(uri);
      if (assetId.package != _buildStep.inputId.package) return null;

      if (await _buildStep.canRead(assetId)) {
        return await _buildStep.readAsString(assetId);
      }
    } on Object {
      return null;
    }

    return null;
  }
}
