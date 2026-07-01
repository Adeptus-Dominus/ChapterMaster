/// @function find_next_alive_rank
/// @description Returns the index of the next living rank (dudes_num > 0 and dudes_hp > 0) in a
///              formation, preferring ranks that match the requested vehicle flag. Returns -1 if
///              none. The dudes_hp > 0 check keeps callers safe from dividing by a rank's HP.
/// @param {Id.Instance.obj_enunit} _block The obj_enunit formation to search.
/// @param {Real} _prefer_vehicle 0/1 to prefer that category, or -1 for any living rank.
/// @returns {Real}
function find_next_alive_rank(_block, _prefer_vehicle) {
    if (!instance_exists(_block)) {
        return -1;
    }

    var _fallback = -1;
    for (var f = 1; f <= 30; f++) {
        if (_block.dudes_num[f] <= 0 || _block.dudes_hp[f] <= 0) {
            continue;
        }

        if (_prefer_vehicle == -1 || _block.dudes_vehicle[f] == _prefer_vehicle) {
            return f;
        }

        if (_fallback == -1) {
            _fallback = f;
        }
    }

    return _fallback;
}

/// @function get_next_enemy_formation
/// @description Returns the nearest enemy formation (obj_enunit) sitting behind the given one
///              that still contains at least one living rank, or noone if there isn't one.
/// @param {Id.Instance} _block The formation we are spilling out of.
/// @returns {Id.Instance}
function get_next_enemy_formation(_block) {
    if (!instance_exists(_block)) {
        return noone;
    }

    var _bx = _block.x;
    var _bid = _block.id;
    var _best = noone;
    var _best_x = 0;
    with (obj_enunit) {
        if (id == _bid) {
            continue;
        }

        if (x <= _bx) {
            continue;
        }

        if (find_next_alive_rank(id, -1) == -1) {
            continue;
        }

        if (_best == noone || x < _best_x) {
            _best = id;
            _best_x = x;
        }
    }

    return _best;
}

/// @param {Array|Id.Instance} _list Formation ID or array of such to compress & destroy if empty
function combat_cleanup_formations(_list) {
    if (is_array(_list)) {
        for (var i = 0; i < array_length(_list); i++) {
            if (instance_exists(_list[i])) {
                compress_enemy_array(_list[i]);
                destroy_empty_column(_list[i]);
            }
        }
    } else if (instance_exists(_list)) {
        compress_enemy_array(_list);
        destroy_empty_column(_list);
    }
}

/// @param {Real} _ac Armour points value
/// @param {Real} _ap Armour-pierce value
/// @param {Bool} _is_vehicle Vehicle or not
/// @returns {Real} Armour value after AP multiplier
function combat_rank_armour(_ac, _ap, _is_vehicle) {
    if (_ap < 1 || _ap > 4) {
        return _ac;
    }

    static _inf = [
        1,
        3,
        2,
        1.5,
        0,
    ];

    static _veh = [
        1,
        6,
        4,
        2,
        0,
    ];

    var _armor_mod = _is_vehicle ? _veh[_ap] : _inf[_ap];
    _ac *= _armor_mod;
    return round(_ac);
}

/// @description Computes damage against a rank, applies casualties, and returns the combat outcome.
/// @param {Id.Instance.obj_enunit} block
/// @param {Real} rank
/// @param {Real} dmg_per_weapon
/// @param {Real} ap
/// @param {Real} splash
/// @param {Real} shots_fired
/// @returns {Struct}
function combat_apply_rank_damage(block, rank, dmg_per_weapon, ap, splash, shots_fired) {
    var _rank_armour = combat_rank_armour(block.dudes_ac[rank], ap, block.dudes_vehicle[rank]);
    var _rank_num = block.dudes_num[rank];
    var _rank_hp = block.dudes_hp[rank];
    var _rank_dr = block.dudes_dr[rank];

    var _final_hit = max(0, (dmg_per_weapon - (_rank_armour)) * _rank_dr);
    var _total_damage = shots_fired * _final_hit;
    var _raw_kills = floor(_total_damage / _rank_hp);
    var _casualties = min(_raw_kills, _rank_num);
    _casualties = min(_casualties, ceil(shots_fired * splash));

    // Apply casualties and update overall combat status
    if (_casualties > 0) {
        block.dudes_num[rank] -= _casualties;
        obj_ncombat.enemy_forces -= _casualties;
    } else if (_rank_num == 1 && _total_damage > 0) {
        // Handle partial damage for single unit remains
        block.dudes_hp[rank] -= _total_damage;
        if (block.dudes_hp[rank] <= 0) {
            block.dudes_num[rank] = 0;
            obj_ncombat.enemy_forces -= 1;
            _casualties = 1; // Count as casualty for tracking purposes
        }
    }

    return {
        casualties: _casualties,
        raw_kills: _raw_kills,
        final_hit: _final_hit,
        bounced: (_final_hit <= 0),
    };
}

