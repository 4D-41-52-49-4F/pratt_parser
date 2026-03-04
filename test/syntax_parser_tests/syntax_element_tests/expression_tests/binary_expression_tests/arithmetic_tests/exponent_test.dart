import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test exponent operator', () {
    final operator = SyntaxOperator.fromSymbol('^') as BinaryOperator;

    test('Exponent with integer base and integer exponent evaluates to integer value.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '2'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result is int, true);
      expect(result, 8);
    });

    test('Exponent with integer base and double exponent evaluates to double value.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '9'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '0.5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result is double, true);
      expect(result, closeTo(3.0, 1e-12));
    });

    test('Exponent with negative base and odd integer exponent evaluates to negative integer.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-2'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result is int, true);
      expect(result, -8);
    });

    test('Exponent with negative base and even integer exponent evaluates to positive integer.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-2'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '4'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result is int, true);
      expect(result, 16);
    });

    test('Exponent with zero base evaluates to 0.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '0'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result, 0);
    });

    test('Exponent with zero exponent evaluates to 1.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '5'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '0'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result, 1);
    });

    test('Exponent with very large numbers evaluates to infitinite. (Exceeding double.maxFinite).', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1.8e154'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '2'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;

      expect(result.isInfinite, true);
    });

    test('Exponent with very small numbers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1e-154'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '2'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result is double, true);
      expect(result, closeTo(1e-308, 1e-320));
    });

    test('Exponent with one value not num throws Exception.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.stringLiteral, '2'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate, throwsException);
    });
  });

  group('Test edge cases of dart:math pow(num base, num exponent) function in relation to exponent operator.', () {
    final operator = SyntaxOperator.fromSymbol('^') as BinaryOperator;

    test('Exponent is zero (0.0 or -0.0) → result is 1.0', () {
      for (final exponent in [0.0, -0.0]) {
        final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '2'));
        final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '$exponent'));
        final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

        expect(expression.evaluate(), 1.0);
      }
    });

    test('base is 1.0 → result is 1.0', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1.0'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '12345'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), 1.0);
    });

    test('Either base or exponent is NaN → result is NaN', () {
      for (final base in ['${double.nan}', '3.0']) {
        for (final exponent in ['${double.nan}', '3.0']) {
          if (base == exponent && base != '${double.nan}') continue;

          final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, base));
          final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, exponent));
          final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

          final result = expression.evaluate() as double;
          expect(result.isNaN, true);
        }
      }
    });

    test('Negative base and non-integer finite exponent → result is NaN', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-2'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '0.5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isNaN, true);
    });

    test('base is Infinity and exponent negative → result is 0.0', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '${double.infinity}'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-1'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), 0.0);
    });

    test('base is Infinity and exponent positive → result is Infinity', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '${double.infinity}'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '2'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), double.infinity);
    });

    test('base is 0.0 and exponent negative → result is Infinity', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '0.0'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-2'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), double.infinity);
    });

    test('base is 0.0 and exponent positive → result is 0.0', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '0.0'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), 0.0);
    });

    test('base is -Infinity or -0.0 and exponent is odd integer → result is negative', () {
      for (final xValue in ['-${double.infinity}', '-0.0']) {
        final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, xValue));
        final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
        final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

        final result = expression.evaluate() as double;
        expect(result.isNegative, true);
      }
    });

    test('base is -Infinity or -0.0 and exponent is even integer → result is positive', () {
      for (final xValue in ['-${double.infinity}', '-0.0']) {
        final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, xValue));
        final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '4'));
        final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

        final result = expression.evaluate() as double;
        expect(result.isNegative, false);
      }
    });

    test('exponent is Infinity and |base| < 1 → result is 0.0', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '0.5'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '${double.infinity}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), 0.0);
    });

    test('exponent is Infinity and base = -1 → result is 1.0', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-1.0'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '${double.infinity}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), 1.0);
    });

    test('exponent is Infinity and |base| > 1 → result is Infinity', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '2.0'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '${double.infinity}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), double.infinity);
    });

    test('exponent is -Infinity → result is 1/pow(x, Infinity)', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '2.0'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-${double.infinity}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result, closeTo(0.0, 1e-12));
    });
  });
}
