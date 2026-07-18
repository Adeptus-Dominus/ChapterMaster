/// @param {Real} strength
/// @param {Id.Instance.obj_en_fleet|Id.Instance.obj_p_fleet} fleet
function distribute_strength_to_fleet(strength, fleet) {
    while (strength > 0) {
        var ship_type = choose(1, 1, 1, 1, 2, 2, 3);
        strength -= ship_type;
        if (ship_type == 1) {
            fleet.escort_number++;
        } else if (ship_type == 2) {
            fleet.frigate_number++;
        } else if (ship_type == 3) {
            fleet.capital_number++;
        }
    }
}

/// @self Id.Instance.obj_en_fleet|Id.Instance.obj_p_fleet
/// @param {Id.Instance.obj_en_fleet|Id.Instance.obj_p_fleet} fleet
function standard_fleet_strength_calc(fleet = noone) {
    if (fleet == noone) {
        fleet = self;
    }
    return fleet.capital_number + (fleet.frigate_number / 2) + (fleet.escort_number / 4);
}

function random_sector_exit_point() {
    action_x = choose(room_width * -1, room_width * 2);
    action_y = choose(room_height * -1, room_height * 2);
}

/// @self Id.Instance.obj_en_fleet|Id.Instance.obj_p_fleet
/// @param {Id.Instance.obj_en_fleet|Id.Instance.obj_p_fleet} object
/// @return {Bool}
function in_room(object = noone) {
    if (object == noone) {
        object = self;
    }
    return !(object.x < 0 || object.x > room_width || object.y < 0 || object.y > room_height);
}

/// @self Id.Instance.obj_en_fleet|Id.Instance.obj_p_fleet
/// @param {Real} targ_x
/// @param {Real} targ_y
/// @param {Id.Instance.obj_fleet} final_target
function set_fleet_target(targ_x, targ_y, final_target) {
    action_x = targ_x;
    action_y = targ_y;
    target = final_target;
    action_eta = floor(point_distance(x, y, targ_x, targ_y) / 128) + 1;
}

/// @param {Id.Instance} target
function scr_valid_fleet_target(target) {
    if (target == noone) {
        return false;
    }
    if (is_string(target)) {
        target = noone;
        return false;
    }
    var valid = instance_exists(target);
    if (valid) {
        valid = target.object_index == obj_p_fleet || target.object_index == obj_en_fleet;
    }
    return valid;
}

function get_fleet_uid(search_uid) {
    var _fleet = noone;
    with (obj_en_fleet) {
        if (uid == search_uid) {
            _fleet = self;
            break;
        }
    }
    return _fleet;
}

/// @self Asset.GMObject.obj_en_fleet|Asset.GMObject.obj_p_fleet
/// @param {Id.Instance.obj_en_fleet|Id.Instance.obj_p_fleet} fleet
/// @param {Array<Id.Instance>} visited
function fleets_next_location(fleet = noone, visited = []) {
    var targ_location = noone;

    if (fleet == noone) {
        fleet = self;
    }

    if (instance_exists(fleet)) {
        // Add the current fleet's ID to the visited list to avoid rechecking it
        array_push(visited, fleet.id);

        // Check if the fleet has a 'target' variable
        if (variable_instance_exists(fleet, "target")) {
            // If the target is valid and not already in the visited list, proceed recursively
            var fleet_target_valid = scr_valid_fleet_target(fleet.target);
            if (!fleet_target_valid) {
                fleet.target = 0;
            }
            if (fleet_target_valid && !array_contains(visited, fleet.target.id)) {
                // Recursive call with the target and the updated visited list
                targ_location = fleets_next_location(fleet.target, visited);
            } else if (fleet.action != "") {
                // If no valid target, use the fleet's action coordinates
                targ_location = instance_nearest(fleet.action_x, fleet.action_y, obj_star);
            } else {
                // Default to nearest star to fleet's current position
                targ_location = instance_nearest(fleet.x, fleet.y, obj_star);
            }
        }
    }
    // If targ_location was not set to anything else, default to the nearest star
    if (targ_location == noone) {
        targ_location = instance_nearest(fleet.x, fleet.y, obj_star);
    }
    return targ_location;
}

/// @self Asset.GMObject.obj_en_fleet|Asset.GMObject.obj_p_fleet
/// @param {Id.Instance.obj_en_fleet|Id.Instance.obj_p_fleet} target
function chase_fleet_target_set(target) {
    var targ_location = fleets_next_location(target);
    if (targ_location != noone) {
        action_x = targ_location.x;
        action_y = targ_location.y;
        action = "";
        set_fleet_movement();
    }
}

/// @self Asset.GMObject.obj_en_fleet|Asset.GMObject.obj_p_fleet
function fleet_intercept_time_calculate(target_intercept) {
    var intercept_time = -1;
    var targ_location = fleets_next_location(target_intercept);
    if (instance_exists(targ_location)) {
        intercept_time = floor(point_distance(targ_location.x, targ_location.y, action_x, action_y) / action_spd) + 1;
    }
    return intercept_time;
}

function get_largest_player_fleet() {
    var chosen_fleet = noone;
    if (instance_exists(obj_p_fleet)) {
        with (obj_p_fleet) {
            if (point_in_rectangle(x, y, 0, 0, room_width, room_height) && point_in_rectangle(action_x, action_y, 0, 0, room_width, room_height)) {
                if (chosen_fleet == noone) {
                    chosen_fleet = self;
                    continue;
                }
                if (!(capital_number == 0 && chosen_fleet.capital_number == 0)) {
                    if (capital_number > chosen_fleet.capital_number) {
                        chosen_fleet = self;
                    }
                } else if (!(frigate_number == 0 && chosen_fleet.frigate_number == 0)) {
                    if (frigate_number > chosen_fleet.frigate_number) {
                        chosen_fleet = self;
                    }
                } else if (!(escort_number == 0 && chosen_fleet.escort_number == 0)) {
                    if (escort_number > chosen_fleet.escort_number) {
                        chosen_fleet = self;
                    }
                }
            }
        }
    }
    return chosen_fleet;
}

