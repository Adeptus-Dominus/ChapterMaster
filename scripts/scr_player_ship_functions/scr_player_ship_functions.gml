function return_lost_ships_chance() {
    if (array_contains(obj_ini.ship_location, "Lost")) {
        if (roll_dice_chapter(1, 100, "high") > 97) {
            return_lost_ship();
        }
    }
}

function return_lost_ship() {
    var _return_id = get_valid_player_ship("Lost");
    if (_return_id != -1) {
        var _lost_fleet = noone;
        with (obj_p_fleet) {
            if (action == "Lost") {
                _lost_fleet = id;
                break;
            }
        }
        var _star = instance_find(obj_star, irandom(instance_number(obj_star) - 1));
        var _new_fleet = create_player_fleet(_star.x, _star.y);
        if (_lost_fleet != noone) {
            find_and_move_ship_between_fleets(_lost_fleet, _new_fleet, _return_id);
            if (player_fleet_ship_count(_lost_fleet) == 0) {
                with (_lost_fleet) {
                    instance_destroy();
                }
            }
        } else {
            add_ship_to_fleet(_return_id, _new_fleet);
        }

        var _return_defect = roll_dice_chapter(1, 100, "high");
        var _text = $"The ship {obj_ini.ship[_return_id]} has returned to real space and is now orbiting the {_star.name} system\n";

        static unit_effects = {
            "geller_fail": function(unit) {
                unit.edit_corruption(max(0, irandom_range(20, 120) - unit.piety));
            },
        };
        if (_return_defect < 90) {
            var _units = collect_role_group("all", [_star.name, 0, _return_id], false, {}, true);
            _units.shuffle();
            var _bool_units = bool(_units.number());

            if (_return_defect > 80) {
                obj_ini.ship_hp[_return_id] *= random_range(0.2, 0.8);
                _text += $"Reports indicate it has suffered damage as a result of it's time in the warp";
            } else if (_return_defect > 70) {
                var _techs = _units.get_from({group: SPECIALISTS_TECHS});
                if (bool(_techs.number())) {
                    _techs.kill_percent(100);
                }
            } else if (_return_defect > 60) {
                if (_bool_units) {
                    _text += $"While in the warp the geller fields temporarily went down leaving the ships crew to face the horror of the warp";
                    _units.for_each(unit_effects.geller_fail);
                }
            } else if (_return_defect > 50) {
                if (_units.number() > 1) {
                    _text += $"The ship was stuck in the warp for many years so many that even the resolve of the marines began to breakdown, there was a mutiney as many marines thought they would be best to try their luck as renegades in the warp. Those who remained loyal to you prevailed but their geneseed was burnt for fear of corruption";
                    _units.kill_percent(50, true, false);
                }
            } else if (_return_defect > 40) {
                if (_bool_units) {
                    _text += $"The ship is empty, what happened to the origional crew is a mystery";
                    _units.kill_percent(100, false, false);
                }
            } else if (_return_defect > 20) {
                //This would be an awsome oppertunity and ideal kick off place to allow a redemtion arc either liberating the ship or some of your captured marines  gene seed other bits
                _text += $"The fate of your ship {obj_ini.ship[_return_id]} has now become clear\n A Chaos fleet has warped into the {_star.name} system with your once prized ship now a part of it";
                if (_bool_units) {
                    _text += $"You must assume the worst for your crew";
                    _units.kill_percent(100, false, false);
                }

                scr_kill_ship(_return_id);
                var _chaos_fleet = spawn_chaos_fleet_at_system(_star);
                var fleet_strength = floor(((100 - roll_dice_chapter(1, 100, "low")) / 10) + 3);
                distribute_strength_to_fleet(fleet_strength, _chaos_fleet);
                with (_new_fleet) {
                    instance_destroy();
                }
            } else {
                _text += $"The fate of your ship {obj_ini.ship[_return_id]} has now become clear. While it did not survive it's travels through the warp and tore itself apart somewhere in the  {_star.name} system. ";
                scr_kill_ship(_return_id);
                if (player_fleet_ship_count(_new_fleet) == 0) {
                    with (_new_fleet) {
                        instance_destroy();
                    }
                }
                if (array_length(_units) > 0) {
                    _text += "Some of your astartes may have been able to jetison and survive the ships destruction";
                }
                //TODO finish off the jettisoned marines logic
            }
            //More scenarios needed but this is a good start
        }
        scr_popup("Ship Returns", _text, "lost_warp", "");
        if (_lost_fleet != noone) {
            if (!player_fleet_ship_count(_lost_fleet)) {
                with (_lost_fleet) {
                    instance_destroy();
                }
            }
        }
    }
}

