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

    test('Deep access: user.profile.points', () async {
      final rule = 'user.profile.points';
      final tokens = Tokenizer().tokenize(rule);
      final expression = SyntaxParser(tokens).parseSyntaxTree();

      // Erwarteter AST: Member(obj: Member(obj: Var(user), prop: "profile"), prop: "points")
      expect(await expression.evaluate(), 150);
    });

    test('Comparison of two map values: user.profile.points > config.thresholds.min_points', () async {
      final rule = 'user.profile.points > config.thresholds.min_points';
      final tokens = Tokenizer().tokenize(rule);
      final expression = SyntaxParser(tokens).parseSyntaxTree();

      // Dies kombiniert BinaryExpression mit zwei MemberExpressions
      final result = await expression.evaluate();
      expect(result, isTrue); // 150 > 100
    });

    test('Equality check between two distinct objects', () async {
      VariableEnvironment.addOrUpdateVariable('otherUser', {
        'profile': {'points': 150},
      });

      final rule = 'user.profile.points == otherUser.profile.points';
      final tokens = Tokenizer().tokenize(rule);
      final expression = SyntaxParser(tokens).parseSyntaxTree();

      expect(await expression.evaluate(), isTrue);
    });
  });
}
