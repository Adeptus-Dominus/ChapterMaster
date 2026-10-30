/// @desc Returns the nth power of two in 1-indexed sequence 1, 2, 4, 8, ... Equal to 2^(_index - 1).
/// @param {Real} _index
/// @returns {Real} Returns 0 for _index <= 0. Inverse is bit_length for exact powers of two.
function nth_power_of_two(_index) {
    _index = floor(_index);
    if (_index <= 0) {
        return 0;
    }
    var _result = 1;
    for (var i = 1; i < _index; i++) {
        _result *= 2;
    }
    return _result;
}

/// @desc Returns the number of bits needed to represent a non-negative integer. Inverse of nth_power_of_two for exact powers of two; floors non-powers.
/// @param {Real} _value
/// @returns {Real} Returns 0 for _value <= 0
function bit_length(_value) {
    _value = floor(_value);
    if (_value <= 0) {
        return 0;
    }
    var _bits = 0;
    while (_value > 0) {
        _value = floor(_value / 2);
        _bits++;
    }
    return _bits;
}

function fleet_power_value(_fleet) {
    if (_fleet == noone || !instance_exists(_fleet)) {
        return 0;
    }

    return _fleet.capital_number * 16 + _fleet.frigate_number * 8 + _fleet.escort_number * 4;
}


function new_ork_fleet(xx, yy) {
    fleet = create_enemy_fleet(xx, yy, eFACTION.ORK);
    fleet.sprite_index = spr_fleet_ork;
    fleet.image_index = 1;
    return fleet;
}

/// @self Asset.GMObject.obj_star
function ork_fleet_cap_reached() {
    var _bonus = 4;
    var _ork_stars = 0;
    with (obj_star) {
        if (owner == eFACTION.ORK) {
            _ork_stars++;
        }
    }

    var _ork_fleets = 0;
    with (obj_en_fleet) {
        if (owner == eFACTION.ORK) {
            _ork_fleets++;
            if (_ork_fleets >= _ork_stars + _bonus) {
                return true;
            }
        }
    }

    return _ork_fleets >= _ork_stars + _bonus;
}

/// @self Asset.GMObject.obj_star
function orks_end_turn_growth() {
    for (var i = 1; i <= planets; i++) {
        var _pdata = get_planet_data(i);
        if (!p_orks[i]) {
            var _strongholds = _pdata.get_features(eP_FEATURES.ORKSTRONGHOLD);
            for (var s = 0; s < array_length(_strongholds); s++) {
                var _hold = _strongholds[s];
                _hold.tier -= 0.01;
                if (_hold.tier <= 0) {
                    _pdata.delete_feature(eP_FEATURES.ORKSTRONGHOLD);
                }
            }
        }
        _pdata.ork_planet_turn();
    }
}

function ork_fleet_move() {
    var hides = choose(1, 2, 3);

    repeat (hides) {
        instance_deactivate_object(instance_nearest(x, y, obj_star));
    }

    with (obj_star) {
        if (is_dead_star() || owner == eFACTION.ORK || scr_orbiting_fleet(eFACTION.ORK) != noone) {
            instance_deactivate_object(id);
        }
    }
    var nex = instance_nearest(x, y, obj_star);
    action_x = nex.x;
    action_y = nex.y;
    action = "";
    set_fleet_movement();

    instance_activate_object(obj_star);
    exit;
}

