/// Specifies the associativity of an operator, determining the order in which
/// operators of the same precedence are evaluated.
enum Associativity {
  /// Operators are evaluated from left to right.
  ///
  /// Example: `a - b - c` is evaluated as `(a - b) - c`.
  left,

  /// Operators are evaluated from right to left.
  ///
  /// Example: `a = b = c` is evaluated as `a = (b = c)`.
  right,
}

/// Base class for all syntax operators in the parser.
///
/// Operators are characterized by their symbol representation, precedence level,
/// and associativity. The precedence determines the order of evaluation, while
/// associativity determines how operators of the same precedence are grouped.
sealed class SyntaxOperator {
  /// The symbol representation of this operator (e.g., '+', '-', '==').
  final String symbol;

  /// The precedence level of this operator.
  ///
  /// Higher values indicate higher precedence. Operators with higher precedence
  /// are evaluated before operators with lower precedence.
  final int precedence;

  /// The associativity of this operator.
  ///
  /// Determines the direction in which operators of the same precedence are evaluated.
  final Associativity associativity;

  /// Creates a new [SyntaxOperator] with the given [symbol], [precedence], and [associativity].
  const SyntaxOperator({required this.symbol, required this.precedence, required this.associativity});

  /// Creates a [SyntaxOperator] instance from the given [symbol] string.
  ///
  /// This factory method maps symbol strings to their corresponding operator
  /// implementations. Throws an [Exception] if the symbol does not correspond
  /// to any defined operator.
  ///
  /// Throws an [Exception] if the [symbol] is not a recognized operator.
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
    '=' => const SimpleAssignmentOperator._(),
    '+=' => const AdditionAssignmentOperator._(),
    '-=' => const SubtractionAssignmentOperator._(),
    '*=' => const MultiplicationAssignmentOperator._(),
    '/=' => const DivisionAssignmentOperator._(),
    (_) => throw Exception('Operator not defined: $symbol'),
  };

  /// Returns a string representation of this operator.
  @override
  String toString() => 'SyntaxOperator($symbol, $precedence, $associativity)';
}

/// Base class for assignment operators.
///
/// Assignment operators perform an operation on the left operand and assign the result to the left operand. Examples include simple assignment (=) and compound assignments (+=, -=).
/// Note: Assignment operators typically have the lowest precedence and right associativity, meaning they are evaluated after all other operators and group from right to left.
sealed class AssignmentOperator extends SyntaxOperator {
  /// Creates a new [AssignmentOperator] instance.
  const AssignmentOperator({required super.symbol, required super.associativity}) : super(precedence: 0);
}

/// Base class for unary operators.
///
/// Unary operators operate on a single operand. Examples include negation (!)
/// and unary minus (-).
sealed class UnaryOperator extends SyntaxOperator {
  /// Creates a new [UnaryOperator] with the given [symbol], [precedence], and [associativity].
  const UnaryOperator({required super.symbol, required super.precedence, required super.associativity});

  /// Creates a [UnaryOperator] instance from the given [symbol] string.
  ///
  /// This factory method maps symbol strings to their corresponding unary operator
  /// implementations. Throws an [Exception] if the symbol does not correspond
  /// to any defined unary operator.
  ///
  /// Throws an [Exception] if the [symbol] is not a recognized unary operator.
  factory UnaryOperator.fromSymbol(String symbol) => switch (symbol) {
    '!' => const NotOperator._(),
    '-' => const UnaryMinusOperator._(),
    '++' => const IncrementOperator._(),
    '--' => const DecrementOperator._(),
    (_) => throw Exception('Unexpected binary operator: $symbol'),
  };
}

/// Base class for binary operators.
///
/// Binary operators operate on two operands (left and right). Examples include
/// arithmetic operators (+, -, *, /), relational operators (<, >, ==), and
/// logical operators (&&, ||).
sealed class BinaryOperator extends SyntaxOperator {
  /// Creates a new [BinaryOperator] with the given [symbol], [precedence], and [associativity].
  const BinaryOperator({required super.symbol, required super.precedence, required super.associativity});
}

/// Base class for ternary operators.
///
/// Ternary operators are used in conditional expressions and operate on three
/// operands (condition, true case, false case).
sealed class TernaryOperator extends SyntaxOperator {
  /// Creates a new [TernaryOperator] with the given [symbol], [precedence], and [associativity].
  const TernaryOperator({required super.symbol, required super.precedence, required super.associativity});
}

