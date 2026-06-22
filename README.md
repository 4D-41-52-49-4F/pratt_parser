# 🧠 Pratt Parser in Dart

## 📝 Introduction

After learning about parsing theory, I wanted to implement a **Pratt parser** (top-down operator precedence parser) from scratch — one of the most elegant algorithms for parsing expressions.

The core idea: instead of encoding grammar rules recursively, operators are assigned **precedence levels** and **associativity**, which the parser uses to decide how tightly an operator binds to its operands. This makes it easy to support complex expressions — arithmetic, logical, relational, ternary, assignments, member access, and function calls — all in a clean, extensible way.

Since this project is part of my apprenticeship, I also built a **global environment** around the parser, consisting of a variable store and a function registry, so expressions can actually be *evaluated* at runtime — not just parsed.

---

## 🛠️ Getting Started

To use this library, you need the **Dart SDK** installed and available in your PATH.

### 📦 Install Dependencies

```bash
dart pub get
```

### ✅ Run Tests

```bash
dart test
```

---

## 🏗️ Architecture

The project is split into two main subsystems.

---

### 1. 🔤 Syntax Parser

The core of the project. It transforms a raw expression string into an evaluable **syntax tree**.

---

#### 🔡 Lexer

The `Lexer` tokenizes the input string character by character, producing a flat list of `Token` objects. Each token has a `TokenType` and a `lexeme` (the raw string it was parsed from).

Supported token types:

- **Literals** — numeral (`42`, `3.14`), string (`"hello"`, `'world'`), boolean (`true`, `false`), null
- **Identifiers** — variable names and function names
- **Operators** — single-char (`+`, `-`, `*`, `/`, `%`, `^`, `<`, `>`, `=`, `!`, `?`, `:`, `.`) and multi-char (`==`, `!=`, `<=`, `>=`, `&&`, `||`, `++`, `--`, `+=`, `-=`, `*=`, `/=`)
- **Parentheses** — `(`, `)`, `[`, `]`, `{`, `}`
- **Comma** — `,` as a separator in function calls

---

#### ⚙️ Operators & Precedence

All operators are modeled as sealed class hierarchies with explicit `precedence` and `associativity`. The full precedence table (highest to lowest):

| Precedence | Operators | Type |
|---|---|---|
| 10 | `.` | Member access |
| 9 | `!`, `-` (unary), `++`, `--` | Unary |
| 8 | `^` | Exponent (right-assoc) |
| 7 | `*`, `/`, `%` | Multiplicative |
| 6 | `+`, `-` | Additive |
| 5 | `<`, `<=`, `>`, `>=` | Relational |
| 4 | `==`, `!=` | Equality |
| 3 | `&&` | Logical AND |
| 2 | `\|\|` | Logical OR |
| 1 | `?` `:` | Ternary |
| 0 | `=`, `+=`, `-=`, `*=`, `/=` | Assignment (right-assoc) |

---

#### 🌳 AST (Abstract Syntax Tree)

The `SyntaxParser` produces a tree of `SyntaxExpression` nodes. Each node knows how to `evaluate()` itself:

- **`SyntaxLiteral<T>`** — a raw value (string, num, bool, null)
- **`VariableExpression`** — looks up an identifier in the `VariableEnvironment`
- **`AssignmentExpression`** — assigns (or compound-assigns) a value to a variable
- **`UnaryExpression`** — applies a unary operator (`!`, `-`, `++`, `--`) to one operand
- **`BinaryExpression`** — applies a binary operator to two operands
- **`TernaryExpression`** — evaluates `condition ? trueCase : falseCase`
- **`FunctionExpression`** — resolves and calls a function from the `FunctionRegistry`
- **`MemberExpression`** — accesses a property on an object (`obj.property` or `obj.method(...)`)

Type validation happens at evaluation time through a dedicated `_ExpressionValidator`, which throws typed exceptions (e.g. `_ArithmeticException`, `_LogicalException`) for invalid operand combinations.

---

### 2. 🌐 Global Environment

The runtime environment that expressions are evaluated against.

---

#### 📦 VariableEnvironment

A static key-value store for variables. Supports adding, updating, and reading values by name. Assignment expressions write into this environment; variable expressions read from it.

```dart
VariableEnvironment.addOrUpdateVariable('x', 42);
VariableEnvironment.getValue('x'); // 42
```

---

#### 🔧 FunctionRegistry

A static registry that maps function names to `RuntimeFunction` implementations (`dynamic Function(List<dynamic> args)`). Functions must be registered before they can be called in an expression.

```dart
FunctionRegistry.register('abs', (args) => (args[0] as num).abs());
FunctionRegistry.registerAliases(['min', 'minimum'], (args) => ...);
```

---

## 📁 Project Structure

```
pratt_parser/
├── lib/
│   ├── main.dart                          # Public exports
│   └── src/
│       └── models/
│           ├── global_environment/
│           │   ├── _function_registry/    # FunctionRegistry
│           │   └── _variable_environment/ # VariableEnvironment
│           └── syntax_parser/
│               ├── _syntax_elements/
│               │   ├── expressions/       # AST node types
│               │   └── operator/          # Operator hierarchy & precedence
│               ├── lexer.dart             # Tokenizer
│               └── syntax_parser.dart     # Pratt parser
├── test/
│   ├── global_environment_tests/          # VariableEnvironment & FunctionRegistry tests
│   └── syntax_parser_tests/              # Lexer, parser & expression tests
├── pubspec.yaml
└── CHANGELOG.md
```

---

## 🚀 Planned Features

- **Postfix `++`/`--`** — currently `++`/`--` are parsed as prefix operators; postfix support would require a different parsing strategy
- **String concatenation** — extend `AdditionOperator` to support `"hello" + " world"`
- **Null safety operator** — `??` as a fallback for null values
- **Block expressions** — support for multiple statements / sequencing
