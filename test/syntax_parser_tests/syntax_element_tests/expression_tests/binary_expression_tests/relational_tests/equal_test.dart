import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test equal', () {
    final operator = SyntaxOperator.fromSymbol('==') as BinaryOperator;

    test('Two integers equal', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Two integers not equal', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '7'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('Integer equal to double', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5.0'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Double equal to double', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3.14'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3.14'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Same strings are equal.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'equal'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'equal'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Different strings are not equal.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'not'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'equal'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('"null" is not equal null', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'null'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.nullLiteral, 'null'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('Negative numbers equal', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-7'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-7'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Negative number not equal', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-7'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '7'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('Zero equal to zero', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0.0'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });
  });

  group('Equal operator == edge cases', () {
    final operator = SyntaxOperator.fromSymbol('==') as BinaryOperator;

    test('NaN compared to any number is false', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.nan}'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('NaN compared to NaN is false', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.nan}'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.nan}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('Infinity equal to Infinity is true', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.infinity}'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.infinity}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('-Infinity equal to -Infinity is true', () {
      final leftOperand = SyntaxLiteral.literalFromToken(
        const Token(TokenType.numeralLiteral, '${double.negativeInfinity}'),
      );
      final rightOperand = SyntaxLiteral.literalFromToken(
        const Token(TokenType.numeralLiteral, '${double.negativeInfinity}'),
      );
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Infinity not equal to -Infinity', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.infinity}'));
      final rightOperand = SyntaxLiteral.literalFromToken(
        const Token(TokenType.numeralLiteral, '${double.negativeInfinity}'),
      );
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('0.0 equal to -0.0', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0.0'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-0.0'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Very large numbers comparison', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e308'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e308'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Very small numbers comparison', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e-308'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e-308'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });
  });
}