/// @desc Returns the nearest star within max_distance, or noone.
/// @param {Real} _x
/// @param {Real} _y
/// @param {Real} _max_distance  Default 50
/// @returns {Id.Instance.obj_star|noone}
function get_nearest_star(_x, _y, _max_distance = 50) {
    var _near = instance_nearest(_x, _y, obj_star);
    if (instance_exists(_near) && point_distance(_x, _y, _near.x, _near.y) <= _max_distance && _near.name != "") {
        return _near;
    }

    return noone;
}

/// @self Asset.GMObject.obj_en_fleet|Asset.GMObject.obj_p_fleet
function set_fleet_movement(fastest_route = true, new_action = "move", minimum_eta = 1, maximum_eta = 1000) {
    action = "";
    var _at_star = instance_exists(orbiting);

    if (action == "") {
        turns_static = 0;
        var mine;
        if (fastest_route) {
            mine = instance_nearest(x, y, obj_star);
            var star_travel = new FastestRouteAlgorithm(x, y, action_x, action_y, self.id, _at_star);
            var path = star_travel.final_array_path();
            if (array_length(path) > 1) {
                var targ = find_star_by_name(path[1]);
                if (targ != noone) {
                    array_delete(path, 0, 2);
                    complex_route = path;
                    action_x = targ.x;
                    action_y = targ.y;
                    set_fleet_movement(false, new_action);
                } else {
                    set_fleet_movement(false, new_action);
                }
            } else {
                set_fleet_movement(false, new_action);
            }
        } else {
            var _target_sys = instance_nearest(action_x, action_y, obj_star);
            var _target_is_sys = false;

            if (instance_exists(_target_sys)) {
                _target_is_sys = point_distance(_target_sys.x, _target_sys.y, action_x, action_y) < 10;
            }

            mine = instance_nearest(x, y, obj_star);

            var eta = calculate_fleet_eta(x, y, action_x, action_y, action_spd, _target_is_sys, _at_star, warp_able);
            action_eta = eta;
            if ((action_eta <= 0) || (owner != eFACTION.INQUISITION)) {
                action_eta = eta;
            } else if ((owner == eFACTION.INQUISITION) && (action_eta < 2) && (string_count("_her", trade_goods) == 0)) {
                action_eta = 2;
            }
            if (_at_star) {
                if (owner != eFACTION.ELDAR && mine.storm) {
                    action_eta += 10000;
                }
            }

            fleet_unregister_from_star(id);
            action = new_action;
            action_eta = clamp(action_eta, minimum_eta, maximum_eta);
        }
    }
}

/// @param {Id.Instance.obj_en_fleet|Id.Instance.obj_p_fleet} fleet
/// @param {Struct} unit
function load_unit_to_fleet(fleet, unit) {
    var loaded = false;
    var all_ships = fleet_full_ship_array(fleet);

    for (var i = 0; i < array_length(all_ships); i++) {
        var ship_ident = all_ships[i];
        if (obj_ini.ship_capacity[ship_ident] > obj_ini.ship_carrying[ship_ident]) {
            obj_ini.ship_carrying[ship_ident] += unit.size;
            unit.planet_location = 0;
            unit.location_string = obj_ini.ship_location[ship_ident];
            unit.ship_location = ship_ident;
            loaded = true;
            break;
        }
    }
    return loaded;
}

/// @param {Real} self_x
/// @param {Real} self_y
/// @param {Real} target_x
/// @param {Real} target_y
/// @param {Real} fleet_speed
/// @param {Bool} from_star
/// @param {Bool} to_star
/// @param {Bool} warp_able
function calculate_fleet_eta(self_x, self_y, target_x, target_y, fleet_speed, from_star = true, to_star = true, warp_able = false) {
    var _eta = floor(point_distance(self_x, self_y, target_x, target_y) / fleet_speed) + 1;
    var _lane_strength = 0;
    /// @type {Id.Instance.obj_star}
    var _departure_star = noone;
    /// @type {Id.Instance.obj_star}
    var _destanation_star = noone;

    if (from_star) {
        _departure_star = instance_nearest(self_x, self_y, obj_star);
    }

    if (to_star) {
        _destanation_star = instance_nearest(target_x, target_y, obj_star);
    }

    if (_departure_star != noone && _destanation_star != noone) {
        _lane_strength = determine_warp_join(_departure_star.id, _destanation_star.id);
    }

    if (_lane_strength > 0) {
        if (warp_able) {
            _eta = ceil(_eta / _lane_strength);
        }
    } else {
        _eta *= 2;
    }

    if (_destanation_star != noone) {
        //check end location for warp storm
        if (_destanation_star.storm) {
            _eta += 10000;
        }
    }

    return _eta;
}

/// @self Asset.GMObject.obj_en_fleet|Asset.GMObject.obj_p_fleet
/// @param {Id.Instance.obj_en_fleet|Id.Instance.obj_p_fleet} fleet
/// @param {Bool} selected
function calculate_action_speed(fleet = noone, selected = false) {
    try {
        if (fleet == noone) {
            var capitals = 0, frigates = 0, escorts = 0, i;
            var _is_player_fleet = object_index == obj_p_fleet;
            if (_is_player_fleet) {
                if (!selected) {
                    player_fleet_ship_count();
                    capitals = capital_number;
                    frigates = frigate_number;
                    escorts = escort_number;
                } else {
                    //TODO extract to a fleet selected function
                    var types = selected_ship_types();
                    capitals = types[0];
                    frigates = types[1];
                    escorts = types[2];
                }
            }
            var fleet_speed = 128;
            if (capitals > 0) {
                fleet_speed = 100;
            } else if (frigates > 0) {
                fleet_speed = 128;
            } else if (escorts > 0) {
                fleet_speed = 174;
            }
            if (_is_player_fleet) {
                if ((obj_controller.stc_ships >= 6) && (fleet_speed >= 100)) {
                    fleet_speed *= 1.2;
                }
            }
            return fleet_speed;
        } else {
            with (fleet) {
                return calculate_action_speed(, selected);
            }
        }
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
        return 200;
    }
}

