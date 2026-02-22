import 'dart:math';

import 'package:benchmarks/benchmarks.dart';
import 'package:source_span/source_span.dart';
import 'package:sqlparser/sqlparser.dart';
// ignore: implementation_imports
import 'package:sqlparser/src/reader/tokenizer/token.dart';

class TokenizerBenchmark extends BenchmarkBase {
  late SourceFile input;
  final engine = SqlEngine();

  static const int size = 10000;

  TokenizerBenchmark(ScoreEmitter emitter)
      : super('Tokenizing $size keywords', emitter);

  @override
  void setup() {
    final input = StringBuffer();

    final random = Random();
    final keywordLexemes = keywords.keys.toList();
    for (var i = 0; i < size; i++) {
      final keyword = keywordLexemes[random.nextInt(keywordLexemes.length)];
      input
        ..write(' ')
        ..write(keyword);
    }

    this.input = SourceFile.fromString(input.toString());
  }

  @override
  void run() {
    engine.tokenize(input.span(0));
  }
}
