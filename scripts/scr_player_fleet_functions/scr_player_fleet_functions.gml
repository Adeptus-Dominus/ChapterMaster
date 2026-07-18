function fleet_has_roles(fleet, roles = []) {
    var all_ships = fleet_full_ship_array(fleet);
    for (var i = 0; i <= 10; i++) {
        for (var s = 0; s < array_length(obj_ini.TTRPG[i]); s++) {
            var unit = fetch_unit([i, s]);
            if (unit.planet_location < 1) {
                if (array_contains(all_ships, unit.ship_location)) {
                    if (array_contains(roles, unit.role())) {
                        return true;
                    }
                }
            }
        }
    }
}

function fleet_engaged(fleet) {
    var _engaged = false;
    var _fleet_action = fleet.action;
    if (_fleet_action != "" && _fleet_action != "move") {
        //don't inspect if engaged in non negotiable actions
        if (array_contains(global.fleet_move_options, _fleet_action)) {
            _engaged = true;
        }
    }

    return _engaged;
}

function split_selected_into_new_fleet(start_fleet) {
    var new_fleet = create_player_fleet(x, y);
    with (start_fleet) {
        // Pass over ships to the new fleet, if they are selected
        var cap_number = array_length(capital);

        for (var i = 0; i < cap_number; i++) {
            if ((capital[i] != "") && capital_sel[i]) {
                move_ship_between_player_fleets(self, new_fleet, "capital", i);
                i--;
                cap_number--;
            }
        }
        var frig_number = array_length(frigate);
        for (var i = 0; i < frig_number; i++) {
            if ((frigate[i] != "") && frigate_sel[i]) {
                move_ship_between_player_fleets(self, new_fleet, "frigate", i);
                i--;
                frig_number--;
            }
        }
        var esc_number = array_length(escort);
        for (var i = 0; i < esc_number; i++) {
            if ((escort[i] != "") && escort_sel[i]) {
                move_ship_between_player_fleets(self, new_fleet, "escort", i);
                i--;
                esc_number--;
            }
        }
        set_player_fleet_image();
    }
    return new_fleet;
}

/// @self Id.Instance.obj_p_fleet
function cancel_fleet_movement() {
    var nearest_star = instance_nearest(x, y, obj_star);
    action = "";
    x = nearest_star.x;
    y = nearest_star.y;
    action_x = 0;
    action_y = 0;
    complex_route = [];
    just_left = false;
    set_fleet_location(nearest_star.name);
    fleet_register_at_star(self, nearest_star);
}

/// @self Id.Instance.obj_p_fleet
function set_new_player_fleet_course(target_array) {
    if (array_length(target_array) > 0) {
        var target_planet = find_star_by_name(target_array[0]);
        var from_star = instance_exists(orbiting);
        var valid = target_planet != noone;
        if (valid) {
            valid = !(from_star && target_planet.id == orbiting.id);
        }
        if (!valid) {
            if (array_length(target_array) > 1) {
                target_planet = find_star_by_name(target_array[1]);
                array_delete(target_array, 0, 2);
            } else {
                return "complex_route_finish";
            }
        } else {
            array_delete(target_array, 0, 1);
        }

        complex_route = target_array;
        var from_x = from_star ? orbiting.x : x;
        var from_y = from_star ? orbiting.y : y;
        action_eta = calculate_fleet_eta(from_x, from_y, target_planet.x, target_planet.y, action_spd, from_star, true, warp_able);
        action_x = target_planet.x;
        action_y = target_planet.y;
        action = "move";
        just_left = true;

        if (from_star) {
            fleet_unregister_from_star(id);
        }

        x = x + lengthdir_x(48, point_direction(x, y, action_x, action_y));
        y = y + lengthdir_y(48, point_direction(x, y, action_x, action_y));
        set_fleet_location("Warp");
    }
}

function find_and_move_ship_between_fleets(out_fleet, in_fleet, index) {
    var _class = player_ships_class(index);
    var relative_index = -1;
    switch (_class) {
        case "capital":
            relative_index = array_get_index(out_fleet.capital_num, index);
            break;
        case "frigate":
            relative_index = array_get_index(out_fleet.frigate_num, index);
            break;
        case "escort":
            relative_index = array_get_index(out_fleet.escort_num, index);
            break;
    }
    if (relative_index != -1) {
        move_ship_between_player_fleets(out_fleet, in_fleet, _class, relative_index);
    }
}

