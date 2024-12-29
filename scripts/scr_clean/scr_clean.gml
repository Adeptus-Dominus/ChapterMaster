function scr_clean(target_object, target_is_infantry, hostile_shots, hostile_damage, hostile_weapon, hostile_range, hostile_splash) {
    // Converts enemy scr_shoot damage into player marine or vehicle casualties.
    //
    // Parameters:
    // target_object: The obj_pnunit instance taking casualties. Represents the player's rank being attacked.
    // target_is_infantry: Boolean-like value (1 for infantry, 0 for vehicles). Determines whether to process as infantry/dreadnoughts or vehicles.
    // hostile_shots: The number of shots fired at the target. Represents the total hits from the attacking unit.
    // hostile_damage: The amount of damage per shot. This value is reduced by armor or damage resistance before being applied.
    // hostile_weapon: The name of the weapon used in the attack. Certain weapons have special effects that modify damage behavior.
    // hostile_range: The range of the weapon. This may influence damage or other combat mechanics.
    // hostile_splash: The splash damage modifier. Indicates if the weapon affects multiple targets or has an area-of-effect component.

    try {
        with (target_object) {
            if (obj_ncombat.wall_destroyed == 1) {
                exit;
            }

            var vehicle_hits = 0;
            var man_hits = 0;
            var total_hits = hostile_shots;

            // ### Vehicle Damage Processing ###
            if (!target_is_infantry and veh > 0) {
                var units_lost = 0;
                var you = -1;

                // Find valid vehicle targets
                var valid_vehicles = [];
                for (var v = 0; v < veh; v++) {
                    if (veh_hp[v] > 0 && veh_dead[v] == 0) {
                        array_push(valid_vehicles, v);
                    }
                }

                // Apply damage for each hostile shot, until we run out of targets
                for (var shot = 0; shot < total_hits; shot++) {
                    if (array_length(valid_vehicles) == 0) {
                        break;
                    }

                    // Select a random vehicle from the valid list
                    var random_index = array_random_index(valid_vehicles);
                    you = random_index;

                    // Apply damage
                    var minus = hostile_damage - veh_ac[you];
                    if (minus < 0) {
                        minus = 0.25;
                    }
                    if (enemy == 13 && minus < 1) {
                        minus = 1;
                    }
                    veh_hp[you] -= minus;
                    vehicle_hits++;

                    // Check if the vehicle is destroyed
                    if (veh_hp[you] <= 0 && veh_dead[you] == 0) {
                        veh_dead[you] = 1;
                        units_lost += 1;
                        obj_ncombat.player_forces -= 1;

                        // Record loss
                        var existing_index = array_get_index(lost, veh_type[you]);
                        if (existing_index != -1) {
                            lost_num[existing_index] += 1;
                        } else {
                            array_push(lost, veh_type[you]);
                            array_push(lost_num, 1);
                        }

                        // Remove dead vehicles from further hits
                        array_delete(valid_vehicles, you, 1);
                    }
                }

                // Update flavor messages if required
                if (vehicle_hits > 0) {
                    scr_flavor2(units_lost, "", hostile_range, hostile_weapon, vehicle_hits, hostile_splash);
                }
            }

            // ### Marine + Dreadnought Processing ###
            if (target_is_infantry and (men + dreads > 0)) {
                man_hits = total_hits - vehicle_hits;
                var units_lost = 0;

                // Find valid infantry targets
                var valid_marines = [];
                for (var m = 0; m < array_length(unit_struct); m++) {
                    var unit = unit_struct[m];
                    if (is_struct(unit) &&
                        unit.hp() > 0 &&
                        marine_dead[m] == 0) {
                        array_push(valid_marines, m);
                    }
                }

                // Apply damage for each shot
                for (var shot = 0; shot < man_hits; shot++) {
                    if (array_length(valid_marines) == 0) break; // No valid targets left

                    // Select a random marine from the valid list
                    var random_index = array_random_index(valid_marines);
                    var marine_index = valid_marines[random_index];
                    var marine = unit_struct[marine_index];

                    // Apply damage
                    var minus = hostile_damage - (2 * marine_ac[marine_index]);
                    if (minus > 0) {
                        var damage_resistance = (marine.damage_resistance() / 100);
                        if (marine_mshield[marine_index] > 0) damage_resistance += 0.1;
                        if (marine_fiery[marine_index] > 0) damage_resistance += 0.15;
                        if (marine_fshield[marine_index] > 0) damage_resistance += 0.08;
                        if (marine_quick[marine_index] > 0) damage_resistance += 0.2; // TODO: only if melee
                        if (marine_dome[marine_index] > 0) damage_resistance += 0.15;
                        if (marine_iron[marine_index] > 0) {
                            if (damage_resistance <= 0) {
                                marine.add_or_sub_health(20);
                            } else {
                                damage_resistance += (marine_iron[marine_index] / 5);
                            }
                        }
                        minus = round(minus * (1 - damage_resistance));
                    }
                    if (minus < 0 && hostile_weapon == "Fleshborer") minus = 1.5;
                    /* if (hostile_weapon == "Web Spinner") {
                        var webr = floor(random(100)) + 1;
                        var chunk = max(10, 62 - (marine_ac[marine_index] * 2));
                        minus = (webr <= chunk) ? 5000 : 0;
                    } */
                    marine.add_or_sub_health(-minus);

                    // Check if marine is dead
                    if (marine.hp() <= 0 && marine_dead[marine_index] < 1) {
                        marine_dead[marine_index] = 1;
                        units_lost += 1;
                        obj_ncombat.player_forces -= 1;

                        // Record loss
                        var existing_index = array_get_index(lost, marine_type[marine_index]);
                        if (existing_index != -1) {
                            lost_num[existing_index] += 1;
                        } else {
                            array_push(lost, marine_type[marine_index]);
                            array_push(lost_num, 1);
                        }
                        
                        // Remove dead infantry from further hits
                        array_delete(valid_marines, marine_index, 1);

                        // Check red thirst threadhold
                        if (
                            obj_ncombat.red_thirst == 1 &&
                            marine_type[marine_index] != "Death Company" &&
                            ((obj_ncombat.player_forces / obj_ncombat.player_max) < 0.9)
                        ) {
                            obj_ncombat.red_thirst = 2;
                        }

                        if (marine.IsSpecialist("dreadnoughts")) {
                            dreads -= 1;
                        } else {
                            men -= 1;
                        }
                    }
                }

                // After processing, update messages if any hits occurred
                if (man_hits > 0) {
                    scr_flavor2(units_lost, "", hostile_range, hostile_weapon, man_hits, hostile_splash);
                }
            }

            // ### Cleanup ###
            // If the target_object got wiped out, move it off-screen
            if ((men + veh + dreads) <= 0) {
                x = -5000;
                instance_deactivate_object(id);
            }
        }
    } catch(_exception) {
        handle_exception(_exception);
    }
}
