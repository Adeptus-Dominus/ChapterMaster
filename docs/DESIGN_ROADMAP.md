# Design Roadmap — Sector Governor / Adeptus Indomitus

*Working design backlog. Captures the vision braindump, distils each idea, maps it to
the real code it would touch, and flags feasibility, dependencies, and open questions.
This is a living doc — add, cut, and re-prioritise freely.*

Status legend — **Complexity:** S (a few files) · M (a system) · L (a subsystem + UI) · XL (new pillar).
**Dependency:** what must exist first.

---

## 1. The vision in one paragraph

Grow the game from "command a Space Marine Chapter" into "command an **Imperial war effort at
sector scale**, from any seat you choose." Two threads run through everything: (1) **scale up** —
bigger battles, real populations, layered planets, deeper economy; (2) **choose your seat and your
allegiance** — play the Chapter, or play as a **Sector Governor / Warmaster** who expands their hold
of influence and can either stay loyal to the Imperium or **break away** (independent/renegade, or
fall to Chaos). The braindump's ten ideas are really facets of these two threads.

---

## 2. How the world is modelled today (so ideas map to reality)

Understanding this makes every idea below concrete. Key touchpoints:

- **Planets live as parallel arrays on `obj_star`**, indexed by planet slot. Read/wrapped by
  `scr_PlanetData` (`PlanetData(planet, system)` constructor). Fields include:
  `p_owner`, `p_first` (original owner), `p_population`, `p_max_population`, `p_large`, `p_pop`
  (secondary pop), `p_type`, `p_feature`, `p_pdf`, `p_guardsmen`, `p_sisters`, `p_eldar`, `p_orks`,
  `p_tau`, `p_tyranids`, `p_chaos`, `p_demons`, `p_traitors`, `p_necrons`, `p_fortified`,
  `p_lasers`, `p_silo`, `p_defenses`, `p_upgrades` (array of built features per planet),
  `p_influence[planet][faction]`, `dispo` (player disposition), `p_heresy` / `p_hurssy`
  (corruption/heresy). — `scripts/scr_PlanetData/scr_PlanetData.gml`
- **Factions are an enum** `eFACTION` = PLAYER, IMPERIUM, MECHANICUS, INQUISITION, ECCLESIARCHY,
  ELDAR, ORK, TAU, TYRANIDS, CHAOS, HERETICS, GENESTEALER, NECRONS. — `scripts/macros/macros.gml`
- **"Buildings" already exist as planet features** in enum `eP_FEATURES` (MONASTERY,
  RECRUITING_WORLD, MECHANICUS_FORGE, ARSENAL, GENE_VAULT, SECRET_BASE, FORGE, CAPILLARY_TOWERS,
  etc.), stored per planet in `p_upgrades[]`. — `scripts/scr_planetary_feature/scr_planetary_feature.gml`
- **Per-faction population + influence** already tracked per planet:
  `adjust_influence(faction, value, planet, star)` and `merge_influences()`.
  — `scripts/scr_population_influence/scr_population_influence.gml`
- **Combat** is an alarm-driven turn machine: `obj_ncombat` orchestrates, `obj_pnunit` (player rows)
  and `obj_enunit` (enemy rows) resolve fire; `scr_battle_Roster` gathers forces, `scr_shoot` /
  `scr_player_combat_weapon_stacks` resolve volleys. See `docs/ARCHITECTURE.md` "How does combat work".