/// @self Asset.GMObject.obj_en_fleet
function scr_efleet_arrive_at_trade_loc() {
    //if player fleet at star or player forces trade
    var chase_fleet = false;

    var _valid_fleet = false;
    var _orbit = orbiting;
    var _valid_planet = false;

    var _viewer = obj_controller.location_viewer;
    if (orbiting.owner < 6 && _viewer.has_troops(orbiting.name)) {
        _valid_planet = true;
    }

    with (obj_p_fleet) {
        if (x == _orbit.x && y == _orbit.y) {
            _valid_fleet = true;
            break;
        }
    }

    //iff no forces see iffleet to chase
    if (!_valid_fleet && !_valid_planet) {
        var _chase_target = -1;
        if (instance_exists(target) && target.object_index == obj_p_fleet) {
            _chase_target = target;
        } else {
            target = instance_nearest(x, y, obj_p_fleet);
        }
        var _chase_fleet = instance_exists(target) && (target.action != "" || point_distance(x, y, target.x, target.y) > 40) && obj_ini.fleet_type != ePLAYER_BASE.HOME_WORLD;

        if (_chase_fleet) {
            if (!string_count("Inqis", trade_goods)) {
                if (target.action != "") {
                    action_x = target.action_x;
                    action_y = target.action_y;
                } else if (target.action == "") {
                    var _targ_star = instance_nearest(target.x, target.y, obj_star);
                    action_x = _targ_star.x;
                    action_y = _targ_star.y;
                }
                action = "";
                set_fleet_movement();
                if (owner != eFACTION.ELDAR) {
                    obj_controller.disposition[owner] -= 1;
                }
            }
        }

        //if no fleet find a valid planet with player forces
        if (action == "") {
            var _player_star = nearest_star_with_ownership(x, y, 1);
            if (_player_star != noone) {
                action_x = _player_star.x;
                action_y = _player_star.y;
                set_fleet_movement();
            } else {
                var _player_presence_stars = _viewer.player_force_stars();
                if (array_length(_player_presence_stars)) {
                    var _nearest_index = nearest_from_array(x, y, _player_presence_stars);
                    var _nearest = _player_presence_stars[_nearest_index];
                    action_x = _nearest.x;
                    action_y = _nearest.y;
                    set_fleet_movement();
                }
            }
        }

        //if no other viable options drop off at random imperial planet
        if (action == "") {
            var _imp = nearest_star_with_ownership(x, y, 2);
            if (_imp != noone) {
                if (x == _imp.x && y == _imp.y) {
                    _valid_planet = true;
                } else {
                    action_x = _imp.x;
                    action_y = _imp.y;
                    set_fleet_movement();
                }
            }
        }
    }

    if (_valid_fleet || _valid_planet) {
        var targ;
        var cur_star = nearest_star_proper(x, y);
        var bleh = "";
        if (owner != eFACTION.INQUISITION) {
            bleh = $"{obj_controller.faction[owner]} Fleet finalizes trade at {cur_star.name}.";
        } else {
            bleh = $"Inquisitor Ship finalizes trade at {cur_star.name}.";
        }
        LOGGER.info(bleh);
        scr_alert("green", "trade", bleh, cur_star.x, cur_star.y);
        scr_event_log("", bleh, cur_star.name);

        // Drop off here
        if (fleet_has_cargo("player_goods")) {
            scr_trade_dep();
        }

        if (target != noone) {
            target = noone;
        }

        if (owner == eFACTION.ELDAR) {
            cur_star = nearest_star_with_ownership(xx, yy, eFACTION.ELDAR);
            if (cur_star != noone) {
                cur_star = targ.x;
                cur_star = targ.y;
            }
        } else {
            action_x = home_x;
            action_y = home_y;
            set_fleet_movement();
        }
        trade_goods = "return";
        if (action_eta == 0) {
            instance_destroy();
        }
        return true;
    }
    return false;
}

/// @function scr_orbiting_fleet(faction, system)
/// @description Returns the ID of a fleet orbiting the given system/star that matches the specified faction.
/// @param {Real|Array<Real>} faction
/// The faction identifier to check against. Can be a single faction ID or an array of multiple factions.
/// @param {Id.Instance.obj_star} system
/// The system instance or star to check. If `noone`, the function uses the calling instance's position.
/// @returns {Id.Instance.obj_en_fleet|Id.Instance.obj_p_fleet} The ID of the matching fleet instance, or `noone` if no valid fleet is found.
///
/// @example
/// ```gml
/// // Find a fleet orbiting this star that belongs to faction 3
/// var fleet_id = scr_orbiting_fleet(3);
/// if (fleet_id != noone) {
///     LOGGER.debug("Faction fleet found: " + string(fleet_id));
/// }
///
/// // Find fleets from multiple factions
/// var factions = [1, 2, 5];
/// var fleet_id = scr_orbiting_fleet(factions, some_system);
/// ```
function scr_orbiting_fleet(faction, system = noone) {
    var _found_fleet = noone;
    var _faction_list = is_array(faction);
    var xx = system == noone ? x : system.x;
    var yy = system == noone ? y : system.y;
    with (obj_en_fleet) {
        if (x == xx && y == yy) {
            var _valid = false;
            if (_faction_list) {
                _valid = array_contains(faction, owner);
            } else {
                if (owner == faction) {
                    _valid = true;
                }
            }
            if (_valid && action == "") {
                _found_fleet = id;
                break;
            }
        }
    }
    return _found_fleet;
}

