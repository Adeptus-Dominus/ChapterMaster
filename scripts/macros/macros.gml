// Imperial Guard squad: how many guardsmen one Guard Squad unit represents.
// RESERVED (iteration 2): the Guard Squad system (this macro, the guard_squad template,
// scr_add_man, scr_marine_struct max_health(), scr_cheatcode, scr_roster, and the combat
// hook in scr_player_combat_weapon_stacks) is not used in normal play. Kept for planned
// reuse as heavy weapons teams. Do not delete.
#macro GUARD_SQUAD_SIZE 10

// Imperial Guard heavy weapons team: how many guardsmen one Heavy Weapons Team unit represents.
// The team is a single pooled-HP entity (role "Heavy Weapons Team") crewing one heavy weapon, with
// the health of this many guardsmen (see scr_marine_struct max_health()). 3 = a 3-man weapons team.
#macro GUARD_HEAVY_WEAPONS_TEAM_SIZE 3

// Ground-combat cover save: fraction of would-be casualties treated as missed, standing
// in for spacing, terrain use and a low profile the combat model does not simulate.
// Rolled per incoming shot in damage_infantry, after armour, so it also blunts
// armour-piercing weapons that ignore Flak. A successful save posts a combat-log line.
// Astartes are bulky and hide poorly, so their save is much weaker than the Guard's.
#macro GUARD_COVER_SAVE 0.4
#macro MARINE_COVER_SAVE 0.15

// Guardsman veterancy: surviving a victory at the battle site earns GUARD_BATTLE_XP,
// and every kill made by Guard small-arms volleys awards GUARD_KILL_XP to one random
// surviving Guard there (the Alarm_7 kill lottery), so credit lands unevenly. At
// GUARD_VETERAN_XP total a basic Guardsman is eligible for Veteran promotion: pure
// survival takes ~18 victories (with 10 spawn XP: 16), while a trooper the lottery
// favours needs roughly 6 kills. No more whole-levy promotions after 4 battles.
// All three are tunable. (GUARD_BATTLE_XP/GUARD_VETERAN_XP were dropped twice: first
// in a646b5ccc, again in the 13-Jul-2026 merge resolution, crashing Alarm_7,
// scr_roster, and the guardxp cheat.)
#macro GUARD_BATTLE_XP 5
#macro GUARD_KILL_XP 15
#macro GUARD_VETERAN_XP 90

// Cover fades as the enemy closes: the save is scaled by shooter distance (block units,
// point_distance / 10). At or beyond COVER_SAVE_FULL_RANGE the full save applies; point
// blank it drops to COVER_SAVE_MIN_FACTOR of it, so hugging the line strips cover.
#macro COVER_SAVE_FULL_RANGE 10
#macro COVER_SAVE_MIN_FACTOR 0.25

// Anti-tank penetration is now a per-vehicle, cost-tiered weak-spot chance defined in
// vehicle_penetration_chance (scr_clean), not a weapon-AP formula: a capable shot rolls
// that chance to get through, so an armour-ignoring volley cannot brute-force a heavy hull
// (a Land Raider sits at 5%). Tune the chances there, per vehicle type.

