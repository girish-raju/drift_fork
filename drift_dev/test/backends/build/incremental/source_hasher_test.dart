import 'package:drift_dev/src/backends/build/incremental/source_hasher.dart';
import 'package:test/test.dart';

const _source = '''
import 'package:drift/drift.dart';

const defaultLength = 32;

class Users extends Table {
  TextColumn get id => text().withLength(max: defaultLength)();
  TextColumn get name => text()();
}

class Groups extends Table {
  TextColumn get id => text()();
  TextColumn get owner => text().references(Users, #id)();
}

class Unrelated extends Table {
  IntColumn get value => integer()();
}
''';

LibraryClassHashes hash(String source, {String context = 'ctx'}) {
  return hashLibraryClasses(
    source: source,
    selfPackage: 'app',
    context: context,
  )!;
}

void main() {
  test('is deterministic', () {
    expect(hash(_source).classHashes, hash(_source).classHashes);
  });

  test('hashes every top-level class', () {
    expect(
      hash(_source).classHashes.keys,
      containsAll(['Users', 'Groups', 'Unrelated']),
    );
  });

  test('changing one class only changes its own hash', () {
    final before = hash(_source).classHashes;
    final after = hash(
      _source.replaceFirst('IntColumn get value', 'IntColumn get amount'),
    ).classHashes;

    expect(after['Users'], before['Users']);
    expect(after['Groups'], before['Groups']);
    expect(after['Unrelated'], isNot(before['Unrelated']));
  });

  test('references between classes are part of the hash', () {
    // Groups mentions Users, so a change to Users also invalidates Groups.
    final before = hash(_source).classHashes;
    final after = hash(
      _source.replaceFirst('TextColumn get name', 'TextColumn get fullName'),
    ).classHashes;

    expect(after['Users'], isNot(before['Users']));
    expect(after['Groups'], isNot(before['Groups']));
    expect(after['Unrelated'], before['Unrelated']);
  });

  test('referenced top-level variables are part of the hash', () {
    final before = hash(_source).classHashes;
    final after = hash(
      _source.replaceFirst('defaultLength = 32', 'defaultLength = 64'),
    ).classHashes;

    expect(after['Users'], isNot(before['Users']));
    expect(after['Unrelated'], before['Unrelated']);
  });

  test('changing the directives changes all hashes', () {
    final before = hash(_source).classHashes;
    final after = hash(
      _source.replaceFirst(
        "import 'package:drift/drift.dart';",
        "import 'package:drift/drift.dart' as drift;",
      ),
    ).classHashes;

    for (final entry in after.entries) {
      expect(entry.value, isNot(before[entry.key]));
    }
  });

  test('the context is part of the hash', () {
    expect(
      hash(_source, context: 'a').classHashes['Users'],
      isNot(hash(_source, context: 'b').classHashes['Users']),
    );
  });

  test('only whitespace-relevant changes are conservative but safe', () {
    // Reformatting a class changes its source text and therefore its hash -
    // that is conservative (unnecessary regeneration) but never incorrect.
    final after = hash(
      _source.replaceFirst(
        'class Unrelated extends Table {',
        'class Unrelated  extends Table {',
      ),
    ).classHashes;

    expect(after['Users'], hash(_source).classHashes['Users']);
  });

  test('marks self-package and relative imports as unsafe', () {
    expect(hash(_source).onlySafeImports, isTrue);

    expect(
      hash("import 'package:app/tables.dart';\n$_source").onlySafeImports,
      isFalse,
    );
    expect(
      hash("import 'tables.dart';\n$_source").onlySafeImports,
      isFalse,
    );
    expect(
      hash(
        _source.replaceFirst(
          "import 'package:drift/drift.dart';",
          "import 'package:drift/drift.dart';\npart 'other.dart';",
        ),
      ).onlySafeImports,
      isFalse,
    );
  });

  test('returns null for sources with syntax errors', () {
    expect(
      hashLibraryClasses(
        source: 'class {',
        selfPackage: 'app',
        context: 'ctx',
      ),
      isNull,
    );
  });
}
