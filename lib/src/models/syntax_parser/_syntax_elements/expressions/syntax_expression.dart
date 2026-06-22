import 'dart:math';

import 'package:pratt_parser/src/models/global_environment/_function_registry/function_registry.dart';
import 'package:pratt_parser/src/models/global_environment/_variable_environment/variable_environment.dart';
import 'package:pratt_parser/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:pratt_parser/src/models/syntax_parser/lexer.dart';

/// Base class for all syntax expressions in the parser.
///
/// This sealed class represents the abstract syntax tree nodes for expressions
/// that can be evaluated to produce a runtime value.
sealed class SyntaxExpression {
  const SyntaxExpression();

  /// Evaluates the expression and returns the resulting value.
  ///
  /// Returns the evaluated result of the expression.
  dynamic evaluate();
}

/// Represents a function call expression in the syntax tree.
///
/// This expression encapsulates a function identifier and its list of parameter
/// expressions, which are evaluated and passed to the registered function.
final class FunctionExpression extends SyntaxExpression {
  /// The identifier/name of the function to call.
  final String identifier;

  /// The list of parameter expressions passed to the function.
  final List<SyntaxExpression> parameter;

  /// Creates a function expression with the given identifier and parameters.
  ///
  /// [identifier] is the name of the function to call.
  /// [parameter] is the list of expressions representing the function arguments.
  const FunctionExpression({required this.identifier, required this.parameter});

  /// Evaluates the function call by resolving the function and applying it
  /// to the evaluated arguments.
  ///
  /// Returns the result of the function call.
  @override
  dynamic evaluate() => FunctionRegistry.resolve(identifier, parameter.map((e) => e.evaluate()).toList());

  @override
  String toString() => 'Function $identifier($parameter)';
}

/// Represents a unary expression in the syntax tree.
///
/// This expression applies a unary operator (such as negation or minus) to a
/// single operand expression.
final class UnaryExpression extends SyntaxExpression {
  /// The unary operator to apply.
  final UnaryOperator operator;

  /// The operand expression that the operator is applied to.
  final SyntaxExpression operand;

  /// Creates a unary expression with the given operator and operand.
  ///
  /// [operator] is the unary operator to apply (e.g., NotOperator, UnaryMinusOperator).
  /// [operand] is the expression to operate on.
  const UnaryExpression({required this.operator, required this.operand});

  /// Evaluates the unary expression by first evaluating the operand,
  /// validating the operator-operand combination, and then applying the operator.
  ///
  /// Returns the result of applying the unary operator to the evaluated operand.
  @override
  dynamic evaluate() {
    final evaluatedOperand = operand.evaluate();

    _ExpressionValidator.validateUnary(operator: operator, operand: evaluatedOperand);

    return switch (operator) {
      NotOperator() => !(evaluatedOperand as bool),
      UnaryMinusOperator() => -(evaluatedOperand as num),
      IncrementOperator() => (evaluatedOperand as num) + 1,
      DecrementOperator() => (evaluatedOperand as num) - 1,
    };
  }

  @override
  String toString() => 'UnaryExpression(operator: ${operator.symbol}, operand: $operand)';
}

/// Represents a binary expression in the syntax tree.
///
/// This expression applies a binary operator (arithmetic, relational, logical,
/// or equality) to two operand expressions.
final class BinaryExpression extends SyntaxExpression {
  /// The binary operator to apply.
  final BinaryOperator operator;

  /// The left operand expression.
  final SyntaxExpression leftOperand;

  /// The right operand expression.
  final SyntaxExpression rightOperand;

  /// Creates a binary expression with the given operator and operands.
  ///
  /// [operator] is the binary operator to apply (e.g., AdditionOperator,
  /// EqualOperator, AndOperator).
  /// [leftOperand] is the left-hand side expression.
  /// [rightOperand] is the right-hand side expression.
  const BinaryExpression({required this.operator, required this.leftOperand, required this.rightOperand});

