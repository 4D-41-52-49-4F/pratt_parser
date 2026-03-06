import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:test/test.dart';

void main() {
  group('DotOperator Tests', () {
    final operator = SyntaxOperator.fromSymbol('.') as DotOperator;

    group('Operator Properties', () {
      test('DotOperator has correct symbol', () {
        expect(operator.symbol, '.');
      });

      test('DotOperator has correct precedence', () {
        expect(operator.precedence, 10);
      });

      test('DotOperator has right associativity', () {
        expect(operator.associativity, Associativity.right);
      });

      test('DotOperator toString contains correct information', () {
        final str = operator.toString();
        expect(str.contains('.'), true);
        expect(str.contains('10'), true);
        expect(str.contains('right'), true);
      });
    });

    group('Type Checking', () {
      test('DotOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('Equality Tests', () {
      test('Two DotOperator instances are equal', () {
        final op1 = SyntaxOperator.fromSymbol('.') as DotOperator;
        final op2 = SyntaxOperator.fromSymbol('.') as DotOperator;
        expect(op1, equals(op2));
      });
    });
  });
}
