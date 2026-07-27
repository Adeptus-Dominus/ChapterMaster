# Code Style and Formatting

## Formatting

### Formatter/Linter

A solid GameMaker-specific formatter, that formats most of the elements that can get untidy, is [GoboCat](https://github.com/EttyKitty/GoboCat). Project's root has a config with correct options.

### Rules

**Not Styled by Gobo**
- Declare each variable on a new line; not `var n1 = 0, n2 = 2...`.
- Use `++`/`--`; not `+=1`/`-=1`.

**Styled by Gobo**
- LF End of Line.
- Indentation should be 4 spaces (avoid tabs).
- No line wrap (refactor if too complex).
- Braces go on the same line.
- Files end with an empty line.
- Use `&&` and `||`; not of `and` and `or`.
- End simple statements with semicolons.
- Use parentheses to clarify conditions with mixed operators, ensuring consistent behavior across platforms.
- Simple sequences of the same operator (like `&&` alone) don’t need extra parentheses: `if (condition1 && condition2 && condition3)`
- Avoid wrapping each condition individually when using the same operator: `if ((condition1) && (condition2) && (condition3))`

## File Style Conventions

Follow the general GameMaker convention of using type prefixes in file names (`scr_`, `spr_`, etc.), unless stated otherwise below.

### Scripts

- Don't create a separate file for every single small script (`scr_format_string`).
- Instead store scripts in library-like files (`scr_string_functions.gml`, `scr_array_functions.gml`, etc).

### Constructors

1. Don't add `scr_` for files with a constructor.
2. Name such files as the main `constructor` inside (i.e. `CoolConstructor.gml`).
3. Keep a single `constructor` per file, unless other `constructors` or `functions` in the file are never referenced from outside.

## Code Style Convention

All variable names, function names, etc., should use `snake_case` unless stated otherwise.

### Local Variables (`var`)

1. `_` prefix; Exception: loop indices (e.g., `var i` is allowed)
  - Ease readability.
  - Prevent namespace clashes with instance variables and scripts.
  - Not required for loop indices (e.g., `var i`).

Example: `var _player_health;`

### Instance Variables

**Public** (default)
1. No rules, as such names may overlap with global scripts, be careful.

**Private:** (shouldn't be read or mutated from outside the constructor/object)
1. `__` prefix

Example: `__sound_cache = {};`

**Constant** (doesn't change at runtime; used instead of `#macro` when isn't accessed externaly)
1. `CAPS_SNAKE_CASE`

Example: `DEFAULT_CROSSFADE_MS = 2000;`

### Global Variables (`global.`)

De-facto, these are instance variables of the `global` object.

1. No rules for now.

Example: `global.game_version = 1.0;`.

### Macros (`#macro`)

1. `CAPS_SNAKE_CASE`
2. Optional short group prefix (e.g., `SFX_`)

Example: `#macro SFX_CLICK "click"`.

### Enums (`enum`)

1. `CAPS_SNAKE_CASE`
2. Prefixed with an `e`

Example: `enum eCOLORS` with entries `DARK_RED`, `BLUE`

### Constructor Functions (`constructor`)

1. `PascalCase`.

### Scripts and Methods (`function`)

As scripts are global in scope, be wary of namespace collisions with absolutely everything in the project (fun).

1. Name them as actions where possible
2. Optional group prefix at the start

Examples: `create_green_apple()`, `string_convert()`, `fleet_destroy()`

### Function Arguments

1. Treat as **Local Variables**; all same rules

Example: `set_volume(_value)`

# Code Architecture Conventions

## JSDocs

**Functions:** Every function and method should have `@param` and `@returns`, optionally `@desc` if public, for Feather compliance.
**Type Hinting:** Use `@type` during declaration (`/// @type {Array<Array<Struct.TTRPG_stats>>}`); unions are supported.

## Maintainability

- **Prefer `constructor` over GameMaker objects or scripts** when the logic does not require built-in collision detection and is not a simple helper function.
- **Use clear, unabbreviated names** for variables, functions, and classes; avoid names like `x`, `tmp`, `fn`, `obj1`.
- **Avoid compact, cryptic expressions**. Nested ternary operators, chained logic, single‑letter variable names, or excessive inline functions. These obscure intent.
- **Avoid raw strings or numbers used as identifiers / constants more than once**. Replace them with `#macro` or `enum`. Exception: never use `#macro` for arrays. `#macro` expand inline, each usage creates a new array instance; use a static variable or a function that returns a static variable instead.
- **Maintain high spatial locality.** Keep logic within the most relevant scope. Favor constructor methods or object methods (declared in Create) over global scripts when the logic only pertains to that data structure.
- **Don’t repeat code fragments**. Abstract two or more near‑identical lines / blocks into a function or method.
- **Eliminate boilerplate**. Use global functions, lookups, static methods, or constructors to avoid repetitive code.
- **Limit nesting depth**. Functions or blocks should not contain too many nested structures (e.g., `if`/`else`, `for`/`while`, `try`/`catch`, `switch`). Refactor where posible; use early `return`/`exit` instead.

## Safety

- **Initialize variables to a value.** `var variable = 0`.
- **Don't type juggle variables.** If a variable is a `real`, keep it as a `real` or `undefined` throughout the entire codebase.
- **Undefined safety.** Use `??`, `??=`, and `? : ` for concise null-coalescing and assignments.
- **Implement fail‑loud patterns**. Use `try`/`catch`, `throw`, and `LOGGER.error("string")` in error‑prone code.

## Performance

- **Precalculate array length for loops in hotpaths.** `for (var i = 0, l = array_length(array); i < l; i++)` if the loop runs somewhere where speed matters.
- **Keep heavy logic (loops, allocations) out of Draw and Step events**. These events run every frame and can destroy performance.
- **Prefer `arrays` and `structs` over `ds_*` structures** (`ds_map`, `ds_list`, `ds_grid`, `ds_stack`, `ds_queue`). If you must use a `ds_*` structure, always pair it with a corresponding `ds_destroy` call to avoid memory leaks.

## String Interpolation

For string interpolation choose one of these methods:
- For general use - [template strings](https://manual.gamemaker.io/beta/en/index.htm#t=GameMaker_Language%2FGML_Reference%2FStrings%2FStrings.htm) (`$"text {variable}"`), as they are easier to read, less typo-prone and automatically handle type conversion.
- For edge cases, when you need to prepare a string with placeholders, and later use with different variables, - [string()](https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Reference/Strings/string.htm) function (`string("text {0}", value_to_insert)`).
- Don't use `string(var) + string(var2)` unless you know what you're doing.
