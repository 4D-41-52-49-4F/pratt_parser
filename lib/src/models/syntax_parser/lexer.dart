/// A lexer for tokenizing input strings into a list of [Token] objects.
///
/// The lexer processes input character by character and produces a sequence of
/// tokens representing literals, operators, identifiers, and punctuation.
class Lexer {
  /// Creates a new [Lexer] instance.
  const Lexer();

  /// Tokenizes the given [input] string into a list of [Token] objects.
  ///
  /// The method processes the input character by character, identifying and
  /// categorizing each element as a literal (string, number, boolean, null),
  /// operator, identifier, or punctuation token.
  ///
  /// Throws an [Exception] if an unknown character is encountered or if a
  /// string literal is not properly closed.
  ///
  /// Returns a list of [Token] objects representing the tokenized input.
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

  /// Returns true if the given character [c] is a digit.
  bool _isNumber(String c) => RegExp(r'\d').hasMatch(c);

  /// Returns true if the given character [c] is a letter or underscore.
  bool _isLetter(String c) => RegExp('[A-Za-z_]').hasMatch(c);

  /// Returns true if the given character [c] is a string delimiter (single or double quote).
  bool _isStringDelimiter(String c) => '\'"'.contains(c);

  /// Returns true if the given string [s] represents the null literal.
  bool _isNull(String s) => s.toLowerCase() == 'null';

  /// Returns true if the given string [s] represents a boolean literal (true or false).
  bool _isBooleanLiteral(String s) => s.toLowerCase() == 'true' || s.toLowerCase() == 'false';

  /// Returns true if the given character [c] is an opening parenthesis.
  bool _isOpeningParenthesis(String c) => '([{'.contains(c);

  /// Returns true if the given character [c] is a closing parenthesis.
  bool _isClosingParenthesis(String c) => ')]}'.contains(c);

  /// Returns true if the given string [s] is a valid operator.
  ///
  /// Checks for both two-character operators (==, !=, <=, >=, &&, ||, ++, --) and
  /// single-character operators (+, -, *, /, %, <, >, =, !, ?, ., ^).
  bool _isOperator(String s) =>
      ['==', '!=', '<=', '>=', '&&', '||', '++', '--', '+=', '-=', '*=', '/='].contains(s) ||
      '+-*/%><=!?:.^'.contains(s);

  /// Returns true if the given character [c] is neither a letter nor a number.
  bool _isForbiddenChar(String c) => !_isLetter(c) && !_isNumber(c);
}

/// Represents a token produced by the [Lexer].
///
/// A token consists of a [type] indicating its category and a [lexeme]
/// containing the actual string representation from the input.
class Token {
  /// The type of this token, indicating its category.
  final TokenType type;

  /// The lexeme, which is the actual string representation from the input.
  final String lexeme;

  /// Creates a new [Token] with the given [type] and [lexeme].
  const Token(this.type, this.lexeme);

  /// Returns a string representation of this token in the format `type(lexeme)`.
  @override
  String toString() => '$type($lexeme)';
}

/// Enum representing the different types of tokens that can be produced by the [Lexer].
enum TokenType {
  /// A boolean literal token (true or false).
  booleanLiteral,

  /// A numeral literal token (e.g., 42, 3.14).
  numeralLiteral,

  /// A string literal token (e.g., "hello").
  stringLiteral,

  /// A null literal token.
  nullLiteral,

  /// A closing parenthesis token (), ], }).
  closingParenthesis,

  /// An opening parenthesis token (, [, {.
  openingParenthesis,

  /// An operator token (e.g., +, -, *, /, ==, &&).
  operator,

  /// An identifier token (variable or function name).
  identifier,

  /// A comma token used as a separator.
  comma,
}