function get_player_ships(location = "", name = "") {
    var _ships = [];
    for (var i = 0; i < array_length(obj_ini.ship); i++) {
        if (obj_ini.ship[i] != "") {
            if (location == "") {
                array_push(_ships, i);
            } else {
                if (obj_ini.ship_location[i] == location) {
                    array_push(_ships, i);
                }
            }
        }
    }
    return _ships;
}

/// @desc Generic per-ship, per-turn action-use counter for the ship action economy. _kind
/// is "assault" (ground assault), "bombard", or "raid"; each has its OWN independent
/// counter (obj_ini.ship_<kind>_uses / obj_ini.ship_<kind>_turn), so spending one action
/// never consumes another. Counters are keyed to obj_controller.turn, so a stored count
/// from any earlier turn reads as zero: no per-turn reset pass and nothing new to save
/// (after a load the counters simply start fresh). Out-of-range or missing arrays read as
/// zero.
function ship_action_used(ship_index, _kind) {
    if (ship_index < 0) {
        return 0;
    }
    var _uses_var = "ship_" + _kind + "_uses";
    var _turn_var = "ship_" + _kind + "_turn";
    if (!variable_instance_exists(obj_ini, _uses_var) || !variable_instance_exists(obj_ini, _turn_var)) {
        return 0;
    }
    var _uses = variable_instance_get(obj_ini, _uses_var);
    var _turn = variable_instance_get(obj_ini, _turn_var);
    if ((ship_index >= array_length(_uses)) || (ship_index >= array_length(_turn))) {
        return 0;
    }
    if (_turn[ship_index] != obj_controller.turn) {
        return 0;
    }
    return _uses[ship_index];
}

/// @desc Spend one use of action _kind on this ship for the current turn.
function ship_action_spend(ship_index, _kind) {
    if (ship_index < 0) {
        return;
    }
    var _uses_var = "ship_" + _kind + "_uses";
    var _turn_var = "ship_" + _kind + "_turn";
    if (!variable_instance_exists(obj_ini, _uses_var)) {
        variable_instance_set(obj_ini, _uses_var, []);
    }
    if (!variable_instance_exists(obj_ini, _turn_var)) {
        variable_instance_set(obj_ini, _turn_var, []);
    }
    var _uses = variable_instance_get(obj_ini, _uses_var);
    var _turn = variable_instance_get(obj_ini, _turn_var);
    while (array_length(_uses) <= ship_index) {
        array_push(_uses, 0);
    }
    while (array_length(_turn) <= ship_index) {
        array_push(_turn, -1);
    }
    if (_turn[ship_index] != obj_controller.turn) {
        _turn[ship_index] = obj_controller.turn;
        _uses[ship_index] = 0;
    }
    _uses[ship_index] += 1;
    variable_instance_set(obj_ini, _uses_var, _uses);
    variable_instance_set(obj_ini, _turn_var, _turn);
}

/// @desc How many ground assaults this ship has supported this turn (its own counter,
/// independent of bombardment and raids).
function ship_assaults_used(ship_index) {
    return ship_action_used(ship_index, "assault");
}

/// @desc Spend one ground assault support use on this ship for the current turn.
function ship_assault_spend(ship_index) {
    ship_action_spend(ship_index, "assault");
}

/// @desc How many orbital bombardments this ship has run this turn (its own counter,
/// independent of ground assaults and raids).
function ship_bombards_used(ship_index) {
    return ship_action_used(ship_index, "bombard");
}

/// @desc How many raids this ship has supported this turn (its own counter, independent
/// of ground assaults and bombardment).
function ship_raids_used(ship_index) {
    return ship_action_used(ship_index, "raid");
}

