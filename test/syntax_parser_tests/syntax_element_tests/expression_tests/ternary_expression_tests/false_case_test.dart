import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('TernaryExpression false branch tests', () {
    final conditionToken = Token(TokenType.booleanLiteral, 'false');
    final trueCaseToken = Token(TokenType.stringLiteral, 'true case');
    final falseCaseToken = Token(TokenType.stringLiteral, 'false case');

    final condition = SyntaxLiteral.literalFromToken(conditionToken);
    final trueCase = SyntaxLiteral.literalFromToken(trueCaseToken);
    final falseCase = SyntaxLiteral.literalFromToken(falseCaseToken);

    test('False condition returns the false case value.', () {
      final expression = TernaryExpression(condition: condition, trueCase: trueCase, falseCase: falseCase);

      expect(expression.evaluate(), 'false case');
    });

    test('False condition does not return the true case.', () {
      final expression = TernaryExpression(condition: condition, trueCase: trueCase, falseCase: falseCase);

      expect(expression.evaluate(), isNot('true case'));
    });

    test('False condition works with different false case value.', () {
      final anotherFalseCaseToken = Token(TokenType.stringLiteral, 'another false case');
      final anotherFalseCase = SyntaxLiteral.literalFromToken(anotherFalseCaseToken);
      final expression = TernaryExpression(condition: condition, trueCase: trueCase, falseCase: anotherFalseCase);

      expect(expression.evaluate(), 'another false case');
    });

    test('False condition still evaluates correctly with boolean literals.', () {
      final boolTrueToken = Token(TokenType.booleanLiteral, 'true');
      final boolFalseToken = Token(TokenType.booleanLiteral, 'false');

      final boolTrue = SyntaxLiteral.literalFromToken(boolTrueToken);
      final boolFalse = SyntaxLiteral.literalFromToken(boolFalseToken);

      final expression = TernaryExpression(condition: condition, trueCase: boolTrue, falseCase: boolFalse);

      expect(expression.evaluate(), false);
    });

    test('True condition evaluates correctly with int literals.', () {
      final boolTrueToken = Token(TokenType.numeralLiteral, '42');
      final boolFalseToken = Token(TokenType.numeralLiteral, '21');

      final boolTrue = SyntaxLiteral.literalFromToken(boolTrueToken);
      final boolFalse = SyntaxLiteral.literalFromToken(boolFalseToken);

      final expression = TernaryExpression(condition: condition, trueCase: boolTrue, falseCase: boolFalse);

      expect(expression.evaluate(), 21);
    });

    test('True condition evaluates correctly with double literals.', () {
      final boolTrueToken = Token(TokenType.numeralLiteral, '42.21');
      final boolFalseToken = Token(TokenType.numeralLiteral, '21.42');

      final boolTrue = SyntaxLiteral.literalFromToken(boolTrueToken);
      final boolFalse = SyntaxLiteral.literalFromToken(boolFalseToken);

      final expression = TernaryExpression(condition: condition, trueCase: boolTrue, falseCase: boolFalse);

      expect(expression.evaluate(), 21.42);
    });

    test('True condition evaluates correctly with null literals.', () {
      final boolTrueToken = Token(TokenType.numeralLiteral, '21.52');
      final boolFalseToken = Token(TokenType.nullLiteral, 'null');

      final boolTrue = SyntaxLiteral.literalFromToken(boolTrueToken);
      final boolFalse = SyntaxLiteral.literalFromToken(boolFalseToken);

      final expression = TernaryExpression(condition: condition, trueCase: boolTrue, falseCase: boolFalse);

      expect(expression.evaluate(), null);
    });
  });
}
