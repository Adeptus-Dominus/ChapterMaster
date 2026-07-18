/*
    Creates all instances and logic for the game, 
    This is the MAIN script to load in the actual game UI and where most if not all MISC Stuff from the game is:
    NOTE from old Duke:

    Welcome to the project file for Chapter Master.  As of December
    2014 I will be attempting to add documentation across this file
    in order to facilitate the transfer of development.  This comment
    in particular will give you a rundown on the most key parts of
    Chapter Master.  Burn it to memory and it will help smooth out
    development.
    
    
    The main objects that you will probably be concering yourself
    with are as follows:
    
    obj_ini: Handles all of the marine, ship, and vehicle variables.
    It is first created after going through the main menu and
    finilizing chapter creation.
    
    obj_controller: Misc variables, is the focus of the room view,
    and draws the vast majority of the user interface.
    
    obj_popup: Draws and handles all of the popup stuff (such as
    random events, confirmation boxes, changing equipment, etc.)
    
    
    In addition to these objects, there are also a multitude of
    scripts.  They are split into a number of folders for different
    categories and relatively clean access.
    
    Sys: Utility functions that should be included within frikkin'
    Game Maker.  Stuff like drawing dotted lines, adding comas to
    numbers, exploding a banana string into multiple variables.
    
    Combat: Anything that relates to things dying goes in here.
    Note that the scr_weapon script also handles the tooltips for
    weapons and their stats, until it is cleaned up and rewritten.
    
    Interface: This contains all of the long, probably uneccesary
    scripts for drawing the UI.  The controller object executes these
    in the draw function when certain criteria is met.
    
    Turn: All of the end-of-turn AI, random events, and actions
    pertaining to ending turn go in here.  Note that the enemy AI
    is split further into a handful of different scripts, designated
    as A, B, C, D, and E.  These are all ran on each star object each
    turn.
        A: Enemy ground combat
        B: Rebellions, number increases, spreading
        C: Enemy production of ships
        D: Local random event happenings
        E: Enemy space combat and quening player battles
    Note that the alarm5 event of the controller also has some turn
    end scripts- this one handles the END of END of turn for variables
    and crap that is not neccesarily pertaining to a local star or planet.
    
    Diplomacy: Everything related to quests, trading, dialogue, and 
    names goes into this folder.  The scr_dialogue in particular is
    the main script that contains all of the dialogue writing for
    each enemy race.
    
    Root Folder: All of the frequently-accessed scripts that don't
    fall neatly into the other folders go on top.  The most important
    ones to take note of are scr_chapter (contains all the presets),
    chapter_random (randomizes the chapter), scr_initialize_custom
    (executed by obj_ini to generate the actual chapter arrays), and
    scr_loyalty (either calculates the loyalty or changes it on
    demand).  Check equipment, add items, add man, add vehicle, and add
    artifact are also in this root folder, and frequently used.
    
    The Machine God watches over you.
*/

var _name_gen = global.name_generator;
LOGGER.info("Creating Controller");
scr_colors_initialize();
is_test_map = false;
target_navy_number = 5;
global.sound_playing = undefined;
global.defeat = 0;
tutorial = 0;
sound_in = 0;
sound_to = "";
fix_right = 0;
text_bar = 0;
bar_fix = false;
last_attack_form = 1;
last_raid_form = 3;
double_click = 0;
double_was = 0;
last_weapons_tab = 1;
complex_event = false;
current_eventing = "";
chaos_rating = 0;
chapter_made = 0;
// obj_cuicons.alarm[1]=1; // Clean up custom icons
map_scale = 1;
scale_mod = 1;
unit_manage_constants = {};
unit_manage_constants.current_data = "";
management_buttons = false;
display_unit = undefined;

diplo_buttons = {};
diplomacy_pathway = "";
option_selections = [];
ready = false;

// Role Init
var _arrays_count = 103;
var _empty_array = [];

LOGGER.info("Set Game Arrays and Statics");
r_race = array_create_advanced(_arrays_count, _empty_array);
r_role = array_create_advanced(_arrays_count, _empty_array);
r_wep1 = array_create_advanced(_arrays_count, _empty_array);
r_wep2 = array_create_advanced(_arrays_count, _empty_array);
r_armour = array_create_advanced(_arrays_count, _empty_array);
r_gear = array_create_advanced(_arrays_count, _empty_array);
r_mobi = array_create_advanced(_arrays_count, _empty_array);

var _empty_size = 21;
r_race[100] = array_create(_empty_size, 0);
r_role[100] = array_create(_empty_size, "");
r_wep1[100] = array_create(_empty_size, "");
r_wep2[100] = array_create(_empty_size, "");
r_armour[100] = array_create(_empty_size, "");
r_gear[100] = array_create(_empty_size, "");
r_mobi[100] = array_create(_empty_size, "");

var _roles_data = {};

_roles_data[$ eROLE.HONOURGUARD] = {
    name: "Honour Guard",
    w1: "Power Sword",
    w2: "Bolter",
    arm: "Artificer Armour",
    mob: "",
    gear: "",
};
_roles_data[$ eROLE.VETERAN] = {
    name: "Veteran",
    w1: "Chainsword",
    w2: "Bolter",
    arm: STR_ANY_POWER_ARMOUR,
    mob: "",
    gear: "",
};
_roles_data[$ eROLE.TERMINATOR] = {
    name: "Terminator",
    w1: "Power Fist",
    w2: "Storm Bolter",
    arm: "Terminator Armour",
    mob: "",
    gear: "",
};
_roles_data[$ eROLE.CAPTAIN] = {
    name: "Captain",
    w1: "Power Sword",
    w2: "Bolt Pistol",
    arm: STR_ANY_POWER_ARMOUR,
    mob: "",
    gear: "Iron Halo",
};
_roles_data[$ eROLE.DREADNOUGHT] = {
    name: "Dreadnought",
    w1: "Close Combat Weapon",
    w2: "Twin Linked Lascannon",
    arm: "Dreadnought",
    mob: "",
    gear: "",
};
_roles_data[$ eROLE.CHAMPION] = {
    name: "Champion",
    w1: "Power Sword",
    w2: "Bolt Pistol",
    arm: STR_ANY_POWER_ARMOUR,
    mob: "",
    gear: "Combat Shield",
};
_roles_data[$ eROLE.TACTICAL] = {
    name: "Tactical Marine",
    w1: "Bolter",
    w2: "Combat Knife",
    arm: STR_ANY_POWER_ARMOUR,
    mob: "",
    gear: "",
};
_roles_data[$ eROLE.DEVASTATOR] = {
    name: "Devastator Marine",
    w1: "",
    w2: "Combat Knife",
    arm: STR_ANY_POWER_ARMOUR,
    mob: "",
    gear: "",
};
_roles_data[$ eROLE.ASSAULT] = {
    name: "Assault Marine",
    w1: "Chainsword",
    w2: "Bolt Pistol",
    arm: STR_ANY_POWER_ARMOUR,
    mob: "Jump Pack",
    gear: "",
};
_roles_data[$ eROLE.ANCIENT] = {
    name: "Ancient",
    w1: "Company Standard",
    w2: "Power Sword",
    arm: STR_ANY_POWER_ARMOUR,
    mob: "",
    gear: "",
};
_roles_data[$ eROLE.SCOUT] = {
    name: "Scout",
    w1: "Sniper Rifle",
    w2: "Combat Knife",
    arm: "Scout Armour",
    mob: "",
    gear: "",
};
_roles_data[$ eROLE.CHAPLAIN] = {
    name: "Chaplain",
    w1: "Power Sword",
    w2: "Bolt Pistol",
    arm: STR_ANY_POWER_ARMOUR,
    mob: "",
    gear: "Rosarius",
};
_roles_data[$ eROLE.APOTHECARY] = {
    name: "Apothecary",
    w1: "Chainsword",
    w2: "Bolt Pistol",
    arm: STR_ANY_POWER_ARMOUR,
    mob: "",
    gear: "Narthecium",
};
_roles_data[$ eROLE.TECHMARINE] = {
    name: "Techmarine",
    w1: "Power Axe",
    w2: "Storm Bolter",
    arm: "Artificer Armour",
    mob: "Servo-arm",
    gear: "",
};
_roles_data[$ eROLE.LIBRARIAN] = {
    name: "Librarian",
    w1: "Force Staff",
    w2: "Storm Bolter",
    arm: STR_ANY_POWER_ARMOUR,
    mob: "",
    gear: "Psychic Hood",
};
_roles_data[$ eROLE.SERGEANT] = {
    name: "Sergeant",
    w1: "Chainsword",
    w2: "Storm Bolter",
    arm: STR_ANY_POWER_ARMOUR,
    mob: "",
    gear: "",
};
_roles_data[$ eROLE.VETERANSERGEANT] = {
    name: "Veteran Sergeant",
    w1: "Chainsword",
    w2: "Storm Bolter",
    arm: STR_ANY_POWER_ARMOUR,
    mob: "",
    gear: "",
};