/// @desc How many ground assaults this planet's local forces have supported this turn.
/// Same epoch-keyed pattern as the ship counters, stored on the star instance: counts
/// from earlier turns read as zero, missing arrays read as zero, nothing new is saved.
function local_assaults_used(star_object, planet_number) {
    if (!instance_exists(star_object) || (planet_number < 0)) {
        return 0;
    }
    if (!variable_instance_exists(star_object, "local_assault_uses") || !variable_instance_exists(star_object, "local_assault_turn")) {
        return 0;
    }
    if ((planet_number >= array_length(star_object.local_assault_uses)) || (planet_number >= array_length(star_object.local_assault_turn))) {
        return 0;
    }
    if (star_object.local_assault_turn[planet_number] != obj_controller.turn) {
        return 0;
    }
    return star_object.local_assault_uses[planet_number];
}

/// @desc Spend one ground assault support use from this planet's local forces.
function local_assault_spend(star_object, planet_number) {
    if (!instance_exists(star_object) || (planet_number < 0)) {
        return;
    }
    if (!variable_instance_exists(star_object, "local_assault_uses")) {
        star_object.local_assault_uses = [];
    }
    if (!variable_instance_exists(star_object, "local_assault_turn")) {
        star_object.local_assault_turn = [];
    }
    while (array_length(star_object.local_assault_uses) <= planet_number) {
        array_push(star_object.local_assault_uses, 0);
    }
    while (array_length(star_object.local_assault_turn) <= planet_number) {
        array_push(star_object.local_assault_turn, -1);
    }
    if (star_object.local_assault_turn[planet_number] != obj_controller.turn) {
        star_object.local_assault_turn[planet_number] = obj_controller.turn;
        star_object.local_assault_uses[planet_number] = 0;
    }
    star_object.local_assault_uses[planet_number] += 1;
}

function new_player_ship_defaults() {
    with (obj_ini) {
        array_push(ship, "");
        array_push(ship_uid, 0);
        array_push(ship_owner, 0);
        array_push(ship_class, "");
        array_push(ship_size, 0);
        array_push(ship_leadership, 0);
        array_push(ship_hp, 0);
        array_push(ship_maxhp, 0);
        array_push(ship_location, "");
        array_push(ship_shields, 0);
        array_push(ship_conditions, "");
        array_push(ship_speed, 0);
        array_push(ship_turning, 0);
        array_push(ship_front_armour, 0);
        array_push(ship_other_armour, 0);
        array_push(ship_weapons, 0);
        array_push(ship_wep, array_create(6, ""));
        array_push(ship_wep_facing, array_create(6, ""));
        array_push(ship_wep_condition, array_create(6, ""));
        array_push(ship_capacity, 0);
        array_push(ship_carrying, 0);
        array_push(ship_contents, "");
        array_push(ship_turrets, 0);
        array_push(ship_guardsmen, 0);
        array_push(ship_guardsmen_max, 0);
    }
    return array_length(obj_ini.ship) - 1;
}

function get_valid_player_ship(location = "", name = "") {
    for (var i = 0; i < array_length(obj_ini.ship); i++) {
        if (obj_ini.ship[i] != "") {
            if (location == "") {
                return i;
            } else {
                if (obj_ini.ship_location[i] == location) {
                    return i;
                }
            }
        }
    }
    return -1;
}

function loose_ship_to_warp_event() {
    var eligible_fleets = [];
    with (obj_p_fleet) {
        if (action == "move") {
            array_push(eligible_fleets, id);
        }
    }

    if (array_length(eligible_fleets) == 0) {
        //LOGGER.debug("RE: Ship Lost, couldn't find a player fleet");
        exit;
    }

    var _fleet = array_random_element(eligible_fleets);
    var _ships = fleet_full_ship_array(_fleet);
    var _ship_index = array_random_element(_ships);

    var text = "The ";

    text += $"{ship_class_name(_ship_index)} has been lost to the miasma of the warp.";

    var marine_count = scr_count_marines_on_ship(_ship_index);
    if (marine_count > 0) {
        text += $"  {marine_count} Battle Brothers were onboard.";
    }
    scr_event_log("red", text);
    var _lost_ship_fleet = noone;
    with (obj_p_fleet) {
        if (action == "Lost") {
            _lost_ship_fleet = id;
        }
    }
    if (_lost_ship_fleet == noone) {
        _lost_ship_fleet = create_player_fleet(-500, -500);
    }

    find_and_move_ship_between_fleets(_fleet, _lost_ship_fleet, _ship_index);
    with (_lost_ship_fleet) {
        set_fleet_location("Lost");
    }

    var unit;
    for (var company = 0; company <= obj_ini.companies; company++) {
        for (var marine = 0; marine < array_length(obj_ini.role[company]); marine++) {
            if (obj_ini.name[company][marine] == "") {
                continue;
            }
            unit = fetch_unit([company, marine]);
            if (unit.ship_location == _ship_index) {
                unit.location_string = "Lost";
            }
        }
        for (var vehicle = 1; vehicle <= 100; vehicle++) {
            if (obj_ini.veh_lid[company][vehicle] == _ship_index) {
                obj_ini.veh_loc[company][vehicle] = "Lost";
            }
        }
    }

    _lost_ship_fleet.action = "Lost";
    fleet_unregister_from_star(_lost_ship_fleet);
    _lost_ship_fleet.alarm[1] = 2;

    scr_popup("Ship Lost", text, "lost_warp", "");

    if (player_fleet_ship_count(_fleet) == 0) {
        with (_fleet) {
            instance_destroy();
        }
    }
}