- **Guard / Auxilia layer** (this fork's headline feature) spans `scr_trade`, `scr_management`,
  `scr_roster`, `scr_add_man`, `scr_ui_manage`. Governor trade already raises Guardsmen + attached
  armour at the homeworld.
- **Sector Governor** already exists as an NPC/trade partner: `scr_gov_disp`, plus governor hooks in
  `scr_trade`, `scr_dialogue`, `scr_event_code`, `scr_diplomacy_helpers`.

Takeaway: **most of the braindump extends systems that already exist** (planet arrays, faction
populations, influence, planet features, guard units). The genuinely new pillars are the *playable*
Governor/Warmaster and Renegade **modes**, and Nid/Chaos **behaviour**.

---

## 3. Idea backlog (grouped, mapped, sized)

### A. Bigger battles
**Idea:** raise battle scope from small-scale to tens/hundreds of thousands, by fielding
PDF/Guard/Sisters alongside Marines, with enemy numbers scaled proportionally to their
population/bodies.
**Design notes:** the Auxilia layer already introduces mass infantry that split into capped volleys —
this is the lever. "Bigger" is mostly (a) letting more rows/stacks exist, (b) sourcing attacker and
defender counts from real populations (see D/E), and (c) making sure the combat loop and UI stay
readable at scale (abstract large blocks rather than draw every body).
**Ties to:** D (populations), E (force generation), F (Warmaster leading Guard).
**Code touchpoints:** `scr_battle_Roster`, `obj_pnunit`/`obj_enunit`, `scr_shoot`,
`scr_player_combat_weapon_stacks`, `scr_civil_roster`, `scr_battle_allies`.
**Complexity:** M–L. **Depends on:** partially on D/E for the numbers to feel earned.
**Open Qs:** cap on simultaneous rows? Do we abstract 100k into "blocks of N" for perf/readability?

### B. Planetary regions (multi-region worlds)
**Idea:** a world isn't taken in one click. Each planet = **1 capital + 3 outlying regions**. Each
region can hold an upgrade + defences (depth). Landing forces pick a region; landing on an occupied
region triggers an immediate battle; lose it and that incursion is deleted before it spreads.
**Design notes:** this is the highest-leverage structural change — it turns planets from a scalar
into a small board and gives buildings (C), populations (D) and battles (A) a place to live. Cleanest
approach: nest a `regions[]` array under each planet slot on `obj_star` (capital + 3), each region
carrying `owner`, `upgrades[]`, `defences`, `garrison`. Migrate existing per-planet scalars to
"sum/rollup of regions" so old code keeps working during transition.
**Ties to:** almost everything — C, D, A, B is the substrate.
**Code touchpoints:** `scr_PlanetData` (constructor + rollups), `obj_star` planet arrays, invasion/
drop logic (`scr_drop_select_function`, `scr_star_ownership`, `scr_purge_world`), map draw
(`scr_draw_planet_features`), combat trigger.
**Complexity:** L–XL (touches the core data model). **Depends on:** nothing hard, but should land
*before* C/D so they build on regions rather than being retrofitted.
**Open Qs:** fixed 3 regions or vary by planet size/type? Can regions be independently owned by
different factions at once (contested worlds)?

### C. Deeper building trees
**Idea:** more buildings to expand into, gated by planet type / assigned flags.
- *Marine-side:* training fields (raise XP cap), clone farms (forbidden recruitment), defensive
  walls, turrets.
- *Planetary improvements:* manufactory, mines, defensive networks/turrets, PDF/Guard training
  grounds — each giving economic or defensive bonuses, filtered by world flags/type.
**Design notes:** buildings already exist as `eP_FEATURES` in `p_upgrades[]`. This is "add entries +
effects + a build UI + type/flag gating," which is very tractable and incremental. With regions (B),
buildings attach to a region slot.
**Ties to:** B (where they sit), D (mines/manufactory feed economy), E (training grounds feed forces).
**Code touchpoints:** `scr_planetary_feature` (enum + effects), `scr_PlanetData` (`p_upgrades`),
build/management UI (`scr_ui_manage`, `scr_gov_disp`), `scr_forge_world_functions` (precedent for
economic buildings).
**Complexity:** M (S per building once the framework exists). **Depends on:** nicer with B first.
**Open Qs:** build via resources/time (HOI4/Aurora production lines — your stated inspiration)?
Global build queue or per-planet?

### D. Populations for other races (+ biomass)
**Idea:** track populations per race, not just player/imperial. Orks sprout fungal growth after
taking a world (bonus growth using a captive race as livestock); this feeds the Nid loop. Biomass as
a currency.
**Design notes:** per-faction populations *already exist* (`p_orks`, `p_tyranids`, `p_chaos`,
`p_traitors`, `p_necrons`, ...). This idea = give them **growth/decay dynamics and cross-race
interactions** (ork spores, nid consumption, livestock modifiers) plus a **biomass** accumulator that
Nids spend (see J). `scr_population_influence` is the natural home.
**Ties to:** J (nids eat biomass), I (orks), E (defender counts), A (battle scale).
**Code touchpoints:** `scr_population_influence`, `scr_ork_planet_functions`, `scr_PlanetData`
(pop fields), turn tick (population growth pass), `scr_planet_heresy` (precedent for per-turn planet
state change).
**Complexity:** M. **Depends on:** ideally B (per-region pops) but works planet-level first.
**Open Qs:** one biomass pool per Nid fleet, or per contested planet?

### E. PDF / Guard rework + enemy force generation
**Idea:** PDF and Guard are pushovers right now. Draw enemy (and friendly) numbers from **held
systems** — "actual population × strength → produced force." Heretic worlds have little manufacturing,
so their output should reflect that.
**Design notes:** couples force strength to the economy/population model. Define a per-planet (or
per-region) "military output" derived from population, planet type, and buildings (C), then have
attackers/defenders draw from it. This is what makes A ("bigger battles") *earned* rather than
arbitrary.
**Ties to:** A, C, D, and F (governor fields these forces).
**Code touchpoints:** `scr_battle_Roster`, enemy AI (`scr_enemy_ai_a..e`), `p_pdf`/`p_guardsmen`
generation, `scr_system_spawn_functions`.
**Complexity:** M–L. **Depends on:** D (populations) for the inputs; C for the multipliers.
**Open Qs:** production per turn (stockpile) vs. instantaneous "muster on attack"?

### F. Warmaster / Sector Governor **mode** (playable)  ⭐ headline
**Idea (clarified):** *play as* a Sector Governor / Warmaster. Expand your **hold of influence**,
lead Guard forces into deployments, survive with what's available — and choose your path: stay the
**Imperial** way, or **break off** into independence/renegade or Chaos (→ G, H).
**Design notes:** this reframes the campaign around **influence + holdings** rather than a Chapter
roster. Mechanically it leans hard on the existing **influence system**
(`p_influence[planet][faction]`) and the Guard/Auxilia layer. Big pieces:
1. **New game-start / mode select** — pick "Chapter" (existing) or "Governor/Warmaster."
2. **Player as a faction actor** with influence to grow across a sector, holdings to manage.
3. **Guard-led deployments** — the player's main force is Auxilia, not Astartes (Astartes become
   *allies you petition*, inverting the current relationship).