var _role_keys = struct_get_names(_roles_data);
var _max_id = 0;

for (var k = 0, _kl = array_length(_role_keys); k < _kl; k++) {
    _max_id = max(_max_id, real(_role_keys[k]));
}

for (var i = 101; i < 103; i++) {
    var _target_size = _max_id + 1;

    r_role[i] = array_create(_target_size, "");
    r_wep1[i] = array_create(_target_size, "");
    r_wep2[i] = array_create(_target_size, "");
    r_armour[i] = array_create(_target_size, "");
    r_mobi[i] = array_create(_target_size, "");
    r_gear[i] = array_create(_target_size, "");

    for (var j = 0, jl = array_length(_role_keys); j < jl; j++) {
        var _key = _role_keys[j];
        var _id = real(_key);
        var _data = _roles_data[$ _key];

        r_role[i][_id] = _data.name;
        r_wep1[i][_id] = _data.w1;
        r_wep2[i][_id] = _data.w2;
        r_armour[i][_id] = _data.arm;
        r_mobi[i][_id] = _data.mob;
        r_gear[i][_id] = _data.gear;
    }
}

// ** Sets cheatcode values **
cheatcode = "";
cheatyface = 0;
if (is_test_map) {
    global.cheat_debug = true;
}

// ** Sets play variables **
info_fragments = 0;
play_time = 0;
play_second = 0;
invis = false;

otha = 0;
zoomed = 0;
spr_custom1 = 0;
spr_custom2 = 0;
spr_custom3 = 0;
spr_custom4 = 0;
force_scroll = 0;
homeworld_rule = 1;
demanding = 0;
select_wounded = 1;
terra_direction = floor(random(360)) + 1;

load_game = 0;
good_log = 0;

// Line
l_options = 0;
l_menu = 0;
l_manage = 0;
l_settings = 0;
l_apothecarium = 0;
l_reclusium = 0;
l_librarium = 0;
l_armoury = 0;
l_recruitment = 0;
l_fleet = 0;
l_diplomacy = 0;
l_log = 0;
l_turn = 0;
current_planet_feature = 0;
// Highlight
h_options = 0;
h_menu = 0;
h_manage = 0;
h_settings = 0;
h_apothecarium = 0;
h_reclusium = 0;
h_librarium = 0;
h_armoury = 0;
h_recruitment = 0;
h_fleet = 0;
h_diplomacy = 0;
h_log = 0;
h_turn = 0;
// Relative Y
y_slide = 0;
new_banner_x = 0;
hide_banner = 0;
// ui stuff
menu_lock = false;
menu_buttons = {
    "chapter_manage": new MainMenuButton(spr_ui_but_1, spr_ui_hov_1,,, ord("M"), scr_toggle_manage),
    "chapter_settings": new MainMenuButton(spr_ui_but_1, spr_ui_hov_1,,, ord("S"), scr_toggle_setting),
    "apoth": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3,,, ord("A"), scr_toggle_apothecarion),
    "reclu": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3,,, ord("R"), scr_toggle_reclu),
    "lib": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3,,, ord("L"), scr_toggle_lib),
    "arm": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3,,, ord("N"), scr_toggle_armamentarium),
    "recruit": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3,,, ord("T"), scr_toggle_recruiting),
    "fleet": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3,,, ord("F"), scr_toggle_fleet_area),
    "diplo": new MainMenuButton(spr_ui_but_2, spr_ui_hov_2,,, ord("D"), scr_toggle_diplomacy),
    "event": new MainMenuButton(spr_ui_but_2, spr_ui_hov_2,,, ord("O"), scr_toggle_event_log),
    "end_turn": new MainMenuButton(spr_ui_but_2, spr_ui_hov_2,,, ord("E"), scr_end_turn),
    "help": new MainMenuButton(spr_ui_but_4, spr_ui_hov_4,,, ord("H"), scr_in_game_help),
    "menu": new MainMenuButton(spr_ui_but_4, spr_ui_hov_4,,,, scr_in_game_menu),
};

helpful_places_button = new UnitButtonObject({
    style: "pixel",
    label: "System Data",
});

helpful_places = false;

instance_create(x, y, obj_planet_map);
new_button_highlight = "";
// new_button_highlighting=0;
new_buttons_hide = 0;
new_buttons_frame = 0;

// ** Sets tooltips **
tooltip = "";
tooltip_stat1 = 0;
tooltip_stat2 = 0;
tooltip_stat3 = 0;
tooltip_stat4 = 0;
tooltip_other = "";

// ** For weapon display in management **
unit_profile = false;
unit_bio = false;
view_squad = false;
company_report = false;
company_data = {};
unit_focus = false;
filter_mode = false;
manage_tags = [];
pauldron_trim = 0;
last_unit = [
    0,
    0,
];
ui_coloring = "";
ui_melee_penalty = 0;
ui_ranged_penalty = 0;
management_tags = [];

