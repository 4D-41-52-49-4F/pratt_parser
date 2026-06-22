import 'package:pratt_parser/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:test/test.dart';

void main() {
  group('Arithmetic Operators Tests', () {
    group('ExponentOperator', () {
      final operator = SyntaxOperator.fromSymbol('^') as ExponentOperator;

      test('ExponentOperator has correct symbol', () {
        expect(operator.symbol, '^');
      });

      test('ExponentOperator has correct precedence', () {
        expect(operator.precedence, 8);
      });

      test('ExponentOperator has right associativity', () {
        expect(operator.associativity, Associativity.right);
      });

      test('ExponentOperator is instance of ArithmeticOperator', () {
        expect(operator, isA<ArithmeticOperator>());
      });

      test('ExponentOperator is instance of BinaryOperator', () {
        expect(operator, isA<BinaryOperator>());
      });

      test('ExponentOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('MultiplicationOperator', () {
      final operator = SyntaxOperator.fromSymbol('*') as MultiplicationOperator;

      test('MultiplicationOperator has correct symbol', () {
        expect(operator.symbol, '*');
      });

      test('MultiplicationOperator has correct precedence', () {
        expect(operator.precedence, 7);
      });

      test('MultiplicationOperator has left associativity', () {
        expect(operator.associativity, Associativity.left);
      });

      test('MultiplicationOperator is instance of ArithmeticOperator', () {
        expect(operator, isA<ArithmeticOperator>());
      });

      test('MultiplicationOperator is instance of BinaryOperator', () {
        expect(operator, isA<BinaryOperator>());
      });

      test('MultiplicationOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('DivisionOperator', () {
      final operator = SyntaxOperator.fromSymbol('/') as DivisionOperator;

      test('DivisionOperator has correct symbol', () {
        expect(operator.symbol, '/');
      });

      test('DivisionOperator has correct precedence', () {
        expect(operator.precedence, 7);
      });

      test('DivisionOperator has left associativity', () {
        expect(operator.associativity, Associativity.left);
      });

      test('DivisionOperator is instance of ArithmeticOperator', () {
        expect(operator, isA<ArithmeticOperator>());
      });

      test('DivisionOperator is instance of BinaryOperator', () {
        expect(operator, isA<BinaryOperator>());
      });

      test('DivisionOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('ModuloOperator', () {
      final operator = SyntaxOperator.fromSymbol('%') as ModuloOperator;

      test('ModuloOperator has correct symbol', () {
        expect(operator.symbol, '%');
      });

      test('ModuloOperator has correct precedence', () {
        expect(operator.precedence, 7);
      });

      test('ModuloOperator has left associativity', () {
        expect(operator.associativity, Associativity.left);
      });

      test('ModuloOperator is instance of ArithmeticOperator', () {
        expect(operator, isA<ArithmeticOperator>());
      });

      test('ModuloOperator is instance of BinaryOperator', () {
        expect(operator, isA<BinaryOperator>());
      });

      test('ModuloOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('AdditionOperator', () {
      final operator = SyntaxOperator.fromSymbol('+') as AdditionOperator;

      test('AdditionOperator has correct symbol', () {
        expect(operator.symbol, '+');
      });

      test('AdditionOperator has correct precedence', () {
        expect(operator.precedence, 6);
      });

      test('AdditionOperator has left associativity', () {
        expect(operator.associativity, Associativity.left);
      });

      test('AdditionOperator is instance of ArithmeticOperator', () {
        expect(operator, isA<ArithmeticOperator>());
      });

      test('AdditionOperator is instance of BinaryOperator', () {
        expect(operator, isA<BinaryOperator>());
      });

      test('AdditionOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('SubtractionOperator', () {
      final operator = SyntaxOperator.fromSymbol('-') as SubtractionOperator;

      test('SubtractionOperator has correct symbol', () {
        expect(operator.symbol, '-');
      });

      test('SubtractionOperator has correct precedence', () {
        expect(operator.precedence, 6);
      });

      test('SubtractionOperator has left associativity', () {
        expect(operator.associativity, Associativity.left);
      });

      test('SubtractionOperator is instance of ArithmeticOperator', () {
        expect(operator, isA<ArithmeticOperator>());
      });

      test('SubtractionOperator is instance of BinaryOperator', () {
        expect(operator, isA<BinaryOperator>());
      });

      test('SubtractionOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });
  });
}
