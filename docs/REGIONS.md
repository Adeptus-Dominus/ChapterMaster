# Planetary Regions — background layer

Multi-region planets for the Sector Governor roadmap (item B). This document covers the data
layer only; UI and invasion/combat integration come later.

## Model

A planet is a small board of **regions**: one **capital** plus a variable number of outlying
regions. Region count varies by planet size/type (`region_count_for_planet`):

| Planet type | Regions (capital + outlying) |
|---|---|
| Hive, Forge, Temperate, Shrine, Feudal, Desert | 4 (capital + 3) |
| Ice, Agri, Death | 3 (capital + 2) |
| Lava | 2 (capital + 1) |
| Dead, Daemon, Craftworld, or max pop 0 | 1 (capital only) |
| fallback | 4 if "large", else 3 if max pop ≥ 1M, else 2 |

Each region carries its own `owner`, `first_owner`, `population`, `max_population`, `pdf`,
`guardsmen`, `force_level` (0–5 for non-Imperial holders), `fortification` (0–5), `defences`, and
`upgrades[]`. Because each region has its own owner, a single planet can be **contested** —
different factions holding different regions at once.

## Storage & save/load

Regions live in `obj_star.p_regions[planet]` (an array of `Region` records per planet). The name
starts with `p_`, so it is serialised and restored automatically by `obj_star`'s generic
save/load code — no bespoke save logic was needed.

`Region` (`scripts/Region/Region.gml`) is deliberately a **plain data record with no methods**.
Regions restored from a save come back as plain structs, so all logic lives in
`scripts/scr_region_functions/scr_region_functions.gml` and only ever touches region *fields*.

## Legacy compatibility (the rollup)

The existing per-planet scalars (`p_owner`, `p_population`, `p_pdf`, `p_guardsmen`,
`p_fortified`, `p_defenses`, `p_upgrades`) remain the authoritative **summary** so the large body
of non-region-aware code keeps working unchanged. `regions_rollup(star, planet)` recomputes them
from the regions: population/pdf/guardsmen **sum**, fortification/defences take the **max**, owner
is the **capital's** owner, upgrades are the **union**.

> Per-faction level arrays (`p_orks`, `p_tau`, …) are intentionally *not* rewritten by the rollup
> yet, to avoid disturbing existing balance. A faction mapping will be added when invasion/combat
> move onto regions.

Generation is seeded **from** the current scalars (capital takes ~40% of mass, rest split evenly),
so regionising a planet conserves its totals.

## API (`scr_region_functions`)

- `regions_ensure(star, planet)` — guarantees regions exist (generates lazily); safe on old saves.
- `regions_generate(star, planet)` — (re)build regions from planet scalars.
- `regions_rollup(star, planet)` — recompute planet scalars from regions (call after any change).
- `planet_is_contested(star, planet)` → bool.
- `planet_region_count(star, planet)` → count.
- `region_get(star, planet, index)` / `planet_capital_region(star, planet)` → Region.
- `regions_owned_by(star, planet, faction)` → Region[].
- `region_set_owner(star, planet, index, faction)` — change a region's owner + rollup. **This is
  the entry point invasion/battle code should use.**
- `obj_star.get_regions(planet)` — instance accessor mirroring `get_planet_data`.

## Conquest overlay (Option A)

Decision: **planet-level scalars stay authoritative.** `scr_star_ownership` already recomputes
`p_owner` every turn from the enemy force still present, and combat grinds that force down 1–2
levels per win — so strong worlds already take several fights. Regions are therefore a **derived
overlay**, not a second source of truth. Making regions authoritative (calling `regions_rollup`
during play) would clobber real combat losses, so **`regions_rollup` is reserved for a future
Option B** and is *not* called in normal play.

`regions_sync(star, planet)` (called each turn from `scr_star_ownership`) recomputes region
ownership from the authoritative state: the planet owner always holds the **capital**; a contesting
force takes a share of the **outlying** regions scaled by strength. On an enemy world the contester
is the **player** (grip = `1 - enemyForce/6`, so regions fall as the force is worn down); on a
friendly world it's a hostile **beachhead** (grip = `enemyForce/6`). The capital only changes hands
when `p_owner` itself flips — so a world is conquered region by region, capital last. Only
`region.owner` is written; no scalar is touched.

## Conquest focus (player steering)

