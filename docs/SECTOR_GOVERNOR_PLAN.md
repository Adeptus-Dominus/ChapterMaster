# Sector Governor — Plan & Handoff

*Snapshot: 2026-07-07 (updated). This is the master doc for the Sector Governor / multi-region work.
It ties together the design vision, what's implemented so far, how to pick the work back up on
another machine, and what's next.*

## Companion docs

- `docs/DESIGN_ROADMAP.md` — the full feature vision (all ten braindump ideas, mapped to code,
  sized, dependency-ordered).
- `docs/REGIONS.md` — technical reference for the multi-region data layer, conquest overlay, and the
  region building tree.
- `docs/POPULATIONS_FORCE_PLAN.md` — build plan for per-race populations + Tyranid biomass and drawing
  enemy forces/waves from them (replacing the abstract 0–6 force level). Ork-first, phased.
- `docs/CHEATCODES.md` — includes the new `regions` debug command.
- This doc — current state + next steps + how to continue.

## Where things stand

**Built and wired in-game:**

1. **Multi-region planets (data layer).** Every planet is now a capital + a variable number of
   outlying regions (count scales with planet size/type). Each region has its own owner,
   population, garrison (pdf/guardsmen), fortification, defences, and buildings. Stored in
   `obj_star.p_regions[planet]`; persists automatically through the existing save system (it uses
   the `p_*` naming the save code already serialises). Generated at worldgen and lazily for old
   saves. Population/forces are split with the capital weighted double, so the capital is always
   the largest region and totals are conserved.

2. **Conquest overlay (Option A).** Planet-level scalars stay authoritative — combat and
   `scr_star_ownership` are unchanged. Each turn, `regions_sync` *derives* region control from the
   real state: the owner holds the capital; a contesting force takes a share of the outlying
   regions scaled by strength. Assault an enemy world and, as its force is ground down 1–2 levels
   per win, outlying regions flip to you one at a time — capital last, when the world itself
   changes hands. Nothing writes back to the authoritative scalars, so real combat losses are never
   clobbered.

3. **Debug visibility.** `regions` console command (press **P** on the star map, type `regions` or
   `regions <planet>`) prints each region's owner/population/garrison/fortification as an in-game
   popup and to the IDE Output window. Region info also shows in the debug forces window.

4. **Region-selection UI + steered conquest.** The system view now shows a **Planetary Regions**
   panel (in the right column when garrison/population/feature panels are idle): each region's owner
   colour-coded, its fortification, defences and garrison, plus a **CONTESTED** badge. Click an
   outlying region to set it as your **conquest focus**. `regions_sync` then flips that region
   first; otherwise it flips **weakest-fortified regions first**, so per-region defences now shape
   *which* regions fall and in what order — you can steer the conquest instead of just watching it.
   Capturing a region grinds down its own fortification and defences (**consume-on-capture**). All
   of this lives in the *derived* overlay, so the fragile combat core is still untouched. The focus
   choice is stored per planet in `obj_star.p_region_focus[planet]` (a `p_*` array, so it saves
   automatically). Tactical note: the *battle screen itself* is unchanged — see "Next steps".

5. **Region building tree.** A data-driven building catalogue (`region_building_catalogue`) with a
   **Construction box** under the regions panel, reusing the game's holo build widget (the
   Monastery→Forge pattern). Buildings are per-region, instant-requisition, gated by planet type,
   and stored in `Region.buildings`. Effects feed systems that already exist: **Bastion** →
   fortification, **Turret Battery / Anti-Orbital Gun** → defences, **Manufactorum** → forge/industry
   points, **Factory / Mine** → requisition, **Industrial Farms** → population, **PDF / Guard
   Barracks & Training Ground** → garrison growth, **Candidate Station** → recruitment success
   without tying up apothecaries. Per-turn effects tick from `scr_star_ownership` for regions you
   hold. Art is placeholder; numbers are first-pass. Also fixed: **left-clicking a multi-region
   planet now locks in the regions/construction view** (previously only hover showed it; click
   opened the garrison report).

**Design decisions locked:**

- Region count is **variable by planet size/type** (Hive/Forge etc. = capital + 3; smaller worlds
  fewer; dead worlds one).
- **Contested worlds allowed** — different factions can hold different regions of one planet.
- Combat depth is **Option A** for now (land + capture, planet-scale fights); **Option B**
  (fully region-aware combat) is deferred and to be scoped.
- Buildings/fortifications/turrets are **framework-only** so far (fields exist; no catalogue yet).

## Key files

New:

- `scripts/Region/Region.gml` — the per-region data record (plain data; no methods, so it survives
  save/load).
- `scripts/scr_region_functions/scr_region_functions.gml` — generation, the conquest overlay
  (`regions_sync`, now steered + fortification-resistant + consume-on-capture), contested/query
  helpers, the conquest-focus API (`region_focus_get/set/ensure`, `regions_contest_order`,
  `region_assault_target`), the `draw_regions_panel` UI, and the debug dump.

Edited:

- `objects/obj_star/Create_0.gml` — `p_regions` init + `get_regions` accessor; **new**
  `p_region_focus` init (per-planet conquest-focus, `p_*` so it auto-saves).
