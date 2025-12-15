import 'package:source_span/source_span.dart';
import 'package:sqlparser/sqlparser.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('BEGIN', () {
    test('without mode', () {
      testStatement('BEGIN;', BeginTransactionStatement());
      testStatement('BEGIN TRANSACTION;', BeginTransactionStatement());
    });

    test('deferred', () {
      testStatement('BEGIN DEFERRED;',
          BeginTransactionStatement(TransactionMode.deferred));
    });

    test('immediate', () {
      testStatement('BEGIN IMMEDIATE;',
          BeginTransactionStatement(TransactionMode.immediate));
    });

    test('exclusive', () {
      testStatement('BEGIN EXCLUSIVE TRANSACTION;',
          BeginTransactionStatement(TransactionMode.exclusive));
    });
  });

  test('COMMIT', () {
    testStatement('COMMIT', CommitStatement());
    testStatement('END', CommitStatement());
    testStatement('COMMIT TRANSACTION', CommitStatement());
    testStatement('END TRANSACTION', CommitStatement());
  });

  test('can parse substring', () {
    final engine = SqlEngine();
    final source = SourceFile.fromString('PREFIXSELECT * FROM fooSUFFIX');
    final parsed = engine.parseSpan(source.span(6, 23));
    expect(parsed.errors, isEmpty);
    expect(parsed.sql.text, 'SELECT * FROM foo');
    expect(parsed.rootNode.span!.text, 'SELECT * FROM foo');
  });
}
