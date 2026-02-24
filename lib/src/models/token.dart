class Tokenizer {
  const Tokenizer();

  List<Token> tokenize(String input) {
    final tokens = <Token>[];

    var newInput = input;

    while (newInput.isNotEmpty) {
      final c = newInput[0];

      if (c == ' ' || c == '\t') {
        newInput = newInput.substring(1);
        continue;
      }

      final isObjectSeperator = _isObjectSeperator(c);
      if (isObjectSeperator) {
        tokens.add(Token(TokenType.objectSeperator, '.'));
        newInput = newInput.substring(1);
        continue;
      }

      final isNumber = _isNumber(c);
      final isOperator = _isOperator(c);
      final isParenthese = _isParenthese(c);
      final isLetter = _isLetter(c);

      if (isNumber) {
        newInput = _extractToken(newInput, TokenType.number, _isNumber, tokens);
      }

      if (isOperator) {
        newInput = _extractToken(newInput, TokenType.operator, _isOperator, tokens);
      }

      if (isParenthese) {
        newInput = _extractToken(newInput, TokenType.parenthese, _isParenthese, tokens);
      }

      if (isLetter) {
        newInput = _extractToken(newInput, TokenType.identifier, _isLetter, tokens);
      }
    }

    return tokens;
  }

  String _extractToken(String input, TokenType type, bool Function(String) checker, List<Token> tokens) {
    final buffer = StringBuffer();
    final l = input.length;
    var isType = true;
    var i = 0;

    do {
      final c = input[i];
      isType = checker(c);
      if (!isType) break;
      buffer.write(c);
      i++;
    } while (i < l);
    tokens.add(Token(TokenType.identifier, buffer.toString()));

    return input.substring(i);
  }

  bool _isNumber(String c) => '0123456789'.contains(c);
  bool _isOperator(String c) => '><=!+-*/%&|^~?:'.contains(c);
  bool _isParenthese(String c) => '{[()]}'.contains(c);
  bool _isObjectSeperator(String c) => c == '.';
  bool _isLetter(String c) => RegExp('[A-Za-z_]').hasMatch(c);
}

class Token {
  final TokenType type;
  final String value;
  Token(this.type, this.value);
  @override
  String toString() => '$type($value)';
}

enum TokenType { number, parenthese, operator, identifier, object, objectSeperator }
