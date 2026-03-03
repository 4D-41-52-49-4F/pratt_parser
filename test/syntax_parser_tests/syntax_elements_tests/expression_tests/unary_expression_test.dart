import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  group('Test creation and evaluation of UnaryExpression.', () {
    test(
      'UnaryExpression with NotOperator as operator and BooleanLiteral as operand will evaluate to opposite of input.',
      () {
        final operator = UnaryOperator.fromSymbol('!');
        final operand = SyntaxLiteral.literalFromToken(Token(TokenType.booleanLiteral, 'true'));
        final expression = UnaryExpression(operator: operator, operand: operand);
        final result = expression.evaluate();

        expect(result is bool, true);
        expect(result, false);
      },
    );
    test('UnaryExpression with UnaryMinusOperator as operator and NumLiteral as operand will evaluate to itself.', () {
      final operator = UnaryOperator.fromSymbol('-');
      final operand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '8'));
      final expression = UnaryExpression(operator: operator, operand: operand);
      final result = expression.evaluate();

      expect(result is num, true);
      expect(result, -8);
    });

    test(
      'UnaryExpression with NotOperator as operator and Expression evaluating to non-boolean value throws Exception.',
      () {
        final operator = UnaryOperator.fromSymbol('!');
        final operand = SyntaxLiteral.literalFromToken(Token(TokenType.stringLiteral, 'true'));
        final expression = UnaryExpression(operator: operator, operand: operand);

        expect(expression.evaluate, throwsException);
      },
    );
    test(
      'UnaryExpression with UnaryMinusOperator as operator and Expression evaluating to non-num value throws Exception.',
      () {
        final operator = UnaryOperator.fromSymbol('-');
        final operand = SyntaxLiteral.literalFromToken(Token(TokenType.stringLiteral, '8'));
        final expression = UnaryExpression(operator: operator, operand: operand);

        expect(expression.evaluate, throwsException);
      },
    );
  });
}
