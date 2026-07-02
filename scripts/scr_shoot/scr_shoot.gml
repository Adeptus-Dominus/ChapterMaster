function scr_shoot(weapon_index_position, target_object, target_type, damage_data, melee_or_ranged) {
    try {
        // weapon_index_position: Weapon number
        // target_object: Target object
        // target_type: Target dudes
        // damage_data: "att" or "arp" or "highest"
        // melee_or_ranged: melee or ranged

        // This massive clusterfuck of a script uses the newly determined weapon and target data to attack and assign damage
        var hostile_type;
        var hostile_damage;
        var hostile_weapon;
        var hostile_range;
        var hostile_splash;
        var aggregate_damage = att[weapon_index_position];
        var armour_pierce = apa[weapon_index_position];
        if (obj_ncombat.wall_destroyed == 1) {
            exit;
        }

        if ((weapon_index_position >= 0) && instance_exists(target_object) && (owner == 2)) {
            var stop, damage_type, doom;
            var shots_fired = wep_num[weapon_index_position];
            if (shots_fired == 0 || ammo[weapon_index_position] == 0) {
                exit;
            }
            doom = 0;
            if ((shots_fired != 1) && (melee_or_ranged != "melee")) {
                switch (obj_ncombat.enemy) {
                    case eFACTION.ECCLESIARCHY:
                        doom = 0.3;
                        break;
                    case eFACTION.ELDAR:
                        doom = 0.4;
                        break;
                    case eFACTION.ORK:
                        doom = 0.2;
                        break;
                    case eFACTION.TAU:
                        doom = 0.4;
                        break;
                    case eFACTION.TYRANIDS:
                        doom = 0.4;
                        break;
                }
            }
            if (obj_ncombat.enemy == eFACTION.HERETICS) {
                aggregate_damage = round(aggregate_damage * 1.15);
                armour_pierce = round(armour_pierce * 1.15);
            }
            if ((obj_ncombat.enemy == eFACTION.CHAOS) && (obj_ncombat.threat == 7)) {
                doom = 1;
            }

            damage_type = "";
            stop = 0;

            if (ammo[weapon_index_position] > 0) {
                ammo[weapon_index_position] -= 1;
            }

            if (damage_data == "medi") {
                damage_type = "att";
                if (aggregate_damage < armour_pierce) {
                    damage_type = "arp";
                }
            } else {
                damage_type = damage_data;
            }
            if (wep[weapon_index_position] == "Web Spinner") {
                damage_type = "status";
            }

            var attack_count_mod = max(1, splash[weapon_index_position]);

            if ((damage_type == "status") && (stop == 0) && (shots_fired > 0)) {
                var damage_per_weapon = 0, hit_number = shots_fired;
                if (melee_or_ranged != "wall") {
                    shots_fired *= attack_count_mod;
                }
                if ((hit_number > 0) && (melee_or_ranged != "wall") && instance_exists(target_object)) {
                    if (wep_owner[weapon_index_position] == "assorted") {
                        target_object.hostile_shooters = 999;
                    } else if (wep_owner[weapon_index_position] != "assorted") {
                        target_object.hostile_shooters = 1;
                    }
                    hostile_damage = 0;
                    hostile_weapon = wep[weapon_index_position];
                    hostile_type = 1;
                    hostile_range = range[weapon_index_position];
                    hostile_splash = attack_count_mod;

                    scr_clean(target_object, hostile_type, hit_number, hostile_damage, hostile_weapon, hostile_range, hostile_splash, weapon_index_position);
                }
            } else if ((damage_type == "att") && (aggregate_damage > 0) && (stop == 0) && (shots_fired > 0)) {
                var damage_per_weapon, hit_number;

                damage_per_weapon = aggregate_damage;

                if (melee_or_ranged == "melee") {
                    if (shots_fired > (target_object.men - target_object.dreads) * 2) {
                        doom = ((target_object.men - target_object.dreads) * 2) / shots_fired;
                    }
                }

                hit_number = shots_fired;

                if ((doom != 0) && (shots_fired > 1)) {
                    damage_per_weapon = floor((doom * damage_per_weapon));
                    hit_number = floor(hit_number * doom);
                }
                if (melee_or_ranged != "wall") {
                    shots_fired *= attack_count_mod;
                }

                if ((hit_number > 0) && (melee_or_ranged != "wall") && instance_exists(target_object)) {
                    if (wep_owner[weapon_index_position] == "assorted") {
                        target_object.hostile_shooters = 999;
                    }
                    if (wep_owner[weapon_index_position] != "assorted") {
                        target_object.hostile_shooters = 1;
                    }
                    hostile_damage = damage_per_weapon / hit_number;
                    hostile_weapon = wep[weapon_index_position];
                    hostile_type = 1;
                    hostile_range = range[weapon_index_position];
                    hostile_splash = attack_count_mod;

                    scr_clean(target_object, hostile_type, hit_number, hostile_damage, hostile_weapon, hostile_range, hostile_splash, weapon_index_position);
                }
            } else if (((damage_type == "arp") || (damage_type == "dread")) && (armour_pierce > 0) && (stop == 0) && (shots_fired > 0)) {
                var damage_per_weapon, hit_number;
                damage_per_weapon = aggregate_damage;
                if (aggregate_damage == 0) {
                    damage_per_weapon = shots_fired;
                }
                if (melee_or_ranged != "wall") {
                    shots_fired *= attack_count_mod;
                }
                if (melee_or_ranged == "melee") {
                    if (shots_fired > ((target_object.veh + target_object.dreads) * 5)) {
                        doom = ((target_object.veh + target_object.dreads) * 5) / shots_fired;
                    }
                }
                hit_number = shots_fired;

                if ((doom != 0) && (shots_fired > 1)) {
                    damage_per_weapon = floor((doom * damage_per_weapon));
                    hit_number = floor(hit_number * doom);
                }

                if (damage_per_weapon == 0) {
                    damage_per_weapon = shots_fired * doom;
                }

                if (hit_number > 0 && instance_exists(target_object)) {
                    hostile_weapon = wep[weapon_index_position];
                    hostile_range = range[weapon_index_position];
                    hostile_splash = attack_count_mod;
                    hostile_damage = damage_per_weapon / hit_number;
                    if (melee_or_ranged == "wall") {
                        var dest = 0;

                        hostile_damage -= target_object.ac[1];
                        hostile_damage = max(0, hostile_damage);
                        hostile_damage = round(hostile_damage) * hit_number;
                        target_object.hp[1] -= hostile_damage;
                        if (target_object.hp[1] <= 0) {
                            dest = 1;
                        }
                        obj_nfort.hostile_weapons = hostile_weapon;
                        obj_nfort.hostile_shots = hit_number;
                        obj_nfort.hostile_damage = hostile_damage;

                        scr_flavor2(dest, "wall", hostile_range, hostile_weapon, hit_number, hostile_splash);
                    } else {
                        target_object.hostile_shooters = (wep_owner[weapon_index_position] == "assorted") ? 999 : 1;
                        hostile_type = 0;

                        scr_clean(target_object, hostile_type, hit_number, hostile_damage, hostile_weapon, hostile_range, hostile_splash, weapon_index_position);
                    }
                }
            }
        }

        if (instance_exists(target_object) && (owner == eFACTION.PLAYER)) {
            // LOGGER.debug("{0}, {1}, {2}, {3}, {4}", wep_num[weapon_index_position], wep[weapon_index_position], splash[weapon_index_position], range[weapon_index_position], att[weapon_index_position])
            var shots_fired = 0;
            var stop = 0;
            var damage_type = "";

            if (weapon_index_position >= 0) {
                shots_fired = wep_num[weapon_index_position];
            }

            if (shots_fired == 0) {
                exit;
            }

            // Guardsman accuracy: mirror the enemy's doom (the owner == eFACTION.IMPERIUM branch
            // above) on the player side. Ranged, multi-shot lasgun stacks only, matching the enemy
            // gating (shots_fired != 1 && not melee). Scaling shots_fired flows through total damage
            // (c = shots_fired * final_hit_damage_value), the casualty cap, and the announced count,
            // while damage_per_weapon stays divided by wep_num, so the cut is a clean linear share.
            if ((weapon_index_position >= 0) && (shots_fired > 1) && (melee_or_ranged != "melee") && (wep[weapon_index_position] == "Lasgun")) {
                shots_fired = max(1, floor(shots_fired * GUARD_DOOM));
            }

            /*if (weapon_index_position<-40){
				if (weapon_index_position=-53){
					if (player_silos>30) then shots_fired=30;
					if (player_silos<30) then shots_fired=player_silos;
				}
				if (weapon_index_position=-51) or (weapon_index_position=-52){
					shots_fired=round(player_silos/2);
				}
			}*/

            while (target_type < array_length(target_object.dudes_hp)) {
                if (target_object.dudes_hp[target_type] == 0) {
                    target_type++;
                    stop = 1;
                } else {
                    stop = 0;
                    break;
                }
            }

            if (weapon_index_position >= 0) {
                if (ammo[weapon_index_position] == 0) {
                    stop = 1;
                }
                if (ammo[weapon_index_position] > 0) {
                    ammo[weapon_index_position] -= 1;
                }
            }
            if (wep[weapon_index_position] == "Missile Silo") {
                obj_ncombat.player_silos -= min(obj_ncombat.player_silos, 30);
            }

            if (damage_data != "highest") {
                damage_type = damage_data;
            }
            if ((damage_data == "highest") && (weapon_index_position >= 0)) {
                damage_type = "att";
                if ((aggregate_damage >= 100) && (armour_pierce > 0)) {
                    damage_type = "arp";
                }
            }
            if (damage_data == "highest") {
                if (weapon_index_position == -51 || weapon_index_position == -52 || weapon_index_position == -53) {
                    damage_type = "att";
                }
            }

            if ((weapon_index_position >= 0) || (weapon_index_position < -40)) {
                // Normal shooting
                var that_works = false;

                if (weapon_index_position >= 0) {
                    if ((aggregate_damage > 0) && (stop == 0)) {
                        that_works = true;
                    }
                }
                if ((weapon_index_position < -40) && (stop == 0)) {
                    that_works = true;
                }

                if (that_works == true) {
                    var damage_per_weapon = 0;
                    attack_count_mod = 0;

                    if (weapon_index_position >= 0) {
                        damage_per_weapon = aggregate_damage / wep_num[weapon_index_position];
                    } // Average damage
                    if (weapon_index_position < -40) {
                        attack_count_mod = 3;

                        if (weapon_index_position == -51) {
                            at = 160;
                            armour_pierce = 0;
                        }
                        if (weapon_index_position == -52) {
                            at = 200;
                            armour_pierce = -1;
                        }
                        if (weapon_index_position == -53) {
                            at = 250;
                            armour_pierce = 0;
                        }
                    }

                    attack_count_mod = max(1, splash[weapon_index_position]);

                    // Armour multiplier indexed by AP rating (1..4); any AP outside that range
                    // leaves armour untouched. Infantry and vehicles scale differently.
                    var _inf_ap = [1, 3, 2, 1.5, 0];
                    var _veh_ap = [1, 6, 4, 2, 0];
                    var _ap_valid = (armour_pierce >= 1) && (armour_pierce <= 4);

                    // Never open fire on a dead rank/formation. Stale men/veh/medi (only refreshed on
                    // the enemy's own alarm) and scr_target's rank-1 fallback can aim us at corpses;
                    // snap to a living rank instead, or clean up the empty formation and bail.
                    if (!instance_exists(target_object)) {
                        exit;
                    }
                    if (target_object.dudes_num[target_type] <= 0) {
                        var _alive_rank = find_next_alive_rank(target_object, -1);
                        if (_alive_rank == -1) {
                            destroy_empty_column(target_object);
                            exit;
                        }
                        target_type = _alive_rank;
                    }

                    // Damage spills across ranks and, once a formation is spent, into the
                    // formation behind it. Every target actually fired upon gets its own flavour
                    // line with its own casualty count. The loop always terminates: shots_left
                    // strictly shrinks on every iteration that continues.
                    var spill_block = target_object;
                    var spill_rank = target_type;
                    var shots_left = shots_fired;
                    var touched_blocks = []; // Spill-over formations only; target_object is cleaned below.

                    // The whole volley posts ONE battle-log line: the first target gets the rich
                    // weapon flavour (deferred), and every later target the overflow kills is
                    // gathered into a kill list appended to it (see emit_volley_flavour).
                    var _first_target = true;
                    var _primary_flavour = undefined;
                    var _spill_kills = []; // [{ name, count }] for targets killed after the first.

                    while (shots_left > 0) {
                        // This target's armour against our AP rating.
                        var _armour = spill_block.dudes_ac[spill_rank];
                        if (_ap_valid) {
                            var _ap_table = spill_block.dudes_vehicle[spill_rank] ? _veh_ap : _inf_ap;
                            _armour *= _ap_table[armour_pierce];
                        }
                        var final_hit = max(0, (damage_per_weapon - (_armour * attack_count_mod)) * spill_block.dudes_dr[spill_rank]);

                        var rank_num = spill_block.dudes_num[spill_rank];
                        var rank_hp = spill_block.dudes_hp[spill_rank];
                        var total_damage = shots_left * final_hit;
                        var raw_kills = floor(total_damage / rank_hp);
                        var casualties = min(raw_kills, rank_num, shots_left * attack_count_mod);

                        // Surplus damage only spills once this rank is actually wiped out.
                        var next_shots = 0;
                        if ((casualties >= rank_num) && (rank_num > 0) && (raw_kills > rank_num)) {
                            next_shots = max(0, shots_left - ceil((rank_num * rank_hp) / final_hit));
                        }

                        // Gather flavour. The first target carries the rich phrasing (deferred, with
                        // the full weapon count); later targets just contribute to the kill list.
                        // final_hit <= 0 means armour stopped the shots cold (AP too low).
                        if (_first_target) {
                            _primary_flavour = scr_flavor(weapon_index_position, spill_block, spill_rank, shots_fired, casualties, final_hit <= 0, true);
                            _first_target = false;
                        } else if (casualties > 0) {
                            array_push(_spill_kills, { name: spill_block.dudes[spill_rank], count: casualties });
                        }

                        if ((rank_num == 1) && (casualties == 0) && (total_damage > 0)) {
                            spill_block.dudes_hp[spill_rank] -= total_damage; // Chip a lone survivor
                            if (spill_block.dudes_hp[spill_rank] <= 0) {
                                // Chipped to death: remove it now and drop the force count. Otherwise
                                // dudes_num stays 1 at dudes_hp <= 0 - a "zombie" that find_next_alive_rank
                                // skips, so it's never finished off and keeps inflating enemy_forces.
                                spill_block.dudes_num[spill_rank] = 0;
                                obj_ncombat.enemy_forces -= 1;
                            }
                        }
                        if (casualties >= 1) {
                            spill_block.dudes_num[spill_rank] -= casualties;
                            obj_ncombat.enemy_forces -= casualties;
                        }

                        shots_left = next_shots;
                        if (shots_left <= 0) {
                            break;
                        }

                        // Next target: a living rank in this formation, else the formation behind.
                        var next_rank = find_next_alive_rank(spill_block, spill_block.dudes_vehicle[spill_rank]);
                        if (next_rank == -1) {
                            spill_block = get_next_enemy_formation(spill_block);
                            if (spill_block == noone) {
                                break;
                            }
                            array_push(touched_blocks, spill_block);
                            next_rank = find_next_alive_rank(spill_block, -1);
                            if (next_rank == -1) {
                                break;
                            }
                        }
                        spill_rank = next_rank;
                    }

                    // Post the single consolidated line for the whole volley.
                    emit_volley_flavour(_primary_flavour, _spill_kills);

                    // Clean up the spill-over formations (target_object is handled below).
                    for (var _tb = 0; _tb < array_length(touched_blocks); _tb++) {
                        if (instance_exists(touched_blocks[_tb])) {
                            compress_enemy_array(touched_blocks[_tb]);
                            destroy_empty_column(touched_blocks[_tb]);
                        }
                    }
                }
            }

            if (stop == 0) {
                compress_enemy_array(target_object);
                destroy_empty_column(target_object);
            }
        }
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

/// @function find_next_alive_rank
/// @description Returns the index of the next living rank (dudes_num > 0 and dudes_hp > 0) in a
///              formation, preferring ranks that match the requested vehicle flag. Returns -1 if
///              none. The dudes_hp > 0 check keeps callers safe from dividing by a rank's HP.
/// @param {Id.Instance} _block The obj_enunit formation to search.
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
        var _dpw = att[weapon_index_position] / _shots; // per-bike damage
        var _mod = max(1, splash[weapon_index_position]);
        if (ammo[weapon_index_position] > 0) {
            ammo[weapon_index_position] -= 1;
        }

        // Armour multiplier indexed by AP rating (1..4), matching scr_shoot's normal path.
        var _inf_ap = [1, 3, 2, 1.5, 0];
        var _veh_ap = [1, 6, 4, 2, 0];
        var _ap_valid = (_ap >= 1) && (_ap <= 4);

        // Total living models across every formation on the field.
        var _formations = [];
        var _total = 0;
        with (obj_enunit) {
            array_push(_formations, id);
            for (var r = 1; r <= 30; r++) {
                if (dudes[r] != "" && dudes_num[r] > 0) {
                    _total += dudes_num[r];
                }
            }
        }
        if (_total <= 0) {
            exit;
        }

        // Apply damage proportionally to each rank's share of the field; record every rank that lost models.
        var _hits = []; // [{ name, kills, bounced }]
        for (var fi = 0; fi < array_length(_formations); fi++) {
            var _f = _formations[fi];
            if (!instance_exists(_f)) {
                continue;
            }
            for (var r = 1; r <= 30; r++) {
                if (_f.dudes[r] == "" || _f.dudes_num[r] <= 0) {
                    continue;
                }

                var _armour = _f.dudes_ac[r];
                if (_ap_valid) {
                    var _ap_table = _f.dudes_vehicle[r] ? _veh_ap : _inf_ap;
                    _armour *= _ap_table[_ap];
                }

                var _rank_shots = _shots * (_f.dudes_num[r] / _total);
                var _final_hit = max(0, (_dpw - (_armour * _mod)) * _f.dudes_dr[r]);
                var _kills = min(floor((_rank_shots * _final_hit) / _f.dudes_hp[r]), _f.dudes_num[r]);
                if (_kills < 0) {
                    _kills = 0;
                }

                if (_kills > 0) {
                    _f.dudes_num[r] -= _kills;
                    obj_ncombat.enemy_forces -= _kills;
                    array_push(_hits, { name: _f.dudes[r], kills: _kills, bounced: (_final_hit <= 0), block: _f, rank: r });
                }
            }
        }

        // Primary = the rank with the most kills (rich deferred flavour); the rest form the kill list.
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
                array_push(_spill, { name: _hits[i].name, count: _hits[i].kills });
            }
            var _p = _hits[_best];
            if (instance_exists(_p.block)) {
                _primary = scr_flavor(weapon_index_position, _p.block, _p.rank, _shots, _p.kills, _p.bounced, true);
            }
        }
        emit_volley_flavour(_primary, _spill);

        // Clean up spent ranks/formations (mirrors scr_shoot).
        for (var fi = 0; fi < array_length(_formations); fi++) {
            if (instance_exists(_formations[fi])) {
                compress_enemy_array(_formations[fi]);
                destroy_empty_column(_formations[fi]);
            }
        }
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}
