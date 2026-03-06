import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:test/test.dart';

void main() {
  group('Ternary Operators Tests', () {
    group('ConditionOperator', () {
      final operator = SyntaxOperator.fromSymbol('?') as ConditionOperator;

      test('ConditionOperator has correct symbol', () {
        expect(operator.symbol, '?');
      });

      test('ConditionOperator has correct precedence', () {
        expect(operator.precedence, 1);
      });

      test('ConditionOperator has right associativity', () {
        expect(operator.associativity, Associativity.right);
      });

      test('ConditionOperator is instance of TernaryOperator', () {
        expect(operator, isA<TernaryOperator>());
      });

      test('ConditionOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('ElseOperator', () {
      final operator = SyntaxOperator.fromSymbol(':') as ElseOperator;

      test('ElseOperator has correct symbol', () {
        expect(operator.symbol, ':');
      });

      test('ElseOperator has correct precedence', () {
        expect(operator.precedence, 1);
      });

      test('ElseOperator has right associativity', () {
        expect(operator.associativity, Associativity.right);
      });

      test('ElseOperator is instance of TernaryOperator', () {
        expect(operator, isA<TernaryOperator>());
      });

      test('ElseOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });
  });
}
