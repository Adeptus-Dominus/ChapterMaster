/// @function compress_enemy_array
/// @description Compresses column data arrays by removing gaps left by eliminated entities, processes only the first 20 indices
/// @param {id.Instance} _target_column - The column instance to clean up
/// @returns {undefined} No return value; modifies target column directly
function compress_enemy_array(_target_column) {
    if (!instance_exists(_target_column)) {
        return;
    }

    with (_target_column) {
        // Define all data arrays to be processed with their default values
        var _data_arrays = [
            {
                arr: dudes,
                def: "",
            },
            {
                arr: dudes_special,
                def: "",
            },
            {
                arr: dudes_num,
                def: 0,
            },
            {
                arr: dudes_ac,
                def: 0,
            },
            {
                arr: dudes_hp,
                def: 0,
            },
            {
                arr: dudes_vehicle,
                def: 0,
            },
            {
                arr: dudes_damage,
                def: 0,
            }
        ];

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
    with (_target_column) {
        if ((men + veh + medi == 0) && (owner != 1)) {
            instance_destroy();
        }
    }
}

/// @function check_dead_marines
/// @description Checks if the marine is dead and then runs various related code
/// @self Asset.GMObject.obj_pnunit
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

/// @self Asset.GMObject.obj_pnunit
/// @param {Asset.GMObject.obj_pnunit} target_object
function scr_clean(target_object, target_is_infantry, hostile_shots, hostile_damage, hostile_weapon, hostile_range, hostile_splash, weapon_index_position) {
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

            var damage_data = {
                "units_lost": 0,
                "unit_type": "",
                "hits": 0,
            };

            // ### Vehicle Damage Processing ###
            if (!target_is_infantry && veh > 0) {
                damage_vehicles(damage_data, hostile_shots, hostile_damage, weapon_index_position);
            }

            // ### Marine + Dreadnought Processing ###
            if (target_is_infantry && (men + dreads > 0)) {
                damage_infantry(damage_data, hostile_shots, hostile_damage, weapon_index_position);
            }

            if (damage_data.hits < hostile_shots) {
                // ### Vehicle Damage Processing ###
                if (target_is_infantry && veh > 0) {
                    damage_vehicles(damage_data, hostile_shots, hostile_damage, weapon_index_position);
                }

                // ### Marine + Dreadnought Processing ###
                if (!target_is_infantry && (men + dreads > 0)) {
                    damage_infantry(damage_data, hostile_shots, hostile_damage, weapon_index_position);
                }
            }

            scr_flavor2(damage_data.units_lost, damage_data.unit_type, hostile_range, hostile_weapon, damage_data.hits, hostile_splash);

            // ### Cleanup ###
            // If the target_object got wiped out, move it off-screen
            if ((men + veh + dreads) <= 0) {
                x = -5000;
                instance_deactivate_object(id);
            }
        }
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

/// @self Asset.GMObject.obj_pnunit
function damage_infantry(_damage_data, _shots, _damage, _weapon_index) {
    var _armour_pierce = apa[_weapon_index];
    var _armour_mod = 0;
    switch (_armour_pierce) {
        case 4:
            _armour_mod = 0;
            break;
        case 3:
            _armour_mod = 1.5;
            break;
        case 2:
            _armour_mod = 2;
            break;
        case 1:
            _armour_mod = 3;
            break;
        default:
            _armour_mod = 3;
            break;
    }

    // Find valid infantry targets
    var valid_marines = [];
    for (var m = 0, l = array_length(unit_struct); m < l; m++) {
        var unit = unit_struct[m];
        if (is_struct(unit) && unit.hp() > 0 && marine_dead[m] == 0) {
            array_push(valid_marines, m);
        }
    }

    // Bulk man-block with no individual model structs (Guard auxilia): take losses
    // straight off the men count, the way the enemy's ranks do, since there are no
    // marine structs for the normal path to kill. Scoped to guard blocks only.
    if (guard == 1 && array_length(valid_marines) == 0 && men > 0) {
        // Identical to the enemy Guardsman casualty math in scr_shoot. Reduce each
        // shot by armour, pool the survivable damage across all shots, convert it to
        // dead men at dudes_hp each, and cap the kills at the shot count. With
        // dudes_ac 40 the rank shrugs off low-AP fire (basic Choppaz, Shootas) the
        // same way the enemy Guardsmen you fight do, and only armour-piercing weapons
        // cut them down in numbers. Armour is what gives them their staying power, so
        // there is no separate cohesion cap here.
        var _g_ac = (array_length(dudes_ac) > 1) ? dudes_ac[1] : 40;
        var _g_hp = (array_length(dudes_hp) > 1) ? dudes_hp[1] : 5;
        if (_g_hp <= 0) {
            _g_hp = 5;
        }
        var _g_after = _damage - (_g_ac * _armour_mod);
        if (_g_after < 0) {
            _g_after = 0;
        }
        var _g_pool = _shots * _g_after;
        var _g_total = min(floor(_g_pool / _g_hp), _shots);
        _g_total = min(_g_total, men);
        if (_g_total < 0) {
            _g_total = 0;
        }
        // Cover / dispersion save (see GUARD_COVER_SAVE in macros.gml). A flat fraction
        // of would-be casualties are treated as missed, standing in for spacing, terrain
        // and a small profile. Applied after armour so it also blunts armour-piercing
        // weapons (choppaz, power klawz) that ignore Flak entirely.
        if (_g_total > 0 && GUARD_COVER_SAVE > 0) {
            _g_total = floor(_g_total * (1 - GUARD_COVER_SAVE));
        }
        _damage_data.hits += _shots;
        // Always name the block, even on a zero-casualty hit, or the enemy attack
        // flavor prints "fire at ." with a blank target whenever armour soaks the shot.
        _damage_data.unit_type = "Imperial Guardsman";
        if (_g_total > 0) {
            men -= _g_total;
            if (array_length(dudes_num) > 1) {
                dudes_num[1] = max(0, dudes_num[1] - _g_total);
            }
            // Report through the same lost/lost_num summary the marines use.
            _damage_data.units_lost += _g_total;
            _damage_data.unit_type = "Imperial Guardsman";
            var _g_idx = -1;
            for (var gk = 0, gl = array_length(lost); gk < gl; gk++) {
                if (lost[gk] == "Imperial Guardsman") {
                    _g_idx = gk;
                    break;
                }
            }
            if (_g_idx >= 0) {
                lost_num[_g_idx] += _g_total;
            } else {
                array_push(lost, "Imperial Guardsman");
                array_push(lost_num, _g_total);
            }
        }
        return;
    }

    // Apply damage for each shot
    for (var shot = 0; shot < _shots; shot++) {
        if (array_length(valid_marines) == 0) {
            break; // No valid targets left
        }

        _damage_data.hits++;

        // Select a random marine from the valid list
        var marine_index = array_random_element(valid_marines);
        var marine = unit_struct[marine_index];
        _damage_data.unit_type = marine.role();

        // Apply damage
        var _shot_luck = roll_dice_chapter(1, 100, "low");
        var _modified_damage = 0;
        var _marine_armour = marine_ac[marine_index] * _armour_mod;
        if (_shot_luck == 1) {
            _modified_damage = _damage - (2 * _marine_armour);
        } else if (_shot_luck == 100) {
            _modified_damage = _damage;
        } else {
            _modified_damage = _damage - _marine_armour;
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
            valid_marines = array_delete_value(valid_marines, marine_index);
            _damage_data.units_lost++;
        }
    }

    return;
}

/// @self Asset.GMObject.obj_pnunit
function damage_vehicles(_damage_data, _shots, _damage, _weapon_index) {
    var _armour_pierce = apa[_weapon_index];
    var _armour_mod = 0;
    switch (_armour_pierce) {
        case 4:
            _armour_mod = 0;
            break;
        case 3:
            _armour_mod = 2;
            break;
        case 2:
            _armour_mod = 4;
            break;
        case 1:
            _armour_mod = 6;
            break;
        default:
            _armour_mod = 6;
            break;
    }

    var veh_index = -1;

    // Find valid vehicle targets
    var valid_vehicles = [];
    for (var v = 0, l = array_length(veh_hp); v < l; v++) {
        if (veh_hp[v] > 0 && veh_dead[v] == 0) {
            array_push(valid_vehicles, v);
        }
    }

    // Apply damage for each hostile shot, until we run out of targets
    for (var shot = 0; shot < _shots; shot++) {
        if (array_length(valid_vehicles) == 0) {
            break;
        }

        _damage_data.hits++;

        // Select a random vehicle from the valid list
        veh_index = array_random_element(valid_vehicles);

        // Apply damage
        var _modified_damage = _damage - veh_ac[veh_index] * _armour_mod;
        if (_modified_damage < 0) {
            _modified_damage = 0;
        }
        if (enemy == 13 && _modified_damage < 1) {
            _modified_damage = 1;
        }
        veh_hp[veh_index] -= _modified_damage;
        _damage_data.unit_type = veh_type[veh_index];

        // Check if the vehicle is destroyed
        if (veh_hp[veh_index] <= 0 && veh_dead[veh_index] == 0) {
            veh_dead[veh_index] = 1;
            _damage_data.units_lost++;
            obj_ncombat.player_forces -= 1;

            // Record loss
            var existing_index = array_get_index(lost, veh_type[veh_index]);
            if (existing_index != -1) {
                lost_num[existing_index] += 1;
            } else {
                array_push(lost, veh_type[veh_index]);
                array_push(lost_num, 1);
            }

            // Remove dead vehicles from further hits
            valid_vehicles = array_delete_value(valid_vehicles, veh_index);
        }
    }

    return;
}
