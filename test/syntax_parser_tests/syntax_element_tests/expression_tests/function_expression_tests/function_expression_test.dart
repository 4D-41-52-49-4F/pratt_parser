import 'package:abschlussprojekt/src/models/global_environment/_function_registry/function_registry.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('FunctionExpression tests', () {
    setUp(() {
      FunctionRegistry.register('echo', (args) => args.first);
      FunctionRegistry.register('sum', (args) => (args[0] as num) + (args[1] as num));
      FunctionRegistry.register('noArgs', (args) => 'ok');
    });

    test('Evaluates function with single parameter.', () {
      final param = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '10'));

      final expression = FunctionExpression(identifier: 'echo', parameter: [param]);

      expect(expression.evaluate(), 10);
    });

    test('Evaluates function with multiple parameters.', () {
      final p1 = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
      final p2 = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '7'));

      final expression = FunctionExpression(identifier: 'sum', parameter: [p1, p2]);

      expect(expression.evaluate(), 12);
    });

    test('Evaluates function with no parameters.', () {
      const expression = FunctionExpression(identifier: 'noArgs', parameter: []);

      expect(expression.evaluate(), 'ok');
    });

    test('Evaluates parameters before calling function.', () {
      final assignment = AssignmentExpression(
        identifier: 'x',
        operator: SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator,
        expression: SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3')),
      );

      FunctionRegistry.register('double', (args) => (args[0] as num) * 2);

      final expression = FunctionExpression(identifier: 'double', parameter: [assignment]);

      expect(expression.evaluate(), 6);
    });

    test('Throws exception if function is not registered.', () {
      final param = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '1'));

      final expression = FunctionExpression(identifier: 'unknownFunction', parameter: [param]);

      expect(expression.evaluate, throwsException);
    });

    test('toString returns readable representation.', () {
      final param = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));

      final expression = FunctionExpression(identifier: 'echo', parameter: [param]);

      expect(expression.toString(), contains('Function echo'));
      expect(expression.evaluate(), 5);
    });
  });

  group('FunctionExpression nested evaluation', () {
    setUp(() {
      FunctionRegistry.register('sum', (args) => (args[0] as num) + (args[1] as num));
      FunctionRegistry.register('double', (args) => (args[0] as num) * 2);
      FunctionRegistry.register('square', (args) => (args[0] as num) * (args[0] as num));
    });

    test('Nested function call: sum(2, double(3))', () {
      final two = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));

      final three = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3'));

      final doubleCall = FunctionExpression(identifier: 'double', parameter: [three]);

      final sumCall = FunctionExpression(identifier: 'sum', parameter: [two, doubleCall]);

      expect(sumCall.evaluate(), 8);
    });

    test('Deep nesting: double(sum(2, 3))', () {
      final two = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));

      final three = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3'));

      final sumCall = FunctionExpression(identifier: 'sum', parameter: [two, three]);

      final doubleCall = FunctionExpression(identifier: 'double', parameter: [sumCall]);

      expect(doubleCall.evaluate(), 10);
    });

    test('Multiple nested calls: square(double(3))', () {
      final three = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3'));

      final doubleCall = FunctionExpression(identifier: 'double', parameter: [three]);

      final squareCall = FunctionExpression(identifier: 'square', parameter: [doubleCall]);

      expect(squareCall.evaluate(), 36);
    });

    test('Nested calls inside multiple parameters: sum(double(2), square(3))', () {
      final two = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '2'));

      final three = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '3'));

      final doubleCall = FunctionExpression(identifier: 'double', parameter: [two]);

      final squareCall = FunctionExpression(identifier: 'square', parameter: [three]);

      final sumCall = FunctionExpression(identifier: 'sum', parameter: [doubleCall, squareCall]);

      expect(sumCall.evaluate(), 13);
    });
  });
}
