import 'package:pratt_parser/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:test/test.dart';

void main() {
  group('Relational Operators Tests', () {
    group('LessThanOperator', () {
      final operator = SyntaxOperator.fromSymbol('<') as LessThanOperator;

      test('LessThanOperator has correct symbol', () {
        expect(operator.symbol, '<');
      });

      test('LessThanOperator has correct precedence', () {
        expect(operator.precedence, 5);
      });

      test('LessThanOperator has left associativity', () {
        expect(operator.associativity, Associativity.left);
      });

      test('LessThanOperator is instance of RelationalOperator', () {
        expect(operator, isA<RelationalOperator>());
      });

      test('LessThanOperator is instance of BinaryOperator', () {
        expect(operator, isA<BinaryOperator>());
      });

      test('LessThanOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('LessThanOrEqualOperator', () {
      final operator = SyntaxOperator.fromSymbol('<=') as LessThanOrEqualOperator;

      test('LessThanOrEqualOperator has correct symbol', () {
        expect(operator.symbol, '<=');
      });

      test('LessThanOrEqualOperator has correct precedence', () {
        expect(operator.precedence, 5);
      });

      test('LessThanOrEqualOperator has left associativity', () {
        expect(operator.associativity, Associativity.left);
      });

      test('LessThanOrEqualOperator is instance of RelationalOperator', () {
        expect(operator, isA<RelationalOperator>());
      });

      test('LessThanOrEqualOperator is instance of BinaryOperator', () {
        expect(operator, isA<BinaryOperator>());
      });

      test('LessThanOrEqualOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('GreaterThanOperator', () {
      final operator = SyntaxOperator.fromSymbol('>') as GreaterThanOperator;

      test('GreaterThanOperator has correct symbol', () {
        expect(operator.symbol, '>');
      });

      test('GreaterThanOperator has correct precedence', () {
        expect(operator.precedence, 5);
      });

      test('GreaterThanOperator has left associativity', () {
        expect(operator.associativity, Associativity.left);
      });

      test('GreaterThanOperator is instance of RelationalOperator', () {
        expect(operator, isA<RelationalOperator>());
      });

      test('GreaterThanOperator is instance of BinaryOperator', () {
        expect(operator, isA<BinaryOperator>());
      });

      test('GreaterThanOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('GreaterThanOrEqualOperator', () {
      final operator = SyntaxOperator.fromSymbol('>=') as GreaterThanOrEqualOperator;

      test('GreaterThanOrEqualOperator has correct symbol', () {
        expect(operator.symbol, '>=');
      });

      test('GreaterThanOrEqualOperator has correct precedence', () {
        expect(operator.precedence, 5);
      });

      test('GreaterThanOrEqualOperator has left associativity', () {
        expect(operator.associativity, Associativity.left);
      });

      test('GreaterThanOrEqualOperator is instance of RelationalOperator', () {
        expect(operator, isA<RelationalOperator>());
      });

      test('GreaterThanOrEqualOperator is instance of BinaryOperator', () {
        expect(operator, isA<BinaryOperator>());
      });

      test('GreaterThanOrEqualOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });
  });
}
