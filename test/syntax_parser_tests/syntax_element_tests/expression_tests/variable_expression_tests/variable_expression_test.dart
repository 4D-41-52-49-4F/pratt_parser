import 'package:abschlussprojekt/src/models/global_environment/_variable_environment/variable_environment.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('VariableExpression tests', () {
    final state = VariableEnvironment.globalState;

    setUp(state.clear);

    test('Simple variable retrieval.', () {
      state['x'] = 10;

      const expr = VariableExpression(identifier: 'x');

      expect(expr.evaluate(), 10);
    });

    test('Variable storing string value.', () {
      state['name'] = 'Alice';

      const expr = VariableExpression(identifier: 'name');

      expect(expr.evaluate(), 'Alice');
    });

    test('Variable storing boolean value.', () {
      state['flag'] = true;

      const expr = VariableExpression(identifier: 'flag');

      expect(expr.evaluate(), true);
    });

    test('Variable referencing another SyntaxExpression.', () {
      final inner = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '42'));
      state['numExpr'] = inner;

      const expr = VariableExpression(identifier: 'numExpr');

      expect(expr.evaluate(), 42);
    });

    test('Variable referencing an AssignmentExpression.', () {
      final assignment = AssignmentExpression(
        identifier: 'y',
        expression: SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '99')),
      );

      state['assignExpr'] = assignment;

      const expr = VariableExpression(identifier: 'assignExpr');

      expect(expr.evaluate(), 99);
      expect(state['y'], 99);
    });

    test('Nested variable evaluation.', () {
      state['a'] = 5;
      state['b'] = const VariableExpression(identifier: 'a');
      state['c'] = const VariableExpression(identifier: 'b');

      const expr = VariableExpression(identifier: 'c');

      expect(expr.evaluate(), 5);
    });

    test('Accessing undefined variable throws.', () {
      const expr = VariableExpression(identifier: 'undefinedVar');

      expect(expr.evaluate, throwsException);
    });

    test('toString provides readable output.', () {
      const expr = VariableExpression(identifier: 'x');

      expect(expr.toString(), contains('VariableExpression(x)'));
    });
  });
}
