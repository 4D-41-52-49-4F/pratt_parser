import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test logical OR (||)', () {
    final operator = SyntaxOperator.fromSymbol('||') as BinaryOperator;

    test('false || false evaluates to false', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.booleanLiteral, 'false'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.booleanLiteral, 'false'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('false || true evaluates to true', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.booleanLiteral, 'false'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.booleanLiteral, 'true'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('true || false evaluates to true', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.booleanLiteral, 'true'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.booleanLiteral, 'false'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('true || true evaluates to true', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.booleanLiteral, 'true'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.booleanLiteral, 'true'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Complex expressions as operands', () {
      final leftOperand = BinaryExpression(
        operator: SyntaxOperator.fromSymbol('>') as BinaryOperator,
        leftOperand: SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '5')),
        rightOperand: SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '10')),
      );

      final rightOperand = BinaryExpression(
        operator: SyntaxOperator.fromSymbol('<') as BinaryOperator,
        leftOperand: SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '3')),
        rightOperand: SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '5')),
      );

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Non-boolean left operand throws Exception', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.numeralLiteral, '1'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.booleanLiteral, 'true'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate, throwsException);
    });

    test('Non-boolean right operand throws Exception', () {
      final leftOperand = SyntaxLiteral.literalFromToken(Token(TokenType.booleanLiteral, 'true'));
      final rightOperand = SyntaxLiteral.literalFromToken(Token(TokenType.stringLiteral, 'false'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate, throwsException);
    });
  });
}
