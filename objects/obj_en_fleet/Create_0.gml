owner = 0;
capital_number = 0;
frigate_number = 0;
escort_number = 0;
guardsmen = 0;
home_x = 0;
home_y = 0;
selected = 0;
tau_fled = 0;
hurt = 0;
/// @type {Id.Instance.obj_star}
orbiting = noone;
rep = 3;
minimum_eta = 2;
turns_static = 0;
navy = 0;
guardsmen_ratio = 0;
guardsmen_unloaded = 0;
complex_route = [];
warp_able = false;
ii_check = floor(random(5)) + 1;
etah = 0;
safe = 0;
last_turn_check = 0;
events = [];
in_view = true;

uid = scr_uuid_generate();
//TODO set up special save method for faction specific fleet variables
inquisitor = -1;

cargo_data = {};

image_xscale = 1.25;
image_yscale = 1.25;

var _capital_size = 21;
var _ship_size = 31;

capital = array_create(_capital_size, "");
capital_num = array_create(_capital_size, 0);
capital_sel = array_create(_capital_size, 1);
capital_imp = array_create(_capital_size, 0);
capital_max_imp = array_create(_capital_size, 0);

frigate = array_create(_ship_size, "");
frigate_num = array_create(_ship_size, 0);
frigate_sel = array_create(_ship_size, 1);
frigate_imp = array_create(_ship_size, 0);
frigate_max_imp = array_create(_ship_size, 0);

escort = array_create(_ship_size, "");
escort_num = array_create(_ship_size, 0);
escort_sel = array_create(_ship_size, 1);
escort_imp = array_create(_ship_size, 0);
escort_max_imp = array_create(_ship_size, 0);

image_speed = 0;

action = "";
action_x = 0;
action_y = 0;
target = noone;
target_x = 0;
target_y = 0;
action_spd = 64;
if (owner <= 6) {
    action_spd = 128;
}
action_eta = 0;
connected = 0;
loaded = 0;

trade_goods = "";

capital_health = 100;
frigate_health = 100;
escort_health = 100;
problems = [];
/// @param {string} _name
/// @param {Real} _timer
/// @param {struct} _data
/// @returns {Struct.AiFleetProblem}
add_problem = method(self, add_fleet_problem);
move = method(self, set_fleet_movement);
problems_to_mission_log = method(self, fleet_problems_to_mission_log);

#region save/load serialization

/// Called from save function to take all object variables and convert them to a json savable format and return it
serialize = function() {
    var _object_fleet = self;

    var _save_data = {
        obj: object_get_name(object_index),
        x,
        y,
        cargo_data: cargo_data,
    };

    var excluded_from_save = [
        "temp",
        "serialize",
        "deserialize",
        "orbiting",
        "in_view",
    ];

    copy_serializable_fields(_object_fleet, _save_data, excluded_from_save);

    return _save_data;
};
deserialize = function(_save_data) {
    var exclusions = [
        "id",
        "cargo_data",
        "orbiting",
    ]; // skip automatic setting of certain vars, handle explicitly later

    // Automatic var setting
    var _all_names = struct_get_names(_save_data);
    var _len = array_length(_all_names);
    for (var i = 0; i < _len; i++) {
        var _var_name = _all_names[i];
        if (array_contains(exclusions, _var_name)) {
            continue;
        }
        var _loaded_value = struct_get(_save_data, _var_name);
        try {
            variable_instance_set(self, _var_name, _loaded_value);
        } catch (e) {
            LOGGER.exception("Deserialization failed", e);
        }
    }
    if (struct_exists(_save_data, "cargo_data")) {
        variable_instance_set(self, "cargo_data", _save_data.cargo_data);
        if (fleet_has_cargo("ork_warboss")) {
            var _boss = new NewPlanetFeature(eP_FEATURES.ORKWARBOSS);
            _boss.load_json_data(cargo_data.ork_warboss);
            cargo_data.ork_warboss = _boss;
        }
    }
    load_fleet_problems(AiFleetProblem, _save_data);
};

#endregion
