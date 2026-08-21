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
player_role_data = [];
default_role_data = [];

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

/// @type {Struct<Struct.ArtifactStruct>}
artifact_map = {};

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

ship_wep = array_create_2d(6, 6, "");
ship_wep_facing = array_create_2d(6, 6, "");
ship_wep_condition = array_create_2d(6, 6, "");

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
/// @type {Array<Array<Struct.TTRPG_stats>>}
TTRPG = array_create(11, []);

company_spawn_buffs = [];
role_spawn_buffs = {};
previous_forge_masters = [];
recruit_trial = 0;
recruiting_type = "Death";
sector_handler = new SectorHandler();

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
    for (var _coy = 0; _coy <= obj_ini.companies; _coy++) {
        for (var _mar = 0; _mar < array_length(obj_ini.TTRPG[_coy]); _mar++) {
            var _marine_json = jsonify_marine_struct(_coy, _mar, false);
            array_push(_marines, _marine_json);
        }
    }

    var _artifact_list = [];
    var _artifact_names = struct_get_names(artifact_map);
    var _artifact_len = array_length(_artifact_names);
    for (var k = 0; k < _artifact_len; k++) {
        var _artifact_name = _artifact_names[k];
        var _artifact = artifact_map[$ _artifact_name];
        array_push(_artifact_list, _artifact.to_json());
    }

    var _squad_copies = variable_clone(squads);

    var _squad_keys = struct_get_names(_squad_copies);
    for (var i = 0; i < array_length(_squad_keys); i++) {
        var _squad = _squad_copies[$ _squad_keys[i]];

        for (var s = 0; s < array_length(_squad.members); s++) {
            if (is_struct(_squad.members[s])) {
                _squad.members[s] = _squad.members[s].uid;
            }
        }
    }

    var save_data = {
        obj: object_get_name(object_index),
        x,
        y,
        custom_advisors,
        full_liveries,
        company_liveries,
        complex_livery_data,
        squad_types,
        artifact_list: _artifact_list,
        marine_structs: _marines,
        squad_structs: _squad_copies,
        equipment,
        gene_slaves, // squads // marines,
        chapter_data,
        chapter_squad_arrangement,
        player_role_data,
    };

    if (variable_instance_exists(self, "last_ship")) {
        save_data.last_ship = last_ship;
    }

    var excluded_from_save = [
        "temp",
        "serialize",
        "deserialize",
        "role_spawn_buffs",
        "TTRPG",
        "squads",
        "squad_structs",
        "squad_types",
        "marines",
        "last_ship",
        "chapter_data",
        "chapter_squad_arrangement",
        "artifact_map",
    ];

    copy_serializable_fields(id, save_data, excluded_from_save);

    save_data.company_lengths = [];
    for (var _coy = 0; _coy <= companies; _coy++) {
        array_push(save_data.company_lengths, company_length(_coy));
    }

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
        "artifact", // old format arrays - skip auto-set
        "artifact_tags",
        "artifact_identified",
        "artifact_condition",
        "artifact_quality",
        "artifact_loc",
        "artifact_sid",
        "artifact_equipped",
        "artifact_struct",
        "artifact_list",
        "sector_handler",
        "company_lengths",
    ]; // skip automatic setting of certain vars, handle explicitly later

    // Automatic var setting
    var all_names = struct_get_names(save_data);

    if (!array_contains(all_names, "chapter_squad_arrangement")) {
        chapter_squad_arrangement = json_to_gamemaker(working_directory + $"main/squads/company_squad_builds.json", json_parse);
    }

    for (var i = 0; i < array_length(all_names); i++) {
        var var_name = all_names[i];
        if (array_contains(exclusions, var_name)) {
            continue;
        }

        var loaded_value = struct_get(save_data, var_name);
        try {
            variable_instance_set(id, var_name, loaded_value);
        } catch (e) {
            LOGGER.exception("Deserialization failed", e);
        }
    }

    // Set explicit vars here
    var livery_picker = new ColourItem(0, 0);
    livery_picker.scr_unit_draw_data();
    if (struct_exists(save_data, "full_liveries")) {
        variable_instance_set(id, "full_liveries", save_data.full_liveries);
    } else {
        variable_instance_set(id, "full_liveries", array_create(21, variable_clone(livery_picker.map_colour)));
    }

    livery_picker.scr_unit_draw_data(-1);
    if (struct_exists(save_data, "company_liveries")) {
        variable_instance_set(id, "company_liveries", save_data.company_liveries);
    } else {
        variable_instance_set(id, "company_liveries", array_create(11, variable_clone(livery_picker.map_colour)));
    }

    livery_picker.scr_unit_draw_data();

    if (struct_exists(save_data, "complex_livery_data")) {
        variable_instance_set(id, "complex_livery_data", save_data.complex_livery_data);
    }
    if (struct_exists(save_data, "squad_types")) {
        variable_instance_set(id, "squad_types", save_data.squad_types);
    }

    var _marine_structs = save_data[$ "marine_structs"];

    function load_marine_struct(company, marine, struct) {
        TTRPG[company][marine] = new TTRPG_stats("chapter", company, marine, "blank");
        TTRPG[company][marine].load_json_data(struct);
    }

    var _company_lengths = struct_exists(save_data, "company_lengths") ? save_data.company_lengths : array_create(companies + 1, 501);
    for (var _coy = 0; _coy <= companies; _coy++) {
        for (var _mar = 0; _mar < _company_lengths[_coy]; _mar++) {
            TTRPG[_coy][_mar] = undefined;
        }
    }

    if (is_array(_marine_structs)) {
        var _m_ar_len = array_length(_marine_structs);
        for (var m = 0; m < _m_ar_len; m++) {
            var _marine_json = _marine_structs[m];
            var _coy = _marine_json.company;
            var _mar = _marine_json.marine_number;
            load_marine_struct(_coy, _mar, _marine_json);
        }
    }

    /// @desc Restores marine `specials` from obj_ini.spe, the parallel array it used to live in.
    ///    Saves predating that move carry no `specials` key at all, as it was a method and jsonify_marine_struct() skips methods.
    ///    `powers_known` was already a plain field and did round-trip, so without this those psykers load knowing powers with no discipline behind them.
    /// @param {Array<Array<String>>} _legacy_specials The saved spe array, indexed [company][marine]
    /// @returns {undefined}
    function migrate_legacy_marine_specials(_legacy_specials) {
        if (!is_array(_legacy_specials)) {
            return;
        }
        var _migrated = 0;
        var _company_count = min(array_length(_legacy_specials), array_length(TTRPG));
        for (var _coy = 0; _coy < _company_count; _coy++) {
            var _company_row = _legacy_specials[_coy];
            if (!is_array(_company_row)) {
                continue; // the legacy array is ragged; stray non-array rows carry nothing
            }
            var _row_length = array_length(_company_row);
            for (var _mar = 0; _mar < _row_length; _mar++) {
                var _legacy_string = _company_row[_mar];
                if (!is_string(_legacy_string) || _legacy_string == "") {
                    continue;
                }
                var _unit = fetch_unit([_coy, _mar]);
                if (!is_struct(_unit)) {
                    continue;
                }
                if (is_string(_unit.specials) && _unit.specials != "") {
                    continue;
                }
                _unit.specials = _legacy_string;
                _migrated++;
            }
        }
        if (_migrated > 0) {
            LOGGER.info($"Migrated specials for {_migrated} marines from the legacy obj_ini.spe array");
        }
    }

    if (struct_exists(save_data, "spe")) {
        migrate_legacy_marine_specials(save_data[$ "spe"]);
    }

    var _squad_structs = save_data[$ "squad_structs"];
    if (is_struct(_squad_structs)) {
        squads = {};
        var _squad_uids = struct_get_names(_squad_structs);
        var _squad_count = array_length(_squad_uids);
        for (var i = 0; i < _squad_count; i++) {
            var _squad_uid = _squad_uids[i];
            var _data = _squad_structs[$ _squad_uid];
            var _squad = new UnitSquad();
            try {
                _squad.load(_data);
            } catch (e) {
                LOGGER.exception("Failed to load squad " + _squad_uid, e);
            }
        }
    }

    artifact_map = {};
    if (struct_exists(save_data, "artifact_list")) {
        try {
            load_artifact_list(save_data.artifact_list);
        } catch (e) {
            LOGGER.exception("Failed to load artifact list", e);
        }
    }

    if (struct_exists(save_data, "gene_slaves")) {
        variable_instance_set(id, "gene_slaves", save_data.gene_slaves);
    }

    if (struct_exists(save_data, "chapter_data")) {
        chapter_data = new ChapterGameData(save_data.chapter_data);
    }

    if (struct_exists(save_data, "sector_handler")) {
        with (obj_ini.sector_handler) {
            move_data_to_current_scope(save_data.sector_handler);
        }
    }
};

#endregion
