#macro DEBUG_TARGET_SELECTION false

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

function scr_clean(target_object, weapon_data) {
    // Converts enemy scr_shoot damage into player marine or vehicle casualties.
    //
    // Parameters:
    // target_object: The obj_pnunit instance taking casualties. Represents the player's rank being attacked.
    // target_type: Boolean-like value (1 for infantry, 0 for vehicles). Determines whether to process as infantry/dreadnoughts or vehicles.
    // hostile_shots: The number of shots fired at the target. Represents the total hits from the attacking unit.
    // hostile_damage: The amount of damage per shot. This value is reduced by armor or damage resistance before being applied.
    // hostile_weapon: The name of the weapon used in the attack. Certain weapons have special effects that modify damage behavior.
    // hostile_range: The range of the weapon. This may influence damage or other combat mechanics.

    try {
        with(target_object) {
            if (obj_ncombat.wall_destroyed == 1) {
                exit;
            }

            if (DEBUG_TARGET_SELECTION) {
                var _t_start = get_timer();
            }
            
            var armour_pierce = weapon_data.armour_pierce;
            var hostile_shots = weapon_data.shot_count;
            var hostile_damage = weapon_data.damage;
            var hostile_weapon = weapon_data.name;
            var hostile_range = weapon_data.attack_type;
            var target_type = weapon_data.target_type;
            var shooter_count = weapon_data.shooter_count;
            var hits = 0;
            var unit_type = "";
            var valid_vehicles = [];
            var valid_marines = [];
            var units_lost = 0;

            // Find valid infantry targets
            for (var m = 0; m < array_length(unit_struct); m++) {
                var unit = unit_struct[m];
                if (is_struct(unit) && unit.hp() > 0 && marine_dead[m] == 0) {
                    if (unit.IsSpecialist(SPECIALISTS_DREADNOUGHTS)) {
                        var _temp_struct = {
                            index: m,
                            type: "dread"
                        };
                        array_push(valid_vehicles, _temp_struct);
                    } else {
                        array_push(valid_marines, m);
                    }
                }
            }
            valid_marines = array_shuffle(valid_marines);

            // Find valid vehicle targets
            for (var v = 0; v < veh; v++) {
                if (veh_hp[v] > 0 && veh_dead[v] == 0) {
                    var _temp_struct = {
                        index: v,
                        type: "veh"
                    };
                    array_push(valid_vehicles, _temp_struct);
                }
            }
            valid_vehicles = array_shuffle(valid_vehicles);

            if (target_type == "arp" && array_empty(valid_vehicles)) {
                target_type = "att";
            } else if (target_type = "att" && array_empty(valid_marines)) {
                target_type = "arp";
            }

            for (var shot = 0; shot < hostile_shots; shot++) {
                // ### Vehicle Damage Processing ###
                if (target_type == "arp" && !array_empty(valid_vehicles)) {
                    // Apply damage for each hostile shot, until we run out of targets

                    hits++;

                    // Select a random vehicle from the valid list
                    var random_index = array_random_index(valid_vehicles);
                    var vehicle = valid_vehicles[random_index];
                    var vehicle_id = vehicle.index;
                    var type = vehicle.type;

                    if (type == "veh") {
                        unit_type = veh_type[vehicle_id];

                        // Apply damage
                        var _min_damage = enemy == 13 ? 1 : 0.25;
                        var _dice_sides = 200;
                        var _random_damage_mod = roll_dice(1, _dice_sides, "low") / _dice_sides;
                        var _armour_points = max(0, veh_ac[vehicle_id] - armour_pierce);
                        var _modified_damage = max(_min_damage, (hostile_damage * _random_damage_mod) - _armour_points);

                        veh_hp[vehicle_id] -= _modified_damage;

                        // Check if the vehicle is destroyed
                        if (veh_hp[vehicle_id] <= 0 && veh_dead[vehicle_id] == 0) {
                            veh_dead[vehicle_id] = 1;
                            units_lost++;
                            obj_ncombat.player_forces -= 1;

                            // Record loss
                            var existing_index = array_get_index(lost, veh_type[vehicle_id]);
                            if (existing_index != -1) {
                                lost_num[existing_index] += 1;
                            } else {
                                array_push(lost, veh_type[vehicle_id]);
                                array_push(lost_num, 1);
                            }

                            // Remove dead vehicles from further hits
                            array_delete(valid_vehicles, vehicle_id, 1);
                        }
                    } else {
                        var marine = unit_struct[vehicle_id];
                        unit_type = marine.role();

                        // Apply damage
                        var _min_damage = enemy == 13 ? 1 : 0.25;
                        var _dice_sides = 200;
                        var _random_damage_mod = roll_dice(1, _dice_sides, "low") / _dice_sides;
                        var _armour_points = max(0, marine_ac[marine_index] - armour_pierce);
                        var _modified_damage = (hostile_damage * _random_damage_mod) - _armour_points;

                        if (_modified_damage > 0) {
                            var damage_resistance = marine.damage_resistance() / 100;
                            if (marine_mshield[vehicle_id] > 0) {
                                damage_resistance += 0.1;
                            }
                            if (marine_fiery[vehicle_id] > 0) {
                                damage_resistance += 0.15;
                            }
                            if (marine_fshield[vehicle_id] > 0) {
                                damage_resistance += 0.08;
                            }
                            if (marine_quick[vehicle_id] > 0) {
                                damage_resistance += 0.2;
                            } // TODO: only if melee
                            if (marine_dome[vehicle_id] > 0) {
                                damage_resistance += 0.15;
                            }
                            if (marine_iron[vehicle_id] > 0) {
                                if (damage_resistance <= 0) {
                                    marine.add_or_sub_health(20);
                                } else {
                                    damage_resistance += marine_iron[vehicle_id] / 5;
                                }
                            }
                            _modified_damage = max(_min_damage, round(_modified_damage * (1 - damage_resistance)));
                        }
        
                        if (_modified_damage < 0 && hostile_weapon == "Fleshborer") {
                            _modified_damage = 1.5;
                        }

                        /* if (hostile_weapon == "Web Spinner") {
                            var webr = floor(random(100)) + 1;
                            var chunk = max(10, 62 - (marine_ac[vehicle_id] * 2));
                            _modified_damage = (webr <= chunk) ? 5000 : 0;
                        } */

                        marine.add_or_sub_health(-_modified_damage);

                        // Check if marine is dead
                        if (check_dead_marines(marine, vehicle_id)) {
                            // Remove dead infantry from further hits
                            array_delete(valid_vehicles, random_index, 1);
                            units_lost++;
                            if (array_empty(valid_vehicles)) {
                                target_type = "att";
                                continue;
                            }
                        }
                    }
                }

                // ### Marine + Dreadnought Processing ###
                if (target_type == "att" && !array_empty(valid_marines)) {
                    // Apply damage for each shot
                    hits++;

                    // Select a random marine from the valid list
                    var random_index = array_random_index(valid_marines);
                    var marine_index = valid_marines[random_index];
                    var marine = unit_struct[marine_index];
                    unit_type = marine.role();

                    // Apply damage
                    var _min_damage = enemy == 13 ? 1 : 0.25;
                    var _dice_sides = 200;
                    var _random_damage_mod = roll_dice(1, _dice_sides, "low") / _dice_sides;
                    var _armour_points = max(0, marine_ac[marine_index] - armour_pierce);
                    var _modified_damage = max(_min_damage, (hostile_damage * _random_damage_mod) - _armour_points);

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
                        _modified_damage = max(_min_damage, round(_modified_damage * (1 - damage_resistance)));
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
                        array_delete(valid_marines, random_index, 1);
                        units_lost++;
                        if (array_empty(valid_marines)) {
                            target_type = "arp";
                            continue;
                        }
                    }
                }

                // ### Cleanup ###
                // If the target_object got wiped out, move it off-screen
                if ((men + veh + dreads) <= 0) {
                    x = -5000;
                    instance_deactivate_object(id);
                    break;
                }
            }

            if (DEBUG_TARGET_SELECTION) {
                var _t_end = get_timer();
                var _elapsed_ms = (_t_end - _t_start) / 1000;
                show_debug_message($"⏱️ Clean Execution Time: {_elapsed_ms}ms");
    
                show_debug_message($"Hits: {hits}");
                show_debug_message($"Kills: {units_lost}");
            }

            // Flavour battle-log message
            if (DEBUG_TARGET_SELECTION) {
                var _t_start = get_timer();
            }
            scr_flavor2(units_lost, unit_type, hostile_range, hostile_weapon, shooter_count);
            if (DEBUG_TARGET_SELECTION) {
                var _t_end = get_timer();
                var _elapsed_ms = (_t_end - _t_start) / 1000;
                show_debug_message($"⏱️ Flavour Execution Time: {_elapsed_ms}ms");
            }
        }
    } catch (_exception) {
        handle_exception(_exception);
    }
}

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
