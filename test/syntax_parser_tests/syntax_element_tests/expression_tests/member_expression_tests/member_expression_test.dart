import 'package:abschlussprojekt/src/models/global_environment/_variable_environment/variable_environment.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('MemberExpression tests', () {
    final state = VariableEnvironment.globalState;

    setUp(state.clear);

    test('Access simple property from object.', () {
      state['obj'] = {'name': 'Alice'};

      const objExpr = VariableExpression(identifier: 'obj');
      final propExpr = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'name'));

      final expression = MemberExpression(obj: objExpr, property: propExpr);

      expect(expression.evaluate(), 'Alice');
    });

    test('Access numeric property value.', () {
      state['obj'] = {'age': 30};

      const objExpr = VariableExpression(identifier: 'obj');
      final propExpr = SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'age'));

      final expression = MemberExpression(obj: objExpr, property: propExpr);

      expect(expression.evaluate(), 30);
    });

    test('Access nested property (obj.user.name).', () {
      state['obj'] = {
        'user': {'name': 'Bob'},
      };

      const objExpr = VariableExpression(identifier: 'obj');

      final userExpr = MemberExpression(
        obj: objExpr,
        property: SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'user')),
      );

      final nameExpr = MemberExpression(
        obj: userExpr,
        property: SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'name')),
      );

      expect(nameExpr.evaluate(), 'Bob');
    });

    test('Property determined by variable.', () {
      state['obj'] = {'x': 42};
      state['key'] = 'x';

      const objExpr = VariableExpression(identifier: 'obj');
      const propExpr = VariableExpression(identifier: 'key');

      const expression = MemberExpression(obj: objExpr, property: propExpr);

      expect(expression.evaluate(), 42);
    });

    test('Access deep nested structure.', () {
      state['obj'] = {
        'a': {
          'b': {'c': 100},
        },
      };

      final a = MemberExpression(
        obj: const VariableExpression(identifier: 'obj'),
        property: SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'a')),
      );

      final b = MemberExpression(
        obj: a,
        property: SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'b')),
      );

      final c = MemberExpression(
        obj: b,
        property: SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'c')),
      );

      expect(c.evaluate(), 100);
    });

    test('Missing property returns null.', () {
      state['obj'] = {'x': 1};

      final expression = MemberExpression(
        obj: const VariableExpression(identifier: 'obj'),
        property: SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'y')),
      );

      expect(expression.evaluate(), null);
    });

    test('Object assignment is evaluated before member access.', () {
      state['ignored'] = {'x': 5};

      final assignment = AssignmentExpression(
        identifier: 'obj',
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: const VariableExpression(identifier: 'ignored'),
      );

      final member = MemberExpression(
        obj: assignment,
        property: SyntaxLiteral.literalFromToken(const Token(TokenType.stringLiteral, 'x')),
      );

      final result = member.evaluate();

      expect(result, 5);
      expect(state['obj'], {'x': 5});
    });
  });
}
