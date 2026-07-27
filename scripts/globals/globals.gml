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

global.faction_names = [
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
global.language = "en";

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
