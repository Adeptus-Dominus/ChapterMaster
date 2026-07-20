/// @self Asset.GMObject.obj_en_fleet
function navy_orbiting_planet_end_turn_action() {
    end_sequence_finished = false;

    var _war_with_player = obj_controller.faction_status[eFACTION.IMPERIUM] == "War";
    if (trade_goods != "player_hold") {
        if (trade_goods == "") {
            ///basicically if there is a player fleet enroute for this star and the player is at war with the navy it will trigger
            ///meaning the navy fleet is going to sit and wait fot the player to arrive
            if (orbiting.present_fleet[20] > 0) {
                end_sequence_finished = true;
            }
        }

        // Check if the ground battle is victorious or not
        if (!end_sequence_finished && _war_with_player && trade_goods == "invading_player" && guardsmen_unloaded == 1) {
            navy_finish_destroying_player_world();
        }

        // Invade the player homeworld as needed
        if (!end_sequence_finished) {
            navy_attack_player_world();
        }
        // Bombard the shit out of the player homeworld
        if (!end_sequence_finished && _war_with_player && trade_goods == "" && !guardsmen_unloaded) {
            navy_bombard_player_world();
        }

        //hunt the player like the dog they are
        if (!end_sequence_finished && _war_with_player && action == "" && trade_goods == "" && guardsmen_unloaded == 0) {
            navy_hunt_player_assets();
        }

        if (trade_goods == "building_ships") {
            var _forge = scr_get_planet_with_type(orbiting, "Forge");
            if (_forge == -1 || orbiting.p_owner[_forge] != eFACTION.MECHANICUS) {
                trade_goods = "";
            } else {
                end_sequence_finished = true;
            }
        }
        //Eldar shit I think? Doesn't check for eldar ships
        new_navy_ships_forge();

        //OK this calculates how many imperial guard the ships have and can have at a max
        guardsmen_ratio = fleet_remaining_guard_ratio();

        if (action == "" && guardsmen_unloaded) {
            // Move from one planet to another
            scr_navy_has_unloaded_guardsmen_turn_end();
        }

        if (navy_strength_calc() <= 14 && !guardsmen_unloaded) {
            dock_navy_at_forge();

            send_navy_to_forge();
        } else if (trade_goods == "" && action == "") {
            // Bombard the shit out of things when able
            imperial_navy_bombard();
        }

        // If the guardsmen all die then move on and find recruit world this should really be handled by guardsmen_ratio but will monitor for now
        check_navy_guard_still_live();

        // Go to recruiting grounds
        if ((guardsmen_unloaded == 0 && guardsmen_ratio < 0.5 && (trade_goods != "goto_forge") && trade_goods != "building_ships") || trade_goods == "recr") {
            // determine what sort of planet is needed
            scr_navy_find_recruit_world();
        }
        // Get recruits
        if (!end_sequence_finished && action == "" && (trade_goods == "goto_recruiting" || trade_goods == "recruiting")) {
            scr_navy_recruit_new_guard();
        }

        if (trade_goods == "recruited") {
            trade_goods = "";
        }

        if (!end_sequence_finished) {
            scr_navy_planet_action();
        }
        /* */
    }
}

/// @self Asset.GMObject.obj_en_fleet
function check_navy_guard_still_live() {
    if (guardsmen_unloaded) {
        var guardsmen_dead = true;
        for (var o = 1; o <= orbiting.planets; o++) {
            if (orbiting.p_guardsmen[o] > 0) {
                guardsmen_dead = false;
                break;
            }
        }
        if (guardsmen_dead) {
            guardsmen_unloaded = 0;
            guardsmen_ratio = 0;
            trade_goods = "";
        }
    }
}

function build_new_navy_fleet(construction_forge) {
    /// @type {Asset.GMObject.obj_en_fleet}
    var new_navy_fleet = create_enemy_fleet(construction_forge.x, construction_forge.y, eFACTION.IMPERIUM);

    with (new_navy_fleet) {
        capital_number = 0;
        frigate_number = 0;
        escort_number = 1;
        home_x = x;
        home_y = y;
        warp_able = true;
        navy = 1;

        var total_ships = 0;
        total_ships += capital_number - 1;
        total_ships += round((frigate_number / 2));
        total_ships += round((escort_number / 4));
        if (total_ships <= 1 && capital_number + frigate_number + escort_number > 0) {
            total_ships = 1;
        }
        choose_fleet_sprite_image();
        image_index = total_ships;
        image_speed = 0;

        trade_goods = "building_ships";
    }
}

/// @self Asset.GMObject.obj_en_fleet
function new_navy_ships_forge() {
    if (trade_goods == "building_ships") {
        var onceh = 0;
        var advance = false;

        for (var p = 1; p <= orbiting.planets; p++) {
            if (orbiting.p_type[p] == "Forge") {
                //if no non-imperium,player, or eldar aligned fleets or ground forces, continue
                if (orbiting.p_orks[p] + orbiting.p_chaos[p] + orbiting.p_tyranids[p] + orbiting.p_necrons[p] + orbiting.p_tau[p] + orbiting.p_traitors[p] == 0) {
                    if (orbiting.present_fleet[7] + orbiting.present_fleet[8] + orbiting.present_fleet[9] + orbiting.present_fleet[10] + orbiting.present_fleet[13] == 0) {
                        advance = 1;
                    }
                }
            }
        }

        if (!advance) {
            exit;
        }

        //TODO here we can make fleet be restored more quickly by better forge worlds
        if (escort_number < 12) {
            escort_number += 1;
        } else if (frigate_number < 5) {
            frigate_number += 0.25;
            onceh = 1;
            if (frigate_number > 4.99) {
                frigate_number = 5;
            }
        } else if (capital_number < 1) {
            capital_number += 0.0834;
            if (capital_number > 1) {
                capital_number = 1;
            }
        }
        if (onceh == 1) {
            var ii = 0;
            ii += capital_number;
            ii += round((frigate_number / 2));
            ii += round((escort_number / 4));

            image_index = ii <= 1 ? 1 : ii;
        }

        if (capital_number >= 1 && frigate_number >= 5 && escort_number >= 12) {
            var i = -1;
            repeat (capital_number) {
                i += 1;
                capital_max_imp[i] = (((floor(random(15)) + 1) * 1000000) + 15000000) * 2;
            }
            i = -1;
            repeat (frigate_number) {
                i += 1;
                frigate_max_imp[i] = (500000 + (floor(random(50)) + 1) * 10000) * 2;
            }
            trade_goods = "";
        }

        end_sequence_finished = true;
    }
}

