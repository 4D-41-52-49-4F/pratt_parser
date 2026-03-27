import 'package:abschlussprojekt/src/models/global_environment/_variable_environment/variable_environment.dart';
import 'package:test/test.dart';

void main() {
  group('VariableEnvironment - Basic Operations', () {
    setUp(() {
      VariableEnvironment.globalState.clear();
    });

    test('Add a new variable', () {
      VariableEnvironment.addOrUpdateVariable('name', 'John');
      expect(VariableEnvironment.getValue('name'), 'John');
    });

    test('Update an existing variable', () {
      VariableEnvironment.addOrUpdateVariable('age', 30);
      expect(VariableEnvironment.getValue('age'), 30);

      VariableEnvironment.addOrUpdateVariable('age', 31);
      expect(VariableEnvironment.getValue('age'), 31);
    });

    test('Get value of non-existent variable returns null', () {
      expect(VariableEnvironment.getValue('nonexistent'), null);
    });

    test('Add multiple different variables', () {
      VariableEnvironment.addOrUpdateVariable('var1', 'value1');
      VariableEnvironment.addOrUpdateVariable('var2', 'value2');
      VariableEnvironment.addOrUpdateVariable('var3', 'value3');

      expect(VariableEnvironment.getValue('var1'), 'value1');
      expect(VariableEnvironment.getValue('var2'), 'value2');
      expect(VariableEnvironment.getValue('var3'), 'value3');
    });

    test('Access all variables via globalState', () {
      VariableEnvironment.addOrUpdateVariable('x', 10);
      VariableEnvironment.addOrUpdateVariable('y', 20);

      expect(VariableEnvironment.globalState['x'], 10);
      expect(VariableEnvironment.globalState['y'], 20);
      expect(VariableEnvironment.globalState.length, 2);
    });
  });

  group('VariableEnvironment - Data Types', () {
    setUp(() {
      VariableEnvironment.globalState.clear();
    });

    test('Store and retrieve string values', () {
      VariableEnvironment.addOrUpdateVariable('message', 'Hello, World!');
      expect(VariableEnvironment.getValue('message'), 'Hello, World!');
    });

    test('Store and retrieve numeric values', () {
      VariableEnvironment.addOrUpdateVariable('intValue', 42);
      VariableEnvironment.addOrUpdateVariable('doubleValue', 3.14);

      expect(VariableEnvironment.getValue('intValue'), 42);
      expect(VariableEnvironment.getValue('doubleValue'), 3.14);
    });

    test('Store and retrieve boolean values', () {
      VariableEnvironment.addOrUpdateVariable('isActive', true);
      VariableEnvironment.addOrUpdateVariable('isDeleted', false);

      expect(VariableEnvironment.getValue('isActive'), true);
      expect(VariableEnvironment.getValue('isDeleted'), false);
    });

    test('Store and retrieve list values', () {
      final list = [1, 2, 3, 4, 5];
      VariableEnvironment.addOrUpdateVariable('numbers', list);

      expect(VariableEnvironment.getValue('numbers'), list);
      expect((VariableEnvironment.getValue('numbers') as List).length, 5);
    });

    test('Store and retrieve map values', () {
      final map = {'key1': 'value1', 'key2': 'value2'};
      VariableEnvironment.addOrUpdateVariable('data', map);

      expect(VariableEnvironment.getValue('data'), map);
      expect((VariableEnvironment.getValue('data') as Map)['key1'], 'value1');
    });

    test('Store and retrieve null values', () {
      VariableEnvironment.addOrUpdateVariable('nullVar', null);
      expect(VariableEnvironment.getValue('nullVar'), null);
    });

    test('Store and retrieve complex nested structures', () {
      final complex = {
        'user': {
          'name': 'Alice',
          'age': 25,
          'hobbies': ['reading', 'gaming', 'coding'],
        },
        'active': true,
        'score': 95.5,
      };
      VariableEnvironment.addOrUpdateVariable('complex', complex);

      final retrieved = VariableEnvironment.getValue('complex') as Map;
      expect((retrieved['user'] as Map)['name'], 'Alice');
      expect(((retrieved['user'] as Map)['hobbies'] as List).length, 3);
      expect(retrieved['active'], true);
    });
  });

  group('VariableEnvironment - State Management', () {
    setUp(() {
      VariableEnvironment.globalState.clear();
    });

    test('Clear all variables', () {
      VariableEnvironment.addOrUpdateVariable('var1', 'value1');
      VariableEnvironment.addOrUpdateVariable('var2', 'value2');

      expect(VariableEnvironment.globalState.length, 2);

      VariableEnvironment.globalState.clear();
      expect(VariableEnvironment.globalState.length, 0);
    });

    test('Direct modification via globalState', () {
      VariableEnvironment.globalState['direct'] = 'added directly';
      expect(VariableEnvironment.getValue('direct'), 'added directly');
    });

    test('Variables persist across multiple operations', () {
      VariableEnvironment.addOrUpdateVariable('counter', 1);
      expect(VariableEnvironment.getValue('counter'), 1);

      VariableEnvironment.addOrUpdateVariable('counter', 2);
      expect(VariableEnvironment.getValue('counter'), 2);

      VariableEnvironment.addOrUpdateVariable('counter', 3);
      expect(VariableEnvironment.getValue('counter'), 3);
    });

    test('globalState and getValue return same reference', () {
      VariableEnvironment.addOrUpdateVariable('map', {'key': 'value'});

      final mapViaGlobalState = VariableEnvironment.globalState['map'];
      final mapViaGetValue = VariableEnvironment.getValue('map');

      expect(mapViaGlobalState, mapViaGetValue);
    });
  });

  group('VariableEnvironment - Edge Cases', () {
    setUp(() {
      VariableEnvironment.globalState.clear();
    });

    test('Variable name with special characters', () {
      VariableEnvironment.addOrUpdateVariable('var_with_underscore', 'value');
      VariableEnvironment.addOrUpdateVariable('var123', 'value');

      expect(VariableEnvironment.getValue('var_with_underscore'), 'value');
      expect(VariableEnvironment.getValue('var123'), 'value');
    });

    test('Empty string as variable name', () {
      VariableEnvironment.addOrUpdateVariable('', 'empty name');
      expect(VariableEnvironment.getValue(''), 'empty name');
    });

    test('Very long variable name', () {
      final longName = 'a' * 1000;
      VariableEnvironment.addOrUpdateVariable(longName, 'long name value');
      expect(VariableEnvironment.getValue(longName), 'long name value');
    });

    test('Overwrite with different type', () {
      VariableEnvironment.addOrUpdateVariable('data', 'string');
      expect(VariableEnvironment.getValue('data'), 'string');

      VariableEnvironment.addOrUpdateVariable('data', 42);
      expect(VariableEnvironment.getValue('data'), 42);

      VariableEnvironment.addOrUpdateVariable('data', {'key': 'value'});
      expect(VariableEnvironment.getValue('data'), {'key': 'value'});
    });

    test('Variable with whitespace in name', () {
      VariableEnvironment.addOrUpdateVariable('var with spaces', 'value');
      expect(VariableEnvironment.getValue('var with spaces'), 'value');
    });

    test('Case sensitivity of variable names', () {
      VariableEnvironment.addOrUpdateVariable('Var', 'uppercase V');
      VariableEnvironment.addOrUpdateVariable('var', 'lowercase v');

      expect(VariableEnvironment.getValue('Var'), 'uppercase V');
      expect(VariableEnvironment.getValue('var'), 'lowercase v');
    });

    test('Empty list as variable value', () {
      VariableEnvironment.addOrUpdateVariable('emptyList', []);
      expect(VariableEnvironment.getValue('emptyList'), []);
      expect((VariableEnvironment.getValue('emptyList') as List).length, 0);
    });

    test('Empty map as variable value', () {
      VariableEnvironment.addOrUpdateVariable('emptyMap', {});
      expect(VariableEnvironment.getValue('emptyMap'), {});
      expect((VariableEnvironment.getValue('emptyMap') as Map).length, 0);
    });

    test('Empty string as variable value', () {
      VariableEnvironment.addOrUpdateVariable('emptyString', '');
      expect(VariableEnvironment.getValue('emptyString'), '');
    });

    test('Zero as variable value', () {
      VariableEnvironment.addOrUpdateVariable('zero', 0);
      expect(VariableEnvironment.getValue('zero'), 0);
    });

    test('False as variable value is not treated as null', () {
      VariableEnvironment.addOrUpdateVariable('falseValue', false);
      expect(VariableEnvironment.getValue('falseValue'), false);
      expect(VariableEnvironment.getValue('falseValue'), isNotNull);
    });
  });

  group('VariableEnvironment - Real World Scenarios', () {
    setUp(() {
      VariableEnvironment.globalState.clear();
    });

    test('User profile storage and retrieval', () {
      final userProfile = {
        'id': 1,
        'name': 'John Doe',
        'email': 'john@example.com',
        'roles': ['user', 'admin'],
        'settings': {'theme': 'dark', 'notifications': true},
      };

      VariableEnvironment.addOrUpdateVariable('currentUser', userProfile);

      final retrieved = VariableEnvironment.getValue('currentUser');
      expect((retrieved as Map)['name'], 'John Doe');
      expect((retrieved['roles'] as List).contains('admin'), true);
      expect((retrieved['settings'] as Map)['theme'], 'dark');
    });

    test('Session variables in order processing', () {
      VariableEnvironment.addOrUpdateVariable('orderId', 'ORD-12345');
      VariableEnvironment.addOrUpdateVariable('customerId', 'CUST-789');
      VariableEnvironment.addOrUpdateVariable('totalAmount', 199.99);
      VariableEnvironment.addOrUpdateVariable('discountApplied', true);

      expect(VariableEnvironment.getValue('orderId'), 'ORD-12345');
      expect(VariableEnvironment.getValue('customerId'), 'CUST-789');
      expect(VariableEnvironment.getValue('totalAmount'), 199.99);
      expect(VariableEnvironment.getValue('discountApplied'), true);
    });

    test('Update user preferences', () {
      final user = {
        'preferences': {'newsletter': false, 'frequency': 'weekly'},
      };
      VariableEnvironment.addOrUpdateVariable('user', user);

      // Simulate updating preferences
      var updatedUser = VariableEnvironment.getValue('user') as Map;
      (updatedUser['preferences'] as Map)['newsletter'] = true;
      VariableEnvironment.addOrUpdateVariable('user', updatedUser);

      expect(((VariableEnvironment.getValue('user') as Map)['preferences'] as Map)['newsletter'], true);
    });

    test('Counters and metrics', () {
      VariableEnvironment.addOrUpdateVariable('pageViews', 0);
      VariableEnvironment.addOrUpdateVariable('clicks', 0);

      var views = VariableEnvironment.getValue('pageViews') as num;
      VariableEnvironment.addOrUpdateVariable('pageViews', views + 1);

      var clicks = VariableEnvironment.getValue('clicks') as num;
      VariableEnvironment.addOrUpdateVariable('clicks', clicks + 5);

      expect(VariableEnvironment.getValue('pageViews'), 1);
      expect(VariableEnvironment.getValue('clicks'), 5);
    });

    test('Temporary state in workflow', () {
      VariableEnvironment.addOrUpdateVariable('formData', {
        'firstName': 'Jane',
        'lastName': 'Smith',
        'email': 'jane@example.com',
      });
      VariableEnvironment.addOrUpdateVariable('isFormValid', true);
      VariableEnvironment.addOrUpdateVariable('submitInProgress', false);

      final formData = VariableEnvironment.getValue('formData') as Map;
      expect(formData['firstName'], 'Jane');
      expect(VariableEnvironment.getValue('isFormValid'), true);
      expect(VariableEnvironment.getValue('submitInProgress'), false);
    });
  });

  group('VariableEnvironment - Concurrency Simulation', () {
    setUp(() {
      VariableEnvironment.globalState.clear();
    });

    test('Multiple sequential updates', () {
      for (var i = 0; i < 100; i++) {
        VariableEnvironment.addOrUpdateVariable('counter', i);
      }
      expect(VariableEnvironment.getValue('counter'), 99);
    });

    test('Many variables in state', () {
      for (var i = 0; i < 1000; i++) {
        VariableEnvironment.addOrUpdateVariable('var_$i', i * 2);
      }

      expect(VariableEnvironment.globalState.length, 1000);
      expect(VariableEnvironment.getValue('var_500'), 1000);
      expect(VariableEnvironment.getValue('var_999'), 1998);
    });

    test('Rapid value changes', () {
      VariableEnvironment.addOrUpdateVariable('state', 'initial');

      for (final newState in ['loading', 'success', 'error', 'initial']) {
        VariableEnvironment.addOrUpdateVariable('state', newState);
      }

      expect(VariableEnvironment.getValue('state'), 'initial');
    });
  });
}
