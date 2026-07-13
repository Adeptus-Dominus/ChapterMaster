# Populations, Biomass & Force Generation — Design & Build Plan

*Roadmap items **D** (populations/biomass) and **E** (force generation), plus the "unhook the 0–6
enemy sizes" rework. Ork-first. This doc is the spec to build from; no code has been written for it
yet. Written against a full read of the current systems (see "Current systems", below).*

---

## 1. Goal in one paragraph

Give each **race a real population** on each world (and Tyranids a **biomass** pool), have those
pools **grow, spread and get consumed** over time, and have **battle forces and attack waves be
drawn from them** instead of from the abstract 0–6 "force level." End state: an Ork world that has
been festering for 40 turns fields a genuinely larger WAAAGH than one just seeded; a Tyranid splinter
that has eaten three hive worlds is a fleet-scaling menace. Do it **without a big-bang rewrite** of
the fragile 3,400-line combat file — populations become authoritative, the legacy 0–6 level becomes a
*derived* value (exactly the Option-A pattern the regions layer already uses), and the hardcoded
combat ladders get replaced **one faction at a time**, Orks first.

**The unified end-state (where all the races are headed):** every side — attacker or defender —
musters exactly **what it actually has on the world**: its per-region population, its `p_pdf` /
`p_guardsmen`, its race / biomass pool. All of it flows through **one shared generator**
(`spawn_from_counts`) driven by a **per-faction lore recipe** (§9). No abstract 0–6 tiers, no nominal
pools or muster rates — what is present is what takes the field. Orks are the pilot that proves the
pattern; PDF, Guard, Tau, Nids and the rest are the same machine with different recipes.

---

## 2. Current systems (what we're changing)

Two independent "size" currencies exist today:

**Ground: the 0–6 force level.** Per-planet arrays on `obj_star` — `p_orks`, `p_tau`, `p_tyranids`,
`p_chaos`, `p_traitors`, `p_necrons`, `p_eldar`, `p_sisters` — each an abstract tier 0–6 (clamped in
`scr_star_ownership.gml` lines 18–22; the canonical writer `PlanetData.edit_forces`/`add_forces`,
`scr_PlanetData.gml` ~325–361, clamps 0–12). Surfaced as `PlanetData.planet_forces[eFACTION]`
(`scr_PlanetData.gml` 49–66 / 305–320). This level is the **only** signal for "how much of this race
is here."