// ** Sets default mouse vars **
current_target = false;
click = 0;
click2 = 0;
dropdown_open = 0;
scrollbar_engaged = 0;
born_leader = 0;

// ** Sets the secrets/events of the world **
craftworld = 0;
hurssy = 0;
hurssy_time = 0;
qsfx = 0;
und_armouries = 0;
und_gene_vaults = 0;
und_lairs = 0;
// ** Sets default gene seed values **
gene_sold = 0;
gene_xeno = 0;
gene_tithe = 24;
gene_iou = 0;
draw_helms = true;

// ** Sets default views and in game values on creation **
managing = 0;
formating = 0;
man_current = 0;
man_max = 0;
ship_current = 0;
ship_max = 0;
ship_see = 0;
man_sel[0] = 0;
man_size = 0;
man_count = 0;
squad_sel_action = -1;
squad_sel_count = 0;
squad_sel = -1;
selecting_location = "";
selecting_types = "";
selecting_dudes = "";
sel_all = "";
sel_promoting = 0;
drag_square = [];
rectangle_action = -1;
sel_loading = -1;
sel_uid = 0;

// ** Sets Chapter events and celebrations **
fest_sid = 0;
fest_wid = 0;
fest_planet = 0;
fest_star = "";
fest_type = "";
fest_cost = 0;
fest_warp = 0;
fest_scheduled = 0;
fest_lav = 0;
fest_locals = 0;
fest_feature1 = 0;
fest_feature2 = 0;
fest_feature3 = 0;
fest_display = 0;
fest_display_tags = "";
fest_repeats = 0;
fest_honor_co = 0;
fest_honor_id = 0;
fest_honoring = 0;
fest_attend = "";
// Sets the festivities and allowances
fest_feasts = 0;
fest_boozes = 0;
fest_drugses = 0;

recent_type = [];
recent_keyword = [];
recent_turn = [];
recent_number = [];

recent_happenings = 0;

// Sets up items to be default
// TODO command_set is used for equipement. We should re do this and have an array for all available equipement
var _size = 40;
sel_uni = array_create(_size, "");
sel_veh = array_create(_size, "");
command_set = array_create(_size, 0);
for (var i = 2; i <= 9; i++) {
    command_set[i] = 1;
}
command_set[20] = 1;
command_set[24] = 1;

// Outlier indices
modest_livery = 0;
progenitor_visuals = 0;
tagged_training = 0;

// ** Default menu items **
selecting_planet = 0;
selecting_ship = -1;
fleet_minimized = 0;
fleet_all = 1;
unload = 0;
new_vehicles = 1;
menu = eMENU.WELCOME_SCREEN1;
settings = 0;
text_bar = 0;
text_selected = "";
return_object = 0;
return_size = 0;
menu_artifact = 1;
menu_artifact_type = 0;
menu_adept = 0;
artifacts = 0;
identifiable = 0;
repair_ships = 0;
forge_points = 0;
master_craft_chance = 0;
tech_status = "cult_mechanicus";
forge_string = "";
apothecary_string = "";
player_forge_data = {
    player_forges: 0,
    vehicle_hanger: [],
};
selection_data = false;
selections = [];

technologies_known = [];

// ** STC values **,
stc_wargear = 0;
stc_vehicles = 0;
stc_ships = 0;
stc_un_total = 0;
stc_wargear_un = 0;
stc_vehicles_un = 0;
stc_ships_un = 0;
stc_bonus = array_create(7, 0);
stc_research = {
    wargear: 0,
    vehicles: 0,
    ships: 0,
    research_focus: "wargear",
};
// ** Resets the years **
check_number = 0;
year_fraction = 0;
year = 0;
millenium = 0;

if (instance_exists(obj_ini)) {
    if (obj_ini.millenium != 0) {
        check_number = obj_ini.check_number;
        year_fraction = 0; // 84 per turn
        year = obj_ini.year;
        millenium = obj_ini.millenium;
    }
}
// ** Penitent and blood debt reset **
penitent = 0;
penitent_current = 0;
penitent_max = 0;
penitent_turnly = 0;
penitent_turn = 0;
penitent_end = 0;
blood_debt = 0;
penit_co = array_create(51, 0);
penit_id = array_create(51, 0);

// ** Sets penitent or blood debt if chapter disadvantage is selected **
if (instance_exists(obj_ini)) {
    penitent = obj_ini.penitent;
    penitent_current = obj_ini.penitent_current;
    penitent_max = obj_ini.penitent_max;

    if (scr_has_disadv("Blood Debt")) {
        penitent_end = millenium + year + (obj_ini.penitent_end / 12);
        blood_debt = 1;
    } else {
        penitent_end = millenium + year + obj_ini.penitent_end;
    }

    if (string_count(obj_ini.spe[0][1], "$") > 0) {
        born_leader = 1;
    }
}
// ** Resets marines and other vars **
event = [];
// ship management arrays
// they are used to display a paginated subset of ships
// at a particular location for the load to ship screen.
sh_ide = [];
sh_uid = [];
sh_name = [];
sh_class = [];
sh_loc = [];
sh_hp = [];
sh_cargo = [];
sh_cargo_max = [];
reset_manage_arrays();
alll = 0;

popup = 0; // 1: fleet, 2: other, 3: system
selected = 0;
sel_owner = 0;
sel_system_x = 0;
sel_system_y = 0;
popup_master_crafted = 0;
close_popups = true;
unit_manage_image = false;
// ** Sets starting turn **
turn = 1;
// ** Sets events and missions **
last_event = 0;
last_mission = 0;
// ** Inquisition inspection **
last_inquisitor_inspection = 0; // Duhuhu

// ** Sets when chaos will arrive **
chaos_turn = 2;
// ** Sets fleets**
chaos_fleets = 0;
tau_fleets = 0;
tau_stars = 0;
tau_messenger = 0;
imp_ships = 0;
cooldown = 8;
exit_all = 0;
// ** Sets diplomacy and trading **
diplomacy = 0;
trading = 0;
trading_artifact = 0;
trading_enemy_demand = 0;
trading_demand = 0;
trade_likely = "";
questing = 0;
liscensing = 0;
audience = 0;
force_goodbye = 0;
trade_req = 0;
trade_gene = 0;
trade_chip = 0;
trade_info = 0;
zui = 0;
// Variables for management
temp = array_create(9001, "");
// ** Resets all audiences **
audience_stack = [];
audiences = 0;

// ** Sets default recruiting vars **
recruits = 0;
recruiting_worlds = "";
recruit_trial = eTRIALS.BLOODDUEL;
recruit_last = 0;

recruit_name = [];
recruit_corruption = [];
recruit_distance = [];
recruit_training = [];
recruit_exp = [];
recruit_data = [];

recruit_name[0] = "";
recruit_corruption[0] = 0;
recruit_distance[0] = 0;
recruit_training[0] = 0;
recruit_exp[0] = 0;
recruit_data[0] = {};