// Formation order abilities. RETREAT_DAMAGE_MULT is the damage a retreating formation
// still takes (0.2 = 80% reduced) while it withdraws unable to fight back.
// DEVASTATOR_BRACED_MULT boosts a holding Devastator formation's ranged damage (braced
// heavy weapons). ASSAULT_JUMP_RANGE is how far (x units, 10 per column) an ordered
// Assault formation can leap to reach the enemy front in one bound.
#macro RETREAT_DAMAGE_MULT 0.2
// Caught in melee mid-rout, a retreating formation is cut down, not shielded:
// melee damage against retreaters is amplified instead of reduced.
#macro RETREAT_MELEE_MULT 1.5
// Movement passes the last fighting formation must hold before it may also
// retreat (the rear-guard delaying action), and where departed blocks wait
// off-field (past the -100 targeting bound).
#macro RETREAT_REARGUARD_HOLD 3
#macro RETREAT_ESCAPED_X -150
// Balance stabilisation for the population-driven faction levels: planet force
// levels now sit at 5-6 permanently on big worlds, which inflated tactical battle
// spawns far past the old "single engagement" scale (~1000 men). Clamp the level
// used for battle sizing; 7 (Enormicus) and raw garrison counts are untouched.
#macro ENEMY_BATTLE_THREAT_CAP 4
// Region commitment (assault balance): attacking an OUTLYING sector of a
// multi-region world engages only this share of the enemy's real headcount;
// they hold the rest back to garrison their other ground. Assaulting the
// CAPITAL, or a foe squeezed into a single region, meets the full force (and
// only there do enemy leaders such as an Ork Warboss take the field). Partial
// victories also cut the strategic level by 1 instead of 2 (obj_ncombat
// Alarm_5), so chipping outlying sectors is safer but slower than a
// decapitation strike.
#macro REGION_ASSAULT_COMMIT_FRACTION 0.35

// ---- Background sector war (Guard vs xenos/heretic attrition) ----
// Each turn, on every world where the Imperium (Guard/PDF) and a level-modelled enemy
// both have a presence, the off-screen war grinds the enemy down: the bulk of the enemy
// fights the sector's Guard while the player's marines mop up the elite. This is what
// erodes a 100k-Ork world over turns instead of leaving it a static stronghold. The
// player's own force is NEVER an input to this (see the Final Liberation note on region
// width): geography and the Guard presence decide it, not what the Chapter brings.
//   SECTOR_BACKGROUND_WAR_INTERVAL : turns between background attrition passes.
//   SECTOR_BACKGROUND_GUARD_TIER_*  : the p_guardsmen headcount bands that map to a 1-6
//                                     "Guard strength tier" for the attrition roll.
#macro SECTOR_BACKGROUND_WAR_INTERVAL 2
#macro SECTOR_BACKGROUND_GUARD_MIN 4000

// ---- Region width (fixed slice per region) ----
// A region fields a FIXED slice of the planet's enemy force, set by the region itself,
// not by the size of the attacking Chapter force. The capital fields the whole force;
// each outlying region fields REGION_WIDTH_SLICE_FRACTION of it. Bringing a larger
// tailored force clears the slice faster and safer but NEVER makes the enemy field more
// (the Final Liberation failure mode: scaling enemy width to player commitment punishes
// bringing force and collapses into min-maxing a tiny stack). This reuses the assault
// commitment fraction so the two stay identical.
#macro REGION_WIDTH_SLICE_FRACTION REGION_ASSAULT_COMMIT_FRACTION

// ---- Per-region garrison (combat width) ----
// The enemy's total headcount on a world is divided across its regions instead of the
// capital fielding everything: each OUTLYING region holds up to a capped share, and the
// CAPITAL holds the remainder (so it is always the strongpoint). The cap scales with world
// size (a fraction of the total) but never exceeds REGION_GARRISON_CEILING, so a small
// world's outlying regions hold a modest slice and a huge world's are capped at the ceiling.
// This makes clearing an outlying region a bounded objective and leaves the bulk in the
// capital as a visible reserve. See region_garrison.
#macro REGION_GARRISON_CEILING 10000
#macro REGION_GARRISON_FRACTION REGION_ASSAULT_COMMIT_FRACTION

// ---- Orbital Gun Array (capital planetary defence) ----
// The gun array watches the approaches: attacking a gun-world from orbit (bombard, raid,
// or a ship-launched ground assault) against ANY region except the designated safe
// landing zone risks a ship each time. The safe zone is the outlying region farthest
// from the capital (highest region index): you can bombard it to clear it, then land
// there and advance overland toward the capital (Vraks-style). Landing on the safe zone,
// or acting once your troops are already planetside, never triggers the guns.
//   ORBITAL_GUN_SHIP_LOSS_CHANCE : chance a hostile orbital action provokes the guns.
//   On a hit: 50% the ship is destroyed, 50% badly damaged. Target priority
//   frigate > capital > escort (the guns pick the valuable, killable target).
#macro ORBITAL_GUN_SHIP_LOSS_CHANCE 0.9
#macro ORBITAL_GUN_DAMAGE_MIN 0.2
#macro ORBITAL_GUN_DAMAGE_MAX 0.6

