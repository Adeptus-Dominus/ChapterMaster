# GameMaker Language (GML) Guide

This guide covers the language for developers familiar with JavaScript or other C-family languages.

---

## Table of Contents

- [Syntax Basics](#syntax-basics)
- [Variables and Scope](#variables-and-scope)
- [Functions](#functions)
- [Constructors](#constructors)
- [Methods](#methods)
- [Data Structures and Accessors](#data-structures-and-accessors)
- [Keywords](#keywords)
- [Constants and Macros](#constants-and-macros)
- [Built-in Functions](#built-in-functions)
- [Assets](#assets)
- [Comparison: GML vs JavaScript](#comparison-gml-vs-javascript)

---

## Syntax Basics

GameMaker Language (GML) is syntactically similar to JavaScript ES3 but has significant differences.

### Comments

```gml
// Single-line comment
/* Multi-line comment */

/// GML JSDoc uses triple-slash single-line comments, not /** */
/// @param {real} value
/// @returns {bool}
```

### Naming

- Alphanumeric characters and underscores only; first character must not be numeric.
- Names are globally scoped for functions, scripts, assets.
- Built-ins are almost always `snake_case`.

### Data Types

| Type | Notes |
|---|---|
| `real` | All numeric values (integers and floats). |
| `boolean` | `true` / `false` constants. Internally stored as `real` (values <= 0.5 are `false`, > 0.5 are `true`). Convert with `bool(x)`. |
| `string` | Double quotes **only** (`"text"`, not `'text'`). Positions are **1-indexed** (unlike arrays). |
| `array` | 0-indexed by default. 1-indexed is an optional project-wide setting. |
| `struct` | Key-value data structure (~ JS `Object`). |
| `function` / `method` | First-class; can be stored in variables and passed as arguments. |
| `int64` | 64-bit integer, used for bitwise results and handles. |
| `pointer` | Memory address; used only in specific native-function contexts (`buffer_get_address`, etc.). |
| `handle` | 64-bit reference to assets, instances, buffers, data structures, etc. |


### Built-in Constants & Special Values

GML provides several built-in constants. Some act as special data type values, while others act as sentinels for instances and contexts.

| Value | Category | Notes |
|---|---|---|
| `true` / `false` | Boolean | Resolves to `1` and `0`. |
| `undefined` | Special Value | Uninitialised variable value. Falsy. |
| `NaN` | Special Value | Not-a-number. Not equal to itself (`NaN == NaN` -> `false`). |
| `infinity` | Special Value | Positive infinity (all lower-case). |
| `pi` | Math Constant | 3.14159... |
| `pointer_null` | Pointer | Null pointer (~ JS `null`). Falsy. |
| `pointer_invalid` | Pointer | Invalid pointer sentinel. |
| `noone` | Instance Sentinel | "No instance" (legacy value: `-4`). Returned by collision/instance functions when nothing is found. |
| `all` | Instance Sentinel | "All instances" (legacy value: `-3`). Used in `with()` or instance functions to target everything. |
| `self` | Context | Current context struct/instance (legacy value: `-1`). |
| `other` | Context | Other context (event-triggering instance, legacy: `-2`). |
| `global` | Context | The global struct. |

### Operators

**Standard:** `+`, `-`, `*`, `/`, `%` (`mod`), `div` (integer division), `&&` (`and`), `||` (`or`), `^^` (`xor`), `!` (`not`).

**Ternary:** `condition ? true_val : false_val`

**Comparison:** `<`, `>`, `<=`, `>=`, `==`, `!=`

**Nullish coalescing:** `??`, with assignment `??=`

**Bitwise:** `|`, `&`, `^`, `<<`, `>>`

**Compound assignment:** `+=`, `-=`, `*=`, `/=`, `|=`, `&=`, `^=`, `??=`

**Literal prefixes:**
- Binary: `0b10` -> `2`
- Hex: `0x001122` or `$001122`

### String Interpolation

```gml
$"Hello {name}"                           // Template string
string("text {0} and {1}", a, b)          // Deferred placeholder substitution
```

**Note:** String character positions are **1-indexed** (`string_char_at(s, 1)` gets the first character), while arrays are 0-indexed.

---

## Variables and Scope

### Variable Kinds

Resolution order: **local -> instance -> global -> built-in**.

| Kind | Declaration | Scope |
|---|---|---|
| **Local** | `var x = 0;` | Current function/event body only. |
| **Instance** | No keyword, e.g. `health = 100;` | The current instance/struct (`self`). |
| **Global** | `global.variable` | Entire game. |
| **Constant** | `#macro`, `enum`, or literal | Compile-time replacement / named value. |

### Block Scoping

`var` is scoped to the **function body**, not to individual blocks. Control-flow constructs (`if`, `for`, `switch`, `try`) do **not** create a new local scope.

```gml
function example() {
    for (var i = 0; i < 10; i++) {
        var _inner = i;
    }
    // _inner is accessible here! (unlike JS let)
}
```

Only function bodies introduce a new local scope.

### Symbol Categories

Beyond the four scopes, symbols fall into three conceptual categories:

| Category | Description |
|---|---|
| **Local** | Ephemeral, scoped to a function/event. |
| **Self** | Members of a data structure (global, object instance, struct instance). |
| **Independent** | Globally available but not a member of any struct - enums, macros, asset IDs, built-in function identifiers. |

### `self` Context Changes

`self` (~ JS `this`) changes depending on context:

- **Struct literal body** -> `self` is the struct being defined.
- **Function body** -> `self` is the instance/struct the function was called on or bound to.
- **`with` statement** -> `self` becomes the argument's value for the block duration.
- **Accessor chain** -> `self` implicitly follows the accessed value.

```gml
with (obj_player) {
    x += 10;  // self is obj_player instance
}
```

Instance variables written without `self.` are implicitly on `self`. Undefined variables return `undefined` (access produces no error, but using the value may).

---

## Functions

### Declaration

```gml
// Named function (hoisted in Script assets)
function do_something(_arg1, _arg2) {
    return _arg1 + _arg2;
}

// Anonymous function
var _fn = function(_x) { return _x * 2; };
```

### Default Arguments

```gml
function greet(_name = "Unknown") {
    return $"Hello {_name}";
}
```

### Hoisting

Functions defined at the top level of **Script** assets are hoisted during boot (`ScriptPrepare()`) before any script statements execute. Cross-script circular references work. Functions defined inside Objects or nested blocks are **not** hoisted.

### Returning

- `return` exits the function and returns a value.
- `exit` exits the current event or script immediately without a value.

### Static Struct

Every function has an associated static struct for function-level persistent variables:

```gml
function counter() {
    static _count = 0;   // Initialised once, persists across calls
    _count++;
    return _count;
}
```

Retrieve/overwrite with `static_get(function)` / `static_set(function, struct)`.

---

## Constructors

GML uses **constructor functions** with the `constructor` keyword instead of JS classes. Called with `new`.

```gml
function Marine(_name, _chapter) constructor {
    name = _name;
    chapter = _chapter;

    static greet = function() {
        return $"For the {chapter}!";
    };
}

var _marine = new Marine("Brother Cassius", "Ultramarines");
```

- Inside a constructor, `self` refers to the struct being created.
- Constructor functions are globally available like any script function.

---

## Methods

A **method** binds a function to a specific context so `self` inside the function refers to that context.

```gml
var _bound = method(_context, function() {
    return self.some_value;
});
```

**Behaviour:**

- Methods share the **static struct** of the original function they were created from. Chaining `method()` on a method still shares the original function's static struct.
- `static_get(the_method)` returns the **actual** static struct of the function behind the method (not a copy).
- `static_set(the_method, struct)` has **no effect** - the static struct of the function behind a method cannot be replaced.
- Variables attached directly to a method via `.` accessor (e.g. `_bound.tag = "x"`) are stored opaquely - not in the static struct.
- Use `self` inside a method to reference the bound context.

---

## Data Structures and Accessors

### Arrays

```gml
var _arr = [10, 20, 30];
_arr[0] = 25;           // 0-based indexing (default)
_arr[1] = 35;
array_push(_arr, 40);   // Push to end
```

No `.length` property - use `array_length(_arr)`.

**Copy on Write:** This project has `option_copy_on_write_enabled: true`. When an array is passed into a function, modifying it inside the function creates a temporary copy unless the `@` accessor is used:
```gml
function modify(_arr) {
    _arr[@ 1] = 200;    // Bypasses CoW, modifies original
}
```
With CoW enabled, use `@` to modify arrays in-place inside functions, or return the modified copy.

### Structs

```gml
var _s = { name: "Cassius", hp: 100 };

_s.name;              // Dot accessor
_s[$ "name"];         // Struct accessor (bracket with $)
```

### Legacy DS Structures

| Type | Accessor | Creation | Notes |
|---|---|---|---|
| `ds_list` | `[| index]` | `ds_list_create()` | Manual `ds_destroy()` required |
| `ds_map` | `[? key]` | `ds_map_create()` | Manual `ds_destroy()` required |
| `ds_grid` | `[# x, y]` | `ds_grid_create(w, h)` | Manual `ds_destroy()` required |

DS structures must be manually destroyed or they leak memory. GML documentation recommends arrays and structs instead, where possible.

---

## Keywords

Complete GML keyword list:

```
and             begin           break           case
catch           constructor     continue        default
delete          div             do              else
end             enum            exit            for
function        global          globalvar       if
mod             new             not             or
repeat          return          static          switch
then            throw           try             until
var             while           with            xor
```

- `begin`/`end` are alternative tokens for `{`/`}`.
- `and`, `or`, `not`, `xor`, `mod`, `div` are keyword operators.
- `globalvar` is deprecated; use `global.` instead.
- `delete` de-references a struct, flagging it for garbage collection. Does **not** remove individual fields or array entries.
- `repeat (n) { ... }` executes the block `n` times.
- `do { ... } until (condition)` - note `until`, not `while`.
- `switch` in GML **has fallthrough** (like C/JS). Each `case` must end with an explicit `break` unless you intentionally want to fall through to the next case.
- `with (expr) { ... }` changes `self` to the given expression.

### Preprocessor Directives

```
#macro      #region     #endregion
```

- `#region` / `#endregion` create code-folding blocks in the IDE.
- `#macro NAME value` - compile-time textual replacement. Can span lines with trailing `\`.

---

## Constants and Macros

### Enums

```gml
enum COLORS {
    DARK_RED,
    BLUE,
    GREEN
}
```

Values start at 0 and auto-increment.

### Macros

```gml
#macro SFX_CLICK "click_sound.wav"
#macro MAX_HP 100
```

- Compile-time textual replacement.
- **Do not** use `#macro` for arrays - each reference creates a new array instance.

---

## Built-in Functions

Primitives have no internal methods; use library functions instead.

**Strings:**
`string_length`, `string_copy`, `string_pos`, `string_repeat`, `string_upper`, `string_lower`, `string_hash_to_newline`, `string_delete`, `string_insert`, `string_replace`, `string_count`

**Arrays:**
`array_length`, `array_push`, `array_pop`, `array_sort`, `array_shift`, `array_unshift`, `array_resize`, `array_copy`, `array_create`, `array_equals`, `array_filter`, `array_map`, `array_reduce`, `array_find`

**Math:**
`min`, `max`, `abs`, `round`, `floor`, `ceil`, `clamp`, `lerp`, `sin`, `cos`, `tan`, `darcsin`, `darccos`, `darctan`, `point_distance`, `point_direction`, `random`, `irandom`, `random_range`, `irandom_range`

**Type checking/conversion:**
`typeof(x)` (function, not operator), `is_instanceof(x, Constructor)` (checks inheritance chain), `instanceof(x)` (gets the constructor used to create a struct), `bool(x)`, `is_array(x)`, `is_bool(x)`, `is_string(x)`, `is_numeric(x)`, `is_struct(x)`, `is_undefined(x)`, `is_ptr(x)`, `is_int32(x)`, `is_int64(x)`, `is_handle(x)`.

---

## Assets

GameMaker projects consist of globally referenceable assets. The primary code-carrying assets:

### Scripts

- Named `.gml` files under `scripts/` in the project.
- Functions and enums defined at the top level are **globally available** - no import/export statements.
- Loaded early in boot; function definitions are hoisted before any script statements execute.

### Objects

- Class-like assets from which **Instances** are created at runtime.
- Have **events** (Create, Step, Draw, Alarm, etc.) where code runs.
- Objects have built-in instance variables (`x`, `y`, `speed`, `direction`, `image_index`, etc.).

---

## Comparison: GML vs JavaScript

| GML | JavaScript |
|---|---|
| `self` | `this` |
| `struct` | `object` / `{}` |
| `real` | `number` |
| `bool` values are `real` (1/0) | distinct `boolean` type |
| `pointer_null` | `null` |
| `infinity` | `Infinity` |
| `typeof(x)` - function | `typeof x` - operator |
| `instanceof(x, y)` - function | `x instanceof y` - operator |
| `///` JSDoc | `/** */` JSDoc |
| `function ... constructor` + `new` | `class` |
| `var` only | `var`, `let`, `const` |
| Block scoping: function-level only | Block scoping with `let`/`const` |
| `#macro` for compile-time constants | No preprocessor |
| `array_length(a)`, `string_length(s)` | `a.length`, `s.length` |
| `struct[$ "key"]` | `obj["key"]` |
| `^^` - logical XOR | `^` - bitwise XOR only |
| `$` hex prefix | `0x` hex prefix |
| `switch` - fallthrough (uses `break`) | `switch` - fallthrough (uses `break`) |
| `do...until(condition)` | `do...while(condition)` |
| `repeat(n) { }` | no equivalent |
| 0-based array indexing (default) | 0-based array indexing |