//TODO further breakup into a nvay fleet functions script
/// @self Asset.GMObject.obj_en_fleet
function navy_strength_calc() {
    return (capital_number * 8) + (frigate_number * 2) + escort_number;
}

/// @self Asset.GMObject.obj_en_fleet
function dock_navy_at_forge() {
    // Got to forge world
    if (action == "" && trade_goods == "goto_forge" && scr_star_has_planet_with_type(orbiting, "Forge")) {
        trade_goods = "building_ships";
    }
}

/// @self Asset.GMObject.obj_en_fleet
function send_navy_to_forge() {
    // Quene a visit to a forge world
    if (action == "" && trade_goods == "") {
        var forge_list = [];
        with (obj_star) {
            var cont = 0;
            for (var p = 1; p < planets; p++) {
                if (p_type[p] == "Forge") {
                    if (p_orks[p] + p_chaos[p] + p_tyranids[p] + p_necrons[p] + p_tau[p] + p_traitors[p] == 0) {
                        if (present_fleet[7] + present_fleet[8] + present_fleet[9] + present_fleet[10] + present_fleet[13] == 0) {
                            cont = 1;
                        }
                    }
                }
            }
            if (cont) {
                array_push(forge_list, id);
            }
        }
        if (array_length(forge_list)) {
            var go_there = nearest_from_array(x, y, forge_list);
            var target_forge = forge_list[go_there];
            action_x = target_forge.x;
            action_y = target_forge.y;
            set_fleet_movement();
        } else {
            scr_alert("Yellow", "Sector Info", "The sector has no active Forge Worlds as a result The imperial navy are unable to effectivly recover from Combat losses");
        }
    }
}

/// @self Asset.GMObject.obj_en_fleet
function imperial_navy_bombard() {
    if (turns_static < 12) {
        exit;
    }
    var _fleets = get_orbiting_fleets([6, 7, 8, 9, 10, 11, 12, 13], orbiting);
    if (array_length(_fleets)) {
        exit;
    }

    if (orbiting.present_fleet[1] > 0 && obj_controller.faction_status[eFACTION.IMPERIUM] == "War") {
        exit;
    }

    var _bombard = 0;
    for (var p = 0; p <= orbiting.planets; p++) {
        if (orbiting.p_type[p] != "Daemon") {
            if (orbiting.p_population[p] == 0 && orbiting.p_tyranids[p] > 0) {
                _bombard = p;
            } else if (orbiting.p_population[p] == 0 && orbiting.p_orks[p] > 0 && orbiting.p_owner[p] == eFACTION.ORK) {
                _bombard = p;
            } else if (orbiting.p_owner[p] == eFACTION.TAU && orbiting.p_tau[p] + orbiting.p_pdf[p] > 0) {
                _bombard = p;
            } else if (orbiting.p_owner[p] == eFACTION.CHAOS && (orbiting.p_chaos[p] + orbiting.p_traitors[p] + orbiting.p_pdf[p] > 0 || orbiting.p_heresy[p] >= 50)) {
                _bombard = p;
            } else {
                var _cults = return_planet_features(orbiting.p_feature[p], eP_FEATURES.GENE_STEALER_CULT);
                if (array_length(_cults)) {
                    if (!_cults[0].hiding) {
                        _bombard = p;
                    }
                }
            }
        }
    }

    if (_bombard > 0) {
        if (guardsmen_unloaded) {
            navy_load_guardsmen();
        }
        var _p_data = orbiting.get_planet_data(_bombard);
        scare = (capital_number * 3) + frigate_number;
        _p_data.suffer_navy_bombard(scare);
        end_sequence_finished = true;
    } else {}
}

