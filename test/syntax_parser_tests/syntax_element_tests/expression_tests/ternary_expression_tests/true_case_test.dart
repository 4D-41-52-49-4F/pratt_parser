import 'package:pratt_parser/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:pratt_parser/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('TernaryExpression true branch tests', () {
    const conditionToken = Token(TokenType.booleanLiteral, 'true');
    const trueCaseToken = Token(TokenType.stringLiteral, 'true case');
    const falseCaseToken = Token(TokenType.stringLiteral, 'false case');

    final condition = SyntaxLiteral.literalFromToken(conditionToken);
    final trueCase = SyntaxLiteral.literalFromToken(trueCaseToken);
    final falseCase = SyntaxLiteral.literalFromToken(falseCaseToken);

    test('True condition returns the true case value.', () {
      final expression = TernaryExpression(condition: condition, trueCase: trueCase, falseCase: falseCase);

      expect(expression.evaluate(), 'true case');
    });

    test('True condition does not return the false case.', () {
      final expression = TernaryExpression(condition: condition, trueCase: trueCase, falseCase: falseCase);

      expect(expression.evaluate(), isNot('false case'));
    });

    test('True condition works with different true case value.', () {
      const anotherTrueToken = Token(TokenType.stringLiteral, 'another true case');
      final anotherTrueCase = SyntaxLiteral.literalFromToken(anotherTrueToken);

      final expression = TernaryExpression(condition: condition, trueCase: anotherTrueCase, falseCase: falseCase);

      expect(expression.evaluate(), 'another true case');
    });

    test('True condition evaluates correctly with boolean literals.', () {
      const boolTrueToken = Token(TokenType.booleanLiteral, 'true');
      const boolFalseToken = Token(TokenType.booleanLiteral, 'false');

      final boolTrue = SyntaxLiteral.literalFromToken(boolTrueToken);
      final boolFalse = SyntaxLiteral.literalFromToken(boolFalseToken);

      final expression = TernaryExpression(condition: condition, trueCase: boolTrue, falseCase: boolFalse);

      expect(expression.evaluate(), true);
    });

    test('True condition evaluates correctly with int literals.', () {
      const boolTrueToken = Token(TokenType.numeralLiteral, '42');
      const boolFalseToken = Token(TokenType.numeralLiteral, '21');

      final boolTrue = SyntaxLiteral.literalFromToken(boolTrueToken);
      final boolFalse = SyntaxLiteral.literalFromToken(boolFalseToken);

      final expression = TernaryExpression(condition: condition, trueCase: boolTrue, falseCase: boolFalse);

      expect(expression.evaluate(), 42);
    });

    test('True condition evaluates correctly with double literals.', () {
      const boolTrueToken = Token(TokenType.numeralLiteral, '42.21');
      const boolFalseToken = Token(TokenType.numeralLiteral, '21.42');

      final boolTrue = SyntaxLiteral.literalFromToken(boolTrueToken);
      final boolFalse = SyntaxLiteral.literalFromToken(boolFalseToken);

      final expression = TernaryExpression(condition: condition, trueCase: boolTrue, falseCase: boolFalse);

      expect(expression.evaluate(), 42.21);
    });

    test('True condition evaluates correctly with null literals.', () {
      const boolTrueToken = Token(TokenType.nullLiteral, 'null');
      const boolFalseToken = Token(TokenType.numeralLiteral, '21.42');

      final boolTrue = SyntaxLiteral.literalFromToken(boolTrueToken);
      final boolFalse = SyntaxLiteral.literalFromToken(boolFalseToken);

      final expression = TernaryExpression(condition: condition, trueCase: boolTrue, falseCase: boolFalse);

      expect(expression.evaluate(), null);
    });
  });
}
