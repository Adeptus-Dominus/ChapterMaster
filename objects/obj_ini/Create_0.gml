LOGGER.debug("Creating obj_ini");

// normal stuff
specials = 0;
firsts = 0;
seconds = 0;
thirds = 0;
fourths = 0;
fifths = 0;
sixths = 0;
sevenths = 0;
eighths = 0;
ninths = 0;
tenths = 0;
commands = 0;

heh1 = 0;
heh2 = 0;

companies = 10;
progenitor = ePROGENITOR.NONE;
aspirant_trial = 0;
custom_advisors = {};

//default sector name to prevent potential crash
sector_name = "Terra Nova";
//default
load_to_ships = [
    2,
    0,
    0,
];
if (instance_exists(obj_creation)) {
    load_to_ships = obj_creation.load_to_ships;
}

penitent = 0;
penitent_max = 0;
penitent_current = 0;
penitent_end = 0;
man_size = 0;
home_planet = 2;

// Equipment- maybe the bikes should go here or something?          yes they should
equipment = {};

var _artifact_array_size = 200;
artifact = array_create(_artifact_array_size, "");
artifact_equipped = array_create(_artifact_array_size, false);
artifact_tags = array_create_advanced(_artifact_array_size, []);
artifact_identified = array_create(_artifact_array_size, 0);
artifact_condition = array_create(_artifact_array_size, 100);
artifact_quality = array_create(_artifact_array_size, "artifact");
artifact_loc = array_create(_artifact_array_size, "");
artifact_sid = array_create(_artifact_array_size, 0);
artifact_struct = array_create(_artifact_array_size);
for (var i = 0; i < _artifact_array_size; i++) {
    artifact_struct[i] = new ArtifactStruct(i);
}

squads = {};

// Ship Init

ship_id = [];
ship = [];
ship_uid = [];
ship_owner = [];
ship_class = [];
ship_size = [];
ship_leadership = [];
ship_hp = [];
ship_maxhp = [];

ship_location = [];
ship_shields = [];
ship_conditions = [];
ship_speed = [];
ship_turning = [];

ship_front_armour = [];
ship_other_armour = [];
ship_weapons = [];

ship_wep = array_create(6, "");
ship_wep_facing = array_create(6, "");
ship_wep_condition = array_create(6, "");

ship_capacity = [];
ship_carrying = [];
ship_contents = [];
ship_turrets = [];
ship_lost = [];

// Vehicle Init

var _max_companies = 11;
var _max_vehicles = 205;

last_ship = array_create_2d(_max_companies, _max_vehicles, {uid: "", name: ""});

veh_race = array_create_2d(_max_companies, _max_vehicles, 0);
veh_hp = array_create_2d(_max_companies, _max_vehicles, 100);
veh_chaos = array_create_2d(_max_companies, _max_vehicles, 0);
veh_lid = array_create_2d(_max_companies, _max_vehicles, -1);
veh_wid = array_create_2d(_max_companies, _max_vehicles, 2);
veh_uid = array_create_2d(_max_companies, _max_vehicles, 0);

veh_loc = array_create_2d(_max_companies, _max_vehicles, "");
veh_role = array_create_2d(_max_companies, _max_vehicles, "");
veh_wep1 = array_create_2d(_max_companies, _max_vehicles, "");
veh_wep2 = array_create_2d(_max_companies, _max_vehicles, "");
veh_wep3 = array_create_2d(_max_companies, _max_vehicles, "");
veh_upgrade = array_create_2d(_max_companies, _max_vehicles, "");
veh_acc = array_create_2d(_max_companies, _max_vehicles, "");

// Unit Init
defaults_slot = 100;

/// @type {Array<Array>}
race = [[]];
/// @type {Array<Array<String>>}
name = [[]];
/// @type {Array<Array<String>>}
role = [[]];
/// @type {Array<Array<String>>}
wep1 = [[]];
/// @type {Array<Array<String>>}
spe = [[]];
/// @type {Array<Array<String>>}
wep2 = [[]];
/// @type {Array<Array<String>>}
armour = [[]];
/// @type {Array<Array<String>>}
gear = [[]];
/// @type {Array<Array<String>>}
mobi = [[]];
/// @type {Array<Array<Real>>}
age = [[]];
/// @type {Array<Array<Real>>}
god = [[]];
/// @type {Array<Array<Struct.TTRPG_stats>>}
TTRPG = [[]];