//TODO make method for setting ship weaponry
function new_player_ship(type, start_loc = "home", new_name = "") {
    var index = new_player_ship_defaults();

    for (var k = 0; k <= 200; k++) {
        if (new_name == "") {
            new_name = global.name_generator.GenerateFromSet("imperial_ship");
            if (array_contains(obj_ini.ship, new_name)) {
                new_name = "";
            }
        } else {
            break;
        }
    }
    if (start_loc == "home") {
        start_loc = obj_ini.home_name;
    }
    obj_ini.ship[index] = new_name;
    obj_ini.ship_uid[index] = floor(random(99999999)) + 1;
    obj_ini.ship_owner[index] = 1; //TODO: determine if this means the player or not
    obj_ini.ship_size[index] = 1;
    obj_ini.ship_location[index] = start_loc;
    obj_ini.ship_leadership[index] = 100;
    if (string_count("Battle Barge", type) > 0) {
        obj_ini.ship_class[index] = "Battle Barge";
        obj_ini.ship_size[index] = 3;
        obj_ini.ship_hp[index] = 1200;
        obj_ini.ship_maxhp[index] = 1200;
        obj_ini.ship_conditions[index] = "";
        obj_ini.ship_speed[index] = 20;
        obj_ini.ship_turning[index] = 45;
        obj_ini.ship_front_armour[index] = 6;
        obj_ini.ship_other_armour[index] = 6;
        obj_ini.ship_weapons[index] = 5;
        obj_ini.ship_shields[index] = 12;
        obj_ini.ship_wep[index][1] = "Weapons Battery";
        obj_ini.ship_wep_facing[index][1] = "left";
        obj_ini.ship_wep_condition[index][1] = "";
        obj_ini.ship_wep[index][2] = "Weapons Battery";
        obj_ini.ship_wep_facing[index][2] = "right";
        obj_ini.ship_wep_condition[index][2] = "";
        obj_ini.ship_wep[index][3] = "Thunderhawk Launch Bays";
        obj_ini.ship_wep_facing[index][3] = "special";
        obj_ini.ship_wep_condition[index][3] = "";
        obj_ini.ship_wep[index][4] = "Torpedo Tubes";
        obj_ini.ship_wep_facing[index][4] = "front";
        obj_ini.ship_wep_condition[index][4] = "";
        obj_ini.ship_wep[index][5] = "Macro Bombardment Cannons";
        obj_ini.ship_wep_facing[index][5] = "most";
        obj_ini.ship_wep_condition[index][5] = "";
        obj_ini.ship_capacity[index] = 600;
        obj_ini.ship_guardsmen_max[index] = 500000;  // Battle Barge: Guard auxilia capacity
        obj_ini.ship_guardsmen[index] = 0;
        obj_ini.ship_carrying[index] = 0;
        obj_ini.ship_contents[index] = "";
        obj_ini.ship_turrets[index] = 3;
    }
    if (string_count("Strike Cruiser", type) > 0) {
        obj_ini.ship_class[index] = "Strike Cruiser";
        obj_ini.ship_size[index] = 2;
        obj_ini.ship_hp[index] = 600;
        obj_ini.ship_maxhp[index] = 600;
        obj_ini.ship_conditions[index] = "";
        obj_ini.ship_speed[index] = 25;
        obj_ini.ship_turning[index] = 90;
        obj_ini.ship_front_armour[index] = 6;
        obj_ini.ship_other_armour[index] = 6;
        obj_ini.ship_weapons[index] = 4;
        obj_ini.ship_shields[index] = 6;
        obj_ini.ship_wep[index][1] = "Weapons Battery";
        obj_ini.ship_wep_facing[index][1] = "left";
        obj_ini.ship_wep_condition[index][1] = "";
        obj_ini.ship_wep[index][2] = "Weapons Battery";
        obj_ini.ship_wep_facing[index][2] = "right";
        obj_ini.ship_wep_condition[index][2] = "";
        obj_ini.ship_wep[index][3] = "Thunderhawk Launch Bays";
        obj_ini.ship_wep_facing[index][3] = "special";
        obj_ini.ship_wep_condition[index][3] = "";
        obj_ini.ship_wep[index][4] = "Bombardment Cannons";
        obj_ini.ship_wep_facing[index][4] = "most";
        obj_ini.ship_wep_condition[index][4] = "";
        obj_ini.ship_capacity[index] = 250;
        obj_ini.ship_guardsmen_max[index] = 150000;  // Strike Cruiser: Guard auxilia capacity
        obj_ini.ship_guardsmen[index] = 0;
        obj_ini.ship_carrying[index] = 0;
        obj_ini.ship_contents[index] = "";
        obj_ini.ship_turrets[index] = 1;
    }
    if (string_count("Gladius", type) > 0) {
        obj_ini.ship_class[index] = "Gladius";
        obj_ini.ship_hp[index] = 200;
        obj_ini.ship_maxhp[index] = 200;
        obj_ini.ship_conditions[index] = "";
        obj_ini.ship_speed[index] = 30;
        obj_ini.ship_turning[index] = 90;
        obj_ini.ship_front_armour[index] = 5;
        obj_ini.ship_other_armour[index] = 5;
        obj_ini.ship_weapons[index] = 1;
        obj_ini.ship_shields[index] = 1;
        obj_ini.ship_wep[index][1] = "Weapons Battery";
        obj_ini.ship_wep_facing[index][1] = "most";
        obj_ini.ship_wep_condition[index][1] = "";
        obj_ini.ship_capacity[index] = 30;
        obj_ini.ship_guardsmen_max[index] = 0;       // Gladius escort: no Guard capacity
        obj_ini.ship_guardsmen[index] = 0;
        obj_ini.ship_carrying[index] = 0;
        obj_ini.ship_contents[index] = "";
        obj_ini.ship_turrets[index] = 1;
    }
    if (string_count("Hunter", type) > 0) {
        obj_ini.ship_class[index] = "Hunter";
        obj_ini.ship_hp[index] = 200;
        obj_ini.ship_maxhp[index] = 200;
        obj_ini.ship_conditions[index] = "";
        obj_ini.ship_speed[index] = 30;
        obj_ini.ship_turning[index] = 90;
        obj_ini.ship_front_armour[index] = 5;
        obj_ini.ship_other_armour[index] = 5;
        obj_ini.ship_weapons[index] = 2;
        obj_ini.ship_shields[index] = 1;
        obj_ini.ship_wep[index][1] = "Torpedoes";
        obj_ini.ship_wep_facing[index][1] = "front";
        obj_ini.ship_wep_condition[index][1] = "";
        obj_ini.ship_wep[index][2] = "Weapons Battery";
        obj_ini.ship_wep_facing[index][2] = "most";
        obj_ini.ship_wep_condition[index][2] = "";
        obj_ini.ship_capacity[index] = 25;
        obj_ini.ship_guardsmen_max[index] = 0;       // Hunter escort: no Guard capacity
        obj_ini.ship_guardsmen[index] = 0;
        obj_ini.ship_carrying[index] = 0;
        obj_ini.ship_contents[index] = "";
        obj_ini.ship_turrets[index] = 1;
    }
    if (string_count("Gloriana", type) > 0) {
        obj_ini.ship[index] = new_name;
        obj_ini.ship_size[index] = 3;

        obj_ini.ship_class[index] = "Gloriana";

        obj_ini.ship_hp[index] = 2400;
        obj_ini.ship_maxhp[index] = 2400;
        obj_ini.ship_conditions[index] = "";
        obj_ini.ship_speed[index] = 25;
        obj_ini.ship_turning[index] = 60;
        obj_ini.ship_front_armour[index] = 8;
        obj_ini.ship_other_armour[index] = 8;
        obj_ini.ship_weapons[index] = 4;
        obj_ini.ship_shields[index] = 24;
        obj_ini.ship_wep[index][1] = "Lance Battery";
        obj_ini.ship_wep_facing[index][1] = "most";
        obj_ini.ship_wep_condition[index][1] = "";
        obj_ini.ship_wep[index][2] = "Lance Battery";
        obj_ini.ship_wep_facing[index][2] = "most";
        obj_ini.ship_wep_condition[index][2] = "";
        obj_ini.ship_wep[index][3] = "Lance Battery";
        obj_ini.ship_wep_facing[index][3] = "most";
        obj_ini.ship_wep_condition[index][3] = "";
        obj_ini.ship_wep[index][4] = "Plasma Cannon";
        obj_ini.ship_wep_facing[index][4] = "front";
        obj_ini.ship_wep_condition[index][4] = "";
        obj_ini.ship_wep[index][5] = "Macro Bombardment Cannons";
        obj_ini.ship_wep_facing[index][5] = "most";
        obj_ini.ship_wep_condition[index][5] = "";
        obj_ini.ship_capacity[index] = 800;
        obj_ini.ship_guardsmen_max[index] = 1000000; // Gloriana: Guard auxilia capacity
        obj_ini.ship_guardsmen[index] = 0;
        obj_ini.ship_carrying[index] = 0;
        obj_ini.ship_contents[index] = "";
        obj_ini.ship_turrets[index] = 8;
    }
    return index;
}

