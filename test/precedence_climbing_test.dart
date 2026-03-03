import 'package:abschlussprojekt/src/models/global_environment/_variable_environment/variable_environment.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/syntax_parser.dart';
import 'package:test/test.dart';

void main() {
  group('Intensive Precedence & Member Access Stress Tests', () {
    setUp(() {
      VariableEnvironment.addOrUpdateVariable('player', {
        'lvl': 10,
        'stats': {'hp': 100, 'mp': 50},
        'items': {'potions': 5},
      });
      VariableEnvironment.addOrUpdateVariable('enemy', {'hp': 80, 'isBoss': false});
    });

    test('1. Deep Member Access vs. Multiplicative', () {
      const rule = 'result = player.stats.hp + player.lvl * 5';
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 150);
      expect(VariableEnvironment.getValue('result'), 150);
    });

    test('2. Right-Associative Assignment with Arithmetic', () {
      const rule = 'x = y = 2 + 3 * 4';
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 14);
      expect(VariableEnvironment.getValue('x'), 14);
      expect(VariableEnvironment.getValue('y'), 14);
    });

    test('3. Comparison Precedence in Ternary', () {
      const rule = 'res = player.stats.hp > 50 ? 10 + 10 : 0';
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 20);
      expect(VariableEnvironment.getValue('res'), 20);
    });

    test('4. Member Access on Ternary Result', () {
      const rule = 'val = 1 > 0 ? player.lvl : enemy.hp';
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 10);
      expect(VariableEnvironment.getValue('val'), 10);
    });

    test('5. Complex Logical Precedence', () {
      const rule = 'logic = 10 > 5 && 5 < 2 || 1 == 1';
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), true);
      expect(VariableEnvironment.getValue('logic'), true);
    });

    test('6. Chained Member Access as Assignment Target', () {
      const rule = 'player.stats.hp + 50 == 150';
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), true);
    });

    test('7. The "Nesting Hell" Test', () {
      const rule = 'calc = (10 + 2) * ((5 - 3) + player.lvl / 2)';
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 84);
      expect(VariableEnvironment.getValue('calc'), 84);
    });

    test('8. Boolean Negation vs Member Access', () {
      const rule = 'check = !enemy.isBoss';
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), true);
      expect(VariableEnvironment.getValue('check'), true);
    });

    test('9. Mixed Assignment and Comparison Side-Effect', () {
      const rule = 'a = (b = 10) > 5';
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), true);
      expect(VariableEnvironment.getValue('a'), true);
      expect(VariableEnvironment.getValue('b'), 10);
    });

    test('10. Massive Multi-Level Evaluation', () {
      const rule = 'x = player.items.potions > 0 && enemy.hp > 0 ? player.lvl * 2 : 0';
      final parser = SyntaxParser(rule);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 20);
      expect(VariableEnvironment.getValue('x'), 20);
    });
  });
}