load_default_gear = function(_role_id, _role_name, _wep1, _wep2, _armour, _mobi, _gear) {
    role[defaults_slot][_role_id] = _role_name;
    wep1[defaults_slot][_role_id] = _wep1;
    wep2[defaults_slot][_role_id] = _wep2;
    armour[defaults_slot][_role_id] = _armour;
    mobi[defaults_slot][_role_id] = _mobi;
    gear[defaults_slot][_role_id] = _gear;
    race[defaults_slot][_role_id] = 1;
};

check_number = 0;
year_fraction = 0;
year = 0;
millenium = 0;
company_spawn_buffs = [];
role_spawn_buffs = {};
previous_forge_masters = [];
recruit_trial = 0;
recruiting_type = "Death";

gene_slaves = [];

adv = [];
dis = [];

chapter_data = new ChapterGameData();

if (instance_exists(obj_creation)) {
    custom = obj_creation.custom;
}

if (global.load == -1) {
    scr_initialize_custom();
}

#region save/load serialization

/// Called from save function to take all object variables and convert them to a json savable format and return it
serialize = function() {
    var _marines = array_create(0);
    for (var _coy = 0; _coy <= 10; _coy++) {
        for (var _mar = 0; _mar <= 500; _mar++) {
            if (obj_ini.name[_coy][_mar] != "") {
                var _marine_json = jsonify_marine_struct(_coy, _mar, false);
                array_push(_marines, _marine_json);
            } else if (_mar > 0 && _mar <= 499 && obj_ini.name[_coy][_mar + 1] == "") {
                break;
            }
        }
    }

    var _artifact_struct_trimmed = [];
    var _artifact_count = array_length(artifact_struct);
    for (var i = 0; i < _artifact_count; i++) {
        if (artifact_struct[i].name != "") {
            array_push(_artifact_struct_trimmed, artifact_struct[i]);
        }
    }

    var save_data = {
        obj: object_get_name(object_index),
        x,
        y,
        custom_advisors,
        full_liveries: full_liveries,
        company_liveries: company_liveries,
        complex_livery_data: complex_livery_data,
        squad_types: squad_types,
        artifact_struct: _artifact_struct_trimmed,
        marine_structs: _marines,
        squad_structs: squads,
        equipment: equipment,
        gene_slaves: gene_slaves, // squads // marines,
        chapter_data: chapter_data,
        chapter_squad_arrangement: chapter_squad_arrangement,
    };

    if (variable_instance_exists(self, "last_ship")) {
        save_data.last_ship = last_ship;
    }

    var excluded_from_save = [
        "temp",
        "serialize",
        "deserialize",
        "load_default_gear",
        "role_spawn_buffs",
        "TTRPG",
        "squads",
        "squad_structs",
        "squad_types",
        "marines",
        "last_ship",
        "chapter_data",
        "chapter_squad_arrangement",
    ];

    copy_serializable_fields(self, save_data, excluded_from_save);

    return save_data;
};

