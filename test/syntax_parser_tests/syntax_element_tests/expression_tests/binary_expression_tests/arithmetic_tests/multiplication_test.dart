import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test multiplication', () {
    final operator = SyntaxOperator.fromSymbol('*') as BinaryOperator;

    test('Multiplication of two integers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), 15);
    });

    test('Multiplication with int and double evaluates to double.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1.5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result is double, true);
      expect(result, 4.5);
    });

    test('Multiplication with negative numbers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-3'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), -15);
    });

    test('Multiplication of two negative numbers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-3'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), 15);
    });

    test('Multiplication with zero evaluates to zero.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), 0);
    });

    test('Multiplication with very large numbers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e308'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate() as double;

      expect(result.isInfinite, true);
    });

    test('Multiplication with very small numbers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e-308'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result, 2e-308);
    });

    test('Multiplication with one value not num throws Exception.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, '1.5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate, throwsException);
    });

    test('Multiplication with NaN propagates NaN.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.nan}'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate() as double;

      expect(result.isNaN, true);
    });
  });

  group('Multiplication edge cases', () {
    final operator = SyntaxOperator.fromSymbol('*') as BinaryOperator;

    test('Multiplying with 0.0 and -0.0', () {
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

    test('Multiplying finite number by Infinity gives Infinity', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.infinity}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isInfinite, true);
      expect(result.isNegative, false);
    });

    test('Multiplying finite negative number by Infinity gives -Infinity', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-2'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.infinity}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isInfinite, true);
      expect(result.isNegative, true);
    });

    test('Infinity multiplied by 0.0 gives NaN', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.infinity}'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0.0'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isNaN, true);
    });

    test('Multiplying NaN with any number gives NaN', () {
      for (final x in ['${double.nan}', '5']) {
        for (final y in ['${double.nan}', '7']) {
          if (x != '${double.nan}' && y != '${double.nan}') continue;

          final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, x));
          final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, y));
          final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

          final result = expression.evaluate() as double;
          expect(result.isNaN, true);
        }
      }
    });

    test('Multiplying very large numbers overflows to Infinity', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e308'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isInfinite, true);
    });

    test('Multiplying very small numbers underflows to 0.0', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e-324'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e-324'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate();
      expect(result, 0.0);
    });
  });
}
