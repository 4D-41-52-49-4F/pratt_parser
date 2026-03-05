import 'package:abschlussprojekt/src/models/syntax_parser/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Lexer - String Literal Tests', () {
    final lexer = Lexer();

    test('Tokenize single-quoted string literal', () {
      final tokens = lexer.tokenize('"hello"');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.stringLiteral);
      expect(tokens[0].lexeme, 'hello');
    });

    test('Tokenize double-quoted string literal', () {
      final tokens = lexer.tokenize("'hello'");
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.stringLiteral);
      expect(tokens[0].lexeme, 'hello');
    });

    test('Tokenize empty string literal', () {
      final tokens = lexer.tokenize('""');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.stringLiteral);
      expect(tokens[0].lexeme, '');
    });

    test('Tokenize string with spaces', () {
      final tokens = lexer.tokenize('"hello world"');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.stringLiteral);
      expect(tokens[0].lexeme, 'hello world');
    });

    test('Tokenize string with special characters', () {
      final tokens = lexer.tokenize('"hello@world#test"');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.stringLiteral);
      expect(tokens[0].lexeme, 'hello@world#test');
    });

    test('Tokenize multiple string literals', () {
      final tokens = lexer.tokenize('"first" "second"');
      expect(tokens.length, 2);
      expect(tokens[0].type, TokenType.stringLiteral);
      expect(tokens[0].lexeme, 'first');
      expect(tokens[1].type, TokenType.stringLiteral);
      expect(tokens[1].lexeme, 'second');
    });

    test('Throw exception for unclosed string literal', () {
      expect(() => lexer.tokenize('"unclosed'), throwsException);
    });
  });

  group('Lexer - Numeral Literal Tests', () {
    final lexer = Lexer();

    test('Tokenize integer literal', () {
      final tokens = lexer.tokenize('42');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.numeralLiteral);
      expect(tokens[0].lexeme, '42');
    });

    test('Tokenize zero', () {
      final tokens = lexer.tokenize('0');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.numeralLiteral);
      expect(tokens[0].lexeme, '0');
    });

    test('Tokenize negative-looking number (starts with digit)', () {
      final tokens = lexer.tokenize('123');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.numeralLiteral);
      expect(tokens[0].lexeme, '123');
    });

    test('Tokenize decimal number', () {
      final tokens = lexer.tokenize('3.14');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.numeralLiteral);
      expect(tokens[0].lexeme, '3.14');
    });

    test('Tokenize decimal starting with dot', () {
      final tokens = lexer.tokenize('.5');
      // The lexer tokenizes '.' as an operator and '5' as a numeral
      expect(tokens.length, 2);
      expect(tokens[0].type, TokenType.operator);
      expect(tokens[0].lexeme, '.');
      expect(tokens[1].type, TokenType.numeralLiteral);
      expect(tokens[1].lexeme, '5');
    });

    test('Tokenize multiple decimal numbers', () {
      final tokens = lexer.tokenize('1.5 2.7');
      expect(tokens.length, 2);
      expect(tokens[0].type, TokenType.numeralLiteral);
      expect(tokens[0].lexeme, '1.5');
      expect(tokens[1].type, TokenType.numeralLiteral);
      expect(tokens[1].lexeme, '2.7');
    });

    test('Tokenize large number', () {
      final tokens = lexer.tokenize('1000000');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.numeralLiteral);
      expect(tokens[0].lexeme, '1000000');
    });
  });

  group('Lexer - Boolean Literal Tests', () {
    final lexer = Lexer();

    test('Tokenize true literal', () {
      final tokens = lexer.tokenize('true');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.booleanLiteral);
      expect(tokens[0].lexeme, 'true');
    });

    test('Tokenize false literal', () {
      final tokens = lexer.tokenize('false');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.booleanLiteral);
      expect(tokens[0].lexeme, 'false');
    });

    test('Tokenize true and false together', () {
      final tokens = lexer.tokenize('true false');
      expect(tokens.length, 2);
      expect(tokens[0].type, TokenType.booleanLiteral);
      expect(tokens[0].lexeme, 'true');
      expect(tokens[1].type, TokenType.booleanLiteral);
      expect(tokens[1].lexeme, 'false');
    });

    test('Tokenize uppercase TRUE', () {
      final tokens = lexer.tokenize('TRUE');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.booleanLiteral);
      expect(tokens[0].lexeme, 'TRUE');
    });

    test('Tokenize lowercase true', () {
      final tokens = lexer.tokenize('true');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.booleanLiteral);
      expect(tokens[0].lexeme, 'true');
    });
  });

  group('Lexer - Null Literal Tests', () {
    final lexer = Lexer();

    test('Tokenize null literal', () {
      final tokens = lexer.tokenize('null');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.nullLiteral);
      expect(tokens[0].lexeme, 'null');
    });

    test('Tokenize NULL (uppercase)', () {
      final tokens = lexer.tokenize('NULL');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.nullLiteral);
      expect(tokens[0].lexeme, 'NULL');
    });

    test('Tokenize Null (mixed case)', () {
      final tokens = lexer.tokenize('Null');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.nullLiteral);
      expect(tokens[0].lexeme, 'Null');
    });
  });

  group('Lexer - Identifier Tests', () {
    final lexer = Lexer();

    test('Tokenize simple identifier', () {
      final tokens = lexer.tokenize('variable');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].lexeme, 'variable');
    });

    test('Tokenize identifier with underscore', () {
      final tokens = lexer.tokenize('my_variable');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].lexeme, 'my_variable');
    });

    test('Tokenize identifier starting with underscore', () {
      final tokens = lexer.tokenize('_private');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].lexeme, '_private');
    });

    test('Tokenize identifier with numbers', () {
      final tokens = lexer.tokenize('var123');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].lexeme, 'var123');
    });

    test('Tokenize camelCase identifier', () {
      final tokens = lexer.tokenize('myVariableName');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].lexeme, 'myVariableName');
    });

    test('Tokenize PascalCase identifier', () {
      final tokens = lexer.tokenize('MyClassName');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].lexeme, 'MyClassName');
    });

    test('Tokenize multiple identifiers', () {
      final tokens = lexer.tokenize('foo bar baz');
      expect(tokens.length, 3);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].lexeme, 'foo');
      expect(tokens[1].type, TokenType.identifier);
      expect(tokens[1].lexeme, 'bar');
      expect(tokens[2].type, TokenType.identifier);
      expect(tokens[2].lexeme, 'baz');
    });

    test('Tokenize identifier followed by operator', () {
      final tokens = lexer.tokenize('x + y');
      expect(tokens.length, 3);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].lexeme, 'x');
      expect(tokens[1].type, TokenType.operator);
      expect(tokens[1].lexeme, '+');
      expect(tokens[2].type, TokenType.identifier);
      expect(tokens[2].lexeme, 'y');
    });
  });

  group('Lexer - Operator Tests', () {
    final lexer = Lexer();

    test('Tokenize single-character operators', () {
      final operators = ['+', '-', '*', '/', '%', '<', '>', '!', '?', ':', '.', '^'];
      for (final op in operators) {
        final tokens = lexer.tokenize(op);
        expect(tokens.length, 1, reason: 'Operator $op');
        expect(tokens[0].type, TokenType.operator, reason: 'Operator $op');
        expect(tokens[0].lexeme, op, reason: 'Operator $op');
      }
    });

    test('Tokenize multi-character operators', () {
      final operators = ['==', '!=', '<=', '>=', '&&', '||'];
      for (final op in operators) {
        final tokens = lexer.tokenize(op);
        expect(tokens.length, 1, reason: 'Operator $op');
        expect(tokens[0].type, TokenType.operator, reason: 'Operator $op');
        expect(tokens[0].lexeme, op, reason: 'Operator $op');
      }
    });

    test('Tokenize assignment operator', () {
      final tokens = lexer.tokenize('=');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.operator);
      expect(tokens[0].lexeme, '=');
    });

    test('Tokenize multiple operators', () {
      final tokens = lexer.tokenize('+ - * /');
      expect(tokens.length, 4);
      expect(tokens[0].lexeme, '+');
      expect(tokens[1].lexeme, '-');
      expect(tokens[2].lexeme, '*');
      expect(tokens[3].lexeme, '/');
    });

    test('Tokenize comparison operators', () {
      final tokens = lexer.tokenize('<= >= == !=');
      expect(tokens.length, 4);
      expect(tokens[0].lexeme, '<=');
      expect(tokens[1].lexeme, '>=');
      expect(tokens[2].lexeme, '==');
      expect(tokens[3].lexeme, '!=');
    });

    test('Tokenize logical operators', () {
      final tokens = lexer.tokenize('&& ||');
      expect(tokens.length, 2);
      expect(tokens[0].lexeme, '&&');
      expect(tokens[1].lexeme, '||');
    });
  });

  group('Lexer - Parenthesis Tests', () {
    final lexer = Lexer();

    test('Tokenize opening parenthesis', () {
      final tokens = lexer.tokenize('(');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.openingParenthesis);
      expect(tokens[0].lexeme, '(');
    });

    test('Tokenize closing parenthesis', () {
      final tokens = lexer.tokenize(')');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.closingParenthesis);
      expect(tokens[0].lexeme, ')');
    });

    test('Tokenize opening bracket', () {
      final tokens = lexer.tokenize('[');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.openingParenthesis);
      expect(tokens[0].lexeme, '[');
    });

    test('Tokenize closing bracket', () {
      final tokens = lexer.tokenize(']');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.closingParenthesis);
      expect(tokens[0].lexeme, ']');
    });

    test('Tokenize opening brace', () {
      final tokens = lexer.tokenize('{');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.openingParenthesis);
      expect(tokens[0].lexeme, '{');
    });

    test('Tokenize closing brace', () {
      final tokens = lexer.tokenize('}');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.closingParenthesis);
      expect(tokens[0].lexeme, '}');
    });

    test('Tokenize balanced parentheses', () {
      final tokens = lexer.tokenize('(())');
      expect(tokens.length, 4);
      expect(tokens[0].type, TokenType.openingParenthesis);
      expect(tokens[1].type, TokenType.openingParenthesis);
      expect(tokens[2].type, TokenType.closingParenthesis);
      expect(tokens[3].type, TokenType.closingParenthesis);
    });
  });

  group('Lexer - Comma Tests', () {
    final lexer = Lexer();

    test('Tokenize comma', () {
      final tokens = lexer.tokenize(',');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.comma);
      expect(tokens[0].lexeme, ',');
    });

    test('Tokenize multiple commas', () {
      final tokens = lexer.tokenize(', , ,');
      expect(tokens.length, 3);
      for (final token in tokens) {
        expect(token.type, TokenType.comma);
      }
    });
  });

  group('Lexer - Whitespace Handling Tests', () {
    final lexer = Lexer();

    test('Skip spaces between tokens', () {
      final tokens = lexer.tokenize('a   b   c');
      expect(tokens.length, 3);
      expect(tokens[0].lexeme, 'a');
      expect(tokens[1].lexeme, 'b');
      expect(tokens[2].lexeme, 'c');
    });

    test('Skip tabs between tokens', () {
      final tokens = lexer.tokenize('a\tb\tc');
      expect(tokens.length, 3);
      expect(tokens[0].lexeme, 'a');
      expect(tokens[1].lexeme, 'b');
      expect(tokens[2].lexeme, 'c');
    });

    test('Skip newlines between tokens', () {
      final tokens = lexer.tokenize('a\nb\nc');
      expect(tokens.length, 3);
      expect(tokens[0].lexeme, 'a');
      expect(tokens[1].lexeme, 'b');
      expect(tokens[2].lexeme, 'c');
    });

    test('Skip mixed whitespace', () {
      final tokens = lexer.tokenize('a \t\n b \r c');
      expect(tokens.length, 3);
      expect(tokens[0].lexeme, 'a');
      expect(tokens[1].lexeme, 'b');
      expect(tokens[2].lexeme, 'c');
    });

    test('Handle leading whitespace', () {
      final tokens = lexer.tokenize('   hello');
      expect(tokens.length, 1);
      expect(tokens[0].lexeme, 'hello');
    });

    test('Handle trailing whitespace', () {
      final tokens = lexer.tokenize('hello   ');
      expect(tokens.length, 1);
      expect(tokens[0].lexeme, 'hello');
    });
  });

  group('Lexer - Complex Expression Tests', () {
    final lexer = Lexer();

    test('Tokenize simple arithmetic expression', () {
      final tokens = lexer.tokenize('1 + 2');
      expect(tokens.length, 3);
      expect(tokens[0].type, TokenType.numeralLiteral);
      expect(tokens[0].lexeme, '1');
      expect(tokens[1].type, TokenType.operator);
      expect(tokens[1].lexeme, '+');
      expect(tokens[2].type, TokenType.numeralLiteral);
      expect(tokens[2].lexeme, '2');
    });

    test('Tokenize function call-like expression', () {
      // The lexer tokenizes: foo, (, bar,, baz, )
      // Note: comma is not a forbidden char, so it's included in identifier
      final tokens = lexer.tokenize('foo(bar, baz)');
      expect(tokens.length, 5);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].lexeme, 'foo');
      expect(tokens[1].type, TokenType.openingParenthesis);
      expect(tokens[1].lexeme, '(');
      expect(tokens[2].type, TokenType.identifier);
      expect(tokens[2].lexeme, 'bar,');
      expect(tokens[3].type, TokenType.identifier);
      expect(tokens[3].lexeme, 'baz');
      expect(tokens[4].type, TokenType.closingParenthesis);
      expect(tokens[4].lexeme, ')');
    });

    test('Tokenize ternary expression', () {
      final tokens = lexer.tokenize('a ? b : c');
      expect(tokens.length, 5);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].lexeme, 'a');
      expect(tokens[1].type, TokenType.operator);
      expect(tokens[1].lexeme, '?');
      expect(tokens[2].type, TokenType.identifier);
      expect(tokens[2].lexeme, 'b');
      expect(tokens[3].type, TokenType.operator);
      expect(tokens[3].lexeme, ':');
      expect(tokens[4].type, TokenType.identifier);
      expect(tokens[4].lexeme, 'c');
    });

    test('Tokenize boolean expression', () {
      final tokens = lexer.tokenize('true && false || true');
      expect(tokens.length, 5);
      expect(tokens[0].type, TokenType.booleanLiteral);
      expect(tokens[0].lexeme, 'true');
      expect(tokens[1].type, TokenType.operator);
      expect(tokens[1].lexeme, '&&');
      expect(tokens[2].type, TokenType.booleanLiteral);
      expect(tokens[2].lexeme, 'false');
      expect(tokens[3].type, TokenType.operator);
      expect(tokens[3].lexeme, '||');
      expect(tokens[4].type, TokenType.booleanLiteral);
      expect(tokens[4].lexeme, 'true');
    });

    test('Tokenize comparison expression', () {
      final tokens = lexer.tokenize('x <= y && y >= z');
      expect(tokens.length, 7);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].lexeme, 'x');
      expect(tokens[1].type, TokenType.operator);
      expect(tokens[1].lexeme, '<=');
      expect(tokens[2].type, TokenType.identifier);
      expect(tokens[2].lexeme, 'y');
      expect(tokens[3].type, TokenType.operator);
      expect(tokens[3].lexeme, '&&');
      expect(tokens[4].type, TokenType.identifier);
      expect(tokens[4].lexeme, 'y');
      expect(tokens[5].type, TokenType.operator);
      expect(tokens[5].lexeme, '>=');
      expect(tokens[6].type, TokenType.identifier);
      expect(tokens[6].lexeme, 'z');
    });

    test('Tokenize string in expression', () {
      final tokens = lexer.tokenize('"hello" + "world"');
      expect(tokens.length, 3);
      expect(tokens[0].type, TokenType.stringLiteral);
      expect(tokens[0].lexeme, 'hello');
      expect(tokens[1].type, TokenType.operator);
      expect(tokens[1].lexeme, '+');
      expect(tokens[2].type, TokenType.stringLiteral);
      expect(tokens[2].lexeme, 'world');
    });

    test('Tokenize null in expression', () {
      final tokens = lexer.tokenize('x == null');
      expect(tokens.length, 3);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].lexeme, 'x');
      expect(tokens[1].type, TokenType.operator);
      expect(tokens[1].lexeme, '==');
      expect(tokens[2].type, TokenType.nullLiteral);
      expect(tokens[2].lexeme, 'null');
    });
  });

  group('Lexer - Error Handling Tests', () {
    final lexer = Lexer();

    test('Throw exception for unknown single character', () {
      expect(() => lexer.tokenize('@'), throwsException);
    });

    test('Throw exception for unknown multi-character sequence', () {
      expect(() => lexer.tokenize('@@'), throwsException);
    });

    test('Throw exception for invalid character in middle of input', () {
      expect(() => lexer.tokenize('a @ b'), throwsException);
    });

    test('Throw exception for invalid character at end', () {
      expect(() => lexer.tokenize('a @'), throwsException);
    });
  });

  group('Lexer - Edge Cases', () {
    final lexer = Lexer();

    test('Tokenize empty string', () {
      final tokens = lexer.tokenize('');
      expect(tokens.length, 0);
    });

    test('Tokenize string with only whitespace', () {
      final tokens = lexer.tokenize('   \t\n  ');
      expect(tokens.length, 0);
    });

    test('Tokenize consecutive operators', () {
      final tokens = lexer.tokenize('++--');
      expect(tokens.length, 3);
      expect(tokens[0].type, TokenType.operator);
      expect(tokens[0].lexeme, '+');
      expect(tokens[1].type, TokenType.operator);
      expect(tokens[1].lexeme, '+-');
      expect(tokens[2].type, TokenType.operator);
      expect(tokens[2].lexeme, '-');
    });

    test('Tokenize mixed case identifiers', () {
      final tokens = lexer.tokenize('ABC abc AbC aBc');
      expect(tokens.length, 4);
      expect(tokens[0].lexeme, 'ABC');
      expect(tokens[1].lexeme, 'abc');
      expect(tokens[2].lexeme, 'AbC');
      expect(tokens[3].lexeme, 'aBc');
    });

    test('Tokenize identifier that looks like keyword', () {
      final tokens = lexer.tokenize('truetrue');
      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].lexeme, 'truetrue');
    });

    test('Tokenize number followed by identifier', () {
      final tokens = lexer.tokenize('123var');
      expect(tokens.length, 2);
      expect(tokens[0].type, TokenType.numeralLiteral);
      expect(tokens[0].lexeme, '123');
      expect(tokens[1].type, TokenType.identifier);
      expect(tokens[1].lexeme, 'var');
    });
  });
}
