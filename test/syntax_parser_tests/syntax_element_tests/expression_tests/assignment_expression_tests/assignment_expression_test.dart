import 'package:abschlussprojekt/src/models/global_environment/_variable_environment/variable_environment.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
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

      final expression = AssignmentExpression(
        identifier: identifier,
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: literal,
      );

      expect(expression.evaluate(), 10);
      expect(state['x'], 10);
    });

    test('Assign string literal to variable.', () {
      const identifier = 'name';
      const token = Token(TokenType.stringLiteral, 'Alice');
      final literal = SyntaxLiteral.literalFromToken(token);

      final expression = AssignmentExpression(
        identifier: identifier,
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: literal,
      );

      expect(expression.evaluate(), 'Alice');
      expect(state['name'], 'Alice');
    });

    test('Assign boolean literal to variable.', () {
      const identifier = 'flag';
      const token = Token(TokenType.booleanLiteral, 'true');
      final literal = SyntaxLiteral.literalFromToken(token);

      final expression = AssignmentExpression(
        identifier: identifier,
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: literal,
      );

      expect(expression.evaluate(), true);
      expect(state['flag'], true);
    });

    test('Reassign variable with new value.', () {
      const identifier = 'x';

      const firstToken = Token(TokenType.numeralLiteral, '5');
      final firstLiteral = SyntaxLiteral.literalFromToken(firstToken);

      const secondToken = Token(TokenType.numeralLiteral, '20');
      final secondLiteral = SyntaxLiteral.literalFromToken(secondToken);

      final firstAssignment = AssignmentExpression(
        identifier: identifier,
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: firstLiteral,
      );
      final secondAssignment = AssignmentExpression(
        identifier: identifier,
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: secondLiteral,
      );

      firstAssignment.evaluate();
      secondAssignment.evaluate();

      expect(state['x'], 20);
    });

    test('Assignment returns assigned value.', () {
      const identifier = 'y';
      const token = Token(TokenType.numeralLiteral, '42');
      final literal = SyntaxLiteral.literalFromToken(token);

      final expression = AssignmentExpression(
        identifier: identifier,
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: literal,
      );

      final result = expression.evaluate();

      expect(result, 42);
      expect(state['y'], 42);
    });

    test('Multiple variables maintain independent values.', () {
      final xLiteral = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1'));
      final yLiteral = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));

      final xAssign = AssignmentExpression(
        identifier: 'x',
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: xLiteral,
      );
      final yAssign = AssignmentExpression(
        identifier: 'y',
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: yLiteral,
      );

      xAssign.evaluate();
      yAssign.evaluate();

      expect(state['x'], 1);
      expect(state['y'], 2);
    });

    test('Chained assignment works (a = b = 5).', () {
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));

      final assignB = AssignmentExpression(
        identifier: 'b',
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: literal,
      );

      final assignA = AssignmentExpression(
        identifier: 'a',
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: assignB,
      );

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

      final assignment = AssignmentExpression(
        identifier: 'result',
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: ternary,
      );

      final value = assignment.evaluate();

      expect(value, 1);
      expect(state['result'], 1);
    });

    test('Multiple variables keep independent values.', () {
      final xLiteral = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1'));
      final yLiteral = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));

      AssignmentExpression(
        identifier: 'x',
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: xLiteral,
      ).evaluate();
      AssignmentExpression(
        identifier: 'y',
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: yLiteral,
      ).evaluate();

      expect(state['x'], 1);
      expect(state['y'], 2);
    });
  });

  group('Simple AssignmentExpression Tests', () {
    final state = VariableEnvironment.globalState;

    setUp(state.clear);

    test('x = 5 stores value and returns it', () {
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expr = AssignmentExpression(
        identifier: 'x',
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: literal,
      );
      expect(expr.evaluate(), 5);
      expect(state['x'], 5);
    });

    test('reassign variable via simple assignment', () {
      state['x'] = 1;
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '10'));
      final expr = AssignmentExpression(
        identifier: 'x',
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: literal,
      );
      expect(expr.evaluate(), 10);
      expect(state['x'], 10);
    });

    test('return value is stored even when variable existed', () {
      state['y'] = 2;
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3'));
      final expr = AssignmentExpression(
        identifier: 'y',
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: literal,
      );
      final result = expr.evaluate();
      expect(result, 3);
      expect(state['y'], 3);
    });
  });

  group('Addition AssignmentExpression Tests (+=)', () {
    final state = VariableEnvironment.globalState;

    setUp(state.clear);

    test('x += 5 when x unset should behave like simple assignment', () {
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expr = AssignmentExpression(
        identifier: 'x',
        operator: SyntaxOperator.fromSymbol('+=') as AdditionAssignmentOperator,
        expression: literal,
      );
      expect(expr.evaluate(), 5);
      expect(state['x'], 5);
    });

    test('x += 5 when x exists adds to current value', () {
      state['x'] = 10;
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expr = AssignmentExpression(
        identifier: 'x',
        operator: SyntaxOperator.fromSymbol('+=') as AdditionAssignmentOperator,
        expression: literal,
      );
      expect(expr.evaluate(), 15);
      expect(state['x'], 15);
    });

    test('chained addition assignment works', () {
      state['a'] = 1;
      final lit1 = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));
      final assign1 = AssignmentExpression(
        identifier: 'a',
        operator: SyntaxOperator.fromSymbol('+=') as AdditionAssignmentOperator,
        expression: lit1,
      );
      final lit2 = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3'));
      final assign2 = AssignmentExpression(
        identifier: 'a',
        operator: SyntaxOperator.fromSymbol('+=') as AdditionAssignmentOperator,
        expression: lit2,
      );
      assign1.evaluate();
      assign2.evaluate();
      expect(state['a'], 6);
    });
  });

  group('Subtraction AssignmentExpression Tests (-=)', () {
    final state = VariableEnvironment.globalState;

    setUp(state.clear);

    test('x -= 5 when x unset should behave like simple assignment', () {
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expr = AssignmentExpression(
        identifier: 'x',
        operator: SyntaxOperator.fromSymbol('-=') as SubtractionAssignmentOperator,
        expression: literal,
      );
      expect(expr.evaluate(), -5);
      expect(state['x'], -5);
    });

    test('x -= 5 when x exists subtracts from current value', () {
      state['x'] = 10;
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expr = AssignmentExpression(
        identifier: 'x',
        operator: SyntaxOperator.fromSymbol('-=') as SubtractionAssignmentOperator,
        expression: literal,
      );
      expect(expr.evaluate(), 5);
      expect(state['x'], 5);
    });
  });

  group('Multiplication AssignmentExpression Tests (*=)', () {
    final state = VariableEnvironment.globalState;

    setUp(state.clear);

    test('x *= 5 when x unset should behave like simple assignment (x=0*5)', () {
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expr = AssignmentExpression(
        identifier: 'x',
        operator: SyntaxOperator.fromSymbol('*=') as MultiplicationAssignmentOperator,
        expression: literal,
      );
      expect(expr.evaluate(), 0);
      expect(state['x'], 0);
    });

    test('x *= 5 when x exists multiplies current value', () {
      state['x'] = 10;
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expr = AssignmentExpression(
        identifier: 'x',
        operator: SyntaxOperator.fromSymbol('*=') as MultiplicationAssignmentOperator,
        expression: literal,
      );
      expect(expr.evaluate(), 50);
      expect(state['x'], 50);
    });
  });

  group('Division AssignmentExpression Tests (/=)', () {
    final state = VariableEnvironment.globalState;

    setUp(state.clear);

    test('x /= 5 when x unset should behave like simple assignment (x=0/5)', () {
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expr = AssignmentExpression(
        identifier: 'x',
        operator: SyntaxOperator.fromSymbol('/=') as DivisionAssignmentOperator,
        expression: literal,
      );
      expect(expr.evaluate(), 0);
      expect(state['x'], 0);
    });

    test('x /= 5 when x exists divides current value', () {
      state['x'] = 20;
      final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final expr = AssignmentExpression(
        identifier: 'x',
        operator: SyntaxOperator.fromSymbol('/=') as DivisionAssignmentOperator,
        expression: literal,
      );
      expect(expr.evaluate(), 4);
      expect(state['x'], 4);
    });
  });
}
