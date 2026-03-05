import 'package:abschlussprojekt/src/models/global_environment/_variable_environment/variable_environment.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('AssignmentExpression tests', () {
    final state = VariableEnvironment.globalState;

    setUp(state.clear);

    test('Assign numeric literal to variable.', () {
      const identifier = 'x';
      const token = Token(TokenType.numeralLiteral, '10');
      final literal = SyntaxLiteral.literalFromToken(token);

      final expression = AssignmentExpression(identifier: identifier, expression: literal);

      expect(expression.evaluate(), 10);
      expect(state['x'], 10);
    });

    test('Assign string literal to variable.', () {
      const identifier = 'name';
      const token = Token(TokenType.stringLiteral, 'Alice');
      final literal = SyntaxLiteral.literalFromToken(token);

      final expression = AssignmentExpression(identifier: identifier, expression: literal);

      expect(expression.evaluate(), 'Alice');
      expect(state['name'], 'Alice');
    });

    test('Assign boolean literal to variable.', () {
      const identifier = 'flag';
      const token = Token(TokenType.booleanLiteral, 'true');
      final literal = SyntaxLiteral.literalFromToken(token);

      final expression = AssignmentExpression(identifier: identifier, expression: literal);

      expect(expression.evaluate(), true);
      expect(state['flag'], true);
    });

    test('Reassign variable with new value.', () {
      const identifier = 'x';

      const firstToken = Token(TokenType.numeralLiteral, '5');
      final firstLiteral = SyntaxLiteral.literalFromToken(firstToken);

      const secondToken = Token(TokenType.numeralLiteral, '20');
      final secondLiteral = SyntaxLiteral.literalFromToken(secondToken);

      final firstAssignment = AssignmentExpression(identifier: identifier, expression: firstLiteral);
      final secondAssignment = AssignmentExpression(identifier: identifier, expression: secondLiteral);

      firstAssignment.evaluate();
      secondAssignment.evaluate();

      expect(state['x'], 20);
    });

    test('Assignment returns assigned value.', () {
      const identifier = 'y';
      const token = Token(TokenType.numeralLiteral, '42');
      final literal = SyntaxLiteral.literalFromToken(token);

      final expression = AssignmentExpression(identifier: identifier, expression: literal);

      final result = expression.evaluate();

      expect(result, 42);
      expect(state['y'], 42);
    });

    test('Multiple variables maintain independent values.', () {
      final xLiteral = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1'));
      final yLiteral = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));

      final xAssign = AssignmentExpression(identifier: 'x', expression: xLiteral);
      final yAssign = AssignmentExpression(identifier: 'y', expression: yLiteral);

      xAssign.evaluate();
      yAssign.evaluate();

      expect(state['x'], 1);
      expect(state['y'], 2);
    });

    test('Chained assignment works (a = b = 5).', () {
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));

      final assignB = AssignmentExpression(identifier: 'b', expression: literal);

      final assignA = AssignmentExpression(identifier: 'a', expression: assignB);

      final result = assignA.evaluate();

      expect(result, 5);
      expect(state['a'], 5);
      expect(state['b'], 5);
    });

    test('Assignment from ternary expression.', () {
      final condition = SyntaxLiteral.literalFromToken(const Token(TokenType.booleanLiteral, 'true'));

      final trueCase = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1'));

      final falseCase = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));

      final ternary = TernaryExpression(condition: condition, trueCase: trueCase, falseCase: falseCase);

      final assignment = AssignmentExpression(identifier: 'result', expression: ternary);

      final value = assignment.evaluate();

      expect(value, 1);
      expect(state['result'], 1);
    });

    test('Multiple variables keep independent values.', () {
      final xLiteral = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1'));
      final yLiteral = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));

      AssignmentExpression(identifier: 'x', expression: xLiteral).evaluate();
      AssignmentExpression(identifier: 'y', expression: yLiteral).evaluate();

      expect(state['x'], 1);
      expect(state['y'], 2);
    });
  });
}
