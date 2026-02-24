import 'package:abschlussprojekt/src/models/token.dart';
import 'package:test/test.dart';

void main() {
  test('Test tokenization', () {
    final rule = 'if(7 + 3 < 10)';

    final dummyToken = Token(TokenType.identifier, 'NIX');

    final tokens = dummyToken.tokenize(rule);

    expect(tokens.length, 8);
  });
}