function merge_player_fleets(main_fleet, merge_fleet) {
    var _merge_ships = fleet_full_ship_array(merge_fleet);

    for (var i = 0; i < array_length(_merge_ships); i++) {
        if (_merge_ships[i] < array_length(obj_ini.ship)) {
            find_and_move_ship_between_fleets(merge_fleet, main_fleet, _merge_ships[i]);
        }
    }

    main_fleet.alarm[7] = 1;

    if (instance_exists(obj_fleet_select)) {
        if ((obj_fleet_select.x == merge_fleet.x) && (obj_fleet_select.y == merge_fleet.y)) {
            with (obj_fleet_select) {
                instance_destroy();
            }

            main_fleet.alarm[3] = 1;
        }
    }

    if (instance_exists(obj_turn_end)) {
        for (var _bi = 0; _bi < array_length(obj_turn_end.battle_pobject); _bi++) {
            if (obj_turn_end.battle_pobject[_bi] == merge_fleet.id && obj_turn_end.battle_world[_bi] == 0) {
                obj_turn_end.battle_pobject[_bi] = main_fleet.id;
            }
        }
    }

    with (merge_fleet) {
        instance_destroy();
    }
}

function move_ship_between_player_fleets(out_fleet, in_fleet, class, index) {
    if (class == "capital") {
        array_insert(in_fleet.capital, 0, out_fleet.capital[index]);
        array_insert(in_fleet.capital_num, 0, out_fleet.capital_num[index]);
        array_insert(in_fleet.capital_uid, 0, out_fleet.capital_uid[index]);
        array_insert(in_fleet.capital_sel, 0, out_fleet.capital_sel[index]);

        in_fleet.capital_number++;
        array_delete(out_fleet.capital, index, 1);
        array_delete(out_fleet.capital_num, index, 1);
        array_delete(out_fleet.capital_uid, index, 1);
        array_delete(out_fleet.capital_sel, index, 1);

        out_fleet.capital_number--;
    } else if (class == "frigate") {
        array_insert(in_fleet.frigate, 0, out_fleet.frigate[index]);
        array_insert(in_fleet.frigate_num, 0, out_fleet.frigate_num[index]);
        array_insert(in_fleet.frigate_uid, 0, out_fleet.frigate_uid[index]);
        array_insert(in_fleet.frigate_sel, 0, out_fleet.frigate_sel[index]);
        in_fleet.frigate_number++;
        array_delete(out_fleet.frigate, index, 1);
        array_delete(out_fleet.frigate_num, index, 1);
        array_delete(out_fleet.frigate_uid, index, 1);
        array_delete(out_fleet.frigate_sel, index, 1);
        out_fleet.frigate_number--;
    } else if (class == "escort") {
        array_insert(in_fleet.escort, 0, out_fleet.escort[index]);
        array_insert(in_fleet.escort_num, 0, out_fleet.escort_num[index]);
        array_insert(in_fleet.escort_uid, 0, out_fleet.escort_uid[index]);
        array_insert(in_fleet.escort_sel, 0, out_fleet.escort_uid[index]);
        in_fleet.escort_number++;
        array_delete(out_fleet.escort, index, 1);
        array_delete(out_fleet.escort_num, index, 1);
        array_delete(out_fleet.escort_uid, index, 1);
        array_delete(out_fleet.escort_sel, index, 1);
        out_fleet.escort_number--;
    }
}

function delete_ship_from_fleet(index, fleet) {
    var _ship_class = player_ships_class(index);
    if (_ship_class == "capital") {
        var _delete_index = array_get_index(fleet.capital_num, index);
        array_delete(fleet.capital, _delete_index, 1);
        array_delete(fleet.capital_num, _delete_index, 1);
        array_delete(fleet.capital_uid, _delete_index, 1);
        array_delete(fleet.capital_sel, _delete_index, 1);

        fleet.capital_number--;
    } else if (_ship_class == "frigate") {
        var _delete_index = array_get_index(fleet.frigate_num, index);
        array_delete(fleet.frigate, _delete_index, 1);
        array_delete(fleet.frigate_num, _delete_index, 1);
        array_delete(fleet.frigate_uid, _delete_index, 1);
        array_delete(fleet.frigate_sel, _delete_index, 1);
        fleet.frigate_number--;
    } else if (_ship_class == "escort") {
        var _delete_index = array_get_index(fleet.escort_num, index);
        array_delete(fleet.escort, _delete_index, 1);
        array_delete(fleet.escort_num, _delete_index, 1);
        array_delete(fleet.escort_uid, _delete_index, 1);
        array_delete(fleet.escort_sel, _delete_index, 1);
        fleet.escort_number--;
    }
}

