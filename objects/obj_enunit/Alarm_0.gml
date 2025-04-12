#macro DEBUG_COLUMN_PRIORITY_ENEMY false

//* This alarm is responsible for the enemy target column selection;

if (!instance_exists(obj_pnunit)) {
    exit;
}

var _block_direction = flank ? get_leftmost : get_rightmost;

enemy = _block_direction();
if (enemy == "none") {
    exit;
}

var target_unit_index = 0;

//In melee check
engaged = collision_point(x - 10, y, obj_pnunit, 0, 1) || collision_point(x + 10, y, obj_pnunit, 0, 1);
// show_debug_message($"enemy is in melee {engaged}")

if (DEBUG_COLUMN_PRIORITY_ENEMY) {
    var _t_start1 = get_timer();
}

if (!engaged) {
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

        if (!target_block_is_valid(enemy, obj_pnunit)) {
            log_error($"Invalid player block was found by a ranged enemy!");
            enemy = _block_direction();
            if (!target_block_is_valid(enemy, obj_pnunit)) {
                log_error($"Two invalid player blocks were found by a ranged enemy! Exiting!");
                exit;
            }
        }

        var dist = get_block_distance(enemy);
        target_unit_index = 0;

        if (range[i] >= dist) {
            if (DEBUG_COLUMN_PRIORITY_ENEMY) {
                show_debug_message($"{wep[i]} IS SHOOTING!");
            }

            var _target_type = apa[i] > 10 ? "arp" : "att";
            var _weapon_type = "ranged";
            var _target_priority_queue = ds_priority_create();

            // Alpha strike override
            if (obj_ncombat.alpha_strike > 0) {
                obj_ncombat.alpha_strike -= 0.5;
                with (obj_pnunit) {
                    for (var u = 0; u < array_length(unit_struct); u++) {
                        if (marine_type[u] == "Chapter Master") {
                            enemy = id;
                            target_unit_index = u;
                        }
                    }
                }
            }

            if (DEBUG_COLUMN_PRIORITY_ENEMY) {
                var _t_start = get_timer();
            }

            // Scan potential targets
            var _check_targets = [];
            with (obj_pnunit) {
                if (!target_block_is_valid(self, obj_pnunit)) {
                    continue;
                }
                array_push(_check_targets, self.id);
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

                if (DEBUG_COLUMN_PRIORITY_ENEMY) {
                    show_debug_message($"Priority: {priority}\n Type: +{_type_bonus}\n Size: +{_size_bonus}\n Doomstack: -{_doomstack_malus}\n Distance: +{_distance_bonus}\n");
                }
                ds_priority_add(_target_priority_queue, enemy_block, priority);
            }

            // Add fort as fallback target
            var fort = instance_nearest(x, y, obj_nfort);
            if (fort != noone && !flank) {
                var d = get_block_distance(fort);
                if (d <= range[i]) {
                    var fort_priority = 9000;
                    ds_priority_add(_target_priority_queue, fort, fort_priority);
                }
            }

            if (DEBUG_COLUMN_PRIORITY_ENEMY) {
                var _t_end = get_timer();
                var _elapsed_ms = (_t_end - _t_start) / 1000;
                show_debug_message($"⏱️ Execution Time: {_elapsed_ms}ms");
            }

            // Shoot highest-priority target
            if (!ds_priority_empty(_target_priority_queue)) {
                var best_target = ds_priority_delete_max(_target_priority_queue);
                var is_fort = best_target.object_index == obj_nfort;
                var _shoot_type = is_fort ? "wall" : _weapon_type;
                var unit_index = is_fort ? 1 : target_unit_index;

                scr_shoot(i, best_target, unit_index, _target_type, _shoot_type);
            } else {
                log_error($"{wep[i]} didn't find a valid target! This shouldn't happen!");
                if (DEBUG_COLUMN_PRIORITY_ENEMY) {
                    show_debug_message($"We didn't find a valid target! Weapon: {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}");
                }
            }

            ds_priority_destroy(_target_priority_queue);
        } else {
            if (DEBUG_COLUMN_PRIORITY_ENEMY) {
                show_debug_message($"I can't shoot, my range is too small! Weapon: {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}; Range: {range[i]}");
            }
            continue;
        }
    }
}

if (DEBUG_COLUMN_PRIORITY_ENEMY) {
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

        if (!target_block_is_valid(enemy, obj_pnunit)) {
            log_error($"Invalid player block was found by a melee enemy!");
            exit;
        }
        
        if (DEBUG_COLUMN_PRIORITY_ENEMY) {
            show_debug_message($"{wep[i]} IS IN MELEE!");
        }

        if (instance_exists(obj_nfort) && (!flank)) {
            enemy = instance_nearest(x, y, obj_nfort);
            scr_shoot(i, enemy, 0, "arp", "wall");
            continue;
        }

        var _attack_type = apa[i] > 10 ? "arp" : "att";
        scr_shoot(i, enemy, 0, _attack_type, "melee");
    }
}

//! Here was some stuff that depended on image_index here, that got deleted, because I couldn't figure out why it exists; 
