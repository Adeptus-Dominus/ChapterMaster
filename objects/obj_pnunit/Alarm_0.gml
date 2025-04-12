#macro DEBUG_COLUMN_PRIORITY_PLAYER true

// Useful functions:
// scr_target
// get_rightmost
// move_unit_block
// gear_weapon_data
// scr_shoot

try {
    if (!instance_exists(obj_enunit)) {
        exit;
    }

    enemy = instance_nearest(0, y, obj_enunit);

    if (obj_ncombat.dropping || (!obj_ncombat.defending && obj_ncombat.formation_set != 2)) {
        move_unit_block("east");
    }

    engaged = collision_point(x - 10, y, obj_enunit, 0, 1) || collision_point(x + 10, y, obj_enunit, 0, 1);

    if (DEBUG_COLUMN_PRIORITY_PLAYER) {
        var _t_start1 = get_timer();
    }

    if (!engaged) {
        for (var i = 0; i < array_length(unit_struct); i++) {
            if (marine_dead[i] == 0 && marine_casting[i] == true) {
                var caster_id = i;
                scr_powers(caster_id);
            }
        }

        // Shooting
        for (var i = 0; i < array_length(wep); i++) {
            if (wep[i] == "" || wep_num[i] == 0) {
                continue;
            }
    
            if (range[i] == 1) {
                // show_debug_message($"A melee or no ammo weapon was found! Weapon: {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}; Range: {range[i]}; Ammo: {ammo[i]}");
                continue;
            }
    
            if (range[i] == 0) {
                log_error($"{wep[i]} has broken range! This shouldn't happen! Range: {range[i]}; Ammo: {ammo[i]}; Owner: {wep_owner[i]}");
                // show_debug_message($"A broken weapon was found! i:{i}; Weapon: {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}; Range: {range[i]}; Ammo: {ammo[i]}");
                continue;
            }
    
            if (!target_block_is_valid(enemy, obj_enunit)) {
                enemy = instance_nearest(0, y, obj_enunit);
                if (!target_block_is_valid(enemy, obj_enunit)) {
                    exit;
                }
            }
    
            var dist = get_block_distance(enemy);
    
            if (range[i] >= dist) {
                var _target_type = apa[i] > 8 ? "arp" : "att";
                var _weapon_type = "ranged";
                var _target_priority_queue = ds_priority_create();
    
                if (DEBUG_COLUMN_PRIORITY_PLAYER) {
                    var _t_start = get_timer();
                }
    
                // Scan potential targets
                var _check_targets = [];
                with (obj_enunit) {
                    if (!target_block_is_valid(self, obj_enunit)) {
                        continue;
                    }
                    array_push(_check_targets, self.id);
                }
    
                if (DEBUG_COLUMN_PRIORITY_PLAYER) {
                    show_debug_message($"{wep[i]} IS HERE!");
                }
    
                for (var t = 0; t < array_length(_check_targets); t++) {
                    var enemy_block = _check_targets[t];
    
                    var _distance = get_block_distance(enemy_block);
                    if (_distance > range[i]) {
                        continue;
                    }
    
                    // Distance weight (closer = higher priority)
                    var _distance_bonus = (range[i] - _distance - 1) * 20;
    
                    // Column size influence (bigger columns = higher threat?)
                    var _doomstack_malus = wep_num[i] / enemy_block.column_size;
    
                    // Column size influence (bigger columns = higher threat?)
                    var _size_bonus = enemy_block.column_size / 10;
    
                    // Target type match bonus
                    var _type_bonus = 0;
                    if (_target_type == "arp") {
                        _type_bonus = 20 * (block_type_size(enemy_block, "armour") / enemy_block.column_size);
                    } else if (_target_type == "att") {
                        _type_bonus = 20 * (block_type_size(enemy_block, "men") / enemy_block.column_size);
                    }
    
                    var priority = 0;
                    priority += _type_bonus;
                    priority += _size_bonus;
                    priority -= _doomstack_malus;
                    priority += _distance_bonus;
                    priority *= random_range(0.5, 1.5);
    
                    if (DEBUG_COLUMN_PRIORITY_PLAYER) {
                        show_debug_message($"Priority: {priority}\n Type: +{_type_bonus}\n Size: +{_size_bonus}\n Doomstack: -{_doomstack_malus}\n Distance: +{_distance_bonus}\n");
                    }
                    ds_priority_add(_target_priority_queue, enemy_block, priority);
                }
        
                if (DEBUG_COLUMN_PRIORITY_PLAYER) {
                    var _t_end = get_timer();
                    var _elapsed_ms = (_t_end - _t_start) / 1000;
                    show_debug_message($"⏱️ Execution Time: {_elapsed_ms}ms");
                }
    
                // Shoot highest-priority target
                if (!ds_priority_empty(_target_priority_queue)) {
                    var best_target = ds_priority_delete_max(_target_priority_queue);
                    var unit_index = 0;
    
                    scr_shoot(i, best_target, unit_index, _target_type, _weapon_type);
                } else {
                    log_error($"{wep[i]} didn't find a valid target! This shouldn't happen!");
                    if (DEBUG_COLUMN_PRIORITY_PLAYER) {
                        show_debug_message($"We didn't find a valid target! Weapon: {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}");
                    }
                }
    
                ds_priority_destroy(_target_priority_queue);
            } else {
                if (DEBUG_COLUMN_PRIORITY_PLAYER) {
                    show_debug_message($"I can't shoot, my range is too small! Weapon: {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}; Range: {range[i]}");
                }
                continue;
            }
        }
    }
    
    if (DEBUG_COLUMN_PRIORITY_PLAYER) {
        var _t_end1 = get_timer();
        var _elapsed_ms1 = (_t_end1 - _t_start1) / 1000;
        show_debug_message($"⏱️ Ranged Alarm Execution Time: {_elapsed_ms1}ms");
    }
    
    //TODO: The melee code was not refactored;
    if (engaged) {
        // Melee
        for (var i = 0; i < array_length(wep); i++) {
            if (wep[i] == "" || wep_num[i] == 0) {
                continue;
            }
    
            if (range[i] >= 2) {
                // show_debug_message($"A melee or no ammo weapon was found! Weapon: {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}; Range: {range[i]}; Ammo: {ammo[i]}");
                continue;
            }
    
            if (range[i] == 0) {
                log_error($"{wep[i]} has broken range! This shouldn't happen! Range: {range[i]}; Ammo: {ammo[i]}; Owner: {wep_owner[i]}");
                // show_debug_message($"A broken weapon was found! i:{i}; Weapon: {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}; Range: {range[i]}; Ammo: {ammo[i]}");
                continue;
            }
    
            if (!target_block_is_valid(enemy, obj_enunit)) {
                exit;
            }
    
            var _attack_type = apa[i] > 8 ? "arp" : "att";
            scr_shoot(i, enemy, 0, _attack_type, "melee");
        }
    }
    
    instance_activate_object(obj_enunit);
} catch (_exception) {
    handle_exception(_exception);
}