// ---- Enemy (Tau) Orbital Gun Array doctrine ----
// The Tau defend their strongest, most populous worlds with orbital batteries (greater
// good): only Hive/Forge worlds they hold with real strength qualify, ranked by force tier
// then population. They maintain up to CAP total, built ONE AT A TIME each over BUILD_TURNS,
// so guns complete at ~turn 30/60/90 (no guns for the first ~30 turns). Lose one and they
// rebuild on their highest-ranked gun-less qualifying world. See tau_orbital_gun_tick.
#macro TAU_ORBITAL_GUN_CAP 3
#macro TAU_ORBITAL_GUN_BUILD_TURNS 30
// Necrons entomb a gauss-silo battery over NECRON_ORBITAL_GUN_BUILD_TURNS turns on each
// world they hold: slow to wake, but relentless once built. Ad Mech forge worlds are
// pre-fortified and always mount one. See tau_orbital_gun_tick.
#macro NECRON_ORBITAL_GUN_BUILD_TURNS 50

// ---- Imperial Navy fleet suggestions (Sector Governor) ----
// The Governor only takes fleet suggestions from a Chapter he trusts: his disposition must
// be ABOVE this to accept "hold / follow" orders (otherwise he politely refuses). A follow
// order lapses on its own after this many turns, returning the fleet to autonomous AI.
#macro NAVY_ORDER_MIN_DISPOSITION 50
#macro NAVY_FOLLOW_MAX_TURNS 40
// Each active fleet order (hold/follow) costs the Governor this much disposition (abuse
// avoidance: no infinite free orders). Cancelling ("As you were") is free.
#macro NAVY_ORDER_DISPOSITION_COST 2

// ---- T'au force cap ----
// The T'au conflate population and army (p_race_pop[TAU] is both), and a hive world seeded
// billions of "troops", making the war unwinnable. Cap the FIELDABLE T'au force to scale with
// world size (a small fraction of carrying capacity) but never exceed TAU_FORCE_CAP. On a world
// the T'au CAPTURED from the Imperium they raise no Fire Warriors from the human populace, only
// Gue'Vesa auxiliaries: a small fraction of the former PDF (TAU_GUEVESA_PDF_FRACTION), capped at
// TAU_GUEVESA_FORCE_CAP. Applied at planet_faction_pop (the single read all force paths use), the
// worldgen seed, and the growth cap. See tau_force_cap_for_world / planet_faction_pop.
#macro TAU_FORCE_CAP 2000000
#macro TAU_MILITARY_FRACTION 0.05
#macro TAU_GUEVESA_PDF_FRACTION 0.05
#macro TAU_GUEVESA_FORCE_CAP 200000

