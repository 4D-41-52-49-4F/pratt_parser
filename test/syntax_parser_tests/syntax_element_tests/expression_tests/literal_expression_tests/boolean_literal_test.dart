import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test boolean literal', () {
    test('BooleanLiteral value is true', () {
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.booleanLiteral, 'true'));

      expect(literal is SyntaxLiteral<bool>, true);
      expect(literal.value is bool, true);
      expect(literal.value, true);
    });

    test('BooleanLiteral value is false', () {
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.booleanLiteral, 'false'));

      expect(literal.value, false);
    });

    test('BooleanLiteral value true case agnostic', () {
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.booleanLiteral, 'TrUe'));

      expect(literal is SyntaxLiteral<bool>, true);
      expect(literal.value is bool, true);
      expect(literal.value, true);
    });

    test('BooleanLiteral value false case agnostic', () {
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.booleanLiteral, 'FALSE'));

      expect(literal.value, false);
    });
  });
}