/// Base class for arithmetic operators.
///
/// Arithmetic operators perform mathematical operations on numeric operands.
/// This includes addition, subtraction, multiplication, division, modulo, and exponentiation.
sealed class ArithmeticOperator extends BinaryOperator {
  /// Creates a new [ArithmeticOperator] with the given [symbol], [precedence], and [associativity].
  const ArithmeticOperator({required super.symbol, required super.precedence, required super.associativity});
}

/// Base class for relational operators.
///
/// Relational operators compare two values and return a boolean result.
/// This includes less than, less than or equal, greater than, and greater than or equal.
sealed class RelationalOperator extends BinaryOperator {
  /// Creates a new [RelationalOperator] with the given [symbol], [precedence], and [associativity].
  const RelationalOperator({required super.symbol, required super.precedence, required super.associativity});
}

/// Base class for equality operators.
///
/// Equality operators compare two values for equality or inequality.
/// This includes equal (==) and not equal (!=).
sealed class EqualityOperator extends BinaryOperator {
  /// Creates a new [EqualityOperator] with the given [symbol], [precedence], and [associativity].
  const EqualityOperator({required super.symbol, required super.precedence, required super.associativity});
}

/// Base class for logical operators.
///
/// Logical operators perform boolean logic operations. This includes AND (&&)
/// and OR (||).
sealed class LogicalOperator extends BinaryOperator {
  /// Creates a new [LogicalOperator] with the given [symbol], [precedence], and [associativity].
  const LogicalOperator({required super.symbol, required super.precedence, required super.associativity});
}

/// Dot operator for member access.
///
/// Used to access properties or methods of an object (e.g., `object.property`).
/// Has the highest precedence (9) and right associativity.
final class DotOperator extends SyntaxOperator {
  /// Creates a new [DotOperator] instance.
  const DotOperator._() : super(symbol: '.', precedence: 10, associativity: Associativity.left);
}

/// Not operator (logical negation).
///
/// Negates the boolean value of its operand (e.g., `!true` becomes `false`).
/// Has precedence 8 and right associativity.
final class NotOperator extends UnaryOperator {
  /// Creates a new [NotOperator] instance.
  const NotOperator._() : super(symbol: '!', precedence: 9, associativity: Associativity.right);
}

/// Unary minus operator (arithmetic negation).
///
/// Negates the numeric value of its operand (e.g., `-5` becomes `5`).
/// Has precedence 8 and right associativity.
final class UnaryMinusOperator extends UnaryOperator {
  /// Creates a new [UnaryMinusOperator] instance.
  const UnaryMinusOperator._() : super(symbol: '-', precedence: 9, associativity: Associativity.right);
}

/// Increment operator (unary).
///
/// Increments the numeric value of its operand by 1 (e.g., `x++` becomes `x + 1`).
/// Has precedence 8 and right associativity.
/// Note: This operator is typically used in postfix form (e.g., `x++`) and may not be supported in all contexts.
final class IncrementOperator extends UnaryOperator {
  /// Creates a new [IncrementOperator] instance.
  const IncrementOperator._() : super(symbol: '++', precedence: 9, associativity: Associativity.right);
}

/// Decrement operator (unary).
///
/// Decrements the numeric value of its operand by 1 (e.g., `x--` becomes `x - 1`).
/// Has precedence 8 and right associativity.
/// Note: This operator is typically used in postfix form (e.g., `x--`)
/// and may not be supported in all contexts.
final class DecrementOperator extends UnaryOperator {
  /// Creates a new [DecrementOperator] instance.
  const DecrementOperator._() : super(symbol: '--', precedence: 9, associativity: Associativity.right);
}

/// Exponent operator.
///
/// Raises the left operand to the power of the right operand (e.g., `2 ^ 3` becomes `8`).
/// Has precedence 7 and right associativity.
final class ExponentOperator extends ArithmeticOperator {
  /// Creates a new [ExponentOperator] instance.
  const ExponentOperator._() : super(symbol: '^', precedence: 8, associativity: Associativity.right);
}

