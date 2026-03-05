import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test creation and evaluation of UnaryExpression.', () {
    final operator = UnaryOperator.fromSymbol('-');
    test('UnaryExpression with UnaryMinusOperator as operator and NumLiteral as operand will evaluate to itself.', () {
      final operand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '8'));
      final expression = UnaryExpression(operator: operator, operand: operand);
      final result = expression.evaluate();

      expect(result is num, true);
      expect(result, -8);
    });

    test(
      'UnaryExpression with UnaryMinusOperator as operator and Expression evaluating to non-num value throws Exception.',
      () {
        final operand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, '8'));
        final expression = UnaryExpression(operator: operator, operand: operand);

        expect(expression.evaluate, throwsException);
      },
    );
  });
}
