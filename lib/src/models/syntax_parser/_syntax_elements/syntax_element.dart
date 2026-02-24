import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/token.dart';

abstract class SyntaxElement {
  const SyntaxElement();

  factory SyntaxElement.fromToken(Token token) {
    SyntaxOperator? op;
    SyntaxExpression? exp;

    try {
      op = SyntaxOperator.fromSymbol(token.value);
      return op;
    } catch (e) {
      try {
        exp = SyntaxExpression.fromString(token.value);
        return exp;
      } catch (e) {
        print(e);
      }
    }

    throw Exception('No Ast_Element parsing possible from input.');
  }

  bool isOperator() => this is SyntaxOperator;
  bool isExpression() => this is SyntaxExpression;
}