/// @self Asset.GMObject.obj_star
function ork_fleet_arrive_target() {
    instance_activate_object(obj_en_fleet);
    var _ork_fleet = scr_orbiting_fleet(eFACTION.ORK);
    if (_ork_fleet == noone) {
        return;
    }

    var _imperial_ship = scr_orbiting_fleet([eFACTION.IMPERIUM, eFACTION.MECHANICUS]);
    if (_imperial_ship == noone && planets > 0 && !has_orbiting_player_fleet()) {
        var ork_attack_planet = 0;
        var _planets = shuffled_planet_array();
        for (var i = 0; i < array_length(_planets); i++) {
            var _planet = _planets[i];
            if ((ork_attack_planet == 0) && (p_tyranids[_planet] > 0)) {
                ork_attack_planet = _planet;
                break;
            }
        }
        if (ork_attack_planet > 0) {
            p_tyranids[ork_attack_planet] -= floor(_ork_fleet.capital_number + (_ork_fleet.frigate_number / 2));

            var _pdata = get_planet_data(ork_attack_planet);

            //generate refugee ships to spread tyranids
            if (p_tyranids[ork_attack_planet] <= 0) {
                if (planet_feature_bool(p_feature[ork_attack_planet], eP_FEATURES.GENE_STEALER_CULT)) {
                    _pdata.delete_feature(eP_FEATURES.GENE_STEALER_CULT);
                    adjust_influence(eFACTION.TYRANIDS, -25, ork_attack_planet, id);
                    var nearest_imperial = nearest_star_with_ownership(x, y, eFACTION.IMPERIUM, id);
                    if (nearest_imperial != noone) {
                        var targ_planet = scr_get_planet_with_owner(nearest_imperial, eFACTION.IMPERIUM);
                        if (targ_planet == -1) {
                            targ_planet = irandom_range(1, nearest_imperial.planets);
                        }
                        _pdata.send_colony_ship(nearest_imperial, targ_planet, "refugee");
                    }
                }
            }
        }

        var _allow_landing = !is_dead_star();
        var _alert_triggered = false;
        if (_allow_landing) {
            for (var i = 0; i < planets; i++) {
                var _planet = _planets[i];
                if ((p_guardsmen[_planet] + p_pdf[_planet] + p_player[_planet] + p_traitors[_planet] + p_tau[_planet] > 0) || ((p_owner[_planet] != eFACTION.ORK) && (p_orks[_planet] <= 0))) {
                    if ((p_type[_planet] != "Dead") && (p_orks[_planet] < 6) && (i <= planets)) {
                        var _dest_men = nth_power_of_two(p_orks[_planet]);
                        var _fleet_men = fleet_power_value(_ork_fleet);
                        var _capacity = max(0, nth_power_of_two(6) - _dest_men);
                        var _landed_men = min(_fleet_men, _capacity);
                        var _remaining_men = _fleet_men - _landed_men;
        
                        if (_remaining_men > 0 && _remaining_men < 4) {
                            _landed_men += _remaining_men;
                            _remaining_men = 0;
                        }

                        if (_landed_men > 0) {
                            get_planet_data(_planet).edit_forces(eFACTION.ORK, min(6, bit_length(_dest_men + _landed_men)));
                        }

                        if (fleet_has_cargo("ork_warboss", _ork_fleet)) {
                            array_push(p_feature[_planet], _ork_fleet.cargo_data.ork_warboss);
                            get_planet_data(_planet).edit_forces(eFACTION.ORK, 6);
                            struct_remove(_ork_fleet.cargo_data, "ork_warboss");
                        }

                        if (_remaining_men <= 0 && !fleet_has_cargo("ork_warboss", _ork_fleet)) {
                            with (_ork_fleet) {
                                instance_destroy();
                            }
                        } else {
                            _ork_fleet.capital_number = floor(_remaining_men / 16);
                            _remaining_men -= _ork_fleet.capital_number * 16;
                            _ork_fleet.frigate_number = floor(_remaining_men / 8);
                            _remaining_men -= _ork_fleet.frigate_number * 8;
                            _ork_fleet.escort_number = floor(_remaining_men / 4);
                            with (_ork_fleet) {
                                image_index = max(round(standard_fleet_strength_calc()), 1);
                            }
                        }
                        _alert_triggered = true;
                        break;
                    }
                }
            }
        }

        if (_alert_triggered) {
            if (!instance_exists(_ork_fleet)) {
                scr_alert("green", "owner", $"Ork ships have crashed across the {name} system.", x, y);
            } else {
                scr_alert("green", "owner", $"Ork ships Spill their ravenouss hordes accross {name} system and the green skin captains turn their guns towards the surface.", x, y);
            }
        } else {
            var new_wagh_star = distance_removed_star(x, y, choose(2, 3, 4, 5));
            if (instance_exists(new_wagh_star)) {
                with (_ork_fleet) {
                    action_x = new_wagh_star.x;
                    action_y = new_wagh_star.y;
                    action = "";
                    set_fleet_movement();
                }
            }
        }
    } // End _allow_landingng portion of code
}

