enum Associativity { left, right }

sealed class SyntaxOperator {
  final String symbol;
  final int precedence;
  final Associativity associativity;

  const SyntaxOperator({required this.symbol, required this.precedence, required this.associativity});

  factory SyntaxOperator.fromSymbol(String symbol) => switch (symbol) {
    '*' => const MultiplicationOperator(),
    '/' => const DivisionOperator(),
    '%' => const ModuloOperator(),
    '+' => const PlusOperator(),
    '-' => const MinusOperator(),
    '<' => const LessThanOperator(),
    '<=' => const LessThanOrEqualOperator(),
    '>' => const GreaterThanOperator(),
    '>=' => const GreaterThanOrEqualOperator(),
    '==' => const EqualOperator(),
    '!=' => const NotEqualOperator(),
    '&&' => const AndOperator(),
    '||' => const OrOperator(),
    '?' => const ConditionOperator(),
    ':' => const ElseOperator(),
    '=' => const AssignmentOperator(),
    (_) => throw Exception('Operator not defined. $symbol'),
  };

  @override
  String toString() => '$runtimeType($symbol, $precedence, $associativity)';
}

sealed class UnaryOperator extends SyntaxOperator {
  const UnaryOperator({required super.symbol, required super.precedence, required super.associativity});

  factory UnaryOperator.fromSymbol(String symbol) => switch (symbol) {
    '!' => NotOperator(),
    '-' => UnaryMinusOperator(),
    (_) => throw Exception("Unexpected binary operator: $symbol"),
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

final class NotOperator extends UnaryOperator {
  const NotOperator() : super(symbol: '!', precedence: 8, associativity: Associativity.right);
}

final class UnaryMinusOperator extends UnaryOperator {
  const UnaryMinusOperator() : super(symbol: '-', precedence: 8, associativity: Associativity.right);
}

final class MultiplicationOperator extends ArithmeticOperator {
  const MultiplicationOperator() : super(symbol: '*', precedence: 7, associativity: Associativity.left);
}

final class DivisionOperator extends ArithmeticOperator {
  const DivisionOperator() : super(symbol: '/', precedence: 7, associativity: Associativity.left);
}

final class ModuloOperator extends ArithmeticOperator {
  const ModuloOperator() : super(symbol: '%', precedence: 7, associativity: Associativity.left);
}

final class PlusOperator extends ArithmeticOperator {
  const PlusOperator() : super(symbol: '+', precedence: 6, associativity: Associativity.left);
}

final class MinusOperator extends ArithmeticOperator {
  const MinusOperator() : super(symbol: '-', precedence: 6, associativity: Associativity.left);
}

final class LessThanOperator extends RelationalOperator {
  const LessThanOperator() : super(symbol: '<', precedence: 5, associativity: Associativity.left);
}

final class LessThanOrEqualOperator extends RelationalOperator {
  const LessThanOrEqualOperator() : super(symbol: '<=', precedence: 5, associativity: Associativity.left);
}

final class GreaterThanOperator extends RelationalOperator {
  const GreaterThanOperator() : super(symbol: '>', precedence: 5, associativity: Associativity.left);
}

final class GreaterThanOrEqualOperator extends RelationalOperator {
  const GreaterThanOrEqualOperator() : super(symbol: '>=', precedence: 5, associativity: Associativity.left);
}

final class EqualOperator extends EqualityOperator {
  const EqualOperator() : super(symbol: '==', precedence: 4, associativity: Associativity.left);
}

final class NotEqualOperator extends EqualityOperator {
  const NotEqualOperator() : super(symbol: '!=', precedence: 4, associativity: Associativity.left);
}

final class AndOperator extends LogicalOperator {
  const AndOperator() : super(symbol: '&&', precedence: 3, associativity: Associativity.left);
}

final class OrOperator extends LogicalOperator {
  const OrOperator() : super(symbol: '||', precedence: 2, associativity: Associativity.left);
}

final class ConditionOperator extends TernaryOperator {
  const ConditionOperator() : super(symbol: '?', precedence: 1, associativity: Associativity.right);
}

final class ElseOperator extends TernaryOperator {
  const ElseOperator() : super(symbol: ':', precedence: 1, associativity: Associativity.right);
}

final class AssignmentOperator extends SyntaxOperator {
  const AssignmentOperator() : super(symbol: '=', precedence: 0, associativity: Associativity.right);
}
