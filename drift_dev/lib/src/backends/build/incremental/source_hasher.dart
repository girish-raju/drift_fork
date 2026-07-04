import 'dart:convert';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:crypto/crypto.dart';

/// Hashes of the top-level class declarations in a Dart library, used as cache
/// keys by drift's incremental generation cache.
class LibraryClassHashes {
  /// Whether the library only imports `dart:` libraries or packages other than
  /// the one being built.
  ///
  /// When a library imports code from its own package (or via relative
  /// imports), a table class could depend on declarations whose changes this
  /// hasher cannot see, since it only parses a single file. In that case the
  /// incremental cache refuses to serve entries for the library.
  final bool onlySafeImports;

  /// Maps the name of each top-level class declaration to a hash covering its
  /// own source and the source of every same-file top-level declaration it
  /// (transitively) references.
  final Map<String, String> classHashes;

  LibraryClassHashes(this.onlySafeImports, this.classHashes);
}

/// Parses [source] without resolution and computes a content hash for each
/// top-level class declaration.
///
/// The hash for a class covers, in a deterministic order:
///  - the [context] string (cache revision, build options, SDK version),
///  - all directives of the library (imports could change what a symbol
///    resolves to),
///  - the source text of every same-file top-level declaration the class
///    transitively references,
///  - the source text of the class itself.
///
/// Returns null when the file cannot be parsed cleanly; callers must treat
/// that as a cache miss.
LibraryClassHashes? hashLibraryClasses({
  required String source,
  required String selfPackage,
  required String context,
}) {
  final ParseStringResult parsed;
  try {
    parsed = parseString(content: source, throwIfDiagnostics: false);
  } on Object {
    return null;
  }
  if (parsed.errors.isNotEmpty) return null;

  final unit = parsed.unit;

  var onlySafeImports = true;
  final directives = StringBuffer();
  for (final directive in unit.directives) {
    directives.writeln(directive.toSource());

    if (directive is PartOfDirective || directive is PartDirective) {
      // Code in other parts of the same library is invisible to this hasher.
      onlySafeImports = false;
    } else if (directive is UriBasedDirective) {
      final uri = directive.uri.stringValue;
      if (uri == null ||
          uri.startsWith('package:$selfPackage/') ||
          !(uri.startsWith('package:') || uri.startsWith('dart:'))) {
        onlySafeImports = false;
      }
    }
  }

  // Source text and referenced identifiers of every named top-level
  // declaration in the file.
  final topLevelSources = <String, String>{};
  final references = <String, Set<String>>{};

  for (final declaration in unit.declarations) {
    final names = <String>[];
    if (declaration is NamedCompilationUnitMember) {
      names.add(declaration.name.lexeme);
    } else if (declaration is TopLevelVariableDeclaration) {
      for (final variable in declaration.variables.variables) {
        names.add(variable.name.lexeme);
      }
    } else {
      continue;
    }

    final text = source.substring(declaration.offset, declaration.end);
    final identifiers = _identifierLexemes(declaration);

    for (final name in names) {
      topLevelSources[name] = text;
      references[name] = identifiers;
    }
  }

  final hashes = <String, String>{};
  for (final declaration in unit.declarations) {
    if (declaration is! ClassDeclaration) continue;
    final name = declaration.name.lexeme;

    // Transitive closure of same-file declarations referenced by this class.
    final closure = <String>{};
    final pending = <String>[name];
    while (pending.isNotEmpty) {
      final current = pending.removeLast();
      if (!closure.add(current)) continue;

      for (final referenced in references[current] ?? const <String>{}) {
        if (topLevelSources.containsKey(referenced)) {
          pending.add(referenced);
        }
      }
    }

    final buffer = StringBuffer(context)
      ..writeln()
      ..writeln(directives);
    for (final member in closure.toList()..sort()) {
      if (member == name) continue;
      buffer
        ..writeln(topLevelSources[member])
        ..writeln();
    }
    buffer.write(topLevelSources[name]);

    hashes[name] = sha256.convert(utf8.encode(buffer.toString())).toString();
  }

  return LibraryClassHashes(onlySafeImports, hashes);
}

/// All identifier token lexemes appearing in [node].
///
/// This deliberately works on tokens instead of resolved AST structures: it
/// over-approximates the set of referenced names (member accesses and named
/// arguments are included too), which can only make the dependency closure -
/// and therefore cache invalidation - more conservative.
Set<String> _identifierLexemes(AstNode node) {
  final seen = <String>{};
  Token? token = node.beginToken;
  final last = node.endToken;

  while (token != null) {
    if (token.type == TokenType.IDENTIFIER) {
      seen.add(token.lexeme);
    }
    if (identical(token, last)) break;
    token = token.next;
  }

  return seen;
}
