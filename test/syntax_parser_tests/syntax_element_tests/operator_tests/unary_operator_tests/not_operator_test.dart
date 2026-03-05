import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:test/test.dart';

void main() {
  group('NotOperator Tests', () {
    final operator = UnaryOperator.fromSymbol('!') as NotOperator;

    group('Operator Properties', () {
      test('NotOperator has correct symbol', () {
        expect(operator.symbol, '!');
      });

      test('NotOperator has correct precedence', () {
        expect(operator.precedence, 8);
      });

      test('NotOperator has right associativity', () {
        expect(operator.associativity, Associativity.right);
      });

      test('NotOperator toString contains correct information', () {
        final str = operator.toString();
        expect(str.contains('!'), true);
        expect(str.contains('8'), true);
        expect(str.contains('right'), true);
      });
    });

    group('Type Checking', () {
      test('NotOperator is instance of UnaryOperator', () {
        expect(operator, isA<UnaryOperator>());
      });

      test('NotOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('Equality Tests', () {
      test('Two NotOperator instances with same symbol are equal', () {
        final op1 = UnaryOperator.fromSymbol('!') as NotOperator;
        final op2 = UnaryOperator.fromSymbol('!') as NotOperator;
        expect(op1, equals(op2));
      });

      test('NotOperator is not equal to UnaryMinusOperator', () {
        final notOp = UnaryOperator.fromSymbol('!') as NotOperator;
        final minusOp = UnaryOperator.fromSymbol('-') as UnaryMinusOperator;
        expect(notOp, isNot(equals(minusOp)));
      });
    });

    group('Hash Code Tests', () {
      test('Two NotOperator instances have same hash code', () {
        final op1 = UnaryOperator.fromSymbol('!') as NotOperator;
        final op2 = UnaryOperator.fromSymbol('!') as NotOperator;
        expect(op1.hashCode, equals(op2.hashCode));
      });
    });

    group('Edge Cases', () {
      test('NotOperator symbol is exactly "!"', () {
        expect(operator.symbol, equals('!'));
        expect(operator.symbol.length, 1);
      });

      test('NotOperator precedence is positive', () {
        expect(operator.precedence, greaterThan(0));
      });
    });
  });
}
