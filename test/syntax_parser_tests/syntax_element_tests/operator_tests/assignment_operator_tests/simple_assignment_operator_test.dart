import 'package:pratt_parser/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:test/test.dart';

void main() {
  group('SimpleAssignmentOperator Tests', () {
    final operator = SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator;

    group('Operator Properties', () {
      test('SimpleAssignmentOperator has correct symbol', () {
        expect(operator.symbol, '=');
      });

      test('SimpleAssignmentOperator has correct precedence', () {
        expect(operator.precedence, 0);
      });

      test('SimpleAssignmentOperator has right associativity', () {
        expect(operator.associativity, Associativity.right);
      });

      test('SimpleAssignmentOperator toString contains correct information', () {
        final str = operator.toString();
        expect(str.contains('='), true);
        expect(str.contains('0'), true);
        expect(str.contains('right'), true);
      });
    });

    group('Type Checking', () {
      test('SimpleAssignmentOperator is instance of AssignmentOperator', () {
        expect(operator, isA<AssignmentOperator>());
      });

      test('SimpleAssignmentOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('Equality Tests', () {
      test('Two SimpleAssignmentOperator instances with same symbol are equal', () {
        final op1 = SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator;
        final op2 = SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator;
        expect(op1, equals(op2));
      });

      test('SimpleAssignmentOperator is not equal to AdditionAssignmentOperator', () {
        final simpleOp = SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator;
        final addOp = SyntaxOperator.fromSymbol('+=') as AdditionAssignmentOperator;
        expect(simpleOp, isNot(equals(addOp)));
      });
    });

    group('Hash Code Tests', () {
      test('Two SimpleAssignmentOperator instances have same hash code', () {
        final op1 = SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator;
        final op2 = SyntaxOperator.fromSymbol('=') as SimpleAssignmentOperator;
        expect(op1.hashCode, equals(op2.hashCode));
      });
    });

    group('Edge Cases', () {
      test('SimpleAssignmentOperator symbol is exactly "="', () {
        expect(operator.symbol, equals('='));
        expect(operator.symbol.length, 1);
      });

      test('SimpleAssignmentOperator precedence is zero', () {
        expect(operator.precedence, 0);
      });
    });
  });
}
