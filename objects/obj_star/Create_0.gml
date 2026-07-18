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

// sets up default planet variables
var _planet_array_size = 9;
planet = array_create(_planet_array_size, 0);
dispo = array_create(_planet_array_size, -50);
p_type = array_create(_planet_array_size, "");
p_owner = array_create(_planet_array_size, 0);
p_first = array_create(_planet_array_size, 0);
p_population = array_create(_planet_array_size, 0);
p_max_population = array_create(_planet_array_size, 0);
p_large = array_create(_planet_array_size, 0);
p_pop = array_create(_planet_array_size, "");
p_guardsmen = array_create(_planet_array_size, 0);
p_pdf = array_create(_planet_array_size, 0);
p_fortified = array_create(_planet_array_size, 0);
p_station = array_create(_planet_array_size, 0);
p_player = array_create(_planet_array_size, 0);
p_lasers = array_create(_planet_array_size, 0);
p_silo = array_create(_planet_array_size, 0);
p_defenses = array_create(_planet_array_size, 0);
p_orks = array_create(_planet_array_size, 0);
p_tau = array_create(_planet_array_size, 0);
p_eldar = array_create(_planet_array_size, 0);
p_tyranids = array_create(_planet_array_size, 0);
p_traitors = array_create(_planet_array_size, 0);
p_chaos = array_create(_planet_array_size, 0);
p_demons = array_create(_planet_array_size, 0);
p_sisters = array_create(_planet_array_size, 0);
p_necrons = array_create(_planet_array_size, 0);
p_halp = array_create(_planet_array_size, 0);
p_heresy = array_create(_planet_array_size, 0);
p_hurssy = array_create(_planet_array_size, 0);
p_hurssy_time = array_create(_planet_array_size, 0);
p_heresy_secret = array_create(_planet_array_size, 0);
p_raided = array_create(_planet_array_size, false);
p_governor = array_create(_planet_array_size, false);
p_operatives = array_create_advanced(_planet_array_size, []);
p_feature = array_create_advanced(_planet_array_size, []);
p_upgrades = array_create_advanced(_planet_array_size, []);
p_influence = array_create_advanced(_planet_array_size, array_create(15, 0));
p_problem = array_create_advanced(_planet_array_size, array_create(8, ""));
p_problem_other_data = array_create_advanced(_planet_array_size, array_create_advanced(8, {}));
p_timer = array_create_advanced(_planet_array_size, array_create(8, -1));

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

system_player_ground_forces = 0;
garrison = false;

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
        planet_data[p] = {
            dispo: object_star.dispo[p],
            planet: object_star.planet[p],
        };
        var var_names = variable_instance_get_names(object_star);
        for (var n = 0; n < array_length(var_names); n++) {
            var var_name = var_names[n];
            if (string_starts_with(var_name, "p_")) {
                var val = object_star[$ var_name][p];
                variable_struct_set(planet_data[p], var_name, val);
            }
        }
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
        "system_garrison",
        "system_sabatours",
        "system_datas",
        "present_fleet",
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
    var all_names = struct_get_names(save_data);
    for (var i = 0; i < array_length(all_names); i++) {
        var var_name = all_names[i];
        if (array_contains(exclusions, var_name)) {
            continue;
        }
        var loaded_value = struct_get(save_data, var_name);
        variable_instance_set(id, var_name, loaded_value);
    }

    if (struct_exists(save_data, "planet_data")) {
        var planet_arr = save_data.planet_data;
        for (var p = 1; p < array_length(planet_arr); p++) {
            var planet = planet_arr[p];
            var var_names = struct_get_names(planet);
            for (var v = 0; v < array_length(var_names); v++) {
                var var_name = var_names[v];

                if (var_name == "p_feature") {
                    var _planet_features = planet[$ var_name];
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
                var val = planet[$ var_name];
                self[$ var_name][p] = val;
            }
        }
    }

    if (struct_exists(save_data, "p_governor")) {
        variable_instance_set(id, "p_governor", save_data.p_governor);
    }
}

#endregion
