import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test addition', () {
    final operator = SyntaxOperator.fromSymbol('+') as BinaryOperator;

    test('BinaryExpression with AdditionOperator and two integers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '6'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '2'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result is int, true);
      expect(result, 8);
    });

    test('Addition with int and double evaluates to double.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '0.5'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result is double, true);
      expect(result, 3.5);
    });

    test('Addition with negative numbers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-6'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '2'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result is int, true);
      expect(result, -4);
    });

    test('Addition of negative numbers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-6'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-2'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result is int, true);
      expect(result, -8);
    });

    test('Addition with zero evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '0'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '5'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result, 5);
    });

    test('Addition with very large numbers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1e308'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1e308'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate() as double;

      expect(result.isInfinite, true);
      expect(result > 0, true);
    });

    test('Addition with very small numbers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1e-308'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '2e-308'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result is double, true);
      expect(result, closeTo(3e-308, 1e-320));
    });

    test('Addition with one value not num throws Exception.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.stringLiteral, '1.5'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate, throwsException);
    });
  });

  group('Addition edge cases', () {
    final operator = SyntaxOperator.fromSymbol('+') as BinaryOperator;

    test('0.0 + -0.0 and variations give 0.0', () {
      for (final x in ['0.0', '-0.0']) {
        for (final y in ['0.0', '-0.0']) {
          final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, x));
          final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, y));
          final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

          final result = expression.evaluate();
          expect(result, 0.0);
        }
      }
    });

    test('Adding finite number to Infinity gives Infinity', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '42'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '${double.infinity}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isInfinite, true);
      expect(result.isNegative, false);
    });

    test('Adding finite negative number to -Infinity gives -Infinity', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-42'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-${double.infinity}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isInfinite, true);
      expect(result.isNegative, true);
    });

    test('Infinity + -Infinity gives NaN', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '${double.infinity}'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '-${double.infinity}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isNaN, true);
    });

    test('Any number + NaN gives NaN', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '100'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '${double.nan}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isNaN, true);
    });

    test('NaN + any number gives NaN', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '${double.nan}'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '100'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isNaN, true);
    });

    test('Adding very small numbers underflow correctly', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1e-324'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1e-324'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate();
      expect(result, 0.0);
    });

    test('Adding very large numbers overflow to Infinity', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1e308'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1e308'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isInfinite, true);
      expect(result.isNegative, false);
    });
  });
}
