import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test less-than-or-equal', () {
    final operator = SyntaxOperator.fromSymbol('<=') as BinaryOperator;

    test('Int less than int evaluates correctly', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Int equal to int evaluates correctly', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '5'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Int greater than int evaluates correctly', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '7'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('Double less than double evaluates correctly', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '2.5'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3.1'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Double equal to double evaluates correctly', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3.5'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3.5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Int and double comparison evaluates correctly', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '4'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '4.5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Negative numbers comparison evaluates correctly', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-2'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-1'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Comparison with zero evaluates correctly', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '0'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '0'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Comparison with one value not num throws Exception', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.stringLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate, throwsException);
    });
  });

  group('Less-than-or-equal operator <= edge cases', () {
    final operator = SyntaxOperator.fromSymbol('<=') as BinaryOperator;

    test('Comparison with double.infinity', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1e308'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '${double.infinity}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Comparison with double.negativeInfinity', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '${double.negativeInfinity}'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '0'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Comparison with NaN always false', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '${double.nan}'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('Comparison with -0.0 and 0.0', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-0.0'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '0.0'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Comparison with very small numbers', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1e-308'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1e-307'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Comparison with very large negative numbers', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-1e308'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-1e307'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Comparison with equal numbers evaluates true', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '5.0'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Comparison with one value not num throws Exception', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.stringLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate, throwsException);
    });
  });
}
