import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/syntax_element.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/syntax_parser.dart';
import 'package:abschlussprojekt/src/models/token.dart';
import 'package:test/test.dart';

void main() {
  group('Test simple mathematical comparison. Result in the end should be false.', () {
    const rule = '7 + 3 < 10';
    const tokenizer = Tokenizer();
    const parser = SyntaxParser();
    final tokens = tokenizer.tokenize(rule);
    final elements = tokens.map((e) => SyntaxElement.fromToken(e)).toList();
    final expression = parser.parseSyntax(elements);

    test('Test tokens', () {
      print(tokens);
      expect(tokens.length, 5);
    });

    test('Test elements.', () {
      print(elements);
      expect(elements.length, 1);
    });

    test('Test expression.', () {
      print(expression);
      expect(expression is BinaryExpression, true);
      expect((expression as BinaryExpression).leftOperand is BinaryExpression, true);
    });

    test('Syntax evaluating', () {
      final value = expression.evaluate();
      expect(value is bool, true);
      expect(value, false);
    });
  });
  group('Test simple mathematical comparison. Result in the end should be true.', () {
    const rule = '7 + 3 == 10';
    const tokenizer = Tokenizer();
    const parser = SyntaxParser();
    final tokens = tokenizer.tokenize(rule);
    final elements = tokens.map((e) => SyntaxElement.fromToken(e)).toList();
    final expression = parser.parseSyntax(elements);

    test('Syntax evaluating', () {
      final value = expression.evaluate();
      expect(value is bool, true);
      expect(value, true);
    });
  });
}