//TOSO provide logic for fleets to attack each other
function merge_ork_fleets() {
    var _stars_with_ork_fleets = stars_with_faction_fleets(eFACTION.ORK);

    var _star_names = struct_get_names(_stars_with_ork_fleets);
    for (var i = 0; i < array_length(_star_names); i++) {
        var _fleets = _stars_with_ork_fleets[$ _star_names[i]];
        if (array_length(_fleets) <= 1) {
            continue;
        }
        var _base_fleet = _fleets[0];
        for (var f = 1; f < array_length(_fleets); f++) {
            merge_fleets(_base_fleet, _fleets[f]);
        }
    }
}

function init_ork_waagh(override = false) {
    var waaagh = irandom(300);
    var waaagh_1 = irandom(3);
    var _ork_stars = scr_get_stars(false, [eFACTION.ORK]);
    var _ork_stars_count = array_length(_ork_stars);

    if ((_ork_stars_count > 45) && (waaagh_1 == 3 || override) && obj_controller.known[eFACTION.ORK] == 0) {
        scr_popup("WAAAAGH!", "The greenskins have gone unchallenged for far too long. A towering Warboss has rallied the ork hordes and halted their infighting. Now unified, the greenskins pose a dire threat to the entire sector!", "waaagh", "");
        scr_event_log("red", "Ork WAAAAGH! begins");
        obj_controller.known[eFACTION.ORK] = 0.5;
    } else if ((_ork_stars_count > 0 && _ork_stars_count <= 5) && (waaagh_1 == 3 || override) && obj_controller.known[eFACTION.ORK] == 0) {
        scr_popup("WAAAAGH!", "The orks are nearly defeated, but in a final desperate push, a new Warboss has mustered a fresh WAAAGH! and begun reclaiming their lost worlds.", "waaagh", "");
        scr_event_log("red", "Ork WAAAAGH! begins.");
        obj_controller.known[eFACTION.ORK] = 0.5;
    } else if ((_ork_stars_count >= 5 && _ork_stars_count <= 45) && (waaagh == 33 || override) && obj_controller.known[eFACTION.ORK] == 0) {
        scr_popup("WAAAAGH!", "The greenskins have swelled in activity, their numbers increasing seemingly without relent.  A massive Warboss has risen to take control, leading most of the sector's Orks on a massive WAAAGH!", "waaagh", "");
        scr_event_log("red", "Ork WAAAAGH! begins.");
        obj_controller.known[eFACTION.ORK] = 0.5;
    } else {
        //if no waaagh is triggered
        return;
    }

    var ork_waagh_activity = [];
    var _any_ork_star = [];
    for (var p = 0; p < array_length(_ork_stars); p++) {
        with (_ork_stars[p]) {
            var _rand_planet = irandom_range(1, planets);
            for (var i = 1; i <= planets; i++) {
                ork_ship_production(i);
                if (i == _rand_planet) {
                    if ((p_owner[i] == eFACTION.ORK) && (p_pdf[i] == 0) && (p_guardsmen[i] == 0) && (p_orks[i] >= 2)) {
                        array_push(ork_waagh_activity, [id, _rand_planet]);
                    }
                }
                if (p_orks[i] > 0) {
                    array_push(_any_ork_star, [id, i]);
                }
            }
        }
    }

    var _waaagh_star = [];
    var _waaagh_star_found = false;
    if (array_length(ork_waagh_activity)) {
        _waaagh_star = array_random_element(ork_waagh_activity);
        _waaagh_star_found = true;
    } else if (array_length(_any_ork_star) > 0) {
        _waaagh_star = array_random_element(_any_ork_star);
        _waaagh_star_found = true;
    }

    var _pdata = undefined;
    if (_waaagh_star_found) {
        _pdata = _waaagh_star[0].get_planet_data(_waaagh_star[1]);
        var _boss = _pdata.add_feature(eP_FEATURES.ORKWARBOSS);

        with (obj_controller) {
            if (faction_defeated[7] == 1) {
                faction_leader[eFACTION.ORK] = _boss.name;
                faction_title[7] = "Warboss";
                faction_status[eFACTION.ORK] = "War";
                scr_audience(eFACTION.ORK, "new_warboss", -40, "War", 0, 2);
            }
        }

        if (override) {
            _boss.player_hidden = false;
            scr_event_log("red", $"boss on {_pdata.name()}", _pdata.system.name);
        }

        if (_pdata.planet_forces[eFACTION.ORK] < 4) {
            _pdata.add_forces(eFACTION.ORK, 2);
        }

        scr_popup("WAAAAGH!", "My lord, our Auspex scans indicate that the Ork Warboss is currently within the " + string(_pdata.system.name) + " system.We must strike swiftly before he relocates. ", "waaagh", "");
        scr_event_log("red", $"boss on {_pdata.name()}", _pdata.system.name);
    } else {
        out_of_system_warboss(true);
    }
}

