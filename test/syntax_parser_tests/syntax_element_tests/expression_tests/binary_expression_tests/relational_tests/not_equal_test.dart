import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test not equal', () {
    final operator = SyntaxOperator.fromSymbol('!=') as BinaryOperator;

    test('Two integers not equal', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Two integers equal', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('Integer != Double', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5.0'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('Double != Double', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3.14'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2.71'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('String != String', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'hello'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'world'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Same strings are equal -> != is false', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'same'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'same'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('"null" is not equal null', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'null'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.nullLiteral, 'null'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });
  });

  group('Not equal edge cases', () {
    final operator = SyntaxOperator.fromSymbol('!=') as BinaryOperator;

    test('NaN != any number is true', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.nan}'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('NaN != NaN is true', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.nan}'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.nan}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Infinity != Infinity is false', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.infinity}'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.infinity}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('-Infinity != -Infinity is false', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.negativeInfinity}'));
      final rightOperand = SyntaxLiteral.literalFromToken(
        const Token(TokenType.numeralLiteral, '${double.negativeInfinity}'),
      );
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('Infinity != -Infinity is true', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.infinity}'));
      final rightOperand = SyntaxLiteral.literalFromToken(
        const Token(TokenType.numeralLiteral, '${double.negativeInfinity}'),
      );
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('0.0 != -0.0 is false', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0.0'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-0.0'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('Very large numbers not equal', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e308'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e307'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Very small numbers not equal', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e-308'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2e-308'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });
  });
}