function set_player_fleet_image() {
    var ii = 0;
    ii += capital_number;
    ii += round((frigate_number / 2));
    ii += round((escort_number / 4));
    if (ii <= 1) {
        ii = 1;
    }
    image_index = min(ii, 9);
}

function find_ships_fleet(index) {
    var _chosen_fleet = noone;
    with (obj_p_fleet) {
        if (array_contains(capital_num, index) || array_contains(frigate_num, index) || array_contains(escort_num, index)) {
            _chosen_fleet = self;
        }
    }
    return _chosen_fleet;
}

function add_ship_to_fleet(index, fleet = noone) {
    var _escorts = [
        "Escort",
        "Hunter",
        "Gladius",
    ];
    var _capitals = [
        "Gloriana",
        "Battle Barge",
    ];
    var _frigates = ["Strike Cruiser"];

    if (fleet == noone) {
        if (array_contains(_capitals, obj_ini.ship_class[index])) {
            array_push(capital, obj_ini.ship[index]);
            array_push(capital_num, index);
            array_push(capital_sel, 0);
            array_push(capital_uid, obj_ini.ship_uid[index]);
            capital_number++;
        } else if (array_contains(_frigates, obj_ini.ship_class[index])) {
            array_push(frigate, obj_ini.ship[index]);
            array_push(frigate_num, index);
            array_push(frigate_sel, 0);
            array_push(frigate_uid, obj_ini.ship_uid[index]);
            frigate_number++;
        } else if (array_contains(_escorts, obj_ini.ship_class[index])) {
            array_push(escort, obj_ini.ship[index]);
            array_push(escort_num, index);
            array_push(escort_sel, 0);
            array_push(escort_uid, obj_ini.ship_uid[index]);
            escort_number++;
        }
    } else {
        with (fleet) {
            add_ship_to_fleet(index);
        }
    }
}

