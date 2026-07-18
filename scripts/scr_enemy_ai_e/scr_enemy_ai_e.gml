/// @self Asset.GMObject.obj_star
function scr_enemy_ai_e() {
    // Guess I'll handle all of the ship combat in here
    // This needs to keep on running in each sector until only one faction's fleet remains
    var imperium_enemies = present_fleet[7] + present_fleet[8] + present_fleet[9] + present_fleet[10] + present_fleet[13];

    var standard_xenos_enemies = present_fleet[2] + present_fleet[7] + present_fleet[8] + present_fleet[10] + present_fleet[13];

    var imperium_fleets = present_fleet[2] + present_fleet[3];

    var have_fleets = 0;
    var battle = 0;
    var battle2 = 0;

    var attack = array_create(20, 0);
    var strength = array_create(20, 0);
    var damage = array_create(20, 0);

    for (var i = 1; i <= 13; i += 1) {
        if (present_fleet[i]) {
            have_fleets += 1;
        }
    }

    if (present_fleet[1] > 0) {
        // Battle1 is reserved for player battles
        var battle_if_war = [
            8,
            eFACTION.MECHANICUS,
            eFACTION.IMPERIUM,
        ];

        var always_battle = [
            7,
            9,
        ];

        for (var i = 0; i < array_length(battle_if_war); i++) {
            var cur_targ = battle_if_war[i];
            if ((present_fleet[cur_targ] > 0) && (obj_controller.faction_status[cur_targ] == "War")) {
                battle = 1;
                break;
            }
        }
        if (!battle) {
            for (var i = 0; i < array_length(always_battle); i++) {
                var cur_targ = always_battle[i];
                if ((present_fleet[cur_targ] > 0) && (obj_controller.faction_status[cur_targ] == "War")) {
                    battle = 1;
                    break;
                }
            }
        }

        if ((present_fleet[10] > 0) && (obj_controller.faction_status[10] == "War")) {
            if (!battle) {
                if (!has_problem_star("meeting") && !has_problem_star("meeting_trap")) {
                    battle = 1;
                }
            }
        }
        if (present_fleet[13] > 0) {
            battle = 1;
        }
    }

    if (battle2 == 0) {
        if (present_fleet[2] > 0) {
            if (imperium_enemies > 0) {
                battle2 = 2;
            }
        } else if (present_fleet[3] > 0) {
            if (imperium_enemies > 0) {
                battle2 = 3;
            }
        } else if (present_fleet[6] > 0) {
            if (standard_xenos_enemies > 0) {
                battle2 = 6;
            }
        } else if (present_fleet[7] > 0) {
            if (standard_xenos_enemies - present_fleet[7] > 0) {
                battle2 = 7;
            }
        } else if (present_fleet[8] > 0) {
            if (standard_xenos_enemies - present_fleet[8] > 0) {
                battle2 = 8;
            }
        } else if (present_fleet[9] > 0) {
            if (standard_xenos_enemies - present_fleet[9] > 0) {
                battle2 = 9;
            }
        } else if (present_fleet[10] > 0) {
            if (standard_xenos_enemies - present_fleet[10] > 0) {
                battle2 = 10;
            }
        } else if (present_fleet[13] > 0) {
            if (standard_xenos_enemies > 0) {
                battle2 = 13;
            }
        }
    }

    instance_activate_object(obj_en_fleet);
    if ((battle2 > 0) && (battle == 0)) {
        // AI only battle
        for (var f = 2; f <= 11; f++) {
            if (f == 11) {
                f = 13;
            }
            if (present_fleet[f] > 0) {
                obj_controller.temp[1049] = self.id;
                obj_controller.temp[1050] = f;
                var _orbiting = self.id;
                var _wanted_owner = f;
                var fleet_strength = 0;
                with (obj_en_fleet) {
                    if ((orbiting == _orbiting) && (owner == _wanted_owner)) {
                        fleet_strength = self.escort_number + (self.frigate_number * 4) + (self.capital_number * 8);
                        if (owner == fleet_has_cargo("ork_warboss")) {
                            fleet_strength *= 1.5;
                        }
                    }
                }

                strength[f] = fleet_strength;

                if ((f == 7) && (strength[7] > 0)) {
                    strength[f] = strength[f] * 0.8;
                } else if ((f == 9) && (strength[9] > 0)) {
                    strength[f] = strength[f] * 1.1;
                } else if ((f == 10) && (strength[10] > 0)) {
                    strength[f] = strength[f] * 1.1;
                } else if ((f == 11) && (strength[13] > 0)) {
                    strength[13] = strength[13] * 2;
                }

                with (obj_en_ship) {
                    if ((x < -7000) && (y < -7000)) {
                        x += 10000;
                        y += 10000;
                    }
                }
                with (obj_en_ship) {
                    if ((x < -7000) && (y < -7000)) {
                        x += 10000;
                        y += 10000;
                    }
                }
                with (obj_en_ship) {
                    if ((x < -7000) && (y < -7000)) {
                        x += 10000;
                        y += 10000;
                    }
                }
            }
        } // This grabs the "strength" from all present fleets and adds it to the temporary variable for this AI battle

        // Determine who will attack who
        repeat (5) {
            var still_battling = false;
            if ((strength[2] + strength[3] > 0) && (strength[6] + strength[7] + strength[8] + strength[9] + strength[10] + strength[13] > 0)) {
                still_battling = true;
            }
            if ((strength[6] > 0) && (strength[2] + strength[7] + strength[8] + strength[9] + strength[10] + strength[13] > 0)) {
                still_battling = true;
            }
            if ((strength[7] > 0) && (strength[2] + strength[6] + strength[8] + strength[9] + strength[10] + strength[13] > 0)) {
                still_battling = true;
            }
            if ((strength[8] > 0) && (strength[2] + strength[6] + strength[7] + strength[9] + strength[10] + strength[13] > 0)) {
                still_battling = true;
            }
            if ((strength[9] > 0) && (strength[2] + strength[6] + strength[7] + strength[8] + strength[10] + strength[13] > 0)) {
                still_battling = true;
            }
            if ((strength[10] > 0) && (strength[2] + strength[6] + strength[7] + strength[8] + strength[9] + strength[13] > 0)) {
                still_battling = true;
            }
            if ((strength[13] > 0) && (strength[2] + strength[6] + strength[7] + strength[8] + strength[9] + strength[10] > 0)) {
                still_battling = true;
            }

            if (still_battling == true) {
                // Imperial Fleet Attacks
                var who = 2;
                if (strength[who] > 0) {
                    if ((strength[9] > 0) && (attack[who] == 0)) {
                        attack[who] = 9;
                    }
                    if ((strength[10] > 0) && (attack[who] == 0)) {
                        attack[who] = 10;
                    }
                    if ((strength[13] > 0) && (attack[who] == 0)) {
                        attack[who] = 13;
                    }
                    if ((strength[7] > 0) && (attack[who] == 0)) {
                        attack[who] = 7;
                    }
                    if ((strength[8] > 0) && (attack[who] == 0)) {
                        attack[who] = 8;
                    }
                    if ((strength[6] > 0) && (attack[who] == 0)) {
                        attack[who] = 6;
                    }
                    damage[attack[who]] += strength[who] / 2;
                }

                // Eldar Fleet Attacks
                who = 6;
                if (strength[who] > 0) {
                    if ((strength[13] > 0) && (13 != who)) {
                        attack[who] = 13;
                    }
                    if (attack[who] != 13) {
                        for (var i = 10; i >= 2; i--) {
                            if ((strength[i] > 0) && (i != who)) {
                                attack[who] = i;
                            }
                        }
                    }
                    damage[attack[who]] += strength[who] / 2;
                }

                // Ork Fleet Attacks
                who = 7;
                if (strength[who] > 0) {
                    if ((strength[9] > 0) && (attack[who] == 0)) {
                        attack[who] = 9;
                    }
                    if ((strength[13] > 0) && (attack[who] == 0)) {
                        attack[who] = 13;
                    }
                    if ((strength[10] > 0) && (attack[who] == 0)) {
                        attack[who] = 10;
                    }
                    if ((strength[8] > 0) && (attack[who] == 0)) {
                        attack[who] = 8;
                    }
                    if ((strength[2] > 0) && (attack[who] == 0)) {
                        attack[who] = 2;
                    }
                    if ((strength[6] > 0) && (attack[who] == 0)) {
                        attack[who] = 6;
                    }
                    damage[attack[who]] += strength[who] / 2;
                }

                // Tau Fleet Attacks
                who = 8;
                if (strength[who] > 0) {
                    if ((strength[13] > 0) && (attack[who] == 0)) {
                        attack[who] = 13;
                    }
                    if ((strength[9] > 0) && (attack[who] == 0)) {
                        attack[who] = 9;
                    }
                    if ((strength[7] > 0) && (attack[who] == 0)) {
                        attack[who] = 7;
                    }
                    if ((strength[10] > 0) && (attack[who] == 0)) {
                        attack[who] = 10;
                    }
                    if ((strength[2] > 0) && (attack[who] == 0)) {
                        attack[who] = 2;
                    }
                    damage[attack[who]] += strength[who] / 2;
                }

                // Tyranid Fleet Attacks
                who = 9;
                if (strength[who] > 0) {
                    if ((strength[13] > 0) && (13 != who)) {
                        attack[who] = 13;
                    }
                    if (attack[who] != 13) {
                        for (var i = 2; i <= 10; i++) {
                            if ((strength[i] > 0) && (i != who)) {
                                attack[who] = i;
                            }
                        }
                    }
                    damage[attack[who]] += strength[who] / 2;
                }

                // Chaos Fleet Attacks
                who = 10;
                if (strength[who] > 0) {
                    if ((strength[9] > 0) && (attack[who] == 0)) {
                        attack[who] = 9;
                    }
                    if ((strength[13] > 0) && (attack[who] == 0)) {
                        attack[who] = 13;
                    }
                    if ((strength[2] > 0) && (attack[who] == 0)) {
                        attack[who] = 2;
                    }
                    if ((strength[6] > 0) && (attack[who] == 0)) {
                        attack[who] = 6;
                    }
                    if ((strength[7] > 0) && (attack[who] == 0)) {
                        attack[who] = 7;
                    }
                    if ((strength[8] > 0) && (attack[who] == 0)) {
                        attack[who] = 8;
                    }
                    damage[attack[who]] += strength[who] / 2;
                }

                // Necron Fleet Attacks
                who = 13;
                if (strength[who] > 0) {
                    if ((strength[6] > 0) && (attack[who] == 0)) {
                        attack[who] = 6;
                    }
                    if ((strength[9] > 0) && (attack[who] == 0)) {
                        attack[who] = 9;
                    }
                    if ((strength[2] > 0) && (attack[who] == 0)) {
                        attack[who] = 2;
                    }
                    if ((strength[10] > 0) && (attack[who] == 0)) {
                        attack[who] = 10;
                    }
                    if ((strength[7] > 0) && (attack[who] == 0)) {
                        attack[who] = 7;
                    }
                    if ((strength[8] > 0) && (attack[who] == 0)) {
                        attack[who] = 8;
                    }
                    damage[attack[who]] += strength[who] / 2;
                }

                // Attacking has been determined, work out damage
                for (var i = 2; i <= 10; i++) {
                    strength[i] -= damage[i];
                    damage[i] = 0;
                    if ((strength[i] <= 0) && (present_fleet[i] > 0)) {
                        obj_controller.temp[1049] = i;
                        obj_controller.temp[1050] = self.id;
                        with (obj_en_fleet) {
                            if ((owner == obj_controller.temp[1049]) && (orbiting == obj_controller.temp[1050])) {
                                instance_destroy();
                            }
                        }
                    }
                }

                strength[13] -= damage[13];
                damage[13] = 0;
                if ((strength[13] <= 0) && (present_fleet[13] > 0)) {
                    obj_controller.temp[1049] = 13;
                    obj_controller.temp[1050] = self.id;
                    with (obj_en_fleet) {
                        if ((owner == obj_controller.temp[1049]) && (orbiting == obj_controller.temp[1050])) {
                            instance_destroy();
                        }
                    }
                }
            }
        }

        // Those 5 battle intervals have finished
        // Clean up the surviving fleet(s)

        for (var i = 2; i <= 11; i++) {
            if (i == 11) {
                i = 13;
            }
            if ((strength[i] > 0) && (present_fleet[i] > 0)) {
                // Get RACE[X] ORBITING[Y] and STRENGTH[z]
                obj_controller.temp[1047] = strength[i];
                obj_controller.temp[1048] = 0;
                obj_controller.temp[1049] = i;
                obj_controller.temp[1050] = self.id;

                with (obj_en_fleet) {
                    if ((owner != obj_controller.temp[1049]) && (orbiting != obj_controller.temp[1050])) {
                        x -= 10000;
                        y -= 10000;
                    }
                    if ((owner == obj_controller.temp[1049]) && (orbiting == obj_controller.temp[1050])) {
                        obj_controller.temp[1048] += escort_number;
                        obj_controller.temp[1048] += frigate_number * 4;
                        obj_controller.temp[1048] += capital_number * 8;
                    }
                }

                if (strength[i] < obj_controller.temp[1048]) {
                    // Need to remove ships if !=
                    repeat (40) {
                        if (obj_controller.temp[1047] > obj_controller.temp[1048]) {
                            with (obj_en_fleet) {
                                if ((owner == obj_controller.temp[1049]) && (orbiting == obj_controller.temp[1050])) {
                                    if ((escort_number > 0) && (escort_number + frigate_number + capital_number != 1)) {
                                        escort_number -= 1;
                                        obj_controller.temp[1047] -= 1;
                                        if (escort_number + frigate_number + capital_number <= 0) {
                                            instance_destroy();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if (strength[i] < obj_controller.temp[1048]) {
                    repeat (20) {
                        if (obj_controller.temp[1047] < obj_controller.temp[1048]) {
                            with (obj_en_fleet) {
                                if ((owner == obj_controller.temp[1049]) && (orbiting == obj_controller.temp[1050])) {
                                    if ((frigate_number > 0) && (escort_number + frigate_number + capital_number != 1)) {
                                        frigate_number -= 1;
                                        obj_controller.temp[1047] -= 4;
                                        if (escort_number + frigate_number + capital_number <= 0) {
                                            instance_destroy();
                                        }
                                    }
                                }
                            }
                        }
                    }
                    repeat (10) {
                        if (obj_controller.temp[1047] < obj_controller.temp[1048]) {
                            with (obj_en_fleet) {
                                if ((owner == obj_controller.temp[1049]) && (orbiting == obj_controller.temp[1050])) {
                                    if ((capital_number > 0) && (escort_number + frigate_number + capital_number != 1)) {
                                        capital_number -= 1;
                                        obj_controller.temp[1047] -= 8;
                                        if (escort_number + frigate_number + capital_number <= 0) {
                                            instance_destroy();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                strength[i] = obj_controller.temp[1047];
                // I'd hope that removes enough ships from the survivor
            }
            with (obj_en_fleet) {
                if ((x < -5000) && (y < -5000)) {
                    x += 10000;
                    y += 10000;
                }
            }
        }
    } // End AI battle

    if (battle > 0) {
        if ((present_fleet[1] > 0) && ((present_fleet[6] + present_fleet[7] + present_fleet[8] + present_fleet[9] + present_fleet[10] + present_fleet[13] > 0) || ((present_fleet[2] > 0) && (obj_controller.faction_status[2] == "War")))) {
            for (var i = 2; i <= 10; i++) {
                var special_stop = false;
                if (i == 10) {
                    special_stop = has_problem_star("meeting") || has_problem_star("meeting_trap");
                }

                if ((obj_controller.faction_status[i] == "War") && (!special_stop) && (present_fleet[i] > 0)) {
                    // Quene battle
                    obj_turn_end.battles += 1;
                    obj_turn_end.battle[obj_turn_end.battles] = 1;
                    obj_turn_end.battle_world[obj_turn_end.battles] = 0;
                    obj_turn_end.battle_opponent[obj_turn_end.battles] = i; // Who triggered it first
                    obj_turn_end.battle_location[obj_turn_end.battles] = name;
                    obj_turn_end.battle_pobject[obj_turn_end.battles] = instance_nearest(x, y, obj_p_fleet);

                    if (!instance_exists(obj_turn_end.battle_pobject[obj_turn_end.battles])) {
                        obj_turn_end.battles -= 1;
                        break;
                    }

                    if (i == 10) {
                        obj_controller.temp[1049] = string(name);
                        with (obj_temp2) {
                            instance_destroy();
                        }
                        with (obj_temp3) {
                            instance_destroy();
                        }
                        with (obj_en_fleet) {
                            if ((action == "") && (orbiting == obj_controller.temp[1049]) && (owner == 10)) {
                                if (string_count("warband", trade_goods) > 0) {
                                    instance_create(x, y, obj_temp2);
                                }
                                if (string_lower(trade_goods) == "chaos") {
                                    instance_create(x, y, obj_temp3);
                                }
                            }
                        }
                        if (instance_exists(obj_temp2)) {
                            obj_turn_end.battle_special[obj_turn_end.battles] = "BLOOD";
                            with (obj_temp2) {
                                instance_destroy();
                            }
                        }
                        if (instance_exists(obj_temp3)) {
                            obj_turn_end.battle_special[obj_turn_end.battles] = "CHAOS";
                            with (obj_temp2) {
                                instance_destroy();
                            }
                        }
                    }
                    break;
                }
            }
        }
    }

    instance_activate_object(obj_p_fleet);
    instance_activate_object(obj_en_fleet);

    var chaos_meeting = 0;

    for (var run = 1; run <= planets; run++) {
        var forces_list = [];
        var force_count = 0;
        if (p_player[run] > 0 && struct_exists(obj_controller.location_viewer.garrison_log, name)) {
            forces_list = scr_count_forces(name, run, true, true);
            force_count = forces_list[0] + forces_list[1];
        }

        if (p_player[run] > 0 && force_count > 0) {
            if (p_player[run] > 0) {
                if (has_problem_planet(run, "meeting")) {
                    chaos_meeting = run;
                } else if (has_problem_planet(run, "meeting_trap")) {
                    chaos_meeting = run + 0.1;
                }
            }
            if (has_problem_planet(run, "spyrer")) {
                if (p_player[run] > 20) {
                    var tixt = "The Spyrer on " + planet_numeral_name(run) + " seems to have vanished, presumably gone into hiding.";
                    scr_popup("Spyrer Rampage", tixt, "spyrer", "");
                } else if (p_player[run] <= 20) {
                    obj_turn_end.battles += 1;
                    obj_turn_end.battle[obj_turn_end.battles] = 1;
                    obj_turn_end.battle_world[obj_turn_end.battles] = run;
                    obj_turn_end.battle_opponent[obj_turn_end.battles] = 30;
                    obj_turn_end.battle_location[obj_turn_end.battles] = name;
                    obj_turn_end.battle_object[obj_turn_end.battles] = id;
                    obj_turn_end.battle_special[obj_turn_end.battles] = "spyrer";
                }
            }

            if ((p_player[run] > 0) && has_problem_planet(run, "fallen")) {
                if (choose(true, false)) {
                    obj_turn_end.battles += 1;
                    obj_turn_end.battle[obj_turn_end.battles] = 1;
                    obj_turn_end.battle_world[obj_turn_end.battles] = run;
                    obj_turn_end.battle_opponent[obj_turn_end.battles] = 10;
                    obj_turn_end.battle_location[obj_turn_end.battles] = name;
                    obj_turn_end.battle_object[obj_turn_end.battles] = id;
                    if (choose(true, false)) {
                        obj_turn_end.battle_special[obj_turn_end.battles] = "fallen1";
                    } else {
                        obj_turn_end.battle_special[obj_turn_end.battles] = "fallen2";
                    }
                } else {
                    if (remove_planet_problem(run, "fallen")) {
                        var tixt = "Your marines have scoured " + planet_numeral_name(run) + " in search of the Fallen.  Despite their best efforts, and meticulous searching, none have been found.  It appears as though the information was faulty or out of date.";
                        scr_popup("Hunt the Fallen", tixt, "fallen", "");
                        scr_event_log("", $"Mission Successful: No Fallen located upon {planet_numeral_name(run)}");
                    }
                }
            }
        }
        if (p_player[run] > 0 && has_problem_planet(run, "necron")) {
            setup_necron_tomb_raid(run);
        }
        if ((p_player[run] > 0) && (force_count > 0)) {
            for (var force = 2; force < 14; force++) {
                battle_opponent = 0;
                var pause = false;

                switch (force) {
                    case 3: // mechanicus aren't quite in yet
                    case 4:
                    case 12:
                        continue;
                    case 2:
                        if (p_player[run] > 0 && p_owner[run] == eFACTION.PLAYER && p_guardsmen[run] > 0 && obj_controller.faction_status[2] == "War") {
                            battle_opponent = 2;
                        }
                        if (p_player[run] >= 10 && p_owner[run] != eFACTION.PLAYER && p_guardsmen[run] > 0 && obj_controller.faction_status[2] == "War") {
                            battle_opponent = 2;
                        }
                        break;
                    case 5:
                        if (p_player[run] > 0 && p_sisters[run] > 0 && obj_controller.faction_status[5] == "War") {
                            battle_opponent = 5;
                        }
                        break;
                    case 6:
                        if (p_player[run] > 0 && p_eldar[run] > 0 && obj_controller.faction_status[6] == "War") {
                            battle_opponent = 6;
                        }
                        break;
                    case 7:
                        if (p_guardsmen[run] + p_pdf[run] == 0 && p_player[run] > 0 && p_orks[run] > 0) {
                            battle_opponent = 7;
                        }
                        break;
                    case 8:
                        if (p_guardsmen[run] == 0 && p_player[run] > 0 && p_tau[run] > 0) {
                            battle_opponent = 8;
                        }
                        break;
                    case 9:
                        if (p_guardsmen[run] + p_pdf[run] == 0 && p_player[run] > 0 && p_tyranids[run] > 0) {
                            battle_opponent = 9;
                        }
                        break;
                    case 10:
                        pause = has_problem_planet(run, "meeting") || has_problem_planet(run, "meeting_trap");
                        if (p_guardsmen[run] + p_pdf[run] == 0 && p_player[run] > 0 && p_chaos[run] > 0 && !pause && obj_controller.faction_status[10] == "War") {
                            battle_opponent = 10;
                        }
                        break;
                    case 11:
                        pause = has_problem_planet(run, "meeting") || has_problem_planet(run, "meeting_trap");
                        if (p_guardsmen[run] + p_pdf[run] == 0 && p_player[run] > 0 && p_traitors[run] > 0 && !pause && obj_controller.faction_status[10] == "War") {
                            battle_opponent = 11;
                        }
                        break;
                    case 13:
                        if (p_guardsmen[run] + p_pdf[run] == 0 && p_player[run] > 0 && p_necrons[run] > 0) {
                            battle_opponent = 13;
                        }
                        break;
                }

                // other battle crap here
                if (battle_opponent > 0) {
                    obj_turn_end.battles += 1;
                    obj_turn_end.battle[obj_turn_end.battles] = 1;
                    obj_turn_end.battle_world[obj_turn_end.battles] = run;
                    obj_turn_end.battle_opponent[obj_turn_end.battles] = battle_opponent;
                    obj_turn_end.battle_location[obj_turn_end.battles] = name;
                    obj_turn_end.battle_object[obj_turn_end.battles] = id;
                }
            }
        }

        // Other planetary stuff
        if (array_length(p_feature[run])) {
            // Transforming billions pop number to a real number so the code can handle it
            // Otherwise, 3 and a half billions get translated as 3,50 instead of 3500000000

            //fortress monestary
            if (p_owner[run] == eFACTION.PLAYER) {
                var monestary = search_planet_features(p_feature[run], eP_FEATURES.MONASTERY);
                if (array_length(monestary) > 0) {
                    monestary = p_feature[run][monestary[0]];
                    var md = 225;
                    var ms = 300;
                    var ml = 32;
                    var build_rate = 4;
                    var build_rate2 = 6;
                    if (scr_has_adv("Siege Masters")) {
                        md = 300;
                        ms = 400;
                        ml = 48;
                        build_rate2 = 5;
                    }
                    if (scr_has_adv("Crafters")) {
                        build_rate = 3;
                        if (choose(0, 1) == 1) {
                            if (p_silo[run] < ms) {
                                p_silo[run] += 1;
                            }
                            if (p_defenses[run] < md) {
                                p_defenses[run] += 1;
                            }
                        }
                    }
                    if (p_silo[run] < ms) {
                        p_silo[run] += 1;
                    }
                    if (p_defenses[run] < md) {
                        p_defenses[run] += 1;
                    }

                    if (((obj_controller.turn / build_rate) == round(obj_controller.turn / build_rate)) && (p_lasers[run] > ml)) {
                        p_lasers[run] += 1;
                    }
                    if (((obj_controller.turn / build_rate2) == round(obj_controller.turn / build_rate2)) && (p_fortified[run] < 5)) {
                        p_fortified[run] += 1;
                    }
                    if (monestary.forge > 0) {
                        obj_controller.player_forge_data.player_forges += sqr(monestary.forge_data.size);
                        if (monestary.forge_data.vehicle_hanger) {
                            array_push(obj_controller.player_forge_data.vehicle_hanger, [name, run]);
                        }
                    }
                }
            }
        } // End p_feature!=""

        // Work on upgrades
        if (array_length(p_upgrades[run]) > 0) {
            for (var up = 0; up < array_length(p_upgrades[run]); up++) {
                var upgrade = p_upgrades[run][up];
                if (struct_exists(upgrade, "built")) {
                    var upgrade_type = upgrade.f_type;
                    if (upgrade.built == obj_controller.turn) {
                        var display_type = "No Available Feature";
                        if (upgrade_type == eP_FEATURES.ARSENAL) {
                            display_type = "Arsenal";
                            obj_controller.und_armouries++;
                        } else if (upgrade_type == eP_FEATURES.SECRET_BASE) {
                            display_type = "Lair";
                            obj_controller.und_lairs++;
                        } else if (upgrade_type == eP_FEATURES.GENE_VAULT) {
                            display_type = "Gene Vault";
                            obj_controller.und_gene_vaults++;
                        }
                        var tx = $"Hidden {display_type} on {name} {scr_roman(run)} has been completed.";
                        scr_alert("green", "owner", string(tx), x, y);
                        scr_event_log("", string(tx));
                    }
                    if (upgrade.built <= obj_controller.turn && upgrade_type == eP_FEATURES.SECRET_BASE) {
                        if (upgrade.forge > 0) {
                            obj_controller.player_forge_data.player_forges += sqr(upgrade.forge_data.size);
                            if (upgrade.forge_data.vehicle_hanger) {
                                array_push(obj_controller.player_forge_data.vehicle_hanger, [name, run]);
                            }
                        }
                    }
                }
            }
        }

        if (p_population[run] < 0) {
            p_population[run] = 0;
        }
    }

    if (chaos_meeting > 0) {
        // Run through forces and determine what all is there
        var _meeting = instance_create(0, 0, obj_temp_meeting);

        var otm = 0;
        var master_present = false;
        for (var co = 0; co <= 10; co++) {
            for (var i = 1; i <= 200; i++) {
                var _unit = fetch_unit([co, i]);
                var _is_unit_real_and_here = _unit.role() != "" && _unit.location_string == name;
                var _is_this_a_chaos_meeting = _unit.planet_location == floor(chaos_meeting);
                var _unit_does_not_have_dreadnought_role = _unit.role() != obj_ini.role[100][6];
                var _unit_is_not_venerable = _unit.role() != "Venerable " + string(obj_ini.role[100][6]);
                var _unit_does_not_have_dreadnought_armour = string_count("Dread", obj_ini.armour[co][i]) == 0;
                var _is_chapter_master = _unit.role() == obj_ini.role[100][eROLE.CHAPTERMASTER];
                if (_is_unit_real_and_here && _is_this_a_chaos_meeting && _unit_does_not_have_dreadnought_role && _unit_is_not_venerable && (_unit_does_not_have_dreadnought_armour || _is_chapter_master)) {
                    _meeting.dudes += 1;
                    otm = _meeting.dudes;
                    _meeting.present[otm] = 1;
                    _meeting.co[otm] = co;
                    _meeting.ide[otm] = i;
                    if (_unit.role() == obj_ini.role[100][eROLE.CHAPTERMASTER]) {
                        master_present = true;
                    }
                }
            }
        }

        // title / text / image / speshul
        var popup_text = "A cloaked, ragged figure approaches your forces and hails you. ";
        if (master_present && (otm <= 21)) {
            var effect = "meeting_1t";
            if (chaos_meeting == floor(chaos_meeting)) {
                effect = "meeting_1";
            }
            scr_popup("Chaos Meeting", $"{popup_text}He is to bring you to meet with their master and you have few enough forces to be permitted.  What is thy will?", "chaos_messenger", effect);
        }
        if (master_present && (otm > 21)) {
            scr_popup("Chaos Meeting", $"{popup_text}He is to bring you to their master, but before the meeting proceeds, you must bring fewer forces.  Only yourself and up to two squads will be allowed in the presence of {obj_controller.faction_title[10]} {obj_controller.faction_leader[10]}.", "chaos_messenger", "meeting_2");
            instance_destroy(_meeting);
        }
        if (!master_present && (otm > 21)) {
            scr_popup("Chaos Meeting", $"{popup_text}The meeting was supposed to be with the Chaos Lord, and yourself, but you are not planet-side.  Land on the planet with up to two squads and the meeting will proceed.", "chaos_messenger", "meeting_3");
            instance_destroy(_meeting);
        }
    }

    for (var i = 1; i <= planets; i++) {
        var existing_problem = has_any_problem_planet(i);
        if (!existing_problem) {
            if (!irandom(50) && p_owner[i] == eFACTION.IMPERIUM) {
                if (p_owner[i] == eFACTION.IMPERIUM) {
                    scr_new_governor_mission(i);
                }
            }
        }
    }
}
