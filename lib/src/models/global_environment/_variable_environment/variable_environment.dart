class VariableEnvironment {
  static final Map<String, dynamic> _variableValues = {};

  static Map<String, dynamic> get globalState => _variableValues;

  static void addOrUpdateVariable(String name, dynamic value) {
    _variableValues[name] = value;
  }

  static dynamic getValue(String name) => _variableValues[name];
}