// ---- Dig In ----
// A force (player OR enemy) that holds a region for DIG_IN_TURNS consecutive turns without
// it changing hands entrenches: +1 fortification, capped at DIG_IN_FORT_CAP. Light cover /
// field works that make a settled position harder to take. Applies to both sides; the
// counter resets whenever the region changes hands. See regions_dig_in_tick.
#macro DIG_IN_TURNS 2
#macro DIG_IN_FORT_CAP 5
// Imperial worlds pass their raw Guard garrison through threat (population-scaled,
// sanity-capped at 1M strategically). A tactical battle fields at most this many of
// them; the rest are the garrison you are NOT fighting today.
#macro ENEMY_GUARD_BATTLE_CAP 1500
// Training Ground pacing: per-turn XP per ground, and the ceiling past which
// grounds teach nothing more (real fighting takes over from drills).
#macro TRAINING_GROUND_XP_PER_TURN 5
#macro TRAINING_GROUND_XP_CAP 45
// Taint trade ships ("Imperial Colonists" spreading heresy/cults): per-turn launch
// chance per corrupted world, the corruption floor required to export at all, and
// the sector-wide cap on such ships in flight at once.
#macro TAINT_EXPORT_CHANCE_PCT 4
#macro TAINT_EXPORT_MIN_CORRUPTION 75
#macro TAINT_EXPORT_MAX_IN_FLIGHT 2
// Building on allied (Imperial) worlds: POSITIVE DISPOSITION is the permission
// (they let the Chapter fortify) and also the leverage: at 100 disposition the
// locals cover this fraction of the construction bill.
#macro REGION_BUILD_INFLUENCE_DISCOUNT_MAX 0.5
// Construction License price: what the player pays the Sector Governor for build rights
// on ONE outlying region they do not yet own. Bought per region from the population
// screen; the full building set then unlocks there at the normal disposition-discounted
// price (see region_building_can_build / region_building_price).
#macro REGION_BUILD_LICENSE_COST 500
// Putting down a heretic revolt buys real peace: the world's corruption takes
// this cut, and no new cult can seed there for the cooldown, giving purge fleets
// their window instead of a fresh revolt every turn.
#macro HERETIC_CLEANSE_CORRUPTION_CUT 35
#macro HERETIC_RESEED_COOLDOWN 12
// Purges have their own per-fleet budget, independent of ground assaults: heresy
// grows every turn now, so cleansing must not compete with fighting for actions.
#macro PURGES_PER_FLEET_TURN 4
#macro DEVASTATOR_BRACED_MULT 1.25
#macro ASSAULT_JUMP_RANGE 30
// Minimum heresy/influence a purge that kills anyone removes. Keeps purges viable on
// hive worlds and against the Daemonic Incursion +2/turn heresy pump.
#macro PURGE_MIN_HERESY_DROP 3
// Sector war directives (Discuss button, Imperium diplomacy): cooldown between
// changes, disposition cost of a non-default order, and the per-turn effects.
#macro SECTOR_DIRECTIVE_COOLDOWN 10
// How long a non-default sector directive stands before it LAPSES back to "defend".
// A standing war order is a commitment the Guard march to, not a permanent setting:
// after this many turns the Sector Commander's regiments have finished the campaign
// he was given and revert to holding the core worlds until the player issues fresh
// orders. Must exceed SECTOR_DIRECTIVE_COOLDOWN so a directive never lapses while the
// player is still barred from renewing it. (See sector_directive_tick.)
#macro SECTOR_DIRECTIVE_DURATION 50
#macro SECTOR_DIRECTIVE_DISPO_COST 3
#macro SECTOR_DIRECTIVE_STRIKE_INTERVAL 6
#macro SECTOR_RECLAIM_INTERVAL 8
#macro SECTOR_DEFEND_PDF_GROWTH 100
#macro SECTOR_DEFEND_PDF_CAP 6000

// Range accuracy/damage falloff for ranged fire. Damage is scaled by how far the target
// is relative to the weapon's range: at point blank it gets RANGE_POINT_BLANK_BONUS, and
// it falls by up to RANGE_FALLOFF at maximum range, floored at RANGE_MIN_MULT. Short-range
// weapons (Shotgun, Flamer) can only ever fire close, so they live in the bonus band and
// hit hard; long-range weapons soften at the edge of their reach. Melee and wall fire are
// exempt. Applied to dealt damage in scr_shoot.
#macro RANGE_POINT_BLANK_BONUS 1.25
#macro RANGE_FALLOFF 0.5
#macro RANGE_MIN_MULT 0.6