/// @self Asset.GMObject.obj_en_fleet
function navy_hunt_player_assets() {
    var hold = false;

    var player_owns_planet = scr_get_planet_with_owner(orbiting, eFACTION.PLAYER);
    hold = player_owns_planet || (orbiting.present_fleet[eFACTION.PLAYER] > 0);

    if (hold) {
        // Chase player fleets
        var chase_fleet = get_nearest_player_fleet(x, y, false, true);
        if (chase_fleet != noone) {
            var thatp, my_dis;
            etah = chase_fleet.action_eta;

            var intercept = fleet_intercept_time_calculate(chase_fleet);
            if (intercept) {
                if (intercept <= etah) {
                    target = chase_fleet.id;
                    chase_fleet_target_set(target);
                    trade_goods = "player_hold";
                    exit;
                }
            }
            with (obj_temp8) {
                instance_destroy();
            }
        }
        // End chase

        // Go after home planet or fleet?

        if (trade_goods == "" && action == "") {
            var homeworld_distance, homeworld_nearby, fleet_nearby, fleet_distance, planet_nearby;
            homeworld_distance = 9999;
            fleet_distance = 9999;
            fleet_nearby = 0;
            homeworld_nearby = 0;
            planet_nearby = 0;

            with (obj_p_fleet) {
                if (action == "") {
                    instance_create(x, y, obj_temp7);
                }
            }
            with (obj_star) {
                if (array_contains(p_owner, eFACTION.PLAYER)) {
                    instance_create(x, y, obj_temp8);
                }
            }

            if (instance_exists(obj_temp7)) {
                fleet_nearby = instance_nearest(x, y, obj_temp7);
                fleet_distance = point_distance(x, y, fleet_nearby.x, fleet_nearby.y);
            }
            if (instance_exists(obj_temp8)) {
                homeworld_nearby = instance_nearest(x, y, obj_temp8);
                homeworld_distance = point_distance(x, y, homeworld_nearby.x, homeworld_nearby.y) - 30;
            }

            if (homeworld_distance < fleet_distance && homeworld_distance < 5000 && homeworld_distance > 40) {
                // Go towards planet
                action_x = homeworld_nearby.x;
                action_y = homeworld_nearby.y;
                with (obj_temp7) {
                    instance_destroy();
                }
                with (obj_temp8) {
                    instance_destroy();
                }
                exit;
            }

            if (fleet_distance < homeworld_distance && fleet_distance < 7000 && fleet_distance > 40 && instance_exists(obj_temp7)) {
                // Go towards that fleet
                planet_nearby = instance_nearest(fleet_nearby.x, fleet_nearby.y, obj_star);

                if (instance_exists(planet_nearby)) {
                    if (fleet_distance <= 500 && planet_nearby != orbiting) {
                        // Case 1; really close, wait for them to make the move
                        with (obj_temp7) {
                            instance_destroy();
                        }
                        with (obj_temp8) {
                            instance_destroy();
                        }
                        exit;
                    }
                    if (fleet_distance > 500) {
                        // Case 2; kind of far away, move closer
                        var diss = fleet_distance / 2;
                        var goto = 0;
                        var dirr = point_direction(x, y, fleet_nearby.x, fleet_nearby.y);

                        with (orbiting) {
                            y -= 20000;
                        }
                        goto = instance_nearest(x + lengthdir_x(diss, dirr), y + lengthdir_y(diss, dirr), obj_star);
                        with (orbiting) {
                            y += 20000;
                        }
                        if (goto.present_fleet[eFACTION.PLAYER] == 0) {
                            action_x = goto.x;
                            action_y = goto.y;
                            set_fleet_movement();
                        }

                        with (obj_temp7) {
                            instance_destroy();
                        }
                        with (obj_temp8) {
                            instance_destroy();
                        }
                        exit;
                    }
                }
            }
        }

        with (obj_temp7) {
            instance_destroy();
        }
        with (obj_temp8) {
            instance_destroy();
        }
    }
}

/// @self Asset.GMObject.obj_en_fleet
function navy_finish_destroying_player_world() {
    //slightly more verbose than the last way, but reduces reliance on fixed array sizes
    var tar = array_reduce(
        orbiting.p_guardsmen,
        function(prev, _curr, idx) {
            return _curr > 0 ? idx : prev;
        },
        0
    );

    if (tar == 0) {
        // Guard all dead
        trade_goods = "recr";
        action = "";
    } else {
        //this was always a dead path previously since tar could never be bigger than i, now it will
        var _targ = orbiting.get_planet_data(tar);
        if (orbiting.p_owner[tar] == eFACTION.PLAYER && orbiting.p_player[tar] == 0 && planet_feature_bool(orbiting.p_feature[tar], eP_FEATURES.MONASTERY) == 0) {
            _targ.return_to_first_owner();
            _targ.add_disposition(-50);
            trade_goods = "";
            action = "";
        }
    }
}

/// @self Asset.GMObject.obj_en_fleet
function navy_attack_player_world() {
    if (obj_controller.faction_status[eFACTION.IMPERIUM] == "War" && trade_goods == "invade_player" && guardsmen_unloaded == 0) {
        if (instance_exists(orbiting)) {
            var tar = 0;
            for (var i = 1; i <= orbiting.planets; i++) {
                if ((orbiting.p_owner[i] == eFACTION.PLAYER) && (planet_feature_bool(orbiting.p_feature[i], eP_FEATURES.MONASTERY) == 0) && (orbiting.p_guardsmen[i] == 0)) {
                    tar = i;
                }
            }
            if (tar) {
                guardsmen_unloaded = 1;
                for (var i = 1; i <= 20; i++) {
                    if (capital_imp[i] > 0) {
                        orbiting.p_guardsmen[tar] += capital_imp[i];
                        capital_imp[i] = 0;
                    }
                }
                for (var i = 1; i <= 30; i++) {
                    if (frigate_imp[i] > 0) {
                        orbiting.p_guardsmen[tar] += frigate_imp[i];
                        frigate_imp[i] = 0;
                    }
                }
                for (var i = 1; i <= 30; i++) {
                    if (escort_imp[i] > 0) {
                        orbiting.p_guardsmen[tar] += escort_imp[i];
                        escort_imp[i] = 0;
                    }
                }
                trade_goods = "invading_player";
                exit;
            }
        }
    }
}