  /// Evaluates the binary expression by first evaluating both operands,
  /// validating the operator-operand combination, and then applying the operator.
  ///
  /// Returns the result of applying the binary operator to the evaluated operands.
  @override
  dynamic evaluate() {
    final evaluatedLeftOperand = leftOperand.evaluate();
    final evaluatedRightOperand = rightOperand.evaluate();

    _ExpressionValidator.validateBinary(
      operator: operator,
      leftOperand: evaluatedLeftOperand,
      rightOperand: evaluatedRightOperand,
    );

    return switch (operator) {
      ExponentOperator() => pow(evaluatedLeftOperand as num, evaluatedRightOperand as num),
      MultiplicationOperator() => (evaluatedLeftOperand as num) * (evaluatedRightOperand as num),
      DivisionOperator() => (evaluatedLeftOperand as num) / (evaluatedRightOperand as num),
      ModuloOperator() => (evaluatedLeftOperand as num) % (evaluatedRightOperand as num),
      AdditionOperator() => (evaluatedLeftOperand as num) + (evaluatedRightOperand as num),
      SubtractionOperator() => (evaluatedLeftOperand as num) - (evaluatedRightOperand as num),
      LessThanOperator() => (evaluatedLeftOperand as num) < (evaluatedRightOperand as num),
      LessThanOrEqualOperator() => (evaluatedLeftOperand as num) <= (evaluatedRightOperand as num),
      GreaterThanOperator() => (evaluatedLeftOperand as num) > (evaluatedRightOperand as num),
      GreaterThanOrEqualOperator() => (evaluatedLeftOperand as num) >= (evaluatedRightOperand as num),
      EqualOperator() => evaluatedLeftOperand == evaluatedRightOperand,
      NotEqualOperator() => evaluatedLeftOperand != evaluatedRightOperand,
      AndOperator() => (evaluatedLeftOperand as bool) && (evaluatedRightOperand as bool),
      OrOperator() => (evaluatedLeftOperand as bool) || (evaluatedRightOperand as bool),
    };
  }

  @override
  String toString() => 'BinaryExpression(left: $leftOperand, operator: ${operator.symbol}, right: $rightOperand)';
}

/// Represents a ternary (conditional) expression in the syntax tree.
///
/// This expression evaluates a condition and returns one of two values based
/// on whether the condition is true or false.
final class TernaryExpression extends SyntaxExpression {
  /// The condition expression to evaluate.
  final SyntaxExpression condition;

  /// The expression to evaluate and return if the condition is true.
  final SyntaxExpression trueCase;

  /// The expression to evaluate and return if the condition is false.
  final SyntaxExpression falseCase;

  /// Creates a ternary expression with the given condition and cases.
  ///
  /// [condition] is the boolean expression to evaluate.
  /// [trueCase] is the expression to return if the condition is true.
  /// [falseCase] is the expression to return if the condition is false.
  const TernaryExpression({required this.condition, required this.trueCase, required this.falseCase});

  /// Evaluates the ternary expression by first evaluating the condition,
  /// validating it is a boolean, and then returning the appropriate case.
  ///
  /// Returns the result of either the trueCase or falseCase expression.
  @override
  dynamic evaluate() {
    final evaluatedCondition = condition.evaluate();
    _ExpressionValidator.validateTernary(condition: evaluatedCondition);

    return evaluatedCondition ? trueCase.evaluate() : falseCase.evaluate();
  }

  @override
  String toString() => 'TernaryExpression(condition: $condition ? left: $trueCase : right: $falseCase)';
}

/// Represents a variable expression in the syntax tree.
///
/// This expression retrieves the value of a variable from the variable environment
/// by its identifier.
final class VariableExpression extends SyntaxExpression {
  /// The identifier/name of the variable to retrieve.
  final String identifier;

  /// Creates a variable expression with the given identifier.
  ///
  /// [identifier] is the name of the variable to look up in the environment.
  const VariableExpression({required this.identifier});

  /// Evaluates the variable expression by looking up the identifier in the
  /// variable environment and returning its value.
  ///
  /// If the value is itself a SyntaxExpression, it is evaluated recursively.
  /// Otherwise, the raw value is returned.
  ///
  /// Throws an exception if the variable is not initialized.
  @override
  dynamic evaluate() {
    _ExpressionValidator.validateVariableExpression(identifier: identifier);

    final value = VariableEnvironment.getValue(identifier);
    return value is SyntaxExpression ? value.evaluate() : value;
  }

  @override
  String toString() => 'VariableExpression($identifier)';
}

/// Represents an assignment expression in the syntax tree.
///
/// This expression assigns a value to a variable by evaluating the right-hand
/// side expression and storing the result in the variable environment.
final class AssignmentExpression extends VariableExpression {
  /// The assignment operator.
  final AssignmentOperator operator;

  /// The expression to evaluate and assign to the variable.
  final SyntaxExpression expression;

  /// Creates an assignment expression with the given identifier and expression.
  ///
  /// [identifier] is the name of the variable to assign to.
  /// [operator] is the assignment operator.
  /// [expression] is the expression whose value will be assigned.
  const AssignmentExpression({required super.identifier, required this.operator, required this.expression});