// Imperial Guard auxilia screen: the front-most battle columns guardsmen are dealt across.
// Ten obj_pnunit columns exist (1 back to 10 front, higher column = nearer the enemy); the
// Marine and vehicle roles only use columns 1-7, so 8-10 are free front-most positions.
// Guardsmen are spread across these as separate positional blocks so the screen sits ahead of
// the Marines and engages the enemy in waves, instead of merging the whole regiment into one
// lasgun volley in the hire column. FIRST is the rear-most screen column, COUNT how many
// front columns the screen occupies (FIRST + COUNT - 1 must stay within the 10 columns).
#macro GUARD_SCREEN_COLUMN_FIRST 8
#macro GUARD_SCREEN_COLUMN_COUNT 3

// Enemy target preference: the minimum weapon armour pierce (apa, scale 0-4) that counts as
// "anti-tank" and so hunts vehicles in obj_enunit\Alarm_0. Weapons below this prefer infantry
// and only turn to vehicles as a fallback. 3 splits dedicated anti-tank (rokkit / lascannon /
// melta tier) from general-purpose and anti-infantry guns. Raise toward 4 to make only the
// heaviest guns chase tanks; drop toward 1 for the old behaviour where almost everything did.
#macro GUARD_ENEMY_ANTITANK_AP 3

// Column piercing (both sides): when a front block has no men (an armour wall), an
// anti-infantry volley pushes through by depth instead of dumping into the wall. The
// volley reaches at most PIERCE_MAX_DEPTH lines, front included. Every armour line it
// passes soaks PIERCE_LINE_SOAK of the ORIGINAL volley as bounced chip fire, and
// everything still travelling lands on the first men-bearing line. Through one wall
// ~66% of the shots reach the infantry, through two walls ~33%, and infantry behind
// three or more lines cannot be reached at all. Men-behind-men screening is unchanged:
// a front block with men in it still absorbs the whole volley.
#macro PIERCE_LINE_SOAK 0.33
#macro PIERCE_MAX_DEPTH 3

// Basic combat orders: an advancing block that finds a friendly block directly
// ahead may leapfrog over it, landing on the first free slot beyond, probing at
// most this many columns. It never lands on or vaults past an enemy block.
#macro PLAYER_LEAPFROG_MAX_COLUMNS 6

// Ship assault economy: how many ground assaults each ship can support per turn. The old
// rule capped the whole fleet at 2 attacks per turn regardless of size, so deploying
// everything on every assault cost nothing. Now each carrying ship supports this many
// assaults per turn, one use spent per assault it contributes units to; bigger fleets
// can clear a system in one turn, but every launch spends real capacity. Raids, purges,
// and bombardment keep their old fleet-level rules.
// Assault economy, split by APPROACH so a gun-world landing is a real phase:
//  - ORBITAL (dropping troops from ships, under the guns) is limited to one strike per turn,
//    so you cannot spam landings from orbit.
//  - GROUND (fighting from an established foothold; see Hold Ground) allows several strikes
//    per turn, rewarding a beachhead: land once, then grind forward on the ground.
// SHIP_ASSAULTS_PER_TURN is kept as an alias of the ORBITAL cap for any legacy call site.
#macro ORBITAL_ASSAULTS_PER_TURN 1
#macro GROUND_ASSAULTS_PER_TURN 3
#macro SHIP_ASSAULTS_PER_TURN ORBITAL_ASSAULTS_PER_TURN
// Disposition drop a full indiscriminate fire purge (100% of the population burned)
// inflicts on a world's regard for the Chapter. Scaled down by the actual share killed
// per purge, so a light burn costs a little and a total one costs this much. Selective
// purges (targeted heretics) and governor assassinations carry no penalty. Tune down
// toward 0 to soften, up for harsher consequences.
#macro PURGE_FIRE_DISPO_PENALTY 40

