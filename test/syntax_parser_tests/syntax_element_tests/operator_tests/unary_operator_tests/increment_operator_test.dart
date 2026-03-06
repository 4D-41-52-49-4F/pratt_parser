import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('IncrementOperator Tests', () {
    final operator = UnaryOperator.fromSymbol('++') as IncrementOperator;

    group('Operator Properties', () {
      test('IncrementOperator has correct symbol', () {
        expect(operator.symbol, '++');
      });

      test('IncrementOperator has correct precedence', () {
        expect(operator.precedence, 9);
      });

      test('IncrementOperator has right associativity', () {
        expect(operator.associativity, Associativity.right);
      });

      test('IncrementOperator toString contains correct information', () {
        final str = operator.toString();
        expect(str.contains('++'), true);
        expect(str.contains('9'), true);
        expect(str.contains('right'), true);
      });
    });

    group('Type Checking', () {
      test('IncrementOperator is instance of UnaryOperator', () {
        expect(operator, isA<UnaryOperator>());
      });

      test('IncrementOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('Equality Tests', () {
      test('Two IncrementOperator instances with same symbol are equal', () {
        final op1 = UnaryOperator.fromSymbol('++') as IncrementOperator;
        final op2 = UnaryOperator.fromSymbol('++') as IncrementOperator;
        expect(op1, equals(op2));
      });

      test('IncrementOperator is not equal to DecrementOperator', () {
        final inc = UnaryOperator.fromSymbol('++') as IncrementOperator;
        final dec = UnaryOperator.fromSymbol('--') as DecrementOperator;
        expect(inc, isNot(equals(dec)));
      });
    });

    group('Hash Code Tests', () {
      test('Two IncrementOperator instances have same hash code', () {
        final op1 = UnaryOperator.fromSymbol('++') as IncrementOperator;
        final op2 = UnaryOperator.fromSymbol('++') as IncrementOperator;
        expect(op1.hashCode, equals(op2.hashCode));
      });
    });

    group('Edge Cases', () {
      test('IncrementOperator symbol is exactly "++"', () {
        expect(operator.symbol, equals('++'));
        expect(operator.symbol.length, 2);
      });

      test('IncrementOperator precedence is positive', () {
        expect(operator.precedence, greaterThan(0));
      });
    });

    group('Evaluation', () {
      test('IncrementOperator applied to positive integer', () {
        final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
        final expr = UnaryExpression(operator: operator, operand: literal);
        expect(expr.evaluate(), 6);
      });

      test('IncrementOperator applied to negative integer', () {
        final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '-1'));
        final expr = UnaryExpression(operator: operator, operand: literal);
        expect(expr.evaluate(), 0);
      });
    });
  });
}
