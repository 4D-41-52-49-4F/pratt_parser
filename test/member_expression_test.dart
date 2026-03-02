import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/environment/environment.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/syntax_parser.dart';
import 'package:abschlussprojekt/src/models/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  group('MemberExpression & Comparison Tests', () {
    setUp(() {
      VariableEnvironment.addOrUpdateVariable('user', {
        'id': 1,
        'profile': {'points': 150, 'rank': 'A'},
      });

      VariableEnvironment.addOrUpdateVariable('config', {
        'thresholds': {'min_points': 100},
      });
    });

    test('Deep access: user.profile.points', () {
      final rule = 'user.profile.points';
      final tokens = Tokenizer().tokenize(rule);
      final expression = SyntaxParser(tokens).parseSyntaxTree();

      expect(expression.evaluate(), 150);
    });

    test('Comparison of two map values: user.profile.points > config.thresholds.min_points', () {
      final rule = 'user.profile.points > config.thresholds.min_points';
      final tokens = Tokenizer().tokenize(rule);
      final expression = SyntaxParser(tokens).parseSyntaxTree();

      final result = expression.evaluate();
      expect(result, isTrue);
    });

    test('Equality check between two distinct objects', () {
      VariableEnvironment.addOrUpdateVariable('otherUser', {
        'profile': {'points': 150},
      });

      final rule = 'user.profile.points == otherUser.profile.points';
      final tokens = Tokenizer().tokenize(rule);
      final expression = SyntaxParser(tokens).parseSyntaxTree();

      expect(expression.evaluate(), isTrue);
    });
  });
}
