import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/syntax_element.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/syntax_operator.dart';

sealed class SyntaxExpression extends SyntaxElement {
  const SyntaxExpression();

  factory SyntaxExpression.fromString(String string) {
    final number = int.tryParse(string);
    if (number != null) return NumberLiteral(number);
    if (string == 'true') return BoolLiteral(true);
    if (string == 'false') return BoolLiteral(false);
    return StringLiteral(string);
  }

  dynamic evaluate();
}

sealed class FunctionExpression extends SyntaxExpression {}

final class UnaryExpression extends SyntaxExpression {
  final UnaryOperator operator;
  final SyntaxExpression operand;

  const UnaryExpression({required this.operator, required this.operand});

  @override
  bool evaluate() {
    final evaluatedOperand = operand.evaluate();
    return switch (operator) {
      NotOperator() => !evaluatedOperand,
    };
  }

  @override
  String toString() => '$runtimeType($operator, $operand)';
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
  String toString() => '$runtimeType($operator, $leftOperand, $rightOperand)';
}

final class TernaryExpression extends SyntaxExpression {
  final SyntaxExpression condition;
  final SyntaxExpression leftOperand;
  final SyntaxExpression rightOperand;

  const TernaryExpression({required this.condition, required this.leftOperand, required this.rightOperand});

  @override
  dynamic evaluate() {
    final evaluatedCondition = condition.evaluate();
    if (evaluatedCondition is! bool) throw Exception('Condition must evaluate to a bool!');
    return evaluatedCondition ? leftOperand.evaluate() : rightOperand.evaluate();
  }

  @override
  String toString() => '$runtimeType($condition, $leftOperand, $rightOperand)';
}

sealed class SyntaxLiteral<T> extends SyntaxExpression {
  final T value;

  const SyntaxLiteral(this.value);

  @override
  T evaluate() => value;

  @override
  String toString() => '$runtimeType($value)';
}

final class BoolLiteral extends SyntaxLiteral<bool> {
  const BoolLiteral(super.value);
}

final class NumberLiteral extends SyntaxLiteral<num> {
  const NumberLiteral(super.value);
}

final class StringLiteral extends SyntaxLiteral<String> {
  const StringLiteral(super.value);
}