**The 0–6 → battle units mapping** lives in `obj_ncombat/Alarm_0.gml` (~3,469 lines): one
`if (enemy == eFACTION.X)` block per faction, each a ladder of `if (threat == 1)` … `if (threat == 6)`
tiers with **hand-authored** squad lists (e.g. Orks threat 6 = a fixed "WAAAGH of 11000" built from
two duplicated waves). `obj_ncombat.threat` is set in exactly two places:
`scr_drop_select_function.gml` (~378–426, from the planet's 0–6 `p_*` value) and
`obj_turn_end/Mouse_56.gml` (~165–169, from `planet_forces[enemy]`).

**The one existing exception — Imperial Guard.** For `enemy == eFACTION.IMPERIUM`, `threat` is a
**real headcount** (up to 1,000,000) and Alarm_0 (lines 530–617) *derives* units by division:
`guardsmen = round(threat/50)`, `Leman Russ = round(threat/10000)`, `Basilisk = round(threat/50000)`,
etc. **This is the template for everything below.**

**Space: ship counts.** Enemy fleets (`obj_en_fleet`) carry `capital_number/frigate_number/
escort_number` that accrete a few ships per turn per AI roll (`scr_enemy_ai_c` Chaos, `scr_PlanetData`
Necron, `scr_ork_fleet_functions` Orks, `obj_controller/Alarm_1` Eldar). Fleet size is **decoupled**
from the 0–6 ground level. When a fleet arrives it raises the ground 0–6 level; the NPC-vs-NPC ground
war in `scr_enemy_ai_a` (84–1203) escalates/de-escalates those levels with `choose(1..6) * score`.

**Populations today.** `p_population` / `p_max_population` / `p_large` / `p_pop` are a **single
loyalist-civilian** figure per world (seeded by type in `obj_star/Alarm_1.gml`); `p_pdf` /
`p_guardsmen` are the Imperial military derived from it (`military = p_population/470`, split 75/25).
Growth: `PlanetData.end_turn_population_growth` (+0.08%/turn) only on Imperial worlds with **no** xenos
presence. Shrink: consumed by Necrons (×0.75), Orks (×0.97), zeroed by Tyranids at level ≥5.
**There is no per-race population and no biomass anywhere.** The nearest per-faction continuum is
`p_influence[planet][faction]` (0–100).

**Takeaway:** the seam is narrow. `PlanetData.planet_forces` + `edit_forces`/`add_forces` is the one
choke point translating pools ↔ force levels; `obj_ncombat.threat` has only two setters; the Guard
block is a working "headcount → units" example. That is what makes a phased approach feasible.

---

## 3. New state (the D layer)

**Locked decisions (from design review):**

- **Absolute headcounts for every faction.** The Imperial-Guard model (`threat` = real headcount,
  units derived by division) is the model for *all* races — attacker and defender alike. One unit,
  one set of math, `spawn_from_counts` shared everywhere.
- **Populations live PER REGION**, not per planet. Each race's headcount sits in the specific
  region(s) it occupies, so forces genuinely spread out and each race's expansion is a region-by-
  region affair driven by its behaviour profile (§7). The planet 0–6 level is the *rollup → derived*
  value for legacy code.
- **Tyranid biomass** is a per-planet pool (Nids are mass, not a per-region garrison).
- **Civilians vs combatants.** A race's population is mostly **civilian**; only a **combatant
  fraction** takes the field. The Imperium already does exactly this (`p_population` civ →
  `military = pop/470` → PDF/Guard). Battle musters the **combatants** ("what's there"); the civ pool
  is the base that breeds them, grows, and gets consumed/taxed. **Total-war races are the exception:**
  Tyranids (every bioform fights) and largely Orks (the whole mob fights; Gretchin are the nearest
  thing to a civ underclass) field ~all their population. So each race profile carries a **levy rate**
  (civ → combatants) or a **total-war** flag.

Storage (all `p_*` / on the region struct, so it serialises with the existing save code):

- **`Region.race_pop`** — per region, an array/struct indexed by `eFACTION` holding an integer
  headcount for each race present in that region. Lives on the `Region` record (saves inside
  `p_regions`, like `buildings`/`gun_mastered`). Lazy-init via a `region_race_pop_ensure` helper for
  old saves.
- **`p_race_pop[planet]`** — a per-planet **rollup cache** (sum of each faction across the planet's
  regions), rebuilt from the regions each turn. Convenience for planet-scale readers; not
  authoritative.
- **`p_biomass[planet]`** — the Tyranid biomass pool. `p_*` array, auto-serialised.

**Seeding & calibration.** At worldgen (`obj_star/Alarm_1.gml`, after the 0–6 levels are set) and
lazily for old saves: seed each occupied region's `race_pop` from `level_to_count(faction,
p_<race>[planet])` split across the regions that race holds. Calibrate the count↔level anchors to the
*existing* Alarm_0 tiers so day-one feel is unchanged (Orks: L1≈100, L2≈350, L3≈1,000, L4≈3,600,
L5≈7,000, L6≈11,000 — read straight off the current ladder). Faction **starting postures** (§7)
override the naive seed for Orks/Tau at map-gen.

---

## 4. The bridge (Phase 2 — make the old system population-driven without touching combat)

Invert today's dependency so the **pool is authoritative and the 0–6 level is derived** — the same
Option-A move the regions overlay already uses:

- `count_to_level(faction, count)` and `level_to_count(faction, level)` (anchor-table lookups,
  monotonic, clamped 0–6).
- Each turn (or inside `edit_forces`/a small `race_forces_sync`), set
  `p_<race>[planet] = count_to_level(faction, p_race_pop[planet][faction])`. The legacy combat, the
  NPC war, ownership flips, and threat-setting all keep working **unchanged** — they just now read a
  level that reflects real populations.
- Growth/decay code (ork spread, heretic escalation, Necron/Tyranid consumption) is retargeted to
  add/remove from the **pool**; the level follows automatically. Reductions on player victory: the
  post-battle flow lowers the level today; in Phase 2 it lowers the **pool** by the count the battle
  represents, and the level re-derives.

After Phase 2 the game is fully playable and every battle already scales with real populations — the
only thing still abstract is the 6-rung granularity inside Alarm_0.

---

## 5. The unhook (Phase 3 — Orks first)

Replace a faction's `if (threat==1..6)` ladder in `obj_ncombat/Alarm_0.gml` with **count-derived
generation**, exactly like the Guard block:

- Threat carries the **count** for unhooked factions (set `threat = p_race_pop[planet][ORK]` in the
  two threat-setters, gated by a per-faction `force_from_population(faction)` flag so un-migrated
  factions keep using the 0–6 value).
- The Ork block computes squads by division off the count, e.g. (numbers to be tuned against the
  current tiers): `boyz = round(pop * 0.6)`, `ard_boyz = round(pop * 0.2)`, `gretchin = round(pop *
  0.25)`, `nobz/meganobz = round(pop / 130)`, `deff_dread = round(pop / 300)`, `battlewagon =
  round(pop / 600)`, `warboss` present above a threshold, split across multiple `obj_enunit` waves
  above a cap so the battlefield stays readable. Calibrate so `pop≈11000` reproduces roughly today's
  threat-6 WAAAGH.
- A shared helper (generalise the Guard pattern) — `spawn_enemy_from_counts(unit_table, pop)` — so
  each faction's block becomes a small data table + one call, not 250 lines of hand-authoring. This
  is the reusable primitive that makes migrating the *other* factions cheap and low-risk later.

Do Orks, prove it in play, then Nids (biomass-fed), then the rest, leaving each un-migrated faction on
its old ladder the entire time.

---

## 6. Ork pilot — specifics

- **Ork population pool** grows on Ork-held worlds toward a per-type cap (fungal bloom). Reuse
  `grow_ork_forces` (`scr_PlanetData.gml` ~527–594) but grow `p_race_pop[planet][ORK]` instead of the
  level; the level derives.
- **Livestock bonus** ("using x race as livestock"): while Orks hold a world with a surviving captive
  `p_population`, ork growth is boosted and the captive population is consumed faster (extend the
  existing `population * 0.97` cull). More captives → faster WAAAGH.
- **Spore spread**: on high ork pop, seed a small `p_race_pop[neighbour][ORK]` on an adjacent world
  (reuse the existing ork-spread-to-neighbour logic, `scr_PlanetData` ~ line 588).
- **Fleets & waaagh**: keep the existing ork fleet spawn (gated today by level ≥4 in
  `scr_ork_fleet_functions`); re-gate on an ork-pop threshold so big populations launch bigger/more
  frequent WAAAGH fleets. (Full space-size-from-population is a later unification — see §8.)
- **Battle**: the Alarm_0 Ork block becomes count-derived (per §5). This is the one combat-core edit
  in the pilot and gets an isolated review + smoke test.

---

## 7. Faction behaviour & starting states

Every race shares the count→units combat model; what differs is its **behaviour profile** — how its
per-region population grows, spreads, consumes and attacks. Each faction gets a small profile the
turn-tick reads.

**Orks — the rising WAAAGH.** Start **~1–5 years into their growth cycle**: an established but
not-yet-maxed ork population that is *just beginning to attack the locals*. Seed ork worlds with a
mid-range `race_pop` (not level 1, not maxed) flagged "cracking open." Behaviour: fungal bloom (grow
in held regions toward a per-type cap); **livestock** — consume captive population (loyalist first)
for accelerated growth; **spore-spread** to an adjacent region/world when pop is high; launch WAAAGH
fleets / ground assaults on neighbours above a threshold. Aggressive, expansionist, consumes.

**Tau — the expanding enclave.** Start **owning their worlds, clustered together** (a Tau bloc in one
area of the sector, as they seed in the map today). Behaviour: consolidate, grow population, then
**expand reach outward** — push influence into and annex adjacent worlds region by region
(assimilate, don't exterminate). Methodical outward growth from the cluster; low consumption of
captives.

**Later profiles (stubs).** Tyranids: consume population → biomass → ascend → splinter fleet (item
J). Chaos/Heretics: corrupt population → traitor PDF/Guard. Necrons: awaken → cull. Eldar: raid,
rarely hold. Each is a behaviour profile over the same population/count machinery.

**Interactions — populations meeting populations.** This is the real reframe. *Today:* a fleet
arriving **dumps force** (bumps the 0–6 level — tyranid ships set `p_tyranids`, `grow_ork_forces`
raises `p_orks`); the NPC-vs-NPC ground war is resolved abstractly in `scr_enemy_ai_a` (~84–1203) as
`choose(1..6) × score` comparisons that decrement the loser's level; and consumption is scattered
special-cases (orks `×0.97`, Necrons `×0.75`, Nids zero the pop at level ≥5). *New model:* a fleet
arrival **drops a population** — a beachhead / spore-drop seeded into a region's race pool, not a
level. From there the pools **interact directly**: grow, spread, **consume** each other and the locals
(orks eat the populace as livestock; Nids eat everything → biomass), and **contest** regions (reusing
the conquest overlay). NPC-vs-NPC battles become **pool vs pool** — each side musters what it actually
has through the shared recipe, and the loser's pool takes the real casualties — replacing the abstract
score fight. This folds the scattered growth / consume / war special-cases into one "populations
interacting" layer.

*Needs a review pass before Phase 2:* map `scr_enemy_ai_a` (the NPC war), the fleet-arrival deposit
sites (`obj_en_fleet` orbit logic, `grow_ork_forces`, tyranid ship logic), and every
population-consumption site, so each is retargeted from "adjust the 0–6 level" to "add/consume the
region pool."

---

## 8. Fielding the forces — the PDF unit & marines as a multiplier

**The PDF unit (new content).** For "Orks attacking the locals" to be a real fight, the locals need a
fieldable unit. Add a **PDF trooper**: a *less-proficient Imperial Guardsman* — human, light/flak
armour, autogun (or a worse lasgun), a lower ballistic/stat line, and few or no organic heavy
weapons/sergeants. Build it the way the fork already added Guard content (unit profile + wargear via
the Auxilia layer; use the Guardsman implementation as the template). The loyalist force is **whatever
is actually there** — read straight off the world's real counts, not a nominal pool or muster rate:
the region's **`p_pdf`** (PDF, always present) through the same count→units generator, **plus
`p_guardsmen` only if Guard are deployed there.** So a loyalist defence = mass **PDF** (weak) + any
deployed **Guard** (better) + optional Astartes. Used both in player-defended battles and as the local
defenders when an NPC race (Orks) assaults a populated world.

> Calibration note: the existing Guard combat block actually fields ~10% of its headcount as line
> Guardsmen (`T/10`) with vehicles scaled off the full `T` (see §9). "Use what's there" means the
> **source** is the real `p_pdf`/`p_guardsmen`; whether we field all of it or keep a scale-down like
> the Guard block's is a per-unit calibration knob (the sim handles either, since it's counts).

**The Imperial pipeline (civ → PDF → tithe → Guard).** Lore-accurate *and* it matches the existing
`/10`: a world's **civilians** raise a **base PDF** for local defence (lore ≈ **0.5% of population**;
the game currently uses ~`pop/470`). The **Imperial Tithe** then trains **one-tenth of the PDF** — the
best of them — into **Astra Militarum (Guard)** regiments that deploy off-world. So the chain is
**civ → PDF (local, always present) → Guard ≈ PDF/10 (tithed, deployable, better)**. That is the Guard
block's `/10`, now with a lore reason behind it.

**Lore scale — think millions, not thousands.** Real 40K numbers dwarf the current ~11k combat cap:

- **Hive world:** each hive **10–100 billion**, 5–20 hives → often **>1 trillion** per world; a
  population doubles ~every 100 years.
- **PDF ≈ 0.5% of population** — a civilised world's PDF runs from ~**20 million** up into the
  **billions**.
- **Guard regiment: 10,000–80,000** typically (siege regiments 250,000+), raised as ~**1/10 of PDF**.
- **Ork WAAAGH: millions** typically, **billions** at its worst (War of the Beast).

So an Ork incursion seeds a population in the **millions**, and a mature WAAAGH is a millions-strong
combatant pool. The numeric sim handles that fine, but it hard-confirms the two combat tasks from §13:
a **display rescale** (a strength bar can't cap at ~800 men when forces are millions) and **counts,
never per-model**. Net effect: the whole scale shifts **upward** from today's tiers — the count↔level
anchors (§4) map the current L1–L6 onto the *lower* end of the real range and extend far past it.

**Marines & elites — real units that tip the balance.** Combat is a **numerical simulation** — counts
trading firepower, numbers beating numbers. Nothing is rendered model-by-model: each unit type carries
a **count** (a Boy stack of 280,000 is just the number 280,000), and resolution is firepower ×
resilience × count on each side. Astartes stay a headcount too, with their real elite stats, deployed
in their actual small numbers. Because the sim weighs quality against quantity, a small Marine force
**adds its devastation to the field and tips the balance** — but it is **not an auto-win**: a few
thousand Marines cannot out-damage a million-strong green tide on their own. They swing a close fight,
not a hopeless one.

---

## 9. Force-composition recipes (lore)

`spawn_from_counts` needs, per faction, a **composition recipe** — which units, in what ratios, with
thresholds for leaders / vehicles / elites — so a headcount produces a **lore-accurate** force that
scales smoothly. The current Alarm_0 tiers already encode rough compositions; this turns those fixed
tiers into ratio-based recipes and validates/expands them against 40K lore (this is also where "more
unit diversity" lands).

**Orks (pilot) — a WAAAGH is Boyz-heavy with a Warboss on top.** For a green count `P`, roughly:

- **Boyz** are the bulk — Slugga (melee) + Shoota (ranged), ~60% of `P`, split into mobs.
- **Gretchin** expendable fodder, ~15–25% of `P` (more on big worlds).
- **'Ard Boyz** a tougher slice (~10%).
- **Nobz / Meganobz** the elite core, ~1 per ~130 Boyz.
- **Warboss** — one, above a WAAAGH threshold (a real WAAAGH has a boss); **Big Mek / Weirdboy**
  occasionally at higher counts.
- **Vehicles** scale with `P` — Trukks/Battlewagons, Deff Dreads/Killa Kans, a Stompa only on the
  largest WAAAGHs.
- **Specialists** at higher counts — Kommandos, Tankbustas, Flash Gitz.

This matches the units the Ork block already spawns, so the pilot is "ratio-ise + validate," not
invent from scratch.

**Ork recipe — the numbers.** `P` = total Ork headcount on the field. Calibrated so `P≈100`
reproduces today's threat-1 and `P≈11000` today's threat-6. Every unit below already exists in the
Ork combat block, so this is **no new content** — just re-expressing the fixed tiers as continuous
ratios. Two pieces: the **mob** (a share of `P`) and the **retinue** (a count derived from `P`,
switched on by a threshold).

*Mob — shares of `P`, normalised across whichever rows are active at that `P`:*

| Unit | Share | Appears when | Role |
|---|---|---|---|
| Shoota Boy | 28% | always | ranged bulk |
| Slugga Boy | 25% | always | melee bulk |
| 'Ard Boy | 20% | `P ≥ 150` | tougher line |
| Gretchin | 25% | `P ≥ 1500` | expendable fodder |

*Retinue — `1 per N`, switched on by a threshold:*

| Unit | Rule | Appears when | Role |
|---|---|---|---|
| Nob / Meganob | 1 per 130 boyz (min 1) | always | elite core |
| Flash Git | 1 per 150 | `P ≥ 800` | shooty elite |
| Mekboy | 1 per 1250 | `P ≥ 800` | support |
| Deff Dread / Killa Kan | 1 per 180 | `P ≥ 800` | walkers |
| Battlewagon / Trukk | 1 per 400 | `P ≥ 800` | armour / transport |
| Tankbusta | 1 per 75 | `P ≥ 5000` | anti-tank |
| Kommando | 1 per 350 | `P ≥ 5000` | infiltrators |

*Boss:*

| Unit | Rule |
|---|---|
| Nob warlord | leads the mob while `P < 300` (no full Warboss yet) |
| Warboss | 1, once `P ≥ 300` (a real WAAAGH has a boss) |
| Big Warboss + 2–3 extra waves | `P ≥ 9000` — the mob is split across multiple `obj_enunit` waves, capped by the boss's retinue (today's threat-6 behaviour by hand) |

**Rules & calibration:**

- **Normalise the mob shares** over whichever rows are active: below `P=150` it's just Shoota/Slugga
  (~53/47 → ≈50/50 at `P=100`, matching L1); at `P ≥ 1500` all four fill `P` (~28/25/20/25, matching
  L4–L5).
- **Unit rows are a sim structure, not a picture.** Each unit type is one `obj_enunit` carrying a
  count; huge counts are just numbers. The current threat-6 tier splits a WAAAGH across a few
  `obj_enunit` waves for the *volley/column resolution*, not for visuals — keep such splits only where
  the combat math needs them.
- **Checks:** `P=100` → ~50 Shoota / 47 Slugga / 1 Nob ≈ L1. `P≈1000` → +'Ard, Warboss, first
  Dreads/Wagons/Mek/Flash Gitz ≈ L3. `P≈7000` → +Gretchin, Tankbustas, Kommandos ≈ L5. `P≈11000` →
  Big Warboss + waves ≈ L6.

**Sketches for the rest (to detail later):**

- **PDF** — mass conscripts with autoguns, sparse heavy weapons, weak officers, the odd Sentinel.
  Low quality, high number. *(New unit — §8.)*
- **Imperial Guard** — Guardsmen (lasgun) + Sergeants + Heavy Weapon Teams + Chimera / Leman Russ /
  Basilisk. Already in the fork.
- **Tau** — Fire Warriors (Strike/Breacher) as the line, Kroot auxiliaries as screen/melee,
  Pathfinders, Crisis/Broadside Battlesuits as elites, drones throughout, an Ethereal to lead,
  Devilfish/Hammerhead armour. Fewer bodies, more range and tech.
- **Tyranids** — a swarm recipe scaling with **biomass**: Termagants/Hormagaunts as the tide, Warriors,
  big beasts (Carnifex) and synapse (Tyrant) at high biomass (item J).
- **Chaos/Heretics, Necrons, Eldar** — later; each a recipe over the same machinery.

**Content gap:** PDF is new, and each faction may want a few more unit profiles/wargear for variety
(the braindump's "unit diversity"). Recipes are data tables feeding `spawn_from_counts`, so adding a
unit = a table row + a profile, not combat-code surgery.

---

## 10. Build order & the seams to touch

| Phase | Work | Files / seams | Risk |
|---|---|---|---|
| 1 | Per-region `race_pop` on `Region` + `p_biomass`; ensure/seed helpers; `pops` debug cheat; Ork/Tau **starting postures** at map-gen | `scripts/Region/Region.gml`, `obj_star/Alarm_1.gml`, new `scr_population_functions`, `scr_cheatcode` | Low (additive) |
| 2 | Bridge: planet 0–6 level derived from the region rollup; **behaviour profiles** (Ork bloom/livestock/spore, Tau expand) retargeted to grow/spread the region pools; victory drains the pool | `scr_PlanetData` (`edit_forces`/`planet_forces`/growth fns), `scr_star_ownership`, `scr_enemy_ai_a/b`, `scr_ork_fleet_functions` | Medium (strategic layer) |
| 3 | **PDF unit** (new content, weak Guardsman) + generalise the Guard headcount→units block into a shared `spawn_from_counts`; defender side draws PDF (`p_pdf`) + Guard (`p_guardsmen`) | Guard/Auxilia unit + wargear defs, `obj_ncombat/Alarm_0.gml` (Guard block 530–617 as template) | Medium–High |
| 4 | Unhook **Orks** (attacker) via `spawn_from_counts` from a lore recipe (§9); `threat` carries the count; **mass rendered as capped stacks**, Marines/elites stay real units adding their devastation | `obj_ncombat/Alarm_0.gml` (Ork block 1305–1560; existing stack-capping), the 2 threat-setters | **High** (combat core) |
| 5+ | Nids (biomass → force → fleet, item J), then Tau/Chaos/Necrons/Eldar combat blocks | same seams, one block at a time | High, but incremental |

---

## 11. Questions — settled & still open

**Settled (design review):**

- **Scale & source:** absolute headcounts, and the count is **what's actually there** — PDF from the
  region's `p_pdf`, Guard from `p_guardsmen` (only if deployed on that world), each hostile race from
  its region pool. Literal numbers read off the real state, **not** a nominal pool / muster rate.
  (Whether a unit fields all of its count or a scale-down like the Guard block's `T/10` is a
  per-unit calibration knob.) ✔
- **Storage:** **per-region** race populations (`Region.race_pop`), planet level is a derived rollup. ✔
- **Elites:** combat is a **numerical sim** (counts trading firepower); Marines/elites stay **real
  headcount units** with elite stats and add their devastation to tip the balance — *not* an auto-win.
  No model rendering, so no "readability cap" — the mass is just big numbers. ✔
- **Starting postures:** Orks seed ~1–5 yrs into growth "cracking open" the locals; Tau seed as
  clustered world-owners expanding outward. ✔
- **New unit:** a **PDF trooper** (weak Guardsman) is required so locals can fight. ✔
- **Civ vs combatants:** a population is mostly civilian; battle musters only the **combatant
  fraction** (a per-race levy rate), *except* **total-war** races (Tyranids, Orks) that field ~all of
  it. ✔

**Still open:**

1. **World-type caps.** Max `race_pop` per region by planet type/size (how big can a hive-world
   WAAAGH get)?
2. **Count↔level anchors.** Confirm the exact table (Orks L1≈100 … L6≈11000 from the current ladder)
   so the Phase-2 bridge changes nothing in feel.
3. **Livestock rules.** Which captive population feeds Ork growth — only loyalist `p_population`, or
   any non-Ork pop (other xenos too)? Does the captive race matter to the rate?
4. **PDF stat line.** How much weaker than a Guardsman — autogun vs lasgun, BS/armour values, any
   heavy weapons at all?
5. **Large-count handling (the sim, not visuals).** Does the volley/column resolution and its
   performance hold up at counts in the hundreds of thousands / millions? Where do the current
   `obj_enunit` row/column limits bite, and do we cap or scale in the *math*?
8. **Composition recipes (lore).** The per-faction unit tables in §9 need lore validation/expansion —
   which units, what ratios, thresholds for leaders/vehicles/elites, and which don't exist yet.
6. **Space unification.** Should fleet ship counts eventually derive from population/biomass too (one
   currency), or stay separate? (Lean separate for now; revisit with the Nid biomass→fleet loop.)
7. **Threat overloading.** During migration `threat` = a level for some factions, a count for others;
   confirm a per-faction `force_from_population` flag as the switch, and note the Alarm_0 story
   overrides that set `threat = 2/3` become "small/medium" count presets.

---

## 12. Risks & mitigations

- **`obj_ncombat/Alarm_0.gml` is the fragile combat core, 3.4k lines, no compiler here.** Mitigation:
  the pool/level bridge (Phase 2) leaves it untouched; Phase 3 migrates **one faction at a time** with
  the rest on their old ladders, each migration isolated behind `spawn_enemy_from_counts` + an
  independent review + a new-galaxy smoke test.
- **Balance drift.** Anchor every count↔level and count→units mapping to the *existing* tier headcounts
  so day-one behaviour matches; tune afterwards.
- **Save/load.** New `p_*` arrays serialise automatically; `race_pop_ensure` back-fills old saves,
  seeding from their current 0–6 levels. No bespoke save code (same guarantee the regions layer uses).
- **Two threat meanings during migration.** The `force_from_population` per-faction flag keeps
  un-migrated factions bit-for-bit identical.

---

## 13. Combat from the player's seat (review)

How a ground battle actually plays, and what changes when forces come from populations (confirmed by
reading the combat objects).

**What it is.** A top-down **numeric skirmish on one line**. Each side is a set of vertical bars on a
centre line (`obj_ncombat/Draw_0`); a bar's **height = the stack's strength**, and its **count shows
only on hover** in a right-hand composition panel (`scr_punit_combat_heplers.block_composition_string`
→ e.g. "1240x Total; 800 Guardsmen, 200 Scouts…"). No models, no map — numbers beating numbers.

**What the player does.** Almost entirely **press Enter to advance the round and read the combat
log** (`obj_ncombat/KeyPress_13`, a 5-step `timer_stage` cycle; stages 2/4 auto-resolve on a timer).
The only in-fight input is **clicking a column to toggle advance/hold** (`obj_pnunit/Step_0`) — no
mid-fight targeting or retreat. The real choices are **pre-battle** on the drop screen: which
companies/ships/squads to commit, the target race, ship bombardment, and a **formation** (a cycling
choice of saved 10-column layouts). Feedback is the scrolling combat log (casualty lines from
`scr_flavor`) plus an "Enemy Forces at X%" readout each round.

**What already scales (good).** Resolution is pure count arithmetic — `damage / hp = kills`, clamped
to what's present (`scr_shoot`); `enemy_forces/enemy_max` unbounded. **Enemies are stored as counts**
(`dudes_num[]`), so a 1,000,000-Ork battle resolves correctly and the hover panel prints "1000000x
Total" fine.

**What breaks at population scale (the extra Phase 3/4 work):**

1. **Bar height saturates at ~800.** `draw_size = min(400, column_size)`, `column_size = men*0.5 + …`
   — every stack past ~800 men draws the *same* full bar; you can't see 800 vs 1,000,000. Needs a
   rescale (log, or relative-to-largest-stack) so scale is legible.
2. **Fixed 10 player columns** (`obj_ncombat/Create_0` builds exactly 10) — populations funnel into
   10 bars; fine numerically, but the display hides scale.
3. **Player mass must be COUNTS, not per-model.** The player side rebuilds stacks by scanning
   `unit_struct` **one struct per model every turn** (`scr_player_combat_weapon_stacks`) — O(N) per
   model. Marines (~1,000 in a Chapter) are fine, but **mass PDF/Guard drawn from populations must be
   represented as counts** (like the enemy `dudes_num`), or thousands of per-model structs hang the
   turn. Reinforces §8: **elites = real units (few structs), mass = counts.**
4. Minor structural caps: ≤30 ranks and a 71-slot type array per column (limits unit *variety* per
   column, not counts), vehicle array = 1500, Guard volley-chunking at 100.

**Implication for the plan.** The player *experience* doesn't change — still "commit forces, pick a
formation, Enter through the rounds, read the log." Force generation just changes the numbers flowing
in, which the resolution already handles. The extra work beyond the §9 recipe is **(a) a display
rescale so big battles read**, and **(b) representing player-side mass (PDF/Guard) as counts** so the
turn doesn't choke — both land in Phase 3/4.

---

## 14. Companion docs

- `docs/DESIGN_ROADMAP.md` — items **D** (populations/biomass) and **E** (force generation) this plan
  fulfils, plus **J** (Nids) which the biomass pool feeds.
- `docs/REGIONS.md` — the Option-A "authoritative scalar, derived overlay" pattern reused here
  (pool authoritative, 0–6 level derived).
- `docs/SECTOR_GOVERNOR_PLAN.md` — overall state/handoff.
