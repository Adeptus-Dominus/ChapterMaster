// Imperial Guard squad: how many guardsmen one Guard Squad unit represents.
// RESERVED (iteration 2): the Guard Squad system (this macro, the guard_squad template,
// scr_add_man, scr_marine_struct max_health(), scr_cheatcode, scr_roster, and the combat
// hook in scr_player_combat_weapon_stacks) is not used in normal play. Kept for planned
// reuse as heavy weapons teams. Do not delete.
#macro GUARD_SQUAD_SIZE 10

// Imperial Guard cover save: fraction of would-be ground-combat casualties treated as
// missed, standing in for spacing, terrain use and a low profile that the combat model
// does not simulate. Applied after armour, so it also blunts armour-piercing weapons
// (choppaz, power klawz) that ignore Flak entirely. 0 = no save, 0.4 = 40% fewer losses.
#macro GUARD_COVER_SAVE 0.4

// Imperial Guard auxilia screen: the front-most battle columns guardsmen are dealt across.
// Ten obj_pnunit columns exist (1 back to 10 front, higher column = nearer the enemy); the
// Marine and vehicle roles only use columns 1-7, so 8-10 are free front-most positions.
// Guardsmen are spread across these as separate positional blocks so the screen sits ahead of
// the Marines and engages the enemy in waves, instead of merging the whole regiment into one
// lasgun volley in the hire column. FIRST is the rear-most screen column, COUNT how many
// front columns the screen occupies (FIRST + COUNT - 1 must stay within the 10 columns).
#macro GUARD_SCREEN_COLUMN_FIRST 8
#macro GUARD_SCREEN_COLUMN_COUNT 3

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
    CHAPLAIN = 14,
    APOTHECARY = 15,
    TECHMARINE = 16,
    LIBRARIAN = 17,
    SERGEANT = 18,
    VETERANSERGEANT = 19,
    LANDRAIDER = 50,
    RHINO = 51,
    PREDATOR = 52,
    LANDSPEEDER = 53,
    WHIRLWIND = 54,
}
enum eMENU {
    DEFAULT = 0,
    MANAGE = 1,
    APOTHECARION = 11,
    RECLUSIAM = 12,
    LIBRARIUM = 13,
    ARMAMENTARIUM = 14,
    RECRUITING = 15,
    FLEET = 16,
    EVENT_LOG = 17,
    DIPLOMACY = 20,
    SETTINGS = 21,
    COMPANY_SETTINGS = 22,
    ROLE_SETTINGS = 23,
    FORMATIONS_SETTINGS = 24,
    GAME_HELP = 30,
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
    DEMON_WORLD
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
