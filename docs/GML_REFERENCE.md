# GameMaker Language (GML) Reference

This guide covers the language for developers familiar with JavaScript or other C-family languages.

GameMaker Language (GML) is syntactically similar to JavaScript ES3 but has significant differences.

---

## Table of Contents

- [Quick Comparison: GML vs JavaScript](#comparison-gml-vs-javascript)
- [Asset Types](#asset-types)
- [Syntax Basics](#syntax-basics)
- [Variable Scope](#variable-scope)
- [Variable Categories](#variable-categories)
- [Functions](#functions)
- [Constructors](#constructors)
- [Methods and Binding](#methods-and-binding)
- [Data Structures and Accessors](#data-structures-and-accessors)
- [Constants and Macros](#constants-and-macros)
- [Built-in Functions List](#built-in-functions-list)
- [Keywords List](#keywords-list)

---

## Comparison: GML vs JavaScript

| JavaScript | GML |
|---|---|
| `this` | `self` |
| `object` / `{}` | `struct` |
| `number` | `real` |
| distinct `boolean` type | `bool` values are `real` (1/0) |
| `null` | `pointer_null` |
| `Infinity` | `infinity` |
| `typeof x` - operator | `typeof(x)` - function |
| `x instanceof y` - operator | `instanceof(x, y)` - function |
| `/** */` JSDoc | `///` JSDoc |
| `class` | `function ... constructor` + `new` |
| `var`, `let`, `const` | `var` only |
| Block scoping with `let`/`const` | Function-level only |
| No preprocessor | `#macro` for compile-time constants |
| `a.length`, `s.length` | `array_length(a)`, `string_length(s)` |
| `obj["key"]` | `struct[$ "key"]` |
| `^` - bitwise XOR only | `^^` - logical XOR |
| `0x` hex prefix | `$` hex prefix |
| `switch` - fallthrough (uses `break`) | `switch` - fallthrough (uses `break`) |
| `do...while(condition)` | `do...until(condition)` |
| no equivalent | `repeat(n) { }` |

---

## Asset Types

GameMaker projects consist of globally referenceable assets.

The primary code-carrying assets:

### Scripts

- Functions and enums defined at the top level are **globally available** - no import/export statements.
- Loaded early in boot; function definitions are hoisted before any script statements execute.

### Objects

Objects in GameMaker are **blueprints** (similar to JavaScript classes) from which **Instances** are spawned at runtime. Each Object asset defines:

- **Events** - a set of named code blocks that the engine calls automatically under specific conditions. Think of them as predefined lifecycle methods that GameMaker's runtime invokes for you:
  - `Create` - runs once when an instance is first created (like a constructor).
  - `Step` - runs every frame (like an `update()` loop).
  - `Draw` - runs every frame when the instance is visible (like a `render()` method).
  - `Alarm` - timed callbacks, set with `alarm[0] = steps;`.
  - Collision events, Input events, etc. - triggered by engine‑detected interactions.
- **Built‑in Instance Variables** - every Object comes with a rich set of default fields (e.g., `x`, `y`, `speed`, `direction`, `image_index`, `visible`, `solid`). These are analogous to predefined properties on a class that the engine uses for movement, rendering, and collision.
- **Inheritance** - Objects can have a **Parent** Object. A child inherits all events and instance variables from its parent, and can override them by defining its own events. The child's events can call the parent's version with `event_inherited()`.

---

## Syntax Basics

### Comments

```gml
// Single-line comment
/* Multi-line comment */

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

- **Standard:** `+`, `++`, `-`, `--`, `*`, `/`, `%` (`mod`), `div` (integer division), `&&` (`and`), `||` (`or`), `^^` (`xor`), `!` (`not`).
- **Ternary:** `condition ? true_val : false_val`
- **Comparison:** `<`, `>`, `<=`, `>=`, `==`, `!=`
- **Nullish coalescing:** `??`, with assignment `??=`
- **Bitwise:** `|`, `&`, `^`, `<<`, `>>`
- **Compound assignment:** `+=`, `-=`, `*=`, `/=`, `|=`, `&=`, `^=`, `??=`
- **Literal prefixes:**
  - Binary: `0b10` -> `2`
  - Hex: `0x001122` or `$001122`

### String Interpolation

```gml
$"Hello {name}" // Template string
string("text {0} and {1}", a, b) // Deferred placeholder substitution
```

---

## Variable Scope

GML has three primary runtime scopes. At runtime, variable names are resolved in this order (the first match overshadows):
1. **local**
2. **instance**
3. **global**
4. **built-in**

### Local Scope

- Bound to the current function body or event.
- Control-flow blocks (`if`, `for`, `switch`, `try`) do **not** create a new local scope.

### Instance Scope

- Bound to the executing object instance or struct.

**Context Keywords: `self` and `other`**

GML uses `self` and `other` to manage scope dynamically.

`self` is the GML equivalent of `this` in JavaScript, referring to the **current scope** of the code being executed.

`other` refers to the **previous scope** before `self` was changed. 

Their behavior is context-dependent:

| Context | `self` refers to... | `other` refers to... |
|---|---|---|
| **Collision Event** | The current instance. | The other instance involved in the collision. |
| **`with` statement** | The instance or struct passed to `with`. | The instance or struct that executed the `with` block. |
| **Method / Constructor** | The instance or struct the function is bound to or called on. | The caller of the method/constructor (not the bound context). |
| **Struct literal body** | The struct being defined. | Usually the same as `self`. |
| **Accessor chain** | Implicitly follows the accessed value. | Usually the same as `self`. |
| **Elsewhere** | The current instance or struct. | Usually the same as `self`. |

### Global Scope

- Global functions (scripts), `global.` struct, and `enums` are accessible from anywhere in the code.

---

## Variable Categories

While scope defines *where* a variable can be accessed, GML features distinct categories of variables based on how they are initialized and stored.

### Local

- Declared with `var`.
- Scoped to the **function or event body**, not to individual blocks.
- Exists only during the current function or event execution.

### Instance

- Declared without a keyword (e.g., `hp = 100;`) or via context (`self.hp = 100;`).
- Bound to the lifetime of the specific instance or struct.

### Static

- **Initialized Once** on the first function (`constructor` functions included) call and stored in the function's static struct.
- **Persists** across calls without polluting instance memory.
- **Hoisting:** Initializers run at the top of the function body before any standard code executes.
- **External Access:** Accessible via `function_name.variable`, but the function **must execute at least once** first to instantiate its static struct.
- **Inheritance:** Reading traverses child-to-parent static structs. Writing via a child constructor assigns directly to the child static struct without modifying the parent.

### Global

- Declared on the `global` struct (e.g., `global.score = 0;`).
- Accessible from anywhere.
- The `global` struct acts as a de facto application singleton.

### Constant

- **Enums:** Named integer constants.

### Compile-Time

Not true variables in the runtime memory sense, but named values resolved at compile-time. They are globally available and not tied to any struct.

- **Macros:** Compile-time textual replacement. Do not use for arrays; each reference creates a new array instance.
- **Asset IDs:** References to objects, sprites, sounds, etc. (e.g., `obj_player`).
- **Function identifiers:** The names of globally hoisted script functions.

---

## Functions

### Declaration

```gml
// Named function (hoisted in Script assets)
function do_something(_arg1, _arg2) {
    return _arg1 + _arg2;
}

// Anonymous function (method)
var _fn = function(_x) { return _x * 2; };
```

### Default Arguments

```gml
function greet(_name = "Unknown") {
    return $"Hello {_name}";
}
```

### Hoisting

Functions defined at the top level of **Script** assets are hoisted globally during boot before any script statements execute (cross-script circular references work). See [Assets](#assets). Functions defined inside Objects or nested blocks are **not** hoisted.

### Returning

- `return` exits the function and returns a value.
- `exit` exits the current event or script immediately without a value.

### Static Struct

Every function has an associated static struct where its `static` variables live. You can retrieve or replace this entire struct using built-in functions:

- `static_get(function)` - Returns the static struct of the function.
- `static_set(function, struct)` - Overwrites the function's static struct.

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

// Inheritance (equivalent to JS `extends`)
function Apothecary(_name) : Marine(_name) constructor {
    static heal = function() { /* ... */ };
}

var _marine = new Marine("Brother Cassius", "Ultramarines");
```

- Inside a constructor, `self` refers to the struct being created.
- Constructor functions are globally available like any script function.
- Use `static` for methods inside a constructor. This attaches the method to the constructor's static struct once, rather than copying it into every new instance (similar to JS prototype methods).

---

## Methods and Binding

In GML, a **method** is a function that is bound to a specific context (a struct or instance), meaning `self` inside the function refers to that context. 

There are two ways to create a method:

### 1. Implicit Binding (Standard Methods)
When you define a function inside a struct or constructor, GML automatically binds it to that struct. This is the standard way to create methods, similar to JavaScript.

```gml
// Using a struct literal
var _my_struct = {
    hp = 100,
    get_hp = function() { return self.hp; }
};

// Using a constructor (best practice for instances)
function Player() constructor {
    hp = 100;
    
    // Static ensures the method is created once, not copied per instance
    static get_hp = function() { 
        return self.hp; 
    };
}
```

### 2. Explicit Binding (The `method()` Function)
You can explicitly bind an existing, unbound function to a specific context using the built-in `method()` function. This behaves like JavaScript's `Function.prototype.bind()` and is useful for callbacks or assigning methods dynamically.

```gml
var _context = { name: "Cassius" };
var _unbound_fn = function() { return self.name; };

var _bound = method(_context, _unbound_fn);
// _bound() will return "Cassius"
```

**Quirks of `method()` and Static Structs:**
When using explicit binding via `method()`, there are specific rules regarding static structs:
- Methods share the **static struct** of the original function they were created from. Chaining `method()` on a method still shares the original function's static struct.
- `static_get(the_method)` returns the **actual** static struct of the function behind the method (not a copy).
- `static_set(the_method, struct)` has **no effect** - the static struct of the function behind a method cannot be replaced.
- Variables attached directly to a method via `.` accessor (e.g. `_bound.tag = "x"`) are stored opaquely - not in the static struct.

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
    _arr[1] = 200;    // Creates a copy, reference lost
}
```

### Structs

```gml
var _s = { name: "Cassius", hp: 100 };

_s.name;              // Dot accessor
_s[$ "name"];         // Struct accessor (bracket with $)
```

### Legacy DS Structures

| Type | Accessor | Creation |
|---|---|---|
| `ds_list` | `[\| index]` | `ds_list_create()` |
| `ds_map` | `[? key]` | `ds_map_create()` |
| `ds_grid` | `[# x, y]` | `ds_grid_create(w, h)` |
| `ds_stack` | Built-in functions | `ds_stack_create()` |
| `ds_queue` | Built-in functions | `ds_queue_create()` |
| `ds_priority` | Built-in functions | `ds_priority_create()` |

DS structures must be manually destroyed with `ds_destroy()` or they leak memory. GML documentation recommends arrays and structs instead, where possible.

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
- **Do not** add `=` during assignment, or `;` at the end.

---

## Built-in Functions List

Primitives have no internal methods; use library functions instead.

**Strings:**
`string_length`, `string_copy`, `string_pos`, `string_repeat`, `string_upper`, `string_lower`, `string_hash_to_newline`, `string_delete`, `string_insert`, `string_replace`, `string_count`

**Arrays:**
`array_length`, `array_push`, `array_pop`, `array_sort`, `array_shift`, `array_unshift`, `array_resize`, `array_copy`, `array_create`, `array_equals`, `array_filter`, `array_map`, `array_reduce`, `array_find`

**Math:**
`min`, `max`, `abs`, `round`, `floor`, `ceil`, `clamp`, `lerp`, `sin`, `cos`, `tan`, `darcsin`, `darccos`, `darctan`, `point_distance`, `point_direction`, `random`, `irandom`, `random_range`, `irandom_range`

**Type checking/conversion:**
`typeof(x)` (function, not operator), `is_instanceof(x, Constructor)` (checks inheritance chain), `instanceof(x)` (gets the constructor used to create a struct), `bool(x)`, `is_array(x)`, `is_bool(x)`, `is_string(x)`, `is_numeric(x)`, `is_struct(x)`, `is_undefined(x)`, `is_ptr(x)`, `is_int32(x)`, `is_int64(x)`, `is_handle(x)`, `is_method(x)`, `is_callable(x)`

---

## Keywords List

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
- `globalvar` is deprecated; use `global.` instead.

### Preprocessor Directives

```
#macro      #region     #endregion
```

- `#region` / `#endregion` create code-folding blocks in the IDE.
- `#macro NAME value` - compile-time textual replacement. Can span lines with trailing `\`.
