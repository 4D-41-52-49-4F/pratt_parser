/// A type alias for runtime functions used in the function registry.
///
/// Represents a function that takes a list of dynamic arguments and returns
/// a dynamic result.
typedef RuntimeFunction = dynamic Function(List<dynamic> args);

/// Registry for managing and resolving runtime functions.
///
/// This class provides functionality to register functions by name and resolve
/// them during execution. It maintains a map of function names to their
/// corresponding implementations.
class FunctionRegistry {
  /// Internal map storing registered functions by name.
  static final Map<String, RuntimeFunction> _functions = {};

  /// Registers a function with the given name.
  ///
  /// [name] The identifier used to look up the function.
  /// [func] The function implementation to register.
  static void register(String name, RuntimeFunction func) {
    _functions[name] = func;
  }

  /// Registers a function with multiple names (aliases).
  ///
  /// [names] The list of identifiers that will all resolve to the same function.
  /// [func] The function implementation to register under all names.
  static void registerAliases(List<String> names, RuntimeFunction func) {
    for (final name in names) {
      _functions[name] = func;
    }
  }

  /// Resolves a function by name and executes it with the given arguments.
  ///
  /// [name] The identifier of the function to resolve.
  /// [args] The list of arguments to pass to the function.
  ///
  /// Returns the result of the function execution.
  ///
  /// Throws an [Exception] if the function is not registered.
  static dynamic resolve(String name, List<dynamic> args) {
    if (_functions[name] == null) {
      throw Exception('Tried to call unregisteres function. Please register the function first. $name');
    }
    return _functions[name]!(args);
  }
}
