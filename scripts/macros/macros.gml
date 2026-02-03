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
#macro SHOP_SELL_MOD 0.8
#macro LARGE_PLANET_MOD 1000000000 // Population threshold for large planet classification

#macro STR_ANY_POWER_ARMOUR "Any Power Armour"
#macro STR_ANY_TERMINATOR_ARMOUR "Any Terminator Armour"

// Basic, because we don't include Artificer Armour
#macro LIST_BASIC_POWER_ARMOUR ["MK7 Aquila", "MK6 Corvus", "MK5 Heresy", "MK8 Errant", "MK4 Maximus", "MK3 Iron Armour","Power Armour"]
#macro LIST_TERMINATOR_ARMOUR ["Terminator Armour", "Tartaros","Cataphractii"]
#macro FACTION_NAMES ["","Your Chapter", "Imperium of Man","Adeptus Mechanicus","Inquisition","Ecclesiarchy","Eldar","Orks", "Tyranid Hive","Tau Empire","Chaos","Heretics","Genestealer Cults", "Necron Dynasties"]
#macro XENOS_FACTIONS [6,7,8,9]

#macro FLEET_MOVE_OPTIONS ["move", "crusade1","crusade2","crusade3", "mars_spelunk1"]

#macro ALLIANCE_GRADES ["Hated", "Hostile","Suspicious","Uneasy","Neutral","Allies","Close Allies","Battle Brothers"]

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
    GAME_HELP = 30,
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
