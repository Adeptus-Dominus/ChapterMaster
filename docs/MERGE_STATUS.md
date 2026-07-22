# Sector Governor Overhaul → Auxilla (EXE-BETA) — MERGE STATUS

Weaving the Sector Governor overhaul from the SOURCE tree into this Auxilla base.
SOURCE = `...\Sector govonor\Chapter-Master-1.5-Adeptus-Indomitus-main\...-main\`.
Authoritative: SOURCE `docs/MERGE_GUIDE.md`, `docs/HANDOFF_PORTING_GUIDE.md`, `docs/POPULATIONS_FORCE_PLAN.md` §16.

Method: `§16` comment tags mark overhaul edits (141 in SOURCE). A/I = additive/in-place. Namespace prefixes:
ork_/chaos_/heretic_/tyranid_/genestealer_/faction_/br_/regions_/planet_faction_. **Cannot compile here — compile in GameMaker.**
Diff any file with:  `diff <AUXILLA>/<f> <SOURCE>/<f>`

## DONE ✅

**Phase 1 — data model**
- `objects/obj_star/Create_0.gml` — added p_race_pop, p_infra_turns, p_ork_loot, p_biomass, p_ork_clan, p_chaos_god (save-safe).
- `scripts/scr_planetary_feature/scr_planetary_feature.gml` — eP_FEATURES += FUNGAL_BLOOM, ASCENSION_BEACON, HERETIC_ACTIVITY; GSC ascension_age; 3 feature cases.
- `objects/obj_en_fleet/Create_0.gml` — `revealed = false`.
- `scripts/macros/macros.gml` — NO CHANGE NEEDED (Auxilla newer/superset; eFACTION matches).
- `objects/obj_star/Alarm_0.gml` — NO CHANGE (identical in both).

**Phase 2 — resolver/composition core**
- Copied wholesale (byte-exact, registered in ChapterMaster.yyp): `scripts/Region`, `scripts/scr_battle_resolver`, `scripts/scr_region_functions`, `objects/obj_duel`.
- Wired: `scr_enemy_ai_a` → `resolve_ai_planet_battle(id,_run)` (guarded by global.br_ai_battles; kept Auxilla's eFACTION names, NOT the overhaul's numeric downgrades). `scr_turn_first` → `chaos_great_game_tick()`.

**Phase 3 — faction systems (done so far)**
- `scripts/scr_ground_ai_helpers.gml` — has_imperial_enemies zeroes hidden heretic/GSC.
- `objects/obj_star/Draw_0.gml` — Ork clan icon on star label.
- `objects/obj_en_fleet/Step_0.gml` — revealed-aware Tyranid fog.
- `objects/obj_en_fleet/Alarm_1.gml` — tyranid_fleet_engage/migrate (removed old p_tyranids[4]=5 index bug).
- `scripts/scr_necron_tombs.gml` — slow awakening seed (necron_awaken_seed/count_to_level).
- `scripts/scr_imperial_manage_fleet_functions.gml` — colony-ship corruption/cult/chaos_god taint spread.
- `objects/obj_star/Alarm_1.gml` — worldgen seeding: Craftworld/Ork(+FUNGAL_BLOOM+clans)/Tau race pops, younger GSC cults, regions_ensure.
- `scripts/scr_star_ownership.gml` — regions_sync + regions_buildings_tick + p_infra_turns + regions_orbital_guns_tick (kept Auxilla's ownership-reversion logic, NOT overhaul's numeric downgrades).
- `scripts/scr_ork_fleet_functions.gml` — REPLACED wholesale via cp (verified: entire diff was overhaul rewrites, zero independent Auxilla drift; scr_orbiting_fleet resolves in scr_fleet_functions). New: ork_world_tick, sector_ork_population, population-driven init_ork_waagh + WAAAGH landing.

Verified all referenced hub functions exist (regions_*, ork_*, chaos_*, heretic_*, tyranid_*, genestealer_*, resolve_ai_planet_battle, count_to_level, necron_awaken_seed, etc.).

## REMAINING ⏳

**Phase 3 — `scripts/scr_PlanetData/scr_PlanetData.gml` (ENGINE DONE ✅ — 2394 lines, brace-balanced, verified)**
- ✅ `end_turn_race_population_growth` method spliced in + CALL SITE + `heretic_concealment_tick(system,planet)` call.
- ✅ `end_turn_genestealer_cults` replaced with the overhaul's superset (population infiltration + rate-limited Ascension Day). `end_turn_heretics_and_corruption_growth` was ALREADY identical (md5-verified) — no change.
- ✅ FIXED a 9-line truncation at EOF (init_fallen_marines tail + constructor close) caused by mixing bash+file-tool writes; re-verified balance=0.
- ⏳ ONLY REMAINING here: presence-list/headline DISPLAY reconcile (keep Auxilla's Gue'Vesa/Defense/Guard text, add hidden-cult concealment) — a UI display detail, folded into Phase 4. Not required to compile/run.
- (superseded note — original delicate plan):

- Measured: +357 overhaul lines, but 24 Auxilla-only lines a cp would DROP (the `Imperial Guard`/`Defense Force`/`Gue'Vesa Force` garrison display + Auxilla's GSC-reveal alerts). TRUE 3-way conflict in the presence-list region.
- ONE genuinely ADDITIVE method: `end_turn_race_population_growth` (+184; OVER ~197-378) — insert after Auxilla's `end_turn_population_growth` (Auxilla:182) / before `display_population` (Auxilla:220). Can bash-splice from OVER (no retype). Then add its CALL SITE in `end_turn_planet` + `heretic_concealment_tick(system,planet)` call + corruption floor 25.
- TWO IN-PLACE REWRITES (Auxilla ALREADY has these — reconcile, do NOT duplicate): `end_turn_genestealer_cults` (Auxilla:1926 vs OVER:2210) and `end_turn_heretics_and_corruption_growth` (Auxilla:1982 vs OVER:2315). 3-way each.
- PRESENCE-LIST/headline display conflict (hunks @-1259, @-1393): keep Auxilla's Gue'Vesa/Defense/Guard garrison text, ADD the overhaul's hidden-cult concealment (don't show hidden heretic/GSC force numbers). 24 Auxilla-only lines live here — a cp would drop them.
- Approach: diff each region (`diff <AUXILLA> <OVER>` scr_PlanetData), splice the additive method, then hand-merge the 2 rewritten methods + presence display against Auxilla's current versions.
- `scripts/scr_bomb_world.gml` — DROPPED permanently (design decision 2026-07-17): the only overhaul change was an `ork_maybe_behead` call on bombardment; behead is now RAID-ONLY (targeted strike), so bombardment must NOT roll behead. Do NOT port. (Removed from SOURCE too.) Behead lives in the raid screen (`ork_decapitation_strike`) + the combat-casualty roll in `scr_battle_resolver` ("the fighting") — both already merged.

