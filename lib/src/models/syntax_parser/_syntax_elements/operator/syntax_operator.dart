enum Associativity { left, right }

sealed class SyntaxOperator {
  final String symbol;
  final int precedence;
  final Associativity associativity;

  const SyntaxOperator({required this.symbol, required this.precedence, required this.associativity});

  factory SyntaxOperator.fromSymbol(String symbol) => switch (symbol) {
    '.' => const DotOperator._(),
    '^' => const ExponentOperator._(),
    '*' => const MultiplicationOperator._(),
    '/' => const DivisionOperator._(),
    '%' => const ModuloOperator._(),
    '+' => const AdditionOperator._(),
    '-' => const SubtractionOperator._(),
    '<' => const LessThanOperator._(),
    '<=' => const LessThanOrEqualOperator._(),
    '>' => const GreaterThanOperator._(),
    '>=' => const GreaterThanOrEqualOperator._(),
    '==' => const EqualOperator._(),
    '!=' => const NotEqualOperator._(),
    '&&' => const AndOperator._(),
    '||' => const OrOperator._(),
    '?' => const ConditionOperator._(),
    ':' => const ElseOperator._(),
    '=' => const AssignmentOperator._(),
    (_) => throw Exception('Operator not defined: $symbol'),
  };

  @override
  String toString() => 'SyntaxOperator($symbol, $precedence, $associativity)';
}

sealed class UnaryOperator extends SyntaxOperator {
  const UnaryOperator({required super.symbol, required super.precedence, required super.associativity});

  factory UnaryOperator.fromSymbol(String symbol) => switch (symbol) {
    '!' => const NotOperator._(),
    '-' => const UnaryMinusOperator._(),
    (_) => throw Exception('Unexpected binary operator: $symbol'),
  };
}

sealed class BinaryOperator extends SyntaxOperator {
  const BinaryOperator({required super.symbol, required super.precedence, required super.associativity});
}

sealed class TernaryOperator extends SyntaxOperator {
  const TernaryOperator({required super.symbol, required super.precedence, required super.associativity});
}

sealed class ArithmeticOperator extends BinaryOperator {
  const ArithmeticOperator({required super.symbol, required super.precedence, required super.associativity});
}

sealed class RelationalOperator extends BinaryOperator {
  const RelationalOperator({required super.symbol, required super.precedence, required super.associativity});
}

sealed class EqualityOperator extends BinaryOperator {
  const EqualityOperator({required super.symbol, required super.precedence, required super.associativity});
}

sealed class LogicalOperator extends BinaryOperator {
  const LogicalOperator({required super.symbol, required super.precedence, required super.associativity});
}

final class DotOperator extends SyntaxOperator {
  const DotOperator._() : super(symbol: '.', precedence: 9, associativity: Associativity.right);
}

final class NotOperator extends UnaryOperator {
  const NotOperator._() : super(symbol: '!', precedence: 8, associativity: Associativity.right);
}

final class UnaryMinusOperator extends UnaryOperator {
  const UnaryMinusOperator._() : super(symbol: '-', precedence: 8, associativity: Associativity.right);
}

final class ExponentOperator extends ArithmeticOperator {
  const ExponentOperator._() : super(symbol: '^', precedence: 7, associativity: Associativity.right);
}

final class MultiplicationOperator extends ArithmeticOperator {
  const MultiplicationOperator._() : super(symbol: '*', precedence: 7, associativity: Associativity.left);
}

final class DivisionOperator extends ArithmeticOperator {
  const DivisionOperator._() : super(symbol: '/', precedence: 7, associativity: Associativity.left);
}

final class ModuloOperator extends ArithmeticOperator {
  const ModuloOperator._() : super(symbol: '%', precedence: 7, associativity: Associativity.left);
}

final class AdditionOperator extends ArithmeticOperator {
  const AdditionOperator._() : super(symbol: '+', precedence: 6, associativity: Associativity.left);
}

final class SubtractionOperator extends ArithmeticOperator {
  const SubtractionOperator._() : super(symbol: '-', precedence: 6, associativity: Associativity.left);
}

final class LessThanOperator extends RelationalOperator {
  const LessThanOperator._() : super(symbol: '<', precedence: 5, associativity: Associativity.left);
}

final class LessThanOrEqualOperator extends RelationalOperator {
  const LessThanOrEqualOperator._() : super(symbol: '<=', precedence: 5, associativity: Associativity.left);
}

final class GreaterThanOperator extends RelationalOperator {
  const GreaterThanOperator._() : super(symbol: '>', precedence: 5, associativity: Associativity.left);
}

final class GreaterThanOrEqualOperator extends RelationalOperator {
  const GreaterThanOrEqualOperator._() : super(symbol: '>=', precedence: 5, associativity: Associativity.left);
}

final class EqualOperator extends EqualityOperator {
  const EqualOperator._() : super(symbol: '==', precedence: 4, associativity: Associativity.left);
}

final class NotEqualOperator extends EqualityOperator {
  const NotEqualOperator._() : super(symbol: '!=', precedence: 4, associativity: Associativity.left);
}

final class AndOperator extends LogicalOperator {
  const AndOperator._() : super(symbol: '&&', precedence: 3, associativity: Associativity.left);
}

final class OrOperator extends LogicalOperator {
  const OrOperator._() : super(symbol: '||', precedence: 2, associativity: Associativity.left);
}

final class ConditionOperator extends TernaryOperator {
  const ConditionOperator._() : super(symbol: '?', precedence: 1, associativity: Associativity.right);
}

final class ElseOperator extends TernaryOperator {
  const ElseOperator._() : super(symbol: ':', precedence: 1, associativity: Associativity.right);
}

final class AssignmentOperator extends SyntaxOperator {
  const AssignmentOperator._() : super(symbol: '=', precedence: 0, associativity: Associativity.right);
}