/// @function object_distance(obj_1, obj_2)
/// @description Returns the distance in pixels between two instances or objects based on their `x` and `y` coordinates.
/// @param {Id.Instance} obj_1 The first object or instance.
/// @param {Id.Instance} obj_2 The second object or instance.
/// @returns {Real} The distance in pixels between `obj_1` and `obj_2`.
///
/// @example
/// ```gml
/// var dist = object_distance(player, enemy);
/// if (dist < 100) {
///     LOGGER.debug("Enemy is within range!");
/// }
/// ```
function object_distance(obj_1, obj_2) {
    return point_distance(obj_1.x, obj_1.y, obj_2.x, obj_2.y);
}

/// @function scr_orbiting_player_fleet(system)
/// @description Returns the ID of the nearest player fleet orbiting the given system or star.
/// @param {Id.Instance.obj_star} system
/// The system instance or identifier to check. If `noone`, the function checks the calling star instance.
/// @returns {Id.Instance.obj_p_fleet} The instance ID of the orbiting player fleet, or -1 if none is found.
///
/// @example
/// ```gml
/// var fleet_id = scr_orbiting_player_fleet();
/// if (fleet_id != -1) {
///     LOGGER.debug("Fleet orbiting star: " + string(fleet_id));
/// }
/// ```
function scr_orbiting_player_fleet(system = noone) {
    if (system == noone && !is_struct(self) && object_index == obj_star) {
        var _fleet = instance_nearest(x, y, obj_p_fleet);
        if (object_distance(self, _fleet) > 0) {
            return -1;
        } else {
            return _fleet.id;
        }
    } else if (system != noone) {
        try {
            with (system) {
                return scr_orbiting_player_fleet();
            }
        } catch (_exception) {
            ERROR_HANDLER.handle_exception(_exception);
        }
    }

    return -1;
}

function get_orbiting_fleets(faction, system = noone) {
    var _fleets = [];
    var _faction_list = is_array(faction);
    var xx = system == noone ? x : system.x;
    var yy = system == noone ? y : system.y;
    with (obj_en_fleet) {
        if (x == xx && y == yy) {
            var _valid = false;
            if (_faction_list) {
                _valid = array_contains(faction, owner);
            } else {
                if (owner == faction) {
                    _valid = true;
                }
            }
            if (_valid && action == "") {
                array_push(_fleets, id);
            }
        }
    }
    return _fleets;
}

function sector_imperial_fleet_strength() {
    obj_controller.imp_ships = 0;
    var _imperial_planet_count = 0;
    var _mech_worlds = 0;
    with (obj_en_fleet) {
        if (owner == eFACTION.IMPERIUM) {
            var _imperial_fleet_defence_score = capital_number + (frigate_number / 2) + (escort_number / 4);
            obj_controller.imp_ships += _imperial_fleet_defence_score;
        }
    }
    with (obj_star) {
        for (var i = 0; i <= planets; i++) {
            var _owner_imperial = p_owner[i] < eFACTION.ECCLESIARCHY && p_owner[i] > eFACTION.PLAYER;
            _imperial_planet_count += _owner_imperial;
        }
        if (owner == eFACTION.MECHANICUS) {
            _mech_worlds++;
        }
    }
    max_fleet_strength = (_imperial_planet_count / 8) * (_mech_worlds * 3);
}

function fleet_star_draw_offsets() {
    var coords = [
        0,
        0,
    ];
    switch (owner) {
        case eFACTION.IMPERIUM:
            if (!navy) {
                coords = [
                    0,
                    -24,
                ]; //
            } else {
                coords = [
                    0,
                    24,
                ];
            }
            break;
        case eFACTION.MECHANICUS:
            coords = [
                0,
                -32,
            ]; //
            break;
        case eFACTION.INQUISITION:
            coords = [
                0,
                -32,
            ]; //
            break;
        case eFACTION.ELDAR:
            coords = [
                -24,
                -24,
            ]; //
            break;
        case eFACTION.ORK:
            coords = [
                30,
                0,
            ]; //
            break;
        case eFACTION.TAU:
            coords = [
                -24,
                -24,
            ]; //
            break;
        case eFACTION.TYRANIDS:
            coords = [
                0,
                32,
            ]; //
            break;
        case eFACTION.CHAOS:
            coords = [
                -30,
                0,
            ]; //
            break;
        case eFACTION.NECRONS:
            coords = [
                32,
                32,
            ]; //
            break;
    }
    return coords;
}