**Phase 4 — UI (partly done)**
- ✅ `objects/obj_star_select/Create_0.gml` — cp'd (zero drift).
- ✅ `objects/obj_drop_select/Create_0.gml` — cp'd (zero drift).
- ✅ `scripts/scr_draw_planet_features.gml` — Ork clan line + Fungal Bloom/Ascension Beacon/Heretic Activity description panels (woven).
- ✅ `scripts/scr_DataSlate.gml` — NO CHANGE (identical in both).
- ✅ `objects/obj_star_select/Draw_64.gml` — DONE & verified (550 lines, brace-balanced). Added: keep-open-over-regions-panel, default-to-regions-view, the regions panel + construction box (draw_regions_panel + draw_region_construction_panel), and the force drill-down panel. KEPT Auxilla's newer raid/bombard/purge/deploy logic (skipped the overhaul's older versions of those 3 hunks). NOTE: file-tool edits produced a bad +5 brace imbalance here; rebuilt deterministically from the pristine base (verify any complex weave with a brace check).
- ✅ `scripts/scr_drop_select_function.gml` — DONE (balance 0). Kept Auxilla's `ship_action_spend`/`RAIDATTACK` raid API; added Cleanse-by-Fire (ork_cleanse_bloom), Behead (ork_decapitation_strike), and the assault/bombard SECTOR selector.
- ✅ `scripts/scr_cheatcode.gml` — DONE (balance 0). Kept Auxilla's cheats (veteranguard/guardxp/spawnmarines); added `regions`, `ascension`/`ascensionday`/`beacon` (force_ascension_day), and the region debug readout.

### ✅ presence-list/headline (DONE) — planet_info_screen replaced with overhaul version (balance 0):
combined clickable "Imperial Forces"/"Chaos Forces" alliance totals + per-faction breakdown rows (open the
force drill-down panel), secret heretic/GSC numbers hidden, Auxilla's Gue'Vesa kept.

