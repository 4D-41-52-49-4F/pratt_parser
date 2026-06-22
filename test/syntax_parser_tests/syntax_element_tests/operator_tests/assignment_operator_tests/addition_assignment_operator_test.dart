import 'package:pratt_parser/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:test/test.dart';

void main() {
  group('AdditionAssignmentOperator Tests', () {
    final operator = SyntaxOperator.fromSymbol('+=') as AdditionAssignmentOperator;

    group('Operator Properties', () {
      test('AdditionAssignmentOperator has correct symbol', () {
        expect(operator.symbol, '+=');
      });

      test('AdditionAssignmentOperator has correct precedence', () {
        expect(operator.precedence, 0);
      });

      test('AdditionAssignmentOperator has right associativity', () {
        expect(operator.associativity, Associativity.right);
      });

      test('AdditionAssignmentOperator toString contains correct information', () {
        final str = operator.toString();
        expect(str.contains('+=') || str.contains('+='), true);
        expect(str.contains('0'), true);
        expect(str.contains('right'), true);
      });
    });

    group('Type Checking', () {
      test('AdditionAssignmentOperator is instance of AssignmentOperator', () {
        expect(operator, isA<AssignmentOperator>());
      });

      test('AdditionAssignmentOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('Equality Tests', () {
      test('Two AdditionAssignmentOperator instances with same symbol are equal', () {
        final op1 = SyntaxOperator.fromSymbol('+=') as AdditionAssignmentOperator;
        final op2 = SyntaxOperator.fromSymbol('+=') as AdditionAssignmentOperator;
        expect(op1, equals(op2));
      });

      test('AdditionAssignmentOperator is not equal to SubtractionAssignmentOperator', () {
        final addOp = SyntaxOperator.fromSymbol('+=') as AdditionAssignmentOperator;
        final subOp = SyntaxOperator.fromSymbol('-=') as SubtractionAssignmentOperator;
        expect(addOp, isNot(equals(subOp)));
      });
    });

    group('Hash Code Tests', () {
      test('Two AdditionAssignmentOperator instances have same hash code', () {
        final op1 = SyntaxOperator.fromSymbol('+=') as AdditionAssignmentOperator;
        final op2 = SyntaxOperator.fromSymbol('+=') as AdditionAssignmentOperator;
        expect(op1.hashCode, equals(op2.hashCode));
      });
    });

    group('Edge Cases', () {
      test('AdditionAssignmentOperator symbol is exactly "+="', () {
        expect(operator.symbol, equals('+='));
        expect(operator.symbol.length, 2);
      });

      test('AdditionAssignmentOperator precedence is zero', () {
        expect(operator.precedence, 0);
      });
    });
  });
}
