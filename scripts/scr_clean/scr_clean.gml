/// @function compress_enemy_array
/// @description Compresses column data arrays by removing gaps left by eliminated entities, processes only the first 20 indices
/// @param {id.Instance} _target_column - The column instance to clean up
/// @returns {undefined} No return value; modifies target column directly
function compress_enemy_array(_target_column) {
    if (!instance_exists(_target_column)) {
        return;
    }

    with(_target_column) {
        // Define all data arrays to be processed with their default values
        var _data_arrays = [{
            arr: dudes,
            def: ""
        }, {
            arr: dudes_special,
            def: ""
        }, {
            arr: dudes_num,
            def: 0
        }, {
            arr: dudes_ac,
            def: 0
        }, {
            arr: dudes_hp,
            def: 0
        }, {
            arr: dudes_vehicle,
            def: 0
        }, {
            arr: dudes_damage,
            def: 0
        }];

        // Track which slots are empty
        var _empty_slots = array_create(20, false);
        for (var i = 1; i < array_length(_empty_slots); i++) {
            if (dudes_num[i] <= 0) {
                _empty_slots[i] = true;
            }
        }

        // Compress arrays using a pointer that doesn't restart from beginning
        var pos = 1;
        while (pos < array_length(_empty_slots) - 1) {
            if (_empty_slots[pos] && !_empty_slots[pos + 1]) {
                // Move data from position pos+1 to pos
                for (var j = 0; j < array_length(_data_arrays); j++) {
                    _data_arrays[j].arr[pos] = _data_arrays[j].arr[pos + 1];
                    _data_arrays[j].arr[pos + 1] = _data_arrays[j].def;
                }
                _empty_slots[pos] = false;
                _empty_slots[pos + 1] = true;

                // Only backtrack if we're not at the beginning
                if (pos > 1) {
                    pos--; // Check this position again in case we need to shift more
                }
            } else {
                pos++; // Move to next position
            }
        }
    }
}

/// @function destroy_empty_column
/// @description Destroys the column if it's empty
/// @param {id.Instance} _target_column - The column instance to clean up
function destroy_empty_column(_target_column) {
    // Destroy empty non-player columns to conserve memory and processing
    with(_target_column) {
        if ((men + veh + medi == 0) && (owner != 1)) {
            instance_destroy();
        }
    }
}

