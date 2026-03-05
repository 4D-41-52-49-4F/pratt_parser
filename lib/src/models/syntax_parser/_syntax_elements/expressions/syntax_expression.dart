import 'dart:math';

import 'package:abschlussprojekt/src/models/global_environment/_function_registry/function_registry.dart';
import 'package:abschlussprojekt/src/models/global_environment/_variable_environment/variable_environment.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';

sealed class SyntaxExpression {
  const SyntaxExpression();

  dynamic evaluate();
}

final class FunctionExpression extends SyntaxExpression {
  final String identifier;
  final List<SyntaxExpression> parameter;

  const FunctionExpression({required this.identifier, required this.parameter});

  @override
  dynamic evaluate() {
    return FunctionRegistry.resolve(identifier, parameter.map((e) => e.evaluate()).toList());
  }

  @override
  String toString() => 'Function $identifier($parameter)';
}

final class UnaryExpression extends SyntaxExpression {
  final UnaryOperator operator;
  final SyntaxExpression operand;

  const UnaryExpression({required this.operator, required this.operand});

  @override
  dynamic evaluate() {
    final evaluatedOperand = operand.evaluate();

    _ExpressionValidator.validateUnary(operator: operator, operand: evaluatedOperand);

    return switch (operator) {
      NotOperator() => !evaluatedOperand,
      UnaryMinusOperator() => -evaluatedOperand,
    };
  }

  @override
  String toString() => 'UnaryExpression(operator: ${operator.symbol}, operand: $operand)';
}

final class BinaryExpression extends SyntaxExpression {
  final BinaryOperator operator;
  final SyntaxExpression leftOperand;
  final SyntaxExpression rightOperand;

  const BinaryExpression({required this.operator, required this.leftOperand, required this.rightOperand});

  @override
  evaluate() {
    final evaluatedLeftOperand = leftOperand.evaluate();
    final evaluatedRightOperand = rightOperand.evaluate();

    _ExpressionValidator.validateBinary(
      operator: operator,
      leftOperand: evaluatedLeftOperand,
      rightOperand: evaluatedRightOperand,
    );

    return switch (operator) {
      ExponentOperator() => pow(evaluatedLeftOperand, evaluatedRightOperand),
      MultiplicationOperator() => evaluatedLeftOperand * evaluatedRightOperand,
      DivisionOperator() => evaluatedLeftOperand / evaluatedRightOperand,
      ModuloOperator() => evaluatedLeftOperand % evaluatedRightOperand,
      AdditionOperator() => evaluatedLeftOperand + evaluatedRightOperand,
      SubtractionOperator() => evaluatedLeftOperand - evaluatedRightOperand,
      LessThanOperator() => evaluatedLeftOperand < evaluatedRightOperand,
      LessThanOrEqualOperator() => evaluatedLeftOperand <= evaluatedRightOperand,
      GreaterThanOperator() => evaluatedLeftOperand > evaluatedRightOperand,
      GreaterThanOrEqualOperator() => evaluatedLeftOperand >= evaluatedRightOperand,
      EqualOperator() => evaluatedLeftOperand == evaluatedRightOperand,
      NotEqualOperator() => evaluatedLeftOperand != evaluatedRightOperand,
      AndOperator() => evaluatedLeftOperand && evaluatedRightOperand,
      OrOperator() => evaluatedLeftOperand || evaluatedRightOperand,
    };
  }

  @override
  String toString() => 'BinaryExpression(left: $leftOperand, operator: ${operator.symbol}, right: $rightOperand)';
}

final class TernaryExpression extends SyntaxExpression {
  final SyntaxExpression condition;
  final SyntaxExpression trueCase;
  final SyntaxExpression falseCase;

  const TernaryExpression({required this.condition, required this.trueCase, required this.falseCase});

  @override
  dynamic evaluate() {
    final evaluatedCondition = condition.evaluate();
    _ExpressionValidator.validateTernary(condition: evaluatedCondition);

    return evaluatedCondition ? trueCase.evaluate() : falseCase.evaluate();
  }

  @override
  String toString() => 'TernaryExpression(condition: $condition ? left: $trueCase : right: $falseCase)';
}

final class VariableExpression extends SyntaxExpression {
  final String identifier;

  const VariableExpression({required this.identifier});

  @override
  dynamic evaluate() {
    _ExpressionValidator.validateVariableExpression(identifier: identifier);

    final value = VariableEnvironment.getValue(identifier);
    return value is SyntaxExpression ? value.evaluate() : value;
  }

  @override
  String toString() => 'VariableExpression($identifier)';
}

final class AssignmentExpression extends VariableExpression {
  final SyntaxExpression expression;

  const AssignmentExpression({required super.identifier, required this.expression});

  @override
  dynamic evaluate() {
    final evaluatedExpression = expression.evaluate();

    VariableEnvironment.addOrUpdateVariable(identifier, evaluatedExpression);

    return evaluatedExpression;
  }

  @override
  String toString() => 'AssignmentExpression($identifier = $expression)';
}