//TODO further split this shite up
/// @self Asset.GMObject.obj_en_fleet|Asset.GMObject.obj_p_fleet
function fleet_arrival_logic() {
    var _dest_star = instance_nearest(action_x, action_y, obj_star);
    x = _dest_star.x;
    y = _dest_star.y;
    var sta = _dest_star;
    fleet_register_at_star(id, _dest_star);

    if (owner == eFACTION.MECHANICUS) {
        if (trade_goods == "mars_spelunk1") {
            trade_goods = "mars_spelunk2";
            action_x = home_x;
            action_y = home_y;
            action_eta = 52;
            action = "move";
            exit;
        } else if (trade_goods == "mars_spelunk2") {
            // Unload techmarines nao plz
            scr_mission_reward("mars_spelunk", instance_nearest(home_x, home_y, obj_star), 1);
            instance_destroy();
        }
    }

    //TODO create oppertunity to purge new colonisers if they have taint and the player has garrisons or control of the planet
    if (fleet_has_cargo("colonize")) {
        deploy_colonisers(_dest_star);
    }

    if (trade_goods == "return") {
        instance_destroy();
    }

    if (owner == eFACTION.INQUISITION) {
        if (fleet_has_cargo("radical_inquisitor")) {
            radical_inquisitor_mission_ship_arrival();
            exit;
        }
    }

    if (!navy) {
        if (trade_goods == "merge") {
            if (instance_exists(orbiting)) {
                var _orbit = orbiting;
                var _viable_merge = false;
                var _merge_fleet = false;
                var _imperial_fleets = get_orbiting_fleets(eFACTION.IMPERIUM, _orbit);
                for (var i = 0; i < array_length(_imperial_fleets); i++) {
                    var _fleet = _imperial_fleets[i];
                    if (!_fleet.navy && _fleet.id != id) {
                        _viable_merge = true;
                        _merge_fleet = _fleet;
                        break;
                    }
                }
                if (_viable_merge) {
                    merge_fleets(_merge_fleet.id, id);
                    exit;
                } else {
                    trade_goods = "";
                }
            }
        }

        var cancel = false;
        if (string_count("Inqis", trade_goods) > 0) {
            cancel = true;
        }
        if (string_count("merge", trade_goods) > 0) {
            cancel = true;
        }
        if (trade_goods == "cancel_inspection") {
            cancel = true;
        }
        if (trade_goods == "|DELETE|") {
            cancel = true;
        }
        if (trade_goods == "return") {
            cancel = true;
        }
        if (string_count("_her", trade_goods) > 0) {
            cancel = true;
        }
        if (string_count("investigate_dead", trade_goods) > 0) {
            cancel = true;
        }
        if (string_count("spelunk", trade_goods) > 0) {
            cancel = true;
        }
        if (fleet_has_cargo("warband")) {
            cancel = true;
        }
        if (fleet_has_cargo("ork_warboss")) {
            cancel = true;
        }
        if (fleet_has_cargo("chaos")) {
            cancel = true;
        }

        if (!cancel && ((trade_goods != "return" && owner != eFACTION.TYRANIDS && owner != eFACTION.CHAOS) && fleet_has_cargo("player_goods"))) {
            if (scr_efleet_arrive_at_trade_loc()) {
                exit;
            }
        }
    }

    if ((owner == eFACTION.INQUISITION) && (string_count("_her", trade_goods) == 0)) {
        if ((_dest_star.owner == eFACTION.PLAYER) && (trade_goods == "cancel_inspection")) {
            fleet_unregister_from_star(id); // set_fleet_movement() below also unregisters. Unregister before deactivating the star for lifecycle clarity.
            instance_deactivate_object(_dest_star);
            var _pick;
            repeat (choose(1, 2)) {
                _pick = instance_nearest(x, y, obj_star);
                instance_deactivate_object(_pick);
            }

            repeat (5) {
                _pick = instance_nearest(x, y, obj_star);
                if (_pick.owner == eFACTION.ELDAR) {
                    instance_deactivate_object(_pick);
                }
            }

            _pick = instance_nearest(x, y, obj_star);
            action_x = _pick.x;
            action_y = _pick.y;
            set_fleet_movement();
            instance_activate_object(obj_star);
            trade_goods += "|DELETE|";
            exit;
        }
    }

    /*if (owner = eFACTION.IMPERIUM) and (guardsmen>0){// 135 ; guardsmen onto planet
        var en_p,en_planets,land,i;
        i=0;en_planets=0;land=0;
        
        if (sta.x=home_x) and (sta.y=home_y){
            repeat(4){i+=1;
                en_p[i]=0;
                if (sta.p_owner[i]<=eFACTION.ECCLESIARCHY){en_p[i]=1;en_planets+=1;}
            }
            
            if (guardsmen>0) and (en_planets>0){
                land=floor(guardsmen/en_planets);
                i=0;
                repeat(4){i+=1;
                    if (en_p[i]=1){guardsmen-=land;sta.p_guardsmen[i]+=land;}
                }
                if (guardsmen<5) then guardsmen=0;
            }
        }
        if (sta.owner>5) or ((sta.owner  = eFACTION.PLAYER) and (obj_controller.faction_status[eFACTION.IMPERIUM]="War")){
            repeat(4){i+=1;
                en_p[i]=0;
                if (sta.p_player[i]>0) and (obj_controller.faction_status[eFACTION.IMPERIUM]="War"){en_p[i]=1;en_planets+=1;}
            }
            
            if (guardsmen>0) and (en_planets>0){
                land=floor(guardsmen/en_planets);
                i=0;
                repeat(4){i+=1;
                    if (en_p[i]=1){guardsmen-=land;sta.p_guardsmen[i]+=land;}
                }
                if (guardsmen<5) then guardsmen=0;
            }
        }
    }*/

    if (owner == eFACTION.INQUISITION) {
        if (string_count("DELETE", trade_goods) > 0) {
            instance_destroy();
        }
        if (obj_controller.known[eFACTION.INQUISITION] == 0) {
            obj_controller.known[eFACTION.INQUISITION] = 1;
        }
    } else if (owner == eFACTION.TAU) {
        if (instance_exists(obj_p_ship)) {
            var p_ship = instance_nearest(x, y, obj_p_ship);
            if ((p_ship.action == "") && (point_distance(x, y, p_ship.x, p_ship.y) < 80)) {
                if (obj_controller.p_known[8] == 0) {
                    obj_controller.p_known[8] = 1;
                }
            }
        }
    } else if (owner == eFACTION.TYRANIDS) {
        var mess = 1, plap = instance_nearest(action_x, action_y, obj_p_fleet);

        if (instance_exists(plap)) {
            if (point_distance(plap.x, plap.y, action_x, action_y) < 80) {
                mess = 0;
            }
        }

        if ((mess == 1) && (sta.vision != 0)) {
            scr_alert("red", "owner", $"Contact has been lost with {sta.name}!", sta.x, sta.y);
            scr_event_log("red", $"Contact has been lost with {sta.name}.");
            sta.vision = 0;
        }
    }
    action_x = 0;
    action_y = 0;

    // fleet chase
    if ((string_count("Inqis", trade_goods) > 0) && (string_count("fleet", trade_goods) > 0) && (!string_count("_her", trade_goods))) {
        inquisition_fleet_inspection_chase();
    }

    var old_x = x;
    var old_y = y;
    x = -100;
    y = -100;

    var _near_fleet = instance_nearest(old_x, old_y, obj_en_fleet);
    var _arrival_behaviour = _near_fleet.image_index;

    if (_arrival_behaviour < 3) {
        _arrival_behaviour = 0;
    }
    if (_arrival_behaviour >= 3) {
        _arrival_behaviour = 10;
    }
    if ((owner == eFACTION.TAU) && (_arrival_behaviour >= 3)) {
        _arrival_behaviour = 0;
    }
    if (string_count("_her", trade_goods) == 0) {
        _arrival_behaviour = 99;
    } // was 999

    // Think this might be causing the crash
    if ((owner == eFACTION.TAU) && (sta.present_fleet[eFACTION.IMPERIUM] + sta.present_fleet[eFACTION.PLAYER] >= 1) && (sta.present_fleet[eFACTION.TAU] == 1) && (image_index == 1) && (tau_fled == 0)) {
        _arrival_behaviour = 15;
    }
    if ((_near_fleet.owner == eFACTION.TAU) && (owner == eFACTION.TAU) && (tau_fled == 1)) {
        _arrival_behaviour = 0;
    }

    if ((owner == eFACTION.CHAOS) && (fleet_has_cargo("chaos") || fleet_has_cargo("warband"))) {
        _arrival_behaviour = 0;
    }

    if ((owner == eFACTION.TAU) && (_arrival_behaviour == 15)) {
        // Get the fuck out
        var new_star = 0;
        var stue = 0;
        tau_fled = 1;

        instance_activate_object(obj_star); // new_star
        stue = instance_nearest(x, y, obj_star);

        if (image_index == 1) {
            // Start influence thing
            var tau_influence;
            var tau_influence_chance = irandom(100) + 1;
            var tau_influence_planet = irandom(stue.planets) + 1;

            with (stue) {
                if (p_type[tau_influence_planet] != "Dead") {
                    scr_alert("green", "owner", $"Tau ship broadcasts subversive messages to {planet_numeral_name(tau_influence_planet)}.", sta.x, sta.y);
                    tau_influence = p_influence[tau_influence_planet][eFACTION.TAU];

                    if ((tau_influence_chance <= 70) && (tau_influence < 70)) {
                        adjust_influence[tau_influence_planet](eFACTION.TAU, 10, tau_influence_planet);
                        if (p_type[tau_influence_planet] == "Forge") {
                            adjust_influence(eFACTION.TAU, -5, tau_influence_planet, self);
                        }
                    }

                    if ((tau_influence_chance <= 3) && (tau_influence < 70)) {
                        adjust_influence(eFACTION.TAU, 30, tau_influence_planet, self);
                        if (p_type[tau_influence_planet] == "Forge") {
                            adjust_influence(eFACTION.TAU, -25, tau_influence_planet, self);
                        }
                    }
                }
            }
        }

        instance_deactivate_object(stue);

        with (obj_star) {
            if (owner != eFACTION.TAU) {
                instance_deactivate_object(self);
            }
        }

        var good = 0;

        repeat (100) {
            if (good == 0) {
                var xx = x + choose(random(300), random(300) * -1);
                var yy = y + choose(random(300), random(300) * -1);
                new_star = instance_nearest(xx, yy, obj_star);
                if (new_star.owner != eFACTION.TAU) {
                    with (new_star) {
                        instance_deactivate_object(id);
                    }
                }
                if (new_star.owner == eFACTION.TAU) {
                    good = 1;
                }
            }
        }

        if (new_star.owner == eFACTION.TAU) {
            action_x = new_star.x;
            action_y = new_star.y;
            set_fleet_movement();
        }

        instance_activate_object(obj_star);
        // This appears bugged
    }

    x = old_x;
    y = old_y;

    var _chaos = fleet_has_cargo("warband");

    if ((_near_fleet.x == old_x) && (_near_fleet.y == old_y) && (_near_fleet.owner == self.owner) && (_near_fleet.action == "") && ((owner == eFACTION.TAU) || (owner == eFACTION.CHAOS)) && (_arrival_behaviour == 10) && (!_chaos)) {
        // Move somewhere new
        var stue2 = noone;
        var goood = 0;

        with (obj_star) {
            if (is_dead_star()) {
                instance_deactivate_object(id);
            }
        }
        var stue = instance_nearest(x, y, obj_star);
        instance_deactivate_object(stue);
        repeat (10) {
            if (goood == 0) {
                stue2 = instance_nearest(x + choose(random(400), random(400) * -1), y + choose(random(400), random(400) * -1), obj_star);
                if ((owner == eFACTION.TAU) && (stue2.owner == eFACTION.TAU)) {
                    goood = 1;
                }
                if ((owner == eFACTION.CHAOS) && (stue2.owner != eFACTION.CHAOS)) {
                    goood = 1;
                }
                if (stue2.planets == 0) {
                    goood = 0;
                }
                if ((stue.present_fleet[eFACTION.IMPERIUM] > 0) || (stue.present_fleet[eFACTION.PLAYER] > 0)) {
                    goood = 0;
                }
                if ((stue2.planets == 1) && (stue2.p_type[1] == "Dead")) {
                    goood = 0;
                }
            }
        }
        action_x = stue2.x;
        action_y = stue2.y;
        set_fleet_movement();
        instance_activate_object(obj_star);
    }

    // ORKS
    // Right here check to see if the fleet is being useless
    // If yes check for connected planet, see if not owned by orks
    // If not owned by orks then start heading that way
    // If the connected planet is owned by orks then choose a random one within 400 not owned by orks

    if (owner == eFACTION.ORK) {
        if (instance_exists(orbiting)) {
            with (orbiting) {
                ork_fleet_arrive_target();
            }
        }

        var kay = 0, temp5 = 0, temp6 = 0, temp7 = 0;

        var _nearest_star = instance_nearest(x, y, obj_star);

        // This is the new check to go along code; if doesn't add up to all planets = 7 then they exit
        if (!is_dead_star(_nearest_star)) {
            // KILL the enemy
            if ((_nearest_star.present_fleet[1] > 1) || (_nearest_star.present_fleet[2] > 1)) {
                exit;
            }
        }

        if (((_nearest_star.owner == eFACTION.CHAOS) && (image_index >= 5) && (owner == eFACTION.CHAOS)) || ((owner == eFACTION.CHAOS) && (image_index >= 5) && (_nearest_star.planets == 0))) {
            kay = 50;
        }

        if (kay == 50) {
            if (owner == eFACTION.ORK) {
                with (obj_star) {
                    if (owner == eFACTION.ORK) {
                        instance_deactivate_object(self);
                    }
                }
            }

            repeat (20) {
                if (kay == 50) {
                    temp5 = x + choose(random(300), random(300) * -1);
                    temp6 = y + choose(random(300), random(300) * -1);
                    temp7 = instance_nearest(temp5, temp6, obj_star);

                    if ((owner == eFACTION.ORK) && (temp7.owner != eFACTION.ORK) && (temp7.planets > 0) && (temp7.image_alpha >= 1)) {
                        kay = 55;
                    }
                    if ((owner == eFACTION.TAU) && (temp7.owner != eFACTION.TAU) && (temp7.planets > 0) && (temp7.image_alpha >= 1)) {
                        kay = 55;
                    }
                    if ((owner == eFACTION.CHAOS) && (temp7.owner != eFACTION.CHAOS) && (temp7.planets > 0) && (temp7.image_alpha >= 1)) {
                        kay = 55;
                    }
                }
            }

            if ((kay == 55) && instance_exists(temp7)) {
                action_x = temp7.x;
                action_y = temp7.y;
                set_fleet_movement();
            }

            instance_activate_object(obj_star);
        } else {
            fleet_register_at_star(id, _nearest_star);
        }

        instance_activate_object(obj_star);
    }

    exit;
}