// ** Sets loyalty variables **
loyal = array_create(51, "");
loyal_num = array_create(51, 0);
loyal_time = array_create(51, 0);

// ** Sets quest variables **
quest = array_create(60, "");
quest_faction = array_create(60, 0);
quest_end = array_create(60, 0);

// ** Sets inquisitor variables **
inquisitor_gender = array_create(11, 0);
inquisitor_type = array_create(11, "");
inquisitor = array_create(11, "");

for (var i = 0; i < array_length(inquisitor_gender); i++) {
    inquisitor_gender[i] = choose(0, 0, 0, 1, 1, 1, 1);
    inquisitor_type[i] = choose("Ordo Malleus", "Ordo Xenos", "Ordo Hereticus", "Ordo Hereticus", "Ordo Hereticus", "Ordo Hereticus", "Ordo Hereticus", "Ordo Hereticus");
    var _gender = inquisitor_gender[i];
    inquisitor[i] = _name_gen.GenerateFromSet($"imperial_{string_gender(_gender)}");
}

// ** Sets diplomacy variables **
diplo_last = "";
diplo_text = "";
diplo_txt = "";
diplo_char = 0;
diplo_option = [];

diplo_alpha = 0;
// ** Sets combat to not true **
combat = 0;
random_event_next = eEVENT.NONE;
useful_info = "";

// ** Secret Lair styles **
lair_styles = [
    {
        name: "Barbarian",
        description: "Heavy on leather, hides, and trophy body parts.",
        tag: "BRB",
    },
    {
        name: "Disco",
        description: "Rainbow colored dance floor and steel rafters.",
        tag: "DIS",
    },
    {
        name: "Feudal",
        description: "Lots of stone, metal filigree, and statues.",
        tag: "FEU",
    },
    {
        name: "Gothic",
        description: "Lightly-dusty stone, mosaics, and statues throughout.",
        tag: "GTH",
    },
    {
        name: "Mechanicus",
        description: "Grates, tubes, gears, and augmented reality.",
        tag: "MCH",
    },
    {
        name: "Prospero",
        description: "Marble or sandstone surfaces and gold filigree.",
        tag: "PRS",
    },
    {
        name: "Rave Club",
        description: "Large, open area with neon or strobe lights.",
        tag: "RAV",
    },
    {
        name: "Steel",
        description: "Stainless steel surfaces and water fountains.",
        tag: "STL",
    },
    {
        name: "Utilitarian",
        description: "Plaster or concrete surfaces with carpeting.",
        tag: "UTL",
    },
];

// ** Sets the reason for loss of loyalty **
var loyalReasons = [
    "Heretic Contact",
    "Heretical Homeworld",
    "Traitorous Marines",
    "Use of Sorcery",
    "Mutant Gene-Seed",
    "Non-Codex Arming",
    "Non-Codex Size",
    "Lack of Apothecary",
    "Upset Machine Spirits",
    "Undevout",
    "Irreverence for His Servants",
    "Unvigilant",
    "Conduct Unbecoming",
    "Refusing to Crusade",
    "Eldar Contact",
    "Ork Contact",
    "Tau Contact",
    "Xeno Trade",
    "Xeno Associate",
    "Inquisitor Killer",
    "Crossing the Inquisition",
    "Avoiding Inspections",
    "Lost Standard",
];

for (var i = 0; i < array_length(loyalReasons); i++) {
    loyal[i + 1] = loyalReasons[i];
}

inqis_flag_lair = 0;
inqis_flag_gene = 0;

faction_justmet = 0;
// ** Sets up starting requisition **
requisition = 500;
if (instance_exists(obj_ini)) {
    if ((obj_ini.progenitor == ePROGENITOR.NONE) && (global.chapter_name != "Doom Benefactors")) {
        requisition = 2000;
    }
}
if (is_test_map == true) {
    requisition = 50000;
}

chapter_master = new scr_chapter_master();

trade_attempt = false;
// ** Sets income **
income = 0;
income_last = 0;
income_base = 0;
income_home = 0;
income_forge = 0;
income_agri = 0;
income_training = 0;
income_fleet = 0;
income_trade = 0;
income_leader = 0;
income_tribute = 0;
// ** Extra variables **
info_chips = 0;
inspection_passes = 0;
recruiting_worlds_bought = 0;

LOGGER.info("Set Battle Formations");
// ** BATTLE FORMATIONS **
var _count = 16;
bat_formation = array_create(_count, "");
bat_formation_type = array_create(_count, 0);
bat_deva_for = array_create(_count, 3);
bat_assa_for = array_create(_count, 5);
bat_tact_for = array_create(_count, 4);
bat_vete_for = array_create(_count, 3);
bat_hire_for = array_create(_count, 3);
bat_libr_for = array_create(_count, 2);
bat_comm_for = array_create(_count, 2);
bat_tech_for = array_create(_count, 2);
bat_term_for = array_create(_count, 5);
bat_hono_for = array_create(_count, 2);
bat_drea_for = array_create(_count, 6);
bat_rhin_for = array_create(_count, 6);
bat_pred_for = array_create(_count, 6);
bat_landraid_for = array_create(_count, 6);
bat_landspee_for = array_create(_count, 5);
bat_whirl_for = array_create(_count, 1);
bat_scou_for = array_create(_count, 3);
// ground=1    raid=2
// 1: Attack        type=1
// 2: Defend        type=1
// 3: Raid              type=2
// 4: (New Formation)   type=0
default_bat_formation();
// Defaults formations end here

bat_devastator_column = 3;
bat_assault_column = 5;
bat_tactical_column = 4;
bat_veteran_column = 3;
bat_hire_column = 3;
bat_librarian_column = 2;
bat_command_column = 2;
bat_techmarine_column = 2;
bat_terminator_column = 5;
bat_honor_column = 2;
bat_dreadnought_column = 6;
bat_rhino_column = 6;
bat_predator_column = 6;
bat_landraider_column = 6;
bat_whirlwind_column = 1;
bat_landspeeder_column = 5;
bat_scout_column = 3;
// ** Sets up disposition per faction **

LOGGER.info("Set Ai Faction data");
imperial_factions = [
    eFACTION.IMPERIUM,
    eFACTION.MECHANICUS,
    eFACTION.INQUISITION,
    eFACTION.ECCLESIARCHY,
];

faction = array_create(14, "");
disposition = array_create(14, 0);

// Faction Names
faction[eFACTION.PLAYER] = "Player";
faction[eFACTION.IMPERIUM] = "Imperium";
faction[eFACTION.MECHANICUS] = "Mechanicus";
faction[eFACTION.INQUISITION] = "Inquisition";
faction[eFACTION.ECCLESIARCHY] = "Ecclesiarchy";
faction[eFACTION.ELDAR] = "Eldar";
faction[eFACTION.ORK] = "Ork";
faction[eFACTION.TAU] = "Tau";
faction[eFACTION.TYRANIDS] = "Tyranids";
faction[eFACTION.CHAOS] = "Chaos";
faction[eFACTION.HERETICS] = "Heretics";
faction[eFACTION.GENESTEALER] = "Genestealers";
faction[eFACTION.NECRONS] = "Necrons";