  /// Evaluates the assignment expression by first evaluating the right-hand
  /// side expression, then storing the result in the variable environment.
  ///
  /// Returns the evaluated value of the expression.
  @override
  dynamic evaluate() {
    final evaluatedExpression = expression.evaluate();

    _ExpressionValidator.validateAssignmentExpression(identifier: identifier, operator: operator);

    return switch (operator) {
      AdditionAssignmentOperator() => VariableEnvironment.addOrUpdateVariable(
        identifier,
        ((VariableEnvironment.getValue(identifier) ?? 0) as num) + evaluatedExpression,
      ),
      SubtractionAssignmentOperator() => VariableEnvironment.addOrUpdateVariable(
        identifier,
        ((VariableEnvironment.getValue(identifier) ?? 0) as num) - evaluatedExpression,
      ),
      MultiplicationAssignmentOperator() => VariableEnvironment.addOrUpdateVariable(
        identifier,
        ((VariableEnvironment.getValue(identifier) ?? 0) as num) * evaluatedExpression,
      ),
      DivisionAssignmentOperator() => VariableEnvironment.addOrUpdateVariable(
        identifier,
        ((VariableEnvironment.getValue(identifier) ?? 0) as num) / evaluatedExpression,
      ),
      SimpleAssignmentOperator() => VariableEnvironment.addOrUpdateVariable(identifier, evaluatedExpression),
    };
  }

  @override
  String toString() => 'AssignmentExpression($identifier = $expression)';
}

/// Represents a member access expression in the syntax tree.
///
/// This expression accesses a property or element of an object using bracket
/// notation.
final class MemberExpression extends SyntaxExpression {
  /// The object expression to access a member from.
  final SyntaxExpression obj;

  /// The property/expression representing the member to access.
  final SyntaxExpression property;

  /// Creates a member expression with the given object and property.
  ///
  /// [obj] is the object expression to access a member from.
  /// [property] is the expression representing the property/element to access.
  const MemberExpression({required this.obj, required this.property});

  /// Evaluates the member expression by first evaluating the object and
  /// property expressions, then accessing the property on the object.
  ///
  /// Returns the value of the accessed property/element.
  @override
  dynamic evaluate() {
    final left = obj.evaluate();

    // If property is a function expression (method call), evaluate it directly
    if (property is FunctionExpression) {
      return property.evaluate();
    }

    final evaluatedProperty = property.evaluate();
    return (left as Map)[evaluatedProperty];
  }

  @override
  String toString() => 'MemberExpression($obj.$property)';
}

/// Base class for literal expressions in the syntax tree.
///
/// This sealed class represents literal values such as strings, numbers,
/// booleans, and null in the abstract syntax tree.
final class SyntaxLiteral<T> extends SyntaxExpression {
  /// The literal value stored in this expression.
  final T value;

  /// Creates a syntax literal with the given value.
  ///
  /// [value] is the literal value to store.
  const SyntaxLiteral(this.value);

  /// Creates a [SyntaxLiteral] from a [Token].
  ///
  /// [token] is the token to convert to a literal.
  /// [identifierAsString] if true, treats identifier tokens as strings instead of
  /// throwing an exception.
  ///
  /// Returns a [SyntaxLiteral] instance appropriate for the token type.
  /// Throws an exception if the token type is not supported.
  static SyntaxLiteral<dynamic> literalFromToken(Token token, {bool identifierAsString = false}) =>
      switch (token.type) {
        TokenType.stringLiteral => SyntaxLiteral<String>(token.lexeme),
        TokenType.identifier => identifierAsString ? SyntaxLiteral<String>(token.lexeme) : throw _unsupported(),
        TokenType.numeralLiteral => SyntaxLiteral<num>(num.parse(token.lexeme)),
        TokenType.booleanLiteral => SyntaxLiteral<bool>(bool.parse(token.lexeme, caseSensitive: false)),
        TokenType.nullLiteral => const SyntaxLiteral<Null>(null),
        (_) => throw _unsupported(),
      };

  static Exception _unsupported() => Exception('Unsupported literal type.');

  /// Evaluates the literal expression by returning its stored value.
  ///
  /// Returns the literal value directly without further evaluation.
  @override
  T evaluate() => value;

  @override
  // Prints the runtime type and value for easier debugging (e.g., StringLiteral(hello), NumeralLiteral(42)).
  // ignore: no_runtimetype_tostring
  String toString() => '$runtimeType($value)';
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
    if (operator is IncrementOperator || operator is DecrementOperator) {
      if (operand is! num) {
        throw _UnaryException('Increment and decrement operators operate on num values. Got: ${operand.runtimeType}');
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

  static void validateAssignmentExpression({required String identifier, required AssignmentOperator operator}) {
    // Simple assignment does not require pre-existing variable or type checks.
    if (operator is AdditionAssignmentOperator ||
        operator is SubtractionAssignmentOperator ||
        operator is MultiplicationAssignmentOperator ||
        operator is DivisionAssignmentOperator) {
      final value = VariableEnvironment.getValue(identifier);
      if (value != null && value is! num) {
        throw _AssignmentException(
          'Compound assignment operators (+=, -=, *=, /=) require the variable to be of type num. Variable $identifier is of type ${value.runtimeType}.',
        );
      }
    }
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

final class _AssignmentException implements Exception {
  final String message;
  const _AssignmentException(this.message);

  @override
  String toString() => '_AssignmentException: $message';
}

// final class _MemberException implements Exception {
//   final String message;
//   const _MemberException(this.message);

//   @override
//   String toString() => '_MemberException: $message';
// }