/// @self Asset.GMObject.obj_en_fleet|Asset.GMObject.obj_p_fleet
function choose_fleet_sprite_image() {
    if (owner == eFACTION.IMPERIUM && !fleet_has_cargo("colonize")) {
        sprite_index = spr_fleet_imperial;
    } else if (owner == eFACTION.IMPERIUM && fleet_has_cargo("colonize")) {
        sprite_index = spr_fleet_civilian;
    } else if (owner == eFACTION.MECHANICUS) {
        sprite_index = spr_fleet_mechanicus;
    } else if ((owner == eFACTION.INQUISITION) && (string_count("_fleet", trade_goods) > 0) && (target > 0)) {
        target = instance_nearest(target_x, target_y, obj_p_fleet);
    } else if (owner == eFACTION.INQUISITION) {
        sprite_index = spr_fleet_inquisition;
    } else if (owner == eFACTION.ELDAR) {
        sprite_index = spr_fleet_eldar;
    } else if (owner == eFACTION.ORK) {
        sprite_index = spr_fleet_ork;
    } else if (owner == eFACTION.TAU) {
        sprite_index = spr_fleet_tau;
    } else if (owner == eFACTION.TYRANIDS) {
        sprite_index = spr_fleet_tyranid;
    } else if (owner == eFACTION.CHAOS) {
        sprite_index = spr_fleet_chaos;
    }
    image_speed = 0;
}