// Static Dispositions
disposition[eFACTION.ELDAR] = -10;
disposition[eFACTION.ORK] = -40;
disposition[eFACTION.TAU] = 0;
disposition[eFACTION.TYRANIDS] = -irandom_range(40, 100);
disposition[eFACTION.CHAOS] = -70;
disposition[eFACTION.HERETICS] = -70;
disposition[eFACTION.GENESTEALER] = 0;
disposition[eFACTION.NECRONS] = -20;

// Dynamic Dispositions (Imperial)
if (instance_exists(obj_ini)) {
    disposition[eFACTION.IMPERIUM] = obj_ini.imperium_disposition;
    disposition[eFACTION.MECHANICUS] = obj_ini.mechanicus_disposition;
    disposition[eFACTION.INQUISITION] = obj_ini.inquisition_disposition;
    disposition[eFACTION.ECCLESIARCHY] = obj_ini.ecclesiarchy_disposition;
}

// ** Max disposition **
disposition_max = array_create(14, 0);
disposition_max[2] = 40;
disposition_max[3] = 40;
disposition_max[4] = 40;
disposition_max[5] = 40;
if (instance_exists(obj_ini)) {
    disposition_max[2] = 40 + obj_ini.imperium_disposition;
    if (disposition_max[2] > 100) {
        disposition_max[2] = 100;
    }
    disposition_max[3] = 40 + obj_ini.mechanicus_disposition;
    if (disposition_max[3] > 100) {
        disposition_max[3] = 100;
    }
    disposition_max[4] = 40 + obj_ini.inquisition_disposition;
    if (disposition_max[4] > 100) {
        disposition_max[4] = 100;
    }
    disposition_max[5] = 40 + obj_ini.ecclesiarchy_disposition;
    if (disposition_max[5] > 100) {
        disposition_max[5] = 100;
    }
}
// ** Sets up faction leader names as well as player faction stuff **
faction_leader = array_create(14, "");
faction_title = array_create(14, "");
faction_status = array_create(14, "");
// Sector Command faction
faction_leader[eFACTION.IMPERIUM] = _name_gen.GenerateFromSet($"imperial_male");
faction_title[eFACTION.IMPERIUM] = "Sector Commander";
faction_status[eFACTION.IMPERIUM] = "Allied";
// Mechanicus faction
//TODO make a dedicateed set of mechanicus names base imperial names are jarring af
faction_leader[eFACTION.MECHANICUS] = _name_gen.GenerateFromSet($"imperial_male");
faction_title[eFACTION.MECHANICUS] = "Magos";
faction_status[eFACTION.MECHANICUS] = "Allied";
if (faction_leader[eFACTION.MECHANICUS] == faction_leader[eFACTION.IMPERIUM]) {
    faction_leader[eFACTION.MECHANICUS] = _name_gen.GenerateFromSet("space_marine");
}
// Inquisition faction
faction_leader[eFACTION.INQUISITION] = _name_gen.GenerateFromSet($"imperial_male");
if (faction_leader[eFACTION.INQUISITION] == faction_leader[eFACTION.MECHANICUS]) {
    faction_leader[eFACTION.INQUISITION] = _name_gen.GenerateFromSet($"imperial_male");
}
faction_title[eFACTION.INQUISITION] = "Inquisitor Lord";
faction_status[eFACTION.INQUISITION] = "Allied";
// Sisters faction
faction_leader[eFACTION.ECCLESIARCHY] = _name_gen.GenerateFromSet($"imperial_female");
faction_title[eFACTION.ECCLESIARCHY] = "Prioress";
faction_status[eFACTION.ECCLESIARCHY] = "Allied";
// Eldar faction
faction_leader[eFACTION.ELDAR] = _name_gen.GenerateMultiSyllable("eldar", 2);
faction_title[eFACTION.ELDAR] = "Farseer";
faction_status[eFACTION.ELDAR] = "Antagonism"; // If disposition = 0 then instead set it to "Antagonism"
// Orkz faction
faction_leader[eFACTION.ORK] = _name_gen.GenerateComposite("ork", false);
faction_title[eFACTION.ORK] = "Warboss";
faction_status[eFACTION.ORK] = "War";
// Tau faction
faction_leader[eFACTION.TAU] = _name_gen.GenerateComposite("tau", true);
faction_title[eFACTION.TAU] = "Diplomat";
faction_status[eFACTION.TAU] = "Antagonism";
// Other factions unkown to player
faction_status[eFACTION.TYRANIDS] = "War";
faction_title[eFACTION.CHAOS] = "Chaos Lord";
faction_status[eFACTION.CHAOS] = "War";
faction_status[eFACTION.HERETICS] = "War";
faction_status[eFACTION.GENESTEALER] = "War";
faction_status[eFACTION.NECRONS] = "War";
// ** Sets faction gender for names **
faction_gender = array_create(14, 1);
faction_gender[eFACTION.ELDAR] = set_gender();
faction_gender[eFACTION.TAU] = set_gender();

//TODO this syntax for choosing gendered naes is kinda ass to read
faction_leader[eFACTION.INQUISITION] = _name_gen.GenerateFromSet($"imperial_{string_gender(faction_gender[eFACTION.INQUISITION])}");

faction_gender[eFACTION.CHAOS] = set_gender();
if (faction_gender[eFACTION.CHAOS] == eGENDER.FEMALE) {
    faction_leader[eFACTION.CHAOS] = choose("1", "1", "1", "2");
}
if (faction_gender[eFACTION.CHAOS] == eGENDER.MALE) {
    faction_leader[eFACTION.CHAOS] = choose("1", "2", "2", "2");
}
if (faction_leader[eFACTION.CHAOS] == "1") {
    faction_leader[eFACTION.CHAOS] = _name_gen.GenerateFromSet("space_marine");
}
if (faction_leader[eFACTION.CHAOS] == "2") {
    faction_leader[eFACTION.CHAOS] = _name_gen.GenerateFromSet("chaos");
}

known = array_create(14, 0);
known[0] = 2;
known[eFACTION.PLAYER] = 999;
known[eFACTION.IMPERIUM] = 1;
known[eFACTION.MECHANICUS] = 1;

// ** Sets diplomacy annoyed status **
annoyed = array_create(14, 0);
// ** Sets diplomacy ignore status **
ignore = array_create(14, 0);
// ** Sets diplomacy turns to be ignored **
turns_ignored = array_create(14, 0);
// ** Sets faction defeated **
faction_defeated = array_create(14, 0);

