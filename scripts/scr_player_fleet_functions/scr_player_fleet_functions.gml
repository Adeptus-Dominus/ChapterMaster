// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more informationype

function fleet_has_roles(fleet="none", roles) {
    var all_ships = fleet_full_ship_array(fleet);
    for (var i = 0; i < all_ships; i++) {
        var _ship_struct = fetch_ship(all_ships[i]);
        var _unit_count = array_length(_ship_struct.cargo.unit_list);
        for (var u = 0; u < _unit_count; u++) {
            var _unit = fetch_unit(_ship_struct.cargo.unit_list[u]);
            if (array_contains(roles, _unit.role())) {
                return true;
            }
        }
    }
}

function split_selected_into_new_fleet(start_fleet = "none") {
    var new_fleet;
    if (start_fleet == "none") {
        new_fleet = instance_create(x, y, obj_p_fleet);
        new_fleet.owner  = eFACTION.Player;
        // Pass over ships to the new fleet, if they are selected
        var _cap = struct_get_names(capital);
        var _cap_num = array_length(_cap);
        for (var i = 0; i < _cap_num; i++) {
            if (capital[$ _cap[i]].sel) {
                move_ship_between_player_fleets(self, new_fleet, capital[$ _cap[i]]);
            }
        }

        var _fri = struct_get_names(frigate);
        var _fri_num = array_length(_fri);
        for (var i = 0; i < _fri_num; i++) {
            if (frigate[$ _fri[i]].sel) {
                move_ship_between_player_fleets(self, new_fleet, frigate[$ _fri[i]]);
            }
        }

        var _esc = struct_get_names(escort);
        var _esc_num = array_length(_esc);
        for (var i = 0; i < _esc_num; i++) {
            if (escort[$ _esc[i]].sel) {
                move_ship_between_player_fleets(self, new_fleet, escort[$ _esc[i]]);
            }
        }
        set_player_fleet_image();
    } else {
        with (start_fleet) {
            new_fleet = split_selected_into_new_fleet();
        }
    }
    return new_fleet;
}

function cancel_fleet_movement() {
    var nearest_star = instance_nearest(x, y, obj_star);
    action="";
    x=nearest_star.x;
    y=nearest_star.y;
    action_x=0;
    action_y=0;
    complex_route=[];
    just_left=false;
}

function set_new_player_fleet_course(target_array) {
    if (array_length(target_array)>0) {
        var target_planet = star_by_name(target_array[0]);
        var nearest_planet = instance_nearest(x,y,obj_star);
        var from_star = point_distance(nearest_planet.x,nearest_planet.y, x, y) < 75;
        var valid = target_planet != "none";
        if (valid) {
            valid = !(target_planet.id == nearest_planet.id && from_star);
        }
        if (!valid) {
            if (array_length(target_array) > 1) {
                target_planet = star_by_name(target_array[1]);
                array_delete(target_array, 0, 2);
            } else {
                return "complex_route_finish";
            }
        } else {
            array_delete(target_array, 0, 1);
        }
        complex_route = target_array;
        var from_x = from_star ? nearest_planet.x : x;
        var from_y = from_star ? nearest_planet.y : y;
        action_eta = calculate_fleet_eta(from_x, from_y, target_planet.x, target_planet.y, action_spd, from_star, , warp_able);
        action_x = target_planet.x;
        action_y = target_planet.y;
        action = "move";
        just_left = true;
        orbiting = 0;
        x = x + lengthdir_x(48, point_direction(x, y, action_x, action_y));
        y = y + lengthdir_y(48, point_direction(x, y, action_x, action_y));
        set_fleet_location("Warp");
    }
}

function find_and_move_ship_between_fleets(out_fleet, in_fleet, fUUID) {
    move_ship_between_player_fleets(out_fleet, in_fleet, fUUID);
}

function merge_player_fleets(main_fleet, merge_fleet) {
    var _merge_ships = fleet_full_ship_array(merge_fleet);
    for (var i = 0; i < array_length(_merge_ships); i++) {
        move_ship_between_fleets(merge_fleet, main_fleet, _merge_ships[i]);
    }

    main_fleet.alarm[7] = 1;
    if (instance_exists(obj_fleet_select)) {
        if (obj_fleet_select.x = merge_fleet.x) && (obj_fleet_select.y = merge_fleet.y) {
            with(obj_fleet_select) { instance_destroy(); }
            main_fleet.alarm[3] = 1;
        }
    }

    with (merge_fleet) {
        instance_destroy();
    }
}

