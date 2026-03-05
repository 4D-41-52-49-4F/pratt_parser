import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:test/test.dart';

void main() {
  group('UnaryMinusOperator Tests', () {
    final operator = UnaryOperator.fromSymbol('-') as UnaryMinusOperator;

    group('Operator Properties', () {
      test('UnaryMinusOperator has correct symbol', () {
        expect(operator.symbol, '-');
      });

      test('UnaryMinusOperator has correct precedence', () {
        expect(operator.precedence, 8);
      });

      test('UnaryMinusOperator has right associativity', () {
        expect(operator.associativity, Associativity.right);
      });

      test('UnaryMinusOperator toString contains correct information', () {
        final str = operator.toString();
        expect(str.contains('-'), true);
        expect(str.contains('8'), true);
        expect(str.contains('right'), true);
      });
    });

    group('Type Checking', () {
      test('UnaryMinusOperator is instance of UnaryOperator', () {
        expect(operator, isA<UnaryOperator>());
      });

      test('UnaryMinusOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('Equality Tests', () {
      test('Two UnaryMinusOperator instances with same symbol are equal', () {
        final op1 = UnaryOperator.fromSymbol('-') as UnaryMinusOperator;
        final op2 = UnaryOperator.fromSymbol('-') as UnaryMinusOperator;
        expect(op1, equals(op2));
      });

      test('UnaryMinusOperator is not equal to NotOperator', () {
        final minusOp = UnaryOperator.fromSymbol('-') as UnaryMinusOperator;
        final notOp = UnaryOperator.fromSymbol('!') as NotOperator;
        expect(minusOp, isNot(equals(notOp)));
      });
    });

    group('Hash Code Tests', () {
      test('Two UnaryMinusOperator instances have same hash code', () {
        final op1 = UnaryOperator.fromSymbol('-') as UnaryMinusOperator;
        final op2 = UnaryOperator.fromSymbol('-') as UnaryMinusOperator;
        expect(op1.hashCode, equals(op2.hashCode));
      });
    });

    group('Edge Cases', () {
      test('UnaryMinusOperator symbol is exactly "-"', () {
        expect(operator.symbol, equals('-'));
        expect(operator.symbol.length, 1);
      });

      test('UnaryMinusOperator precedence is positive', () {
        expect(operator.precedence, greaterThan(0));
      });
    });
  });
}