### COMPILE + LOAD FIX (2026-07-16)
Game COMPILED and ran. First LOAD crashed: deserialize `array_set: argument 0 is not an array` at obj_star
Create_0 — `p_regions`/`p_region_focus` were declared in Alarm_1 (regions_ensure) + serialized but NOT declared
in Create_0, so on load `self.p_regions` wasn't an array. FIXED: added them to Create_0 (+ get_regions helper).
ALSO the file tool had truncated Create_0's deserialize function (3rd file-tool corruption) — rebuilt Create_0
from pristine base via Python, verified balance 0 + deserialize/#endregion restored.

### STRATEGIC SYSTEMS VERIFIED WIRED (sector map + AI-vs-AI, not player tactical)
- 0-6 force levels now DERIVED from population (count_to_level) — real forces via planet_faction_composition.
- AI-vs-AI ground war → resolve_ai_planet_battle (scr_enemy_ai_a:377), population rosters + alliance sides.
- Hidden cults: heretic_concealment_tick + AI blindness (has_imperial_enemies zeroes hidden) + tag-only display.
- Tyranid Hive Fleet: GSC Ascension Day → ascend_tyranid_world spawns obj_en_fleet at map edge → roams (engage/migrate).
- (DROPPED by design) `scr_bomb_world.gml` Ork ork_maybe_behead on bombardment — behead is raid-only; not ported. Player TACTICAL battle screen (obj_ncombat) still base-spawn — the overhaul's own deferred "Option B", not a merge gap.

### VERIFICATION DONE
- Hub (scr_region_functions + scr_battle_resolver) has ZERO dangling function refs (all scr_* and base calls resolve; make_colour_rgb etc. are GML built-ins).
- Every merged/rebuilt file confirmed brace-balanced + no unterminated strings (bash checks). NOTE: file-tool edits produced silent corruption twice (scr_PlanetData truncation, Draw_64 +5) — always brace-check after a file-tool weave; the Python-reconstruction approach (apply hunks to pristine, verify balance, write) proved reliable.
- USER: compile in GameMaker → new sector + save/reload + end several turns (watch for end-turn freeze).

**Phase 5 — resources:** the 4 new resources ARE registered. Re-confirm no other new sprite/datafile refs (spr_fleet_tyranid/chaos/civilian, spr_forge_holo) are missing.

