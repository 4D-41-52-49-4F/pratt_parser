enum Associativity { left, right }

sealed class SyntaxOperator {
  final String symbol;
  final int precedence;
  final Associativity associativity;

  const SyntaxOperator({required this.symbol, required this.precedence, required this.associativity});

  factory SyntaxOperator.fromSymbol(String symbol) {
    return switch (symbol) {
      '!' => const NotOperator(),
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
      ':' => const OptionOperator(),
      (_) => throw Exception('Operator not defined.'),
    };
  }

  @override
  String toString() => '$runtimeType($symbol, $precedence, $associativity)';
}

sealed class UnaryOperator extends SyntaxOperator {
  const UnaryOperator({required super.symbol, required super.precedence, required super.associativity});
}

sealed class BinaryOperator extends SyntaxOperator {
  const BinaryOperator({required super.symbol, required super.precedence, required super.associativity});
}

sealed class TernaryOperator extends SyntaxOperator {
  const TernaryOperator({required super.symbol, required super.precedence, required super.associativity});
}

final class NotOperator extends UnaryOperator {
  const NotOperator() : super(symbol: '!', precedence: 7, associativity: Associativity.right);
}

final class MultiplicationOperator extends BinaryOperator {
  const MultiplicationOperator() : super(symbol: '*', precedence: 6, associativity: Associativity.left);
}

final class DivisionOperator extends BinaryOperator {
  const DivisionOperator() : super(symbol: '/', precedence: 6, associativity: Associativity.left);
}

final class ModuloOperator extends BinaryOperator {
  const ModuloOperator() : super(symbol: '%', precedence: 6, associativity: Associativity.left);
}

final class PlusOperator extends BinaryOperator {
  const PlusOperator() : super(symbol: '+', precedence: 5, associativity: Associativity.left);
}

final class MinusOperator extends BinaryOperator {
  const MinusOperator() : super(symbol: '-', precedence: 5, associativity: Associativity.left);
}

final class LessThanOperator extends BinaryOperator {
  const LessThanOperator() : super(symbol: '<', precedence: 4, associativity: Associativity.left);
}

final class LessThanOrEqualOperator extends BinaryOperator {
  const LessThanOrEqualOperator() : super(symbol: '<=', precedence: 4, associativity: Associativity.left);
}

final class GreaterThanOperator extends BinaryOperator {
  const GreaterThanOperator() : super(symbol: '>', precedence: 4, associativity: Associativity.left);
}

final class GreaterThanOrEqualOperator extends BinaryOperator {
  const GreaterThanOrEqualOperator() : super(symbol: '>=', precedence: 4, associativity: Associativity.left);
}

final class EqualOperator extends BinaryOperator {
  const EqualOperator() : super(symbol: '==', precedence: 3, associativity: Associativity.left);
}

final class NotEqualOperator extends BinaryOperator {
  const NotEqualOperator() : super(symbol: '!=', precedence: 3, associativity: Associativity.left);
}

final class AndOperator extends BinaryOperator {
  const AndOperator() : super(symbol: '&&', precedence: 2, associativity: Associativity.left);
}

final class OrOperator extends BinaryOperator {
  const OrOperator() : super(symbol: '||', precedence: 1, associativity: Associativity.left);
}

final class ConditionOperator extends TernaryOperator {
  const ConditionOperator() : super(symbol: '?', precedence: 0, associativity: Associativity.left);
}

final class OptionOperator extends TernaryOperator {
  const OptionOperator() : super(symbol: ':', precedence: 1, associativity: Associativity.left);
}