// Eldar craftworld hunt. The hidden craftworld and the full Eldar battle roster have
// always been in the game; what was missing is any way for Eldar to appear (nothing
// ever raised p_eldar on normal worlds) and any realistic way to find the craftworld
// (a 5% roll when parking a fleet within 300px of an invisible star). Now an Eldar
// warhost strikes an inhabited world on a random cadence between ELDAR_INTERVAL_MIN
// and ELDAR_INTERVAL_MAX turns; each ground
// victory against them yields one piece of intelligence, and at ELDAR_INTEL_REQUIRED
// pieces the craftworld is revealed for invasion. Warhost strength starts at
// FORCE_BASE and ramps by one per clue collected up to FORCE_MAX, keeping max-tier
// Eldar for the craftworld itself (its garrison is 6). ELDAR_FLEET_ENABLED gates the
// craftworld's orbiting fleet, disabled for now so the reveal never forces Eldar
// naval combat; flip to 1 to restore it. Gathered intelligence goes stale after
// ELDAR_CLUE_EXPIRY turns: the clues are lost and the craftworld slips away to a new
// hidden location, so it must be located, reached and assaulted within that window.
#macro ELDAR_INTERVAL_MIN 20
#macro ELDAR_INTERVAL_MAX 50
#macro ELDAR_CLUE_EXPIRY 400
#macro ELDAR_INCURSION_FORCE_BASE 3
#macro ELDAR_INCURSION_FORCE_MAX 5
#macro ELDAR_INTEL_REQUIRED 3
#macro ELDAR_FLEET_ENABLED 1
// Warhosts prefer worlds touched by the Great Enemy: a planet with heresy, chaos or
// traitor presence is this many times likelier to be struck than a clean one. The
// Eldar do not do proportionality: on a tainted world the warhost stays and scours
// it each incursion tick, culling ELDAR_PURGE_POP_FRACTION of the population and
// ELDAR_PURGE_DEFENSE_FRACTION of the PDF and Guard while purging the taint, so
// leaving them to "clean up chaos for you" costs the world its people and clearing
// them off is a real choice. On clean worlds the warhost withdraws after one
// interval (its "secret mission" done) instead of garrisoning the sector forever.
#macro ELDAR_TAINT_SPAWN_WEIGHT 5
#macro ELDAR_PURGE_POP_FRACTION 0.25
#macro ELDAR_PURGE_DEFENSE_FRACTION 0.5

// Eldar naval combat tuning. Vanilla Eldar ships move at spid 60-100 while every other
// faction's ships run 20-45, which is why fights against them degenerate into endless
// chase loops. This multiplier scales the whole Eldar speed table; at 0.65 they run
// 39-65, still comfortably the fastest ships in the game but catchable. 1.0 restores
// vanilla darting.
#macro ELDAR_SHIP_SPEED_MULT 0.65

// Guard volley size: how many rank-and-file guardsmen share one firing stack in combat. The
// regiment splits into capped stacks of this size instead of merging into one giant lasgun
// volley, so each chunk fires and targets independently like an enemy obj_enunit block (those
// run ~32-40 strong). They still deploy as one movable hireling line; this only affects firing.
// Lower for more, smaller volleys; raise toward one big stack. Keep it from making too many
// stacks: a block has 71 stack slots shared with every other weapon.
#macro GUARD_VOLLEY_SIZE 100


// Imperial Guard accuracy ("doom"): mirrors the enemy's per-faction doom in scr_shoot (the
// owner == eFACTION.IMPERIUM branch, e.g. Orks 0.2, Tyranids 0.4). Massed lasgun fire from raw
// conscripts connects far less than disciplined Astartes fire, so the guard's ranged lasgun
// volleys have their effective shots scaled by this fraction before damage. The player branch
// divides damage_per_weapon by wep_num rather than the scaled count, so per-shot damage is
// untouched and the cut is linear: the volley still fires in full but only this share lands.
// 1 = no reduction (marine-grade, also what Elite Cultists fire at), 0.35 = roughly a third of
// the lasguns connect. Kills scale about linearly with this value, so 0.7 is roughly double the
// effectiveness of 0.35 with no change to damage or penetration.
#macro GUARD_DOOM 0.7