function out_of_system_warboss(overide = false) {
    with (obj_controller) {
        // More Testing
        if (faction_defeated[7] == 1 || known[eFACTION.ORK] == 0 || overide) {
            known[eFACTION.ORK] = 0;
            var _warboss = new NewPlanetFeature(eP_FEATURES.ORKWARBOSS);
            if (faction_defeated[7] == 1) {
                faction_defeated[7] = -1;
                faction_leader[eFACTION.ORK] = _warboss.name;
                faction_title[7] = "Warboss";
                faction_status[eFACTION.ORK] = "War";
                scr_audience(eFACTION.ORK, "new_warboss", -40, "War", 0, 2);
            } else {
                known[eFACTION.ORK] = 0.5;
            }

            var gold = faction_gender[7];
            if (gold == 0) {
                gold = 1;
            }
            var gnew = 0;
            repeat (20) {
                if (gnew == 0 || gnew == gold) {
                    gnew = choose(1, 2, 3, 4);
                }
            }
            faction_gender[7] = gnew;
            starf = 0;

            var x3 = 0;
            var y3 = 0;

            var side = choose("left", "right", "up", "down");
            if (side == "left") {
                y3 = floor(random_range(0, room_height)) + 1;
            }
            if (side == "right") {
                y3 = floor(random_range(0, room_height)) + 1;
                x3 = room_width;
            }
            if (side == "up") {
                x3 = floor(random_range(0, room_width)) + 1;
            }
            if (side == "down") {
                x3 = floor(random_range(0, room_width)) + 1;
                y3 = room_height;
            }

            //lots of this can be wrapped into a single with
            with (obj_star) {
                if (owner == eFACTION.ELDAR) {
                    instance_deactivate_object(id);
                    continue;
                }
                if (is_dead_star() || planets == 0) {
                    instance_deactivate_object(id);
                    continue;
                }
            }

            for (var fnum = 1; fnum <= 8; fnum++) {
                var x4 = 0;
                var y4 = 0;
                var dire = 0;
                if (fnum == 1) {
                    dire = point_direction(x4, y4, room_width / 2, room_height / 2);
                    x4 = x3 + lengthdir_x(60, dire);
                    y4 = y3 + lengthdir_y(60, dire);
                }
                if (fnum > 1) {
                    dire = point_direction(x4, y4, room_width / 2, room_height / 2);
                    x4 = x3 + choose(round(random_range(30, 50)), round(random_range(-30, -50)));
                    y4 = y3 + choose(round(random_range(30, 50)), round(random_range(-30, -50)));
                }

                var _nfleet = new_ork_fleet(x4, y4);
                var tplan = instance_nearest(_nfleet.x, _nfleet.y, obj_star);
                _nfleet.action_x = tplan.x;
                _nfleet.action_y = tplan.y;
                if (fnum == 1) {
                    starf = tplan;
                    _nfleet.cargo_data.ork_warboss = _warboss;
                }
                with (_nfleet) {
                    frigate_number = 10;
                    capital_number = 4;
                    set_fleet_movement();
                }
                instance_deactivate_object(tplan);
            }

            instance_activate_object(obj_star);
            instance_activate_object(obj_en_fleet);

            var _ork_leader = obj_controller.faction_leader[eFACTION.ORK];
            var tix = $"Warboss {_ork_leader} leads a WAAAGH! into Sector {obj_ini.sector_name}.";
            scr_alert("red", "lol", string(tix), starf.x, starf.y);
            scr_event_log("red", tix);
            scr_popup("WAAAAGH!", $"A WAAAGH! led by the Warboss {_ork_leader} has arrived in {obj_ini.sector_name}.  With him is a massive Ork fleet.  Numbering in the dozens of battleships, they carry with them countless greenskins.  The forefront of the WAAAGH! is destined for the {starf.name} system.", "waaagh", "");
        }
    }
}