- `objects/obj_star/Alarm_1.gml` — generate regions at worldgen.
- `objects/obj_star_select/Draw_64.gml` — **new** draws the Planetary Regions panel in the right
  column (idle state) and a close-guard so clicking the panel does not deselect the planet.
- `scripts/scr_star_ownership/scr_star_ownership.gml` — calls `regions_sync(id, run)` per planet
  each turn (the overlay).
- `scripts/scr_cheatcode/scr_cheatcode.gml` — `regions` command + debug-window readout.
- `ChapterMaster.yyp` — registers the two region scripts (no new script assets were added this
  pass; the UI/focus functions live inside the existing `scr_region_functions`).

> Nothing in the fragile combat core (`obj_ncombat` / `obj_pnunit` / `obj_enunit`) or the
> drop-select assault path was modified. All changes are additive (overlay + UI + one save field);
> existing behaviour is unchanged. The region-selection UI works entirely through the derived
> overlay, so it can never clobber real combat state.

## How to continue on another machine

1. Unzip the project anywhere.
2. Install the matching **GameMaker** IDE (see `docs/README.md` → "Compiling from source").
3. Open **ChapterMaster.yyp** in GameMaker.
4. Press **Run (F5)** to compile and play.
5. To verify regions: start a new galaxy (or load a save), open a system, and select a multi-region
   planet — the **Planetary Regions** panel should appear on the right. Click an outlying region to
   set the focus (it highlights). To watch steered conquest, park a fleet at an enemy world with a
   strong garrison (force 4–6), set a focus region, and assault it over several turns; the focused
   region should fall first and its Fort/Def tick down as you take it. The `regions` cheat (press
   **P**, type `regions`) still prints the raw data for cross-checking.

> This pass was reviewed for GML syntax, save/load safety, name collisions, and (by a second
> independent read) balanced braces / undefined identifiers — but it was **not run** in a compiler
> in this environment. Two things to eyeball on first run: (a) the panel's screen position
> (`340 + main_data_slate.width, 160` in `obj_star_select/Draw_64.gml`) — nudge if it overlaps; and
> (b) balance of the new fortification-resistance/consume-on-capture in `regions_sync`. If a compile
> error appears, note the script + line — the fix is usually small.

## Next steps (in suggested order)

**Finish Option A:**

1. ~~**Region-selection UI.**~~ **DONE.** The Planetary Regions panel + click-to-focus + steered
   conquest overlay + contested-world display are in (see "Where things stand" #4).
2. **Per-region defences affect the fight — done at the *conquest* level; tactical battle is Option B.**
   Fortification now shapes the conquest: fortified regions resist flipping (fall last) and are
   ground down on capture. Making the *tactical battle screen* itself harder per region was
   deliberately **not** done here, because the existing fortification combat code assumes the
   **player is the defender** — `obj_ncombat.fortified` is only ever set on the defending path, and
   the battle narrative ("An Aegis Defense Line protects **your** forces", "your Monastery") is
   written from the defender's seat. Feeding it into an offensive player assault would put the walls
   on the wrong side and print the wrong text. Doing it properly means teaching the combat core to
   treat fortification as the *defender's* asset regardless of who attacks — that is squarely the
   Option B combat-core rework (below), so it was left for that pass.
3. ~~**Building framework → catalogue.**~~ **DONE** (first pass — see "Where things stand" #5).
   Remaining: real building art (placeholder holos for now), balance tuning of costs/effects, and
   optionally build queues / build time instead of instant requisition.

**Then Option B (scope first):**

4. **Region-aware combat.** Enemy force size, casualties, and targeting computed per region;
   simultaneous multi-front contested planets. This touches the combat core — the biggest, riskiest
   piece — and should be designed carefully on top of the working Option A. `regions_rollup` (which
   makes regions authoritative for the planet scalars) is already written and reserved for this.
   Include here the **attacker-side fortification** fix noted above: `obj_ncombat` currently treats
   fortification as the defender's asset only (set on the defending path, "protects your forces"
   text). To make an assaulted region's fortification actually harden the battle, the fort object,
   its bonuses, and the combat narrative need an attacker/defender-aware form. `region_assault_target`
   (already written) picks *which* region an assault lands on and is ready to feed this.

**Beyond regions** (see `DESIGN_ROADMAP.md`): populations/biomass, force generation, bigger
battles, Nid/Chaos reworks, Ork AI, and the playable Warmaster/Sector Governor + Renegade modes.

## Open questions to settle

1. ~~Region-selection UI: reuse the existing screens, or a dedicated panel?~~ **Settled:** a
   dedicated read-only panel in the system view's right column, click-to-focus. Follow-up: should
   the focus also drive the "Attack" action's target (Option B), or stay advisory as it is now?
2. Steered conquest tuning: right now the *count* of regions that fall derives from the enemy force
   ratio (`1 - force/6`) and fortified regions fall last. Is "weakest-fortified first, focus
   overrides" the behaviour you want, or should a fortified region *block* progress until reduced?
3. Building economy: instant/bonus buildings, or HOI4/Aurora-style build queues with resources?
4. Option B scope: full per-region force simulation, or a lighter "region modifies the existing
   fight" model? (Includes the attacker-side fortification fix — see Option B step 4.)
