import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';

class SyntaxParser {
  final String rule;
  List<Token> _tokens = [];
  int _pos = 0;

  SyntaxParser(this.rule) {
    const lexer = Lexer();
    _tokens = lexer.tokenize(rule);
    _tokens.add(Token(TokenType.stringLiteral, '__EOF__'));
  }

  SyntaxExpression parseSyntaxTree() {
    final expression = _parseExpression();
    return expression;
  }

  SyntaxExpression _parseExpression([int minPrecedence = 0]) {
    var left = _parsePrimary();

    while (true) {
      final token = _peek();

      if (token.type != TokenType.operator) break;

      final operator = SyntaxOperator.fromSymbol(token.lexeme);

      if (operator.precedence < minPrecedence) break;

      if (operator is DotOperator) {
        left = _parseMemberExpression(left);
        continue;
      }

      if (operator is ConditionOperator) {
        left = _parseTernaryExpression(left, operator);
        continue;
      }

      if (operator is BinaryOperator) {
        left = _parseBinaryExpression(left, operator);
        continue;
      }

      break;
    }

    return left;
  }

  SyntaxExpression _parsePrimary() {
    final token = _advance();

    switch (token.type) {
      case TokenType.nullLiteral:
      case TokenType.booleanLiteral:
      case TokenType.numeralLiteral:
      case TokenType.stringLiteral:
        return SyntaxLiteral.literalFromToken(token);

      case TokenType.identifier:
        {
          final activeToken = _peek();
          switch (activeToken.type) {
            case TokenType.openingParenthesis:
              return _parseFunctionExpression(token);
            case TokenType.operator:
              {
                final operator = SyntaxOperator.fromSymbol(activeToken.lexeme);
                return switch (operator) {
                  AssignmentOperator() => _parseAssignmentExpression(token),
                  (_) => _parseVariableExpression(token),
                };
              }
            default:
              return _parseVariableExpression(token);
          }
        }

      case TokenType.operator:
        final operator = UnaryOperator.fromSymbol(token.lexeme);

        final operand = _parseExpression(operator.precedence);
        return UnaryExpression(operator: operator, operand: operand);

      case TokenType.openingParenthesis:
        final expr = _parseExpression();
        _consume(TokenType.closingParenthesis);
        return expr;

      default:
        throw Exception('Unexpected token: $token');
    }
  }

  BinaryExpression _parseBinaryExpression(SyntaxExpression left, BinaryOperator operator) {
    _advance();

    final nextMinPrecedence = operator.associativity == Associativity.left
        ? operator.precedence + 1
        : operator.precedence;

    final right = _parseExpression(nextMinPrecedence);

    return BinaryExpression(operator: operator, leftOperand: left, rightOperand: right);
  }

  TernaryExpression _parseTernaryExpression(SyntaxExpression left, SyntaxOperator operator) {
    _consume(TokenType.operator);
    final leftOperand = _parseExpression();

    _consume(TokenType.operator);
    final rightOperand = _parseExpression(operator.precedence);

    return TernaryExpression(condition: left, trueCase: leftOperand, falseCase: rightOperand);
  }

  FunctionExpression _parseFunctionExpression(Token identifierToken) {
    _consume(TokenType.openingParenthesis);

    final params = <SyntaxExpression>[];

    if (!_check(TokenType.closingParenthesis)) {
      do {
        params.add(_parseExpression());
      } while (_match(TokenType.comma));
    }

    _consume(TokenType.closingParenthesis);

    return FunctionExpression(identifier: identifierToken.lexeme, parameter: params);
  }

  AssignmentExpression _parseAssignmentExpression(Token token) {
    final identifier = token.lexeme;
    _consume(TokenType.operator);
    final expression = _parseExpression();

    return AssignmentExpression(identifier: identifier, expression: expression);
  }

  MemberExpression _parseMemberExpression(SyntaxExpression left) {
    if (!_match(TokenType.operator)) {
      throw Exception('Expected dot operator at this point. Got: ${_peek().type}');
    }
    if (!_check(TokenType.identifier)) {
      throw Exception('Dot operator expects a name on the right. Got: ${_peek().type}');
    }

    final token = _advance();
    final property = SyntaxLiteral.literalFromToken(token, identifierAsString: true);

    return MemberExpression(obj: left, property: property);
  }

  VariableExpression _parseVariableExpression(Token token) => VariableExpression(identifier: token.lexeme);

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
      throw Exception("Expected $type but found ${_peek().type} (${_peek().lexeme})");
    }
    _advance();
  }

  Token _peek() => _tokens[_pos];

  Token _advance() {
    if (_pos >= _tokens.length) {
      throw Exception("Unexpected end of input");
    }
    return _tokens[_pos++];
  }
}