The player picks which region to prioritise. The choice is stored per planet in
`obj_star.p_region_focus[planet]` — a `p_*` array, so it serialises with everything else. `0` means
"no explicit focus" (behaves as before). API in `scr_region_functions`:

- `region_focus_get(star, planet)` / `region_focus_set(star, planet, index)` — read/write the focus
  (validated + clamped; lazily creates the store on old saves via `region_focus_ensure`).
- `regions_contest_order(regions, focus)` — the order outlying regions fall: focused region first,
  then the rest **weakest-fortification-first** (so strongholds hold out longer). Used by
  `regions_sync`.
- `region_assault_target(star, planet, attacker)` — which region an assault *would* land on (focus
  if hostile, else the capital, else the toughest hostile holdout). Written and ready for Option B;
  not yet wired into the tactical battle (see below).

`regions_sync` now (a) flips regions in `regions_contest_order` rather than array order, and
(b) **consumes on capture** — the turn an outlying region is taken by the player, its `fortification`
and `defences` tick down by one. This decay stays in the overlay: `regions_rollup` is still *not*
called in normal play, so the authoritative `p_fortified`/`p_defenses` scalars are never touched.

## UI

`draw_regions_panel(star, planet, x, y)` (in `scr_region_functions`) renders the **Planetary
Regions** panel on the system view: per-region owner (colour-coded via `global.star_name_colors`),
fortification, defences, garrison, and a **CONTESTED** badge; outlying rows are clickable to set the
focus (`region_focus_set`). It is called from `obj_star_select/Draw_64.gml` in the right column.
Selecting a multi-region planet **defaults** to this panel (it pops up on click and stays until you
click off), via a `region_view_planet` tracker that resets the Population/Garrison view state on
planet change; opening Population (P) or Garrison still overrides it for that planet. A close-guard
keeps clicks on the panel from deselecting the planet.

## Buildings (region construction tree)

A data-driven building catalogue (`region_building_catalogue` in `scr_region_functions`). Each entry
has an id, name, holo sprite (placeholder art — reuses `spr_holo_pad` / `spr_forge_holo` /
`spr_def_mine`), requisition cost, build cap, planet-type gating, an optional one-shot `apply`
effect and an optional per-turn `on_turn` effect. Built ids live in `Region.buildings` (serialises
with the region struct; `region_buildings_ensure` back-fills old saves).

Current buildings and effects (numbers are first-pass, tunable):

- **Bastion** — +1 region fortification (cap 5). Hardens the region against capture. Stacks up to 5.
- **Turret Battery** — +1 region defences (cap 5). Stacks up to 5.
- **Anti-Orbital Gun** — active weapon, **region-owner-based** (handled by `regions_orbital_guns_tick`,
  which runs for ALL owners). Each turn it fires for whoever holds ITS region: a player/Imperial-held
  gun destroys a ship from a hostile `obj_en_fleet` in orbit; a gun on a region the **enemy** has
  captured fires on the player's `obj_p_fleet` (the double-edged sword). Player-ship removal via
  `region_player_fleet_lose_ship` (finds a live ship id, zeroes `obj_ini.ship_hp[id]`, drops the
  count) — the same way space combat removes player ships. **Who can work a captured gun:** mindless
  Tyranids never can (it stays silent); other hostile factions (Chaos, Orks, Tau, Necrons, ...) use
  it normally; a Genestealer Cult (`GENE_STEALER_CULT` feature or `eFACTION.GENESTEALER` owner) must
  first work it out (~50% chance/turn), then keeps firing every turn **until driven off the region**.
  That "learned" state is `Region.gun_mastered`, cleared whenever the region leaves cult hands — so a
  reformed cult has to relearn it.
- **Caps:** Bastion and Turret Battery stack (5 each per region). The **Anti-Orbital Gun is one per
  planet** (`region_planet_building_count`). A region may hold only **one player-benefit improvement**
  — Manufactorum / Factory / Mine / Industrial Farms / PDF Barracks / Guard Barracks / Training
  Ground / Candidate Station are mutually exclusive within a region (`region_improvement_count`), but
  the three defences (walls, turrets, orbital gun) build alongside that improvement.
  `region_building_can_build` enforces all of this and the construction panel only lists what's
  currently buildable.
- **Manufactorum** — 10,000 req; adds **+20** to `player_forge_data.player_forges` each turn (≈100
  forge / industry points, since output = 5 × forges). Gated to Hive/Forge/Desert.
