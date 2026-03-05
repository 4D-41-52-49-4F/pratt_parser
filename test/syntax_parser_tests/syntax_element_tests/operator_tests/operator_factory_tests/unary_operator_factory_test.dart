import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:test/test.dart';

void main() {
  group('UnaryOperator.fromSymbol', () {
    test('returns correct unary operator for ! and -', () {
      expect(UnaryOperator.fromSymbol('!') is NotOperator, true);
      expect(UnaryOperator.fromSymbol('-') is UnaryMinusOperator, true);
    });

    test('throws when given a non-unary symbol', () {
      expect(() => UnaryOperator.fromSymbol('+'), throwsException);
      expect(() => UnaryOperator.fromSymbol('&&'), throwsException);
    });
  });
}
