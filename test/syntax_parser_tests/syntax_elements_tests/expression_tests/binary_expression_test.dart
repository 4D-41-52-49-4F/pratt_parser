import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  group('Test creation and evaluation of BinaryExpression.', () {
    group('Test multiplication', () {
      final operator = SyntaxOperator.fromSymbol('*') as BinaryOperator;
      test(
        'BinaryExpression with MultiplicationOperator as operator and NumeralLiteral as left and right operand will evaluate to product of both.',
        () {
          final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
          final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '5'));
          final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

          expect(expression.evaluate(), 15);
        },
      );
      test('Multiplication with int as one operand and double as other operand will evaluate to double.', () {
        final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
        final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1.5'));
        final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
        final result = expression.evaluate();

        expect(result is double, true);
        expect(result, 4.5);
      });
      test('Multiplication with int as one operand and double as other operand will evaluate to double.', () {
        final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
        final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1.5'));
        final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
        final result = expression.evaluate();

        expect(result is double, true);
        expect(result, 4.5);
      });
      test('Multiplication with one value not num throws Exception.', () {
        final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
        final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.stringLiteral, '1.5'));
        final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

        expect(expression.evaluate, throwsException);
      });
    });
    group('Test multiplication', () {
      final operator = SyntaxOperator.fromSymbol('*') as BinaryOperator;
      test(
        'BinaryExpression with MultiplicationOperator as operator and NumeralLiteral as left and right operand will evaluate to product of both.',
        () {
          final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
          final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '5'));
          final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

          expect(expression.evaluate(), 15);
        },
      );
      test('Multiplication with int as one operand and double as other operand will evaluate to double.', () {
        final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
        final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1.5'));
        final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
        final result = expression.evaluate();

        expect(result is double, true);
        expect(result, 4.5);
      });
      test('Multiplication with int as one operand and double as other operand will evaluate to double.', () {
        final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
        final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1.5'));
        final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
        final result = expression.evaluate();

        expect(result is double, true);
        expect(result, 4.5);
      });
      test('Multiplication with one value not num throws Exception.', () {
        final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
        final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.stringLiteral, '1.5'));
        final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

        expect(expression.evaluate, throwsException);
      });
    });
  });
}