function ship_class_name(index) {
    var _ship_name = obj_ini.ship[index];
    var _ship_class = obj_ini.ship_class[index];
    return $"{_ship_class} '{_ship_name}'";
}

function player_ships_class(index) {
    var _escorts = [
        "Escort",
        "Hunter",
        "Gladius",
    ];
    var _capitals = [
        "Gloriana",
        "Battle Barge",
        "Capital",
    ];
    var _frigates = [
        "Strike Cruiser",
        "Frigate",
    ];
    var _ship_name_class = obj_ini.ship_class[index];
    if (array_contains(_escorts, _ship_name_class)) {
        return "escort";
    } else if (array_contains(_capitals, _ship_name_class)) {
        return "capital";
    } else if (array_contains(_frigates, _ship_name_class)) {
        return "frigate";
    }
    return _ship_name_class;
}

function ship_bombard_score(ship_id) {
    var _bomb_score = 0;
    static weapon_bomb_scores = {
        "Bombardment Cannons": {
            value: 1,
        },
        "Macro Bombardment Cannons": {
            value: 2,
        },
        "Plasma Cannon": {
            value: 4,
        },
        "Torpedo Tubes": {
            value: 1,
        },
    };
    for (var b = 0; b < array_length(obj_ini.ship_wep[ship_id]); b++) {
        var _wep = obj_ini.ship_wep[ship_id][b];
        if (struct_exists(weapon_bomb_scores, _wep)) {
            _bomb_score += weapon_bomb_scores[$ _wep].value;
        }
    }

    return _bomb_score;
}