/// @param {Id.Instance.obj_en_fleet|Id.Instance.obj_p_fleet} main_fleet
/// @param {Id.Instance.obj_en_fleet|Id.Instance.obj_p_fleet} merge_fleet
function merge_fleets(main_fleet, merge_fleet) {
    main_fleet.capital_number += merge_fleet.capital_number;
    main_fleet.frigate_number += merge_fleet.frigate_number;
    main_fleet.escort_number += merge_fleet.escort_number;
    var _merge_cargo = struct_get_names(merge_fleet.cargo_data);
    //TODO custom merge stuff
    for (var i = 0; i < array_length(_merge_cargo); i++) {
        if (!struct_exists(main_fleet.cargo_data, _merge_cargo[i])) {
            main_fleet.cargo_data[$ _merge_cargo[i]] = merge_fleet.cargo_data[$ _merge_cargo[i]];
        }
    }
    instance_destroy(merge_fleet.id);
}

/// @self Asset.GMObject.obj_en_fleet|Asset.GMObject.obj_p_fleet
function fleet_respond_crusade() {
    try {
        if (owner != eFACTION.IMPERIUM) {
            exit;
        }
        if (!navy) {
            exit;
        }
        if (orbiting.owner > eFACTION.ECCLESIARCHY) {
            exit;
        }
        if (trade_goods != "") {
            exit;
        }
        if (action != "") {
            exit;
        }
        if (guardsmen_unloaded > 0) {
            exit;
        }

        // Crusade AI
        obj_controller.temp[88] = owner;
        with (obj_crusade) {
            if (owner != obj_controller.temp[88]) {
                y -= 20000;
            }
        }

        var enemu;
        with (obj_star) {
            var cs = instance_nearest(x, y, obj_crusade);

            if (point_distance(x, y, cs.x, cs.y) > cs.radius) {
                y -= 20000;
            }
            enemu = 0;

            var nids = array_reduce(
                p_tyranids,
                function(prev, curr) {
                    return prev || curr > 3;
                },
                false,
            );

            var tau = array_reduce(
                p_tau,
                function(prev, curr) {
                    return prev || curr > 0;
                },
                false,
            );

            enemu += nids + tau;

            if (present_fleet[eFACTION.ELDAR] > 0) {
                enemu += 2;
            }
            if (present_fleet[eFACTION.ORK] > 0) {
                enemu += 2;
            }
            if (present_fleet[eFACTION.TAU] > 0) {
                enemu += 2;
            }
            if (present_fleet[eFACTION.TYRANIDS] > 0) {
                enemu += 2;
            }
            if (present_fleet[eFACTION.CHAOS] > 0) {
                enemu += 2;
            }
            //nothing for heritics faction
            if (present_fleet[eFACTION.NECRONS] > 0) {
                enemu += 2;
            }
        }
        var ns = instance_nearest(x, y, obj_star);
        var ok = false;
        var max_dist = 800;
        var min_dist = 40;
        var to_ignore = [
            eFACTION.IMPERIUM,
            eFACTION.MECHANICUS,
            eFACTION.INQUISITION,
            eFACTION.ECCLESIARCHY,
        ];

        var dist = point_distance(x, y, ns.x, ns.y);
        var valid_target = !array_contains_ext(ns.p_owner, to_ignore, false);
        if (valid_target && dist <= max_dist && dist >= min_dist && (owner == eFACTION.IMPERIUM)) {
            ok = true;
        }

        // if ((ns.owner>5) or (ns.owner  = eFACTION.PLAYER)) and (point_distance(x,y,ns.x,ns.y)<=max_dis) and (point_distance(x,y,ns.x,ns.y)>40) and (owner = eFACTION.IMPERIUM){
        if (ok) {
            action_x = ns.x;
            action_y = ns.y;
            set_fleet_movement();
            home_x = orbiting.x;
            home_y = orbiting.y;

            var i;
            i = 0;
            repeat (orbiting.planets) {
                i += 1;
                if ((orbiting.p_owner[i] == eFACTION.IMPERIUM) && (orbiting.p_guardsmen[i] > 500)) {
                    guardsmen += round(orbiting.p_guardsmen[i] / 2);
                    orbiting.p_guardsmen[i] = round(orbiting.p_guardsmen[i] / 2);
                }
            }

            alarm[5] = 2;

            with (obj_crusade) {
                if (y < -10000) {
                    y += 20000;
                }
            }
            with (obj_crusade) {
                if (y < -10000) {
                    y += 20000;
                }
            }
            with (obj_star) {
                if (y < -10000) {
                    y += 20000;
                }
            }
            with (obj_star) {
                if (y < -10000) {
                    y += 20000;
                }
            }

            exit;
        }

        with (obj_crusade) {
            if (y < -10000) {
                y += 20000;
            }
        }
        with (obj_crusade) {
            if (y < -10000) {
                y += 20000;
            }
        }
        with (obj_star) {
            if (y < -10000) {
                y += 20000;
            }
        }
        with (obj_star) {
            if (y < -10000) {
                y += 20000;
            }
        }
    } catch (_ex) {
        LOGGER.error(self);
        LOGGER.error($"owner: {owner}");
        LOGGER.error($"orbiting: {orbiting}");
        if (instance_exists(orbiting)) {
            LOGGER.error($"orbiting.present_fleet: {orbiting.present_fleet}");
        }
        ERROR_HANDLER.handle_exception(_ex);
    }
}

