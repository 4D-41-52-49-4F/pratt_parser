import 'dart:math' as math;
import 'package:pratt_parser/src/models/global_environment/_function_registry/function_registry.dart';
import 'package:test/test.dart';

void main() {
  group('FunctionRegistry - Basic Registration and Resolution', () {
    setUp(FunctionRegistry.clear);

    test('Register a simple function', () {
      FunctionRegistry.register('add', (args) => (args[0] as num) + (args[1] as num));
      expect(FunctionRegistry.functions.containsKey('add'), true);
    });

    test('Resolve and execute a registered function', () {
      FunctionRegistry.register('add', (args) => (args[0] as num) + (args[1] as num));
      final result = FunctionRegistry.resolve('add', [5, 3]);
      expect(result, 8);
    });

    test('Resolve function with single argument', () {
      FunctionRegistry.register('double', (args) => (args[0] as num) * 2);
      final result = FunctionRegistry.resolve('double', [5]);
      expect(result, 10);
    });

    test('Resolve function with no arguments', () {
      FunctionRegistry.register('getPi', (args) => 3.14159);
      final result = FunctionRegistry.resolve('getPi', []);
      expect(result, 3.14159);
    });

    test('Resolve function with many arguments', () {
      FunctionRegistry.register('sum', (args) => args.reduce((a, b) => (a as num) + (b as num)));
      final result = FunctionRegistry.resolve('sum', [1, 2, 3, 4, 5]);
      expect(result, 15);
    });

    test('Override a registered function', () {
      FunctionRegistry.register('func', (args) => 'version1');
      expect(FunctionRegistry.resolve('func', []), 'version1');

      FunctionRegistry.register('func', (args) => 'version2');
      expect(FunctionRegistry.resolve('func', []), 'version2');
    });

    test('Register and resolve multiple different functions', () {
      FunctionRegistry.register('add', (args) => (args[0] as num) + (args[1] as num));
      FunctionRegistry.register('subtract', (args) => (args[0] as num) - (args[1] as num));
      FunctionRegistry.register('multiply', (args) => (args[0] as num) * (args[1] as num));

      expect(FunctionRegistry.resolve('add', [10, 5]), 15);
      expect(FunctionRegistry.resolve('subtract', [10, 5]), 5);
      expect(FunctionRegistry.resolve('multiply', [10, 5]), 50);
    });
  });

  group('FunctionRegistry - Function Aliases', () {
    setUp(FunctionRegistry.clear);

    test('Register aliases for a function', () {
      FunctionRegistry.registerAliases(['add', 'plus', 'sum'], (args) => (args[0] as num) + (args[1] as num));

      expect(FunctionRegistry.resolve('add', [5, 3]), 8);
      expect(FunctionRegistry.resolve('plus', [5, 3]), 8);
      expect(FunctionRegistry.resolve('sum', [5, 3]), 8);
    });

    test('All aliases resolve to same function', () {
      // ignore: prefer_function_declarations_over_variables
      final func = (args) => ((args as List)[0] as num) * args[1];
      FunctionRegistry.registerAliases(['multiply', 'mul', 'times', 'product'], func);

      expect(FunctionRegistry.resolve('multiply', [6, 7]), 42);
      expect(FunctionRegistry.resolve('mul', [6, 7]), 42);
      expect(FunctionRegistry.resolve('times', [6, 7]), 42);
      expect(FunctionRegistry.resolve('product', [6, 7]), 42);
    });

    test('Register multiple alias groups', () {
      FunctionRegistry.registerAliases(['add', 'plus'], (args) => (args[0] as num) + (args[1] as num));
      FunctionRegistry.registerAliases(['subtract', 'minus'], (args) => (args[0] as num) - (args[1] as num));

      expect(FunctionRegistry.resolve('add', [10, 3]), 13);
      expect(FunctionRegistry.resolve('plus', [10, 3]), 13);
      expect(FunctionRegistry.resolve('subtract', [10, 3]), 7);
      expect(FunctionRegistry.resolve('minus', [10, 3]), 7);
    });

    test('Single name in registerAliases', () {
      FunctionRegistry.registerAliases(['onlyOne'], (args) => 42);
      expect(FunctionRegistry.resolve('onlyOne', []), 42);
    });

    test('Empty alias list does nothing', () {
      FunctionRegistry.registerAliases([], (args) => 42);
      expect(FunctionRegistry.functions.length, 0);
    });
  });

  group('FunctionRegistry - Error Handling', () {
    setUp(FunctionRegistry.clear);

    test('Throw exception for unregistered function', () {
      expect(() => FunctionRegistry.resolve('nonexistent', []), throwsException);
    });

    test('Exception message contains function name', () {
      expect(
        () => FunctionRegistry.resolve('unknownFunc', []),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('unknownFunc'))),
      );
    });

    test('Exception message mentions registering', () {
      expect(
        () => FunctionRegistry.resolve('test', []),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('register'))),
      );
    });

    test('Resolve works after registering previously unregistered function', () {
      expect(() => FunctionRegistry.resolve('delayed', []), throwsException);

      FunctionRegistry.register('delayed', (args) => 'now registered');
      expect(FunctionRegistry.resolve('delayed', []), 'now registered');
    });
  });

  group('FunctionRegistry - Return Types', () {
    setUp(FunctionRegistry.clear);

    test('Function returning string', () {
      FunctionRegistry.register('greet', (args) => 'Hello, ${args[0]}!');
      expect(FunctionRegistry.resolve('greet', ['World']), 'Hello, World!');
    });

    test('Function returning integer', () {
      FunctionRegistry.register('parseInt', (args) => int.parse(args[0]));
      expect(FunctionRegistry.resolve('parseInt', ['42']), 42);
    });

    test('Function returning double', () {
      FunctionRegistry.register('sqrt', (args) => math.sqrt(args[0]));
      final result = FunctionRegistry.resolve('sqrt', [16]);
      expect(result, 4.0);
    });

    test('Function returning boolean', () {
      FunctionRegistry.register('isPositive', (args) => (args[0] as num) > 0);
      expect(FunctionRegistry.resolve('isPositive', [5]), true);
      expect(FunctionRegistry.resolve('isPositive', [-5]), false);
    });

    test('Function returning list', () {
      FunctionRegistry.register('range', (args) => List.generate(args[0], (i) => i + 1));
      final result = FunctionRegistry.resolve('range', [5]) as List;
      expect(result, [1, 2, 3, 4, 5]);
    });

    test('Function returning map', () {
      FunctionRegistry.register('createUser', (args) => {'name': args[0], 'age': args[1]});
      final result = FunctionRegistry.resolve('createUser', ['Alice', 30]) as Map;
      expect(result['name'], 'Alice');
      expect(result['age'], 30);
    });

    test('Function returning null', () {
      FunctionRegistry.register('returns_null', (args) => null);
      expect(FunctionRegistry.resolve('returns_null', []), null);
    });

    test('Function returning complex nested structure', () {
      FunctionRegistry.register(
        'complex',
        (args) => {
          'data': [1, 2, 3],
          'nested': {
            'key': 'value',
            'items': ['a', 'b', 'c'],
          },
        },
      );
      final result = FunctionRegistry.resolve('complex', []) as Map;
      expect(result['data'], [1, 2, 3]);
      expect((result['nested'] as Map)['key'], 'value');
    });
  });

  group('FunctionRegistry - Argument Handling', () {
    setUp(FunctionRegistry.clear);

    test('Function with string arguments', () {
      FunctionRegistry.register('concat', (args) => (args[0] as String) + (args[1] as String));
      expect(FunctionRegistry.resolve('concat', ['Hello', ' World']), 'Hello World');
    });

    test('Function with numeric arguments', () {
      FunctionRegistry.register(
        'max',
        (args) => (args[0] as num) > (args[1] as num) ? (args[0] as num) : (args[1] as num),
      );
      expect(FunctionRegistry.resolve('max', [10, 20]), 20);
    });

    test('Function with mixed type arguments', () {
      FunctionRegistry.register('convert', (args) => '${args[0]} - ${args[1]} - ${args[2]}');
      expect(FunctionRegistry.resolve('convert', ['text', 42, true]), 'text - 42 - true');
    });

    test('Function with list argument', () {
      FunctionRegistry.register('first', (args) => (args[0] as List).first);
      expect(
        FunctionRegistry.resolve('first', [
          [1, 2, 3],
        ]),
        1,
      );
    });

    test('Function with map argument', () {
      FunctionRegistry.register('getValue', (args) => (args[0] as Map)[args[1]]);
      expect(
        FunctionRegistry.resolve('getValue', [
          {'key': 'value'},
          'key',
        ]),
        'value',
      );
    });

    test('Function with null argument', () {
      FunctionRegistry.register('handleNull', (args) => args[0] ?? 'was null');
      expect(FunctionRegistry.resolve('handleNull', [null]), 'was null');
      expect(FunctionRegistry.resolve('handleNull', ['value']), 'value');
    });

    test('Function with empty argument list', () {
      FunctionRegistry.register('constant', (args) => 42);
      expect(FunctionRegistry.resolve('constant', []), 42);
    });
  });

  group('FunctionRegistry - String Operations', () {
    setUp(FunctionRegistry.clear);

    test('Length function', () {
      FunctionRegistry.register('length', (args) => (args[0] as String).length);
      expect(FunctionRegistry.resolve('length', ['hello']), 5);
    });

    test('Contains function', () {
      FunctionRegistry.register('contains', (args) => (args[0] as String).contains(args[1]));
      expect(FunctionRegistry.resolve('contains', ['hello@example.com', '@']), true);
      expect(FunctionRegistry.resolve('contains', ['hello', 'x']), false);
    });

    test('ToUpperCase function', () {
      FunctionRegistry.register('toUpper', (args) => (args[0] as String).toUpperCase());
      expect(FunctionRegistry.resolve('toUpper', ['hello']), 'HELLO');
    });

    test('ToLowerCase function', () {
      FunctionRegistry.register('toLower', (args) => (args[0] as String).toLowerCase());
      expect(FunctionRegistry.resolve('toLower', ['HELLO']), 'hello');
    });

    test('StartsWith function', () {
      FunctionRegistry.register('startsWith', (args) => (args[0] as String).startsWith(args[1] as String));
      expect(FunctionRegistry.resolve('startsWith', ['hello world', 'hello']), true);
      expect(FunctionRegistry.resolve('startsWith', ['hello world', 'world']), false);
    });

    test('EndsWith function', () {
      FunctionRegistry.register('endsWith', (args) => (args[0] as String).endsWith(args[1] as String));
      expect(FunctionRegistry.resolve('endsWith', ['hello world', 'world']), true);
      expect(FunctionRegistry.resolve('endsWith', ['hello world', 'hello']), false);
    });

    test('Trim function', () {
      FunctionRegistry.register('trim', (args) => (args[0] as String).trim());
      expect(FunctionRegistry.resolve('trim', ['  hello world  ']), 'hello world');
    });
  });

  group('FunctionRegistry - Math Operations', () {
    setUp(FunctionRegistry.clear);

    test('Addition function', () {
      FunctionRegistry.register('add', (args) => (args[0] as num) + (args[1] as num));
      expect(FunctionRegistry.resolve('add', [5, 3]), 8);
    });

    test('Subtraction function', () {
      FunctionRegistry.register('subtract', (args) => (args[0] as num) - (args[1] as num));
      expect(FunctionRegistry.resolve('subtract', [10, 3]), 7);
    });

    test('Multiplication function', () {
      FunctionRegistry.register('multiply', (args) => (args[0] as num) * (args[1] as num));
      expect(FunctionRegistry.resolve('multiply', [6, 7]), 42);
    });

    test('Division function', () {
      FunctionRegistry.register('divide', (args) => (args[0] as num) / (args[1] as num));
      expect(FunctionRegistry.resolve('divide', [20, 4]), 5);
    });

    test('Modulo function', () {
      FunctionRegistry.register('mod', (args) => (args[0] as num) % (args[1] as num));
      expect(FunctionRegistry.resolve('mod', [17, 5]), 2);
    });

    test('Power function', () {
      FunctionRegistry.register('pow', (args) => math.pow(args[0], args[1]));
      expect(FunctionRegistry.resolve('pow', [2, 8]), 256);
    });

    test('Absolute value function', () {
      FunctionRegistry.register('abs', (args) => (args[0] as num).abs());
      expect(FunctionRegistry.resolve('abs', [-42]), 42);
    });

    test('Min function', () {
      FunctionRegistry.register('min', (args) {
        final list = args[0] as List<num>;
        var minVal = list[0];
        for (final item in list) {
          if (item < minVal) minVal = item;
        }
        return minVal;
      });
      expect(
        FunctionRegistry.resolve('min', [
          [5, 2, 8, 1, 9],
        ]),
        1,
      );
    });

    test('Max function', () {
      FunctionRegistry.register('max', (args) {
        final list = args[0] as List<num>;
        var maxVal = list[0];
        for (final item in list) {
          if (item > maxVal) maxVal = item;
        }
        return maxVal;
      });
      expect(
        FunctionRegistry.resolve('max', [
          [5, 2, 8, 1, 9],
        ]),
        9,
      );
    });
  });

  group('FunctionRegistry - List Operations', () {
    setUp(FunctionRegistry.clear);

    test('Length of list', () {
      FunctionRegistry.register('listLength', (args) => (args[0] as List).length);
      expect(
        FunctionRegistry.resolve('listLength', [
          [1, 2, 3, 4, 5],
        ]),
        5,
      );
    });

    test('First element', () {
      FunctionRegistry.register('first', (args) => (args[0] as List).first);
      expect(
        FunctionRegistry.resolve('first', [
          [10, 20, 30],
        ]),
        10,
      );
    });

    test('Last element', () {
      FunctionRegistry.register('last', (args) => (args[0] as List).last);
      expect(
        FunctionRegistry.resolve('last', [
          [10, 20, 30],
        ]),
        30,
      );
    });

    test('Contains element', () {
      FunctionRegistry.register('listContains', (args) => (args[0] as List).contains(args[1]));
      expect(
        FunctionRegistry.resolve('listContains', [
          [1, 2, 3],
          2,
        ]),
        true,
      );
      expect(
        FunctionRegistry.resolve('listContains', [
          [1, 2, 3],
          5,
        ]),
        false,
      );
    });

    test('Reverse list', () {
      FunctionRegistry.register('reverse', (args) => (args[0] as List).toList().reversed.toList());
      final result =
          FunctionRegistry.resolve('reverse', [
                [1, 2, 3, 4],
              ])
              as List;
      expect(result, [4, 3, 2, 1]);
    });

    test('Join list to string', () {
      FunctionRegistry.register('join', (args) => (args[0] as List).join(args[1]));
      expect(
        FunctionRegistry.resolve('join', [
          ['a', 'b', 'c'],
          '-',
        ]),
        'a-b-c',
      );
    });
  });

  group('FunctionRegistry - Type Checking and Conversion', () {
    setUp(FunctionRegistry.clear);

    test('Type check - is integer', () {
      FunctionRegistry.register('isInt', (args) => args[0] is int);
      expect(FunctionRegistry.resolve('isInt', [42]), true);
      expect(FunctionRegistry.resolve('isInt', ['42']), false);
    });

    test('Type check - is string', () {
      FunctionRegistry.register('isString', (args) => args[0] is String);
      expect(FunctionRegistry.resolve('isString', ['hello']), true);
      expect(FunctionRegistry.resolve('isString', [42]), false);
    });

    test('Type check - is list', () {
      FunctionRegistry.register('isList', (args) => args[0] is List);
      expect(
        FunctionRegistry.resolve('isList', [
          [1, 2, 3],
        ]),
        true,
      );
      expect(FunctionRegistry.resolve('isList', ['list']), false);
    });

    test('Type check - is map', () {
      FunctionRegistry.register('isMap', (args) => args[0] is Map);
      expect(
        FunctionRegistry.resolve('isMap', [
          {'key': 'value'},
        ]),
        true,
      );
      expect(
        FunctionRegistry.resolve('isMap', [
          [1, 2, 3],
        ]),
        false,
      );
    });

    test('Convert to string', () {
      FunctionRegistry.register('toString', (args) => args[0].toString());
      expect(FunctionRegistry.resolve('toString', [42]), '42');
      expect(FunctionRegistry.resolve('toString', [3.14]), '3.14');
    });

    test('Convert string to int', () {
      FunctionRegistry.register('toInt', (args) => int.parse(args[0]));
      expect(FunctionRegistry.resolve('toInt', ['123']), 123);
    });
  });

  group('FunctionRegistry - Stateful Functions', () {
    setUp(FunctionRegistry.clear);

    test('Function with closure capturing external state', () {
      var callCount = 0;
      FunctionRegistry.register('counter', (args) => ++callCount);

      expect(FunctionRegistry.resolve('counter', []), 1);
      expect(FunctionRegistry.resolve('counter', []), 2);
      expect(FunctionRegistry.resolve('counter', []), 3);
    });

    test('Function accessing shared mutable state', () {
      final accumulator = <int>[];
      FunctionRegistry.register('collect', (args) {
        accumulator.add(args[0]);
        return accumulator.length;
      });

      expect(FunctionRegistry.resolve('collect', [1]), 1);
      expect(FunctionRegistry.resolve('collect', [2]), 2);
      expect(FunctionRegistry.resolve('collect', [3]), 3);
    });
  });

  group('FunctionRegistry - Real World Scenarios', () {
    setUp(FunctionRegistry.clear);

    test('User validation functions', () {
      FunctionRegistry.register('isValidEmail', (args) => (args[0] as String).contains('@'));
      FunctionRegistry.register('isValidAge', (args) => (args[0] as num) >= 18 && (args[0] as num) <= 120);

      expect(FunctionRegistry.resolve('isValidEmail', ['john@example.com']), true);
      expect(FunctionRegistry.resolve('isValidEmail', ['invalid']), false);
      expect(FunctionRegistry.resolve('isValidAge', [25]), true);
      expect(FunctionRegistry.resolve('isValidAge', [150]), false);
    });

    test('E-commerce discount calculation', () {
      FunctionRegistry.register('applyDiscount', (args) {
        final price = args[0] as num;
        final discountPercent = args[1] as num;
        return price * (1 - discountPercent / 100);
      });

      expect(FunctionRegistry.resolve('applyDiscount', [100, 20]), 80);
      expect(FunctionRegistry.resolve('applyDiscount', [50, 10]), 45);
    });

    test('Grade calculation', () {
      FunctionRegistry.register('calculateGrade', (args) {
        final score = args[0] as num;
        if (score >= 90) return 'A';
        if (score >= 80) return 'B';
        if (score >= 70) return 'C';
        if (score >= 60) return 'D';
        return 'F';
      });

      expect(FunctionRegistry.resolve('calculateGrade', [95]), 'A');
      expect(FunctionRegistry.resolve('calculateGrade', [85]), 'B');
      expect(FunctionRegistry.resolve('calculateGrade', [55]), 'F');
    });

    test('User profile builder', () {
      FunctionRegistry.register(
        'createProfile',
        (args) => {'id': args[0], 'name': args[1], 'email': args[2], 'createdAt': DateTime.now().toString()},
      );

      final profile = FunctionRegistry.resolve('createProfile', [1, 'Alice', 'alice@example.com']) as Map;
      expect(profile['id'], 1);
      expect(profile['name'], 'Alice');
      expect(profile['email'], 'alice@example.com');
    });

    test('Order processing functions', () {
      FunctionRegistry.register('calculateTax', (args) => (args[0] as num) * 0.19);
      FunctionRegistry.register('calculateTotal', (args) => (args[0] as num) + (args[1] as num));
      FunctionRegistry.register('formatPrice', (args) => '\$${(args[0] as num).toStringAsFixed(2)}');

      const subtotal = 100;
      final tax = FunctionRegistry.resolve('calculateTax', [subtotal]) as num;
      final total = FunctionRegistry.resolve('calculateTotal', [subtotal, tax]) as num;
      final formatted = FunctionRegistry.resolve('formatPrice', [total]);

      expect(tax, 19);
      expect(total, 119);
      expect(formatted, r'$119.00');
    });
  });

  group('FunctionRegistry - Stress and Performance', () {
    setUp(FunctionRegistry.clear);

    test('Register many functions', () {
      for (var i = 0; i < 1000; i++) {
        FunctionRegistry.register('func_$i', (args) => i);
      }

      expect(FunctionRegistry.functions.length, 1000);
      expect(FunctionRegistry.resolve('func_500', []), 500);
    });

    test('Resolve functions repeatedly', () {
      FunctionRegistry.register('identity', (args) => args[0]);

      var result = 0;
      for (var i = 0; i < 10000; i++) {
        result = FunctionRegistry.resolve('identity', [i]) as int;
      }

      expect(result, 9999);
    });

    test('Complex nested function calls', () {
      FunctionRegistry.register('add', (args) => (args[0] as num) + (args[1] as num));
      FunctionRegistry.register('multiply', (args) => (args[0] as num) * (args[1] as num));

      // Manually simulate: ((5 + 3) * (10 + 2))
      final sum1 = FunctionRegistry.resolve('add', [5, 3]) as int;
      final sum2 = FunctionRegistry.resolve('add', [10, 2]) as int;
      final result = FunctionRegistry.resolve('multiply', [sum1, sum2]) as int;

      expect(result, 8 * 12);
    });
  });

  group('FunctionRegistry - Edge Cases', () {
    setUp(FunctionRegistry.clear);

    test('Function name with special characters', () {
      FunctionRegistry.register('func_with_underscore', (args) => 'underscore');
      FunctionRegistry.register('func123', (args) => 'number');

      expect(FunctionRegistry.resolve('func_with_underscore', []), 'underscore');
      expect(FunctionRegistry.resolve('func123', []), 'number');
    });

    test('Empty string function name', () {
      FunctionRegistry.register('', (args) => 'empty name');
      expect(FunctionRegistry.resolve('', []), 'empty name');
    });

    test('Very long function name', () {
      final longName = 'f' * 1000;
      FunctionRegistry.register(longName, (args) => 'long name');
      expect(FunctionRegistry.resolve(longName, []), 'long name');
    });

    test('Function returning from deeply nested args', () {
      FunctionRegistry.register('deepAccess', (args) {
        final data = args[0] as Map;
        return (((data['a'] as Map)['b'] as Map)['c'] as Map)['d'];
      });

      final result = FunctionRegistry.resolve('deepAccess', [
        {
          'a': {
            'b': {
              'c': {'d': 'found it!'},
            },
          },
        },
      ]);

      expect(result, 'found it!');
    });

    test('Function with very large argument list', () {
      FunctionRegistry.register('processMany', (args) => args.length);

      final largeList = List.generate(1000, (i) => i);
      expect(FunctionRegistry.resolve('processMany', largeList), 1000);
    });
  });
}