// =====================================================================
//  Imperial Guard Auxilia  -  player embark / deploy / raise
//  Added by mod. Uses the same p_guardsmen planetary force the Imperial
//  Navy uses, so deployed Guard plug straight into the ground-war AI.
// =====================================================================

/// @description Pad the parallel Guard arrays out to ship[] length so that indexing
///              ship_guardsmen[i] by a ship index is always safe. ship_guardsmen starts
///              empty and only grows as ships are added during play, so a loaded save
///              (especially one predating these arrays) can restore ship[] while leaving
///              ship_guardsmen shorter or empty. Without this, reading ship_guardsmen[i]
///              for a real ship throws "index out of range".
function ensure_ship_guardsmen_arrays() {
    with (obj_ini) {
        var _n = array_length(ship);
        while (array_length(ship_guardsmen) < _n) {
            array_push(ship_guardsmen, 0);
        }
        while (array_length(ship_guardsmen_max) < _n) {
            array_push(ship_guardsmen_max, 0);
        }
    }
}

/// @description Total Imperial Guard auxilia currently embarked across all player ships.
/// @returns {real}
function player_guardsmen_embarked() {
    var _total = 0;
    with (obj_ini) {
        for (var i = 0; i < array_length(ship_guardsmen); i++) {
            _total += ship_guardsmen[i];
        }
    }
    return _total;
}

