import 'package:abschlussprojekt/src/models/syntax_parser/_function_registry/_function_registry.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/_operator/syntax_operator.dart';
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

  void addParam(SyntaxExpression param) {
    parameter.add(param);
  }

  @override
  String toString() => 'Function $identifier($parameter)';
}

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
    if (evaluatedCondition is! bool) throw Exception('Condition must evaluate to a bool!');
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
