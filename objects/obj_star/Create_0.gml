// Creates all variables, sets up default variables for different planets and if there is a fleet orbiting a system/planet
craftworld = 0;
space_hulk = 0;
old_x = 0;
old_y = 0;

if ((((x >= (room_width - 150)) && (y <= 450)) || (y < 100)) && (global.load == -1)) {
    // was 300
    instance_destroy();
}

scale = 1;
star_scale = 0;
name = "";
star = noone;
planets = 0;
owner = eFACTION.IMPERIUM;
image_speed = 0;
image_alpha = 0;
x2 = 0;
y2 = 0;
warp_lanes = [];
if (global.load == -1) {
    alarm[0] = 1;
}
storm = 0;
storm_image = 0;
trader = 0;
visited = 0;
stored_owner = -1;
navy_enemy_fleet_enroute = false;
in_view = true;
garrisoned = false;

// sets up default planet variables
planet = array_create(PLANET_ARRAY_SIZE, 0);
dispo = array_create(PLANET_ARRAY_SIZE, -50);
p_type = array_create(PLANET_ARRAY_SIZE, "");
p_owner = array_create(PLANET_ARRAY_SIZE, 0);
p_first = array_create(PLANET_ARRAY_SIZE, 0);
p_population = array_create(PLANET_ARRAY_SIZE, 0);
p_max_population = array_create(PLANET_ARRAY_SIZE, 0);
p_large = array_create(PLANET_ARRAY_SIZE, 0);
p_pop = array_create(PLANET_ARRAY_SIZE, "");
p_guardsmen = array_create(PLANET_ARRAY_SIZE, 0);
p_pdf = array_create(PLANET_ARRAY_SIZE, 0);
p_fortified = array_create(PLANET_ARRAY_SIZE, 0);
p_station = array_create(PLANET_ARRAY_SIZE, 0);
p_player = array_create(PLANET_ARRAY_SIZE, 0);
p_lasers = array_create(PLANET_ARRAY_SIZE, 0);
p_silo = array_create(PLANET_ARRAY_SIZE, 0);
p_defenses = array_create(PLANET_ARRAY_SIZE, 0);
p_orks = array_create(PLANET_ARRAY_SIZE, 0);
p_tau = array_create(PLANET_ARRAY_SIZE, 0);
p_eldar = array_create(PLANET_ARRAY_SIZE, 0);
p_tyranids = array_create(PLANET_ARRAY_SIZE, 0);
p_traitors = array_create(PLANET_ARRAY_SIZE, 0);
p_chaos = array_create(PLANET_ARRAY_SIZE, 0);
p_demons = array_create(PLANET_ARRAY_SIZE, 0);
p_sisters = array_create(PLANET_ARRAY_SIZE, 0);
p_necrons = array_create(PLANET_ARRAY_SIZE, 0);
p_halp = array_create(PLANET_ARRAY_SIZE, 0);
p_heresy = array_create(PLANET_ARRAY_SIZE, 0);
p_hurssy = array_create(PLANET_ARRAY_SIZE, 0);
p_hurssy_time = array_create(PLANET_ARRAY_SIZE, 0);
p_heresy_secret = array_create(PLANET_ARRAY_SIZE, 0);
p_raided = array_create(PLANET_ARRAY_SIZE, false);
p_governor = array_create(PLANET_ARRAY_SIZE, false);
p_operatives = array_create_advanced(PLANET_ARRAY_SIZE, []);
p_feature = array_create_advanced(PLANET_ARRAY_SIZE, []);
p_upgrades = array_create_advanced(PLANET_ARRAY_SIZE, []);
p_influence = array_create_advanced(PLANET_ARRAY_SIZE, array_create(15, 0));
p_problem = array_create_advanced(PLANET_ARRAY_SIZE, []);
p_psionic = [];
for (var i = 0; i < PLANET_ARRAY_SIZE; i++) {
    p_psionic[i] = irandom(5);
}

system_datas = array_create(8, undefined);
system_garrison = array_create(8, undefined);
system_sabatours = array_create(8, undefined);

get_garrison = function(planet) {
    var _gar = system_garrison[planet];
    if (is_undefined(_gar)) {
        system_garrison[planet] = new GarrisonForce(id, planet);
        _gar = system_garrison[planet];
        _gar.star = id;
        _gar.planet = planet;
    } else {
        _gar.update();
    }
    return _gar;
};

get_sabatours = function(planet) {
    var _gar = system_sabatours[planet];
    if (is_undefined(_gar)) {
        system_sabatours[planet] = new GarrisonForce(id, planet, "sabotage");
        _gar = system_sabatours[planet];
        _gar.star = id;
        _gar.planet = planet;
    } else {
        _gar.update();
    }
    return _gar;
};

/// @returns {Struct.PlanetData}
get_planet_data = function(planet) {
    var _gar = system_datas[planet];
    if (is_undefined(_gar)) {
        system_datas[planet] = new PlanetData(planet, id);
        _gar = system_datas[planet];
    } else {
        _gar.refresh_data();
    }
    return _gar;
};

add_feature = function(planet, feature) {
    array_push(p_feature[planet], feature);
};

problems = [];

add_problem = function(p_id, data = {}, timer = -1){
    var _prob = new SystemProblem(p_id, self, data, timer);
    array_push(problems, _prob);
    return _prob;
}