function move_ship_between_player_fleets(out_fleet, in_fleet, fUUID) {
    var fUUID_hash = variable_get_hash(fUUID);
    var _class = player_ships_class(fUUID);
    switch _class {
    case "capital":
        struct_set_from_hash(in_fleet.capital, _fUUID_hash, out_fleet.capital[$ fUUID]);
        in_fleet.capital_number--;

        struct_remove_from_hash(out_fleet.capital, _fUUID_hash);
        out_fleet.capital_number--;
        break;
    case "frigate":
        struct_set_from_hash(in_fleet.frigate, _fUUID_hash, out_fleet.frigate[$ fUUID]);
        in_fleet.frigate_number--;

        struct_remove_from_hash(out_fleet.frigate, _fUUID_hash);
        out_fleet.frigate_number--;
        break;
    case "escort":
        struct_set_from_hash(in_fleet.escort, _fUUID_hash, out_fleet.escort[$ fUUID]);
        in_fleet.escort_number--;

        struct_remove_from_hash(out_fleet.escort, _fUUID_hash);
        out_fleet.escort_number--;
        break;
    }
}

function delete_ship_from_fleet(fUUID, fleet = "none") {
    if (fleet == "none") {
        var _ship_class = player_ships_class(fUUID);

        switch _ship_class {
        case "capital":
            struct_remove(capital, fUUID);
            capital_number--;
            break;
        case "frigate":
            struct_remove(frigate, fUUID);
            frigate_number--;
            break;
        case "escort":
            struct_remove(escort, fUUID);
            escort_number--;
            break;
        }
    } else {
        with (fleet) {
            delete_ship_from_fleet(fUUID);
        }
    }
}
function set_player_fleet_image() {
    var ii = 0;
    ii += capital_number;
    ii += round((frigate_number / 2));
    ii += round((escort_number / 4));
    if (ii <= 1) { ii=1; }
    image_index = min(ii, 9);
}

function find_ships_fleet(fUUID) {
    var _chosen_fleet = "none";
    var _fUUID_hash = variable_get_hash(fUUID);
    with (obj_p_fleet) {
        if ((struct_exists_from_hash(capital, _fUUID_hash)) ||
            (struct_exists_from_hash(frigate, _fUUID_hash)) ||
            (struct_exists_from_hash(escort, _fUUID_hash))) {
            _chosen_fleet = self;
        }
    }
    return _chosen_fleet;
}

function add_ship_to_fleet(fUUID, fleet = "none") {
    if (fleet == "none") {
        var _ship_class = player_ships_class(fUUID);
        var _ship = {
            sel : 0
        }

        switch _ship_class {
        case "capital":
            struct_set(capital, fUUID, _ship);
            capital_number++;
            break;
        case "frigate":
            struct_set(frigate, fUUID, _ship);
            frigate_number++;
            break;
        case "escort":
            struct_set(escort, fUUID, _ship);
            escort_number++;
            break;
        }
    } else {
        with (fleet) {
            add_ship_to_fleet(fUUID);
        }
    }
}

