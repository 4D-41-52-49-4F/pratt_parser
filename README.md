🔹 Gesamtüberblick

Dein Parser verarbeitet mathematische Ausdrücke wie z.B.:

3 + 4 * 2
sin(5 + 2)
-4 ^ 2

Er berücksichtigt:

Operator-Priorität (z.B. * vor +)

Assoziativität (z.B. links- oder rechtsassoziativ)

Klammern

Funktionen

Unäre Operatoren (-5)

Das Herzstück ist _parseExpression() mit Precedence Climbing.

1️⃣ Einstiegspunkt
SyntaxExpression parseSyntaxTree() {
  final expression = _parseExpression();
  return expression;
}
Was passiert hier?

Start des Parsings

Ruft _parseExpression() ohne Mindestpriorität auf

Gibt den vollständigen Syntaxbaum zurück

Man könnte auch einfach schreiben:

return _parseExpression();
2️⃣ Expression Parsing (Precedence Climbing)
SyntaxExpression _parseExpression([int minPrecedence = 0])

Das ist der wichtigste Teil.

🔹 Schritt 1: Linke Seite parsen
var left = _parsePrimary();

Zuerst wird ein einzelner Wert geparst:

Zahl

String

Funktionsaufruf

Klammerausdruck

Unärer Operator

Beispiel:

3 + 4 * 2
↑

left = 3

🔹 Schritt 2: Solange ein passender Operator folgt
while (true) {
  final token = _peek();

Hier wird geprüft:

Ist das nächste Token ein Operator?

Ist es ein BinaryOperator?

Hat er genügend Priorität?

Operator-Typ prüfen
if (token.type != TokenType.operator) break;

Falls kein Operator → Ausdruck beendet.

Operator-Objekt erzeugen
final operator = SyntaxOperator.fromSymbol(token.value);

Hier wird z.B. "+" in ein BinaryOperator-Objekt umgewandelt.

Sicherstellen, dass es ein binärer Operator ist
if (operator is! BinaryOperator) break;

Falls es ein unärer Operator ist → nicht hier behandeln.

Priorität prüfen
if (operator.precedence < minPrecedence) break;

Das ist der Kern von Precedence Climbing.

Beispiel:

3 + 4 * 2

+ hat niedrigere Priorität als *, also wird 4 * 2 zuerst berechnet.

🔹 Schritt 3: Operator konsumieren
_advance();

Operator wird verbraucht.

🔹 Schritt 4: Neue Mindestpriorität bestimmen
final nextMinPrecedence =
    operator.associativity == Associativity.left
        ? operator.precedence + 1
        : operator.precedence;
Warum das?

Für linksassoziative Operatoren (z.B. +, -):

3 - 2 - 1

Wird interpretiert als:

(3 - 2) - 1

Deshalb: precedence + 1

Für rechtsassoziative Operatoren (z.B. Potenz ^):

2 ^ 3 ^ 2

Wird interpretiert als:

2 ^ (3 ^ 2)

Deshalb: gleiche Priorität.

🔹 Schritt 5: Rechte Seite parsen
final right = _parseExpression(nextMinPrecedence);

Jetzt wird rekursiv weitergeparst.

🔹 Schritt 6: AST-Knoten erzeugen
left = BinaryExpression(
  operator: operator,
  leftOperand: left,
  rightOperand: right
);

Jetzt wird ein neuer Syntaxbaum-Knoten gebaut.

Danach geht die Schleife weiter.

3️⃣ Primary Parsing
SyntaxExpression _parsePrimary()

Hier werden einzelne Elemente verarbeitet.

🔹 Token holen
final token = _advance();

Nächstes Token wird verbraucht.

🔹 Zahlen & Strings
case TokenType.number:
case TokenType.string:
  return SyntaxExpression.fromToken(token);

Einfacher Leaf-Knoten im Syntaxbaum.

🔹 Funktionen
case TokenType.functionIdentifier:
  return _parseFunction(token);

Beispiel:

sin(5)

Geht in _parseFunction.

🔹 Unäre Operatoren
case TokenType.operator:

Hier wird geprüft:

if (operator is UnaryOperator)

Beispiel:

-5

Dann wird:

final operand = _parseExpression(operator.precedence);

Wichtig: mit passender Priorität.

Ergebnis:

UnaryExpression(operator: -, operand: 5)
🔹 Klammern
case TokenType.openingParenthesis:

Ausdruck innerhalb parsen

Schließende Klammer erwarten

_consume(TokenType.closingParenthesis);
4️⃣ Funktionsparser
FunctionExpression _parseFunction(Token identifierToken)

Beispiel:

max(3, 5)
🔹 Öffnende Klammer prüfen
_consume(TokenType.openingParenthesis);

Fehlt sie → Exception.

🔹 Parameterliste
if (!_check(TokenType.closingParenthesis)) {
  do {
    params.add(_parseExpression());
  } while (_match(TokenType.functionParameterSeperator));
}

Das bedeutet:

Solange Kommas kommen → weitere Parameter

Jeder Parameter ist wieder ein vollständiger Ausdruck

🔹 Schließende Klammer prüfen
_consume(TokenType.closingParenthesis);
🔹 AST-Knoten erzeugen
return FunctionExpression(
  identifier: identifierToken.value,
  parameter: params
);
5️⃣ Hilfsmethoden
_peek()
Token _peek() => tokens[pos];

Schaut nur — verbraucht nichts.

_advance()
Token _advance()

Verbraucht ein Token und erhöht pos.

_check()
bool _check(TokenType type)

Prüft Token-Typ ohne zu konsumieren.

_match()
bool _match(TokenType type)

Wenn Typ passt → konsumieren und true.

_consume()
void _consume(TokenType type)

Erzwingt ein bestimmtes Token.
Falls falsch → Exception.

🧠 Beispiel-Durchlauf

Input:

3 + 4 * 2

Ablauf:

_parsePrimary() → 3

Operator +

Rechte Seite wird mit höherer Mindestpriorität geparst

_parsePrimary() → 4

Operator *

Rechte Seite → 2

4 * 2 wird zuerst gebaut

Dann 3 + (4 * 2)

🎯 Was für ein Parser ist das?

Das ist:

✅ Recursive Descent

✅ Precedence Climbing

✅ Pratt-ähnlicher Stil

✅ AST Builder

Sehr sauber strukturiert 👍

🚀 Fazit

Dein Parser:

Ist korrekt für arithmetische Ausdrücke

Unterstützt Unär + Binär

Unterstützt Funktionen

Unterstützt Assoziativität

Ist erweiterbar (z.B. für Variablen, Ternary etc.)