**Phase 6 — verify:** grep every function the ported code calls vs the tree (catch upstream renames); re-grep `§16` to confirm nothing dropped; then COMPILE in GameMaker, new sector + save/reload + end several turns (watch for end-turn freeze = a per-turn tick loop). Reminder (user's task): the user will do the balance/bug-fix pass afterward, incl. the region-building bugs (~~factory req counter~~, turret battery defence reset, ~~Guard/PDF barracks tick~~, bastion/turret clash, anti-orbital).

### REGION-BUILDING BUGFIX PASS (2026-07-16)
- **Guard/PDF Barracks tick (FIXED):** root cause = `regions_sync` only rewrites `region.owner` and NOTHING calls `regions_rollup` per turn, so `pdf_barracks`/`guard_barracks` on_turn wrote only the region overlay (`_region.pdf`/`.guardsmen`), which never reached the authoritative `p_pdf`/`p_guardsmen` combat reads. Now they dual-write the planet scalar too (`_star.p_pdf[_planet] += 200`, `_star.p_guardsmen[_planet] += 100`) — same pattern Bastion/Turret Battery apply use. Overlay + scalar grow in lockstep, so a later `regions_rollup` on capture stays consistent (no double-count).
- **Factory/Mine req counter (FIXED):** was `obj_controller.requisition += 4/3` directly inside `regions_buildings_tick` — bypassed the `income_*` system so it never showed in the top-left counter and was "added after the fact." Now Factory/Mine carry a `req:` field (4/3), `on_turn: undefined`; new hub fn `regions_player_requisition_income()` sums player-held region-building req; `scr_income` stores it in new `income_regions`; `obj_controller/Step_0` folds it into `income`; `scr_ui_tooltip` shows a "Planetary Industry" line. All allocated together, paid with the rest of income.
- **Anti-Orbital Gun rogue targeting (FIXED):** `regions_orbital_guns_tick` targeted from the IMPERIUM's perspective (`region_faction_is_hostile`), so a player-held gun spared all Imperial ships even after the Chapter went Renegade, and had no concept of player alliances. A PLAYER-held gun now fires from the PLAYER'S perspective: hits any orbiting fleet whose owner is `> eFACTION.PLAYER` and NOT `faction_status == "Allied"`. Renegade flips the Imperial factions from "Allied" to "War" (same signal obj_en_fleet/Alarm_1 already uses), so they become targets automatically; any faction the player allied with is spared. Imperial NPC-held guns keep the old behaviour.

### PLAYTEST CRASH FIXES (from 13-14/7 error logs, Forge Traders save)
- **obj_turn_end/Mouse_56 flee-button crash (FIXED):** "Unable to find instance for object index 0" at `battle_pobject[current_battle].x` — the "Run like hell" (flee) path dereferenced the battle fleet with no `instance_exists` guard, while the Fight button right below it already guards the same value. Added the same guard (`alarm[4]=1; exit;` if the fleet is gone) + guarded the `instance_nearest` result.
- **scr_roster:update_local_string empty-role crash (FIXED, was caught):** `selected_local_roster[$ _role]` / `possible_local_roster[$ _role]` crashed on `variable_struct_set: illegal to use empty names` when a unit's `role()` was "". Skip empty roles in both loops, mirroring the existing `name()==""||role()==""` guard at scr_roster:269.

### FEATURE-REMOVAL PARITY (2026-07-17) — applied to BOTH trees, in sync
- **Fungal Bloom removal = Cleanse by Fire** (already wired both copies): `scr_drop_select_function` PURGEFIRE path calls `ork_cleanse_bloom` when a world has `FUNGAL_BLOOM`. No change needed — confirmed present in Auxilla (`scr_drop_select_function.gml:544`) and SOURCE.
- **Heretic Activity removal = the purge mechanic, tag drops automatically:** fixed `heretic_concealment_tick` (`scr_region_functions`, ~line 1148) in BOTH trees. Old removal check keyed off `p_traitors`, which goes stale when the host disperses (the growth block zeroes `p_race_pop[HERETICS]` below the corruption floor of 25 but left `p_traitors` set), so the tag lingered. Now: openly-Chaos worlds clear the tag (unchanged); a loyal world with `corruption < 25 && host <= 0` drops `HERETIC_ACTIVITY` automatically and zeroes the stale `p_traitors`. No purge-dispatch change — `scr_purge_world` already reduces corruption. Both `scr_region_functions.gml` copies edited identically (byte-parallel).

### DEFENSE-WIRING FIX (2026-07-17) — applied to BOTH trees
Audit of planetary defence (upgrades + Bastion/Turret buildings feeding combat + save/reload):
- **Bastion — OK, no change.** `apply` bumps `p_fortified` (guarded < 5) + region.fortification. `p_fortified` → `PlanetData.fortification_level` → `obj_ncombat.fortified` (obj_turn_end/Mouse_56) → `obj_nfort` bunker with level-scaled hp (obj_ncombat/Alarm_0). Reaches the sector-map estimate (`determine_pdf_defence`), the defending battle, and persists (`p_*` array + region round-trips).
- **Turret Battery — FIXED (was half-wired).** `apply` bumps `p_defenses` + region.defences and it persisted, BUT the defending battle never read it: `obj_ncombat.player_defenses` was hard-set to 0 in Create_0 and never assigned, so the weapon-emplacement unit (Alarm_0 `if (player_defenses+player_silos>0)`) never spawned — even though Alarm_5 already wrote battle losses back to `p_defenses[battle_id]`. FIX (both trees): (1) `obj_turn_end/Mouse_56` now sets `obj_ncombat.player_defenses = _planet_data.ground_defences` alongside `fortified` (gated by the same `_allow_fortifications`); (2) `obj_ncombat/Alarm_0` scales the emplacement `veh_hp_multiplier` by `clamp(player_defenses/6, 1, 5)` so stacking batteries hardens the fight. Files: `objects/obj_turn_end/Mouse_56.gml`, `objects/obj_ncombat/Alarm_0.gml` — edited identically in SOURCE + Auxilla.
- **No separate "defense upgrade" subsystem** raises these scalars for the player — the "additions from upgrades" ARE the region buildings (plus incidental mission/ruins fortification rewards, which already reach combat via `p_fortified`).
- **Latent (not fixed, currently dead code):** `regions_rollup` recomputes `p_fortified`/`p_defenses` as the MAX region value (a clobber of the summed building bonuses), but its only caller `region_set_owner` is never invoked, so it never runs. If ever wired in, change the defence roll-up from max to sum, or re-apply building bonuses after rollup.

### GENESTEALER-CULT WORLDGEN FIX (2026-07-17) — applied to BOTH trees
Audit found the end-turn GSC growth/composition/ascension all matched §16p/§16r, but WORLDGEN seeded the wrong
starting state, so a fresh game showed small, revealed, Purestrain-showing cults:
- `objects/obj_star/Alarm_1.gml` (cult seed): was `p_tyranids = min(3, floor(influence/15))` with NO host and `hiding=false`. Now seeds a population-scaled host (`p_race_pop[TYRANIDS] = round(_people * 0.006 * _mat)`, `_mat = clamp(cult_age/40,0,1)`), derives the level via `count_to_level`, and leaves cults HIDDEN (removed the `hiding=false`). Both trees edited identically.
- `scripts/scr_region_functions.gml` (`planet_faction_composition`): the TYRANIDS branch was gated on `host > 0`, so a revealed host-less cult fell through to the raw ladder (which lists Purestrains). Now cult-phase (GENE_STEALER_CULT, no beacon) ALWAYS routes through the filtered `genestealer_cult_composition` (returns `[]` at host 0) — no Purestrain/bioform leak. Post-Ascension still uses the L6 swarm shape. Both trees edited identically; `planet_faction_composition` re-verified brace-balanced (1015-1070) in both.

### CHAOS SECT + REGION-FORCES FIX (2026-07-17) — applied to BOTH trees (playtest: Isstvan I, fully-Chaos heretic world)
- **Empty region "Forces - <region>" panel:** `region_force_breakdown` composed only the region OWNER faction (CHAOS), but a heretic-held world's force lives under HERETICS — so it read "no significant field army." Now alliance-aware for a Chaos-side owner: folds CHAOS + HERETICS + GENESTEALER unit rosters (scaled by region share), like the planet headline. Also attaches `chaos_sect_allegiance` so a Chaos region shows its sect (mirrors an Ork region showing its clan).
- **Missing "Sect Allegiance — <God>" on the Chaos Forces drill-down:** the sect attaches only when `planet_chaos_god` returns ≥0, which required `chaos_world_present` — but that checked only the 0-6 level scalars (`p_traitors`/`p_chaos`/`p_demons`), which can read 0 on an openly-Chaos world whose force is in the `p_race_pop` host. Now `chaos_world_present` also returns true for a CHAOS/HERETICS OWNER (or a heretic host), so the god is assigned and the sect renders. (No recursion risk — `chaos_sector_tally` still reads raw `p_chaos_god`.)
- Files: `scripts/scr_region_functions.gml` (`chaos_world_present` ~1369, `region_force_breakdown` ~3339). Both re-verified brace-balanced + byte-parallel across trees.
- NOTE (not changed): a Chaos world showing "Planetary Features: ????" is the base game's `player_hidden` feature marker (scr_PlanetData ~1709) — a deliberately concealed feature, not a bug. Left as-is.

### BASTION DISTINCT BONUS (2026-07-17) — applied to BOTH trees, save-safe
The Bastion shared the capped 0-5 `p_fortified` pool with the base-game "improve defences" requisition upgrade (scr_PlanetData ~1518 → `alter_fortification`), so a Bastion on an already-fortified world (or a Forge world starting at 5) added nothing. Gave it a DISTINCT, uncapped bonus:
- New `planet_bastion_count(_star,_planet)` (scr_region_functions, after `region_building_count`): sums "bastion" region-buildings across the world. Save-safe — reads serialised regions via `regions_ensure`; old / region-less saves return 0, and existing Bastions on old saves count immediately (their id is already in `region.buildings`).
- `obj_turn_end/Mouse_56` sets `obj_ncombat.bastion_bonus = planet_bastion_count(pd.system, pd.planet)` at defend-setup (alongside `fortified`/`player_defenses`). `obj_ncombat/Create_0` defaults `bastion_bonus = 0`.
- `obj_ncombat/Alarm_0` bunker block: each Bastion adds **+400 HP / +5 armour** to the `obj_nfort` fortress, UNCAPPED; also spawns a (modest) bunker on a Bastion-only low-fortification world, and fixed the missing `fortified == 6` case (`== 5` → `>= 5`). The +1 fortification-tier nudge still applies while below 5 (helps early), so the Bastion now always adds value.
- Files: `scr_region_functions.gml`, `objects/obj_ncombat/Create_0.gml`, `objects/obj_ncombat/Alarm_0.gml`, `objects/obj_turn_end/Mouse_56.gml` — byte-parallel across trees; `planet_bastion_count` + bunker block re-verified brace-balanced.

## NOTES
- bash `cp`/create PERSISTS to the real tree (byte-exact); bash CANNOT delete; edits via file tools.
- The overhaul's shared-file diffs often include eFACTION→numeric "downgrades" (older base) — SKIP those, keep Auxilla's eFACTION names.