function player_retreat_from_fleet_combat() {
    try {
    var p_strength, ratio, diceh, _roll_100;
    var mfleet = obj_turn_end.battle_pobject[obj_turn_end.current_battle];
    var _fleet_ships = fleet_full_ship_array(mfleet);
    var en_strength = 0;

    var p_strength = mfleet.escort_number;
    p_strength += mfleet.frigate_number*3;
    p_strength += mfleet.capital_number*8;

    _roll_100 = roll_dice(1, 100, "low");
    

    var _loc_star = star_by_name(obj_turn_end.battle_location[obj_turn_end.current_battle]);

    obj_controller.temp[2001] = real(_loc_star.id);
    obj_controller.temp[2002] = real(obj_turn_end.battle_opponent[obj_turn_end.current_battle]);
    var _battle_opponent = obj_turn_end.battle_opponent[obj_turn_end.current_battle]; 

    var cap_total = 0, frig_total = 0, escort_total = 0;
    with(obj_en_fleet) {
        if (orbiting == _loc_star.id) && (owner == _battle_opponent) {
            cap_total += capital_number;
            frig_total += frigate_number;
            escort_total += escort_number;
        }
    }
    
    en_strength += cap_total * 4;
    en_strength += frig_total * 2;
    en_strength += escort_total;

    
    ratio = 9999;
    if (p_strength > 0) && (en_strength > 0) {
        ratio = (en_strength / p_strength) * 100;
    }
    
    var esc_lost = 0, frig_lost = 0, cap_lost = 0;
    
    var ship_lost = [];

    if (scr_has_adv("Kings of Space")) { _roll_100 -= 10; }
    if (_roll_100 <= 80) && (p_strength <= 2) { _roll_100 = -5; }
    
    if (_roll_100 != -5) {
        repeat(50) {
            diceh = roll_dice(1, 100, "high");
            if (diceh <= ratio) {
                ratio -= 100;
                var onceh = 0;
                
                if (mfleet.escort_number > 0) {
                    var _ship_UUIDs = struct_get_names(mfleet.escort);
                    var _ship = array_random_index(_ship_UUIDs);
                    if (!array_contains(ship_lost, _ship)) {
                        var _ship_struct = fetch_ship(_ship);
                        esc_lost += 1;
                        _ship_struct.health.hp = 0;
                        _ship_struct.lost = 1;
                        mfleet.escort_number -= 1;
                        array_push(ship_lost, _ship);
                    }
                } else if (mfleet.frigate_number > 0) {
                    var _ship_UUIDs = struct_get_names(mfleet.frigate);
                    var _ship = array_random_index(_ship_UUIDs);
                    if (!array_contains(ship_lost, _ship)) {
                        var _ship_struct = fetch_ship(_ship);
                        frig_lost += 1;
                        _ship_struct.health.hp = 0;
                        _ship_struct.lost = 1;
                        mfleet.frigate_number -= 1;
                        array_push(ship_lost, _ship);
                    }
                } else if (mfleet.capital_number > 0) {
                    var _ship_UUIDs = struct_get_names(mfleet.capital);
                    var _ship = array_random_index(_ship_UUIDs);
                    if (!array_contains(ship_lost, _ship)) {
                        var _ship_struct = fetch_ship(_ship);
                        cap_lost += 1;
                        _ship_struct.health.hp = 0;
                        _ship_struct.lost = 1;
                        mfleet.capital_number -= 1;
                        array_push(ship_lost, _ship);
                    }
                }
                if (!(mfleet.capital_number + mfleet.frigate_number + mfleet.escort_number)) {
                    break;
                }
                // show_message("Ship lost");
            }
        }
    }
    
    obj_p_fleet.selected = 0;

    with(obj_fleet_select) {
        instance_destroy();
    }
    obj_controller.popup = 0;
    if (obj_controller.zoomed = 1) {
        with(obj_controller) {
            scr_zoom();
        }
    }
    
    type = 98;
    title = "Fleet Retreating";
    cooldown = 15;
    obj_controller.menu = 0;
    
    // 139;
    with(obj_temp_inq) { instance_destroy(); }
    instance_create(obj_turn_end.battle_pobject[obj_turn_end.current_battle].x, obj_turn_end.battle_pobject[obj_turn_end.current_battle].y, obj_temp_inq);
    with(obj_en_fleet) {
        if (navy == 1) && (point_distance(x, y, obj_temp_inq.x, obj_temp_inq.y) < 40) && (trade_goods == "player_hold") { trade_goods = ""; }
    }
    with(obj_temp_inq) { instance_destroy(); }
    
    if (esc_lost + frig_lost + cap_lost > 0) && (mfleet.escort_number + mfleet.frigate_number + mfleet.capital_number > 0) {
        text = "Your fleet is given the command to fall back.  The vesels turn and prepare to enter the Warp, constantly under a hail of enemy fire.  Some of your ships remain behind to draw off the attack and give the rest of your fleet a chance to escape.  ";
        
        if (cap_lost = 1) { text += $"{cap_lost} Battle Barge is destroyed.  "; }
        if (frig_lost = 1) { text += $"{frig_lost} Strike Cruiser is destroyed.  "; }
        if (esc_lost = 1) { text += $"{esc_lost} Escort is destroyed.  "; }
        
        if (cap_lost > 1) { text += $"{cap_lost} Battle Barges were destroyed.  "; }
        if (frig_lost > 1) { text += $"{frig_lost} Strike Cruisers were destroyed.  "; }
        if (esc_lost > 1) { text += $"{esc_lost} Escorts were destroyed.  "; }
    }
    var text = "Your fleet is given the command to fall back.  The vessels turn and prepare to enter the Warp, constantly under a hail of enemy fire. ";
    if (esc_lost + frig_lost + cap_lost = 0) {
        text += "The entire fleet manages to escape with minimal damage.";
    }
    
    if (mfleet.escort_number + mfleet.frigate_number + mfleet.capital_number = 0) {
        text += "All of your ships are destroyed attempting to flee.";
    }

    with (obj_p_fleet) {
        scr_ini_ship_cleanup();

        if (player_fleet_ship_count() == 0){
            instance_destroy();
        } else {
            complex_route=[];
        }     
    }
    with(obj_fleet_select) { instance_destroy(); }
    
    /*
    with(obj_ini){scr_dead_marines(1);}
    with(obj_ini){scr_ini_ship_cleanup();}
    */
    } catch(_exception) {
        handle_exception(_exception)
    }
}

