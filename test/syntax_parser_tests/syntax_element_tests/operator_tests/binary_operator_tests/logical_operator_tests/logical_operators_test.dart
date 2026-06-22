import 'package:pratt_parser/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:test/test.dart';

void main() {
  group('Logical Operators Tests', () {
    group('AndOperator', () {
      final operator = SyntaxOperator.fromSymbol('&&') as AndOperator;

      test('AndOperator has correct symbol', () {
        expect(operator.symbol, '&&');
      });

      test('AndOperator has correct precedence', () {
        expect(operator.precedence, 3);
      });

      test('AndOperator has left associativity', () {
        expect(operator.associativity, Associativity.left);
      });

      test('AndOperator is instance of LogicalOperator', () {
        expect(operator, isA<LogicalOperator>());
      });

      test('AndOperator is instance of BinaryOperator', () {
        expect(operator, isA<BinaryOperator>());
      });

      test('AndOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('OrOperator', () {
      final operator = SyntaxOperator.fromSymbol('||') as OrOperator;

      test('OrOperator has correct symbol', () {
        expect(operator.symbol, '||');
      });

      test('OrOperator has correct precedence', () {
        expect(operator.precedence, 2);
      });

      test('OrOperator has left associativity', () {
        expect(operator.associativity, Associativity.left);
      });

      test('OrOperator is instance of LogicalOperator', () {
        expect(operator, isA<LogicalOperator>());
      });

      test('OrOperator is instance of BinaryOperator', () {
        expect(operator, isA<BinaryOperator>());
      });

      test('OrOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });
  });
}
