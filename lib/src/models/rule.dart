import 'package:abschlussprojekt/src/models/condition.dart';

class Rule {
  final int id;
  final String tableName;
  final RuleStatus status;
  final List<Condition> conditions;

  const Rule(this.id, this.tableName, this.conditions, {this.status = RuleStatus.failed});
}

enum RuleStatus { failed, succeeded }
