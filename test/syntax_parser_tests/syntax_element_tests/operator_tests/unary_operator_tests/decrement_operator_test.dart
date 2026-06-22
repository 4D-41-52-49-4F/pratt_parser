import 'package:pratt_parser/src/models/syntax_parser/_syntax_elements/expressions/syntax_expression.dart';
import 'package:pratt_parser/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:pratt_parser/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('DecrementOperator Tests', () {
    final operator = UnaryOperator.fromSymbol('--') as DecrementOperator;

    group('Operator Properties', () {
      test('DecrementOperator has correct symbol', () {
        expect(operator.symbol, '--');
      });

      test('DecrementOperator has correct precedence', () {
        expect(operator.precedence, 9);
      });

      test('DecrementOperator has right associativity', () {
        expect(operator.associativity, Associativity.right);
      });

      test('DecrementOperator toString contains correct information', () {
        final str = operator.toString();
        expect(str.contains('--'), true);
        expect(str.contains('9'), true);
        expect(str.contains('right'), true);
      });
    });

    group('Type Checking', () {
      test('DecrementOperator is instance of UnaryOperator', () {
        expect(operator, isA<UnaryOperator>());
      });

      test('DecrementOperator is instance of SyntaxOperator', () {
        expect(operator, isA<SyntaxOperator>());
      });
    });

    group('Equality Tests', () {
      test('Two DecrementOperator instances with same symbol are equal', () {
        final op1 = UnaryOperator.fromSymbol('--') as DecrementOperator;
        final op2 = UnaryOperator.fromSymbol('--') as DecrementOperator;
        expect(op1, equals(op2));
      });

      test('DecrementOperator is not equal to IncrementOperator', () {
        final dec = UnaryOperator.fromSymbol('--') as DecrementOperator;
        final inc = UnaryOperator.fromSymbol('++') as IncrementOperator;
        expect(dec, isNot(equals(inc)));
      });
    });

    group('Hash Code Tests', () {
      test('Two DecrementOperator instances have same hash code', () {
        final op1 = UnaryOperator.fromSymbol('--') as DecrementOperator;
        final op2 = UnaryOperator.fromSymbol('--') as DecrementOperator;
        expect(op1.hashCode, equals(op2.hashCode));
      });
    });

    group('Edge Cases', () {
      test('DecrementOperator symbol is exactly "--"', () {
        expect(operator.symbol, equals('--'));
        expect(operator.symbol.length, 2);
      });

      test('DecrementOperator precedence is positive', () {
        expect(operator.precedence, greaterThan(0));
      });
    });

    group('Evaluation', () {
      test('DecrementOperator applied to positive integer', () {
        final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '5'));
        final expr = UnaryExpression(operator: operator, operand: literal);
        expect(expr.evaluate(), 4);
      });

      test('DecrementOperator applied to zero', () {
        final literal = SyntaxLiteral.literalFromToken(const Token(TokenType.numeralLiteral, '0'));
        final expr = UnaryExpression(operator: operator, operand: literal);
        expect(expr.evaluate(), -1);
      });
    });
  });
}