// **** CHAPTER CREATION VARS ****
// ** Sets up Chapter configuration variables **
battle_cry = "For the Emperor";
fortress_name = "";
flagship_name = "";
home_name = "";
home_type = "";
recruiting_name = "";
recruiting_type = "";
// ** Sets up chapter colors **
main_color = 0;
secondary_color = 0;
main_trim = 0;
left_pauldron = 0;
right_pauldron = 0;
lens_color = 0;
weapon_color = 0;
col_special = 0;
trim = 0;
// ** Sets up names, progenitor, successors and mutations **
adept_name = "";
recruiter_name = "";
progenitor = ePROGENITOR.NONE;
successor_chapters = 0;
mutation = "";

// ** Sets up disposition among imperial factions **
progenitor_disposition = 0;
astartes_disposition = 0;
astartes_max = 0;
imperium_disposition = 0;
imperium_max = 0;
guard_disposition = 0;
guard_max = 0;
inquisition_disposition = 0;
inquisition_max = 0;
ecclesiarchy_disposition = 0;
ecclesiarchy_max = 0;
mechanicus_disposition = 0;
mechanicus_max = 0;
other1_disposition = 0;
other1 = "";
// ** Sets up bonuses once chapter is created **
if (instance_exists(obj_ini)) {
    // General setup
    if (global.load == -1) {
        // Tolerant trait
        if (scr_has_disadv("Tolerant")) {
            disposition[eFACTION.ELDAR] += 5;
            disposition[eFACTION.ORK] += 5;
            disposition[eFACTION.TAU] += 10;
        }
        if (scr_has_adv("Enemy: Eldar")) {
            faction_status[eFACTION.ELDAR] = "War";
        }
        // Founding Chapter STC Bonuses here
        if (global.chapter_name == "Salamanders") {
            stc_wargear = 4;
            stc_bonus[1] = 3;
            stc_bonus[2] = 3;
        }
        if (global.chapter_name == "Iron Hands") {
            stc_wargear = 2;
            stc_bonus[1] = 5;
            stc_vehicles = 2;
            stc_bonus[3] = 3;
        }
        if (global.chapter_name == "Blood Ravens") {
            for (var i = 0; i < 3; i++) {
                scr_add_artifact("random_nodemon", "", 0, obj_ini.ship[0], 501);
            }
        }
        // TODO should add special bonus to different chapters based on lore
        adept_name = _name_gen.GenerateFromSet("space_marine");
        recruiter_name = obj_ini.recruiter_name;
        progenitor = obj_ini.progenitor;
        successor_chapters = obj_ini.successors;
        mutation = "";
        main_color = obj_ini.main_color;
        secondary_color = obj_ini.secondary_color;
        main_trim = obj_ini.main_trim;
        left_pauldron = obj_ini.left_pauldron;
        right_pauldron = obj_ini.right_pauldron;
        lens_color = obj_ini.lens_color;
        weapon_color = obj_ini.weapon_color;
        col_special = obj_ini.col_special;
        trim = obj_ini.trim;
        recruit_trial = obj_ini.recruit_trial;
        homeworld_rule = obj_ini.homeworld_rule;

        scr_colors_initialize();
        scr_shader_initialize();
        instance_create(-100, -100, obj_event_log);
        LOGGER.info("New Game");
    }
}
//Set player colour
try {
    global.star_name_colors[1] = make_color_rgb(col_r[main_color], col_g[main_color], col_b[main_color]);
} catch (_exception) {
    global.star_name_colors[1] = make_color_rgb(col_r[1], col_g[1], col_b[1]);
}

LOGGER.info("Controller Created");

#region save/load serialization

LOGGER.info("Set Save and Load functionality");
/// Called from save function to take all object variables and convert them to a json savable format and return it
serialize = function() {
    var object_controller = self;

    var save_data = {
        obj: object_get_name(object_index),
        x,
        y,
        stc_research,
        technologies_known,
        player_forge_data,
        end_turn_insights,
        recruit_data,
        marines,
        loyalty,
        spec_train_data,
        forge_queue: specialist_point_handler.forge_queue,
        chapter_master_data: chapter_master,
        event,
    };
    var excluded_from_save = [
        "temp",
        "serialize",
        "deserialize",
        "company_data",
        "menu_buttons",
        "location_viewer",
        "production_research_pathways",
        "specialist_point_handler",
        "spec_train_data",
        "tooltips",
        "last_unit",
        "unit_manage_constants",
        "unit_manage_image",
        "chapter_master",
        "armamentarium",
        "helpful_places_button",
        "lair_styles",
    ];
    var excluded_from_save_start = ["restart_"];

    copy_serializable_fields(object_controller, save_data, excluded_from_save, excluded_from_save_start);

    return save_data;
};

// Deserialization is done within scr_load
#endregion

// ** Loads the game **
if (global.load >= 0) {
    load_game = global.load;
    successor_chapters = 0;
    instance_create(0, 0, obj_saveload);
    with (obj_ini) {
        instance_destroy();
    }
    instance_create(0, 0, obj_ini);
    obj_saveload.alarm[0] = 1;
    obj_saveload.load_part = 1;
    obj_cursor.image_alpha = 0;
    scr_colors_initialize();
    LOGGER.info("Loading Game");
    exit;
}

///! ************************************************************ */
///! ************************************************************ */
///! ************************************************************ */
///! NOTHING BEYOND THIS POINT WILL BE SET AFTER A LOAD FROM SAVE */
///! ************************************************************ */
///! ************************************************************ */
///! ************************************************************ */
///! ************************************************************ */

global.custom = eCHAPTER_TYPE.RANDOM;

// ** Sets up base training level and trainees at game start **
training_apothecary = 0;
apothecary_recruit_points = 0;
apothecary_aspirant = 0;
training_chaplain = 0;
chaplain_points = 0;
chaplain_aspirant = 0;
training_psyker = 0;
psyker_points = 0;
psyker_aspirant = 0;
training_techmarine = 0;
tech_points = 0;
tech_aspirant = 0;
recruiting = 0;
penitorium = 0;
end_turn_insights = {};
spec_train_data = [
    {
        name: "Techmarine",
        min_exp: 30,
        coord_offset: [
            0,
            0,
        ],
        req: [
            [
                "technology",
                34,
                "exmore",
            ],
        ],
    },
    {
        name: "Librarian",
        min_exp: 0,
        coord_offset: [
            0,
            -7,
        ],
        req: [
            [
                "psionic",
                1,
                "exmore",
            ],
        ],
    },
    {
        name: "Chaplain",
        min_exp: 60,
        coord_offset: [
            7,
            -7,
        ],
        req: [
            [
                "piety",
                34,
                "exmore",
            ],
            [
                "charisma",
                29,
                "exmore",
            ],
        ],
    },
    {
        name: "Apothecary",
        min_exp: 60,
        coord_offset: [
            7,
            0,
        ],
        req: [
            [
                "technology",
                29,
                "exmore",
            ],
            [
                "intelligence",
                44,
                "exmore",
            ],
        ],
    },
];
// Redefines training based on chapter
if (instance_exists(obj_ini)) {
    if (scr_has_disadv("Psyker Intolerant")) {
        training_psyker = 0;
    }
    if (global.chapter_name == "Space Wolves") {
        training_chaplain = 0;
    }
}

