import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test logical AND', () {
    final operator = SyntaxOperator.fromSymbol('&&') as BinaryOperator;

    test('true && true evaluates to true', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.booleanLiteral, 'true'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.booleanLiteral, 'true'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('true && false evaluates to false', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.booleanLiteral, 'true'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.booleanLiteral, 'false'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('false && true evaluates to false', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.booleanLiteral, 'false'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.booleanLiteral, 'true'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('false && false evaluates to false', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.booleanLiteral, 'false'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.booleanLiteral, 'false'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), false);
    });

    test('Complex expression as operands', () {
      final leftOperand = BinaryExpression(
        operator: SyntaxOperator.fromSymbol('<') as BinaryOperator,
        leftOperand: SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3')),
        rightOperand: SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5')),
      );
      final rightOperand = BinaryExpression(
        operator: SyntaxOperator.fromSymbol('>') as BinaryOperator,
        leftOperand: SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '10')),
        rightOperand: SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2')),
      );

      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate(), true);
    });

    test('Left operand not boolean throws Exception', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.booleanLiteral, 'true'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate, throwsException);
    });

    test('Right operand not boolean throws Exception', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.booleanLiteral, 'true'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'false'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate, throwsException);
    });

    test('Both operands not boolean throw Exception', () {
      final leftOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0'));
      final rightOperand = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'false'));
      final expression = BinaryExpression(operator: operator, leftOperand: leftOperand, rightOperand: rightOperand);

      expect(expression.evaluate, throwsException);
    });
  });
}
