import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/environment/environment.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/syntax_parser.dart';
import 'package:abschlussprojekt/src/models/tokenizer.dart';
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

    test('1. Deep Member Access vs. Multiplicative', () async {
      const rule = 'result = player.stats.hp + player.lvl * 5';
      final tokens = const Tokenizer().tokenize(rule);
      await SyntaxParser(tokens).parseSyntaxTree().evaluate();
      expect(VariableEnvironment.getValue('result'), 150);
    });

    test('2. Right-Associative Assignment with Arithmetic', () async {
      const rule = 'x = y = 2 + 3 * 4';
      final tokens = const Tokenizer().tokenize(rule);
      await SyntaxParser(tokens).parseSyntaxTree().evaluate();
      expect(VariableEnvironment.getValue('x'), 14);
      expect(VariableEnvironment.getValue('y'), 14);
    });

    test('3. Comparison Precedence in Ternary', () async {
      const rule = 'res = player.stats.hp > 50 ? 10 + 10 : 0';
      final tokens = const Tokenizer().tokenize(rule);
      await SyntaxParser(tokens).parseSyntaxTree().evaluate();
      expect(VariableEnvironment.getValue('res'), 20);
    });

    test('4. Member Access on Ternary Result', () async {
      const rule = 'val = 1 > 0 ? player.lvl : enemy.hp';
      final tokens = const Tokenizer().tokenize(rule);
      await SyntaxParser(tokens).parseSyntaxTree().evaluate();
      expect(VariableEnvironment.getValue('val'), 10);
    });

    test('5. Complex Logical Precedence', () async {
      const rule = 'logic = 10 > 5 && 5 < 2 || 1 == 1';
      final tokens = const Tokenizer().tokenize(rule);
      await SyntaxParser(tokens).parseSyntaxTree().evaluate();
      expect(VariableEnvironment.getValue('logic'), true);
    });

    test('6. Chained Member Access as Assignment Target', () async {
      const rule = 'player.stats.hp + 50 == 150';
      final tokens = const Tokenizer().tokenize(rule);
      final res = await SyntaxParser(tokens).parseSyntaxTree().evaluate();
      expect(res, true);
    });

    test('7. The "Nesting Hell" Test', () async {
      const rule = 'calc = (10 + 2) * ((5 - 3) + player.lvl / 2)';
      final tokens = const Tokenizer().tokenize(rule);
      await SyntaxParser(tokens).parseSyntaxTree().evaluate();
      expect(VariableEnvironment.getValue('calc'), 84);
    });

    test('8. Boolean Negation vs Member Access', () async {
      const rule = 'check = !enemy.isBoss';
      final tokens = const Tokenizer().tokenize(rule);
      await SyntaxParser(tokens).parseSyntaxTree().evaluate();
      expect(VariableEnvironment.getValue('check'), true);
    });

    test('9. Mixed Assignment and Comparison Side-Effect', () async {
      const rule = 'a = (b = 10) > 5';
      final tokens = const Tokenizer().tokenize(rule);
      await SyntaxParser(tokens).parseSyntaxTree().evaluate();
      expect(VariableEnvironment.getValue('a'), true);
      expect(VariableEnvironment.getValue('b'), 10);
    });

    test('10. Massive Multi-Level Evaluation', () async {
      const rule = 'x = player.items.potions > 0 && enemy.hp > 0 ? player.lvl * 2 : 0';
      final tokens = const Tokenizer().tokenize(rule);
      await SyntaxParser(tokens).parseSyntaxTree().evaluate();
      expect(VariableEnvironment.getValue('x'), 20);
    });
  });
}
