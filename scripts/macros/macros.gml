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

// Ground combat message log: per-stage frame timeout before force-advancing.
#macro COMBAT_STAGE_TIMEOUT_FRAMES 1200

// Offmap shove distance for non-combatant fleets during battle resolution; must exceed room size so they read as !in_room().
#macro FLEET_BATTLE_DISPLACEMENT 100000

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
    IMPERIUM = 2,
    MECHANICUS = 3,
    INQUISITION = 4,
    ECCLESIARCHY = 5,
    ELDAR = 6,
    ORK = 7,
    TAU = 8,
    TYRANIDS = 9,
    CHAOS = 10,
    HERETICS = 11,
    GENESTEALER = 12,
    NECRONS = 13,
    _COUNT
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
    RANDOM = 100
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