/// Multiplication operator.
///
/// Multiplies the left and right operands (e.g., `2 * 3` becomes `6`).
/// Has precedence 7 and left associativity.
final class MultiplicationOperator extends ArithmeticOperator {
  /// Creates a new [MultiplicationOperator] instance.
  const MultiplicationOperator._() : super(symbol: '*', precedence: 7, associativity: Associativity.left);
}

/// Division operator.
///
/// Divides the left operand by the right operand (e.g., `6 / 2` becomes `3`).
/// Has precedence 7 and left associativity.
final class DivisionOperator extends ArithmeticOperator {
  /// Creates a new [DivisionOperator] instance.
  const DivisionOperator._() : super(symbol: '/', precedence: 7, associativity: Associativity.left);
}

/// Modulo operator.
///
/// Returns the remainder of dividing the left operand by the right operand
/// (e.g., `7 % 3` becomes `1`).
/// Has precedence 7 and left associativity.
final class ModuloOperator extends ArithmeticOperator {
  /// Creates a new [ModuloOperator] instance.
  const ModuloOperator._() : super(symbol: '%', precedence: 7, associativity: Associativity.left);
}

/// Addition operator.
///
/// Adds the left and right operands (e.g., `2 + 3` becomes `5`).
/// Has precedence 6 and left associativity.
final class AdditionOperator extends ArithmeticOperator {
  /// Creates a new [AdditionOperator] instance.
  const AdditionOperator._() : super(symbol: '+', precedence: 6, associativity: Associativity.left);
}

/// Subtraction operator.
///
/// Subtracts the right operand from the left operand (e.g., `5 - 3` becomes `2`).
/// Has precedence 6 and left associativity.
final class SubtractionOperator extends ArithmeticOperator {
  /// Creates a new [SubtractionOperator] instance.
  const SubtractionOperator._() : super(symbol: '-', precedence: 6, associativity: Associativity.left);
}

/// Less than operator.
///
/// Returns true if the left operand is less than the right operand
/// (e.g., `2 < 3` becomes `true`).
/// Has precedence 5 and left associativity.
final class LessThanOperator extends RelationalOperator {
  /// Creates a new [LessThanOperator] instance.
  const LessThanOperator._() : super(symbol: '<', precedence: 5, associativity: Associativity.left);
}

/// Less than or equal operator.
///
/// Returns true if the left operand is less than or equal to the right operand
/// (e.g., `2 <= 2` becomes `true`).
/// Has precedence 5 and left associativity.
final class LessThanOrEqualOperator extends RelationalOperator {
  /// Creates a new [LessThanOrEqualOperator] instance.
  const LessThanOrEqualOperator._() : super(symbol: '<=', precedence: 5, associativity: Associativity.left);
}

/// Greater than operator.
///
/// Returns true if the left operand is greater than the right operand
/// (e.g., `3 > 2` becomes `true`).
/// Has precedence 5 and left associativity.
final class GreaterThanOperator extends RelationalOperator {
  /// Creates a new [GreaterThanOperator] instance.
  const GreaterThanOperator._() : super(symbol: '>', precedence: 5, associativity: Associativity.left);
}

/// Greater than or equal operator.
///
/// Returns true if the left operand is greater than or equal to the right operand
/// (e.g., `3 >= 3` becomes `true`).
/// Has precedence 5 and left associativity.
final class GreaterThanOrEqualOperator extends RelationalOperator {
  /// Creates a new [GreaterThanOrEqualOperator] instance.
  const GreaterThanOrEqualOperator._() : super(symbol: '>=', precedence: 5, associativity: Associativity.left);
}

/// Equal operator.
///
/// Returns true if the left and right operands are equal
/// (e.g., `2 == 2` becomes `true`).
/// Has precedence 4 and left associativity.
final class EqualOperator extends EqualityOperator {
  /// Creates a new [EqualOperator] instance.
  const EqualOperator._() : super(symbol: '==', precedence: 4, associativity: Associativity.left);
}

/// Not equal operator.
///
/// Returns true if the left and right operands are not equal
/// (e.g., `2 != 3` becomes `true`).
/// Has precedence 4 and left associativity.
final class NotEqualOperator extends EqualityOperator {
  /// Creates a new [NotEqualOperator] instance.
  const NotEqualOperator._() : super(symbol: '!=', precedence: 4, associativity: Associativity.left);
}

