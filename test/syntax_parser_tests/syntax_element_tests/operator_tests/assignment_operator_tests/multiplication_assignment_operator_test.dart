import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:test/test.dart';

void main() {
  group('MultiplicationAssignmentOperator Tests', () {
    final operator = SyntaxOperator.fromSymbol('*=') as MultiplicationAssignmentOperator;

    group('Operator Properties', () {
      test('MultiplicationAssignmentOperator has correct symbol', () {
        expect(operator.symbol, '*=');
      });

      test('MultiplicationAssignmentOperator has correct precedence', () {
        expect(operator.precedence, 0);
      });

      test('MultiplicationAssignmentOperator has right associativity', () {
        expect(operator.associativity, Associativity.right);
      });

      test('MultiplicationAssignmentOperator toString contains correct information', () {
        final str = operator.toString();
        expect(str.contains('*=') || str.contains('*=') || str.contains('*='), true);
        expect(str.contains('0'), true);
        expect(str.contains('right'), true);
      });
    });

    group('Type Checking', () {
      test('MultiplicationAssignmentOperator is instance of AssignmentOperator', () {
        expect(operator, isA<AssignmentOperator>());
      });

      test('MultiplicationAssignmentOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('Equality Tests', () {
      test('Two MultiplicationAssignmentOperator instances with same symbol are equal', () {
        final op1 = SyntaxOperator.fromSymbol('*=') as MultiplicationAssignmentOperator;
        final op2 = SyntaxOperator.fromSymbol('*=') as MultiplicationAssignmentOperator;
        expect(op1, equals(op2));
      });

      test('MultiplicationAssignmentOperator is not equal to DivisionAssignmentOperator', () {
        final mulOp = SyntaxOperator.fromSymbol('*=') as MultiplicationAssignmentOperator;
        final divOp = SyntaxOperator.fromSymbol('/=') as DivisionAssignmentOperator;
        expect(mulOp, isNot(equals(divOp)));
      });
    });

    group('Hash Code Tests', () {
      test('Two MultiplicationAssignmentOperator instances have same hash code', () {
        final op1 = SyntaxOperator.fromSymbol('*=') as MultiplicationAssignmentOperator;
        final op2 = SyntaxOperator.fromSymbol('*=') as MultiplicationAssignmentOperator;
        expect(op1.hashCode, equals(op2.hashCode));
      });
    });

    group('Edge Cases', () {
      test('MultiplicationAssignmentOperator symbol is exactly "*="', () {
        expect(operator.symbol, equals('*='));
        expect(operator.symbol.length, 2);
      });

      test('MultiplicationAssignmentOperator precedence is zero', () {
        expect(operator.precedence, 0);
      });
    });
  });
}
