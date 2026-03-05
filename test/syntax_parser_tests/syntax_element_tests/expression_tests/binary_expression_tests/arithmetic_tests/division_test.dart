import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test division', () {
    final operator = SyntaxOperator.fromSymbol('/') as BinaryOperator;

    test('Division of two integers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '6'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate();
      expect(result, isA<double>());
      expect(result, 3.0);
    });

    test('Division with double evaluates to double.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3.0'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0.5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate();
      expect(result, isA<double>());
      expect(result, 6.0);
    });

    test('Division with int and double evaluates to double.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0.5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate();
      expect(result, isA<double>());
      expect(result, 6.0);
    });

    test('Division with 0 as dividend evaluates to 0.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2700'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), 0);
    });

    test('Division with negative numbers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-6'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate();
      expect(result, isA<double>());
      expect(result, -3.0);
    });

    test('Division of negative by negative evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-6'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-2'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate();
      expect(result, isA<double>());
      expect(result, 3.0);
    });
    test('Division with divisor 0 throws Exception.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, '0'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate, throwsException);
    });
  });

  group('Division edge cases', () {
    final operator = SyntaxOperator.fromSymbol('/') as BinaryOperator;

    test('Division with very large numbers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e308'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate();
      expect(result, isA<double>());
      expect(result, 5e307);
    });

    test('Division with very small numbers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e-308'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate();
      expect(result, isA<double>());
      expect(result, 5e-309);
    });

    test('Division by very small number close to zero.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e-308'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate();
      expect(result, isA<double>());
      expect(result, 1e308);
    });

    test('Division resulting in Infinity.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e308'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e-308'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isInfinite, true);
      expect(result > 0, true);
    });

    test('Division with Infinity as numerator evaluates to Infinity', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.infinity}'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isInfinite, true);
      expect(result.isNegative, false);
    });

    test('Division with Infinity as denominator evaluates to 0', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.infinity}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result, 0.0);
    });

    test('Division with NaN propagates NaN', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.nan}'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isNaN, true);
    });

    test('Division with -0.0 evaluates correctly', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-0.0'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result, -0.0);
    });

    test('Division of negative Infinity by negative number evaluates correctly', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-${double.infinity}'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-2'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isInfinite, true);
      expect(result.isNegative, false);
    });
  });
}
