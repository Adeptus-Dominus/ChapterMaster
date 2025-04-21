#macro DEBUG_WEAPON_RELOADING false
#macro DEBUG_PLAYER_TARGET_SELECTION false

/// @mixin
function scr_shoot(_weapon_stack, _target_object, _target_index) {
    try {
        // _target_object: Target object
        // _target_index: Target dudes
        // _target_type: "att" or "arp" or "highest"
        // melee_or_ranged: melee or ranged

        // This massive clusterfuck of a script uses the newly determined weapon and target data to attack and assign damage

        if (!instance_exists(_target_object)) {
            exit;
        }

        if (obj_ncombat.wall_destroyed == 1) {
            exit;
        }

        if (!is_struct(_weapon_stack)) {
            exit;
        }

        var _weapon_shot_count = _weapon_stack.shot_count
        var _weapon_attack = _weapon_stack.attack;
        var _weapon_piercing = _weapon_stack.piercing;
        var _weapon_name = _weapon_stack.weapon_name;
        var _shooter = _weapon_stack.owners;
        var _shooter_count = _weapon_stack.weapon_count;
        var _shot_count = _shooter_count * _weapon_shot_count;
        var _target_type = _weapon_stack.target_type;

        if (_shooter_count <= 0 || _weapon_attack <= 0) {
            exit;
        }

        // if (DEBUG_WEAPON_RELOADING) {
        //     show_debug_message($"Weapon Name: {_weapon_name}\n Max Ammo: {_weapon_stack.ammo_max}\n Current Ammo: {_weapon_stack.ammo_current}\n Reload Time: {_weapon_stack.ammo_reload}\n Current Reload: {_weapon_stack.ammo_current}");
        // }

        if (_weapon_stack.ammo_max != -1) {
            if (_weapon_stack.ammo_current == 0 && _weapon_stack.ammo_reload != -1) {
                if (_weapon_stack.ammo_current == -1) {
                    // if (DEBUG_WEAPON_RELOADING) {
                    //     show_debug_message($"{_weapon_name} is reloading! Will finish in {_weapon_stack.ammo_reload} turns!");
                    // }
                    _weapon_stack.ammo_current = _weapon_stack.ammo_reload;
                    _weapon_stack.ammo_current--;
                    continue;
                } else if (_weapon_stack.ammo_current == 0) {
                    // if (DEBUG_WEAPON_RELOADING) {
                    //     show_debug_message($"{_weapon_name} reloaded! Setting ammo to {_weapon_stack.ammo_max}!");
                    // }
                    _weapon_stack.ammo_current = _weapon_stack.ammo_max;
                    _weapon_stack.ammo_current = -1;
                } else {
                    // if (DEBUG_WEAPON_RELOADING) {
                    //     show_debug_message($"{_weapon_name} is still reloading! {_weapon_stack.ammo_current} turns left!");
                    // }
                    _weapon_stack.ammo_current--;
                    continue;
                }
            }

            if (_weapon_stack.ammo_current > 0) {
                _weapon_stack.ammo_current--;
            }
        }

        //* Enemy shooting
        if (owner == 2) {
            if (_target_type == eTARGET_TYPE.Fortification) {
                var _wall_weapon_damage = max(1, round(_weapon_attack - _target_object.ac[1])) * _shooter_count * max(1, _weapon_shot_count / 4);
                _target_object.hp[1] -= _wall_weapon_damage;
        
                obj_nfort.hostile_weapons = _weapon_name;
                obj_nfort.hostile_shots = _shooter_count;
                obj_nfort.hostile_weapon_damage = _wall_weapon_damage;
        
                scr_flavor2((_target_object.hp[1] <= 0), _weapon_stack);
            } else {
                _target_object.hostile_shooters = (_shooter == "Assorted") ? 999 : 1;
                scr_clean(_target_object, _weapon_stack);
            }
        }

        //* Player shooting
        if (owner == eFACTION.Player) {
            var _target_stack = target_unit_stack(_target_object, _target_type);
            if (_target_stack == noone) {
                _target_stack = target_unit_stack(_target_object);
                if (_target_stack == noone) {
                    // if (DEBUG_PLAYER_TARGET_SELECTION) {
                    //     show_debug_message($"{_weapon_name} found no valid targets in the enemy column to attack!");
                    // }
                    log_error($"{_weapon_name} found no valid targets in the enemy column to attack!");
                    exit;
                }
            }

            // if (DEBUG_PLAYER_TARGET_SELECTION) {
            //     show_debug_message($"{_weapon_name} is attacking {_target_object.dudes[_target_stack]}");
            // }

            if (_weapon_name == "Missile Silo") {
                obj_ncombat.player_silos -= min(obj_ncombat.player_silos, 30);
            }

            if (DEBUG_COMBAT_PERFORMANCE) {
                var _t_start_player_scr_shoot = get_timer();
            }
            
            // Normal shooting
            var _min_damage = 0.25;
            var _dice_sides = 50;
            var _random_damage_mod = roll_dice(4, _dice_sides, "low") / 100;
            var _armour_points = max(0, _target_stack.armour - _weapon_piercing);
            var _modified_weapon_attack = (_weapon_attack * _random_damage_mod) - _armour_points;
            _modified_weapon_attack = max(_min_damage, _modified_weapon_attack * _target_stack.resistance);
            var _total_attack = _modified_weapon_attack * _shot_count;

            var _unit_hp = _target_stack.health;
            var _remaining_count = _target_stack.unit_count;

            // Estimate casualties
            var _casualties = min(floor(_total_attack / _unit_hp), _remaining_count);
            _target_stack.unit_count -= _casualties;
            obj_ncombat.enemy_forces -= _casualties;
            var _leftover_damage = _total_attack - (_casualties * _unit_hp);

            // Apply leftover damage to current unit
            _target_stack.health_current -= _leftover_damage;
            if (_target_stack.health_current <= 0) {
                if (_target_stack.unit_count > 1) {
                    _target_stack.health_current = _target_stack.health;
                } else {
                    _target_stack.health_current = 0;
                }
                _target_stack.unit_count--;
                obj_ncombat.enemy_forces--;
                _casualties++;
            }

            _target_object.column_size -= _target_stack.unit_size * _casualties;

            if (_target_stack.unit_count <= 0) {
                struct_remove(_target_object.unit_stacks, _target_stack.unit_name);
            }
            
            if (DEBUG_COMBAT_PERFORMANCE) {
                var _t_end_player_scr_shoot = get_timer();
                var _elapsed_ms_player_scr_shoot = (_t_end_player_scr_shoot - _t_start_player_scr_shoot) / 1000;
                show_debug_message($"⏱️ Execution Time player_scr_shoot: {_elapsed_ms_player_scr_shoot}ms");
            }

            scr_flavor(_weapon_stack, _target_object, _target_stack, _casualties);

            // if (_casualties > 0) {
            //     compress_enemy_array(_target_object);
            //     destroy_empty_column(_target_object);
            // }
        }
    } catch (_exception) {
        handle_exception(_exception);
    }
}
