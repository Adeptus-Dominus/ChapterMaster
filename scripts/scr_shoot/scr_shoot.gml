#macro DEBUG_WEAPON_RELOADING true
#macro DEBUG_PLAYER_TARGET_SELECTION true

/// @mixin
function scr_shoot(weapon_index_position, target_object, target_index, target_type, melee_or_ranged) {
    try {
        // weapon_index_position: Weapon number
        // target_object: Target object
        // target_index: Target dudes
        // target_type: "att" or "arp" or "highest"
        // melee_or_ranged: melee or ranged

        // This massive clusterfuck of a script uses the newly determined weapon and target data to attack and assign damage

        if (!instance_exists(target_object)) {
            exit;
        }

        if (obj_ncombat.wall_destroyed == 1) {
            exit;
        }

        if (weapon_index_position < 0) {
            exit;
        }

        for (var j = 1; j <= 100; j++) {
            obj_ncombat.dead_ene[j] = "";
            obj_ncombat.dead_ene_n[j] = 0;
        }
        obj_ncombat.dead_enemies = 0;

        var wi = weapon_index_position;
        var _weapon_max_kills = splash[wi];
        var _total_damage = att[wi];
        var _weapon_ap = apa[wi];
        var _weapon_name = wep[wi];
        var _shooter = wep_owner[wi];
        var _shooter_count = wep_num[wi];
        var _shot_count = _shooter_count * _weapon_max_kills;
        var _weapon_damage_type = target_type;
        var _weapon_damage_per_hit = _total_damage / _shooter_count;

        if (_shooter_count <= 0 || _total_damage <= 0) {
            exit;
        }

        if (DEBUG_WEAPON_RELOADING) {
            show_debug_message($"Weapon Name: {_weapon_name}\n Max Ammo: {ammo_max[wi]}\n Current Ammo: {ammo_current[wi]}\n Reload Time: {ammo_reload[wi]}\n Current Reload: {ammo_reload_current[wi]}");
        }

        if (ammo_max[wi] != -1) {
            if (ammo_current[wi] == 0 && ammo_reload[wi] != -1) {
                if (ammo_reload_current[wi] == -1) {
                    if (DEBUG_WEAPON_RELOADING) {
                        show_debug_message($"{_weapon_name} is reloading! Will finish in {ammo_reload[wi]} turns!");
                    }
                    ammo_reload_current[wi] = ammo_reload[wi];
                    ammo_reload_current[wi]--;
                    continue;
                } else if (ammo_reload_current[wi] == 0) {
                    if (DEBUG_WEAPON_RELOADING) {
                        show_debug_message($"{_weapon_name} reloaded! Setting ammo to {ammo_max[wi]}!");
                    }
                    ammo_current[wi] = ammo_max[wi];
                    ammo_reload_current[wi] = -1;
                } else {
                    if (DEBUG_WEAPON_RELOADING) {
                        show_debug_message($"{_weapon_name} is still reloading! {ammo_reload_current[wi]} turns left!");
                    }
                    ammo_reload_current[wi]--;
                    continue;
                }
            }

            if (ammo_current[wi] > 0) {
                ammo_current[wi]--;
            }
        }

        //* Enemy shooting
        if (owner == 2) {
            if (_weapon_name == "Web Spinner") {
                _weapon_damage_type = "status";
            } else if (_weapon_damage_type == "medi") {
                _weapon_damage_type = _weapon_ap > 6 ? "arp" : "att";
            }

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
            var _accuracy_mod = melee_or_ranged == "ranged" ? _ranged_accuracy_mod : _melee_accuracy_mod;
    
            _shot_count *= _accuracy_mod;

            var _weapon_data = {
                name: _weapon_name,
                damage: _weapon_damage_per_hit,
                armour_pierce: _weapon_ap,
                shot_count: _shot_count,
                shooter_count: _shooter_count,
                attack_type: melee_or_ranged,
                target_type: target_type
            }

            switch (_weapon_damage_type) {
                case "status":
                    target_object.hostile_shooters = (_shooter == "assorted") ? 999 : 1;
                    _weapon_data.damage = 0;
                    scr_clean(target_object, _weapon_data);
                    break;
                case "att":
                case "arp":
                case "dread":
                    if (melee_or_ranged == "wall") {
                        var _wall_weapon_damage = max(1, round(_weapon_damage_per_hit - target_object.ac[1])) * _shooter_count * max(1, _weapon_max_kills / 4);
                        target_object.hp[1] -= _wall_weapon_damage;
                
                        obj_nfort.hostile_weapons = _weapon_name;
                        obj_nfort.hostile_shots = _shooter_count;
                        obj_nfort.hostile_weapon_damage = _wall_weapon_damage;
                
                        scr_flavor2((target_object.hp[1] <= 0), "wall", melee_or_ranged, _weapon_name, _shooter_count);
                    } else {
                        target_object.hostile_shooters = (_shooter == "assorted") ? 999 : 1;

                        scr_clean(target_object, _weapon_data);
                    }
                    break;
            }
        }

        //* Player shooting
        if (owner == eFACTION.Player) {
            target_index = scr_target(target_object, _weapon_damage_type);
            if (target_index == -1) {
                if (DEBUG_PLAYER_TARGET_SELECTION) {
                    show_debug_message($"{_weapon_name} found no valid targets in the enemy column to attack!");
                }
                exit;
            }

            if (DEBUG_PLAYER_TARGET_SELECTION) {
                show_debug_message($"{_weapon_name} is attacking {target_object.dudes[target_index]}");
            }

            if (_weapon_name == "Missile Silo") {
                obj_ncombat.player_silos -= min(obj_ncombat.player_silos, 30);
            }

            // Normal shooting
            var _min_damage = 0.25;
            var _dice_sides = 200;
            var _random_damage_mod = roll_dice(1, _dice_sides, "low") / _dice_sides;
            var _armour_points = max(0, target_object.dudes_ac[target_index] - _weapon_ap);
            var _weapon_damage_per_hit = (_weapon_damage_per_hit * _random_damage_mod) - _armour_points;
            _weapon_damage_per_hit = max(_min_damage, _weapon_damage_per_hit * target_object.dudes_dr[target_index]);
            _total_damage = _weapon_damage_per_hit * _shooter_count;

            var _dudes_num = target_object.dudes_num[target_index];
            var _unit_hp = target_object.dudes_hp[target_index];
            var _casualties = min(_shot_count, _dudes_num, floor(_total_damage / _unit_hp));

            var _used_damage = _casualties * _unit_hp;
            var _leftover_damage = _total_damage - _used_damage;
            if (_leftover_damage > 0) {
                target_object.dudes_hp[target_index] -= _leftover_damage;
            }

            if (_casualties > 0) {
                if (DEBUG_PLAYER_TARGET_SELECTION) {
                    show_debug_message($"{_weapon_name} attacked {target_object.dudes[target_index]} and destroyed {_casualties}!");
                }

                var found = -1;
                var openz = -1;
                for (var i = 0, _dead_ene = array_length(obj_ncombat.dead_ene); i < _dead_ene; i++) {
                    if (obj_ncombat.dead_ene[i] == "") {
                        if (openz == -1) {
                            openz = i;
                        }
                    }
    
                    if (obj_ncombat.dead_ene[i] == target_object.dudes[target_index]) {
                        found = i;
                        break;
                    }
                }

                if (found != -1) {
                    obj_ncombat.dead_ene_n[found] += _casualties;
                } else if (openz != -1) {
                    obj_ncombat.dead_enemies += 1;
                    obj_ncombat.dead_ene[openz] = string(target_object.dudes[target_index]);
                    obj_ncombat.dead_ene_n[openz] = _casualties;
                }
            } else {
                if (DEBUG_PLAYER_TARGET_SELECTION) {
                    show_debug_message($"{_weapon_name} attacked {target_object.dudes[target_index]} but dealt no damage!");
                }
            }

            scr_flavor(wi, target_object, target_index, _shooter_count, _casualties);

            if (_casualties > 0) {
                target_object.dudes_num[target_index] -= _casualties;
                obj_ncombat.enemy_forces -= _casualties;
                compress_enemy_array(target_object);
                destroy_empty_column(target_object);
            }
        }
    } catch (_exception) {
        handle_exception(_exception);
    }
}