/// @self Asset.GMObject.obj_en_fleet
function navy_bombard_player_world() {
    var bombard = false;
    if (instance_exists(orbiting)) {
        if (orbiting.object_index == obj_star) {
            bombard = true;
        }
    }
    if (bombard) {
        var orbiting_guardsmen = array_sum(orbiting.p_guardsmen);
        var player_forces = array_sum(orbiting.p_player);

        if (orbiting_guardsmen == 0 || player_forces > 0) {
            //cleaned this up so it is easier to read, even though it reads more verbosely
            var hostile_fleet_count = 0;
            with (orbiting) {
                hostile_fleet_count += present_fleet[eFACTION.PLAYER] + present_fleet[eFACTION.ELDAR] + present_fleet[eFACTION.ORK] + present_fleet[eFACTION.TAU] + present_fleet[eFACTION.TYRANIDS] + present_fleet[eFACTION.CHAOS] + present_fleet[eFACTION.NECRONS];
            }
            if (hostile_fleet_count == 0) {
                var deaths = 0, hurss = 0, onceh = 0, wob = 0, kill = 0;

                for (var o = 1; o <= orbiting.planets; o++) {
                    if (orbiting.p_owner[o] == eFACTION.PLAYER) {
                        if ((orbiting.p_population[o] + orbiting.p_pdf[o] > 0) || (orbiting.p_player[o] > 0)) {
                            bombard = o;
                            break;
                        }
                    }
                }

                if (bombard) {
                    var _orbiting_data = orbiting.get_planet_data(bombard);
                    scare = (capital_number * 3) + frigate_number;

                    if (scare > 2) {
                        scare = 2;
                    }
                    if (scare < 1) {
                        scare = 0;
                    }
                    //onceh=2;

                    if (orbiting.p_large[bombard]) {
                        kill = scare * 0.15; // Population if large
                    } else {
                        kill = scare * 15000000; // pop if small
                    }

                    var bombard_name = _orbiting_data.name();
                    var bombard_report_string = $"Imperial Battlefleet bombards {bombard_name}.";
                    var PDF_loses = min(orbiting.p_pdf[bombard], (scare * 15000000) / 2);

                    var civil_loss_mod = orbiting.p_large[bombard] ? scare * 0.15 : scare * 15000000;

                    var civilian_losses = min(orbiting.p_population[bombard], civil_loss_mod);

                    if (civilian_losses > 0 && orbiting.p_large[bombard] == 0) {
                        bombard_report_string += $" {civilian_losses} civilian casualties";
                    }
                    if (civilian_losses > 0 && orbiting.p_large[bombard] == 1) {
                        if (civilian_losses >= 1) {
                            bombard_report_string += $" {civilian_losses} billion civilian casualties";
                        }
                        if (civilian_losses < 1) {
                            bombard_report_string += $"  {floor(civilian_losses * 1000)} million civilian casualties";
                        }
                    }
                    if (PDF_loses > 0) {
                        bombard_report_string += $" and {scr_display_number(PDF_loses)} PDF lost.";
                    }
                    if (PDF_loses <= 0 && civilian_losses > 0) {
                        bombard_report_string += ".";
                    }
                    if (civilian_losses == 0 && PDF_loses > 0) {
                        bombard_report_string += $" {PDF_loses}  PDF lost.";
                    }

                    if (bombard_report_string != "") {
                        scr_alert("red", "owner", bombard_report_string, orbiting.x, orbiting.y);
                        scr_event_log("red", bombard_report_string, orbiting.name);
                        bombard_report_string = string_replace(bombard_report_string, ",.", ",");
                    }

                    orbiting.p_pdf[bombard] -= (scare * 15000000) / 2;
                    if (orbiting.p_pdf[bombard] < 0) {
                        orbiting.p_pdf[bombard] = 0;
                    }

                    orbiting.p_population[bombard] -= kill;
                    if (orbiting.p_population[bombard] < 0) {
                        orbiting.p_population[bombard] = 0;
                    }
                    if (orbiting.p_pdf[bombard] < 0) {
                        orbiting.p_pdf[bombard] = 0;
                    }

                    if (orbiting.p_population[bombard] + orbiting.p_pdf[bombard] <= 0 && orbiting.p_owner[bombard] == eFACTION.PLAYER) {
                        if (planet_feature_bool(orbiting.p_feature[bombard], eP_FEATURES.MONASTERY) == 0) {
                            _orbiting_data.return_to_first_owner();
                            _orbiting_data.add_disposition(-50);
                        } else {
                            trade_goods = "invade_player";
                        }
                    }
                    exit;
                }
            }
        }
    }
}

/// @self Asset.GMObject.obj_en_fleet
function fleet_max_guard() {
    var _maxi = 0;

    _maxi = array_sum(capital_max_imp, _maxi, 0, capital_number - 1);
    _maxi = array_sum(frigate_max_imp, _maxi, 0, frigate_number - 1);
    _maxi = array_sum(escort_max_imp, _maxi, 0, escort_number - 1);
    return _maxi;
}

/// @self Asset.GMObject.obj_en_fleet
function fleet_guard_current() {
    var _maxi = 0;
    _maxi = array_sum(capital_imp, _maxi, 0, capital_number - 1);
    _maxi = array_sum(frigate_imp, _maxi, 0, frigate_number - 1);
    _maxi = array_sum(escort_imp, _maxi, 0, escort_number - 1);
    return _maxi;
}

/// @self Asset.GMObject.obj_en_fleet
function fleet_remaining_guard_ratio() {
    var _curr = fleet_guard_current();
    var _maxi = fleet_max_guard();
    guardsmen_ratio = 0;
    if (guardsmen_unloaded) {
        if (instance_exists(orbiting)) {
            _curr = array_sum(orbiting.p_guardsmen);
        }

        guardsmen_ratio = _curr / _maxi;
        if (_curr <= 0) {
            guardsmen_unloaded = false;
        }
    }
    if (_maxi > 0) {
        guardsmen_ratio = _curr / _maxi;
    }
    return clamp(guardsmen_ratio, 0, 1);
}

//TODO allow for splitting forces

/// @self Asset.GMObject.obj_en_fleet
function scr_navy_unload_guard(planet) {
    var total_guard = fleet_guard_current();

    array_set_value(frigate_imp, 0);
    array_set_value(escort_imp, 0);
    array_set_value(capital_imp, 0);

    orbiting.p_guardsmen[planet] += total_guard;

    guardsmen_unloaded = 1;
    end_sequence_finished = true;
}

