typedef RuntimeFunction = dynamic Function(List<dynamic> args);

class FunctionRegistry {
  static final Map<String, RuntimeFunction> _functions = {};

  static void register(String name, RuntimeFunction func) {
    _functions[name] = func;
  }

  static void registerAliases(List<String> names, RuntimeFunction func) {
    for (var name in names) {
      _functions[name] = func;
    }
  }

  static dynamic resolve(String name, List<dynamic> args) {
    if (_functions[name] == null) return null;
    return _functions[name]!(args);
  }
}
