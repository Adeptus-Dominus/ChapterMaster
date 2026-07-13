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

// Guardsman veterancy: a Guardsman who fights at the battle location and survives earns
// GUARD_BATTLE_XP experience per victory. At GUARD_VETERAN_XP total they become eligible
// for promotion to Veteran Guard, so a trooper must live through roughly
// GUARD_VETERAN_XP / GUARD_BATTLE_XP battles (90 / 25 ~= 3-4). Both are tunable.
// (Restored twice: first dropped in a646b5ccc, then lost again in the 13-Jul-2026
// upstream merge resolution while obj_ncombat Alarm_7, scr_roster, and the guardxp
// cheat still read them, crashing any battle a Guardsman survived.)
#macro GUARD_BATTLE_XP 25
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
#macro DEVASTATOR_BRACED_MULT 1.25
#macro ASSAULT_JUMP_RANGE 30

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
#macro SHIP_ASSAULTS_PER_TURN 2
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
#macro ELDAR_INTERVAL_MIN 30
#macro ELDAR_INTERVAL_MAX 60
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
