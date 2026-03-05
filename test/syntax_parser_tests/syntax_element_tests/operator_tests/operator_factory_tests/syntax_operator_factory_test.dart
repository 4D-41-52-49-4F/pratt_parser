import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/operator/syntax_operator.dart';
import 'package:test/test.dart';

void main() {
  group('SyntaxOperator.fromSymbol', () {
    test('returns correct concrete operator for each supported symbol', () {
      final mapping = <String, Type>{
        '.': DotOperator,
        '^': ExponentOperator,
        '*': MultiplicationOperator,
        '/': DivisionOperator,
        '%': ModuloOperator,
        '+': AdditionOperator,
        '-': SubtractionOperator,
        '<': LessThanOperator,
        '<=': LessThanOrEqualOperator,
        '>': GreaterThanOperator,
        '>=': GreaterThanOrEqualOperator,
        '==': EqualOperator,
        '!=': NotEqualOperator,
        '&&': AndOperator,
        '||': OrOperator,
        '?': ConditionOperator,
        ':': ElseOperator,
        '=': AssignmentOperator,
      };

      for (final entry in mapping.entries) {
        final op = SyntaxOperator.fromSymbol(entry.key);
        expect(op.runtimeType, entry.value, reason: 'Symbol "${entry.key}" produced ${op.runtimeType}');
      }
    });

    test('throws when given an unknown symbol', () {
      expect(() => SyntaxOperator.fromSymbol('@@'), throwsException);
    });
  });

}
