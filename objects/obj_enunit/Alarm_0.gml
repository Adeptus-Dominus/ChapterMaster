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

var _target_unit_index = 0;
var _alpha_strike = get_alpha_strike_target();
if (_alpha_strike != -1) {
    enemy = _alpha_strike[0];
    _target_unit_index = _alpha_strike[1];
}

//In melee check
engaged = collision_point(x - 10, y, obj_pnunit, 0, 1) || collision_point(x + 10, y, obj_pnunit, 0, 1);
// show_debug_message($"enemy is in melee {engaged}")

if (!engaged) {
    if (DEBUG_COLUMN_PRIORITY_ENEMY) {
        var _t_start1 = get_timer();
    }

    // Shooting
    var _ranged_weapons = get_valid_weapon_stacks(weapon_stacks_normal, 2, 999);
    for (var i = 0, _ranged_len = array_length(_ranged_weapons); i < _ranged_len; i++) {
        var _weapon_stack = _ranged_weapons[i];

        if (!target_block_is_valid(enemy, obj_pnunit)) {
            log_error($"Invalid player block was found by a ranged enemy!");
            enemy = _block_direction();
            if (!target_block_is_valid(enemy, obj_pnunit)) {
                log_error($"Two invalid player blocks were found by a ranged enemy! Exiting!");
                exit;
            }
        }

        var dist = get_block_distance(enemy);
        _target_unit_index = get_alpha_strike_target();

        if (_weapon_stack.range >= dist) {
            if (DEBUG_COLUMN_PRIORITY_ENEMY) {
                show_debug_message($"{_weapon_stack.weapon_name} IS SHOOTING!");
            }

            var _target_priority_queue = ds_priority_create();

            if (DEBUG_COLUMN_PRIORITY_ENEMY) {
                var _t_start = get_timer();
            }

            // Scan potential targets
            var _targets = [];
            with (obj_pnunit) {
                if (target_block_is_valid(self, obj_pnunit)) {
                    array_push(_targets, self.id);
                }
            }

            for (var t = 0; t < array_length(_targets); t++) {
                var _block = _targets[t];
                var _distance = get_block_distance(_block);

                if (_distance <= _weapon_stack.range) {
                    var _priority = get_target_priority(_weapon_stack, _block);
                    ds_priority_add(_target_priority_queue, _block, _priority);
                }
            }

            // Add fort as fallback target
            var fort = instance_nearest(x, y, obj_nfort);
            if (fort != noone && !flank) {
                var d = get_block_distance(fort);
                if (d <= _weapon_stack.range) {
                    ds_priority_add(_target_priority_queue, fort, 999);
                }
            }

            if (DEBUG_COLUMN_PRIORITY_ENEMY) {
                var _t_end = get_timer();
                var _elapsed_ms = (_t_end - _t_start) / 1000;
                show_debug_message($"⏱️ Execution Time: {_elapsed_ms}ms");
            }

            // Shoot highest-priority target
            if (!ds_priority_empty(_target_priority_queue)) {
                var _best_target = ds_priority_delete_max(_target_priority_queue);
                var _is_fort = _best_target.object_index == obj_nfort;
                var _unit_index = _is_fort ? 1 : _target_unit_index;

                scr_shoot(_weapon_stack, _best_target, _unit_index);
            } else {
                log_error($"{_weapon_stack.weapon_name} didn't find a valid target! This shouldn't happen!");
            }
            ds_priority_destroy(_target_priority_queue);
        } else {
            if (DEBUG_COLUMN_PRIORITY_ENEMY) {
                show_debug_message($"I can't shoot, my range is too small! Weapon: {_weapon_stack.weapon_name};");
            }
            continue;
        }
    }
    if (DEBUG_COLUMN_PRIORITY_ENEMY) {
        var _t_end1 = get_timer();
        var _elapsed_ms1 = (_t_end1 - _t_start1) / 1000;
        show_debug_message($"⏱️ Enemy Ranged Alarm Execution Time: {_elapsed_ms1}ms");
    }
} else {
    if (DEBUG_COLUMN_PRIORITY_ENEMY) {
        var _t_start1 = get_timer();
    }

    // Melee
    var _melee_weapons = get_valid_weapon_stacks(weapon_stacks_normal, 1, 2);
    for (var i = 0, _wep_len = array_length(_melee_weapons); i < _wep_len; i++) {
        var _weapon_stack = _melee_weapons[i];

        if (!target_block_is_valid(enemy, obj_pnunit)) {
            log_error($"Invalid player block was found by a melee enemy!");
            exit;
        }
        
        if (DEBUG_COLUMN_PRIORITY_ENEMY) {
            show_debug_message($"{_weapon_stack.weapon_name} IS IN MELEE!");
        }

        if (instance_exists(obj_nfort) && (!flank)) {
            enemy = instance_nearest(x, y, obj_nfort);
            scr_shoot(_weapon_stack, enemy, 0);
            continue;
        }

        scr_shoot(_weapon_stack, enemy, 0);
    }

    if (DEBUG_COLUMN_PRIORITY_ENEMY) {
        var _t_end1 = get_timer();
        var _elapsed_ms1 = (_t_end1 - _t_start1) / 1000;
        show_debug_message($"⏱️ Enemy Melee Alarm Execution Time: {_elapsed_ms1}ms");
    }
}

//! Here was some stuff that depended on image_index here, that got deleted, because I couldn't figure out why it exists; 
