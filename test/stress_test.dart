import 'dart:math';

import 'package:abschlussprojekt/src/models/global_environment/_function_registry/function_registry.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/syntax_parser.dart';
import 'package:test/test.dart';

void main() {
  group('Stress Test: Deep Nesting', () {
    test('Very deep parenthesis nesting', () {
      const depth = 200;

      final buffer = StringBuffer();
      for (var i = 0; i < depth; i++) {
        buffer.write('(');
      }
      buffer.write('1');
      for (var i = 0; i < depth; i++) {
        buffer.write(')');
      }

      final rule = buffer.toString();
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 1);
    });

    test('Deep nested ternary expressions', () {
      const depth = 50;

      final buffer = StringBuffer();
      for (var i = 0; i < depth; i++) {
        buffer.write('true ? ');
      }
      buffer.write('1');
      for (var i = 0; i < depth; i++) {
        buffer.write(' : 0');
      }

      final rule = buffer.toString();
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 1);
    });
  });

  group('Stress Test: Large Expressions', () {
    test('Large chained addition (1000 terms)', () {
      final rule = List.generate(1000, (_) => '1').join(' + ');

      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 1000);
    });

    test('Large mixed arithmetic expression', () {
      final rule = List.generate(500, (i) => i.isEven ? '2 * 2' : '4 / 2').join(' + ');
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 1500);
    });
  });

  group('Stress Test: Whitespace & Formatting', () {
    test('Extreme whitespace variations', () {
      const rule = '   7   +    3   *    (  2 + 1   )   ';

      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 16);
    });

    test('Newlines and tabs', () {
      const rule = '''
      7 +
      3 *
      (2
      +
      1)
      ''';

      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 16);
    });
  });

  group('Stress Test: Function Calls', () {
    setUpAll(() {
      FunctionRegistry.register('max', (args) => max(args[0] as num, args[1] as num));
    });

    test('Deep nested function calls (correct)', () {
      const depth = 100;

      String rule = 'max(1, 2)';

      for (int i = 0; i < depth; i++) {
        rule = 'max($rule, 2)';
      }

      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 2);
    });

    test('Large number of function calls chained', () {
      final rule = List.generate(300, (_) => 'max(1,2)').join(' + ');

      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 600);
    });
  });

  group('Stress Test: Failure Resistance', () {
    test('Unbalanced parentheses should throw', () {
      const rule = '((1 + 2)';

      final parser = SyntaxParser(rule);

      expect(parser.parseSyntaxTree, throwsException);
    });

    test('Invalid operator sequence should throw', () {
      const rule = '7 + * 3';

      final parser = SyntaxParser(rule);

      expect(parser.parseSyntaxTree, throwsException);
    });

    test('Division by zero handling', () {
      const rule = '10 / 0';

      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate, throwsException);
    });

    test('Unexpected token should throw', () {
      const rule = 'hello + 3';

      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate, throwsException);
    });
  });

  group('Stress Test: Randomized Stability Smoke Test', () {
    test('Multiple random valid arithmetic expressions', () {
      final random = Random();

      for (var i = 0; i < 200; i++) {
        final a = random.nextInt(100);
        final b = random.nextInt(100);
        final c = random.nextInt(100);

        final rule = '$a + $b * $c';

        final parser = SyntaxParser(rule);
        final expression = parser.parseSyntaxTree();

        final result = expression.evaluate();

        expect(result, a + b * c);
      }
    });
  });
}
