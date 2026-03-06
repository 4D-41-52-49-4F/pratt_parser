import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:test/test.dart';

void main() {
  group('DivisionAssignmentOperator Tests', () {
    final operator = SyntaxOperator.fromSymbol('/=') as DivisionAssignmentOperator;

    group('Operator Properties', () {
      test('DivisionAssignmentOperator has correct symbol', () {
        expect(operator.symbol, '/=');
      });

      test('DivisionAssignmentOperator has correct precedence', () {
        expect(operator.precedence, 0);
      });

      test('DivisionAssignmentOperator has right associativity', () {
        expect(operator.associativity, Associativity.right);
      });

      test('DivisionAssignmentOperator toString contains correct information', () {
        final str = operator.toString();
        expect(str.contains('/=') || str.contains('/=') || str.contains('/='), true);
        expect(str.contains('0'), true);
        expect(str.contains('right'), true);
      });
    });

    group('Type Checking', () {
      test('DivisionAssignmentOperator is instance of AssignmentOperator', () {
        expect(operator, isA<AssignmentOperator>());
      });

      test('DivisionAssignmentOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('Equality Tests', () {
      test('Two DivisionAssignmentOperator instances with same symbol are equal', () {
        final op1 = SyntaxOperator.fromSymbol('/=') as DivisionAssignmentOperator;
        final op2 = SyntaxOperator.fromSymbol('/=') as DivisionAssignmentOperator;
        expect(op1, equals(op2));
      });

      test('DivisionAssignmentOperator is not equal to MultiplicationAssignmentOperator', () {
        final divOp = SyntaxOperator.fromSymbol('/=') as DivisionAssignmentOperator;
        final mulOp = SyntaxOperator.fromSymbol('*=') as MultiplicationAssignmentOperator;
        expect(divOp, isNot(equals(mulOp)));
      });
    });

    group('Hash Code Tests', () {
      test('Two DivisionAssignmentOperator instances have same hash code', () {
        final op1 = SyntaxOperator.fromSymbol('/=') as DivisionAssignmentOperator;
        final op2 = SyntaxOperator.fromSymbol('/=') as DivisionAssignmentOperator;
        expect(op1.hashCode, equals(op2.hashCode));
      });
    });

    group('Edge Cases', () {
      test('DivisionAssignmentOperator symbol is exactly "/="', () {
        expect(operator.symbol, equals('/='));
        expect(operator.symbol.length, 2);
      });

      test('DivisionAssignmentOperator precedence is zero', () {
        expect(operator.precedence, 0);
      });
    });
  });
}
