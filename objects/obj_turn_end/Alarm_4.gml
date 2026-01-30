var battle_o;
battle_o = 0;
current_battle += 1;
combating = 0;

instance_activate_object(obj_star);

if ((battles > 0) && (current_battle <= battles)) {
    var ii = 0, good = 0;
    var battle_star = star_by_name(battle_location[current_battle]);
    obj_controller.temp[1060] = battle_location[current_battle];

    if (battle_star != "none") {
        obj_controller.x = battle_star.x;
        obj_controller.y = battle_star.y;
        show = current_battle;

        if (battle_world[current_battle] == -50) {
            strin[1] = string(battle_pobject[current_battle].capital_number);
            strin[2] = string(battle_pobject[current_battle].frigate_number);
            strin[3] = string(battle_pobject[current_battle].escort_number);
            // pull health values here
            strin[4] = string(battle_pobject[current_battle].capital_health);
            strin[5] = string(battle_pobject[current_battle].frigate_health);
            strin[6] = string(battle_pobject[current_battle].escort_health);

            // Here
            strin[7] = string(battle_object[current_battle].capital_number);
            strin[8] = string(battle_object[current_battle].frigate_number);
            strin[9] = string(battle_object[current_battle].escort_number);
            // pull health values here
            strin[10] = "100";
            strin[11] = "100";
            strin[12] = "100";
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

            var tempy;
            tempy = 0;
            tempy = battle_object[current_battle].p_owner[battle_world[current_battle]];

            if ((tempy == 1) || (tempy == 2) || (tempy == 3)) {
                if (battle_object[current_battle].p_fortified[battle_world[current_battle]] == 1) {
                    strin[3] = "Minimally";
                }
                if (battle_object[current_battle].p_fortified[battle_world[current_battle]] == 2) {
                    strin[3] = "Lightly";
                }
                if (battle_object[current_battle].p_fortified[battle_world[current_battle]] == 3) {
                    strin[3] = "Moderately";
                }
                if (battle_object[current_battle].p_fortified[battle_world[current_battle]] == 4) {
                    strin[3] = "Highly";
                }
                if (battle_object[current_battle].p_fortified[battle_world[current_battle]] == 5) {
                    strin[3] = "Extremely";
                }
                if (battle_object[current_battle].p_fortified[battle_world[current_battle]] == 6) {
                    strin[3] = "Maximally";
                }
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
                tempy = battle_object[current_battle].p_traitors[battle_world[current_battle]];
            }
            if (battle_opponent[current_battle] == 30) {
                tempy = 1;
                strin[4] = "Master Spyrer";
            }

            if (battle_opponent[current_battle] <= 20) {
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
            }
        }

        if (obj_controller.zoomed == 1) {
            with (obj_controller) {
                scr_zoom();
            }
        }
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