#macro MAX_STC_PER_SUBCATEGORY 6
#macro DEFAULT_TOOLTIP_VIEW_OFFSET 32
#macro DEFAULT_LINE_GAP -1
#macro LB_92 "############################################################################################"
#macro DATE_TIME_1 $"{current_day}-{current_month}-{current_year}-{format_time(current_hour)}{format_time(current_minute)}{format_time(format_time(current_second))}"
#macro DATE_TIME_2 $"{current_day}-{current_month}-{current_year}|{format_time(current_hour)}:{format_time(current_minute)}:{format_time(current_second)}"
#macro DATE_TIME_3 $"{current_day}-{current_month}-{current_year} {format_time(current_hour)}:{format_time(current_minute)}:{format_time(current_second)}"
#macro TIME_1 $"{format_time(current_hour)}:{format_time(current_minute)}:{format_time(current_second)}"
#macro CM_GREEN_COLOR #34bc75
#macro CM_RED_COLOR #bf4040
#macro COL_REQUISITION #2398F8
#macro COL_FORGE_POINTS #af5a00

#macro MANAGE_MAN_SEE 34
#macro MANAGE_MAN_MAX array_length(obj_controller.display_unit) + 7
#macro LARGE_PLANET_MOD 1000000000 // Population threshold for large planet classification

// Ground combat message log: lines the display fully drains per turn (so the end-of-turn status
// line shows even on long battles), and the per-stage frame timeout before force-advancing.
#macro COMBAT_LOG_CAPACITY 500
#macro COMBAT_STAGE_TIMEOUT_FRAMES 1200
// Battle-log message_priority colour codes (extends the existing 134/135/137 set).
#macro MSG_COLOR_WHITE 140
#macro MSG_COLOR_LIGHTGREEN 141

#macro STR_ANY_POWER_ARMOUR "Any Power Armour"
#macro STR_ANY_TERMINATOR_ARMOUR "Any Terminator Armour"

// Basic, because we don't include Artificer Armour
global.list_basic_power_armour = ["MK7 Aquila", "MK6 Corvus", "MK5 Heresy", "MK8 Errant", "MK4 Maximus", "MK3 Iron Armour","Power Armour"];
global.list_terminator_armour = ["Terminator Armour", "Tartaros","Cataphractii"];
global.faction_names = ["","Your Chapter", "Imperium of Man","Adeptus Mechanicus","Inquisition","Ecclesiarchy","Eldar","Orks", "Tyranid Hive","Tau Empire","Chaos","Heretics","Genestealer Cults", "Necron Dynasties"];
global.xenos_factions = [6,7,8,9];

global.fleet_move_options = ["move", "crusade1","crusade2","crusade3", "mars_spelunk1"];

global.alliance_grades = ["Hated", "Hostile","Suspicious","Uneasy","Neutral","Allies","Close Allies","Battle Brothers"];

#macro SHIP_WEAPON_SLOTS 8

enum eFACTION {
    NONE = 0,
    PLAYER = 1,
    IMPERIUM,
    MECHANICUS,
    INQUISITION,
    ECCLESIARCHY,
    ELDAR,
    ORK,
    TAU,
    TYRANIDS,
    CHAOS,
    HERETICS,
    GENESTEALER,
    NECRONS = 13
}


enum eGENDER {
    FEMALE,
    MALE,
    NEUTRAL
}

