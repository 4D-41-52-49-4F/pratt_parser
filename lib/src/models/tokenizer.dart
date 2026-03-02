class Tokenizer {
  const Tokenizer();

  List<Token> tokenize(String input) {
    final tokens = <Token>[];
    int i = 0;

    while (i < input.length) {
      final c = input[i];

      if (c.trim().isEmpty) {
        i++;
        continue;
      }

      if (_isStringDelimiter(c)) {
        final delimiter = c;
        final buffer = StringBuffer();
        i++;
        while (i < input.length && input[i] != delimiter) {
          buffer.write(input[i]);
          i++;
        }
        tokens.add(Token(TokenType.stringLiteral, buffer.toString()));
        i++;
        continue;
      }

      if (_isNumber(c)) {
        final buffer = StringBuffer();
        while (i < input.length && _isNumber(input[i])) {
          buffer.write(input[i]);
          i++;
        }
        tokens.add(Token(TokenType.numeralLiteral, buffer.toString()));
        continue;
      }

      if (_isLetter(c)) {
        final buffer = StringBuffer();
        while (i < input.length && (_isLetter(input[i]) || _isNumber(input[i]))) {
          buffer.write(input[i]);
          i++;
        }
        final string = buffer.toString();
        if (_isBooleanLiteral(string)) {
          tokens.add(Token(TokenType.booleanLiteral, string));
          continue;
        }

        if (_isNull(string)) {
          tokens.add(Token(TokenType.nullLiteral, string));
          continue;
        }

        tokens.add(Token(TokenType.identifier, buffer.toString()));
        continue;
      }

      if (i + 1 < input.length) {
        final twoChar = input.substring(i, i + 2);
        if (_isOperator(twoChar)) {
          tokens.add(Token(TokenType.operator, twoChar));
          i += 2;
          continue;
        }
      }

      if (_isOperator(c)) {
        tokens.add(Token(TokenType.operator, c));
        i++;
        continue;
      }

      if ('([{'.contains(c)) {
        tokens.add(Token(TokenType.openingParenthesis, c));
        i++;
        continue;
      }

      if (')]}'.contains(c)) {
        tokens.add(Token(TokenType.closingParenthesis, c));
        i++;
        continue;
      }

      if (c == ',') {
        tokens.add(Token(TokenType.comma, c));
        i++;
        continue;
      }

      if (c == '.') {
        tokens.add(Token(TokenType.dot, c));
        i++;
        continue;
      }

      throw Exception("Unknown character: $c");
    }

    return tokens;
  }

  bool _isNumber(String c) => RegExp(r'\d').hasMatch(c);
  bool _isLetter(String c) => RegExp(r'[A-Za-z_]').hasMatch(c);
  bool _isStringDelimiter(String c) => '\'"'.contains(c);
  bool _isNull(String s) => s.toLowerCase() == 'null';
  bool _isBooleanLiteral(String s) => s.toLowerCase() == 'true' || s.toLowerCase() == 'false';
  bool _isOperator(String s) => ['==', '!=', '<=', '>=', '&&', '||'].contains(s) || '+-*/%><=!?:'.contains(s);
}

class Token {
  final TokenType type;
  final String value;

  Token(this.type, this.value);
  @override
  String toString() => '$type($value)';
}

enum TokenType {
  booleanLiteral,
  numeralLiteral,
  stringLiteral,
  nullLiteral,
  closingParenthesis,
  openingParenthesis,
  operator,
  identifier,
  comma,
  dot,
}
