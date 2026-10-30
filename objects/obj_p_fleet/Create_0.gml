owner = eFACTION.PLAYER;
capital_number = 0;
frigate_number = 0;
escort_number = 0;
selected = 0;
/// @type {Id.Instance.obj_star}
orbiting = noone;
warp_able = true;
ii_check = choose(8, 9, 10, 11, 12);

point_breakdown = single_loc_point_data();
image_xscale = 1.25;
image_yscale = 1.25;

capital = [];
capital_num = [];
capital_sel = [];
capital_uid = [];

frigate = [];
frigate_num = [];
frigate_sel = [];
frigate_uid = [];

escort = [];
escort_num = [];
escort_sel = [];
escort_uid = [];
problems = [];


image_speed = 0;

fix = 2;

capital_health = 100;
frigate_health = 100;
escort_health = 100;

complex_route = [];
just_left = false;
beyond_engagement = false;

action = "";
action_x = 0;
action_y = 0;
action_spd = 128;
action_eta = 0;
connected = 0;
acted = 0;
hurssy = 0;
hurssy_time = 0;
/// Called from save function to take all object variables and convert them to a json savable format and return it


add_problem = method(self, add_fleet_problem);

problems_to_mission_log = method(self, fleet_problems_to_mission_log);

arrived_at_star = function(){
    set_fleet_location(orbiting.name);
    if (orbiting.visited == 0) {
        for (var plan_num = 1; plan_num <= orbiting.planets; plan_num++) {
            if (array_length(orbiting.p_feature[plan_num]) != 0) {
                with (orbiting) {
                    scr_planetary_feature(plan_num);
                }
            }
        }
        orbiting.visited = 1;
    }
    if (orbiting.vision == 0) {
        orbiting.vision = 1;
    }
    meet_system_governors(orbiting);

    if (array_contains(orbiting.p_owner, eFACTION.ECCLESIARCHY)) {
        if ((obj_controller.faction_defeated[5] == 0) && (obj_controller.known[eFACTION.ECCLESIARCHY] == 0)) {
            obj_controller.known[eFACTION.ECCLESIARCHY] = 1;
        }
    }
    if ((orbiting.owner == eFACTION.ELDAR) && (obj_controller.faction_defeated[eFACTION.ELDAR] == 0) && (obj_controller.known[eFACTION.ELDAR] == 0)) {
        obj_controller.known[eFACTION.ELDAR] = 1;
    }
    if ((orbiting.owner == eFACTION.TAU) && (obj_controller.faction_defeated[eFACTION.TAU] == 0) && (obj_controller.known[eFACTION.TAU] == 0)) {
        obj_controller.known[eFACTION.TAU] = 1;
    } 


    if (orbiting.p_type[1] == "Craftworld") {
        var _rando = roll_dice_chapter(1, 100, "high");

        if ((_rando >= 95)) {
            obj_controller.known[eFACTION.ELDAR] = 1;
            scr_alert("green", "elfs", "Eldar Craftworld discovered.", orbiting.old_x, orbiting.old_y);
            with (obj_en_fleet) {
                if (owner == eFACTION.ELDAR) {
                    image_alpha = 1;
                }
            }
        }
        // Quene eldar introduction
        // if (rando>=95) and (dist<=300) then show_message("MON'KEIGH");
    }

    instance_activate_object(obj_star); 
}

arrive_at_waypoint = function(){
    for (var i = 0; i < array_length(problems); i++){
        problems[i].on_waypoint_arrival();
    }
    set_new_player_fleet_course(complex_route);
}

full_ship_array = function(exclude_capitals = false, exclude_frigates = false, exclude_escorts = false) {
    var all_ships = [];
    var _ship_count = array_length(obj_ini.ship);

    if (!exclude_capitals) {
        for (var i = 0; i < array_length(capital_num); i++) {
            if (capital_num[i] < _ship_count) {
                array_push(all_ships, capital_num[i]);
            }
        }
    }
    if (!exclude_frigates) {
        for (var i = 0; i < array_length(frigate_num); i++) {
            if (frigate_num[i] < _ship_count) {
                array_push(all_ships, frigate_num[i]);
            }
        }
    }
    if (!exclude_escorts) {
        for (var i = 0; i < array_length(escort_num); i++) {
            if (escort_num[i] < _ship_count) {
                array_push(all_ships, escort_num[i]);
            }
        }
    }

    return all_ships;
}

calculate_eta = function(target_x, target_y,from_star = true, to_star = true){
    calculate_fleet_eta(x, y, target_x, target_y, fleet_speed, from_star , to_star , warp_able);
}

move = method(self, set_fleet_movement);

serialize = function() {
    var object_fleet = self;

    var save_data = {
        obj: object_get_name(object_index),
        x,
        y,
        point_breakdown: point_breakdown,
    };
    var excluded_from_save = [
        "temp",
        "serialize",
        "deserialize",
        "orbiting",
        "problems",
    ];

    copy_serializable_fields(object_fleet, save_data, excluded_from_save);

    save_data.problems = [];
    for (var i = 0; i < array_length(problems); i++) {
        array_push(save_data.problems, problems[i].save());
    }

    return save_data;
};

deserialize = function(save_data) {
    var exclusions = ["orbiting", "problems"]; // skip automatic setting of certain vars, handle explicitly later

    // Automatic var setting
    var all_names = struct_get_names(save_data);
    var _len = array_length(all_names);
    for (var i = 0; i < _len; i++) {
        var var_name = all_names[i];
        if (array_contains(exclusions, var_name)) {
            continue;
        }
        var loaded_value = struct_get(save_data, var_name);
        try {
            variable_struct_set(self, var_name, loaded_value);
        } catch (e) {
            LOGGER.exception("Deserialization failed", e);
        }
    }

    // Problems, old saves won't have this key
    problems = [];
    load_fleet_problems(PlayerFleetProblem, save_data);
    set_player_fleet_image();
};