// ** Sets the star for the chapter ? **
instance_create(irandom_range(400, room_width - 400), irandom_range(400, room_height - 400), obj_star);
var _number_of_systems = 100;
if (is_test_map == true) {
    _number_of_systems = 20;
}
mask_index = spr_star;
while (instance_number(obj_star) < _number_of_systems) {
    var xx = irandom_range(200, room_width - 150); // dictates how far away from the edge stars spawn
    var yy = irandom_range(130, room_height - 130);
    var nearest_star = instance_nearest(xx, yy, obj_star);
    var repeats = 0;
    while (point_distance(xx, yy, nearest_star.x, nearest_star.y) < 130 && repeats < 100) {
        xx = irandom_range(200, room_width - 150); // dictates how far away from the edge stars spawn
        yy = irandom_range(130, room_height - 160);
        repeats++;
    }
    if (repeats != 100) {
        if (!place_meeting(xx, yy, obj_star)) {
            instance_create(xx, yy, obj_star);
        }
    }
}
mask_index = -1;

LOGGER.info("Set Fleet Type");
fleet_type = "";
if (obj_ini.fleet_type == ePLAYER_BASE.HOME_WORLD) {
    fleet_type = "Homeworld";
}
if (obj_ini.fleet_type == ePLAYER_BASE.FLEET_BASED) {
    fleet_type = "Fleet";
}
if (obj_ini.fleet_type == ePLAYER_BASE.PENITENT) {
    fleet_type = "Crusade";
}
star_names = "";

// ** Sets up the number of enemy factions to appear **
tau = 1;
tyranids = 1;
ork = 1;
eldar = 1;

// ** Sets up loyalty **
loyalty = 100;
loyalty_hidden = 100; // Updated when inquisitors do an inspection

// ** Sets up gene seed **
gene_seed = 20;
if (scr_has_disadv("Sieged")) {
    gene_seed = floor(random_range(250, 400));
}
if (scr_has_disadv("Obliterated")) {
    gene_seed = floor(random_range(50, 200));
}
if (scr_has_disadv("Serpents Delight")) {
    gene_seed = floor(random_range(50, 250));
}
if (scr_has_disadv("Enduring Angels")) {
    gene_seed = floor(random_range(50, 250));
}
if (scr_has_disadv("Depleted Gene-seed Stocks")) {
    gene_seed = 0;
}
if (global.chapter_name == "Soul Drinkers") {
    gene_seed = 60;
}

system_fleet_strength = 0;

// **sets up starting forge_points
LOGGER.info("set up the specialist points");
specialist_point_handler = new SpecialistPointHandler();
specialist_point_handler.calculate_research_points(true);

//** sets up marine_by_location views
LOGGER.info("set up the UnitQuickFindPanel");
location_viewer = new UnitQuickFindPanel();

// ** Sets up the number of marines per company **
marines = 0;
marines = obj_ini.specials + obj_ini.firsts + obj_ini.seconds + obj_ini.thirds + obj_ini.fourths + obj_ini.fifths;
marines += obj_ini.sixths + obj_ini.sevenths + obj_ini.eighths + obj_ini.ninths + obj_ini.tenths;
command = 0;
command = obj_ini.commands;

// Removes the command marines from marine count
if (global.load == -1) {
    marines -= command;
}

// **** INTRO SCREEN ****
#region Intro Scroll
temp[30] = string(check_number) + " " + string(year_fraction) + " " + string(year) + ".M" + string(millenium); // Date
temp[31] = string_upper(adept_name); // Adept name
temp[32] = string_upper(obj_ini.name[0][0]); // Master name
temp[33] = string_upper(scr_thought()); // Thought of the day

// Game start welcoming message
LOGGER.info("Game start welcoming message");

var _canon = obj_ini.role[100];

var _build_clause = function(_prefix, _parts) {
    if (array_length(_parts) == 0) {
        return "";
    }
    return $"{_prefix} {string_join_ext(", ", _parts)}.";
};

var _hq_index = collect_company(0).index_roles();
var _command_staff = [
    {
        role: _canon[eROLE.CHAPTERMASTER],
        name_slot: 0,
        prefix: "your majesty ",
    },
    {
        role: "Forge Master",
        name_slot: 1,
        prefix: "",
    },
    {
        role: "Master of Sanctity",
        name_slot: 2,
        prefix: "",
    },
    {
        role: "Master of the Apothecarion",
        name_slot: 3,
        prefix: "",
    },
    {
        role: $"Chief {_canon[eROLE.LIBRARIAN]}",
        name_slot: 4,
        prefix: "and ",
    },
];

var _parts = [];
for (var i = 0, l = array_length(_command_staff); i < l; i++) {
    var _officer = _command_staff[i];
    if (_hq_index.has_role(_officer.role)) {
        array_push(_parts, $"{_officer.prefix}{_officer.role} {obj_ini.name[0][_officer.name_slot]}");
    }
}
temp[34] = _build_clause("Command staff made of", _parts);

var _specialist_display = [
    _canon[eROLE.TECHMARINE],
    _canon[eROLE.CHAPLAIN],
    _canon[eROLE.APOTHECARY],
    _canon[eROLE.LIBRARIAN],
    "Codiciery",
    "Lexicanum",
];
_parts = [];
for (var i = 0, l = array_length(_specialist_display); i < l; i++) {
    var _role_name = _specialist_display[i];
    var _count = _hq_index.has_role(_role_name) ? _hq_index.role_count(_role_name) : 0;
    if (_count > 0) {
        array_push(_parts, string_plural_count(_role_name, _count));
    }
}
temp[35] = _build_clause("Specialist branches staffed by", _parts);
var _honour_guard_count = _hq_index.has_role(_canon[eROLE.HONOURGUARD]) ? _hq_index.role_count(_canon[eROLE.HONOURGUARD]) : 0;
if (_honour_guard_count > 0) {
    temp[35] += $"\n\nHonour Guard, having the {_honour_guard_count} most veteran {string_plural("marine", _honour_guard_count)} of your chapter serving in it.";
}

var _vehicle_display = [
    "Land Raider",
    "Predator",
    "Whirlwind",
    "Rhino",
    "Land Speeder",
];

for (var _com = 1; _com <= 10; _com++) {
    var _index = collect_company(_com).index_roles();
    var _veh_counts = {};
    for (var v = 1; v <= 100; v++) {
        var _veh = obj_ini.veh_role[_com][v];
        if (_veh != "") {
            _veh_counts[$ _veh] = (_veh_counts[$ _veh] ?? 0) + 1;
        }
    }
    _parts = [];
    var _keys = _index.hierarchy_keys();
    for (var i = 0, l = array_length(_keys); i < l; i++) {
        var _count = _index.role_count(_keys[i]);
        if (_count > 0) {
            array_push(_parts, string_plural_count(_keys[i], _count));
        }
    }
    for (var i = 0, l = array_length(_vehicle_display); i < l; i++) {
        var _count = _veh_counts[$ _vehicle_display[i]] ?? 0;
        if (_count > 0) {
            array_push(_parts, string_plural_count(_vehicle_display[i], _count));
        }
    }
    temp[35 + _com] = _build_clause($"{integer_to_words(_com, true, true)} company made of", _parts);
}

