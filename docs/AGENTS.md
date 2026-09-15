# Agent Guidance

## Useful Links

- GameMaker Manual GitHub: https://github.com/YoYoGames/GameMaker-Manual/develop/Manual/contents/GameMaker_Language/
- GameMaker Manual: https://manual.gamemaker.io/beta/en/
- GameMaker Forum (community evidence, working solutions, and tips): https://forum.gamemaker.io/

## Sequential Execution

Always proceed with each task, issue, or question sequentially, one-by-one, step-by-step; never at once.
The only exception is when you use parallel sub-agents, each handling a separate thing in isolation.

## Banned Symbols

The entire codebase must use only 7-bit ASCII characters (Unicode range U+0000 to U+007F). Never use the following symbols:
- Curly quotes (“ ” ‘ ’) -> use straight quotes (" ').
- Em/En dashes (— –) -> use hyphen (-).
- Math symbols (× ÷ ≠ ≤ ≥ ±) -> use ASCII equivalents (* / != <= >= +/-).
- Bullets (• ▪ ◦) -> use asterisk (*) or hyphen (-).
- Ellipsis (…) -> use three periods (...).
- Arrows (→ ⇒) -> use ASCII (-> =>).

If a single non-ASCII character outside of a mandatory UI string (i.e., a user-facing label that explicitly requires it) is found, the entire submission is rejected.

## Reduce Comment Noise

When code exists for a non-obvious reason, like a redundant function call left for explicitness, or a seemingly unnecessary check, you can add a comment explaining why. Anyone reading it later shouldn't have to guess or trace five call sites to figure out the obscure intent.
But DON'T add comments explaining "what" is happening in each code-block, people can read on their own. Only explain "why", when really needed.

## Minimal Defensive Code

Do not add guards, checks, fallbacks, or safety nets for hypothetical failures. Write the minimum code required by the current contract. Prefer failing fast and loud over silently continuing.

Rules:
- Validate only at trust boundaries: user input, file/network I/O, external APIs, dynamically loaded data, or other code you do not control.
- Trust internal callers and invariants. If the caller already ensures an instance exists, a variable is initialized, an array is non-empty, or a value is valid, do not re-check it.
- Do not duplicate checks across layers. Validate once at the boundary. Internal functions should assume valid inputs.
- Do not add speculative `undefined`, `noone`, `instance_exists`, `variable_instance_exists`, `array_length`, null, or bounds checks unless that exact failure is a documented expected outcome.
- Do not use fallback defaults to hide invalid state. `??`, `??=`, `||`, and similar are for real optional values, not for papering over bugs.
- Do not swallow errors or return a harmless value just to keep going. If recovery is not specified, let the error surface.
- Every guard must have a concrete, reachable failure mode. If you cannot name the failure and how it occurs, delete the guard.
- Debug assertions are acceptable for documenting real invariants. Runtime guards are not.
- When in doubt, omit the guard.

For each added guard, ask: "What real input or state reaches this line and makes this guard necessary?" If the answer is "maybe" or "just in case", reject it.

## Misc Rules

- Favor idiomatic terseness: ternary operators, nullish coalescing (??, ??=) where readable.
- Write elegant, idiomatic, clean code, like a senior software developer.
- Don't try to create new `.yy` files when creating new `.gml` scripts. They'll be created by GameMaker automatically.
