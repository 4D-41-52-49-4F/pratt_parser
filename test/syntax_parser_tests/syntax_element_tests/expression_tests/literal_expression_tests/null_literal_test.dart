import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test null literal', () {
    test('NullLiteral value is null', () {
      final literal = SyntaxLiteral.literalFromToken(Token(TokenType.nullLiteral, 'null'));

      expect(literal is SyntaxLiteral<Null>, true);
      expect(literal.value, null);
    });

    test('NullLiteral value is null case agnostic', () {
      final literal = SyntaxLiteral.literalFromToken(Token(TokenType.nullLiteral, 'NUll'));

      expect(literal.value, null);
    });
  });
}