/// @description Embark Guard from a world you own onto your ships in that system.
///              Pulls from the planet garrison (p_guardsmen) and fills each ship up
///              to its ship_guardsmen_max. Returns the number actually loaded.
/// @param {string} system_name  Star system name (e.g. obj_ini.home_name)
/// @param {real}   planet       Planet index in that system (e.g. obj_ini.home_planet)
/// @returns {real}
function embark_guardsmen(system_name, planet) {
    var _star = find_star_by_name(system_name);
    if (_star == "none") {
        return 0;
    }
    if (_star.p_owner[planet] != eFACTION.PLAYER) {
        return 0; // only from worlds you control
    }

    var _pdata = new PlanetData(planet, _star);
    var _available = _pdata.guardsmen;
    if (_available <= 0) {
        return 0; // nothing garrisoned to pick up
    }

    var _loaded = 0;
    ensure_ship_guardsmen_arrays();
    with (obj_ini) {
        for (var i = 0; i < array_length(ship); i++) {
            if (ship[i] == "") continue;                   // empty roster slot
            if (ship_location[i] != system_name) continue; // ship must be here
            var _space = ship_guardsmen_max[i] - ship_guardsmen[i];
            if (_space <= 0) continue;                      // no hull room (escorts = 0)
            var _take = min(_space, _available - _loaded);
            if (_take <= 0) break;
            ship_guardsmen[i] += _take;
            _loaded += _take;
            if (_loaded >= _available) break;
        }
    }

    _pdata.edit_guardsmen(-_loaded); // remove what we embarked from the planet
    return _loaded;
}

/// @description Deploy all embarked Guard from your ships in a system onto a planet.
///              Adds them to p_guardsmen so the ground-war AI fields them.
/// @param {string} system_name  Star system the fleet is in
/// @param {real}   planet       Planet index to garrison
/// @returns {real}
function deploy_guardsmen(system_name, planet) {
    var _star = find_star_by_name(system_name);
    if (_star == "none") {
        return 0;
    }

    var _unloaded = 0;
    ensure_ship_guardsmen_arrays();
    with (obj_ini) {
        for (var i = 0; i < array_length(ship); i++) {
            if (ship[i] == "") continue;
            if (ship_location[i] != system_name) continue;
            if (ship_guardsmen[i] <= 0) continue;
            _unloaded += ship_guardsmen[i];
            ship_guardsmen[i] = 0;
        }
    }
    if (_unloaded <= 0) {
        return 0;
    }

    var _pdata = new PlanetData(planet, _star);
    _pdata.edit_guardsmen(_unloaded);
    return _unloaded;
}

/// @description OPTIONAL: raise fresh Guard from a controlled world's population,
///              adding them to that world's garrison so you can then embark them.
///              Mirrors the Imperial Navy recruit idiom, so it is safe on both
///              "small" and "large" population worlds.
/// @param {string} system_name
/// @param {real}   planet
/// @param {real}   amount      headcount of Guard to raise
/// @returns {real}
function tithe_guardsmen(system_name, planet, amount) {
    var _star = find_star_by_name(system_name);
    if (_star == "none") {
        return 0;
    }
    if (_star.p_owner[planet] != eFACTION.PLAYER) {
        return 0;
    }

    var _pdata = new PlanetData(planet, _star);
    var _headcount = _pdata.population_as_small();
    if (_headcount <= 0) {
        return 0;
    }

    amount = min(amount, _headcount);
    _pdata.edit_population(-_pdata.population_large_conversion(amount));
    _pdata.edit_guardsmen(amount);
    return amount;
}

/// @description Total embarked Guard on player ships currently at a given system.
/// @param {string} system_name
/// @returns {real}
function player_guardsmen_at(system_name) {
    ensure_ship_guardsmen_arrays();
    var _total = 0;
    with (obj_ini) {
        for (var i = 0; i < array_length(ship); i++) {
            if (ship[i] == "") continue;
            if (ship_location[i] != system_name) continue;
            _total += ship_guardsmen[i];
        }
    }
    return _total;
}