/// @self Asset.GMObject.obj_en_fleet
function scr_navy_planet_action() {
    if (action == "" && !guardsmen_unloaded && instance_exists(orbiting)) {
        // Unload if problem sector, otherwise patrol
        var selected_planet = 0, highest = 0, _target_pop = 0, _popu_large = false;

        for (var p = 1; p <= orbiting.planets; p++) {
            var planet_enemies = planet_imperial_base_enemies(p, orbiting);

            if (planet_enemies > highest && orbiting.p_type[p] != "Daemon") {
                selected_planet = p;
                highest = planet_enemies;
                _target_pop = orbiting.p_population[p];
                if (orbiting.p_large[p]) {
                    _popu_large = true;
                }
            }

            // New shit here, prioritize higher population worlds
            if (planet_enemies >= highest && orbiting.p_type[p] != "Daemon" && p > 1) {
                var _large_planet_pop = orbiting.p_large[p];
                var _planet_pop = orbiting.p_population[p];
                if (has_imperial_enemies(p, orbiting)) {
                    if (population_larger(_large_planet_pop, _planet_pop, _popu_large, _target_pop)) {
                        selected_planet = p;
                        highest = planet_imperial_base_enemies(p, orbiting);
                        _popu_large = _large_planet_pop;
                    }
                }
            }

            if (obj_controller.faction_status[eFACTION.IMPERIUM] == "War") {
                if (orbiting.p_owner[p] == eFACTION.PLAYER && orbiting.p_player[p] == 0 && highest == 0) {
                    selected_planet = p;
                    highest = 0.5;
                }
                if ((orbiting.p_player[p] / 50) >= highest) {
                    selected_planet = p;
                    highest = orbiting.p_player[p] / 50;
                }
                if (planet_feature_bool(orbiting.p_feature[p], eP_FEATURES.MONASTERY) == 1) {
                    selected_planet = p;
                    highest = 1000 + p;
                }
            }
        }
        var _pdf_handling_it = (orbiting.p_influence[selected_planet][eFACTION.IMPERIUM] > 50) && (orbiting.p_pdf[selected_planet] >= 0 && highest <= 2);

        if (selected_planet > 0 && highest > 0 && array_sum(orbiting.p_guardsmen) <= 0) {
            if (!_pdf_handling_it) {
                scr_navy_unload_guard(selected_planet);
            }
        }

        var _player_planet = false;
        if (obj_controller.faction_status[eFACTION.IMPERIUM] == "War") {
            if (scr_orbiting_fleet(eFACTION.PLAYER) != "none") {
                _player_planet = true;
            }

            for (var r = 1; r <= orbiting.planets; r++) {
                _player_planet = orbiting.p_owner[r] == eFACTION.PLAYER;
                if (!_player_planet) {
                    _player_planet = planet_feature_bool(orbiting.p_feature[r], eP_FEATURES.MONASTERY);
                }
            }
        }

        if (((selected_planet == 0 && highest == 0) || _pdf_handling_it) && !_player_planet) {
            var halp = 0;
            var stars_needing_help = [];

            // Check for any help requests
            with (obj_star) {
                if (array_contains(p_halp, 1)) {
                    array_push(stars_needing_help, id);
                }
            }
            if (array_length(stars_needing_help)) {
                var _current = nearest_from_array(x, y, stars_needing_help);
                var _current_star = stars_needing_help[_current];
                var _star_distance = point_distance(x, y, _current_star.x, _current_star.y);
                if (_star_distance > 600) {
                    halp = 0;
                }

                if (_star_distance <= 600) {
                    var star_to_rescue = instance_nearest(_current_star.x, _current_star.y, obj_star);
                    with (star_to_rescue) {
                        array_replace_value(p_halp, 1, 1.1);
                    }

                    action_x = _current_star.x;
                    action_y = _current_star.y;
                    set_fleet_movement();
                }
            }

            // Patrol otherwise
            if (halp == 0) {
                with (orbiting) {
                    y -= 10000;
                }
                with (obj_star) {
                    if (craftworld == 1 || space_hulk == 1) {
                        y -= 10000;
                    }
                }

                var ndir = floor(random_range(0, 360)) + 1;
                if (y <= 300) {
                    ndir = floor(random_range(180, 359)) + 1;
                }
                if (y > (room_height - 300)) {
                    ndir = irandom_range(0, 180);
                }
                if (x <= 300) {
                    ndir = choose(irandom_range(1, 91), irandom_range(270, 360));
                }
                if (x > (room_width - 300)) {
                    ndir = irandom_range(90, 270);
                }

                ndis = random_range(200, 400);
                var next = instance_nearest(x + lengthdir_x(ndis, ndir), y + lengthdir_y(ndis, ndir), obj_star);
                // next=instance_nearest(x,y,obj_star);

                with (obj_star) {
                    if (y < -5000) {
                        y += 10000;
                    }
                    if (y < -5000) {
                        y += 10000;
                    }
                }

                action_x = next.x;
                action_y = next.y;
            }
        }
    }
}

/// @self Asset.GMObject.obj_en_fleet
function navy_load_up_guardsmen_or_move_planet(planet, valid_next_planet) {
    var _player_war = false;
    var _pdata = orbiting.get_planet_data(planet);
    if (_pdata.player_forces > 0 && obj_controller.faction_status[eFACTION.IMPERIUM] == "War") {
        _player_war = true;
    }
    if (planet <= 0 || _player_war) {
        exit;
    }

    if (valid_next_planet > 0) {
        // Jump to next planet
        orbiting.p_guardsmen[valid_next_planet] = _pdata.guardsmen;
        _pdata.edit_guardsmen(-_pdata.guardsmen);
        end_sequence_finished = true;
    } else {
        // Get back onboard
        navy_load_guardsmen();

        trade_goods = "";
        guardsmen_unloaded = false;
    }
}

/// @self Asset.GMObject.obj_en_fleet
function navy_load_guardsmen() {
    var _new_capacity;
    var _maxi = fleet_max_guard();
    _new_capacity = min(array_sum(orbiting.p_guardsmen), _maxi);

    for (var i = 0; i < max(capital_number, frigate_number, escort_number); i++) {
        if (_new_capacity > 0 && capital_number >= i) {
            capital_imp[i] = min(capital_max_imp[i], _new_capacity);
            _new_capacity -= capital_imp[i];
        }
        if (_new_capacity > 0 && frigate_number >= i) {
            frigate_imp[i] = min(frigate_max_imp[i], _new_capacity);
            _new_capacity -= frigate_imp[i];
        }

        if (_new_capacity > 0 && escort_number >= i) {
            escort_imp[i] = min(escort_max_imp[i], _new_capacity);
            _new_capacity -= escort_imp[i];
        }
    }
    orbiting.p_guardsmen = array_create(5, 0);
}

/// @self Asset.GMObject.obj_en_fleet
function scr_navy_has_unloaded_guardsmen_turn_end() {
    var _next_planet = 0, _current_planet = 0;

    var _move_data = guard_find_planet_with_most_enemy_forces(orbiting);

    _next_planet = _move_data[0];
    _current_planet = _move_data[1];

    // Move on, man
    if (_current_planet) {
        if (!has_imperial_enemies(_current_planet, orbiting)) {
            navy_load_up_guardsmen_or_move_planet(_current_planet, _next_planet);
        }
    } else {
        guardsmen_unloaded = false;
    }
}

