import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:test/test.dart';

void main() {
  group('Equality Operators Tests', () {
    group('EqualOperator', () {
      final operator = SyntaxOperator.fromSymbol('==') as EqualOperator;

      test('EqualOperator has correct symbol', () {
        expect(operator.symbol, '==');
      });

      test('EqualOperator has correct precedence', () {
        expect(operator.precedence, 4);
      });

      test('EqualOperator has left associativity', () {
        expect(operator.associativity, Associativity.left);
      });

      test('EqualOperator is instance of EqualityOperator', () {
        expect(operator, isA<EqualityOperator>());
      });

      test('EqualOperator is instance of BinaryOperator', () {
        expect(operator, isA<BinaryOperator>());
      });

      test('EqualOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('NotEqualOperator', () {
      final operator = SyntaxOperator.fromSymbol('!=') as NotEqualOperator;

      test('NotEqualOperator has correct symbol', () {
        expect(operator.symbol, '!=');
      });

      test('NotEqualOperator has correct precedence', () {
        expect(operator.precedence, 4);
      });

      test('NotEqualOperator has left associativity', () {
        expect(operator.associativity, Associativity.left);
      });

      test('NotEqualOperator is instance of EqualityOperator', () {
        expect(operator, isA<EqualityOperator>());
      });

      test('NotEqualOperator is instance of BinaryOperator', () {
        expect(operator, isA<BinaryOperator>());
      });

      test('NotEqualOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });
  });
}
