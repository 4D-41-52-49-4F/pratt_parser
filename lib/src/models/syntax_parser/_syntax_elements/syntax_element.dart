import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/_expression/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/_operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/tokenizer.dart';

abstract class SyntaxElement {
  const SyntaxElement();

  factory SyntaxElement.fromToken(Token token) => switch (token.type) {
    TokenType.operator => SyntaxOperator.fromSymbol(token.value),
    TokenType.functionIdentifier => FunctionExpression(identifier: token.value, parameter: []),
    (_) => SyntaxExpression.fromToken(token),
  };

  bool isOperator() => this is SyntaxOperator;
  bool isExpression() => this is SyntaxExpression;
}