/// @self Asset.GMObject.obj_en_fleet
function scr_navy_recruit_new_guard() {
    var that = 0, te = 0, te_large = 0;
    for (var o = 1; o <= orbiting.planets; o++) {
        if (orbiting.p_owner[o] <= eFACTION.ECCLESIARCHY) {
            var _imp_enemies = has_imperial_enemies(o, orbiting);
            if (_imp_enemies) {
                continue;
            }
            if (orbiting.p_population[o] <= 0) {
                continue;
            }
            var _cur_large = orbiting.p_large[o];
            var _cur_pop = orbiting.p_population[o];
            if (that == 0 || population_larger(_cur_large, _cur_pop, te_large, te)) {
                te = _cur_pop;
                that = o;
                te_large = _cur_large;
            }
        }
    }

    var guard_wanted = fleet_max_guard() - fleet_guard_current();

    var recruit_planet = orbiting.get_planet_data(that);

    if (recruit_planet.population > guard_wanted || recruit_planet.large_population) {
        if (recruit_planet.large_population) {
            guard_wanted = recruit_planet.population_large_conversion(1000000000);
        }
        var _max_array = max_array_length([capital_imp, frigate_imp, escort_imp]);
        recruit_planet.edit_population(-guard_wanted);
        for (var i = 0; i < _max_array; i++) {
            if (i < array_length(capital_imp)) {
                capital_imp[i] = capital_max_imp[i];
            }
            if (i < array_length(frigate_imp)) {
                frigate_imp[i] = frigate_max_imp[i];
            }
            if (i < array_length(escort_imp)) {
                escort_imp[i] = escort_max_imp[i];
            }
        }
        trade_goods = "recruited";
    }
}

function scr_navy_find_recruit_world() {
    var _maxi = fleet_max_guard();
    var _curr = fleet_guard_current();
    var _guard_wanted = _maxi - _curr, planet_needed = 0;

    if (_guard_wanted <= 50000) {
        planet_needed = 1;
    } // Pretty much any
    if (_guard_wanted > 50000) {
        planet_needed = 2;
    } // Feudal and up
    if (_guard_wanted > 200000) {
        planet_needed = 3;
    } // Temperate and up
    if (_guard_wanted > 2000000) {
        planet_needed = 4;
    } // Hive
    trade_goods = "";

    var _nearest = -1;
    if (planet_needed == 1 || planet_needed == 2) {
        var good;
        var _eligible_stars = [];
        var _start = id;
        with (obj_star) {
            for (var o = 1; o <= planets; o++) {
                if (planet_needed <= 3) {
                    if (!p_large[o] && p_population[o] < (_guard_wanted * 6)) {
                        continue;
                    }
                }
                if (planet_needed < 5 && planet_needed > 2) {
                    if (p_large[o] && p_population[o] < 0.1) {
                        continue;
                    }
                }
                if (planet_needed > 3 && !p_large[o]) {
                    continue;
                }
                if (scr_is_planet_owned_by_allies(self, o) && (p_type[o] != "Dead")) {
                    if (p_orks[o] + p_chaos[o] + p_tyranids[o] + p_necrons[o] + p_tau[o] + p_traitors[o] <= 0 && p_influence[o][eFACTION.IMPERIUM] > 50) {
                        array_push(_eligible_stars, id);
                        if (!instance_exists(_nearest)) {
                            _nearest = id;
                        } else {
                            if (point_distance(x, y, _start.x, _start.y) < point_distance(_nearest.x, _nearest.y, _start.x, _start.y)) {
                                _nearest = id;
                            }
                        }
                        break;
                    }
                }
            }
        }
    }

    if (instance_exists(_nearest)) {
        if (_nearest.id == id) {
            trade_goods = "recruiting";
        } else {
            trade_goods = "goto_recruiting";
            action_x = _nearest.x;
            action_y = _nearest.y;
            set_fleet_movement();
            end_sequence_finished = true;
        }
    }
}

function create_start_imperial_fleets() {
    // Create an imperial fleet
    with (obj_controller) {
        with (obj_p_fleet) {
            var steh = instance_nearest(x, y, obj_star);

            var choices = [
                eFACTION.PLAYER,
                eFACTION.IMPERIUM,
                eFACTION.MECHANICUS,
                eFACTION.INQUISITION,
                eFACTION.ECCLESIARCHY,
            ];

            for (var b = 1; b <= 4; b++) {
                var is_valid = array_contains(choices, steh.p_first[b]);
                if (is_valid && (steh.dispo[b] > -30) && (steh.dispo[b] < 0)) {
                    var curr_imp_dispo = obj_controller.disposition[eFACTION.IMPERIUM];
                    steh.dispo[b] = min(obj_ini.imperium_disposition, curr_imp_dispo) + choose(-1, -2, -3, -4, 0, 1, 2, 3, 4);
                }
            }
            if (steh.visited == 0) {
                for (var planet_num = 1; planet_num < 5; planet_num++) {
                    if (array_length(steh.p_feature[planet_num]) != 0) {
                        with (steh) {
                            scr_planetary_feature(planet_num);
                        }
                    }
                }
                steh.visited = 1;
            }
        }

        var _good_navy_stars = [];

        with (obj_star) {
            var sco = 0;
            for (var o = 1; o <= 4; o++) {
                if (p_type[o] == "Hive") {
                    sco += 3;
                }
                if (p_type[o] == "Temperate") {
                    sco += 1;
                }
            }
            if (sco >= 4) {
                array_push(_good_navy_stars, id);
            }
        }

        if (array_length(_good_navy_stars) < target_navy_number) {
            with (obj_star) {
                var sco = 0;
                for (var o = 1; o <= planets; o++) {
                    if (p_type[o] == "Hive") {
                        sco += 3;
                    }
                    if (p_type[o] == "Temperate") {
                        sco += 1;
                    }
                    if (p_type[o] == "Shrine") {
                        sco += 1;
                    }
                }
                if (sco >= 3 && !array_contains(_good_navy_stars, id)) {
                    array_push(_good_navy_stars, id);
                }
            }
        }
        _good_navy_stars = array_shuffle(_good_navy_stars);

        for (var i = 0; i < array_length(_good_navy_stars); i++) {
            if (i >= target_navy_number) {
                break;
            }

            var _star = _good_navy_stars[i];

            setup_start_imperial_navy_fleet(_star);
        }
    }
}

