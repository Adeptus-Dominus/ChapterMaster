#macro DEBUG_COLUMN_PRIORITY_ENEMY false

//* This script is responsible for the target_block target column selection; previosly alarm_0;
/// @mixin
function enunit_target_and_shoot() {
    if (!instance_exists(obj_pnunit)) {
        exit;
    }

    var _block_direction = flank ? get_leftmost : get_rightmost;

    target_block = _block_direction();
    if (target_block == "none") {
        exit;
    }

    var _target_unit_index = 0;
    var _alpha_strike = get_alpha_strike_target();
    if (_alpha_strike != -1) {
        target_block = _alpha_strike[0];
        _target_unit_index = _alpha_strike[1];
    }

    // show_debug_message($"target_block is in melee {engaged}")

    if (!engaged()) {
        if (DEBUG_COMBAT_PERFORMANCE) {
            var _t_start1 = get_timer();
        }

        // Shooting
        var _ranged_weapons = array_concat(get_valid_weapon_stacks(weapon_stacks_normal, 2, 999), get_valid_weapon_stacks_unique(weapon_stacks_unique, 2, 999), get_valid_weapon_stacks(weapon_stacks_vehicle, 2, 999));
        for (var i = 0, _ranged_len = array_length(_ranged_weapons); i < _ranged_len; i++) {
            var _weapon_stack = _ranged_weapons[i];

            if (!pnunit_is_valid(target_block)) {
                log_error($"Invalid player block was found by a ranged target_block!");
                target_block = _block_direction();
                if (!pnunit_is_valid(target_block)) {
                    log_error($"Two invalid player blocks were found by a ranged target_block! Exiting!");
                    exit;
                }
            }

            var dist = get_block_distance(target_block);
            if (_weapon_stack.range >= dist) {
                var _target_priority_queue = ds_priority_create();

                if (DEBUG_COMBAT_PERFORMANCE) {
                    var _t_start = get_timer();
                }

                // Scan potential targets
                var _targets = [];
                with (obj_pnunit) {
                    if (pnunit_is_valid(self)) {
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

                if (DEBUG_COMBAT_PERFORMANCE) {
                    var _t_end = get_timer();
                    var _elapsed_ms = (_t_end - _t_start) / 1000;
                    show_debug_message($"⏱️ Execution Time: {_elapsed_ms}ms");
                }

                // Shoot highest-priority target
                if (!ds_priority_empty(_target_priority_queue)) {
                    var _best_target = ds_priority_delete_max(_target_priority_queue);

                    var _is_fort = _best_target.object_index == obj_nfort;
                    if (_is_fort) {
                        _target_unit_index = 1;
                        _weapon_stack.target_type = eTARGET_TYPE.Fortification;
                    }

                    if (DEBUG_COLUMN_PRIORITY_ENEMY) {
                        show_debug_message($"{_weapon_stack.weapon_name} IS SHOOTING!");
                    }

                    scr_shoot(_weapon_stack, _best_target, _target_unit_index);
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
        if (DEBUG_COMBAT_PERFORMANCE) {
            var _t_end1 = get_timer();
            var _elapsed_ms1 = (_t_end1 - _t_start1) / 1000;
            show_debug_message($"⏱️ Enemy Ranged Alarm Execution Time: {_elapsed_ms1}ms");
        }
    } else {
        if (DEBUG_COMBAT_PERFORMANCE) {
            var _t_start1 = get_timer();
        }

        // Melee
        var _melee_weapons = array_concat(get_valid_weapon_stacks(weapon_stacks_normal, 1, 2), get_valid_weapon_stacks_unique(weapon_stacks_unique, 1, 2), get_valid_weapon_stacks(weapon_stacks_vehicle, 1, 999));
        for (var i = 0, _wep_len = array_length(_melee_weapons); i < _wep_len; i++) {
            var _weapon_stack = _melee_weapons[i];

            if (!pnunit_is_valid(target_block)) {
                log_error($"Invalid player block was found by a melee target_block!");
                exit;
            }

            if (DEBUG_COLUMN_PRIORITY_ENEMY) {
                show_debug_message($"{_weapon_stack.weapon_name} IS IN MELEE!");
            }

            if (instance_exists(obj_nfort) && (!flank)) {
                target_block = instance_nearest(x, y, obj_nfort);
                _target_unit_index = 1;
                _weapon_stack.target_type = eTARGET_TYPE.Fortification;
            }

            scr_shoot(_weapon_stack, target_block, _target_unit_index);
        }

        if (DEBUG_COMBAT_PERFORMANCE) {
            var _t_end1 = get_timer();
            var _elapsed_ms1 = (_t_end1 - _t_start1) / 1000;
            show_debug_message($"⏱️ Enemy Melee Alarm Execution Time: {_elapsed_ms1}ms");
        }
    }
    //! Here was some stuff that depended on image_index here, that got deleted, because I couldn't figure out why it exists;
}

// Previosly alarm_1
/// @mixin
function enunit_enemy_profiles_init() {
    weapon_stacks_normal = {};
    weapon_stacks_vehicle = {};
    weapon_stacks_unique = {};
}