problems_to_mission_log = function(){
    var _temp_log = [];
    for (var i = 1; i <= planets; i++) {
        var _p_data = get_planet_data(i);
        _temp_log = array_concat(_temp_log, _p_data.problems_to_mission_log());
    }
    _temp_log = array_concat(_temp_log, generic_problems_to_mission_log());
    return _temp_log;
}

/// @self Asset.GMObject.obj_star
has_orbiting_player_fleet = function () {
    if (instance_exists(obj_p_fleet)) {
        var _nearest = instance_nearest(x, y, obj_p_fleet);
        if (_nearest.action != "move" && point_distance(_nearest.x, _nearest.y, x, y) == 0) {
            return true;
        }
    }
    return false;
}

/// @function get_orbiting_player_fleet()
/// @description Returns the ID of the nearest player fleet orbiting the given system or star.
/// The system instance or identifier to check. If `noone`, the function checks the calling star instance.
/// @returns {Id.Instance.obj_p_fleet} The instance ID of the orbiting player fleet, or -1 if none is found.
///
/// @example
/// ```gml
/// var fleet_id = get_orbiting_player_fleet();
/// if (fleet_id != noone) {
///     LOGGER.debug("Fleet orbiting star: " + string(fleet_id));
/// }
/// ```
get_orbiting_player_fleet = function() {
    var _fleet = instance_nearest(x, y, obj_p_fleet);
    if (!instance_exists(_fleet)){
        return noone;
    }
    if (object_distance(self, _fleet) > 0 || _fleet.action == "move") {
        return noone;
    } else {
        return _fleet.id;
    }
}

system_player_ground_forces = 0;

/// @desc Reports whether any planet in this system holds a garrison squad that still has members.
/// @returns {Bool}
function has_garrison() {
    for (var _planet = 1; _planet <= planets; _planet++) {
        var _operative_count = array_length(p_operatives[_planet]);
        for (var i = 0; i < _operative_count; i++) {
            var _operative = p_operatives[_planet][i];
            if (_operative.type != "squad") {
                continue;
            }
            if (_operative.job != "garrison") {
                continue;
            }
            if (array_length(fetch_squad(_operative.reference).get_members()) > 0) {
                return true;
            }
        }
    }

    return false;
}

var _array_size = 23;
present_fleet = array_create(_array_size, 0);

vision = 1;

ai_a = -1;
ai_b = -1;
ai_c = -1;
ai_d = -1;
ai_e = -1;

#region save/load serialization

/// Called from save function to take all object variables and convert them to a json savable format and return it
serialize = function() {
    var object_star = id;
    var planet_data = [];

    for (var p = 1; p <= object_star.planets; p++) {
        planet_data[p] = get_planet_data(p).save();
    }

    var save_data = {
        obj: object_get_name(object_index),
        x,
        y,
        planet_data: planet_data,
    };

    if (!is_undefined(object_star.p_governor)) {
        save_data.p_governor = object_star.p_governor;
    }

    var excluded_from_save = [
        "temp",
        "serialize",
        "deserialize",
        "arraysum",
        "garrison",
        "system_garrison",
        "system_sabatours",
        "system_datas",
        "present_fleet",
        "garrisoned"
    ];
    var excluded_from_save_start = ["p_"];

    copy_serializable_fields(object_star, save_data, excluded_from_save, excluded_from_save_start);

    return save_data;
};

function deserialize(save_data) {
    var exclusions = [
        "id",
        "present_fleet",
        "planet_data",
        "feature",
    ]; // skip automatic setting of certain vars, handle explicitly later

    // Automatic var setting
    var _all_names = struct_get_names(save_data);
    for (var i = 0; i < array_length(_all_names); i++) {
        var _var_name = _all_names[i];
        if (array_contains(exclusions, _var_name)) {
            continue;
        }
        var _loaded_value = struct_get(save_data, _var_name);
        variable_instance_set(id, _var_name, _loaded_value);
    }

    if (struct_exists(save_data, "planet_data")) {
        var planet_arr = save_data.planet_data;
        for (var p = 1; p < array_length(planet_arr); p++) {
            var _planet = planet_arr[p];
            var _var_names = struct_get_names(_planet);
            for (var v = 0; v < array_length(_var_names); v++) {
                var _var_name = _var_names[v];

                if (_var_name == "p_feature") {
                    var _planet_features = _planet[$ _var_name];
                    for (var f = 0; f < array_length(_planet_features); f++) {
                        var _feat = _planet_features[f];
                        if (!is_struct(_feat) || !struct_exists(_feat, "f_type")) {
                            continue;
                        }

                        var _new_feat = new NewPlanetFeature(_feat.f_type);

                        _new_feat.load_json_data(_feat);

                        array_push(p_feature[p], _new_feat);
                    }
                    continue;
                }
                if (_var_name == "p_problem") {
                    var _planet_problems = _planet[$ _var_name];
                    for (var f = 0; f < array_length(_planet_problems); f++) {
                        if (!is_struct(_planet_problems[f])){
                            continue;
                        }
                        var _new_prob = new PlanetProblem("", 0, {}, {planet:p,system:id});
                        _new_prob.load(_planet_problems[f]);
                        array_push(p_problem[p], _new_prob);
                    }
                    continue;
                }
                var _val = _planet[$ _var_name];
                if (!is_array(self[$ _var_name])) {
                    self[$ _var_name] = array_create(PLANET_ARRAY_SIZE, 0);
                }
                self[$ _var_name][p] = _val;
            }
        }
    }

    if (struct_exists(save_data, "p_governor")) {
        variable_instance_set(id, "p_governor", save_data.p_governor);
    }
}

#endregion
