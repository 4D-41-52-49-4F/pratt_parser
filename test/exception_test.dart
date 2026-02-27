import 'package:test/test.dart';
import 'package:abschlussprojekt/src/models/syntax_parser/syntax_parser.dart';
import 'package:abschlussprojekt/src/models/tokenizer.dart';

void main() {
  group('Unary Expressions', () {
    test('Not operator with non-boolean', () {
      const rule = '!5';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(() => expression.evaluate(), throwsException);
    });

    test('Unary minus with non-number', () {
      const rule = '-"string"';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(() => expression.evaluate(), throwsException);
    });

    test('Valid unary minus does not throw', () {
      const rule = '-5';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), -5);
    });
  });

  group('Binary Expressions', () {
    test('Arithmetic with invalid operand', () {
      const rule = '3 + "str"';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(() => expression.evaluate(), throwsException);
    });

    test('Division by zero', () {
      const rule = '10 / 0';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(() => expression.evaluate(), throwsException);
    });

    test('Relational operator with non-number', () {
      const rule = '"a" > 3';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(() => expression.evaluate(), throwsException);
    });

    test('Logical operator with non-boolean', () {
      const rule = 'true && 1';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(() => expression.evaluate(), throwsException);
    });

    test('Valid arithmetic does not throw', () {
      const rule = '3 + 4';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 7);
    });
  });

  group('Ternary Expressions', () {
    test('Ternary with non-boolean condition', () {
      const rule = '"str" ? 1 : 0';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(() => expression.evaluate(), throwsException);
    });

    test('Valid ternary with boolean condition', () {
      const rule = 'true ? 1 : 0';
      final tokens = const Tokenizer().tokenize(rule);
      final parser = SyntaxParser(tokens);
      final expression = parser.parseSyntaxTree();

      expect(expression.evaluate(), 1);
    });
  });
}
