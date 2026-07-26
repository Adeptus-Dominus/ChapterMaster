# GameMaker Language (GML) Guide

This guide covers the language for developers familiar with JavaScript or other C-family languages.

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

---

## Asset Types

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

**Standard:** `+`, `++`, `-`, `--`, `*`, `/`, `%` (`mod`), `div` (integer division), `&&` (`and`), `||` (`or`), `^^` (`xor`), `!` (`not`).

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

## Variable Scope

GML has three primary runtime scopes. At runtime, variable names are resolved in this order (the first match wins):
1. **local**
2. **instance**
3. **global**
4. **built-in**

### Local Scope

Declared with `var`. Exists only during the current function or event execution. 

`var` is scoped to the **function body**, not to individual blocks. Control-flow constructs (`if`, `for`, `switch`, `try`) do **not** create a new local scope.

```gml
function example() {
    for (var i = 0; i < 10; i++) {
        var _inner = i;
    }
    // _inner is accessible here! (unlike JS let)
}
```

### Instance Scope

Declared without a keyword (e.g., `hp = 100;`) or via context (`self.hp = 100;`). Tied to the lifetime of the specific instance or struct executing the code.

### Global Scope

Declared on the `global` struct (e.g., `global.score = 0;`). Accessible anywhere in the game. The `global` struct acts as a de facto application singleton.

### Context Keywords: `self` and `other`

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

---

## Variable Categories

While scope defines *where* a variable can be accessed, GML features distinct categories of variables based on how they are initialized and stored.

### Static Variables and Methods

The `static` keyword declares a variable or method that is initialized **only once**, on the very first call to the function, and persists across subsequent calls. Static variables are stored in the function's hidden "static struct" rather than in the local scope.

```gml
function counter() {
    static _count = 0; // Evaluated only on the first call
    _count++;
    return _count;
}

counter(); // returns 1
counter(); // returns 2
```

**Initialization order & behavior:**
- Static variable initializers run at the **very top** of the function body, *before* any other code executes. This means they are always evaluated regardless of conditionals, wrapping them in an `if` statement does nothing to prevent their initialization.
- You can reference a static variable before its declaration line in the same function due to this top-of-function hoisting.

**Accessing static variables from outside:**
You can read a static variable from outside its function using dot syntax, but **you must call the function at least once first**, otherwise, the static struct does not yet exist:

```gml
counter();               // Must call it first to create the static struct
show_debug_message(counter._count); // -> 1 (access via function name)
```

**Static Variables and Inheritance (Critical):**
Unlike JS prototypes, static variables are strictly scoped to the constructor they are defined in. Child constructors have their own separate static scopes.
- **Reading** a static variable from a child instance will traverse the inheritance chain to find the parent's static value if the child doesn't have its own.
- **Writing** (assigning) to a static variable through a child context **creates or modifies a variable on the child's own static struct**, shadowing the parent and leaving the parent's value completely untouched.

```gml
function Parent() constructor {
    static value = 10;
}
function Child() : Parent() constructor { }

show_debug_message(Child.value); // -> 10 (reads from Parent)
Child.value = 20;                // Writes to Child's OWN static struct
show_debug_message(Parent.value);// -> 10 (Parent unchanged!)
```

**Static Methods:**
You can also use `static` to define functions inside constructors. These methods are created only once (rather than re-created for every new instance), which saves memory and improves performance when you have many instances:

```gml
function Player() constructor {
    static say_hello = function() {
        show_debug_message("Hello!");
    };
}
var _p1 = new Player();
var _p2 = new Player();
// _p1.say_hello and _p2.say_hello reference the exact same function.
```

### Compile-Time Values (Independent)

Not true variables in the runtime memory sense, but named values resolved at compile-time. They are globally available and not tied to any struct:
- **Macros:** `#macro NAME value` - Compile-time textual replacement. (Do not use for arrays; each reference creates a new array instance).
- **Enums:** Named integer constants.
- **Asset IDs:** References to objects, sprites, sounds, etc. (e.g., `obj_player`).
- **Built-in function identifiers:** The names of globally hoisted script functions.

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

| Type | Accessor | Creation |
|---|---|---|---|
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
