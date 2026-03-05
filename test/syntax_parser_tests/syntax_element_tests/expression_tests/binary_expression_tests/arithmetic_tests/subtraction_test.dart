import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test subtraction', () {
    final operator = SyntaxOperator.fromSymbol('-') as BinaryOperator;

    test('BinaryExpression with SubtractionOperator and two integers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '6'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result is int, true);
      expect(result, 4);
    });

    test('Subtraction with int and double evaluates to double.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0.5'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result is double, true);
      expect(result, 2.5);
    });

    test('Subtraction with negative numbers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-6'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result is int, true);
      expect(result, -8);
    });

    test('Subtraction of negative numbers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-6'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-2'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result is int, true);
      expect(result, -4);
    });

    test('Subtraction with zero evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result, -5);
    });

    test('Subtraction with very large numbers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e308'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-1e308'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate() as double;

      expect(result.isInfinite, true); // 1e308 - (-1e308) = 2e308 → Infinity
      expect(result > 0, true);
    });

    test('Subtraction with very small numbers evaluates correctly.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e-308'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2e-308'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);
      final result = expression.evaluate();

      expect(result is double, true);
      expect(result, closeTo(-1e-308, 1e-320));
    });

    test('Subtraction with one value not num throws Exception.', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, '1.5'));

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate, throwsException);
    });
  });

  group('Subtraction edge cases', () {
    final operator = SyntaxOperator.fromSymbol('-') as BinaryOperator;

    test('Subtracting 0.0 from 0.0 gives 0.0', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0.0'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0.0'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate();
      expect(result, 0.0);
    });

    test('Subtracting -0.0 from 0.0 gives 0.0', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0.0'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-0.0'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate();
      expect(result, 0.0);
    });

    test('0.0 minus -0.0 gives 0.0', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0.0'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-0.0'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate();
      expect(result, 0.0);
    });

    test('Subtracting Infinity from finite number gives -Infinity', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '100'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.infinity}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isInfinite, true);
      expect(result.isNegative, true);
    });

    test('Subtracting finite number from Infinity gives Infinity', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.infinity}'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '100'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isInfinite, true);
      expect(result.isNegative, false);
    });

    test('Infinity minus Infinity gives NaN', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.infinity}'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.infinity}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isNaN, true);
    });

    test('Finite number minus NaN gives NaN', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '100'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.nan}'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isNaN, true);
    });

    test('NaN minus finite number gives NaN', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '${double.nan}'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '100'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isNaN, true);
    });

    test('Subtracting very small numbers underflow to 0.0', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e-324'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e-324'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate();
      expect(result, 0.0);
    });

    test('Subtracting very large numbers overflow to Infinity', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1e308'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-1e308'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      final result = expression.evaluate() as double;
      expect(result.isInfinite, true);
      expect(result.isNegative, false);
    });
  });
}