4. **Allegiance track** feeding into G/H.
**Ties to:** G (renegade), H (chaos), A/E (leading big Guard battles), C/D (managing holdings).
**Code touchpoints:** new-game flow (`scr_chapter_new`, `scr_creation_home_planet_create`,
`scr_start_allow`/`scr_start_load`), influence (`scr_population_influence`),
management UI (`scr_management`, `scr_ui_manage`, `scr_gov_disp`), `scr_restart_variables`.
**Complexity:** XL (new pillar / mode). **Depends on:** benefits enormously from B, C, D, E existing
first — otherwise "governing" has little to govern. Best treated as the *destination*, with A–E as
the road.
**Open Qs:** how much of the Chapter UI is reused vs. a parallel management screen? Win/loss
conditions for a Governor?

### G. Renegade / independence (without Chaos)
**Idea:** you lose favour with the Imperium and decide *no, I won't die* — break away as an
independent/renegade power, without necessarily worshipping Chaos.
**Design notes:** an **allegiance/loyalty state** and its consequences: Imperial factions turn
hostile, you lose Imperial trade/reinforcement, gain freedom to recruit/trade with non-Imperial or
grey-market sources (→ H's refit merchant/navy ships). Reuses `HERETICS` faction plumbing but framed
as "independent," not Chaos.
**Ties to:** F (a path within the mode), H (ships/warbands), diplomacy.
**Code touchpoints:** `scr_diplomacy_helpers`, `scr_ui_diplomacy`, `scr_chaos_alliance_test`
(precedent for allegiance flips), disposition/`dispo`, `scr_star_ownership`.
**Complexity:** L. **Depends on:** F (or at least a loyalty variable) to hang off.
**Open Qs:** is renegade a slider (favour) or a discrete declaration? Can you return to the Imperium?

### H. Chaos reintroduction + unit diversity + warband/ship events
**Idea:** bring Chaos back properly.
- *Unit diversity:* today ~cultists/elite cultists. Add **cultists → traitor PDF → traitor Guard →
  Blood Pact**, and **per-Chaos-god troop lines**; if one god grows too big it triggers "Great Game"
  infighting (self-balancing).
- *Fleet/economy:* **refit merchant ships** for heretic/independent groups to use for
  fleet/expansion, mixing in **navy vessels** once large enough.
- *Events:* ignore a renegade long enough and a **Chaos warband shows up** to bolster them, recruit,
  etc.
**Design notes:** unit lines follow the Guard/Auxilia data pattern (profiles + wargear). Per-god
growth + Great Game is a light **AI/event rule** on top of `p_chaos`/`p_demons` populations. Warband
arrival is a random/triggered event.
**Ties to:** D (chaos populations), G (renegade attracts warbands), F (a path), CHAOSWARBAND planet
feature already in `eP_FEATURES`.
**Code touchpoints:** unit/wargear defs (follow Auxilia additions), `scr_enemy_ai_*`,
`scr_random_event`/`scr_event_code`, `scr_chaos_alliance_test`, ship defs
(`scr_player_ship_functions`, `scr_player_fleet_combat_functions`).
**Complexity:** L (unit lines are M; per-god Great Game + warband events add L). **Depends on:** D.
**Open Qs:** four full god rosters is a lot of art/stats — start with one line + traitor Guard?

### I. Ork adjustments
**Idea:** Orks should (a) actually fight Nids, and (b) target the biggest/fightiest force — *except*
Tau (too boring for the Orks).
**Design notes:** a **target-preference tweak** in ork AI: weight target selection by enemy
strength/"fightiness," add Nids as valid targets, de-prioritise Tau. Small, self-contained, and a
good early win that also helps curb the Nid/ork balance loop (J).
**Ties to:** J (orks curb the waaagh), D (ork spores/pops).
**Code touchpoints:** `scr_ork_fleet_functions`, `scr_ork_planet_functions`, enemy AI targeting
(`scr_enemy_ai_*`).
**Complexity:** S–M. **Depends on:** none (can do now). **Open Qs:** expose "fightiness" from
existing strength stats or add a metric?

### J. Nid reintroduction / rework
**Idea:** Nids get an **ascension-day cycle** — no overt takeover until the "dinner bell" rings:
a planet's genestealer cult builds up, then summons a **splinter** that grows by consuming the world
(cult + population + biomass). Nids then seek the **nearest large biomass source**. **Fleet growth
scales with biomass consumed**, favouring medium/large ships (escorts die too fast). Orks (post-tuning,
I) act as a counter to the waaagh/nid spread.
**Design notes:** the richest new-behaviour idea; sits directly on D (biomass) + existing
GENESTEALER faction + `GENE_STEALER_CULT`/`CAPILLARY_TOWERS`/`RECLAMATION_POOLS` planet features that
already exist. Phases: cult buildup (timer) → ascension trigger → splinter spawn → biomass-fed growth
→ nearest-biomass targeting → fleet scaling.
**Ties to:** D (biomass is the fuel), I (ork counter), B (region-by-region consumption), A (big
battles vs. swarms).
**Code touchpoints:** new nid behaviour script (precedent: `scr_ork_planet_functions`),
`scr_population_influence` (biomass), `scr_planet_heresy` (per-turn planet corruption is the pattern
to mirror for "consumption"), fleet spawn (`scr_system_spawn_functions`, `scr_ork_fleet_functions`).
**Complexity:** L–XL. **Depends on:** D (biomass/populations) is a hard prerequisite.
**Open Qs:** is ascension a global clock or per-planet cult maturity?

---

## 4. Dependencies at a glance

```
                 D. Populations/Biomass ──────┬──────────────► J. Nids
                        │                      │
   B. Planetary  ──►    ├──► E. Force gen ──►  A. Bigger battles
      Regions           │        │
        │               │        │
        └──► C. Buildings ───────┘
                                          F. Governor/Warmaster MODE ◄── (rests on B,C,D,E)
                                                 │
                                     ┌───────────┴───────────┐
                                 G. Renegade            H. Chaos units/ships/warbands
   I. Ork AI  ── (standalone, helps J) ─────────────────────────► curbs J
```

Reading: **B, C, D are the foundation.** E and A sit on them. **F is the destination** and wants
B–E in place. G/H are allegiance paths off F. **I is a free-standing early win.** J needs D.

---

## 5. Suggested build order (phased)

**Phase 0 — Free wins / warm-up (S–M, no hard deps)**
- I. Ork target-preference AI (fight Nids, chase the biggest, snub Tau).
- C-lite: add 1–2 new buildings to the existing `eP_FEATURES` framework to prove the pattern.

**Phase 1 — Foundation**
- B. Planetary regions (capital + 3) with rollup to legacy per-planet fields.
- D. Per-race population growth/decay + biomass accumulator.

**Phase 2 — Economy & scale**
- C. Full building tree (marine + planetary, type/flag gated) on region slots.
- E. Force generation from population/economy.
- A. Bigger battles, now fed by real numbers.

**Phase 3 — Threats**
- J. Nid ascension + biomass-scaled fleet (curbed by I).
- H. Chaos unit lines + refit/navy ships + warband events.

**Phase 4 — The mode**
- F. Playable Governor/Warmaster mode (influence + holdings + Guard-led play).
- G. Renegade/independence path; H's Chaos path wired into allegiance.

---

## 6. Recommended first slice

Pick a **thin vertical** that produces a visible result fast and de-risks the big items:

1. **Ork AI targeting (I)** — self-contained, immediately visible in play, and it's the balance lever
   the Nid plan later relies on.
2. **One new building end-to-end (C-lite)** — e.g. a **Training Field** (raises a squad XP cap) or a
   **Manufactory** (economic bonus): add the `eP_FEATURES` entry, its effect, a build hook, and a
   tooltip. This proves the build→effect→UI loop we'll reuse for the whole tree.

Either one is a 1–2 session job and teaches us the codebase's real conventions before we commit to
the L/XL structural work (regions, the mode).

---

## 7. Open questions to settle before big work

1. **Regions (B):** fixed 3 outlying regions, or scale with planet size/type? Can a single planet be
   simultaneously owned by multiple factions region-by-region?
2. **Economy model (C/E):** HOI4/Aurora-style production lines with build time + resources, or
   simpler instant/bonus buildings to start?
3. **Governor mode (F):** reuse the Chapter management UI, or build a parallel governor screen?
4. **Renegade (G):** gradual favour slider or a hard declaration? Path back to loyalty?
5. **Chaos scope (H):** one traitor line first, or commit to all four god rosters (art/stats cost)?
6. **Nid trigger (J):** global ascension clock vs. per-planet cult maturity?

---

*Next step: tell me which first slice to build (Ork AI or a first building), or pick a Phase to start
detailing into an implementation plan.*