function set_gender(){
    return choose(eGENDER.FEMALE, eGENDER.MALE);
}
enum eROLE {
    NONE = 0,
    CHAPTERMASTER = 1,
    HONOURGUARD = 2,
    VETERAN = 3,
    TERMINATOR = 4,
    CAPTAIN = 5,
    DREADNOUGHT = 6,
    CHAMPION = 7,
    TACTICAL = 8,
    DEVASTATOR = 9,
    ASSAULT = 10,
    ANCIENT = 11,
    SCOUT = 12,
    BIKER = 13,
    CHAPLAIN = 14,
    APOTHECARY = 15,
    TECHMARINE = 16,
    LIBRARIAN = 17,
    SERGEANT = 18,
    VETERANSERGEANT = 19,
    ATTACK_BIKER = 20,
    LANDRAIDER = 50,
    RHINO = 51,
    PREDATOR = 52,
    LANDSPEEDER = 53,
    WHIRLWIND = 54
}
enum eMENU {
    DEFAULT = 0,
    MANAGE = 1,
    TURN_END = 2,
    WELCOME_SCREEN1 = 3,
    WELCOME_SCREEN2 = 4,
    WELCOME_SCREEN3 = 5,
    WELCOME_SCREEN4 = 6,
    APOTHECARION = 11,
    RECLUSIAM = 12,
    LIBRARIUM = 13,
    ARMAMENTARIUM = 14,
    RECRUITING = 15,
    FLEET = 16,
    EVENT_LOG = 17,
    FESTIVAL = 18,
    DIPLOMACY = 20,
    SETTINGS = 21,
    COMPANY_SETTINGS = 22,
    ROLE_SETTINGS = 23,
    FORMATIONS_SETTINGS = 24,
    GAME_HELP = 30,
    CHAPTER_MASTER = 50,
    SECRET_LAIR = 60
}

enum eLUCK {
    BAD = -1,
    NEUTRAL = 0,
    GOOD = 1
}

enum eINQUISITION_MISSION {
    PURGE,
    INQUISITOR,
    SPYRER,
    ARTIFACT,
    TOMB_WORLD,
    TYRANID_ORGANISM,
    ETHEREAL,
    DEMON_WORLD,
    RANDOM = 100,
}

enum eEVENT {
    //GOOD
    SPACE_HULK,
    PROMOTION,
    STRANGE_BUILDING,
    SORORITAS,
    ROGUE_TRADER,
    INQUISITION_MISSION,
    INQUISITION_PLANET,
    MECHANICUS_MISSION,
    //NEUTRAL
    STRANGE_BEHAVIOR,
    FLEET_DELAY,
    HARLEQUINS,
    SUCCESSION_WAR,
    RANDOM_FUN,
    //BAD
    WARP_STORMS,
    ENEMY_FORCES,
    CRUSADE,
    ENEMY,
    MUTATION,
    SHIP_LOST,
    CHAOS_INVASION,
    NECRON_AWAKEN,
    FALLEN,
    //END
    NONE
}

enum eIN_GAME_MENU_EFFECT {
    SAVE = 11,
    LOAD = 12,
    OPTIONS = 13,
    EXIT = 14,
    RETURN = 15,
    BACK_FROM_SAVELOAD = 18,
    BACK_FROM_SETTINGS = 25,
    CLOSE_SAVELOAD = 30
}

// Overkill spill from a wiped enemy formation only reaches a formation standing
// directly behind it (touching columns, 10px apart; 15 tolerates float jitter). An
// air gap stops the spill: neither hammer blows nor the torrent of fire leap across
// open ground to a formation two rows back.
#macro OVERKILL_SPILL_MAX_GAP 15

// Battle formation box (the green-framed battlefield on the right half of the combat
// screen) and the vertical center the formation columns build around. The box was a
// fixed 235..666 (431 tall) while a single column is 400 tall centered on 450 and a
// STACK of formations in one column sums all its segments, so multi-segment stacks
// overflowed the frame top and bottom (tester screenshot). Enlarged to use nearly the
// full 900-tall screen, and columns/stacks now build around BATTLE_FIELD_CY and clamp
// to BATTLE_FIELD_H (see obj_pnunit / obj_enunit Draw, and the frame in Draw_0).
#macro BATTLE_FIELD_X1 818
#macro BATTLE_FIELD_X2 1578
#macro BATTLE_FIELD_Y1 40
#macro BATTLE_FIELD_Y2 838
#macro BATTLE_FIELD_CY 439
#macro BATTLE_FIELD_H  798
// Largest a single formation segment draws; a stack taller than the field is scaled to
// fit so every segment stays visible and clickable instead of spilling past the frame.
#macro BATTLE_SEG_MAX 400
