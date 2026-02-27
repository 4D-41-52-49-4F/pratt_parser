import 'dart:math';

import 'package:abschlussprojekt/src/models/syntax_parser/_function_registry/_function_registry.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/syntax_parser.dart';
import 'package:abschlussprojekt/src/models/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  group('Test custom function', () {
    int customFunc(int a, int b, int c) {
      final result = (a * b / c).floor();
      return result;
    }

    setUpAll(() {
      FunctionRegistry.register('customFunc', (args) => customFunc(args[0], args[1], args[2]));
      FunctionRegistry.register('max', (args) => max(args[0], args[1]));
      FunctionRegistry.register('min', (args) => min(args[0], args[1]));
    });

    test('Custom function should return value 4', () {
      const args = [8, 1, 2];
      final result = customFunc(args[0], args[1], args[2]);

      expect(result, 4);
    });

    test('Expect same result from rule.', () {
      const rule = 'customFunc(8, 1, 2)';
      const tokenizer = Tokenizer();
      final tokens = tokenizer.tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 4);
    });

    test('Test deep custom function.', () {
      const rule = 'max(min(customFunc(8, 1, 2), 8), 1)';
      const tokenizer = Tokenizer();
      final tokens = tokenizer.tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 4);
    });
  });
}