- **Factory** (+4 req/turn), **Mine** (+3 req/turn) — economy, type-gated.
- **Industrial Farms** — grows region population toward its max. Agri/Temperate/Feudal.
- **PDF Barracks** (+200 pdf/turn), **Guard Barracks** (+100 guardsmen/turn).
- **Training Ground** — Scouts **garrisoned on this planet** gain experience passively each turn
  (iterates `get_garrison(planet).members`, filters `role() == eROLE.SCOUT`, `add_exp(10)`); no
  longer grows garrison. Station scouts on the world to train them.
- **Candidate Station** — passive; adds recruitment screening points via
  `region_candidate_station_bonus`, read by `PlanetData.get_local_apothecary_points`, so recruitment
  success rises *without* tying up apothecaries.

Build flow: `region_building_build` validates (player holds the region, world type allows it, under
the cap), spends requisition, stores the id and runs `apply`. Per turn, `regions_buildings_tick`
(player-held regions) runs `on_turn` effects and `regions_orbital_guns_tick` (all owners) fires the
anti-orbital guns — both hooked into `scr_star_ownership`'s real (argument0) pass. The UI is
`draw_region_construction_panel` + compact `draw_region_build_widget` tiles under the regions panel.

> Timing note to confirm on first run: the Manufactorum's forge-point contribution is added during
> the AI pass (via `scr_star_ownership`), after `player_forges` is reset for the turn — a playtest
> should confirm it lands before forge points are totalled.

## Selecting a planet

Planet selection in the system view is hover-driven (`planet_selection_action`). Clicking a planet
calls `PlanetData.set_star_select_planet`, which now, for **multi-region** worlds, defaults the
right column to the regions panel (`garrison = ""`) instead of the garrison report — so a left click
"locks in" the regions/construction view. Single-region worlds keep the classic garrison report.

## Wiring done

- `Region/Region.gml` — added the `buildings = []` field.
- `obj_star/Create_0.gml` — `p_regions` init + `get_regions` accessor; `p_region_focus` init.
- `obj_star/Alarm_1.gml` — regions generated at worldgen once planet scalars are final.
- `obj_star_select/Draw_64.gml` — draws `draw_regions_panel` + `draw_region_construction_panel` +
  click-to-focus + close-guard.
- `scr_star_ownership.gml` — `regions_sync(id, run)` and `regions_buildings_tick(id, run)` per planet
  each turn (the conquest overlay + building effects).
- `scr_PlanetData.gml` — `get_local_apothecary_points` adds the Candidate Station bonus;
  `set_star_select_planet` defaults multi-region worlds to the regions panel on click.
- `scr_cheatcode.gml` — `regions` console command + region readout in the debug forces window.
- `ChapterMaster.yyp` — `Region` and `scr_region_functions` registered (all focus / UI / building
  functions are additions inside `scr_region_functions`, so no new script asset was added).

## Not done yet (next passes)

1. **Tactical per-region battle (Option B).** Fortification now shapes the *conquest* (resists
   flipping, consumed on capture), but the `obj_ncombat` battle screen itself is unchanged. Making an
   assaulted region's defences actually harden the fight needs the combat core to treat fortification
   as the *defender's* asset regardless of who attacks — today it is defender-only (`obj_ncombat.fortified`
   is set on the defending path, with "protects **your** forces" narrative). `region_assault_target`
   is ready to feed the target region in once that exists.
2. **Building art + more effects.** Buildings use placeholder holo sprites; swap the `sprite` field
   per catalogue entry when real art lands. Effect numbers are first-pass and want tuning/balance.
   Optional: build queues / build time instead of instant requisition; per-turn income shown in the
   income breakdown UI (currently added directly to requisition / forge points).
3. **Option B — full region-aware combat.** Enemy force size, casualties, and targeting computed per
   region (uses `regions_rollup` / a faction-array mapping). Scope to be defined.

## Verification note

Not runtime-tested — this environment has no GameMaker compiler. Changes are additive (overlay + UI +
one save field; the combat core and drop-select path are untouched), and were reviewed for GML syntax,
name-collision, field names, save/load safety, and (by a second independent pass) balanced braces and
undefined identifiers. Recommend a compile + new-galaxy smoke test in the GameMaker IDE; eyeball the
panel position (`340 + main_data_slate.width, 160`) and the conquest-tuning balance on first run.
