import 'dart:math';

import 'package:abschlussprojekt/src/models/syntax_parser/_function_registry/_function_registry.dart';
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
      expect(expression.evaluate(), 10);
      expect(expression.evaluate() > 10, false);
    });

    test('Test string and null extraction', () {
      const rule2 = '"null" != null';
      const tokenizer = Tokenizer();
      final tokens2 = tokenizer.tokenize(rule2);
      final parser = SyntaxParser(tokens2);
      final expression = parser.parseSyntaxTree();

      print(expression);
      expect(expression.evaluate() is bool, true);
      expect(expression.evaluate(), true);
    });

    test('Bool extraction.', () {
      const rule3 = 'true && (true || false) == false';
      const tokenizer = Tokenizer();
      final tokens3 = tokenizer.tokenize(rule3);
      final parser = SyntaxParser(tokens3);
      final expression = parser.parseSyntaxTree();

      print(expression);
      expect(expression.evaluate(), false);
    });

    test('Ternary expression.', () {
      const rule4 = '7 * 3 > 21 ? "greater than 21" : "less or equal 21."';
      const tokenizer = Tokenizer();
      final tokens4 = tokenizer.tokenize(rule4);
      final parser = SyntaxParser(tokens4);
      final expression = parser.parseSyntaxTree();

      print(expression);
      expect(expression.evaluate(), 'less or equal 21.');
    });
  });
}