/// And operator (logical conjunction).
///
/// Returns true if both operands are true (e.g., `true && false` becomes `false`).
/// Has precedence 3 and left associativity.
final class AndOperator extends LogicalOperator {
  /// Creates a new [AndOperator] instance.
  const AndOperator._() : super(symbol: '&&', precedence: 3, associativity: Associativity.left);
}

/// Or operator (logical disjunction).
///
/// Returns true if at least one operand is true (e.g., `true || false` becomes `true`).
/// Has precedence 2 and left associativity.
final class OrOperator extends LogicalOperator {
  /// Creates a new [OrOperator] instance.
  const OrOperator._() : super(symbol: '||', precedence: 2, associativity: Associativity.left);
}

/// Condition operator (ternary operator).
///
/// Used in conditional expressions to select between two values based on a condition
/// (e.g., `condition ? trueValue : falseValue`).
/// Has precedence 1 and right associativity.
final class ConditionOperator extends TernaryOperator {
  /// Creates a new [ConditionOperator] instance.
  const ConditionOperator._() : super(symbol: '?', precedence: 1, associativity: Associativity.right);
}

/// Else operator (ternary operator).
///
/// Used in conditional expressions to separate the true and false cases
/// (e.g., `condition ? trueValue : falseValue`).
/// Has precedence 1 and right associativity.
final class ElseOperator extends TernaryOperator {
  /// Creates a new [ElseOperator] instance.
  const ElseOperator._() : super(symbol: ':', precedence: 1, associativity: Associativity.right);
}

/// Simple assignment operator (=).
///
/// Assigns the value of the right operand to the left operand (e.g., `x = 5`).
/// Has the lowest precedence (0) and right associativity.
/// Note: This operator is typically used in assignment contexts and may not be supported in all expression contexts.
/// This operator is represented by the [SimpleAssignmentOperator] class.
final class SimpleAssignmentOperator extends AssignmentOperator {
  /// Creates a new [SimpleAssignmentOperator] instance.
  const SimpleAssignmentOperator._() : super(symbol: '=', associativity: Associativity.right);
}

/// Addition assignment operator (+=).
///
/// Adds the right operand to the left operand and assigns the result to the left operand (e.g., `x += 5` is equivalent to `x = x + 5`).
/// Has precedence 0 and right associativity.
/// Note: This operator is typically used in assignment contexts and may not be supported in all expression contexts.
final class AdditionAssignmentOperator extends AssignmentOperator {
  /// Creates a new [AdditionAssignmentOperator] instance.
  const AdditionAssignmentOperator._() : super(symbol: '+=', associativity: Associativity.right);
}

/// Subtraction assignment operator (-=).
///
/// Subtracts the right operand from the left operand and assigns the result to the left operand (e.g., `x -= 5` is equivalent to `x = x - 5`).
/// Has precedence 0 and right associativity.
/// Note: This operator is typically used in assignment contexts and may not be supported in all expression contexts.
final class SubtractionAssignmentOperator extends AssignmentOperator {
  /// Creates a new [SubtractionAssignmentOperator] instance.
  const SubtractionAssignmentOperator._() : super(symbol: '-=', associativity: Associativity.right);
}

/// Multiplication assignment operator (*=).
///
/// Multiplies the left operand by the right operand and assigns the result to the left operand (e.g., `x *= 5` is equivalent to `x = x * 5`).
/// Has precedence 0 and right associativity.
/// Note: This operator is typically used in assignment contexts and may not be supported in all expression contexts.
final class MultiplicationAssignmentOperator extends AssignmentOperator {
  /// Creates a new [MultiplicationAssignmentOperator] instance.
  const MultiplicationAssignmentOperator._() : super(symbol: '*=', associativity: Associativity.right);
}

/// Division assignment operator (/=).
///
/// Divides the left operand by the right operand and assigns the result to the left operand (e.g., `x /= 5` is equivalent to `x = x / 5`).
/// Has precedence 0 and right associativity.
/// Note: This operator is typically used in assignment contexts and may not be supported in all expression contexts.
final class DivisionAssignmentOperator extends AssignmentOperator {
  /// Creates a new [DivisionAssignmentOperator] instance.
  const DivisionAssignmentOperator._() : super(symbol: '/=', associativity: Associativity.right);
}
