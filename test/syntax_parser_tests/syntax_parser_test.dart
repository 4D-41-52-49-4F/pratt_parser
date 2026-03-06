import 'dart:math';

import 'package:abschlussprojekt/src/models/global_environment/_function_registry/function_registry.dart';
import 'package:abschlussprojekt/src/models/global_environment/_variable_environment/variable_environment.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/syntax_parser.dart';
import 'package:test/test.dart';

void main() {
  group('SyntaxParser - Simple Literal Tests', () {
    test('Parse null literal', () {
      final parser = SyntaxParser('null');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<SyntaxLiteral>());
      final literal = tree as SyntaxLiteral;
      expect(literal.value, null);
    });

    test('Parse true literal', () {
      final parser = SyntaxParser('true');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<SyntaxLiteral>());
      final literal = tree as SyntaxLiteral;
      expect(literal.value, true);
    });

    test('Parse false literal', () {
      final parser = SyntaxParser('false');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<SyntaxLiteral>());
      final literal = tree as SyntaxLiteral;
      expect(literal.value, false);
    });

    test('Parse integer literal', () {
      final parser = SyntaxParser('42');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<SyntaxLiteral>());
      final literal = tree as SyntaxLiteral;
      expect(literal.value, 42);
    });

    test('Parse decimal literal', () {
      final parser = SyntaxParser('3.14');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<SyntaxLiteral>());
      final literal = tree as SyntaxLiteral;
      expect(literal.value, 3.14);
    });

    test('Parse string literal', () {
      final parser = SyntaxParser('"hello"');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<SyntaxLiteral>());
      final literal = tree as SyntaxLiteral;
      expect(literal.value, 'hello');
    });
  });

  group('SyntaxParser - Simple Variable Tests', () {
    test('Parse single variable', () {
      final parser = SyntaxParser('x');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<VariableExpression>());
      final variable = tree as VariableExpression;
      expect(variable.identifier, 'x');
    });

    test('Parse variable with underscore', () {
      final parser = SyntaxParser('my_variable');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<VariableExpression>());
      final variable = tree as VariableExpression;
      expect(variable.identifier, 'my_variable');
    });

    test('Parse variable with numbers', () {
      final parser = SyntaxParser('var123');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<VariableExpression>());
      final variable = tree as VariableExpression;
      expect(variable.identifier, 'var123');
    });
  });

  group('SyntaxParser - Unary Operator Tests', () {
    test('Parse unary minus on number', () {
      final parser = SyntaxParser('-5');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<UnaryExpression>());
      final unary = tree as UnaryExpression;
      expect(unary.operator, isA<UnaryMinusOperator>());
      expect(unary.operand, isA<SyntaxLiteral>());
    });

    test('Parse unary not on boolean', () {
      final parser = SyntaxParser('!true');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<UnaryExpression>());
      final unary = tree as UnaryExpression;
      expect(unary.operator, isA<NotOperator>());
      expect(unary.operand, isA<SyntaxLiteral>());
    });

    test('Parse unary minus on variable', () {
      final parser = SyntaxParser('-x');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<UnaryExpression>());
      final unary = tree as UnaryExpression;
      expect(unary.operator, isA<UnaryMinusOperator>());
      expect(unary.operand, isA<VariableExpression>());
    });

    test('Parse double negation', () {
      final parser = SyntaxParser('!!true');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<UnaryExpression>());
      final outer = tree as UnaryExpression;
      expect(outer.operator, isA<NotOperator>());
      expect(outer.operand, isA<UnaryExpression>());
    });
  });

  group('SyntaxParser - Simple Binary Operator Tests', () {
    test('Parse simple addition', () {
      final parser = SyntaxParser('1 + 2');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final binary = tree as BinaryExpression;
      expect(binary.operator, isA<AdditionOperator>());
    });

    test('Parse simple subtraction', () {
      final parser = SyntaxParser('5 - 3');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final binary = tree as BinaryExpression;
      expect(binary.operator, isA<SubtractionOperator>());
    });

    test('Parse simple multiplication', () {
      final parser = SyntaxParser('4 * 3');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final binary = tree as BinaryExpression;
      expect(binary.operator, isA<MultiplicationOperator>());
    });

    test('Parse simple division', () {
      final parser = SyntaxParser('10 / 2');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final binary = tree as BinaryExpression;
      expect(binary.operator, isA<DivisionOperator>());
    });

    test('Parse simple modulo', () {
      final parser = SyntaxParser('7 % 3');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final binary = tree as BinaryExpression;
      expect(binary.operator, isA<ModuloOperator>());
    });

    test('Parse simple exponent', () {
      final parser = SyntaxParser('2 ^ 3');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final binary = tree as BinaryExpression;
      expect(binary.operator, isA<ExponentOperator>());
    });

    test('Parse simple equal comparison', () {
      final parser = SyntaxParser('x == y');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final binary = tree as BinaryExpression;
      expect(binary.operator, isA<EqualOperator>());
    });

    test('Parse simple not equal comparison', () {
      final parser = SyntaxParser('a != b');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final binary = tree as BinaryExpression;
      expect(binary.operator, isA<NotEqualOperator>());
    });

    test('Parse simple less than comparison', () {
      final parser = SyntaxParser('a < b');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final binary = tree as BinaryExpression;
      expect(binary.operator, isA<LessThanOperator>());
    });

    test('Parse simple greater than comparison', () {
      final parser = SyntaxParser('a > b');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final binary = tree as BinaryExpression;
      expect(binary.operator, isA<GreaterThanOperator>());
    });

    test('Parse simple logical AND', () {
      final parser = SyntaxParser('true && false');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final binary = tree as BinaryExpression;
      expect(binary.operator, isA<AndOperator>());
    });

    test('Parse simple logical OR', () {
      final parser = SyntaxParser('true || false');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final binary = tree as BinaryExpression;
      expect(binary.operator, isA<OrOperator>());
    });
  });

  group('SyntaxParser - Operator Precedence Tests', () {
    test('Parse addition and multiplication (multiplication first)', () {
      final parser = SyntaxParser('1 + 2 * 3');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final addition = tree as BinaryExpression;
      expect(addition.operator, isA<AdditionOperator>());
      expect(addition.rightOperand, isA<BinaryExpression>());
      final multiplication = addition.rightOperand as BinaryExpression;
      expect(multiplication.operator, isA<MultiplicationOperator>());
    });

    test('Parse multiplication and addition with parentheses', () {
      final parser = SyntaxParser('(1 + 2) * 3');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final mult = tree as BinaryExpression;
      expect(mult.operator, isA<MultiplicationOperator>());
      expect(mult.leftOperand, isA<BinaryExpression>());
    });

    test('Parse exponent higher than multiplication', () {
      final parser = SyntaxParser('2 * 3 ^ 2');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());

      final mult = tree as BinaryExpression;
      expect(mult.operator, isA<MultiplicationOperator>());
      expect(mult.rightOperand, isA<BinaryExpression>());

      final exp = mult.rightOperand as BinaryExpression;
      expect(exp.operator, isA<ExponentOperator>());
    });

    test('Parse relational before logical AND', () {
      final parser = SyntaxParser('a < b && c == d');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final and = tree as BinaryExpression;
      expect(and.operator, isA<AndOperator>());
      expect(and.leftOperand, isA<BinaryExpression>());
      expect(and.rightOperand, isA<BinaryExpression>());
    });

    test('Parse logical AND before logical OR', () {
      final parser = SyntaxParser('a && b || c && d');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final or = tree as BinaryExpression;
      expect(or.operator, isA<OrOperator>());
      expect(or.leftOperand, isA<BinaryExpression>());
      expect(or.rightOperand, isA<BinaryExpression>());
    });
  });

  group('SyntaxParser - Operator Associativity Tests', () {
    test('Parse left associative subtraction', () {
      final parser = SyntaxParser('10 - 5 - 2');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final outer = tree as BinaryExpression;
      expect(outer.operator, isA<SubtractionOperator>());
      expect(outer.leftOperand, isA<BinaryExpression>());
      final inner = outer.leftOperand as BinaryExpression;
      expect(inner.operator, isA<SubtractionOperator>());
    });

    test('Parse right associative exponent', () {
      final parser = SyntaxParser('2 ^ 3 ^ 2');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final outer = tree as BinaryExpression;
      expect(outer.operator, isA<ExponentOperator>());
      expect(outer.rightOperand, isA<BinaryExpression>());
      final inner = outer.rightOperand as BinaryExpression;
      expect(inner.operator, isA<ExponentOperator>());
    });
  });

  group('SyntaxParser - Function Call Tests', () {
    setUp(() {
      FunctionRegistry.register('func', (_) => 'result');
      FunctionRegistry.register('max', (args) {
        args.sort();
        return args.last;
      });
    });

    test('Parse function call with no parameters', () {
      final parser = SyntaxParser('func()');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<FunctionExpression>());
      final func = tree as FunctionExpression;
      expect(func.identifier, 'func');
      expect(func.parameter, isEmpty);
    });

    test('Parse function call with single parameter', () {
      final parser = SyntaxParser('func(x)');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<FunctionExpression>());
      final func = tree as FunctionExpression;
      expect(func.identifier, 'func');
      expect(func.parameter.length, 1);
    });

    test('Parse function call with multiple parameters', () {
      final parser = SyntaxParser('func(a, b, c)');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<FunctionExpression>());
      final func = tree as FunctionExpression;
      expect(func.identifier, 'func');
      expect(func.parameter.length, 3);
    });

    test('Parse function call with literal parameters', () {
      final parser = SyntaxParser('max(1, 5)');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<FunctionExpression>());
      final func = tree as FunctionExpression;
      expect(func.parameter.length, 2);
      expect(func.parameter[0], isA<SyntaxLiteral>());
      expect(func.parameter[1], isA<SyntaxLiteral>());
    });

    test('Parse function call with expression parameters', () {
      final parser = SyntaxParser('func(a + b, c * d)');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<FunctionExpression>());
      final func = tree as FunctionExpression;
      expect(func.parameter.length, 2);
      expect(func.parameter[0], isA<BinaryExpression>());
      expect(func.parameter[1], isA<BinaryExpression>());
    });
  });

  group('SyntaxParser - Assignment Expression Tests', () {
    test('Parse simple assignment', () {
      final parser = SyntaxParser('x = 5');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<AssignmentExpression>());
      final assign = tree as AssignmentExpression;
      expect(assign.identifier, 'x');
      expect(assign.expression, isA<SyntaxLiteral>());
    });

    test('Parse assignment with expression', () {
      final parser = SyntaxParser('x = a + b');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<AssignmentExpression>());
      final assign = tree as AssignmentExpression;
      expect(assign.identifier, 'x');
      expect(assign.expression, isA<BinaryExpression>());
    });

    test('Parse chained assignment (right associative)', () {
      final parser = SyntaxParser('x = y = 5');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<AssignmentExpression>());
      final outer = tree as AssignmentExpression;
      expect(outer.identifier, 'x');
      expect(outer.expression, isA<AssignmentExpression>());
      final inner = outer.expression as AssignmentExpression;
      expect(inner.identifier, 'y');
    });
  });

  group('SyntaxParser - Ternary Expression Tests', () {
    test('Parse simple ternary expression', () {
      final parser = SyntaxParser('a ? b : c');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<TernaryExpression>());
      final ternary = tree as TernaryExpression;
      expect(ternary.condition, isA<VariableExpression>());
      expect(ternary.trueCase, isA<VariableExpression>());
      expect(ternary.falseCase, isA<VariableExpression>());
    });

    test('Parse ternary with literals', () {
      final parser = SyntaxParser('true ? 1 : 2');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<TernaryExpression>());
      final ternary = tree as TernaryExpression;
      expect(ternary.condition, isA<SyntaxLiteral>());
      expect(ternary.trueCase, isA<SyntaxLiteral>());
      expect(ternary.falseCase, isA<SyntaxLiteral>());
    });

    test('Parse ternary with expressions', () {
      final parser = SyntaxParser('a > b ? a + 1 : b - 1');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<TernaryExpression>());
      final ternary = tree as TernaryExpression;
      expect(ternary.condition, isA<BinaryExpression>());
      expect(ternary.trueCase, isA<BinaryExpression>());
      expect(ternary.falseCase, isA<BinaryExpression>());
    });

    test('Parse nested ternary (right associative)', () {
      final parser = SyntaxParser('a ? b : c ? d : e');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<TernaryExpression>());
      final outer = tree as TernaryExpression;
      expect(outer.falseCase, isA<TernaryExpression>());
    });
  });

  group('SyntaxParser - Member Expression Tests', () {
    setUp(() {
      VariableEnvironment.globalState.clear();
      VariableEnvironment.addOrUpdateVariable('obj', {'prop': 'value', 'prop1': 'value1', 'prop2': 'value2'});
      VariableEnvironment.addOrUpdateVariable('email', 'john@example.com');
      FunctionRegistry.register('func', (_) => {'prop': 'result'});
      FunctionRegistry.register('contains', (args) => (args[0] as String).contains(args[1]));
      FunctionRegistry.register(
        'getUser',
        (_) => {
          'name': 'John',
          'details': {'age': 30, 'city': 'NYC'},
        },
      );
    });

    test('Parse simple member access', () {
      final parser = SyntaxParser('obj.prop');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<MemberExpression>());
      final member = tree as MemberExpression;
      expect(member.obj, isA<VariableExpression>());
      expect(member.property, isA<SyntaxLiteral>());
    });

    test('Parse chained member access', () {
      final parser = SyntaxParser('obj.prop1.prop2');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<MemberExpression>());
      final outer = tree as MemberExpression;
      expect(outer.obj, isA<MemberExpression>());
    });

    test('Parse member access on function call', () {
      final parser = SyntaxParser('func().prop');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<MemberExpression>());
      final member = tree as MemberExpression;
      expect(member.obj, isA<FunctionExpression>());
    });

    test('Parse method call on object', () {
      final parser = SyntaxParser('email.contains("@")');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<MemberExpression>());
      final member = tree as MemberExpression;
      expect(member.obj, isA<VariableExpression>());
      expect(member.property, isA<FunctionExpression>());
    });

    test('Evaluate method call on object', () {
      final parser = SyntaxParser('email.contains("@")');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, true);
    });

    test('Evaluate property access on function result', () {
      final parser = SyntaxParser('func().prop');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 'result');
    });

    test('Evaluate nested function call with member access', () {
      final parser = SyntaxParser('getUser().details');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, {'age': 30, 'city': 'NYC'});
    });

    test('Evaluate deep property extraction', () {
      final parser = SyntaxParser('getUser().name');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 'John');
    });
  });

  group('SyntaxParser - Deep Member Access Tests', () {
    setUp(() {
      VariableEnvironment.globalState.clear();
      VariableEnvironment.addOrUpdateVariable('user', {
        'profile': {
          'details': {'age': 25, 'city': 'NYC'},
          'contact': 'john@example.com',
        },
        'posts': ['post1', 'post2', 'post3'],
      });
      VariableEnvironment.addOrUpdateVariable('order', {
        'customer': {'name': 'Alice', 'email': 'alice@example.com'},
        'status': 'pending',
      });
      FunctionRegistry.register(
        'getUser',
        (_) => {
          'name': 'John',
          'email': 'john@example.com',
          'profile': {'age': 30, 'active': true},
        },
      );
      FunctionRegistry.register('getOrder', (_) => VariableEnvironment.getValue('order'));
      FunctionRegistry.register('contains', (args) => (args[0] as String).contains(args[1]));
    });

    test('Parse triple nested member access', () {
      final parser = SyntaxParser('user.profile.details');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<MemberExpression>());
      final outer = tree as MemberExpression;
      expect(outer.obj, isA<MemberExpression>());
    });

    test('Evaluate triple nested member access', () {
      final parser = SyntaxParser('user.profile.details');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, {'age': 25, 'city': 'NYC'});
    });

    test('Parse method call on method result', () {
      final parser = SyntaxParser('getUser().email.contains("@")');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<MemberExpression>());
    });

    test('Evaluate method call on method result', () {
      final parser = SyntaxParser('getUser().email.contains("@")');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, true);
    });

    test('Evaluate complex nested property with methods in condition', () {
      final parser = SyntaxParser('getUser().email.contains("@") && getUser().profile.active');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, true);
    });

    test('Evaluate nested member access with ternary', () {
      final parser = SyntaxParser('getUser().profile.active ? getUser().name : "inactive"');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 'John');
    });

    test('Evaluate deep nested order customer email check', () {
      final parser = SyntaxParser('order.customer.email.contains("@")');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, true);
    });

    test('Evaluate conditional on deeply nested property', () {
      final parser = SyntaxParser('user.profile.contact.contains("@")');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, true);
    });
  });

  group('SyntaxParser - Complex Mixed Expression Tests', () {
    test('Parse complex arithmetic with mixed operators', () {
      final parser = SyntaxParser('1 + 2 * 3 - 4 / 2');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
    });

    test('Parse boolean expression with mixed operators', () {
      final parser = SyntaxParser('a < 5 && b > 3 || c == null');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
    });

    test('Parse assignment with complex expression', () {
      final parser = SyntaxParser('x = a + b * 2 > 10 ? 1 : 0');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<AssignmentExpression>());
    });

    test('Parse function call result used in binary operation', () {
      final parser = SyntaxParser('max(a, b) + min(c, d)');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
      final binary = tree as BinaryExpression;
      expect(binary.leftOperand, isA<FunctionExpression>());
      expect(binary.rightOperand, isA<FunctionExpression>());
    });

    test('Parse negation of expression result', () {
      final parser = SyntaxParser('-(a + b)');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<UnaryExpression>());
      final unary = tree as UnaryExpression;
      expect(unary.operand, isA<BinaryExpression>());
    });
  });

  group('SyntaxParser - Parentheses Tests', () {
    test('Parse single parentheses around literal', () {
      final parser = SyntaxParser('(5)');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<SyntaxLiteral>());
    });

    test('Parse multiple nested parentheses', () {
      final parser = SyntaxParser('(((5)))');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<SyntaxLiteral>());
    });

    test('Parse parentheses around binary expression', () {
      final parser = SyntaxParser('(a + b)');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
    });

    test('Parse complex parenthesized expression', () {
      final parser = SyntaxParser('((a + b) * (c - d)) / (e + f)');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
    });
  });

  group('SyntaxParser - Stress Tests - Deep Nesting', () {
    setUp(() {
      VariableEnvironment.globalState.clear();
      for (var i = 0; i < 10; i++) {
        VariableEnvironment.addOrUpdateVariable(String.fromCharCode(97 + i), i);
      }
      FunctionRegistry.register('f', (args) => args.isNotEmpty ? args[0] : 0);
      FunctionRegistry.register('g', (args) => args.isNotEmpty ? args[0] : 0);
      FunctionRegistry.register('h', (args) => args.isNotEmpty ? args[0] : 0);
      FunctionRegistry.register('i', (args) => args.isNotEmpty ? args[0] : 0);
      FunctionRegistry.register('j', (args) => args.isNotEmpty ? args[0] : 0);
      FunctionRegistry.register('k', (args) => args.isNotEmpty ? args[0] : 0);
    });

    test('Parse deeply nested addition', () {
      final parser = SyntaxParser('1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
    });

    test('Parse deeply nested multiplication', () {
      final parser = SyntaxParser('a * b * c * d * e * f * g * h');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
    });

    test('Parse deeply nested subtraction (left associative)', () {
      final parser = SyntaxParser('100 - 10 - 5 - 2 - 1');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
    });

    test('Parse deeply nested parentheses', () {
      final parser = SyntaxParser('((((((((((x))))))))))');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<VariableExpression>());
    });

    test('Parse deeply nested ternary', () {
      final parser = SyntaxParser('a ? b ? c ? d ? e : f : g : h : i');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<TernaryExpression>());
    });

    test('Parse deeply nested member access', () {
      final parser = SyntaxParser('a.b.c.d.e.f.g.h.i.j');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<MemberExpression>());
    });

    test('Parse nested function calls', () {
      final parser = SyntaxParser('f(g(h(i(j(k)))))');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<FunctionExpression>());
    });

    test('Parse complex nested function calls with arguments', () {
      final parser = SyntaxParser('max(min(a, b), add(c, d), sub(e, f))');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<FunctionExpression>());
      final func = tree as FunctionExpression;
      expect(func.parameter.length, 3);
    });
  });

  group('SyntaxParser - Stress Tests - Complex Expressions', () {
    test('Parse very complex mixed expression', () {
      final parser = SyntaxParser('(a + b * c) ^ 2 < 100 && (d / e - f) > 5 ? max(x, y) : min(z, w)');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<TernaryExpression>());
    });

    test('Parse expression with all operator types', () {
      final parser = SyntaxParser('a + b - c * d / e % f ^ g < h <= i > j >= k == l != m && n || o ? p : q');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<TernaryExpression>());
    });

    test('Parse expression with unary and binary operators mixed', () {
      final parser = SyntaxParser('!a && -b > 0 && !(c < 5)');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
    });

    test('Parse assignment with complex right side', () {
      final parser = SyntaxParser('result = -a * b + (c - d) / e ^ 2 > 0 ? x : y');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<AssignmentExpression>());
    });

    test('Parse function call with complex arguments', () {
      final parser = SyntaxParser('process(a + b * 2, c ? d : e, func(x, y), -z)');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<FunctionExpression>());
      final func = tree as FunctionExpression;
      expect(func.parameter.length, 4);
    });

    test('Parse member access in complex expression', () {
      final parser = SyntaxParser('obj.prop1 + obj.prop2 * obj.method().result - obj.nested.value');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
    });
  });

  group('SyntaxParser - Edge Cases', () {
    test('Parse single space separated items', () {
      final parser = SyntaxParser('a + b');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
    });

    test('Parse with multiple spaces', () {
      final parser = SyntaxParser('a    +    b');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
    });

    test('Parse with no spaces', () {
      final parser = SyntaxParser('a+b');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
    });

    test('Parse mixed spacing and operators', () {
      final parser = SyntaxParser('a +b * c- d');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<BinaryExpression>());
    });

    test('Parse zero number', () {
      final parser = SyntaxParser('0');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<SyntaxLiteral>());
      final lit = tree as SyntaxLiteral;
      expect(lit.value, 0);
    });

    test('Parse large number', () {
      final parser = SyntaxParser('999999999');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<SyntaxLiteral>());
    });

    test('Parse empty string literal', () {
      final parser = SyntaxParser('""');
      final tree = parser.parseSyntaxTree();
      expect(tree, isA<SyntaxLiteral>());
      final lit = tree as SyntaxLiteral;
      expect(lit.value, '');
    });
  });

  group('SyntaxParser - Error Handling', () {
    test('Throw exception for invalid input with unknown character', () {
      expect(() => SyntaxParser('a @ b').parseSyntaxTree(), throwsException);
    });

    test('Throw exception for unclosed string', () {
      expect(() => SyntaxParser('a + "unclosed').parseSyntaxTree(), throwsException);
    });

    test('Throw exception for unclosed parenthesis', () {
      expect(() => SyntaxParser('(a + b').parseSyntaxTree(), throwsException);
    });

    test('Throw exception for unmatched closing parenthesis', () {
      expect(() => SyntaxParser('a + b)').parseSyntaxTree(), throwsException);
    });

    test('Throw exception for operator at start (except unary)', () {
      expect(() => SyntaxParser('* a + b').parseSyntaxTree(), throwsException);
    });
  });

  group('SyntaxParser - Real World Examples', () {
    setUp(() {
      VariableEnvironment.globalState.clear();
      VariableEnvironment.addOrUpdateVariable('age', 25);
      VariableEnvironment.addOrUpdateVariable('citizen', true);
      VariableEnvironment.addOrUpdateVariable('price', 120);
      VariableEnvironment.addOrUpdateVariable('name', 'John');
      VariableEnvironment.addOrUpdateVariable('email', 'john@example.com');
      VariableEnvironment.addOrUpdateVariable('test1', 70);
      VariableEnvironment.addOrUpdateVariable('test2', 80);
      VariableEnvironment.addOrUpdateVariable('test3', 75);
      VariableEnvironment.addOrUpdateVariable('principal', 1000);
      VariableEnvironment.addOrUpdateVariable('rate', 5);
      VariableEnvironment.addOrUpdateVariable('years', 2);
      VariableEnvironment.addOrUpdateVariable('status', 'active');
      VariableEnvironment.addOrUpdateVariable('balance', 500);
      VariableEnvironment.addOrUpdateVariable('minBalance', 100);
      VariableEnvironment.addOrUpdateVariable('allowed', 'yes');
      VariableEnvironment.addOrUpdateVariable('restricted', 'no');
      VariableEnvironment.addOrUpdateVariable('data', [1, 2, 3, 4, 5]);
      VariableEnvironment.addOrUpdateVariable('fn', (x) => x * 2);
      VariableEnvironment.addOrUpdateVariable('condition', (x) => x > 2);
      VariableEnvironment.addOrUpdateVariable('sort', (list) => (list as List)..sort());
      FunctionRegistry.register('length', (args) => (args[0] as String).length);
      FunctionRegistry.register('contains', (args) => (args[0] as String).contains(args[1]));
      FunctionRegistry.register('map', (args) {
        final List list = args[0];
        final Function fn = args[1];
        return list.map((e) => fn(e)).toList();
      });
      FunctionRegistry.register('filter', (args) {
        final List list = args[0];
        final Function condition = args[1];
        return list.where((e) => condition(e)).toList();
      });
      FunctionRegistry.register('transform', (args) {
        final List list = args[0];
        final Function transformFn = args[1];
        return transformFn(list);
      });
    });

    test('Parse age check expression', () {
      final parser = SyntaxParser('age >= 18 && citizen == true');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();

      expect(result, true);
      expect(tree, isA<BinaryExpression>());
    });

    test('Parse discount calculation', () {
      final parser = SyntaxParser('price > 100 ? price * 0.9 : price * 0.95');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();

      expect(result, 108);
      expect(tree, isA<TernaryExpression>());
    });

    test('Parse validation logic', () {
      final parser = SyntaxParser('name != null && length(name) > 0 && email.contains("@")');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();

      expect(result, true);
      expect(tree, isA<BinaryExpression>());
    });

    test('Parse grade calculation', () {
      final parser = SyntaxParser('(test1 + test2 + test3) / 3 >= 60 ? "passed" : "failed"');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();

      expect(result, 'passed');
      expect(tree, isA<TernaryExpression>());
    });

    test('Parse compound interest formula', () {
      final parser = SyntaxParser('principal * (1 + rate / 100) ^ years');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();

      expect(result, 1102.5);
      expect(tree, isA<BinaryExpression>());
    });

    test('Parse complex business logic', () {
      final parser = SyntaxParser('status == "active" && balance >= minBalance ? allowed : restricted');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();

      expect(result, 'yes');
      expect(tree, isA<TernaryExpression>());
    });

    test('Parse data transformation', () {
      final parser = SyntaxParser('transform(filter(map(data, fn), condition), sort)');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();

      expect(result, [4, 6, 8, 10]);
      expect(tree, isA<FunctionExpression>());
    });
  });

  group('SyntaxParser - Evaluation with Variable Environment', () {
    setUp(() {
      VariableEnvironment.globalState.clear();
    });

    test('Evaluate simple variable', () {
      VariableEnvironment.addOrUpdateVariable('x', 5);
      final parser = SyntaxParser('x');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 5);
    });

    test('Evaluate variable in arithmetic expression', () {
      VariableEnvironment.addOrUpdateVariable('a', 10);
      VariableEnvironment.addOrUpdateVariable('b', 5);
      final parser = SyntaxParser('a + b');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 15);
    });

    test('Evaluate assignment expression', () {
      final parser = SyntaxParser('x = 42');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 42);
      expect(VariableEnvironment.getValue('x'), 42);
    });

    test('Evaluate assignment with expression', () {
      VariableEnvironment.addOrUpdateVariable('a', 5);
      VariableEnvironment.addOrUpdateVariable('b', 3);
      final parser = SyntaxParser('c = a * b + 2');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 17);
      expect(VariableEnvironment.getValue('c'), 17);
    });

    test('Evaluate complex variable expression', () {
      VariableEnvironment.addOrUpdateVariable('x', 3);
      VariableEnvironment.addOrUpdateVariable('y', 4);
      final parser = SyntaxParser('x ^ 2 + y ^ 2');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 25);
    });

    test('Evaluate ternary with variables', () {
      VariableEnvironment.addOrUpdateVariable('age', 25);
      final parser = SyntaxParser('age >= 18 ? "adult" : "minor"');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 'adult');
    });

    test('Evaluate multiple assignments chain', () {
      final parser = SyntaxParser('x = y = z = 10');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 10);
      expect(VariableEnvironment.getValue('x'), 10);
      expect(VariableEnvironment.getValue('y'), 10);
      expect(VariableEnvironment.getValue('z'), 10);
    });

    test('Evaluate variable used before assignment', () {
      final parser = SyntaxParser('uninitialized');
      final tree = parser.parseSyntaxTree();
      expect(tree.evaluate, throwsException);
    });
  });

  group('SyntaxParser - Evaluation with Function Registry', () {
    test('Evaluate function call with no arguments', () {
      FunctionRegistry.register('getvalue', (_) => 42);
      final parser = SyntaxParser('getvalue()');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 42);
    });

    test('Evaluate function call with single argument', () {
      FunctionRegistry.register('double', (args) => args[0] * 2);
      final parser = SyntaxParser('double(5)');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 10);
    });

    test('Evaluate function call with multiple arguments', () {
      FunctionRegistry.register('add', (args) => args[0] + args[1]);
      final parser = SyntaxParser('add(3, 7)');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 10);
    });

    test('Evaluate function with variable arguments', () {
      VariableEnvironment.addOrUpdateVariable('x', 5);
      VariableEnvironment.addOrUpdateVariable('y', 3);
      FunctionRegistry.register('max', (args) {
        args.sort();
        return args.last;
      });
      final parser = SyntaxParser('max(x, y, 10)');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 10);
    });

    test('Evaluate nested function calls', () {
      FunctionRegistry.register('double', (args) => args[0] * 2);
      FunctionRegistry.register('add', (args) => args[0] + args[1]);
      final parser = SyntaxParser('add(double(5), 3)');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 13);
    });

    test('Evaluate function call in binary expression', () {
      FunctionRegistry.register('abs', (args) => args[0].abs());
      final parser = SyntaxParser('abs(-5) + 10');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 15);
    });

    test('Evaluate function with expression arguments', () {
      FunctionRegistry.register('sum', (args) => args.reduce((a, b) => a + b));
      final parser = SyntaxParser('sum(1 + 2, 3 * 4, 5)');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 20);
    });

    test('Evaluate function with ternary argument', () {
      FunctionRegistry.register('abs', (args) => args[0].abs());
      VariableEnvironment.addOrUpdateVariable('x', -10);
      final parser = SyntaxParser('abs(x > 0 ? x : -x)');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 10);
    });

    test('Evaluate function with unary operator argument', () {
      FunctionRegistry.register('not', (args) => !args[0]);
      final parser = SyntaxParser('not(!true)');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, true);
    });

    test('Throw exception for unregistered function', () {
      final parser = SyntaxParser('unknownFunc(5)');
      final tree = parser.parseSyntaxTree();
      expect(() => tree.evaluate(), throwsException);
    });
  });

  group('SyntaxParser - Complex Evaluation Tests', () {
    setUp(() {
      VariableEnvironment.globalState.clear();
    });

    test('Evaluate expression mixing variables and functions', () {
      VariableEnvironment.addOrUpdateVariable('a', 5);
      FunctionRegistry.register('double', (args) => args[0] * 2);
      final parser = SyntaxParser('double(a) + a');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 15);
    });

    test('Evaluate complex business logic', () {
      VariableEnvironment.addOrUpdateVariable('balance', 150);
      VariableEnvironment.addOrUpdateVariable('minBalance', 100);
      final parser = SyntaxParser('balance >= minBalance ? "allowed" : "blocked"');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 'allowed');
    });

    test('Evaluate mathematical expression with functions', () {
      FunctionRegistry.register('sqrt', (args) => sqrt((args[0] as num).toDouble()));
      final parser = SyntaxParser('sqrt(16) + 2');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 6);
    });

    test('Evaluate chained calculations', () {
      VariableEnvironment.addOrUpdateVariable('x', 2);
      FunctionRegistry.register('square', (args) => args[0] * args[0]);
      final parser = SyntaxParser('square(x) + square(x)');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 8);
    });

    test('Evaluate conditional with function result', () {
      FunctionRegistry.register('isEven', (args) => args[0] % 2 == 0);
      final parser = SyntaxParser('isEven(4) && isEven(5)');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, false);
    });

    test('Evaluate function returning boolean used in ternary', () {
      FunctionRegistry.register('isPositive', (args) => args[0] > 0);
      VariableEnvironment.addOrUpdateVariable('num', 5);
      final parser = SyntaxParser('isPositive(num) ? "yes" : "no"');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 'yes');
    });

    test('Evaluate with assignment and function', () {
      FunctionRegistry.register('factorial', (args) {
        var n = args[0] as int;
        var result = 1;
        for (var i = 2; i <= n; i++) {
          result *= i;
        }
        return result;
      });
      final parser = SyntaxParser('result = factorial(5)');
      final tree = parser.parseSyntaxTree();
      final evaluationResult = tree.evaluate();
      expect(evaluationResult, 120);
      expect(VariableEnvironment.getValue('result'), 120);
    });

    test('Evaluate deeply nested function calls with variables', () {
      VariableEnvironment.addOrUpdateVariable('x', 2);
      FunctionRegistry.register('add', (args) => args[0] + args[1]);
      FunctionRegistry.register('multiply', (args) => args[0] * args[1]);
      final parser = SyntaxParser('multiply(add(x, 3), add(x, 1))');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 15);
    });

    test('Evaluate real-world discount calculation', () {
      VariableEnvironment.addOrUpdateVariable('price', 100);
      VariableEnvironment.addOrUpdateVariable('discount', 10);
      FunctionRegistry.register('percentOf', (args) => (args[0] * args[1]) / 100);
      final parser = SyntaxParser('price - percentOf(price, discount)');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 90);
    });

    test('Evaluate real-world age classification', () {
      VariableEnvironment.addOrUpdateVariable('age', 15);
      FunctionRegistry.register('category', (args) {
        final age = args[0] as int;
        if (age < 13) return 'child';
        if (age < 18) return 'teen';
        if (age < 65) return 'adult';
        return 'senior';
      });
      final parser = SyntaxParser('category(age) == "teen" ? "in_teen_group" : "not_teen"');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 'in_teen_group');
    });
  });

  group('SyntaxParser - Stress Tests with Environments', () {
    setUp(() {
      VariableEnvironment.globalState.clear();
    });

    test('Evaluate many variables in complex expression', () {
      for (var i = 0; i < 10; i++) {
        VariableEnvironment.addOrUpdateVariable('v$i', i);
      }
      final parser = SyntaxParser('v0 + v1 + v2 + v3 + v4 + v5 + v6 + v7 + v8 + v9');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 45);
    });

    test('Evaluate deeply nested function calls', () {
      FunctionRegistry.register('inc', (args) => args[0] + 1);
      final parser = SyntaxParser('inc(inc(inc(inc(inc(0)))))');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 5);
    });

    test('Evaluate complex mixed expression with all operators', () {
      VariableEnvironment.addOrUpdateVariable('a', 10);
      VariableEnvironment.addOrUpdateVariable('b', 2);
      FunctionRegistry.register('max', (args) {
        args.sort();
        return args.last;
      });
      final parser = SyntaxParser('(a + b) * 2 > 20 && max(a, b) == 10 ? a - b : b * a');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 8);
    });

    test('Evaluate with multiple function registrations', () {
      FunctionRegistry.register('add', (args) => args[0] + args[1]);
      FunctionRegistry.register('subtract', (args) => args[0] - args[1]);
      FunctionRegistry.register('multiply', (args) => args[0] * args[1]);
      FunctionRegistry.register('divide', (args) => args[0] / args[1]);
      final parser = SyntaxParser('divide(multiply(add(10, 5), 2), subtract(5, 2))');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 10);
    });

    test('Evaluate updating variable multiple times', () {
      final parser1 = SyntaxParser('counter = 1');
      final result1 = parser1.parseSyntaxTree().evaluate();
      expect(result1, 1);

      final parser2 = SyntaxParser('counter = counter + 5');
      final result2 = parser2.parseSyntaxTree().evaluate();
      expect(result2, 6);

      final parser3 = SyntaxParser('counter = counter * 2');
      final result3 = parser3.parseSyntaxTree().evaluate();
      expect(result3, 12);

      expect(VariableEnvironment.getValue('counter'), 12);
    });

    test('Evaluate function combining multiple variables', () {
      VariableEnvironment.addOrUpdateVariable('x', 3);
      VariableEnvironment.addOrUpdateVariable('y', 4);
      VariableEnvironment.addOrUpdateVariable('z', 5);
      FunctionRegistry.register('sum', (args) => args.reduce((a, b) => a + b) as num);
      final parser = SyntaxParser('sum(x, y, z) * 2');
      final tree = parser.parseSyntaxTree();
      final result = tree.evaluate();
      expect(result, 24);
    });
  });
}
