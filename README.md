# Kappa → C Transpiler (Flex/Bison)

University project for **PΛH 402 – Theory of Computation focused on the first stages of compilation:
**lexical analysis** and **syntax analysis**, for the fictional language **Kappa**.

The compiler is implemented as a **source-to-source compiler (transpiler)**:
it reads a `.ka` program written in Kappa and produces equivalent **C99** code.  
(See the full specification in `theory2023s-project-v1.pdf`.)

## What it includes
- **Lexer (Flex)**: tokenizes Kappa source code (identifiers, keywords, literals, operators, comments, etc.)
- **Parser (Bison)**: validates syntax based on Kappa grammar
- **Code generation**: emits equivalent **C99** source code for valid programs
- **Sample programs**:
  - `correct1.ka`, `correct2.ka` (Kappa inputs)
  - `correct1.c`, `correct2.c` (expected / generated C outputs)

## Repository contents
- `mylexer.l` — Flex lexer
- `myanalyzer.y` — Bison parser (with semantic actions for translation)
- `cgen.c`, `cgen.h` — C code generation helpers
- `kappalib.h` / `thlib.h` — support library header used by generated C code
- `makefile` — build automation
- `theory2023s-project-v1.pdf` — assignment specification

## Tech stack
- **Language:** C
- **Tools:** Flex, Bison, GCC
- **Environment:** Linux
