global.list_basic_power_armour = [
    "MK7 Aquila",
    "MK6 Corvus",
    "MK5 Heresy",
    "MK8 Errant",
    "MK4 Maximus",
    "MK3 Iron Armour",
    "Power Armour",
];

global.list_terminator_armour = [
    "Terminator Armour",
    "Tartaros",
    "Cataphractii",
];

// Faction display names, indexed by eFACTION. The English values double as the localization
// keys. faction_names_en is the pristine English source and is NEVER mutated; faction_names is
// the live display array rebuilt from it on each language change, so switching back to English
// restores the original English names (an in-place mutation would lose them). Reads like
// global.faction_names[eFACTION.X] pick up the current language without a localize() call
// during draw.
global.faction_names_en = [
    "",
    "Your Chapter",
    "Imperium of Man",
    "Adeptus Mechanicus",
    "Inquisition",
    "Ecclesiarchy",
    "Eldar",
    "Orks",
    "Tau Empire",
    "Tyranid Hive",
    "Chaos",
    "Heretics",
    "Genestealer Cults",
    "Necron Dynasties",
];

global.faction_names = global.faction_names_en;

global.xenos_factions = [
    eFACTION.ELDAR,
    eFACTION.ORK,
    eFACTION.TAU,
    eFACTION.TYRANIDS,
];

global.fleet_move_options = [
    "move",
    "crusade1",
    "crusade2",
    "crusade3",
    "mars_spelunk1",
];

global.alliance_grades = [
    "Hated",
    "Hostile",
    "Suspicious",
    "Uneasy",
    "Neutral",
    "Allies",
    "Close Allies",
    "Battle Brothers",
];

global.chapter_name = "None";
global.game_seed = 0;
global.ui_click_lock = false;
global.base_component_surface = -1;

global.save_version = 0;
global.returned = 0;
global.debug = false;
global.load = 0;
global.cheat_req = false;
global.cheat_gene = false;
global.cheat_disp = false;
global.cheat_debug = false;
global.language = LANG_EN;

// Locale codes of shipped languages, and their display names in their own language.
global.available_languages = [LANG_EN, LANG_ZH];
global.language_display_names = {};
global.language_display_names[$ LANG_EN] = "English";
global.language_display_names[$ LANG_ZH] = "中文";

global.culture_styles = [
    "Greek",
    "Roman",
    "Knightly",
    "Gladiator",
    "Mongol",
    "Feral",
    "Flame Cult",
    "Mechanical Cult",
    "Prussian",
    "Cthonian",
    "Alpha",
    "Ultra",
    "Renaissance",
    "Blood",
    "Angelic",
    "Crusader",
    "Gothic",
    "Wolf Cult",
    "Runic",
];

global.force_strength_descriptions = [
    "None",
    "Minimal",
    "Sparse",
    "Moderate",
    "Numerous",
    "Very Numerous",
    "Overwhelming",
];

global.star_name_colors = [
    c_gray,
    c_white, // Player
    #7a7a7a, // Imperium
    #B22222, // Mechanicus
    c_white, // Inquisition
    c_white, // Ecclesiarchy
    #FF8000, // Eldar
    #009500, // Orks
    #FECB01, // Tau
    #AD5272, // Tyranids
    c_dkgray, // Chaos
    c_dkgray, // Heretics
    #AD5272, // why 12 is skipped in general, we will never know
    #80FF00, // Necrons
];

// Equipment slot keys, aligned with enum eEQUIPMENT_SLOT ordering.
global.unit_equip_slots = [
    "wep1",
    "wep2",
    "armour",
    "gear",
    "mobi",
    "all",
];

global.role_data_keys = [
    "wep1",
    "wep2",
    "armour",
    "gear",
    "mobi",
    "role",
    "available_to_player",
];

// Human-readable labels for equipment slots.
global.unit_equip_slots_display = [
    "First Weapon",
    "Second Weapon",
    "Armour",
    "Gear",
    "Back/Mobility",
    "ALL",
];

// Ordered quality tiers for equipment.
global.equipment_qualities = [
    "shoddy",
    "standard",
    "master_crafted",
    "artifact",
];