/// @desc Registers a fleet at a star: sets orbiting and increments present_fleet.
/// @param {Id.Instance.obj_p_fleet|Id.Instance.obj_en_fleet} _fleet
/// @param {Id.Instance.obj_star} _star
function fleet_register_at_star(_fleet, _star) {
    if (!instance_exists(_star) || !instance_exists(_fleet)) {
        return;
    }

    if (_fleet.orbiting == _star) {
        return;
    }

    if (instance_exists(_fleet.orbiting)) {
        fleet_unregister_from_star(_fleet);
    }

    _fleet.orbiting = _star;
    var _faction = _fleet.owner ?? eFACTION.PLAYER;
    _star.present_fleet[_faction] += 1;

    if (_faction == eFACTION.PLAYER && _star.vision == 0) {
        _star.vision = 1;
    }
}

/// @desc Unregisters a fleet from its orbiting star (if there is one), clears orbiting and decrements present_fleet.
/// @param {Id.Instance.obj_p_fleet|Id.Instance.obj_en_fleet} _fleet
function fleet_unregister_from_star(_fleet) {
    if (!instance_exists(_fleet)) {
        return;
    }
    var _star = _fleet.orbiting;
    if (instance_exists(_star)) {
        var _faction = _fleet.owner ?? eFACTION.PLAYER;
        if (_star.present_fleet[_faction] > 0) {
            _star.present_fleet[_faction] -= 1;
        }
    }
    _fleet.orbiting = noone;
}

/// @desc Finds the nearest star within _max_distance and registers the fleet there.
/// @param {Id.Instance.obj_p_fleet|Id.Instance.obj_en_fleet} _fleet  Fleet instance to register
/// @returns {Id.Instance|noone} The star registered at, or noone if none in range
function fleet_register_at_nearest_star(_fleet, _max_distance = undefined) {
    if (!instance_exists(_fleet)) {
        return noone;
    }

    var _near = get_nearest_star(_fleet.x, _fleet.y, _max_distance);
    if (_near != noone) {
        fleet_register_at_star(_fleet, _near);
        return _near;
    }

    return noone;
}

/// @desc Creates a new player fleet, registering at the nearest star if within 50px.
/// @param {Real} _x
/// @param {Real} _y
/// @param {Array} _ships  Optional array of ship IDs to add to the fleet
/// @returns {Id.Instance.obj_p_fleet}
function create_player_fleet(_x, _y, _ships = []) {
    var _fleet = instance_create(_x, _y, obj_p_fleet);
    _fleet.owner = eFACTION.PLAYER;
    fleet_register_at_nearest_star(_fleet);

    for (var _i = 0; _i < array_length(_ships); _i++) {
        add_ship_to_fleet(_ships[_i], _fleet);
    }

    return _fleet;
}

/// @desc Creates a new enemy fleet, registering at the nearest star if within 50px.
/// @param {Real} _x
/// @param {Real} _y
/// @param {Enum.eFACTION} _owner
/// @returns {Id.Instance.obj_en_fleet}
function create_enemy_fleet(_x, _y, _owner) {
    var _fleet = instance_create(_x, _y, obj_en_fleet);
    _fleet.owner = _owner;
    fleet_register_at_nearest_star(_fleet);

    return _fleet;
}
