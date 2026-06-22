import 'package:pratt_parser/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:pratt_parser/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:pratt_parser/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test creation and evaluation of UnaryExpression.', () {
    final operator = UnaryOperator.fromSymbol('!');
    test(
      'UnaryExpression with NotOperator as operator and BooleanLiteral as operand will evaluate to opposite of input.',
      () {
        final operand = SyntaxLiteral.literalFromToken(const Token(TokenType.booleanLiteral, 'true'));
        final expression = UnaryExpression(operator: operator, operand: operand);
        final result = expression.evaluate();

        expect(result is bool, true);
        expect(result, false);
      },
    );

    test(
      'UnaryExpression with NotOperator as operator and Expression evaluating to non-boolean value throws Exception.',
      () {
        final operand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'true'));
        final expression = UnaryExpression(operator: operator, operand: operand);

        expect(expression.evaluate, throwsException);
      },
    );
  });
}