deserialize = function(save_data) {
    var exclusions = [
        "complex_livery_data",
        "full_liveries",
        "company_liveries",
        "squad_types",
        "marine_structs",
        "squad_structs",
        "chapter_data",
    ]; // skip automatic setting of certain vars, handle explicitly later

    // Automatic var setting
    var all_names = struct_get_names(save_data);

    if (!array_contains(all_names, "chapter_squad_arrangement")) {
        obj_ini.chapter_squad_arrangement = json_to_gamemaker(working_directory + $"main/squads/company_squad_builds.json", json_parse);
    }

    for (var i = 0; i < array_length(all_names); i++) {
        var var_name = all_names[i];
        if (array_contains(exclusions, var_name)) {
            continue;
        }

        var loaded_value = struct_get(save_data, var_name);
        try {
            variable_struct_set(obj_ini, var_name, loaded_value);
        } catch (e) {
            LOGGER.exception("Deserialization failed", e);
        }
    }

    // Set explicit vars here
    var livery_picker = new ColourItem(0, 0);
    livery_picker.scr_unit_draw_data();
    if (struct_exists(save_data, "full_liveries")) {
        variable_struct_set(obj_ini, "full_liveries", save_data.full_liveries);
    } else {
        variable_struct_set(obj_ini, "full_liveries", array_create(21, variable_clone(livery_picker.map_colour)));
    }

    livery_picker.scr_unit_draw_data(-1);
    if (struct_exists(save_data, "company_liveries")) {
        variable_struct_set(obj_ini, "company_liveries", save_data.company_liveries);
    } else {
        variable_struct_set(obj_ini, "company_liveries", array_create(11, variable_clone(livery_picker.map_colour)));
    }

    livery_picker.scr_unit_draw_data();

    if (struct_exists(save_data, "complex_livery_data")) {
        variable_struct_set(obj_ini, "complex_livery_data", save_data.complex_livery_data);
    }
    if (struct_exists(save_data, "squad_types")) {
        variable_struct_set(obj_ini, "squad_types", save_data.squad_types);
    }

    var _marine_structs = save_data[$ "marine_structs"];

    function load_marine_struct(company, marine, struct) {
        obj_ini.TTRPG[company][marine] = new TTRPG_stats("chapter", company, marine, "blank");
        obj_ini.TTRPG[company][marine].load_json_data(struct);
    }

    obj_ini.TTRPG = array_create(11, array_create(501, {}));
    for (var _coy = 0; _coy <= 10; _coy++) {
        for (var _mar = 0; _mar <= 500; _mar++) {
            obj_ini.TTRPG[_coy][_mar] = new TTRPG_stats("chapter", _coy, _mar, "blank");
        }
    }

    if (is_array(_marine_structs)) {
        var _m_ar_len = array_length(_marine_structs);
        for (var m = 0; m < _m_ar_len; m++) {
            var _marine_json = _marine_structs[m];
            var _coy = _marine_json.company;
            var _mar = _marine_json.marine_number;
            load_marine_struct(_coy, _mar, _marine_json);
            if (!is_struct(fetch_unit([_coy, _mar]))) {
                obj_ini.TTRPG[_coy][_mar] = new TTRPG_stats("chapter", _coy, _mar, "blank");
            }
        }
    }

    var _squad_structs = save_data[$ "squad_structs"];
    if (is_struct(_squad_structs)) {
        obj_ini.squads = {};
        var _squad_uids = struct_get_names(_squad_structs);
        var _squad_count = array_length(_squad_uids);
        for (var i = 0; i < _squad_count; i++) {
            var _squad_uid = _squad_uids[i];
            var _squad = new UnitSquad();
            _squad.load_json_data(_squad_structs[$ _squad_uid]);
            obj_ini.squads[$ _squad_uid] = _squad;
        }
    }

    var _artifact_struct = save_data[$ "artifact_struct"];
    if (is_array(_artifact_struct)) {
        obj_ini.artifact_struct = [];
        var _len = array_length(_artifact_struct);
        for (var i = 0; i < 200; i++) {
            // 200 is the max number of artifacts
            var arti_struct = new ArtifactStruct(i);
            if (i < _len) {
                // still within the save_data array
                var arti = _artifact_struct[i];
                if (arti != -1) {
                    // in the serializer we trim out empty slots so there will be nothing to load
                    arti_struct.load_json_data(arti);
                }
                array_push(obj_ini.artifact_struct, arti_struct);
            } else {
                array_push(obj_ini.artifact_struct, arti_struct); //load empty ones into the rest of the slots
            }
        }
    }

    if (struct_exists(save_data, "gene_slaves")) {
        variable_struct_set(obj_ini, "gene_slaves", save_data.gene_slaves);
    }

    if (struct_exists(save_data, "chapter_data")) {
        obj_ini.chapter_data = new ChapterGameData(save_data.chapter_data);
    }
};

#endregion
