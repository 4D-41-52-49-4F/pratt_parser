import 'dart:math';

import 'package:abschlussprojekt/src/models/syntax_parser/_function_registry/_function_registry.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/_expression/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/syntax_parser.dart';
import 'package:abschlussprojekt/src/models/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  group('Arithmetic Expressions', () {
    test('Operator precedence (multiplication before addition)', () {
      const rule = '7 + 3 * 2';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(tokens.isNotEmpty, true);
      expect(expression.evaluate(), 13);
    });

    test('Parentheses override precedence', () {
      const rule = '(7 + 3) * 2';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 20);
    });

    test('Nested arithmetic expressions', () {
      const rule = '((2 + 3) * (4 - 1)) / 5';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 3);
    });
  });

  group('Comparison Operators', () {
    test('Less than should evaluate false', () {
      const rule = '7 + 3 < 10';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), false);
    });

    test('Equality should evaluate true', () {
      const rule = '7 + 3 == 10';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), true);
    });

    test('Greater than with arithmetic', () {
      const rule = '5 * 5 > 20';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), true);
    });
  });

  group('Logical Operators', () {
    test('AND / OR precedence', () {
      const rule = 'true && false || true';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), true);
    });

    test('Logical grouping with parentheses', () {
      const rule = 'true && (false || false)';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), false);
    });

    test('Equality inside logical expression', () {
      const rule = 'true && (true || false) == false';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), false);
    });
  });

  group('Function Handling', () {
    setUpAll(() {
      FunctionRegistry.register('max', (args) => max(args[0] as num, args[1] as num));
      FunctionRegistry.register('min', (args) => min(args[0] as num, args[1] as num));
    });

    test('Nested function calls', () {
      const rule = 'max(min(7, (3 + 1) * 2), 2 * (3 + 2))';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 10);
    });

    test('Function inside comparison', () {
      const rule = 'max(5, 10) == 10';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), true);
    });
  });

  group('Literal Handling', () {
    test('String vs null comparison', () {
      const rule = '"null" != null';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), true);
    });

    test('Boolean literal evaluation', () {
      const rule = 'true == false';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), false);
    });

    test('Null equality', () {
      const rule = 'null == null';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), true);
    });
  });

  group('Ternary Expressions', () {
    test('Simple ternary', () {
      const rule = '10 > 5 ? "yes" : "no"';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 'yes');
    });

    test('Nested ternary', () {
      const rule = '7 * 3 > 21 ? "greater" : 7 * 3 == 21 ? "equal" : "less"';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 'equal');
    });

    test('Ternary with logical condition', () {
      const rule = 'true && false ? 1 : 2';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 2);
    });

    test('Ternary with boolean literal', () {
      const rule = 'true ? 1 : 2';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 1);
    });

    test('Ternary with string literal', () {
      const rule = '"true" ? 1 : 2';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(() => expression.evaluate(), throwsException);
    });
  });

  group('AST Structure Validation', () {
    test('BinaryExpression structure for arithmetic comparison', () {
      const rule = '7 + 3 == 10';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression is BinaryExpression, true);

      final binary = expression as BinaryExpression;
      expect(binary.leftOperand is BinaryExpression, true);
    });
  });

  group('Progressive Negative Expression Tests', () {
    test('Unary minus on positive number', () {
      const rule = '-5';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), -5);
    });

    test('Double unary minus', () {
      const rule = '--7';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 7);
    });

    test('Unary minus with addition', () {
      const rule = '-3 + 5';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 2);
    });

    test('Unary minus with multiplication', () {
      const rule = '-2 * 4';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), -8);
    });

    test('Unary minus with parentheses', () {
      const rule = '-(3 + 2) * 2';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), -10);
    });

    test('Negative number less than zero', () {
      const rule = '-5 < 0';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), true);
    });

    test('Negative multiplication with comparison', () {
      const rule = '-3 * 4 > -15';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), true);
    });

    test('Negative numbers with AND', () {
      const rule = '(-3 < 0) && (-5 > -10)';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), true);
    });

    test('Negative numbers with OR', () {
      const rule = '(-3 > 0) || (-5 < -1)';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), true);
    });

    test('Negative numbers in ternary expression', () {
      const rule = '-3 > -5 ? -2 : -7';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), -2);
    });

    test('Nested ternary with negative numbers', () {
      const rule = '-3 > -2 ? -5 : -1 > -2 ? -2 : -3';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), -2);
    });

    test('Nested parentheses with negatives', () {
      const rule = '(-2 + (-3 * (4 - (-1))))';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), -17);
    });

    test('Multiple unary minus and binary operators', () {
      const rule = '-(-3 + 5) * (-2 + 1)';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 2);
    });

    setUpAll(() {
      FunctionRegistry.register('max', (args) => max(args[0] as num, args[1] as num));
      FunctionRegistry.register('min', (args) => min(args[0] as num, args[1] as num));
    });

    test('Negative numbers in max/min functions', () {
      const rule = 'max(-3, min(-5, -1 * 2))';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), -3);
    });

    test('Nested functions with negative arithmetic', () {
      const rule = 'min(max(-2, -7 + 5), -3 * 2)';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), -6);
    });
  });
}
