import 'package:pratt_parser/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:test/test.dart';

void main() {
  group('SubtractionAssignmentOperator Tests', () {
    final operator = SyntaxOperator.fromSymbol('-=') as SubtractionAssignmentOperator;

    group('Operator Properties', () {
      test('SubtractionAssignmentOperator has correct symbol', () {
        expect(operator.symbol, '-=');
      });

      test('SubtractionAssignmentOperator has correct precedence', () {
        expect(operator.precedence, 0);
      });

      test('SubtractionAssignmentOperator has right associativity', () {
        expect(operator.associativity, Associativity.right);
      });

      test('SubtractionAssignmentOperator toString contains correct information', () {
        final str = operator.toString();
        expect(str.contains('-=') || str.contains('-='), true);
        expect(str.contains('0'), true);
        expect(str.contains('right'), true);
      });
    });

    group('Type Checking', () {
      test('SubtractionAssignmentOperator is instance of AssignmentOperator', () {
        expect(operator, isA<AssignmentOperator>());
      });

      test('SubtractionAssignmentOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('Equality Tests', () {
      test('Two SubtractionAssignmentOperator instances with same symbol are equal', () {
        final op1 = SyntaxOperator.fromSymbol('-=') as SubtractionAssignmentOperator;
        final op2 = SyntaxOperator.fromSymbol('-=') as SubtractionAssignmentOperator;
        expect(op1, equals(op2));
      });

      test('SubtractionAssignmentOperator is not equal to MultiplicationAssignmentOperator', () {
        final subOp = SyntaxOperator.fromSymbol('-=') as SubtractionAssignmentOperator;
        final mulOp = SyntaxOperator.fromSymbol('*=') as MultiplicationAssignmentOperator;
        expect(subOp, isNot(equals(mulOp)));
      });
    });

    group('Hash Code Tests', () {
      test('Two SubtractionAssignmentOperator instances have same hash code', () {
        final op1 = SyntaxOperator.fromSymbol('-=') as SubtractionAssignmentOperator;
        final op2 = SyntaxOperator.fromSymbol('-=') as SubtractionAssignmentOperator;
        expect(op1.hashCode, equals(op2.hashCode));
      });
    });

    group('Edge Cases', () {
      test('SubtractionAssignmentOperator symbol is exactly "-="', () {
        expect(operator.symbol, equals('-='));
        expect(operator.symbol.length, 2);
      });

      test('SubtractionAssignmentOperator precedence is zero', () {
        expect(operator.precedence, 0);
      });
    });
  });
}