function setup_start_imperial_navy_fleet(system) {
    var ii = 0;
    /// @type {Asset.GMObject.obj_en_fleet}
    var nav = create_enemy_fleet(system.x, system.y, eFACTION.IMPERIUM);
    with (nav) {
        navy = 1;

        capital_number = choose(1, 2, 3);
        frigate_number = (capital_number * 2) + 3;
        escort_number = 12;
        home_x = x;
        home_y = y;
        warp_able = true;

        image_speed = 0;
        ii += capital_number - 1;
        ii += round((frigate_number / 2));
        ii += round((escort_number / 4));
        if ((ii <= 1) && (capital_number + frigate_number + escort_number > 0)) {
            ii = 1;
        }
        image_index = ii;

        for (var i = 0; i < capital_number; i++) {
            capital_max_imp[i] = (((floor(random(15)) + 1) * 1000000) + 15000000) * 2;
            capital_imp[i] = capital_max_imp[i];
        }
        for (var i = 0; i < frigate_number; i++) {
            frigate_max_imp[i] = (500000 + (floor(random(50)) + 1) * 10000) * 2;
            frigate_imp[i] = frigate_max_imp[i];
        }
    }
}

function get_imperial_navy_fleets() {
    var _fleets = [];

    with (obj_en_fleet) {
        if (owner != eFACTION.IMPERIUM || !navy) {
            continue;
        } else if (owner == eFACTION.IMPERIUM && navy) {
            array_push(_fleets, id);
        }
    }

    return _fleets;
}

// ============================================================================
// Imperial Navy Orders (Sector Governor fleet suggestions)
// ----------------------------------------------------------------------------
// The player can click an Imperial Navy fleet to open the Sector Governor's
// audience in "fleet orders" mode and SUGGEST one of: Hold position, As you
// were (resume autonomy), or Follow one of the player's fleets (largest /
// closest / smallest, locked to the fleet chosen at order time). Honoured only
// while the Governor's disposition is above NAVY_ORDER_MIN_DISPOSITION.
// A following fleet trails the chosen fleet, joins its attack (finishing the
// planet), then reverts to autonomy once the attack is done or after
// NAVY_FOLLOW_MAX_TURNS turns. Per-fleet state (navy_order, navy_follow_uid,
// navy_order_turns) is declared in obj_en_fleet Create for save safety.
// ============================================================================

/// @function navy_order_ensure
/// @description Old-save safety: seed the navy-order fields on a fleet that predates them.
/// @param {Id.Instance.obj_en_fleet} _fleet
/// @returns {Undefined}
function navy_order_ensure(_fleet) {
    if (!variable_instance_exists(_fleet, "navy_order")) {
        _fleet.navy_order = "";
    }
    if (!variable_instance_exists(_fleet, "navy_follow_uid")) {
        _fleet.navy_follow_uid = "";
    }
    if (!variable_instance_exists(_fleet, "navy_order_turns")) {
        _fleet.navy_order_turns = 0;
    }
}

/// @function player_fleet_flagship_uid
/// @description A stable identifier for a player fleet: the uid of its first ship (capital,
///              else frigate, else escort). Used to LOCK a follow order to a specific fleet so
///              it survives instance-id reuse. Returns "" if the fleet has no ships.
/// @param {Id.Instance.obj_p_fleet} _fleet
/// @returns {String}
function player_fleet_flagship_uid(_fleet) {
    if (!instance_exists(_fleet)) {
        return "";
    }
    for (var i = 0; i < array_length(_fleet.capital_uid); i++) {
        if ((_fleet.capital[i] != "") && (_fleet.capital_uid[i] != "")) {
            return string(_fleet.capital_uid[i]);
        }
    }
    for (var i = 0; i < array_length(_fleet.frigate_uid); i++) {
        if ((_fleet.frigate[i] != "") && (_fleet.frigate_uid[i] != "")) {
            return string(_fleet.frigate_uid[i]);
        }
    }
    for (var i = 0; i < array_length(_fleet.escort_uid); i++) {
        if ((_fleet.escort[i] != "") && (_fleet.escort_uid[i] != "")) {
            return string(_fleet.escort_uid[i]);
        }
    }
    return "";
}

/// @function player_fleet_by_flagship_uid
/// @description Find the player fleet whose flagship uid matches (the locked follow target).
///              Returns noone if no live fleet matches (e.g. it was destroyed).
/// @param {String} _uid
/// @returns {Id.Instance.obj_p_fleet|Real}
function player_fleet_by_flagship_uid(_uid) {
    if (_uid == "") {
        return noone;
    }
    var _match = noone;
    with (obj_p_fleet) {
        if (player_fleet_flagship_uid(id) == _uid) {
            _match = id;
            break;
        }
    }
    return _match;
}

/// @function player_fleet_pick
/// @description Resolve one of the player's fleets by rule at ORDER time: "largest" (most
///              ships), "smallest" (fewest ships, non-empty), or "closest" (nearest to the
///              ordering Navy fleet). Returns the chosen obj_p_fleet, or noone if none exist.
/// @param {String} _rule   "largest" | "smallest" | "closest"
/// @param {Real} _from_x
/// @param {Real} _from_y
/// @returns {Id.Instance.obj_p_fleet|Real}
function player_fleet_pick(_rule, _from_x, _from_y) {
    var _best = noone;
    var _best_metric = -1;
    with (obj_p_fleet) {
        var _count = player_fleet_ship_count(id);
        if (_count <= 0) {
            continue;
        }
        var _metric;
        if (_rule == "largest") {
            _metric = _count;
        } else if (_rule == "smallest") {
            _metric = -_count;
        } else {
            _metric = -point_distance(_from_x, _from_y, x, y);
        }
        if ((_best == noone) || (_metric > _best_metric)) {
            _best = id;
            _best_metric = _metric;
        }
    }
    return _best;
}