/// @desc Whether a raid can still be supported at this star this turn: any carrying ship
/// with raid uses left (its own counter), or the planet's local forces with local uses
/// left. Ship raid uses are independent of ground-assault and bombardment uses, so
/// bombarding or attacking with a ship does not block raiding with it.
function can_ground_deploy(star_object, planet_number) {
    if (!instance_exists(star_object)) {
        return false;
    }
    var _ships = get_player_ships(star_object.name);
    for (var i = 0; i < array_length(_ships); i++) {
        if ((obj_ini.ship_carrying[_ships[i]] > 0) && (ship_raids_used(_ships[i]) < SHIP_ASSAULTS_PER_TURN)) {
            return true;
        }
    }
    if ((star_object.p_player[planet_number] > 0) && (local_assaults_used(star_object, planet_number) < SHIP_ASSAULTS_PER_TURN)) {
        return true;
    }
    return false;
}

/// @desc First ship at this star that has not yet bombarded this turn, or -1. Bombardment
/// is one per ship per turn on its own counter, independent of ground support.
function get_fresh_bombard_ship(location) {
    var _ships = get_player_ships(location);
    for (var i = 0; i < array_length(_ships); i++) {
        if (ship_bombards_used(_ships[i]) == 0) {
            return _ships[i];
        }
    }
    return -1;
}

/// @desc Spend a ship's one bombardment use for the turn, on its own counter. This is
/// independent of the ship's ground assault and raid support, so a ship can bombard and
/// still land troops (attack or raid) the same turn.
function ship_bombard_spend(ship_index) {
    if (ship_index < 0) {
        return;
    }
    ship_action_spend(ship_index, "bombard");
}

/// @function recall_forces_at_world
/// @description "Recall Forces": re-embarks the player's planetside units on a world back
///              onto the SAME ship each came from (matched by the ship uid each unit recorded
///              when it disembarked). A unit whose origin ship is gone, not at this world, or
///              full is LEFT planetside and counted for a warning, so nothing is silently
///              lost or mixed onto the wrong hull. Returns a struct {recalled, stranded}.
/// @param {Id.Instance.obj_star} _star  the world to recall from
/// @returns {Struct}
function recall_forces_at_world(_star) {
    var _recalled = 0;
    var _stranded = 0;
    if (!instance_exists(_star)) {
        return { recalled: 0, stranded: 0 };
    }
    var _star_name = _star.name;

    // Map ship uid -> ship id for ships currently AT this world (so we only board ships in orbit).
    var _uid_to_id = {};
    for (var s = 0; s < array_length(obj_ini.ship); s++) {
        if (obj_ini.ship[s] == "") {
            continue;
        }
        if (obj_ini.ship_location[s] == _star_name) {
            _uid_to_id[$ string(obj_ini.ship_uid[s])] = s;
        }
    }

    // Walk every player unit; re-embark the planetside ones on this world.
    for (var _co = 0; _co <= obj_ini.companies; _co++) {
        var _names = obj_ini.name[_co];
        for (var _mi = 0; _mi < array_length(_names); _mi++) {
            var _unit = fetch_unit([_co, _mi]);
            if (!is_struct(_unit)) {
                continue;
            }
            // Planetside (not on a ship) AND on this world.
            if (_unit.ship_location != -1) {
                continue;
            }
            if (_unit.location_string != _star_name) {
                continue;
            }
            if (!_unit.controllable()) {
                continue;
            }
            var _uid_key = string(_unit.last_ship.uid);
            if ((_unit.last_ship.uid == "") || !variable_struct_exists(_uid_to_id, _uid_key)) {
                _stranded++; // origin ship gone or not here
                continue;
            }
            var _ship = _uid_to_id[$ _uid_key];
            _unit.get_unit_size();
            // Capacity check: the ship must have room for this unit.
            if ((obj_ini.ship_carrying[_ship] + _unit.size) > obj_ini.ship_capacity[_ship]) {
                _stranded++; // ship full
                continue;
            }
            _unit.load_marine(_ship, _star);
            _recalled++;
        }
    }
    return { recalled: _recalled, stranded: _stranded };
}