LOGGER.info("create Ships");

temp[59] = $"CLASSIFICATION: SECTOR LOGISTICAE#++++++++++DATE: {temp[30]}#++++++++AUTHOR: MASTER ADEPT {temp[31]}#++++++++++++RE: INTRODUCTORY MISSIVE#+++++RECIPIENT: CHAPTER MASTER {temp[32]}##++THOUGHT: {temp[33]}++##I see you have made it unscathed, your grace. Death comes with you as it should! The enemy is on the horizon. Thy chapter is mighty and only waits for your word to wreak havoc upon our enemies.##Your chapter contains-";

temp[60] = $"{temp[59]}\n\n{temp[34]}\n\n{temp[35]}##{temp[36]}##{temp[37]}##{temp[38]}##{temp[39]}##{temp[40]}##{temp[41]}##{temp[42]}##{temp[43]}##{temp[44]}##{temp[45]}";

temp[61] = "\n\nYour armamentarium contains some spare equipment- \n";
temp[61] += equipment_struct_to_string(obj_ini.equipment, true, true);

temp[62] = "##Your fleet contains ";

var bb = 0, sk = 0, glad = 0, hunt = 0, ships = 0, bb_names = [], sk_names = [], glad_names = [], hunt_names = [];

var _ship_count = array_length(obj_ini.ship);
codex = array_create(_ship_count, "");
codex_discovered = array_create(_ship_count, 0);
for (var i = 0; i < _ship_count; i++) {
    var _name = obj_ini.ship[i];

    if (_name != "") {
        ships++;
        var _class = obj_ini.ship_class[i];

        switch (_class) {
            case "Battle Barge":
                bb++;
                array_push(bb_names, string(_name));
                break;
            case "Strike Cruiser":
                sk++;
                array_push(sk_names, string(_name));
                break;
            case "Gladius":
                glad++;
                array_push(glad_names, string(_name));
                break;
            case "Hunter":
                hunt++;
                array_push(hunt_names, string(_name));
                break;
        }
    }
}

temp[62] += $" {string_plural_count("warship", ships)}-\n";

if (obj_ini.fleet_type != ePLAYER_BASE.HOME_WORLD || bb == 1) {
    temp[62] += $"Your flagship, Battle Barge {obj_ini.ship[0]}.";
    temp[62] += "\n";
    bb--;
}
if (bb > 0) {
    temp[62] += $"{string_plural_count("Battle Barge", bb)}: {array_to_string_order(bb_names, true)}";
    temp[62] += "\n";
}
if (sk > 0) {
    temp[62] += $"{string_plural_count("Strike Cruiser", sk)}: {array_to_string_order(sk_names, true)}";
    temp[62] += "\n";
}
if (glad > 0) {
    temp[62] += $"{string_plural_count("Gladius Escort", glad)}: {array_to_string_order(glad_names, true)}";
    temp[62] += "\n";
}
if (hunt > 0) {
    temp[62] += $"{string_plural_count("Hunter Escort", hunt)}: {array_to_string_order(hunt_names, true)}";
    temp[62] += "\n";
}

// 61 : equipment
// 62 : ships
var lol = 240;
draw_set_font(fnt_small);
welcome_pages = string_height(string_hash_to_newline(string(temp[60]) + string(temp[61]) + string(temp[62])));
welcome_pages -= 260;
welcome_pages = (welcome_pages / lol) + 1;

if (floor(welcome_pages) < welcome_pages) {
    welcome_pages += 1;
    welcome_pages = floor(welcome_pages);
}

var tman = 65;
temp[65] = string(temp[60]) + string(temp[61]) + string(temp[62]);
for (var i = 0; i < welcome_pages; i++) {
    tman += 1;
    temp[tman] = string(temp[60]) + string(temp[61]) + string(temp[62]);
}

var lig = 0, remov = 0, stahp = 0;

if (welcome_pages >= 1) {
    for (var i = 0; i < 4000; i++) {
        if (string_height(string_hash_to_newline(temp[65])) > 260) {
            lig = string_length(temp[65]);
            temp[65] = string_delete(temp[65], lig, 1);
        }
    }
}
remov = string_length(string(temp[65])) + 1;

if (welcome_pages >= 2) {
    temp[66] = string_delete(temp[66], 1, remov);
    for (var i = 0; i < 4000; i++) {
        if (string_height(string_hash_to_newline(temp[66])) > lol) {
            lig = string_length(temp[66]);
            temp[66] = string_delete(temp[66], lig, 1);
        }
    }
}
remov = string_length(string(temp[65]) + string(temp[66])) + 1;

if (welcome_pages >= 3) {
    temp[67] = string_delete(temp[67], 1, remov);
    for (var i = 0; i < 4000; i++) {
        if (string_height(string_hash_to_newline(temp[67])) > lol) {
            lig = string_length(temp[67]);
            temp[67] = string_delete(temp[67], lig, 1);
        }
    }
}
remov = string_length(string(temp[65]) + string(temp[66]) + string(temp[67])) + 1;

if (welcome_pages < 4) {
    temp[68] = "";
}
if (welcome_pages >= 4) {
    temp[68] = string_delete(temp[68], 1, remov);
    for (var i = 0; i < 4000; i++) {
        if (string_height(string_hash_to_newline(temp[68])) > lol) {
            lig = string_length(temp[68]);
            temp[68] = string_delete(temp[68], lig, 1);
        }
    }
}
remov = string_length(string(temp[65]) + string(temp[66]) + string(temp[67]) + string(temp[68])) + 1;

if (welcome_pages < 5) {
    temp[69] = "";
}
if (welcome_pages >= 5) {
    temp[69] = string_delete(temp[69], 1, remov);
    for (var i = 0; i < 4000; i++) {
        if (string_height(string_hash_to_newline(temp[69])) > lol) {
            lig = string_length(temp[69]);
            temp[69] = string_delete(temp[69], lig, 1);
        }
    }
}
remov = string_length(string(temp[65]) + string(temp[66]) + string(temp[67]) + string(temp[68]) + string(temp[69])) + 1;

instance_create(0, 0, obj_tooltip);

alarm_set(0, 2);

//ensure fleet tab isup to date at gae start
location_viewer.update_fleet_table();

armamentarium = new Armamentarium(self);
#endregion
//**! DO NOT PUT THINGS AT THE BOTTOM OF THIS FILE IF YOU NEED THEM TO WORK AFTER LOADING FROM A SAVE, SEE LINE 1550 -ish   */ 