function fleet_full_ship_array(fleet = "none", exclude_capitals = false, exclude_frigates = false, exclude_escorts = false) {
    var all_ships = [];
    var capital_array = [], frigate_array = [], escort_array = [];
    if (fleet == "none") {
        if (!exclude_capitals) {
            capital_array = struct_get_names(capital);
        }

        if (!exclude_frigates) {
            frigate_array = struct_get_names(frigate);
        }

        if (!exclude_escorts) {
            escort_array = struct_get_names(escort);
        }
        all_ships = array_concat(capital_array, frigate_array, escort_array);
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
        var _ship_struct = fetch_ship(temp);
        _ship_struct.location = location;
        var _unit_count = array_length(_ship_struct.cargo.unit_list);
        for (var u = 0; u < _unit_count; i++) {
            var _unit = fetch_unit(_ship_struct.cargo.unit_list[u]);
            var _comp = _unit.company;
            var _num = _unit.marine_number;
            obj_ini.loc[co][u] = location;
        }
    }
}

function selected_ship_types() {
    var _cap = struct_get_names(capital);
    var _cap_num = array_length(_cap);
    for (var i = 0; i < _cap_num; i++) {
        if (capital[$ _cap[i]].sel) {
            capitals = true;
            break;
        }
    }

    var _fri = struct_get_names(frigate);
    var _fri_num = array_length(_fri);
    for (var i = 0; i < _fri_num; i++) {
        if (frigate[$ _fri[i]].sel) {
            frigates = true;
            break;
        }
    }

    var _esc = struct_get_names(escort);
    var _esc_num = array_length(_esc);
    for (var i = 0; i < _esc_num; i++) {
        if (escort[$ _esc[i]].sel) {
            escorts = true;
            break;
        }
    }
    return [capitals, frigates, escorts];
}

function player_fleet_ship_count(fleet = "none") {
    var ship_count = 0;
    if (fleet=="none") {
        capital_number = 0;
        frigate_number = 0;
        escort_number = 0;

        var _cap = struct_get_names(capital);
        capital_number = array_length(_cap);

        var _fri = struct_get_names(frigate);
        frigate_number = array_length(_fri);

        var _esc = struct_get_names(escort);
        escort_number = array_length(_esc);

        ship_count = capital_number + frigate_number + escort_number;
    } else {
        with(fleet) {
            ship_count = player_fleet_ship_count();
        }
    }
    return ship_count;
}

function player_fleet_selected_count(fleet = "none") {
    var ship_count = 0;
    if (fleet == "none") {
        var _cap = struct_get_names(capital);
        var _cap_num = array_length(_cap);
        for (var i = 0; i < _cap_num; i++) {
            if (capital[$ _cap[i]].sel) {
                ship_count++;
            }
        }

        var _fri = struct_get_names(frigate);
        var _fri_num = array_length(_fri);
        for (var i = 0; i < _fri_num; i++) {
            if (frigate[$ _fri[i]].sel) {
                ship_count++;
            }
        }

        var _esc = struct_get_names(escort);
        var _esc_num = array_length(_esc);
        for (var i = 0; i < _esc_num; i++) {
            if (escort[$ _esc[i]].sel) {
                ship_count++;
            }
        }
    } else {
        with(fleet) {
            ship_count = player_fleet_selected_count();
        }
    }
    return ship_count;
}

function get_nearest_player_fleet(nearest_x, nearest_y, is_static = false, is_moving = false, stop_complex_actions = true) {
    var chosen_fleet = "none";
    if instance_exists(obj_p_fleet) {
        with(obj_p_fleet) {
            var viable = !(is_static && action != "");
            if (viable && is_moving){
                if (action != "move") { viable = false; }
            }
            if (stop_complex_actions) {
                if (string_count("crusade", action) || action == "Lost") {
                    viable = false;
                }
            }
            if (!viable) { continue; }
            if (point_in_rectangle(x, y, 0, 0, room_width, room_height)) {
                if (chosen_fleet == "none") {
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

function calculate_fleet_content_size(ship_array) {
    var total_content = 0;
    for (var i = 0; i < array_length(ship_array); i++) {
        var _ship_struct = fetch_ship(ship_array[i]);
        total_content += _ship_struct.cargo.carrying;
    }
    return total_content;
}

function calculate_fleet_bombard_score(ship_array) {
    var bomb_score = 0;
    for (var i = 0; i < array_length(ship_array); i++) {
        bomb_score += ship_bombard_score(ship_array[i]);
    }
    return bomb_score;
}