/// @function navy_order_give
/// @description Apply a suggestion to a Navy fleet, gated on disposition. Returns true if the
///              order was accepted. _kind is "hold", "release" (As you were), or "follow".
/// @param {Id.Instance.obj_en_fleet} _fleet
/// @param {String} _kind
/// @param {String} _rule
/// @returns {Bool}
function navy_order_give(_fleet, _kind, _rule = "") {
    if (!instance_exists(_fleet)) {
        return false;
    }
    if (obj_controller.disposition[eFACTION.IMPERIUM] <= NAVY_ORDER_MIN_DISPOSITION) {
        return false;
    }
    navy_order_ensure(_fleet);
    _fleet.navy_order_turns = 0;

    // Cancelling an order ("As you were") is free; it just returns the fleet to autonomy.
    if (_kind == "release") {
        _fleet.navy_order = "";
        _fleet.navy_follow_uid = "";
        return true;
    }

    // Every ACTIVE order (hold / follow) costs the Governor a little goodwill, so the player
    // cannot spam orders for free. Deduct once the order is confirmed accepted below.
    var _charge = function() {
        obj_controller.disposition[eFACTION.IMPERIUM] = max(0, obj_controller.disposition[eFACTION.IMPERIUM] - NAVY_ORDER_DISPOSITION_COST);
    };

    if (_kind == "hold") {
        _fleet.navy_order = "hold";
        _fleet.navy_follow_uid = "";
        _fleet.action = "";
        _fleet.target = noone;
        _charge();
        return true;
    }
    if (_kind == "follow") {
        var _target = player_fleet_pick(_rule, _fleet.x, _fleet.y);
        if (!instance_exists(_target)) {
            return false;
        }
        _fleet.navy_order = "follow";
        _fleet.navy_follow_uid = player_fleet_flagship_uid(_target);
        if (_fleet.navy_follow_uid == "") {
            return false;
        }
        _charge();
        return true;
    }
    return false;
}

/// @function navy_orders_tick
/// @description Per-turn processing of all Navy fleets under a player suggestion. HOLD stays
///              put; FOLLOW steers toward the locked player fleet and routes to the world it is
///              attacking to join the assault. Reverts to autonomy when the fleet is gone, the
///              disposition drops, or NAVY_FOLLOW_MAX_TURNS turns pass.
/// @returns {Undefined}
function navy_orders_tick() {
    with (obj_en_fleet) {
        if ((owner != eFACTION.IMPERIUM) || (navy != 1)) {
            continue;
        }
        navy_order_ensure(id);
        if (navy_order == "") {
            continue;
        }
        if (obj_controller.disposition[eFACTION.IMPERIUM] <= NAVY_ORDER_MIN_DISPOSITION) {
            navy_order = "";
            navy_follow_uid = "";
            navy_order_turns = 0;
            continue;
        }
        navy_order_turns += 1;

        if (navy_order == "hold") {
            action = "";
            target = noone;
            continue;
        }

        if (navy_order == "follow") {
            if (navy_order_turns > NAVY_FOLLOW_MAX_TURNS) {
                navy_order = "";
                navy_follow_uid = "";
                navy_order_turns = 0;
                continue;
            }
            var _pf = player_fleet_by_flagship_uid(navy_follow_uid);
            if (!instance_exists(_pf)) {
                navy_order = "";
                navy_follow_uid = "";
                navy_order_turns = 0;
                continue;
            }
            // Where is the followed fleet, and is it attacking a world? obj_p_fleet has no
            // `target` field; it exposes orbiting (the star it sits at) and, while travelling,
            // action=="move" with action_x/action_y as its destination. Prefer the star it is
            // orbiting (it is committing there), else the star it is moving toward, else just
            // shadow its position. Only (re)issue a course when the destination changes, so we
            // do not reset the fleet's ETA every turn.
            var _dest = noone;
            if (instance_exists(_pf.orbiting)) {
                _dest = _pf.orbiting;
            } else if (_pf.action == "move") {
                var _ns = instance_nearest(_pf.action_x, _pf.action_y, obj_star);
                if (instance_exists(_ns) && (point_distance(_ns.x, _ns.y, _pf.action_x, _pf.action_y) < 10)) {
                    _dest = _ns; // heading to a specific star
                }
            }
            var _dx = instance_exists(_dest) ? _dest.x : _pf.x;
            var _dy = instance_exists(_dest) ? _dest.y : _pf.y;
            // If already orbiting the destination star, let the fleet's own navy behaviour
            // (attack / bombard) run rather than re-issuing a move onto itself.
            var _already_there = instance_exists(_dest) && instance_exists(orbiting) && (orbiting == _dest);
            if (!_already_there) {
                target = instance_exists(_dest) ? _dest : noone;
                action_x = _dx;
                action_y = _dy;
                set_fleet_movement();
            }
            continue;
        }
    }
}


/// @function navy_open_fleet_orders
/// @description Open the Sector Governor's audience in fleet-order mode for a specific Imperial
///              Navy fleet (the one the player clicked). Mirrors scr_toggle_diplomacy's audience
///              setup, then routes straight to the "fleet_orders" dialogue branch. The clicked
///              fleet is stashed on obj_controller so the branch's choices apply to it.
/// @param {Id.Instance.obj_en_fleet} _fleet
/// @returns {Undefined}
function navy_open_fleet_orders(_fleet) {
    if (!instance_exists(_fleet)) {
        return;
    }
    with (obj_controller) {
        navy_order_target_fleet = _fleet;
        set_zoom_to_default();
        set_up_diplomacy_buttons();
        menu = eMENU.DIPLOMACY;
        audience = 1;                 // in an audience (not the faction-select screen)
        diplomacy = eFACTION.IMPERIUM; // talking to the Sector Governor
        hide_banner = 1;
        character_diplomacy = false;
        cooldown = 8;
        scr_dialogue("fleet_orders");
    }
}
