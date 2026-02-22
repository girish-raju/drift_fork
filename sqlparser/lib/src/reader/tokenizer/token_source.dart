import 'package:meta/meta.dart';

import 'token.dart';

@internal
abstract base class TokenSource {
  Token? _lastConsumedToken;

  // Up to two tokens of lookahead in used by the parser.
  Token? _pendingLookahead0;
  Token? _pendingLookahead1;

  Token? get previous => _lastConsumedToken;

  TokenSource();

  factory TokenSource.fromIterator(Iterator<Token> tokens) {
    return _IteratorTokenSource(tokens);
  }

  Token lookahead1() {
    if (_pendingLookahead0 case final token?) {
      return token;
    } else {
      return _pendingLookahead0 = readToken();
    }
  }

  (Token, Token?) lookahead2() {
    final peek = lookahead1();
    if (peek.type == TokenType.eof) {
      return (peek, null);
    }

    final next = switch (_pendingLookahead1) {
      null => _pendingLookahead1 = readToken(),
      final pending => pending,
    };
    return (peek, next);
  }

  Token consume() {
    if (_pendingLookahead0 case final token?) {
      _pendingLookahead0 = _pendingLookahead1;
      _pendingLookahead1 = null;
      return _lastConsumedToken = token;
    } else {
      // We should have rolled this into pendingLookahead0 when consuming.
      assert(_pendingLookahead1 == null);
      return _lastConsumedToken = readToken();
    }
  }

  @protected
  Token readToken();
}

final class _IteratorTokenSource extends TokenSource {
  final Iterator<Token> _tokens;

  _IteratorTokenSource(this._tokens);

  @override
  Token readToken() {
    while (true) {
      if (!_tokens.moveNext()) {
        throw StateError('Called readTokens past eof');
      }

      final token = _tokens.current;
      if (token.invisibleToParser) {
        continue;
      }

      return token;
    }
  }
}
