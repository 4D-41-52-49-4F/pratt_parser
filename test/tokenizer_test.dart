import 'package:abschlussprojekt/src/models/syntax_parser/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  test('Tokenizer: andreas(hoefer)', () {
    const string = 'andreas(hoefer)';
    const tokenizer = Tokenizer();
    final tokens = tokenizer.tokenize(string);
    expect(tokens.length, 4);
    expect(tokens[0].type, TokenType.identifier);
    expect(tokens[1].type, TokenType.openingParenthesis);
    expect(tokens[2].type, TokenType.identifier);
    expect(tokens[3].type, TokenType.closingParenthesis);
  });
  test('Tokenizer: andreas123(hoefer123)', () {
    final string = 'andreas123(hoefer123)';
    final tokenizer = Tokenizer();
    final tokens = tokenizer.tokenize(string);
    expect(tokens.length, 4);
    expect(tokens[0].type, TokenType.identifier);
    expect(tokens[1].type, TokenType.openingParenthesis);
    expect(tokens[2].type, TokenType.identifier);
    expect(tokens[3].type, TokenType.closingParenthesis);
  });
  test('Tokenizer: andreas123(123)', () {
    final string = 'andreas123(123)';
    final tokenizer = Tokenizer();
    final tokens = tokenizer.tokenize(string);
    expect(tokens.length, 4);
    expect(tokens[0].type, TokenType.identifier);
    expect(tokens[1].type, TokenType.openingParenthesis);
    expect(tokens[2].type, TokenType.numeralLiteral);
    expect(tokens[3].type, TokenType.closingParenthesis);
  });
  test('Tokenizer: andreas123(true)', () {
    final string = 'andreas123(true)';
    final tokenizer = Tokenizer();
    final tokens = tokenizer.tokenize(string);
    expect(tokens.length, 4);
    expect(tokens[0].type, TokenType.identifier);
    expect(tokens[1].type, TokenType.openingParenthesis);
    expect(tokens[2].type, TokenType.booleanLiteral);
    expect(tokens[3].type, TokenType.closingParenthesis);
  });
  test('Tokenizer: andreas("hoefer")', () {
    final string = 'andreas("hoefer")';
    final tokenizer = Tokenizer();
    final tokens = tokenizer.tokenize(string);
    expect(tokens.length, 4);
    expect(tokens[0].type, TokenType.identifier);
    expect(tokens[1].type, TokenType.openingParenthesis);
    expect(tokens[2].type, TokenType.stringLiteral);
    expect(tokens[3].type, TokenType.closingParenthesis);
  });
  test('Tokenizer: andreas(\'hoefer\')', () {
    final string = "andreas('hoefer')";
    final tokenizer = Tokenizer();
    final tokens = tokenizer.tokenize(string);
    expect(tokens.length, 4);
    expect(tokens[0].type, TokenType.identifier);
    expect(tokens[1].type, TokenType.openingParenthesis);
    expect(tokens[2].type, TokenType.stringLiteral);
    expect(tokens[3].type, TokenType.closingParenthesis);
  });
  test('Tokenizer: andreas(\'hoefer\'+hallo)', () {
    final string = "andreas('hoefer'+hallo)";
    final tokenizer = Tokenizer();
    final tokens = tokenizer.tokenize(string);
    expect(tokens.length, 6);
    expect(tokens[0].type, TokenType.identifier);
    expect(tokens[1].type, TokenType.openingParenthesis);
    expect(tokens[2].type, TokenType.stringLiteral);
    expect(tokens[3].type, TokenType.operator);
    expect(tokens[4].type, TokenType.identifier);
    expect(tokens[5].type, TokenType.closingParenthesis);
  });
  test('Tokenizer: andreas(hoefer)+hallo', () {
    final string = 'andreas(hoefer)+hallo';
    final tokenizer = Tokenizer();
    final tokens = tokenizer.tokenize(string);
    expect(tokens.length, 6);
    expect(tokens[0].type, TokenType.identifier);
    expect(tokens[1].type, TokenType.openingParenthesis);
    expect(tokens[2].type, TokenType.identifier);
    expect(tokens[3].type, TokenType.closingParenthesis);
    expect(tokens[4].type, TokenType.operator);
    expect(tokens[5].type, TokenType.identifier);
  });
}
