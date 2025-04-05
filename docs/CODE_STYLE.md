# How to style your code

## Required:
- Constructor names should always use `PascalCase`.\
  This prevents possible overlaps with variable names, which can cause errors with the YYC compiler.
- Variable names, function names, etc., should never use `PascalCase`.\
  The exception is for enum entries.

## Recommended:

### File names:
Follow the general GameMaker convention of using type prefixes in file names.

### Names:
All variable names, function names, etc., should use `snake_case` unless stated otherwise.

- **Local** variables are recommended to have a `_` prefix, which can ease readability, and prevent namespace clashes with instance variables and functions.
  - Example: `var _example_e1`.

- **Global** variables require no additional prefix, as they already use `global.`.
  - Example: `global.example_e1`.

- **Scripts and Methods** don’t need prefixes but should:
  - Use at least two words to avoid overlap with most instance variables (e.g., `draw_something()`).
  - Be named as actions where possible (`create_green_apple()` vs. `green_apple()`).
  - Preferably have a group prefix at the start (`string_convert`, `fleet_explode`).
  - As scripts are global in scope, be vary of namespace collision with absolutely everything in the project (fun).

- **Macro** constants:
  - To denote their group, use a short prefix in all caps (e.g., `PREFIX_`).
  - The rest should be in all caps `SNAKE_CASE`.
  - Example: `#macro COL_DARK_RED`.

- **Enum** constants:
  - Enum names should start with an `e` prefix and be in all caps.
  - Enum entries should use `PascalCase`.
  - Example: `enum eCOLORS` with entries `DarkRed`, `Blue`, etc.

### General Styling:
- Initialize variables when declaring them (`var variable = 0`).
- Declare each variable on a new line, avoiding `var variable1 = 0, variable2 = 2...` for readability.
- Use `&&` and `||` instead of `and` and `or` to ensure compatibility with JavaScript formatters.
- Indentation should be 4 spaces (avoid tabs).
- End simple statements with semicolons.
- For string interpolation choose one of these methods: 
  - For big strings - [template strings](https://manual.gamemaker.io/beta/en/index.htm#t=GameMaker_Language%2FGML_Reference%2FStrings%2FStrings.htm) (`$"text {variable}"`), as they are easier to read, less typo-prone and convert `{variables}` to strings automatically.
  - For small strings - [string()](https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Reference/Strings/string.htm) function (`string("text {0}", value_to_insert)`), as it may be easier to read in some cases.
- Use parentheses to clarify conditions with mixed `&&` and `||` operators, ensuring consistent behavior across platforms.
  - Example (recommended for mixed operators): `if ((condition1 && condition2) || (condition3 && condition4))`
  - Simple sequences of the same operator (like `&&` alone) don’t need extra parentheses: `if (condition1 && condition2 && condition3)`
  - Avoid wrapping each condition individually when using the same operator: `if ((condition1) && (condition2) && (condition3))`
- Use `++`/`--` instead of `+=1`/`-=1`.

### Formatters:
> [!WARNING]
> JavaScript formatters break `$"something {variable}"` syntax by adding a space after `$`. Manually correct this as needed.

- There is a great GameMaker tailored formatter, that formats most of the stuff that can get ugly, called [Gobo](https://github.com/Pizzaandy/Gobo/)
  - Disable tab indent and set it to 4 spaces.
  - Set max line width to something like 9999, to prevent condition checks from breaking into unreadable multiple lines.
  - The above step will format structs into a single line, so you'll have to use a JS formatter afterwards to fix this.
- You can use [this](https://beautifier.io/) JavaScript formatter to fix broken structs, with:
  - Indent with 4 spaces.
  - Allow unlimited newlines between tokens.
  - Don't wrap lines.
  - Spaces before conditional.
