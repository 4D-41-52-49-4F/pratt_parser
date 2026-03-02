import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expression/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/syntax_parser.dart';
import 'package:abschlussprojekt/src/models/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  group('test double parsing', () {
    test('Simple parsing of a double numeral.', () {
      const rule = '3.21';
      const tokenizer = Tokenizer();
      final tokens = tokenizer.tokenize(rule);
      print(tokens);
      final parser = SyntaxParser(tokens);

      final expression = parser.parseSyntaxTree();

      expect(expression is NumeralLiteral, true);
      expect(expression.evaluate() is double, true);
      expect(expression.evaluate(), 3.21);
    });

    test('Simple + of two double numerals.', () {
      const rule = '3.21 + 4.56';
      const tokenizer = Tokenizer();
      final tokens = tokenizer.tokenize(rule);
      final parser = SyntaxParser(tokens);

      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 7.77);
    });

    test('Test multiplication of two doubles.', () {
      const rule = '1.5 * 2';
      const tokenizer = Tokenizer();
      final tokens = tokenizer.tokenize(rule);
      final parser = SyntaxParser(tokens);

      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 3.0);
    });
  });
}
