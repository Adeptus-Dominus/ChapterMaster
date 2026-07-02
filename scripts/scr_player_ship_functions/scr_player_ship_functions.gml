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
        var _new_fleet = instance_create(_star.x, _star.y, obj_p_fleet);
        _new_fleet.owner = eFACTION.PLAYER;
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
        _lost_ship_fleet = instance_create(-500, -500, obj_p_fleet);
        _lost_ship_fleet.owner = eFACTION.PLAYER;
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
        "Gladius"
    ];
    var _capitals = [
        "Gloriana",
        "Battle Barge",
        "Capital"
    ];
    var _frigates = [
        "Strike Cruiser",
        "Frigate"
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