/// @self Id.Instance.obj_enunit|Id.Instance.obj_pnunit
/// @param {Real} weapon_index_position Weapon number
/// @param {Id.Instance.obj_enunit|Id.Instance.obj_pnunit} target_object Target object
/// @param {Real} target_type Target dudes
/// @param {String} damage_data "att" or "arp" or "highest"
/// @param {String} melee_or_ranged melee or ranged
function scr_shoot(weapon_index_position, target_object, target_type, damage_data, melee_or_ranged) {
    try {
        if (obj_ncombat.wall_destroyed == 1) {
            exit;
        }

        if (!instance_exists(target_object)) {
            exit;
        }

        var _aggregate_damage = att[weapon_index_position];
        var _armour_pierce = apa[weapon_index_position];

        if ((owner == 2) && (weapon_index_position >= 0)) {
            scr_shoot_enemy(weapon_index_position, target_object, damage_data, melee_or_ranged, _aggregate_damage, _armour_pierce);
        }

        if (owner == eFACTION.PLAYER) {
            scr_shoot_player(weapon_index_position, target_object, target_type, _aggregate_damage, _armour_pierce);
        }
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

/// @self Id.Instance.obj_enunit
/// @description Handles enemy-side shooting (owner == 2).
/// @param {Id.Instance.obj_pnunit} target_object
function scr_shoot_enemy(weapon_index_position, target_object, damage_data, melee_or_ranged, aggregate_damage, armour_pierce) {
    var _hit_count = wep_num[weapon_index_position];
    if (_hit_count == 0 || ammo[weapon_index_position] == 0) {
        exit;
    }

    ammo[weapon_index_position] -= 1;

    var _hostile_type = 0;
    var _damage = 0;
    var _damage_per_weapon = 0;
    var _damage_type = "";
    var _weapon_name = wep[weapon_index_position];
    var _weapon_splash = max(1, splash[weapon_index_position]);
    var _weapon_range = range[weapon_index_position];
    var _doom_mod = 1;

    // Determine doom modifier based on faction
    if (_hit_count > 1 && melee_or_ranged != "melee") {
        switch (obj_ncombat.enemy) {
            case eFACTION.ECCLESIARCHY:
                _doom_mod = 0.3;
                break;
            case eFACTION.ELDAR:
                _doom_mod = 0.4;
                break;
            case eFACTION.ORK:
                _doom_mod = 0.2;
                break;
            case eFACTION.TAU:
                _doom_mod = 0.4;
                break;
            case eFACTION.TYRANIDS:
                _doom_mod = 0.4;
                break;
        }
    }

    // Heretic damage boost
    if (obj_ncombat.enemy == eFACTION.HERETICS) {
        aggregate_damage = round(aggregate_damage * 1.15);
    }

    // Resolve damage type
    if (damage_data == "medi") {
        _damage_type = (aggregate_damage < armour_pierce) ? "arp" : "att";
    } else {
        _damage_type = damage_data;
    }

    if (_weapon_name == "Web Spinner") {
        _damage_type = "status";
    }

    var _is_assorted = wep_owner[weapon_index_position] == "assorted";

    if (_damage_type == "status") {
        if (melee_or_ranged != "wall") {
            _hit_count *= _weapon_splash;

            target_object.hostile_shooters = _is_assorted ? 999 : 1;
            _damage = 0;
            _hostile_type = 1;

            scr_clean(target_object, _hostile_type, _hit_count, _damage, _weapon_name, _weapon_range, _weapon_splash, armour_pierce);
        }
    } else if (_damage_type == "att" && aggregate_damage > 0) {
        _damage_per_weapon = aggregate_damage;

        if (melee_or_ranged == "melee") {
            var _men_limit = (target_object.men - target_object.dreads) * 2;
            if (_hit_count > _men_limit) {
                _doom_mod = _men_limit / _hit_count;
            }
        }

        if (_hit_count > 1) {
            _damage_per_weapon = floor(_doom_mod * _damage_per_weapon);
            _hit_count = floor(_hit_count * _doom_mod);
        }

        if (melee_or_ranged != "wall") {
            _hit_count *= _weapon_splash;

            if (_hit_count > 0) {
                target_object.hostile_shooters = _is_assorted ? 999 : 1;
                _damage = _damage_per_weapon / _hit_count;
                _hostile_type = 1;

                scr_clean(target_object, _hostile_type, _hit_count, _damage, _weapon_name, _weapon_range, _weapon_splash, armour_pierce);
            }
        }
    } else if ((_damage_type == "arp" || _damage_type == "dread") && armour_pierce > 0) {
        _damage_per_weapon = (aggregate_damage == 0) ? _hit_count : aggregate_damage;

        if (melee_or_ranged != "wall") {
            _hit_count *= _weapon_splash;
        }

        if (melee_or_ranged == "melee") {
            var _veh_limit = (target_object.veh + target_object.dreads) * 5;
            if (_hit_count > _veh_limit) {
                _doom_mod = _veh_limit / _hit_count;
            }
        }

        if (_hit_count > 1) {
            _damage_per_weapon = floor(_doom_mod * _damage_per_weapon);
            _hit_count = floor(_hit_count * _doom_mod);
        }

        if (_damage_per_weapon == 0) {
            _damage_per_weapon = _hit_count * _doom_mod;
        }

        if (_hit_count > 0) {
            _damage = _damage_per_weapon / _hit_count;

            if (melee_or_ranged == "wall") {
                var dest = 0;

                _damage -= target_object.ac;
                _damage = max(0, _damage);
                _damage = round(_damage) * _hit_count;
                target_object.hp -= _damage;

                if (target_object.hp <= 0) {
                    dest = 1;
                }

                obj_nfort.hostile_weapons = _weapon_name;
                obj_nfort.hostile_shots = _hit_count;
                obj_nfort.hostile_damage = _damage;

                scr_flavor2(dest, "wall", _weapon_range, _weapon_name, _hit_count, _weapon_splash);
            } else {
                target_object.hostile_shooters = _is_assorted ? 999 : 1;
                _hostile_type = 0;

                scr_clean(target_object, _hostile_type, _hit_count, _damage, _weapon_name, _weapon_range, _weapon_splash, armour_pierce);
            }
        }
    }
}

/// @self Id.Instance.obj_pnunit
/// @description Handles player-side shooting (owner == eFACTION.PLAYER).
/// @param {Id.Instance.obj_enunit} target_object
function scr_shoot_player(weapon_index_position, target_object, target_type, aggregate_damage, armour_pierce) {
    // Resolve shots fired
    var shots_fired = 0;
    if (weapon_index_position >= 0) {
        if (aggregate_damage <= 0) {
            exit;
        }

        shots_fired = wep_num[weapon_index_position];
    } else if (weapon_index_position < -40) {
        // Fixes legacy bug where negative weapon indices would always exit early with 0 shots
        shots_fired = 1;
    }

    if (shots_fired == 0) {
        exit;
    }

    var _hp_count = array_length(target_object.dudes_hp);

    while (target_type < _hp_count && target_object.dudes_hp[target_type] <= 0) {
        target_type++;
    }
    
    if (target_type >= _hp_count) {
        exit;
    }

    var damage_per_weapon = 0;
    var attack_count_mod = 1;

    if (weapon_index_position >= 0) {
        var _ammo = ammo[weapon_index_position];
        if (_ammo == 0) {
            exit;
        } else if (_ammo != -1) {
            ammo[weapon_index_position]--;
        }

        //? Probably dead code, because `player_silos` seems to never be assigned to after initialization to 0;
        if (wep[weapon_index_position] == "Missile Silo") {
            obj_ncombat.player_silos -= min(obj_ncombat.player_silos, 30);
        }

        damage_per_weapon = aggregate_damage / wep_num[weapon_index_position];
        attack_count_mod = max(1, splash[weapon_index_position]);
    } else if (weapon_index_position < -40) {
        attack_count_mod = 3;

        switch (weapon_index_position) {
            case -51:
                damage_per_weapon = 160;
                armour_pierce = 0;
                break;
            case -52:
                damage_per_weapon = 200;
                armour_pierce = -1;
                break;
            case -53:
                damage_per_weapon = 250;
                armour_pierce = 0;
                break;
        }
    }

    // Verify current target rank status
    if (target_object.dudes_num[target_type] <= 0) {
        var _alive_rank = find_next_alive_rank(target_object, -1);
        if (_alive_rank == -1) {
            destroy_empty_column(target_object);
            exit;
        }

        target_type = _alive_rank;
    }

    var _target_block = target_object;
    var _target_rank = target_type;
    var _shots_left = shots_fired;
    var _touched_blocks = [_target_block];

    var _first_target = true;
    var _primary_flavour = undefined;
    var _spill_kills = [];

    // Distribute damage spillover across units
    while (_shots_left > 0) {
        var _rank_num = _target_block.dudes_num[_target_rank];
        var _rank_hp = _target_block.dudes_hp[_target_rank];

        var _results = combat_apply_rank_damage(_target_block, _target_rank, damage_per_weapon, armour_pierce, attack_count_mod, _shots_left);

        var _casualties = _results.casualties;
        var _final_hit = _results.final_hit;

        var _next_shots = 0;
        if (_casualties >= _rank_num && _rank_num > 0 && _results.raw_kills > _rank_num) {
            _next_shots = max(0, _shots_left - ceil((_rank_num * _rank_hp) / _final_hit));
        }

        if (_first_target) {
            _primary_flavour = scr_flavor(weapon_index_position, _target_block, _target_rank, shots_fired, _casualties, _final_hit <= 0, true);
            _first_target = false;
        } else if (_casualties > 0) {
            array_push(_spill_kills, {name: _target_block.dudes[_target_rank], count: _casualties});
        }

        _shots_left = _next_shots;
        if (_shots_left <= 0) {
            break;
        }

        var _next_rank = find_next_alive_rank(_target_block, _target_block.dudes_vehicle[_target_rank]);
        if (_next_rank == -1) {
            _target_block = get_next_enemy_formation(_target_block);
            if (_target_block == noone) {
                break;
            }

            array_push(_touched_blocks, _target_block);
            _next_rank = find_next_alive_rank(_target_block, -1);
            if (_next_rank == -1) {
                break;
            }
        }

        _target_rank = _next_rank;
    }

    emit_volley_flavour(_primary_flavour, _spill_kills);
    combat_cleanup_formations(_touched_blocks);
}

/// @self Asset.GMObject.obj_pnunit
/// @description Speed Force: sweep the whole enemy force, dividing damage proportionally to rank
///              size, and report it as ONE consolidated volley line (see emit_volley_flavour).
/// @param {Real} weapon_index_position The Speed Force weapon stack index.
function scr_shoot_spread(weapon_index_position) {
    try {
        if (wep_num[weapon_index_position] <= 0 || ammo[weapon_index_position] == 0) {
            exit;
        }

        var _shots = wep_num[weapon_index_position];
        var _ap = apa[weapon_index_position];
        var _damage_per_weapon = att[weapon_index_position] / _shots;
        var _splash = max(1, splash[weapon_index_position]);

        if (ammo[weapon_index_position] > 0) {
            ammo[weapon_index_position] -= 1;
        }

        var _formations = [];
        var _total = 0;
        with (obj_enunit) {
            array_push(_formations, id);
            for (var _rank = 1; _rank <= 30; _rank++) {
                if (dudes[_rank] != "" && dudes_num[_rank] > 0 && dudes_hp[_rank] > 0) {
                    _total += dudes_num[_rank];
                }
            }
        }

        if (_total <= 0) {
            exit;
        }

        var _hits = [];
        var _wounded = undefined;
        for (var fi = 0; fi < array_length(_formations); fi++) {
            var _block = _formations[fi];
            if (!instance_exists(_block)) {
                continue;
            }

            for (var _rank = 1; _rank <= 30; _rank++) {
                if (_block.dudes[_rank] == "" || _block.dudes_num[_rank] <= 0 || _block.dudes_hp[_rank] <= 0) {
                    continue;
                }

                var _rank_shots = _shots * (_block.dudes_num[_rank] / _total);
                var _results = combat_apply_rank_damage(_block, _rank, _damage_per_weapon, _ap, _splash, _rank_shots);

                if (_results.casualties > 0) {
                    array_push(_hits, {name: _block.dudes[_rank], kills: _results.casualties, bounced: _results.bounced, block: _block, rank: _rank});
                } else if (_wounded == undefined) {
                    _wounded = {
                        bounced: _results.bounced,
                        block: _block,
                        rank: _rank,
                    };
                }
            }
        }

        // Generate and emit flavor text
        var _primary = undefined;
        var _spill = [];
        if (array_length(_hits) > 0) {
            var _best = 0;
            for (var i = 1; i < array_length(_hits); i++) {
                if (_hits[i].kills > _hits[_best].kills) {
                    _best = i;
                }
            }

            for (var i = 0; i < array_length(_hits); i++) {
                if (i == _best) {
                    continue;
                }

                array_push(_spill, {name: _hits[i].name, count: _hits[i].kills});
            }

            var _p = _hits[_best];
            if (instance_exists(_p.block)) {
                _primary = scr_flavor(weapon_index_position, _p.block, _p.rank, _shots, _p.kills, _p.bounced, true);
            }
        } else if (_wounded != undefined && instance_exists(_wounded.block)) {
            _primary = scr_flavor(weapon_index_position, _wounded.block, _wounded.rank, _shots, 0, _wounded.bounced, true);
        }

        emit_volley_flavour(_primary, _spill);
        combat_cleanup_formations(_formations);
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}
