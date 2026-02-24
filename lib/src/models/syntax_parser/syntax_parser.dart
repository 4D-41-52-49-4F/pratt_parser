import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/syntax_element.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/syntax_operator.dart';

class SyntaxParser {
  const SyntaxParser();

  SyntaxExpression parseSyntax(List<SyntaxElement> elements) {
    if (elements.length == 1) return elements[0] as SyntaxExpression;
    final index = _findIndexOfHighestPrecedence(elements);
    print(index);
    final operator = elements[index] as SyntaxOperator;
    if (operator is BinaryOperator) {
      final expression = BinaryExpression(
        operator: operator,
        leftOperand: elements[index - 1] as SyntaxExpression,
        rightOperand: elements[index + 1] as SyntaxExpression,
      );
      elements.insert(index + 2, expression);
      elements.removeRange(index - 1, index + 2);
    }

    return parseSyntax(elements);
  }

  int _findIndexOfHighestPrecedence(List<SyntaxElement> elements) {
    var indexOfHighestPrecedence = -1;

    for (var i = 0; i < elements.length; i++) {
      if (!elements[i].isOperator()) continue;
      if (indexOfHighestPrecedence == -1) {
        indexOfHighestPrecedence = i;
        continue;
      }
      final bestOperator = elements[indexOfHighestPrecedence] as SyntaxOperator;
      final operator = elements[i] as SyntaxOperator;
      if (operator.precedence > bestOperator.precedence) indexOfHighestPrecedence = i;
    }
    return indexOfHighestPrecedence;
  }
}