/// @function check_dead_marines
/// @description Checks if the marine is dead and then runs various related code
/// @mixin
function check_dead_marines(unit_struct, unit_index) {
    var unit_lost = false;

    if (unit_struct.hp() <= 0 && marine_dead[unit_index] < 1) {
        marine_dead[unit_index] = 1;
        unit_lost = true;
        obj_ncombat.player_forces -= 1;

        // Record loss
        var existing_index = array_get_index(lost, marine_type[unit_index]);
        if (existing_index != -1) {
            lost_num[existing_index] += 1;
        } else {
            array_push(lost, marine_type[unit_index]);
            array_push(lost_num, 1);
        }

        // Check red thirst threadhold
        if (obj_ncombat.red_thirst == 1 && marine_type[unit_index] != "Death Company" && ((obj_ncombat.player_forces / obj_ncombat.player_max) < 0.9)) {
            obj_ncombat.red_thirst = 2;
        }

        if (unit_struct.IsSpecialist(SPECIALISTS_DREADNOUGHTS)) {
            dreads -= 1;
        } else {
            men -= 1;
        }
    }

    return unit_lost;
}

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
        with(target_object) {
            if (obj_ncombat.wall_destroyed == 1) {
                exit;
            }

            var vehicle_hits = 0;
            var man_hits = 0;
            var total_hits = hostile_shots;
            var unit_type = "";

            // ### Vehicle Damage Processing ###
            if (!target_is_infantry && veh > 0) {
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
                    var _modified_damage = hostile_damage - veh_ac[you];
                    if (_modified_damage < 0) {
                        _modified_damage = 0.25;
                    }
                    if (enemy == 13 && _modified_damage < 1) {
                        _modified_damage = 1;
                    }
                    veh_hp[you] -= _modified_damage;
                    unit_type = veh_type[you];
                    vehicle_hits++;

                    var units_lost = 0;
                    // Check if the vehicle is destroyed
                    if (veh_hp[you] <= 0 && veh_dead[you] == 0) {
                        veh_dead[you] = 1;
                        units_lost++;
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
                    // Flavor messages
                    scr_flavor2(units_lost, unit_type, hostile_range, hostile_weapon, vehicle_hits, hostile_splash);
                }
            }

            // ### Marine + Dreadnought Processing ###
            if (target_is_infantry && (men + dreads > 0)) {
                man_hits = total_hits - vehicle_hits;

                // Find valid infantry targets
                var valid_marines = [];
                for (var m = 0; m < array_length(unit_struct); m++) {
                    var unit = unit_struct[m];
                    if (is_struct(unit) && unit.hp() > 0 && marine_dead[m] == 0) {
                        array_push(valid_marines, m);
                    }
                }

                // Apply damage for each shot
                for (var shot = 0; shot < man_hits; shot++) {
                    if (array_length(valid_marines) == 0) {
                        break; // No valid targets left
                    }

                    // Select a random marine from the valid list
                    var random_index = array_random_index(valid_marines);
                    var marine_index = valid_marines[random_index];
                    var marine = unit_struct[marine_index];
                    unit_type = marine.role();
                    var units_lost = 0;

                    // Apply damage
                    var _shot_luck = roll_dice_chapter(1, 100, "low");
                    var _modified_damage = 0;
                    if (_shot_luck <= 5) {
                        _modified_damage = hostile_damage - (2 * marine_ac[marine_index]);
                    } else if (_shot_luck > 95) {
                        _modified_damage = hostile_damage;
                    } else {
                        _modified_damage = hostile_damage - marine_ac[marine_index];
                    }

                    if (_modified_damage > 0) {
                        var damage_resistance = marine.damage_resistance() / 100;
                        if (marine_mshield[marine_index] > 0) {
                            damage_resistance += 0.1;
                        }
                        if (marine_fiery[marine_index] > 0) {
                            damage_resistance += 0.15;
                        }
                        if (marine_fshield[marine_index] > 0) {
                            damage_resistance += 0.08;
                        }
                        if (marine_quick[marine_index] > 0) {
                            damage_resistance += 0.2;
                        } // TODO: only if melee
                        if (marine_dome[marine_index] > 0) {
                            damage_resistance += 0.15;
                        }
                        if (marine_iron[marine_index] > 0) {
                            if (damage_resistance <= 0) {
                                marine.add_or_sub_health(20);
                            } else {
                                damage_resistance += marine_iron[marine_index] / 5;
                            }
                        }
                        _modified_damage = round(_modified_damage * (1 - damage_resistance));
                    }
                    if (_modified_damage < 0 && hostile_weapon == "Fleshborer") {
                        _modified_damage = 1.5;
                    }
                    /* if (hostile_weapon == "Web Spinner") {
                        var webr = floor(random(100)) + 1;
                        var chunk = max(10, 62 - (marine_ac[marine_index] * 2));
                        _modified_damage = (webr <= chunk) ? 5000 : 0;
                    } */
                    marine.add_or_sub_health(-_modified_damage);

                    // Check if marine is dead
                    if (check_dead_marines(marine, marine_index)) {
                        // Remove dead infantry from further hits
                        array_delete(valid_marines, marine_index, 1);
                        units_lost++;
                    }

                    // Flavor messages
                    scr_flavor2(units_lost, unit_type, hostile_range, hostile_weapon, man_hits, hostile_splash);
                }
            }

            // ### Cleanup ###
            // If the target_object got wiped out, move it off-screen
            if ((men + veh + dreads) <= 0) {
                x = -5000;
                instance_deactivate_object(id);
            }
        }
    } catch (_exception) {
        handle_exception(_exception);
    }
}
