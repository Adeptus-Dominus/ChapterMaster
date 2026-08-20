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

## Misc Rules

- Favor idiomatic terseness: ternary operators, nullish coalescing (??, ??=) where readable.
- Write elegant, idiomatic, clean code, like a senior software developer.
- Don't try to create new `.yy` files when creating new `.gml` scripts. They'll be created by GameMaker automatically.
