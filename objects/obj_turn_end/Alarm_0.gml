try {
    instance_activate_object(obj_star);
    combating = 0;

    for (var i = 49; i >= 0; i--) {
        if ((battles <= i) && (i >= 2)) {
            if ((battle[i] != 0) && (battle[i - 1] != 0) && (battle_world[i] == 0) && (battle_world[i - 1] > 0)) {
                var tem1 = battle[i - 1];
                var tem2 = battle_location[i - 1];
                var tem3 = battle_world[i - 1];
                var tem4 = battle_opponent[i - 1];
                var tem5 = battle_object[i - 1];
                var tem6 = battle_pobject[i - 1];
                var tem7 = battle_special[i - 1];

                battle[i - 1] = battle[i];
                battle_location[i - 1] = battle_location[i];
                battle_world[i - 1] = battle_world[i];
                battle_opponent[i - 1] = battle_opponent[i];
                battle_pobject[i - 1] = battle_pobject[i];
                battle_special[i - 1] = battle_special[i];

                battle[i] = tem1;
                battle_location[i] = tem2;
                battle_world[i] = tem3;
                battle_opponent[i] = tem4;
                battle_object[i] = tem5;
                battle_pobject[i] = tem6;
                battle_special[i] = tem7;
            }
        }
    }

    // Probably want something right here to organize the battle just in case
    // Space battles first
    // Ground battles after

    if ((battles > 0) && (current_battle <= battles)) {
        var battle_star = find_star_by_name(battle_location[current_battle]);

        if (battle_star != noone) {
            // trying to find the star
            obj_controller.x = battle_star.x;
            obj_controller.y = battle_star.y;
            show = current_battle;

            if (battle_world[current_battle] == 0) {
                strin[1] = string(round(battle_pobject[current_battle].capital_number));
                strin[2] = string(round(battle_pobject[current_battle].frigate_number));
                strin[3] = string(round(battle_pobject[current_battle].escort_number));
                // pull health values here
                strin[4] = string(round(battle_pobject[current_battle].capital_health));
                strin[5] = string(round(battle_pobject[current_battle].frigate_health));
                strin[6] = string(round(battle_pobject[current_battle].escort_health));

                // pull enemy ships here

                for (var e = 2; e <= 11; e++) {
                    if (e == 11) {
                        e = 13;
                    }
                    if (battle_star.present_fleet[e] > 0) {
                        obj_controller.temp[1070] = battle_star.id;
                        obj_controller.temp[1071] = e;
                        obj_controller.temp[1072] = 0;
                        obj_controller.temp[1073] = 0;
                        obj_controller.temp[1074] = 0;

                        with (obj_en_fleet) {
                            if ((orbiting == obj_controller.temp[1070]) && (owner == obj_controller.temp[1071])) {
                                obj_controller.temp[1072] += round(capital_number);
                                obj_controller.temp[1073] += round(frigate_number);
                                obj_controller.temp[1074] += round(escort_number);
                            }
                        }

                        var _fleet_index = 0;
                        if (obj_controller.faction_status[e] != "War") {
                            for (var i = 1; i <= 10; i++) {
                                if (allied_fleet[i] == 0) {
                                    _fleet_index = i;
                                    break;
                                }
                            }
                            allied_fleet[_fleet_index] = e;
                            acap[_fleet_index] = obj_controller.temp[1072];
                            afri[_fleet_index] = obj_controller.temp[1073];
                            aesc[_fleet_index] = obj_controller.temp[1074];
                        }
                        if ((obj_controller.faction_status[e] == "War") || (e == 9) || (e == 13)) {
                            for (var i = 1; i <= 10; i++) {
                                if (enemy_fleet[i] == 0) {
                                    _fleet_index = i;
                                    break;
                                }
                            }
                            enemy_fleet[_fleet_index] = e;
                            ecap[_fleet_index] = obj_controller.temp[1072];
                            efri[_fleet_index] = obj_controller.temp[1073];
                            eesc[_fleet_index] = obj_controller.temp[1074];
                        }
                    }
                }
            }

            if (battle_world[current_battle] >= 1) {
                scr_count_forces(string(battle_location[current_battle]), battle_world[current_battle], true);

                strin[1] = info_mahreens;
                strin[2] = info_vehicles;

                if (info_mahreens + info_vehicles == 0) {
                    if (battles > current_battle) {
                        alarm[4] = 1;
                    }
                    if (battles == current_battle) {
                        alarm[1] = 1;
                    }
                }

                strin[3] = "";

                var tempy = battle_object[current_battle].p_owner[battle_world[current_battle]];

                if ((tempy == 1) || (tempy == 2) || (tempy == 3)) {
                    var array_string = [
                        "",
                        "Minimally",
                        "Lightly",
                        "Moderately",
                        "Highly",
                        "Extremely",
                        "Maximally",
                    ];
                    var battle_fortification = battle_object[current_battle].p_fortified[battle_world[current_battle]];
                    strin[3] = array_string[clamp(battle_fortification, 1, 6)];
                }

                tempy = 0;
                if (battle_opponent[current_battle] == 7) {
                    tempy = battle_object[current_battle].p_orks[battle_world[current_battle]];
                }
                if (battle_opponent[current_battle] == 8) {
                    tempy = battle_object[current_battle].p_tau[battle_world[current_battle]];
                }
                if (battle_opponent[current_battle] == 9) {
                    tempy = battle_object[current_battle].p_tyranids[battle_world[current_battle]];
                }
                if (battle_opponent[current_battle] == 10) {
                    tempy = battle_object[current_battle].p_chaos[battle_world[current_battle]];
                }
                if (battle_opponent[current_battle] == 11) {
                    tempy = battle_object[current_battle].p_traitors[battle_world[current_battle]];
                }
                if (battle_opponent[current_battle] == 13) {
                    tempy = battle_object[current_battle].p_necrons[battle_world[current_battle]];
                }

                if (tempy == 1) {
                    strin[4] = "Minimal Forces";
                }
                if (tempy == 2) {
                    strin[4] = "Sparse Forces";
                }
                if (tempy == 3) {
                    strin[4] = "Moderate Forces";
                }
                if (tempy == 4) {
                    strin[4] = "Numerous Forces";
                }
                if (tempy == 5) {
                    strin[4] = "Very Numerous";
                }
                if (tempy == 6) {
                    strin[4] = "Overwhelming";
                }
                obj_controller.cooldown = 9999;
            }

            // if (obj_controller.zoomed == 1) {
            //     with (obj_controller) {
            //         scr_zoom();
            //     }
            // }
        }
        instance_activate_object(obj_star);
    }

    instance_activate_object(obj_star);

    if ((battle[1] == 0) || (current_battle > battles)) {
        //                         This is temporary for the sake of testing
        if (battle[1] == 0) {
            obj_controller.x = first_x;
            obj_controller.y = first_y;
        }
        alarm[1] = 1;
    }
} catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
}