/// @desc Handles retreat from space combat.
/// @param {Id.Instance.obj_star|noone} destination_star The star to retreat to. If noone, the fleet stays in place.
function player_retreat_from_fleet_combat(destination_star = noone) {
    try {
        var _p_fleet = obj_turn_end.battle_pobject[obj_turn_end.current_battle];
        var _loc_star = find_star_by_name(obj_turn_end.battle_location[obj_turn_end.current_battle]);
        var _battle_opponent = obj_turn_end.battle_opponent[obj_turn_end.current_battle];

        // Fleet strength comparison
        var _p_strength = _p_fleet.escort_number + _p_fleet.frigate_number * 2 + _p_fleet.capital_number * 4;

        var _en_strength = 0;
        with (obj_en_fleet) {
            if (orbiting == _loc_star && owner == _battle_opponent) {
                _en_strength += escort_number + frigate_number * 2 + capital_number * 4;
            }
        }

        // Higher ratio = harder to escape with minimal losses
        var _ratio = (_p_strength > 0 && _en_strength > 0) ? (_en_strength / _p_strength) * 100 : 0;

        // Ship destruction, prefers losing escorts, then frigates, then capitals
        var _ship_lost = [];
        var _tiers = [
            {
                name: "escort",
                lost: 0,
                label: "Escort",
            },
            {
                name: "frigate",
                lost: 0,
                label: "Strike Cruiser",
            },
            {
                name: "capital",
                lost: 0,
                label: "Battle Barge",
            },
        ];

        var _roll_100 = roll_dice_chapter(1, 100, "low");
        if (scr_has_adv("Kings of Space")) {
            _roll_100 -= 10;
        }

        if (_roll_100 <= 80 && _p_strength <= 2) {
            _roll_100 = -5;
        }

        if (_roll_100 != -5 && _en_strength > 0) {
            repeat (50) {
                var _dice_high = roll_dice_chapter(1, 100, "high");
                if (_dice_high > _ratio) {
                    break;
                }

                _ratio -= 100;

                for (var t = 0; t < array_length(_tiers); t++) {
                    var _tier = _tiers[t];
                    var _number = variable_instance_get(_p_fleet, $"{_tier.name}_number");
                    if (_number > 0) {
                        var _num_arr = variable_instance_get(_p_fleet, $"{_tier.name}_num");
                        var _sid = array_random_element(_num_arr);
                        if (!array_contains(_ship_lost, _sid)) {
                            obj_ini.ship_hp[_sid] = 0;
                            variable_instance_set(_p_fleet, $"{_tier.name}_number", _number - 1);
                            array_push(_ship_lost, _sid);
                            _tier.lost += 1;
                        }

                        break;
                    }
                }

                if (_p_fleet.escort_number + _p_fleet.frigate_number + _p_fleet.capital_number == 0) {
                    break;
                }
            }
        }

        // Release any player_hold trade goods on nearby navy enemies
        with (obj_temp_inq) {
            instance_destroy();
        }

        instance_create(_p_fleet.x, _p_fleet.y, obj_temp_inq);
        with (obj_en_fleet) {
            if (navy == 1 && point_distance(x, y, obj_temp_inq.x, obj_temp_inq.y) < 40 && trade_goods == "player_hold") {
                trade_goods = "";
            }
        }

        with (obj_temp_inq) {
            instance_destroy();
        }

        // Move fleet to chosen destination
        if (instance_exists(destination_star)) {
            with (_p_fleet) {
                set_new_player_fleet_course([destination_star.name]);
            }
        }

        _p_fleet.selected = 0;

        with (obj_fleet_select) {
            instance_destroy();
        }

        obj_controller.popup = 0;

        // Build popup text
        var _total_lost = 0;
        for (var i = 0; i < array_length(_tiers); i++) {
            _total_lost += _tiers[i].lost;
        }

        var _total_remaining = _p_fleet.escort_number + _p_fleet.frigate_number + _p_fleet.capital_number;

        var _text = $"Your fleet is given the command to fall back to {destination_star.name ?? "outer space"}. The vessels turn and prepare to enter the Warp, constantly under a hail of enemy fire.";
        if (_total_lost > 0 && _total_remaining > 0) {
            _text += "\n\nSome of your ships remain behind to draw off the attack and give the rest of your fleet a chance to escape.";
            for (var t = 0; t < array_length(_tiers); t++) {
                var _casualties = _tiers[t].lost;
                if (_casualties > 0) {
                    _text += $" {_casualties} {string_plural(_tiers[t].label, _casualties)} {smart_verb("was", _casualties)} destroyed.";
                }
            }
        } else if (_total_lost == 0) {
            _text += "\n\nThe entire fleet manages to escape with minimal damage.";
        } else if (_total_remaining == 0) {
            _text += "\n\nAll of your ships are destroyed attempting to flee.";
        }

        // Show retreat narrative popup
        obj_popup.type = ePOPUP_TYPE.BATTLE_OPTIONS;
        obj_popup.title = "Fleet Retreating";
        obj_popup.text = _text;
        obj_popup.cooldown = 15;
        obj_controller.menu = 0;

        // Cleanup destroyed ships and empty fleets
        with (_p_fleet) {
            scr_ini_ship_cleanup();
            if (player_fleet_ship_count() == 0) {
                instance_destroy();
            }
        }
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

function fleet_full_ship_array(fleet = noone, exclude_capitals = false, exclude_frigates = false, exclude_escorts = false) {
    var all_ships = [];
    var _ship_count = array_length(obj_ini.ship);
    if (fleet == noone) {
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
    } else {
        with (fleet) {
            all_ships = fleet_full_ship_array();
        }
    }
    return all_ships;
}

function set_fleet_location(location) {
    var fleet_ships = fleet_full_ship_array();
    for (var i = 0; i < array_length(fleet_ships); i++) {
        var temp = fleet_ships[i];
        if (temp >= 0 && temp < array_length(obj_ini.ship_location)) {
            obj_ini.ship_location[temp] = location;
        }
    }
    for (var co = 0; co <= obj_ini.companies; co++) {
        for (var i = 0; i < array_length(obj_ini.name[co]); i++) {
            var unit = fetch_unit([co, i]);
            if (array_contains(fleet_ships, unit.ship_location)) {
                unit.location_string = location;
            }
        }
    }
}

function selected_ship_types() {
    var capitals = false;
    var frigates = false;
    var escorts = false;
    for (var i = 0; i < array_length(capital); i++) {
        if (capital[i] != "" && capital_sel[i]) {
            capitals = true;
            break;
        }
    }
    for (var i = 0; i < array_length(frigate); i++) {
        if (frigate[i] != "" && frigate_sel[i]) {
            frigates = true;
            break;
        }
    }
    for (var i = 0; i < array_length(escort); i++) {
        if (escort[i] != "" && escort_sel[i]) {
            escorts = true;
            break;
        }
    }
    return [
        capitals,
        frigates,
        escorts,
    ];
}

function player_fleet_ship_count(fleet = noone) {
    var ship_count = 0;
    if (fleet == noone) {
        capital_number = 0;
        frigate_number = 0;
        escort_number = 0;

        for (var i = 0; i < array_length(capital); i++) {
            if (capital[i] != "") {
                ship_count++;
                capital_number++;
            }
        }
        for (var i = 0; i < array_length(frigate); i++) {
            if (frigate[i] != "") {
                ship_count++;
                frigate_number++;
            }
        }
        for (var i = 0; i < array_length(escort); i++) {
            if (escort[i] != "") {
                ship_count++;
                escort_number++;
            }
        }
    } else {
        with (fleet) {
            ship_count = player_fleet_ship_count();
        }
    }
    return ship_count;
}

function player_fleet_selected_count(fleet = noone) {
    var ship_count = 0;
    if (fleet == noone) {
        for (var i = 0; i < array_length(capital); i++) {
            if (capital[i] != "" && capital_sel[i]) {
                ship_count++;
            }
        }
        for (var i = 0; i < array_length(frigate); i++) {
            if (frigate[i] != "" && frigate_sel[i]) {
                ship_count++;
            }
        }
        for (var i = 0; i < array_length(escort); i++) {
            if (escort[i] != "" && escort_sel[i]) {
                ship_count++;
            }
        }
    } else {
        with (fleet) {
            ship_count = player_fleet_selected_count();
        }
    }
    return ship_count;
}

/// @returns {Id.Instance.obj_p_fleet}
function get_nearest_player_fleet(nearest_x, nearest_y, is_static = false, is_moving = false, stop_complex_actions = true) {
    var chosen_fleet = noone;
    if (instance_exists(obj_p_fleet)) {
        with (obj_p_fleet) {
            var viable = !(is_static && action != "");
            if (viable && is_moving) {
                if (action != "move") {
                    viable = false;
                }
            }
            if (stop_complex_actions) {
                if (string_count("crusade", action) || action == "Lost") {
                    viable = false;
                }
            }
            if (!viable) {
                continue;
            }
            if (point_in_rectangle(x, y, 0, 0, room_width, room_height)) {
                if (chosen_fleet == noone) {
                    chosen_fleet = self;
                }
                if (point_distance(nearest_x, nearest_y, x, y) < point_distance(nearest_x, nearest_y, chosen_fleet.x, chosen_fleet.y)) {
                    chosen_fleet = self;
                }
            }
        }
    }
    return chosen_fleet;
}

/// @self Asset.GMObject.obj_star
function has_orbiting_player_fleet() {
    if (instance_exists(obj_p_fleet)) {
        var _nearest = instance_nearest(x, y, obj_p_fleet);
        if (point_distance(_nearest.x, _nearest.y, x, y) == 0) {
            return true;
        }
    }
    return false;
}

function calculate_fleet_content_size(ship_array) {
    var total_content = 0;
    for (var i = 0; i < array_length(ship_array); i++) {
        var _ship_id = ship_array[i];
        if (_ship_id < array_length(obj_ini.ship)) {
            total_content += obj_ini.ship_carrying[_ship_id];
        }
    }
    return total_content;
}

function calculate_fleet_bombard_score(ship_array) {
    var bomb_score = 0;
    for (var i = 0; i < array_length(ship_array); i++) {
        var _ship_id = ship_array[i];
        if (_ship_id < array_length(obj_ini.ship)) {
            bomb_score += ship_bombard_score(_ship_id);
        }
    }
    return bomb_score;
}
