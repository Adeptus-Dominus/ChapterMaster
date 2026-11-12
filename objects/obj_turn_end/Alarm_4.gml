current_battle += 1;
combating = 0;

instance_activate_object(obj_star);

if ((battles > 0) && (current_battle <= battles)) {
    var battle_star = find_star_by_name(battle_location[current_battle]);
    obj_controller.temp[1060] = battle_location[current_battle];

    if (battle_star != noone) {
        obj_controller.x = battle_star.x;
        obj_controller.y = battle_star.y;
        show = current_battle;

        if (battle_world[current_battle] == 0) {
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
                tempy = battle_object[current_battle].p_traitors[battle_world[current_battle]];
            }
            if (battle_opponent[current_battle] == 30) {
                tempy = 1;
                strin[4] = "Master Spyrer";
            }

            if (battle_opponent[current_battle] <= 20) {
                strin[4] = global.force_strength_descriptions[clamp(tempy, 1, 6)];
            }
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
