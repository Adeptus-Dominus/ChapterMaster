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
            var _melee_accuracy_mod = 1;
            var _ranged_accuracy_mod = 1;
            switch (obj_ncombat.enemy) {
                case eFACTION.Ork:
                    _melee_accuracy_mod = 0.7;
                    _ranged_accuracy_mod = 0.4;
                    break;
                case eFACTION.Tau:
                    _melee_accuracy_mod = 0.5;
                    _ranged_accuracy_mod = 0.6;
                    break;
                case eFACTION.Tyranids:
                    _melee_accuracy_mod = 0.6;
                    _ranged_accuracy_mod = 0.6;
                    break;
            }

            var _accuracy_mod = _weapon_stack.range >= 2 ? _ranged_accuracy_mod : _melee_accuracy_mod;
            _shot_count *= _accuracy_mod;

            if (_target_type == eTARGET_TYPE.FORTIFICATION) {
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
            _target_index = scr_target(_target_object, _target_type);
            if (_target_index == -1) {
                _target_index = scr_target(_target_object);
                if (_target_index == -1) {
                    // if (DEBUG_PLAYER_TARGET_SELECTION) {
                    //     show_debug_message($"{_weapon_name} found no valid targets in the enemy column to attack!");
                    // }
                    log_error($"{_weapon_name} found no valid targets in the enemy column to attack!");
                    exit;
                }
            }

            // if (DEBUG_PLAYER_TARGET_SELECTION) {
            //     show_debug_message($"{_weapon_name} is attacking {_target_object.dudes[_target_index]}");
            // }

            if (_weapon_name == "Missile Silo") {
                obj_ncombat.player_silos -= min(obj_ncombat.player_silos, 30);
            }

            // Normal shooting
            var _min_damage = 0.25;
            var _dice_sides = 200;
            var _random_damage_mod = roll_dice(1, _dice_sides, "low") / 100;
            var _armour_points = max(0, _target_object.dudes_ac[_target_index] - _weapon_piercing);
            _weapon_attack = (_weapon_attack * _random_damage_mod) - _armour_points;
            _weapon_attack = max(_min_damage, _weapon_attack * _target_object.dudes_dr[_target_index]);
            var _total_attack = _weapon_attack * _shot_count;

            var _dudes_num = _target_object.dudes_num[_target_index];
            var _unit_hp = _target_object.dudes_hp[_target_index];
            var _casualties = min(_shot_count, _dudes_num, floor(_total_attack / _unit_hp));

            // if (_casualties > 0) {
            //     if (DEBUG_PLAYER_TARGET_SELECTION) {
            //         show_debug_message($"{_weapon_name} attacked {_target_object.dudes[_target_index]} and destroyed {_casualties}!");
            //     }
            // } else {
            //     if (DEBUG_PLAYER_TARGET_SELECTION) {
            //         show_debug_message($"{_weapon_name} attacked {_target_object.dudes[_target_index]} but dealt no damage!");
            //     }
            // }

            scr_flavor(_weapon_stack, _target_object, _target_index, _casualties);

            if (_casualties > 0) {
                _target_object.dudes_num[_target_index] -= _casualties;
                obj_ncombat.enemy_forces -= _casualties;
                compress_enemy_array(_target_object);
                destroy_empty_column(_target_object);
            }
        }
    } catch (_exception) {
        handle_exception(_exception);
    }
}
