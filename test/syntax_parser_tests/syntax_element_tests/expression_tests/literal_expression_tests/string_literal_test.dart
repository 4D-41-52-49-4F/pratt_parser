import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test sting literal', () {
    test('StringLiteral value is "always valid"', () {
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'always valid'));

      expect(literal is SyntaxLiteral<String>, true);
      expect(literal.value is String, true);
      expect(literal.value, 'always valid');
    });
  });
}
