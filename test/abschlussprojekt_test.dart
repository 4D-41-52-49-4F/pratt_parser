import 'dart:math';

import 'package:abschlussprojekt/src/models/syntax_parser/_function_registry/_function_registry.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/syntax_element.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/_expression/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/syntax_parser.dart';
import 'package:abschlussprojekt/src/models/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  group('Test simple mathematical comparison. Result in the end should be false.', () {
    const rule = '7 + 3 < 10';
    const tokenizer = Tokenizer();
    final tokens = tokenizer.tokenize(rule);
    final parser = SyntaxParser(tokens);
    final expression = parser.parseSyntaxTree();

    test('Test tokens', () {
      expect(tokens.length, 5);
    });

    test('Test expression.', () {
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
    final tokens = tokenizer.tokenize(rule);
    final parser = SyntaxParser(tokens);
    final elements = tokens.map((e) => SyntaxElement.fromToken(e)).toList();
    final expression = parser.parseSyntaxTree();

    test('Syntax evaluating', () {
      final value = expression.evaluate();
      expect(value is bool, true);
      expect(value, true);
    });
  });

  group('Test extraction of Function identifiers and arguments.', () {
    FunctionRegistry.register('max', (args) => max(args[0] as num, args[1] as num));
    FunctionRegistry.register('min', (args) => min(args[0] as num, args[1] as num));

    const rule1 = 'max(min(7, (3 + 1) * 2), 2 * (3 + 2))';
    const tokenizer = Tokenizer();
    final tokens1 = tokenizer.tokenize(rule1);
    final parser = SyntaxParser(tokens1);
    final expression = parser.parseSyntaxTree();
    test('Test if tokenizing works properly.', () {
      print(expression);
      print(expression.evaluate());
    });
  });
}
