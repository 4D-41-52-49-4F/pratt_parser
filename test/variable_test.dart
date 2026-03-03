import 'package:abschlussprojekt/src/models/global_environment/_variable_environment/variable_environment.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/syntax_parser.dart';
import 'package:test/test.dart';

void main() {
  group('Variable Assignment & Scope', () {
    test('Simple assignment returns value', () {
      const rule = 'a = 10';
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 10);
    });

    test('Variable persistence in environment', () {
      const rule = 'x = 42';
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();
      expression.evaluate();

      final value = VariableEnvironment.getValue('x');

      expect(value, 42);
    });

    test('Using assigned variable in arithmetic', () {
      const rule1 = 'y = 5';
      SyntaxParser(rule1).parseSyntaxTree().evaluate();

      const rule2 = 'y * 10';
      final expression = SyntaxParser(rule2).parseSyntaxTree();

      expect(expression.evaluate(), 50);
    });

    test('Chained assignments', () {
      const rule = 'a = b = 5';
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expression.evaluate();

      final valueA = VariableEnvironment.getValue('a');
      final valueB = VariableEnvironment.getValue('b');

      expect(valueA, 5);
      expect(valueB, 5);
    });

    test('Complex expression assignment', () {
      const rule = 'result = (10 + 5) * 2';
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expression.evaluate();

      expect(VariableEnvironment.getValue('result'), 30);
    });

    test('Precedence climbing test.', () {
      const rule = 'result = 10 + 5 * 2';
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expression.evaluate();

      expect(VariableEnvironment.getValue('result'), 20);
    });

    test('Ternary assignment.', () {
      const rule = 'a = 7 > 5 ? "7 bigger 5" : "7 less/equal 5"';
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expression.evaluate();

      expect(VariableEnvironment.getValue('a'), '7 bigger 5');
    });

    test('Reassignment of existing variable', () {
      VariableEnvironment.addOrUpdateVariable('counter', 1);

      const rule = 'counter = counter + 1';
      final expression = SyntaxParser(rule).parseSyntaxTree();

      expression.evaluate();
      expect(VariableEnvironment.getValue('counter'), 2);
    });
  });

  group('Variable Assignment Stress Tests', () {
    test('Deeply nested chained assignments (Right-to-Left)', () {
      const rule = 'a = b = c = d = 100';
      final expression = SyntaxParser(rule).parseSyntaxTree();

      expression.evaluate();

      expect(VariableEnvironment.getValue('a'), 100);
      expect(VariableEnvironment.getValue('b'), 100);
      expect(VariableEnvironment.getValue('c'), 100);
      expect(VariableEnvironment.getValue('d'), 100);
    });

    test('Assignment within arithmetic (Side effects)', () {
      const rule = '(10 + (x = 5)) * x';
      final expression = SyntaxParser(rule).parseSyntaxTree();

      final result = expression.evaluate();

      expect(result, 75);
      expect(VariableEnvironment.getValue('x'), 5);
    });

    test('Reassignment with different types (Type juggling)', () {
      final steps = ['val = 10', 'val = "Hallo"', 'val = true'];

      for (var rule in steps) {
        SyntaxParser(rule).parseSyntaxTree().evaluate();
      }

      expect(VariableEnvironment.getValue('val'), true);
    });

    test('Mathematical precedence with variable updates', () {
      VariableEnvironment.addOrUpdateVariable('x', 2);
      VariableEnvironment.addOrUpdateVariable('y', 3);

      const rule = 'z = x = y = x + y * 10';
      SyntaxParser(rule).parseSyntaxTree().evaluate();

      expect(VariableEnvironment.getValue('z'), 32);
      expect(VariableEnvironment.getValue('x'), 32);
      expect(VariableEnvironment.getValue('y'), 32);
    });

    test('Extremely long variable names and whitespace', () {
      const longName = 'this_is_a_very_long_variable_name_with_underscores_123';
      const rule = '   $longName    =    (  100  /  2  )   ';

      SyntaxParser(rule).parseSyntaxTree().evaluate();

      expect(VariableEnvironment.getValue(longName), 50);
    });

    test('Shadowing / Overwriting Global with Local logic', () {
      final rules = ['a = 1', 'a = a + a', 'a = a * a'];
      for (final r in rules) {
        SyntaxParser(r).parseSyntaxTree().evaluate();
      }

      expect(VariableEnvironment.getValue('a'), 4);
    });
  });
}
