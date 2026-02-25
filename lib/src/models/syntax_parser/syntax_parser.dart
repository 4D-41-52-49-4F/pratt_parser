import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/_expression/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/_operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/tokenizer.dart';

class SyntaxParser {
  final List<Token> tokens;
  int pos = 0;

  SyntaxParser(List<Token> tokens) : tokens = [...tokens, Token(TokenType.string, '__EOF__')];

  // ============================================================
  // ENTRY
  // ============================================================

  SyntaxExpression parseSyntaxTree() {
    final expression = _parseExpression();
    return expression;
  }

  // ============================================================
  // EXPRESSION (Precedence Climbing)
  // ============================================================

  SyntaxExpression _parseExpression([int minPrecedence = 0]) {
    var left = _parsePrimary();

    while (true) {
      final token = _peek();

      if (token.type != TokenType.operator) break;

      final operator = SyntaxOperator.fromSymbol(token.value);

      if (operator is! BinaryOperator) break;
      if (operator.precedence < minPrecedence) break;

      _advance(); // consume operator

      final nextMinPrecedence = operator.associativity == Associativity.left
          ? operator.precedence + 1
          : operator.precedence;

      final right = _parseExpression(nextMinPrecedence);

      left = BinaryExpression(operator: operator, leftOperand: left, rightOperand: right);
    }

    return left;
  }

  // ============================================================
  // PRIMARY
  // ============================================================

  SyntaxExpression _parsePrimary() {
    final token = _advance();

    switch (token.type) {
      case TokenType.number:
      case TokenType.string:
        return SyntaxExpression.fromToken(token);

      case TokenType.functionIdentifier:
        return _parseFunction(token);

      case TokenType.operator:
        final operator = SyntaxOperator.fromSymbol(token.value);

        if (operator is UnaryOperator) {
          final operand = _parseExpression(operator.precedence);
          return UnaryExpression(operator: operator, operand: operand);
        }

        throw Exception("Unexpected binary operator: ${token.value}");

      case TokenType.openingParenthesis:
        final expr = _parseExpression();
        _consume(TokenType.closingParenthesis);
        return expr;

      default:
        throw Exception("Unexpected token: $token");
    }
  }

  // ============================================================
  // FUNCTION
  // ============================================================

  FunctionExpression _parseFunction(Token identifierToken) {
    _consume(TokenType.openingParenthesis);

    final params = <SyntaxExpression>[];

    if (!_check(TokenType.closingParenthesis)) {
      do {
        params.add(_parseExpression());
      } while (_match(TokenType.functionParameterSeperator));
    }

    _consume(TokenType.closingParenthesis);

    return FunctionExpression(identifier: identifierToken.value, parameter: params);
  }

  bool _check(TokenType type) {
    return _peek().type == type;
  }

  bool _match(TokenType type) {
    if (_check(type)) {
      _advance();
      return true;
    }
    return false;
  }

  void _consume(TokenType type) {
    if (!_check(type)) {
      throw Exception("Expected $type but found ${_peek().type} (${_peek().value})");
    }
    _advance();
  }

  Token _peek() => tokens[pos];

  Token _advance() {
    if (pos >= tokens.length) {
      throw Exception("Unexpected end of input");
    }
    return tokens[pos++];
  }
}
