import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('TernaryExpression true branch tests', () {
    final conditionToken = Token(TokenType.booleanLiteral, 'true');
    final trueCaseToken = Token(TokenType.stringLiteral, 'true case');
    final falseCaseToken = Token(TokenType.stringLiteral, 'false case');

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
      final anotherTrueToken = Token(TokenType.stringLiteral, 'another true case');
      final anotherTrueCase = SyntaxLiteral.literalFromToken(anotherTrueToken);

      final expression = TernaryExpression(condition: condition, trueCase: anotherTrueCase, falseCase: falseCase);

      expect(expression.evaluate(), 'another true case');
    });

    test('True condition evaluates correctly with boolean literals.', () {
      final boolTrueToken = Token(TokenType.booleanLiteral, 'true');
      final boolFalseToken = Token(TokenType.booleanLiteral, 'false');

      final boolTrue = SyntaxLiteral.literalFromToken(boolTrueToken);
      final boolFalse = SyntaxLiteral.literalFromToken(boolFalseToken);

      final expression = TernaryExpression(condition: condition, trueCase: boolTrue, falseCase: boolFalse);

      expect(expression.evaluate(), true);
    });

    test('True condition evaluates correctly with boolean literals.', () {
      final boolTrueToken = Token(TokenType.booleanLiteral, 'true');
      final boolFalseToken = Token(TokenType.booleanLiteral, 'false');

      final boolTrue = SyntaxLiteral.literalFromToken(boolTrueToken);
      final boolFalse = SyntaxLiteral.literalFromToken(boolFalseToken);

      final expression = TernaryExpression(condition: condition, trueCase: boolTrue, falseCase: boolFalse);

      expect(expression.evaluate(), true);
    });

    test('True condition evaluates correctly with int literals.', () {
      final boolTrueToken = Token(TokenType.numeralLiteral, '42');
      final boolFalseToken = Token(TokenType.numeralLiteral, '21');

      final boolTrue = SyntaxLiteral.literalFromToken(boolTrueToken);
      final boolFalse = SyntaxLiteral.literalFromToken(boolFalseToken);

      final expression = TernaryExpression(condition: condition, trueCase: boolTrue, falseCase: boolFalse);

      expect(expression.evaluate(), 42);
    });

    test('True condition evaluates correctly with double literals.', () {
      final boolTrueToken = Token(TokenType.numeralLiteral, '42.21');
      final boolFalseToken = Token(TokenType.numeralLiteral, '21.42');

      final boolTrue = SyntaxLiteral.literalFromToken(boolTrueToken);
      final boolFalse = SyntaxLiteral.literalFromToken(boolFalseToken);

      final expression = TernaryExpression(condition: condition, trueCase: boolTrue, falseCase: boolFalse);

      expect(expression.evaluate(), 42.21);
    });

    test('True condition evaluates correctly with null literals.', () {
      final boolTrueToken = Token(TokenType.nullLiteral, 'null');
      final boolFalseToken = Token(TokenType.numeralLiteral, '21.42');

      final boolTrue = SyntaxLiteral.literalFromToken(boolTrueToken);
      final boolFalse = SyntaxLiteral.literalFromToken(boolFalseToken);

      final expression = TernaryExpression(condition: condition, trueCase: boolTrue, falseCase: boolFalse);

      expect(expression.evaluate(), null);
    });
  });
}