final class MemberExpression extends SyntaxExpression {
  final SyntaxExpression obj;
  final SyntaxExpression property;

  const MemberExpression({required this.obj, required this.property});

  @override
  dynamic evaluate() {
    final left = obj.evaluate();
    final evaluatedProperty = property.evaluate();

    return left[evaluatedProperty];
  }

  @override
  String toString() => '$runtimeType($obj.$property)';
}

sealed class SyntaxLiteral<T> extends SyntaxExpression {
  final T value;

  const SyntaxLiteral(this.value);

  static SyntaxLiteral<dynamic> literalFromToken(Token token, {bool identifierAsString = false}) =>
      switch (token.type) {
        TokenType.stringLiteral => _StringLiteral._(token.lexeme),
        TokenType.identifier => identifierAsString ? _StringLiteral._(token.lexeme) : throw _unsupported(),
        TokenType.numeralLiteral => _NumeralLiteral._(num.parse(token.lexeme)),
        TokenType.booleanLiteral => _BooleanLiteral._(bool.parse(token.lexeme, caseSensitive: false)),
        TokenType.nullLiteral => const _NullLiteral._(null),
        (_) => throw _unsupported(),
      };

  static Exception _unsupported() => Exception('Unsupported literal type.');

  @override
  T evaluate() => value;

  @override
  String toString() => '$runtimeType($value)';
}

final class _BooleanLiteral extends SyntaxLiteral<bool> {
  const _BooleanLiteral._(super.value);
}

final class _NumeralLiteral extends SyntaxLiteral<num> {
  const _NumeralLiteral._(super.value);
}

final class _StringLiteral extends SyntaxLiteral<String> {
  const _StringLiteral._(super.value);
}

final class _NullLiteral extends SyntaxLiteral<Null> {
  const _NullLiteral._(super.value);
}

class _ExpressionValidator {
  static void validateUnary({required UnaryOperator operator, required dynamic operand}) {
    if (operator is NotOperator) {
      if (operand is! bool) {
        throw _UnaryException('Not operator negates a boolean value. Got: ${operand.runtimeType}');
      }
    }
    if (operator is UnaryMinusOperator) {
      if (operand is! num) {
        throw _UnaryException('Unary minus operator negates a num value. Got: ${operand.runtimeType}');
      }
    }
  }

  static void validateBinary({
    required BinaryOperator operator,
    required dynamic leftOperand,
    required dynamic rightOperand,
  }) {
    if (operator is ArithmeticOperator) {
      if (leftOperand is! num || rightOperand is! num) {
        throw _ArithmeticException(
          'Wrong type(s) for arithmetic operation: left operand: ${leftOperand.runtimeType} ${operator.symbol} right operand: ${rightOperand.runtimeType} ',
        );
      }
      if ((operator is DivisionOperator || operator is ModuloOperator) && rightOperand == 0) {
        throw const _ArithmeticException('Right operand is 0 in a division context.');
      }
    }

    if (operator is RelationalOperator) {
      if (leftOperand is! num || rightOperand is! num) {
        throw _RelationalException(
          'Relational operators need both values to be compareable (a type of num): left operand: ${leftOperand.runtimeType}, right operand: ${rightOperand.runtimeType} ',
        );
      }
    }
    if (operator is LogicalOperator) {
      if (leftOperand is! bool || rightOperand is! bool) {
        throw _LogicalException(
          'Logical operators need both operands to be boolean. left operand: ${leftOperand.runtimeType} ${operator.symbol}, right operand: ${rightOperand.runtimeType} ',
        );
      }
    }
  }

  static void validateTernary({required dynamic condition}) {
    if (condition is! bool) {
      throw _TernaryException('Condition must evaluate to bool. Got: ${condition.runtimeType}');
    }
  }

  static void validateVariableExpression({required String identifier}) {
    final value = VariableEnvironment.getValue(identifier);
    if (value == null) throw const _VariableException('Variable not Initialized.');
  }
}

final class _UnaryException implements Exception {
  final String message;
  const _UnaryException(this.message);

  @override
  String toString() => '_UnaryException: $message';
}

final class _ArithmeticException implements Exception {
  final String message;
  const _ArithmeticException(this.message);

  @override
  String toString() => '_ArithmeticException: $message';
}

final class _RelationalException implements Exception {
  final String message;
  const _RelationalException(this.message);

  @override
  String toString() => '_RelationalException: $message';
}

final class _LogicalException implements Exception {
  final String message;
  const _LogicalException(this.message);

  @override
  String toString() => '_LogicalException: $message';
}

final class _TernaryException implements Exception {
  final String message;
  const _TernaryException(this.message);

  @override
  String toString() => '_TernaryException: $message';
}

final class _VariableException implements Exception {
  final String message;
  const _VariableException(this.message);

  @override
  String toString() => '_VariableException: $message';
}

// final class _MemberException implements Exception {
//   final String message;
//   const _MemberException(this.message);

//   @override
//   String toString() => '_MemberException: $message';
// }
