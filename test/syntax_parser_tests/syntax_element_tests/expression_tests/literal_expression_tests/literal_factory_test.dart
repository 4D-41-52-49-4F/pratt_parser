import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test literal factory on different TokenType.', () {
    test('Create StringLiteral from TokenType.stringLiteral', () {
      final stringToken = const Token(TokenType.stringLiteral, 'This is a test.');
      final literal = SyntaxLiteral.literalFromToken(stringToken);

      expect(literal is SyntaxLiteral<String>, true);
      expect(literal.evaluate(), 'This is a test.');
    });
    test('Create NumeralLiteral from TokenType.numeralLiteral as int.', () {
      final numToken = const Token(TokenType.numeralLiteral, '123');
      final literal = SyntaxLiteral.literalFromToken(numToken);

      expect(literal is SyntaxLiteral<num>, true);
      expect(literal.evaluate(), 123);
    });
    test('Create NumeralLiteral from TokenType.numeralLiteral as double.', () {
      final numToken = const Token(TokenType.numeralLiteral, '123.456');
      final literal = SyntaxLiteral.literalFromToken(numToken);

      expect(literal is SyntaxLiteral<num>, true);
      expect(literal.evaluate(), 123.456);
    });
    test('Create BooleanLiteral from TokenType.booleanLiteral', () {
      final booleanToken = const Token(TokenType.booleanLiteral, 'true');
      final literal = SyntaxLiteral.literalFromToken(booleanToken);

      expect(literal is SyntaxLiteral<bool>, true);
      expect(literal.evaluate(), true);
    });
    test('Create NullLiteral from TokenType.nullLiteral', () {
      final nullToken = const Token(TokenType.nullLiteral, 'null');
      final literal = SyntaxLiteral.literalFromToken(nullToken);

      expect(literal is SyntaxLiteral<Null>, true);
      expect(literal.evaluate(), null);
    });

    test('Test Exception on TokenType not literal.', () {
      final identifierToken = const Token(TokenType.identifier, 'identifier');

      expect(() => SyntaxLiteral.literalFromToken(identifierToken), throwsException);
    });
  });
}
