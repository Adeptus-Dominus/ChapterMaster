/// @self Asset.GMObject.obj_star
function scr_enemy_ai_d() {
    if (x < -15000) {
        x += 20000;
        y += 20000;
    }
    if (x < -15000) {
        x += 20000;
        y += 20000;
    }
    if (x < -15000) {
        x += 20000;
        y += 20000;
    }

    // Planetary problems here
    for (var i = 1; i <= planets; i++) {
        //this will skip for given planet if no problems associated wiht planet
        if ((p_necrons[i] > 0) && (p_necrons[i] < 6)) {
            p_necrons[i] += 1;
        }

        var wob = 0;
        var fallen = find_problem_planet(i, "fallen");
        if (fallen > -1 && storm - 1 > 0) {
            p_timer[i][fallen]++;
        }

        // Requesting help here
        if (((p_halp[i] == 1) || (p_halp[i] == 1.1)) && (p_population[i] > 0) && (p_owner[i] <= eFACTION.ECCLESIARCHY)) {
            if ((p_orks[i] + p_tau[i] + p_traitors[i] + p_chaos[i] + p_necrons[i] == 0) && (p_tyranids[i] < 4)) {
                p_halp[i] = 0;
            }
        }
        if ((p_halp[i] == 0) && (p_population[i] > 0) && (p_owner[i] <= eFACTION.ECCLESIARCHY) && (p_owner[i] != eFACTION.PLAYER) && (present_fleet[1] <= 0) && (p_player[i] <= 0)) {
            var enemy1 = "", enemies = 0, minimum = 5, tx = "";

            if (p_guardsmen[i] + p_pdf[i] <= 1000000) {
                minimum = 4;
            } else if (p_guardsmen[i] + p_pdf[i] <= 500000) {
                minimum = 3;
            } else if (p_guardsmen[i] + p_pdf[i] <= 200000) {
                minimum = 2;
            } else if (p_guardsmen[i] + p_pdf[i] <= 1000) {
                minimum = 1;
            }

            if (p_orks[i] >= minimum) {
                enemy1 = "Ork";
                enemies += 1;
            }
            if (p_tau[i] >= minimum) {
                enemy1 = "Tau";
                enemies += 1;
            }
            if (p_chaos[i] >= minimum) {
                enemy1 = "Heretic";
                enemies += 1;
            }
            if (p_traitors[i] >= minimum) {
                enemy1 = "Chaos Space Marine";
                enemies += 1;
            }
            if (p_necrons[i] >= minimum) {
                enemy1 = "Necron";
                enemies += 1;
            }
            if ((p_tyranids[i] >= minimum) && (vision > 0) && (p_tyranids[i] > 3)) {
                enemy1 = "Tyranid";
                enemies += 1;
            }

            if (enemies == 1) {
                p_halp[i] = 1;
                tx = $"The Planetary Governor of {planet_numeral_name(i)} requests help against {enemy1} forces!";
                scr_alert("green", "halp", string(tx), x, y);
                scr_event_log("", string(tx), name);
            }
            if (enemies > 1) {
                p_halp[i] = 1;
                tx = "The Planetary Governor of " + string(name) + " " + scr_roman(i) + " requests help against numerous enemy forces!";
                scr_alert("green", "halp", string(tx), x, y);
                scr_event_log("", string(tx), name);
            }
        }
    }
    for (var i = 1; i <= planets; i++) {
        problem_count_down(i);
        if (planet_problemless(i)) {
            continue;
        }

        var _pdata = get_planet_data(i);
        with (_pdata) {
            problem_end_turn_checks();
        }

        mechanicus_missions_end_turn(i);

        var _beast_hunt = has_problem_planet_and_time(i, "hunt_beast", 0);
        if (_beast_hunt > -1) {
            try {
                complete_beast_hunt_mission(i, _beast_hunt);
            } catch (_exception) {
                ERROR_HANDLER.handle_exception(_exception);
            }
        }

        var train_forces = has_problem_planet_and_time(i, "train_forces", 0);
        if (train_forces > -1) {
            try {
                complete_train_forces_mission(i, train_forces);
            } catch (_exception) {
                ERROR_HANDLER.handle_exception(_exception);
            }
        }

        if (((p_tyranids[i] == 3) || (p_tyranids[i] == 4)) && (p_population[i] > 0)) {
            if (!has_problem_planet(i, "Hive Fleet")) {
                var roll = irandom_range(100, 300);
                var cont = 0;

                if ((p_tyranids[i] == 3) && (roll <= 5)) {
                    cont = 1;
                }
                if ((p_tyranids[i] == 4) && (roll <= 8)) {
                    cont = 1;
                }

                var firstest = open_problem_slot(i);
                if (cont == 1 && firstest > -1) {
                    p_problem[i][firstest] = "Hive Fleet";
                    p_timer[i][firstest] = irandom_range(60, 120) + 1;
                    p_timer[i][firstest] += irandom_range(80, 120) + 1;

                    var xx = (random_range(room_width * 1.25, room_width * 2) * choose(-1, 1)) + x;
                    var yy = (random_range(room_height * 1.25, room_height * 2) * choose(-1, 1)) + y;
                    var fleet = create_enemy_fleet(xx, yy, eFACTION.TYRANIDS);
                    fleet.sprite_index = spr_fleet_tyranid;
                    fleet.image_speed = 0;

                    fleet.capital_number = choose(7, 8, 9);
                    fleet.frigate_number = round(random_range(6, 12));
                    fleet.escort_number = round(random_range(12, 27));

                    fleet.image_index = floor(fleet.capital_number + (fleet.frigate_number / 2) + (fleet.escort_number / 4));
                    fleet.image_alpha = 0;

                    fleet.action_x = x;
                    fleet.action_y = y;

                    fleet.action_eta = p_timer[i][firstest];
                    fleet.action = "move";
                }
            }
        }

        if (has_problem_planet_and_time(i, "Hive Fleet", 3) > -1) {
            var woop = scr_role_count("Chief " + string(obj_ini.role[100][17]), "");
            var yep = !scr_has_disadv("Psyker Intolerant");

            if ((obj_controller.known[eFACTION.TYRANIDS] == 0) && (woop != 0) && yep) {
                scr_popup("Shadow in the Warp", $"Chief {obj_ini.role[100][17]} " + string(obj_ini.name[0][5]) + " reports a disturbance in the warp.  He claims it is like a shadow.", "shadow", "");
                scr_event_log("red", $"Chief {obj_ini.role[100][17]} reports a disturbance in the warp.  He claims it is like a shadow.");
            }
            if ((obj_controller.known[eFACTION.TYRANIDS] == 0) && (woop == 0) && yep) {
                for (var q = 1; q <= 90; q++) {
                    if (obj_ini.role[0][q] == obj_ini.role[100][eROLE.CHAPTERMASTER]) {
                        if (string_count("0", obj_ini.spe[0][q]) > 0) {
                            scr_popup("Shadow in the Warp", "You are distracted and bothered by a nagging sensation in the warp.  It feels as though a shadow descends upon your sector.", "shadow", "");
                            scr_event_log("red", "You sense a disturbance in the warp.  It feels something like a massive shadow.");
                        }
                        break;
                    }
                }
            }

            i = 50;
            obj_controller.known[eFACTION.TYRANIDS] = 1;
        }
    }

    if (storm > 0) {
        storm -= 1;
        if (storm == 0) {
            var tr = "Warp Storms over " + string(name) + " dissipate.";
            scr_alert("green", "Warp", tr, x, y);
            scr_event_log("green", tr);
        }
    }
    if (trader > 0) {
        trader -= 1;
        if (trader == 0) {
            var tr = "Rogue Trader fleet departs from " + string(name) + ".";
            scr_alert("green", "Warp", tr, x, y);
            scr_event_log("green", tr);
        }
    }

    // Colonists Colonize

    with (obj_star) {
        if (x < -10000) {
            x += 20000;
            y += 20000;
        }
    }
    with (obj_star) {
        if (x < -10000) {
            x += 20000;
            y += 20000;
        }
    }

    var already_enroute = false;
    var cur_star = id;
    with (obj_en_fleet) {
        if ((owner == eFACTION.IMPERIUM) && fleet_has_cargo("colonize")) {
            already_enroute = action_x == cur_star.x && action_y == cur_star.y;
        }
    }

    if (!already_enroute) {
        var pop_doner_options = [];
        //this stops needless repeats of searches
        if (!struct_exists(obj_controller.end_turn_insights, "population_doners")) {
            pop_doner_options = find_population_doners();
        }
        obj_controller.end_turn_insights.population_doners = pop_doner_options;
        pop_doner_options = obj_controller.end_turn_insights.population_doners;

        var deletion = -1;
        for (var i = 0; i < array_length(pop_doner_options); i++) {
            if (pop_doner_options[i][0] == id) {
                deletion = i;
                break;
            }
        }
        if (deletion > -1) {
            array_delete(pop_doner_options, deletion, 1);
        }

        var priority_requests = [];
        var non_priority_requests = [];

        for (var r = 1; r <= planets; r++) {
            // temp5: new hive, temp4: new planet
            if (!scr_planet_owned_by_group(r, fetch_faction_group())) {
                continue;
            }
            if ((p_population[r] > 0) || (p_type[r] == "")) {
                continue;
            }
            if ((!space_hulk) && (!craftworld) && (p_type[r] != "Dead")) {
                var priority_imperium = [
                    "Hive",
                    "Temperate",
                    "Shrine",
                ];
                if ((p_owner[r] == eFACTION.IMPERIUM) && array_contains(priority_imperium, p_type[r])) {
                    array_push(priority_requests, r);
                    break;
                }

                if ((p_owner[r] == eFACTION.MECHANICUS) && (p_type[r] == "Forge")) {
                    array_push(priority_requests, r);
                    break;
                }
                // Count player planets as HIVE PLANETS so that they are prioritized
                if (p_owner[r] == eFACTION.PLAYER) {
                    array_push(priority_requests, r);
                    break;
                }

                if ((p_owner[r] == eFACTION.IMPERIUM) || (p_owner[r] == eFACTION.ECCLESIARCHY)) {
                    array_push(non_priority_requests, r);
                }
            }
        }

        if (array_length(pop_doner_options) > 0 && (array_length(non_priority_requests) || array_length(priority_requests))) {
            var random_chance = floor(random(100)) + 1;
            var doner_index = 0;
            // TODO check possible fixes for this logic
            // currently this only calculates for priority requests for pops
            for (var i = 1; i < array_length(pop_doner_options); i++) {
                if (star_distace_calc(pop_doner_options[i], priority_requests[0]) < star_distace_calc(pop_doner_options[doner_index], priority_requests[0])) {
                    doner_index = i;
                }
            }
            var doner_star = pop_doner_options[doner_index][0];
            var doner_planet = pop_doner_options[doner_index][1];

            if (array_length(priority_requests) && (random_chance <= 2)) {
                // A hive is requesting repopulation

                new_colony_fleet(doner_star.id, doner_planet, self.id, priority_requests[0]);
            } else if (array_length(non_priority_requests) && (random_chance <= 2)) {
                // Some other world is requesting repopulation

                new_colony_fleet(doner_star.id, doner_planet, self.id, non_priority_requests[0]);
            }
        }

        instance_activate_all();
        with (obj_star) {
            if (x < -10000) {
                x += 20000;
                y += 20000;
            }
            if (x < -10000) {
                x += 20000;
                y += 20000;
            }
        }
    }

    // Local problems will go here
    for (var i = 1; i <= planets; i++) {
        if (i < array_length(system_garrison)) {
            var garrison = get_garrison(i);
            if (garrison.garrison_force) {
                garrison.garrison_disposition_change();
            }
        }
    }
}
