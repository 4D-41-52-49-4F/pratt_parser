class Lexer {
  const Lexer();

  List<Token> tokenize(String input) {
    final tokens = <Token>[];
    var i = 0;

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
        if (i >= input.length || input[i] != delimiter) throw Exception('Saw unlimited String: $buffer');
        tokens.add(Token(TokenType.stringLiteral, buffer.toString()));
        i++;
        continue;
      }

      if (_isNumber(c)) {
        final buffer = StringBuffer();
        var dotted = false;
        while (i < input.length && (_isNumber(input[i]) || (!dotted && '.'.contains(input[i])))) {
          if (input[i] == '.') dotted = true;
          buffer.write(input[i]);
          i++;
        }
        tokens.add(Token(TokenType.numeralLiteral, buffer.toString()));
        continue;
      }

      if (_isLetter(c)) {
        final buffer = StringBuffer();
        while (i < input.length && input[i].trim().isNotEmpty && !_isForbiddenChar(input[i])) {
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

      if (_isOpeningParenthesis(c)) {
        tokens.add(Token(TokenType.openingParenthesis, c));
        i++;
        continue;
      }

      if (_isClosingParenthesis(c)) {
        tokens.add(Token(TokenType.closingParenthesis, c));
        i++;
        continue;
      }

      if (c == ',') {
        tokens.add(Token(TokenType.comma, c));
        i++;
        continue;
      }

      throw Exception('Unknown character: $c');
    }

    return tokens;
  }

  bool _isNumber(String c) => RegExp(r'\d').hasMatch(c);
  bool _isLetter(String c) => RegExp('[A-Za-z_]').hasMatch(c);
  bool _isStringDelimiter(String c) => '\'"'.contains(c);
  bool _isNull(String s) => s.toLowerCase() == 'null';
  bool _isBooleanLiteral(String s) => s.toLowerCase() == 'true' || s.toLowerCase() == 'false';
  bool _isOpeningParenthesis(String c) => '([{'.contains(c);
  bool _isClosingParenthesis(String c) => ')]}'.contains(c);
  bool _isOperator(String s) => ['==', '!=', '<=', '>=', '&&', '||'].contains(s) || '+-*/%><=!?:.^'.contains(s);
  bool _isForbiddenChar(String c) => !_isLetter(c) && !_isNumber(c);
}

class Token {
  final TokenType type;
  final String lexeme;

  const Token(this.type, this.lexeme);
  @override
  String toString() => '$type($lexeme)';
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
}
