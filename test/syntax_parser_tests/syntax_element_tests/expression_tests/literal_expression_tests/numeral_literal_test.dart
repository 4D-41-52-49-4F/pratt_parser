import 'package:pratt_parser/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:pratt_parser/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Test numeral literal', () {
    test('NumeralLiteral value is 42', () {
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '42'));

      expect(literal is SyntaxLiteral<num>, true);
      expect(literal.value is num, true);
      expect(literal.value, 42);
    });

    test('NumeralLiteral value is 42.5', () {
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '42.5'));

      expect(literal.value, 42.5);
    });
  });
}
