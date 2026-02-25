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

      if (_isNumber(c)) {
        final buffer = StringBuffer();
        while (i < input.length && _isNumber(input[i])) {
          buffer.write(input[i]);
          i++;
        }
        tokens.add(Token(TokenType.number, buffer.toString()));
        continue;
      }

      // Identifiers
      if (_isLetter(c)) {
        final buffer = StringBuffer();
        while (i < input.length && (_isLetter(input[i]) || _isNumber(input[i]))) {
          buffer.write(input[i]);
          i++;
        }
        tokens.add(Token(TokenType.functionIdentifier, buffer.toString()));
        continue;
      }

      // Multi-char operators
      if (i + 1 < input.length) {
        final twoChar = input.substring(i, i + 2);
        if (_isOperator(twoChar)) {
          tokens.add(Token(TokenType.operator, twoChar));
          i += 2;
          continue;
        }
      }

      // Single-char operator
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
        tokens.add(Token(TokenType.functionParameterSeperator, c));
        i++;
        continue;
      }

      if (c == '.') {
        tokens.add(Token(TokenType.objectRelation, c));
        i++;
        continue;
      }

      throw Exception("Unknown character: $c");
    }

    return tokens;
  }

  bool _isNumber(String c) => RegExp(r'\d').hasMatch(c);
  bool _isLetter(String c) => RegExp(r'[A-Za-z_]').hasMatch(c);
  bool _isOperator(String s) => ['==', '!=', '<=', '>=', '&&', '||'].contains(s) || '+-*/%><=!'.contains(s);
}

class Token {
  final TokenType type;
  final String value;

  bool get isPartOfTreeStructure => switch (type) {
    TokenType.string => true,
    TokenType.number => true,
    TokenType.operator => true,
    TokenType.functionIdentifier => true,
    TokenType.functionParameter => true,
    TokenType.objectRelation => true,
    (_) => false,
  };

  Token(this.type, this.value);
  @override
  String toString() => '$type($value)';
}

enum TokenType {
  string,
  number,
  closingParenthesis,
  openingParenthesis,
  operator,
  functionIdentifier,
  functionParameter,
  functionParameterSeperator,
  objectRelation,
  objectSeperator,
}
