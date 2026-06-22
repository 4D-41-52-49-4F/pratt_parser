import 'package:pratt_parser/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:pratt_parser/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test ternary condition', () {
    const trueCaseToken = Token(TokenType.stringLiteral, 'true case');
    const falseCaseToken = Token(TokenType.stringLiteral, 'false case');
    final trueCase = SyntaxLiteral.literalFromToken(trueCaseToken);
    final falseCase = SyntaxLiteral.literalFromToken(falseCaseToken);

    test('True condition evaluates to true case of ternary expression.', () {
      const trueConditionToken = Token(TokenType.booleanLiteral, 'true');
      final condition = SyntaxLiteral.literalFromToken(trueConditionToken);

      final expression = TernaryExpression(condition: condition, trueCase: trueCase, falseCase: falseCase);

      expect(expression.evaluate(), 'true case');
    });

    test('False condition evaluates to true case of ternary expression.', () {
      const falseConditionToken = Token(TokenType.booleanLiteral, 'false');
      final condition = SyntaxLiteral.literalFromToken(falseConditionToken);

      final expression = TernaryExpression(condition: condition, trueCase: trueCase, falseCase: falseCase);

      expect(expression.evaluate(), 'false case');
    });

    test('Invalid condition type throws Exception.', () {
      const invalidConditionToken = Token(TokenType.stringLiteral, 'invalid');
      final condition = SyntaxLiteral.literalFromToken(invalidConditionToken);

      final expression = TernaryExpression(condition: condition, trueCase: trueCase, falseCase: falseCase);

      expect(expression.evaluate, throwsException);
    });
  });
}
