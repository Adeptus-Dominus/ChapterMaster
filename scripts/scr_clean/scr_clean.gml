/// @function compress_enemy_array
/// @description Compresses column data arrays by removing gaps left by eliminated entities, processes only the first 20 indices
/// @param {id.Instance} _target_column - The column instance to clean up
/// @returns {undefined} No return value; modifies target column directly
function compress_enemy_array(_target_column) {
    if (!instance_exists(_target_column)) {
        return;
    }

    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.CLEANUP, $"compress_enemy_array column={obj_ncombat.combat_debugger.resolve_label(_target_column)}");

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
            },
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
    // Destroy empty non-player columns to conserve memory and processing.
    with (_target_column) {
        // Count living models straight from dudes_num. men/veh/medi are only refreshed on the enemy's
        // own alarm, so during the player's firing phase they're stale and would leave a wiped-out
        // formation standing - which then keeps getting fired at and blocks "held fire" reporting.
        var _alive = 0;
        for (var r = 1; r < array_length(dudes_num); r++) {
            // A rank chipped to 0 HP but still showing dudes_num is a dead "zombie" - don't count it.
            if (dudes_num[r] > 0 && dudes_hp[r] > 0) {
                _alive += dudes_num[r];
            }
        }
        if ((_alive == 0) && (owner != 1)) {
            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.CLEANUP, $"destroy_empty_column column={obj_ncombat.combat_debugger.resolve_label(_target_column)} destroyed");
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

/// @self Id.Instance.obj_pnunit
/// @param {Id.Instance.obj_pnunit} target_object
function scr_clean(target_object, target_is_infantry, hostile_shots, hostile_damage, hostile_weapon, hostile_range, hostile_splash, hostile_armour_pierce) {
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
        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.SHOOTING, $"scr_clean target={obj_ncombat.combat_debugger.resolve_label(target_object)} is_infantry={target_is_infantry} shots={hostile_shots} dmg={hostile_damage} weapon={hostile_weapon} range={hostile_range} splash={hostile_splash} ap={hostile_armour_pierce}");

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
                damage_vehicles(damage_data, hostile_shots, hostile_damage, hostile_armour_pierce);
            }

            // ### Marine + Dreadnought Processing ###
            if (target_is_infantry && (men + dreads > 0)) {
                damage_infantry(damage_data, hostile_shots, hostile_damage, hostile_armour_pierce);
            }

            if (damage_data.hits < hostile_shots) {
                // ### Vehicle Damage Processing ###
                if (target_is_infantry && veh > 0) {
                    damage_vehicles(damage_data, hostile_shots, hostile_damage, hostile_armour_pierce);
                }

                // ### Marine + Dreadnought Processing ###
                if (!target_is_infantry && (men + dreads > 0)) {
                    damage_infantry(damage_data, hostile_shots, hostile_damage, hostile_armour_pierce);
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
function damage_infantry(_damage_data, _shots, _damage, _hostile_armour_pierce) {
    var _armour_mod = 0;
    switch (_hostile_armour_pierce) {
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

    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.DAMAGE, $"damage_infantry valid_marines={array_length(valid_marines)} shots={_shots} dmg={_damage} ap={_hostile_armour_pierce}");

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

        var _hp_before = marine.hp();
        marine.add_or_sub_health(-_modified_damage);

        // Check if marine is dead
        if (check_dead_marines(marine, marine_index)) {
            // Remove dead infantry from further hits
            valid_marines = array_delete_value(valid_marines, marine_index);
            _damage_data.units_lost++;
            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.DAMAGE, $"damage_infantry marine[{marine_index}] ({_damage_data.unit_type}) KILLED: luck={_shot_luck} armour={_marine_armour} raw_dmg={_damage} mod_dmg={_modified_damage} dr={damage_resistance} hp_before={_hp_before}");
        }
    }

    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.DAMAGE, $"damage_infantry done: hits={_damage_data.hits} lost={_damage_data.units_lost}");

    return;
}

/// @self Asset.GMObject.obj_pnunit
function damage_vehicles(_damage_data, _shots, _damage, _hostile_armour_pierce) {
    var _armour_mod = 0;
    switch (_hostile_armour_pierce) {
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

    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.DAMAGE, $"damage_vehicles valid_vehicles={array_length(valid_vehicles)} shots={_shots} dmg={_damage} ap={_hostile_armour_pierce}");

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
        var _hp_before = veh_hp[veh_index];
        veh_hp[veh_index] -= _modified_damage;
        _damage_data.unit_type = veh_type[veh_index];

        // Check if the vehicle is destroyed
        if (veh_hp[veh_index] <= 0 && veh_dead[veh_index] == 0) {
            veh_dead[veh_index] = 1;
            _damage_data.units_lost++;
            obj_ncombat.player_forces -= 1;
            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.DAMAGE, $"damage_vehicles veh[{veh_index}] ({_damage_data.unit_type}) DESTROYED: armour={veh_ac[veh_index] * _armour_mod} raw_dmg={_damage} mod_dmg={_modified_damage} hp_before={_hp_before}");

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

    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.DAMAGE, $"damage_vehicles done: hits={_damage_data.hits} lost={_damage_data.units_lost}");

    return;
}
