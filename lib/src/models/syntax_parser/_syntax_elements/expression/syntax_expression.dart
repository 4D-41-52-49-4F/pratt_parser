import 'package:abschlussprojekt/src/models/syntax_parser/_function_registry/_function_registry.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/tokenizer.dart';

sealed class SyntaxExpression {
  const SyntaxExpression();

  factory SyntaxExpression.literalFromToken(Token token) {
    return switch (token.type) {
      TokenType.stringLiteral => StringLiteral(token.value),
      TokenType.numeralLiteral => NumeralLiteral(int.parse(token.value)),
      TokenType.booleanLiteral => BooleanLiteral(bool.parse(token.value, caseSensitive: false)),
      TokenType.nullLiteral => NullLiteral(null),
      (_) => throw Exception('Unsupported literal type.'),
    };
  }

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

    final exception = _ExpressionExceptionHandler.getExceptionOfUnaryExpression(
      operator: operator,
      operand: evaluatedOperand,
    );

    if (exception != null) throw exception;

    return switch (operator) {
      NotOperator() => !evaluatedOperand,
      UnaryMinusOperator() => -evaluatedOperand,
    };
  }

  @override
  String toString() => '$runtimeType(operator: ${operator.symbol}, operand: $operand)';
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

    final exception = _ExpressionExceptionHandler.getExceptionOfBinaryExpression(
      operator: operator,
      leftOperand: evaluatedLeftOperand,
      rightOperand: evaluatedRightOperand,
    );

    if (exception != null) throw exception;

    return switch (operator) {
      MultiplicationOperator() => evaluatedLeftOperand * evaluatedRightOperand,
      DivisionOperator() => evaluatedLeftOperand / evaluatedRightOperand,
      ModuloOperator() => evaluatedLeftOperand % evaluatedRightOperand,
      PlusOperator() => evaluatedLeftOperand + evaluatedRightOperand,
      MinusOperator() => evaluatedLeftOperand - evaluatedRightOperand,
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
  String toString() => '$runtimeType(left: $leftOperand, operator: ${operator.symbol}, right: $rightOperand)';
}

final class TernaryExpression extends SyntaxExpression {
  final SyntaxExpression condition;
  final SyntaxExpression leftOperand;
  final SyntaxExpression rightOperand;

  const TernaryExpression({required this.condition, required this.leftOperand, required this.rightOperand});

  @override
  dynamic evaluate() {
    final evaluatedCondition = condition.evaluate();

    final exception = _ExpressionExceptionHandler.getExceptionOfTernaryExpression(condition: evaluatedCondition);

    if (exception != null) throw exception;

    return evaluatedCondition ? leftOperand.evaluate() : rightOperand.evaluate();
  }

  @override
  String toString() => '$runtimeType(condition: $condition ? left: $leftOperand : right: $rightOperand)';
}

sealed class SyntaxLiteral<T> extends SyntaxExpression {
  final T value;

  const SyntaxLiteral(this.value);

  @override
  T evaluate() => value;

  @override
  String toString() => '$runtimeType($value)';
}

final class BooleanLiteral extends SyntaxLiteral<bool> {
  const BooleanLiteral(super.value);
}

final class NumeralLiteral extends SyntaxLiteral<num> {
  const NumeralLiteral(super.value);
}

final class StringLiteral extends SyntaxLiteral<String> {
  const StringLiteral(super.value);
}

final class NullLiteral extends SyntaxLiteral<Null> {
  const NullLiteral(super.value);
}

class _ExpressionExceptionHandler {
  static Exception? getExceptionOfUnaryExpression({required UnaryOperator operator, required dynamic operand}) {
    if (operator is NotOperator) {
      if (operand is! bool) {
        return _UnaryException('Not operator negates a boolean value. Got: ${operand.runtimeType}');
      }
    }
    if (operator is UnaryMinusOperator) {
      if (operand is! num) {
        return _UnaryException('Unary minus operator negates a num value. Got: ${operand.runtimeType}');
      }
    }
    return null;
  }

  static Exception? getExceptionOfBinaryExpression({
    required BinaryOperator operator,
    required dynamic leftOperand,
    required dynamic rightOperand,
  }) {
    if (operator is ArithmeticOperator) {
      if (leftOperand is! num || rightOperand is! num) {
        return _ArithmeticException(
          'Wrong type(s) for arithmetic operation: left operand: ${leftOperand.runtimeType} ${operator.symbol} right operand: ${rightOperand.runtimeType} ',
        );
      }
      if ((operator is DivisionOperator || operator is ModuloOperator) && rightOperand == 0) {
        return _ArithmeticException('Right operand is 0 in a division context.');
      }
    }

    if (operator is RelationalOperator) {
      if (leftOperand is! num || rightOperand is! num) {
        return _RelationalException(
          'Relational operators need both values to be compareable (usually a type of num): left operand: ${leftOperand.runtimeType}, right operand: ${rightOperand.runtimeType} ',
        );
      }
    }
    if (operator is LogicalOperator) {
      if (leftOperand is! bool || rightOperand is! bool) {
        return _LogicalException(
          'Logical operators need both operands to be boolean. left operand: ${leftOperand.runtimeType} ${operator.symbol}, right operand: ${rightOperand.runtimeType} ',
        );
      }
    }

    return null;
  }

  static Exception? getExceptionOfTernaryExpression({dynamic condition}) {
    if (condition is! bool) {
      return _TernaryException('Condition must evaluate to bool. Got: ${condition.runtimeType}');
    }
    return null;
  }
}

final class _UnaryException implements Exception {
  final String message;
  const _UnaryException(this.message);

  @override
  String toString() => 'UnrayException: $message';
}

final class _ArithmeticException implements Exception {
  final String message;
  const _ArithmeticException(this.message);

  @override
  String toString() => 'ArithmeticException: $message';
}

final class _RelationalException implements Exception {
  final String message;
  const _RelationalException(this.message);

  @override
  String toString() => 'RelationalException: $message';
}

final class _LogicalException implements Exception {
  final String message;
  const _LogicalException(this.message);

  @override
  String toString() => 'LogicalException: $message';
}

final class _TernaryException implements Exception {
  final String message;
  const _TernaryException(this.message);

  @override
  String toString() => 'TernaryException: $message';
}
