# How to style your code

## Required

- ✅Struct constructors (functions that return a struct) should always use `PascalCase`.
  - This prevents possible overlaps with variable names, which can cause errors with the YYC compiler.
- ❌Variable names, function names, etc., should never use `PascalCase`.

## Recommended

### Files

- ✅Follow the general GameMaker convention of using type prefixes in file names (`scr_`, `spr_`, etc.), unless stated otherwise below.
- ❌Don't add `scr_` for constructor files.
- ✅Instead name such files as the main class inside (i.e. `CoolConstructor.gml`).
- ❌Don't create a separate file for every single small script (`scr_format_string`).
- ✅Instead store scripts in library-like files (`scr_string_functions.gml`, `scr_array_functions.gml`, etc).

### Variable names

All variable names, function names, etc., should use `snake_case` unless stated otherwise.

**Local Variables**:
- Recommended to have a `_` prefix.
  - Ease readability.
  - Prevent namespace clashes with instance variables and scripts.
  - Not required for loop indices (e.g., `for (var i = 0; i < count; i++) { ... }`).
- Example: `var _player_health`.

**Instance Variables**:
- No special rules, aside from `snake_case`. For now.
- Names may overlap with scripts, be careful.

**Global Variables**:
- Require no additional prefix, as they already use `global.`.
- Example: `global.example_e1`.

### Functions

**Scripts and Methods**:
- Use at least two words (`draw_something()` vs `draw()`). To avoid overlap with simple instance variables.
- Name them as actions where possible (`create_green_apple()` vs. `green_apple()`).
- Preferably have a group prefix at the start (`string_convert`, `fleet_explode`).
- As scripts are global in scope, be wary of namespace collisions with absolutely everything in the project (fun).
- For string interpolation choose one of these methods: 
  - For general use - [template strings](https://manual.gamemaker.io/beta/en/index.htm#t=GameMaker_Language%2FGML_Reference%2FStrings%2FStrings.htm) (`$"text {variable}"`), as they are easier to read, less typo-prone and convert `{variables}` to strings automatically.
  - For edge cases, when you need to prepare a string with placeholders, and later use with different variables, - [string()](https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Reference/Strings/string.htm) function (`string("text {0}", value_to_insert)`).
  - ❌Don't use `string(var) + string(var2)` unless you know what you're doing.

### Constants

**Macros**:
- Written in all caps `SNAKE_CASE`.
- Try to denote their group using a short prefix (e.g., `PREFIX_`).
- Example: `#macro COL_DARK_RED`.

**Enums**:
 - Written in all caps `SNAKE_CASE`.
 - The name should start with an `e` prefix.
 - Example: `enum eCOLORS` with entries `DARK_RED`, `BLUE`, etc.

### Architecture and Logic

- Maintain high spatial locality. Keep logic within the most relevant scope. Favor methods over global scripts when the logic only pertains to that data structure.
- Initialize variables when declaring them (`var variable = 0`).
- Precalculate array length for loops (`for (var i = 0, l = array_length(array); i < l; i++)`).

### JSDocs

- Functions: Every function and method should have `@param` and `@returns` (optionally `@desc`) for Feather compliance.
- Type Hinting: Complex variable types should use `@type` during declaration (`@type {Array<Array<Struct.TTRPG_stats>>}`).

### General Styling (Unsolvable by Gobo)

- Declare each variable on a new line, avoiding `var n1 = 0, n2 = 2...`.
- Use `++`/`--` instead of `+=1`/`-=1`.
- Use `??`, `??=`, and ternary operators for concise null-coalescing and assignments.

### Formatter/Linter

A solid GameMaker-specific formatter, that formats most of the elements that can get untidy, is [Gobo (EttyKitty fork)](https://ettykitty.github.io/Gobo/).
- This is a fork made by EttyKitty. Default settings comply with what is expected in this project, with the addition of some nice new ones.
- Vertical arrays is an optional toggle, enable/disable it as you see fit. This formats array literals with each element on a new line for improved readability.

### General Styling (Solvable by Gobo)

- Use `&&` and `||` instead of `and` and `or`.
- Indentation should be 4 spaces (avoid tabs).
- End simple statements with semicolons.
- Use parentheses to clarify conditions with mixed operators, ensuring consistent behavior across platforms.
  - Example (recommended for mixed operators): `if ((condition1 && condition2) || (condition3 && condition4))`
  - Simple sequences of the same operator (like `&&` alone) don’t need extra parentheses: `if (condition1 && condition2 && condition3)`
  - Avoid wrapping each condition individually when using the same operator: `if ((condition1) && (condition2) && (condition3))`
