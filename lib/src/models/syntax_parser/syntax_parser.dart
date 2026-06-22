import 'package:pratt_parser/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:pratt_parser/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:pratt_parser/src/models/syntax_parser/lexer.dart';

/// A parser for building syntax trees from tokenized input.
///
/// The [SyntaxParser] takes a rule string, tokenizes it using a [Lexer],
/// and constructs a syntax tree representing the parsed expression.
class SyntaxParser {
  /// The original rule string being parsed.
  final String rule;

  /// The list of tokens produced by tokenizing the rule.
  late final List<Token> _tokens;

  /// The current position in the token list during parsing.
  int _pos = 0;

  /// Creates a new [SyntaxParser] for the given [rule] string.
  ///
  /// The constructor tokenizes the rule and appends an EOF marker token.
  SyntaxParser(this.rule) {
    const lexer = Lexer();
    _tokens = lexer.tokenize(rule);
    _tokens.add(const Token(TokenType.stringLiteral, '__EOF__'));
  }

  /// Parses the tokenized input and returns the root [SyntaxExpression] of the syntax tree.
  ///
  /// This is the main entry point for parsing, which delegates to [_parseExpression]
  /// to build the complete syntax tree.
  ///
  /// Returns the root expression node of the parsed syntax tree.
  SyntaxExpression parseSyntaxTree() {
    final expression = _parseExpression();
    if (_tokens[_pos].type != TokenType.stringLiteral || _tokens[_pos].lexeme != '__EOF__') {
      throw Exception('Unexpected tokens remaining after parsing: ${_tokens.sublist(_pos)}');
    }
    return expression;
  }

  /// Parses an expression starting at the current position.
  ///
  /// Implements the Pratt parsing algorithm for operator precedence parsing.
  /// The [minPrecedence] parameter controls the minimum precedence level required
  /// to continue parsing binary operators.
  ///
  /// Returns the parsed [SyntaxExpression] representing the expression subtree.
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

  /// Parses a primary expression (the base case for expression parsing).
  ///
  /// Handles literals (null, boolean, numeral, string), identifiers (variables,
  /// function calls, assignments), unary operators, and parenthesized expressions.
  ///
  /// Returns the parsed [SyntaxExpression] representing the primary expression.
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
                  AssignmentOperator() => _parseAssignmentExpression(token, operator),
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

  /// Parses a binary expression with the given [left] operand and [operator].
  ///
  /// The nextMinPrecedence is calculated based on the operator's associativity
  /// to ensure correct parsing order for operators with the same precedence.
  ///
  /// Returns a [BinaryExpression] containing the operator, left operand, and right operand.
  BinaryExpression _parseBinaryExpression(SyntaxExpression left, BinaryOperator operator) {
    _advance();

    final nextMinPrecedence = operator.associativity == Associativity.left
        ? operator.precedence + 1
        : operator.precedence;

    final right = _parseExpression(nextMinPrecedence);

    return BinaryExpression(operator: operator, leftOperand: left, rightOperand: right);
  }

  /// Parses a ternary (conditional) expression with the given [left] condition and [operator].
  ///
  /// Consumes the condition operator (?), parses the true case expression,
  /// consumes the else operator (:), and parses the false case expression.
  ///
  /// Returns a [TernaryExpression] containing the condition, true case, and false case.
  TernaryExpression _parseTernaryExpression(SyntaxExpression left, SyntaxOperator operator) {
    _consume(TokenType.operator);
    final leftOperand = _parseExpression();

    _consume(TokenType.operator);
    final rightOperand = _parseExpression(operator.precedence);

    return TernaryExpression(condition: left, trueCase: leftOperand, falseCase: rightOperand);
  }

  /// Parses a function expression starting with the given [identifierToken].
  ///
  /// Consumes the opening parenthesis, parses zero or more comma-separated
  /// parameter expressions, and consumes the closing parenthesis.
  ///
  /// Returns a [FunctionExpression] with the identifier and parameter list.
  FunctionExpression _parseFunctionExpression(Token identifierToken, [List<SyntaxExpression>? preparedParams]) {
    _consume(TokenType.openingParenthesis);

    final params = <SyntaxExpression>[...preparedParams ?? []];

    if (!_check(TokenType.closingParenthesis)) {
      do {
        params.add(_parseExpression());
      } while (_match(TokenType.comma));
    }

    _consume(TokenType.closingParenthesis);

    return FunctionExpression(identifier: identifierToken.lexeme, parameter: params);
  }

  /// Parses an assignment expression starting with the given [token].
  ///
  /// The token should be an identifier followed by an assignment operator (=).
  ///
  /// Returns an [AssignmentExpression] with the identifier and assigned expression.
  AssignmentExpression _parseAssignmentExpression(Token token, AssignmentOperator operator) {
    final identifier = token.lexeme;
    _consume(TokenType.operator);
    final expression = _parseExpression();

    return AssignmentExpression(identifier: identifier, expression: expression, operator: operator);
  }

  /// Parses a member expression (property access) on the given [left] object.
  ///
  /// Expects a dot operator followed by an identifier for the property name.
  ///
  /// Returns a [MemberExpression] containing the object and property.
  MemberExpression _parseMemberExpression(SyntaxExpression left) {
    if (!_match(TokenType.operator)) {
      throw Exception('Expected dot operator at this point. Got: ${_peek().type}');
    }
    if (!_check(TokenType.identifier)) {
      throw Exception('Dot operator expects a name on the right. Got: ${_peek().type}');
    }

    final token = _advance();
    late final SyntaxExpression property;
    if (_peek().type == TokenType.openingParenthesis) {
      property = _parseFunctionExpression(token, [left]);
    } else {
      property = SyntaxLiteral.literalFromToken(token, identifierAsString: true);
    }

    return MemberExpression(obj: left, property: property);
  }

  /// Parses a variable expression from the given [token].
  ///
  /// Returns a [VariableExpression] with the identifier from the token's lexeme.
  VariableExpression _parseVariableExpression(Token token) => VariableExpression(identifier: token.lexeme);

  /// Checks if the current token matches the given [type] without consuming it.
  ///
  /// Returns true if the next token is of the specified type, false otherwise.
  bool _check(TokenType type) {
    return _peek().type == type;
  }

  /// Checks if the current token matches the given [type] and consumes it if so.
  ///
  /// Returns true if the token matched and was consumed, false otherwise.
  bool _match(TokenType type) {
    if (_check(type)) {
      _advance();
      return true;
    }
    return false;
  }

  /// Consumes the current token, expecting it to be of the given [type].
  ///
  /// Throws an [Exception] if the current token does not match the expected type.
  void _consume(TokenType type) {
    if (!_check(type)) {
      throw Exception('Expected $type but found ${_peek().type} (${_peek().lexeme})');
    }
    _advance();
  }

  /// Returns the current token without advancing the position.
  ///
  /// Returns the token at the current [_pos] index.
  Token _peek() => _tokens[_pos];

  /// Advances to the next token and returns the current one.
  ///
  /// Throws an [Exception] if there are no more tokens to consume.
  ///
  /// Returns the token at the current position before incrementing [_pos].
  Token _advance() {
    if (_pos >= _tokens.length) {
      throw Exception('Unexpected end of input');
    }
    return _tokens[_pos++];
  }
}
