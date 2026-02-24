import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/syntax_expression.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/_syntax_elements/syntax_operator.dart';

class Condition {
  final SyntaxOperator operator;
  final SyntaxExpression expression1;
  final SyntaxExpression expression2;

  const Condition({required this.operator, required this.expression1, required this.expression2});
}
