/// Manages the variable environment for the runtime.
///
/// This class provides functionality to store, retrieve, and manage variables
/// during program execution. It maintains a map of variable names to their
/// current values.
class VariableEnvironment {
  /// Internal map storing variable values by name.
  static final Map<String, dynamic> _variableValues = {};

  /// Gets the global state map containing all variables.
  ///
  /// Returns the map of all variable names to their current values.
  static Map<String, dynamic> get globalState => _variableValues;

  /// Adds a new variable or updates an existing variable with the given value.
  ///
  /// [name] The identifier of the variable.
  /// [value] The value to assign to the variable.
  static void addOrUpdateVariable(String name, dynamic value) {
    _variableValues[name] = value;
  }

  /// Gets the value of a variable by name.
  ///
  /// [name] The identifier of the variable to retrieve.
  ///
  /// Returns the current value of the variable, or null if the variable
  /// has not been initialized.
  static dynamic getValue(String name) => _variableValues[name];
}
