/// @description This alarm is responsible for the enemy target column selection

obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.SYSTEM, $"Enemy {obj_ncombat.combat_debugger.resolve_label(id)} at x={x}, flank={flank} is picking a target");

if (!instance_exists(obj_pnunit)) {
    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"No valid player blocks, exiting");
    exit;
}

enemy = flank ? get_leftmost() : get_rightmost();
// Upstream (342798291): also bail when the block found is not a valid target.
if (enemy == noone || !target_block_is_valid(enemy, obj_pnunit)) {
    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"Couldn't find valid player blocks, exiting");
    exit;
}

obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"Initial target player block: {obj_ncombat.combat_debugger.resolve_label(enemy)} at x={enemy.x}");

// enemy2 is used across several sibling blocks below (the two column-piercing
// passes and the older melee/vehicle chain). Declare it once here at event scope;
// GML hoists var anyway, so this only makes the shared scope explicit and silences
// the GM2043 "outside its scope" warnings.
var enemy2 = noone;

//In melee check
engaged = collision_point(x - 10, y, obj_pnunit, 0, 1) || collision_point(x + 10, y, obj_pnunit, 0, 1);

if (!engaged) {
    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"Not engaged, firing");
    // Shooting
    for (var i = 0; i < array_length(wep); i++) {
        if (wep[i] == "" || wep_num[i] == 0) {
            continue;
        }

        if ((range[i] == 1) || (ammo[i] == 0)) {
            continue;
        }

        if (range[i] == 0) {
            LOGGER.error($"{wep[i]} has broken range! This shouldn't happen! Range: {range[i]}; Ammo: {ammo[i]}; Owner: {wep_owner[i]}");
            continue;
        }

        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"{wep[i]}(i{i}) is firing");

        if (!target_block_is_valid(enemy, obj_pnunit)) {
            enemy = flank == 0 ? get_rightmost() : get_leftmost();
            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"Target is invalid, flipped to {obj_ncombat.combat_debugger.resolve_label(enemy)}");
            if (!target_block_is_valid(enemy, obj_pnunit)) {
                obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"Target is still invalid, exiting");
                exit;
            }
        }

        var dist = 0;

        if (instance_exists(obj_nfort) && !flank) {
            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"Targeting Fort");
            enemy = instance_nearest(x, y, obj_nfort);
            dist = 2;
        } else {
            dist = get_block_distance(enemy);
        }

        var target_unit_index = 0;

        if (range[i] >= dist) {
            // The weapon is in range;
            // A weapon's armour pierce doubles as its role. Dedicated anti-tank guns
            // (apa >= GUARD_ENEMY_ANTITANK_AP, the rokkit / lascannon / melta class) hunt
            // vehicles. Everything lighter (general-purpose and pure anti-infantry) goes
            // for the men first. This is preference by weapon role, not per-shot penetration
            // knowledge: the enemy never checks whether a given shot would crack a specific
            // target, it just sends tank-hunters at tanks and lighter guns at infantry.
            // Either type still crosses over as a fallback through the paths below: an
            // anti-tank gun with no vehicle in reach drops to the men path, and a lighter
            // gun with no men in reach drops to the vehicle fallback inside the men path.
            var _target_vehicles = apa[i] >= GUARD_ENEMY_ANTITANK_AP; // role-based target preference

            // Weird alpha strike mechanic, that changes target unit index to CM;
            if (((wep[i] == "Power Fist") || (wep[i] == "Bolter")) && (obj_ncombat.alpha_strike > 0) && (wep_num[i] > 5)) {
                obj_ncombat.alpha_strike -= 0.5;

                var cm_present = false;
                var cm_index = -1;
                var cm_block = noone; // Upstream (528c918ff): instance handle, not bool
                with (obj_pnunit) {
                    for (var u = 0; u < array_length(unit_struct); u++) {
                        if (marine_type[u] == obj_ini.role[100][eROLE.CHAPTERMASTER]) {
                            cm_present = true;
                            cm_index = u;
                            cm_block = id;
                        }
                    }
                }
                if (cm_present) {
                    enemy = cm_block;
                    target_unit_index = cm_index;
                    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"Alpha Strike: targeting Chapter Master at {obj_ncombat.combat_debugger.resolve_label(cm_block)} unit_index={cm_index}");
                }
            }

            // AP weapons attacking vehicles and forts;
            var _no_vehicles_present = false;
            if (_target_vehicles) {
                var _shot = false;
                if ((!instance_exists(obj_nfort)) || flank) {
                    if (block_has_armour(enemy) || (enemy.veh_type[1] == "Defenses")) {
                        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"AP -> vehicle in column {obj_ncombat.combat_debugger.resolve_label(enemy)}, apa={apa[i]}, firing");
                        scr_shoot(i, enemy, target_unit_index, "arp", "ranged");
                        continue;
                    } else {
                        // Front block has no armour. If there are other blocks behind,
                        // look for a vehicle to hit. If none is found anywhere (including
                        // a single men-only block, such as a lone Guard rank), fall back
                        // to shooting the men instead of idling. The original code gated
                        // this whole fallback behind a multi-block check, so a lone
                        // men-only block left every AP weapon firing zero shots.
                        if (instance_number(obj_pnunit) > 1) { // Upstream (4bd385330): Orks look behind the front line too
                            var _column_size_value = enemy.column_size;
                            var x2 = enemy.x;
                            repeat (instance_number(obj_pnunit) - 1) {
                                x2 += flank == 0 ? -10 : 10;
                                enemy2 = instance_nearest(x2, y, obj_pnunit);
                                if (!target_block_is_valid(enemy2, obj_pnunit)) {
                                    continue;
                                }
                                if (range[i] < get_block_distance(enemy2)) {
                                    break;
                                }
                                if (block_has_armour(enemy2)) {
                                    // Screening: a large front block (such as a wall of
                                    // Guardsmen) shields the vehicles behind it from AP
                                    // fire, the same way the men-targeting path below
                                    // shields the men behind it. Without this every apa>0
                                    // weapon looks straight past the men-only Guard rank
                                    // to the Marines' vehicles, so the Guard screen
                                    // nothing. When the back block is shielded the shot
                                    // is not taken here; _shot stays false and the weapon
                                    // falls back to firing on the front Guard block.
                                    var _back_column_size_value = enemy2.column_size;
                                    if (_back_column_size_value < _column_size_value) {
                                        continue;
                                    } else {
                                        var _pass_chance = ((_back_column_size_value / _column_size_value) - 1) * 100;
                                        if (irandom_range(1, 100) < min(_pass_chance, 80)) {
                                            continue;
                                        }
                                    }
                                    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"AP -> vehicle found in next column {obj_ncombat.combat_debugger.resolve_label(enemy2)}, firing");
                                    scr_shoot(i, enemy2, target_unit_index, "arp", "ranged");
                                    _shot = true;
                                    break;
                                }
                            }
                        }
                        if (!_shot) {
                            _no_vehicles_present = true;
                            _target_vehicles = false;
                            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"AP -> no vehicles found, falling back to infantry");
                        }
                    }
                } else {
                    enemy = instance_nearest(x, y, obj_nfort);
                    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"AP -> targeting wall");
                    scr_shoot(i, enemy, 1, "arp", "wall");
                    continue;
                }
            }

            // Non-AP weapons attacking normal units;
            if ((!_target_vehicles) && ((!instance_exists(obj_nfort)) || flank)) {
                var _shot = false;
                if (enemy.men > 0) {
                    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"non-AP -> infantry in column {obj_ncombat.combat_debugger.resolve_label(enemy)}, men={enemy.men}, firing");
                    scr_shoot(i, enemy, target_unit_index, "att", "ranged");
                    continue;
                } else if (instance_number(obj_pnunit) > 1) {
                    // There were no marines in the first column, looking behind;
                    // Column piercing. This branch only runs when the front block has zero
                    // men, i.e. a tank wall (or similar armour-only block) is screening the
                    // infantry. The old code rolled a per-block "screening" chance that,
                    // behind a small vehicle block, pinned at its 80% cap and skipped the
                    // infantry, so ~4 of 5 anti-infantry volleys fell through to the vehicle
                    // fallback and plinked the armour. One tank became a bullet sponge for a
                    // thousand men behind it. Instead the volley now pierces by depth (see
                    // PIERCE_LINE_SOAK / PIERCE_MAX_DEPTH in macros.gml): each armour line
                    // soaks a third of the original volley as bounced chip fire, whatever
                    // gets through lands on the first men-bearing line, and nothing reaches
                    // past the third line. Men-behind-men screening is unaffected: a front
                    // block with men in it still absorbs the whole volley above.
                    // Finding the ranks: the old probe walked x2 in 10px steps with
                    // instance_nearest, and inherited vanilla's direction bug: the men
                    // look-behind stepped +10 for the main force (toward the enemy),
                    // opposite to the -10 the vehicle look-behinds correctly use, so it
                    // only ever resolved the front block itself and never reached the
                    // ranks behind. Blocks behind the front are instead collected
                    // directly (main force fronts are the rightmost block, so behind is
                    // lower x; flank fronts are leftmost, behind is higher x), sorted
                    // nearest-behind first, and the first two men-bearing blocks in
                    // weapon range become rank 2 and rank 3.
                    var _front_x = enemy.x;
                    var _behind = [];
                    with (obj_pnunit) {
                        if (id == other.enemy) {
                            continue;
                        }
                        if (x <= 0) {
                            continue;
                        }
                        var _is_behind = other.flank ? (x > _front_x) : (x < _front_x);
                        if (_is_behind) {
                            array_push(_behind, id);
                        }
                    }
                    if (flank) {
                        array_sort(_behind, function(_a, _b) {
                            return _a.x - _b.x;
                        });
                    } else {
                        array_sort(_behind, function(_a, _b) {
                            return _b.x - _a.x;
                        });
                    }
                    var _wall_blocks = [];
                    var _wall_shots = [];
                    // Collect the lines the volley can interact with: the front wall plus
                    // blocks behind it, valid and in range, capped at PIERCE_MAX_DEPTH.
                    var _lines = [enemy];
                    for (var b = 0; b < array_length(_behind); b++) {
                        if (array_length(_lines) >= PIERCE_MAX_DEPTH) {
                            break;
                        }
                        enemy2 = _behind[b];
                        if (!target_block_is_valid(enemy2, obj_pnunit)) {
                            continue;
                        }
                        if (range[i] < get_block_distance(enemy2)) {
                            break;
                        }
                        array_push(_lines, enemy2);
                    }
                    var _total_shots = wep_num[i];
                    var _soak_shots = max(1, floor(_total_shots * PIERCE_LINE_SOAK));
                    var _remaining = _total_shots;
                    var _rank_block = noone;
                    for (var l = 0; l < array_length(_lines); l++) {
                        var _line = _lines[l];
                        if (_line.men > 0) {
                            _rank_block = _line;
                            break;
                        }
                        if (block_has_armour(_line) || (_line.veh_type[1] == "Defenses")) {
                            var _w_soak = min(_soak_shots, _remaining);
                            if (_w_soak > 0) {
                                array_push(_wall_blocks, _line);
                                array_push(_wall_shots, _w_soak);
                                _remaining -= _w_soak;
                            }
                            if (_remaining <= 0) {
                                break;
                            }
                        }
                    }
                    if ((_rank_block != noone) && (_remaining > 0)) {
                        var _ammo_spent = false;
                        scr_shoot(i, _rank_block, target_unit_index, "att", "ranged", _remaining, !_ammo_spent);
                        _ammo_spent = true;
                        _shot = true;
                        // The soaked shots still land on the armour lines they bounced
                        // off, so the walls keep taking chip fire instead of the stopped
                        // shots vanishing.
                        for (var w = 0; w < array_length(_wall_blocks); w++) {
                            scr_shoot(i, _wall_blocks[w], target_unit_index, "att", "ranged", _wall_shots[w], !_ammo_spent);
                        }
                        if (_shot) {
                            continue;
                        }
                    }
                }

                // We failed to find normal units to attack, attacking vehicles with a non-AP weapon;
                //TODO: All of these code blocks should be functions instead;
                if (!_shot && !_no_vehicles_present) {
                    if ((!instance_exists(obj_nfort)) || flank) {
                        if (block_has_armour(enemy) || (enemy.veh_type[1] == "Defenses")) {
                            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"non-AP fallback -> armour in column {obj_ncombat.combat_debugger.resolve_label(enemy)}, firing");
                            scr_shoot(i, enemy, target_unit_index, "att", "ranged");
                            continue;
                        } else if (instance_number(obj_pnunit) > 1) { // Upstream (4bd385330): Orks retarget like everyone else
                            var x2 = enemy.x;
                            repeat (instance_number(obj_pnunit) - 1) {
                                x2 += flank == 0 ? -10 : 10;
                                enemy2 = instance_nearest(x2, y, obj_pnunit);
                                if (!target_block_is_valid(enemy2, obj_pnunit)) {
                                    continue;
                                }
                                if (range[i] < get_block_distance(enemy2)) {
                                    break;
                                }
                                if (block_has_armour(enemy2)) {
                                    scr_shoot(i, enemy2, target_unit_index, "att", "ranged");
                                    break;
                                }
                            }
                        }
                    } else {
                        enemy = instance_nearest(x, y, obj_nfort);
                        scr_shoot(i, enemy, 1, "att", "wall");
                        continue;
                    }
                }
            }
        } else {
            continue;
        }
        LOGGER.error($"{wep[i]} didn't find a valid target! This shouldn't happen!");
    }
} else if (engaged) {
    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"Engaged, attacking in melee");
    //TODO: The melee code was not refactored;
    // Melee
    for (var i = 0; i < array_length(wep); i++) {
        if (wep[i] == "" || wep_num[i] == 0 || (range[i] > 2 && floor(range[i]) == range[i])) {
            continue;
        }

        if (!flank) {
            enemy = get_rightmost();
            if (enemy == noone) {
                engaged = false;
                exit;
            }
        } else if (flank) {
            enemy = get_leftmost();
            if (enemy == noone) {
                engaged = false;
                exit;
            }
        }

        var dist = get_block_distance(enemy);
        if (dist > 1) {
            engaged = false;
            exit;
        }
    
        var _armour_piercing = false;

        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"{wep[i]}(i{i}) is striking");
        // Weapon meets preliminary checks
        if (apa[i] > 2) {
            _armour_piercing = true;
            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"melee AP=true");
        }

        if (_armour_piercing) {
            // Huff and puff and blow the wall down
            if (instance_exists(obj_nfort) && (!flank)) {
                enemy = instance_nearest(x, y, obj_nfort);
                obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"melee AP -> wall");
                scr_shoot(i, enemy, 1, "arp", "wall");
                continue;
            }

            // Check for vehicles
            if (block_has_armour(enemy)) {
                obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"melee AP -> vehicles in {obj_ncombat.combat_debugger.resolve_label(enemy)}");
                scr_shoot(i, enemy, 1, "arp", "melee");
                continue;
            } else {
                _armour_piercing = false;
                obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"melee AP -> no vehicles, falling back to infantry");
            }
        }

        if (!_armour_piercing) {
            // Check for men
            if (enemy.men > 0) {
                obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"melee -> infantry in {obj_ncombat.combat_debugger.resolve_label(enemy)}");
                scr_shoot(i, enemy, 1, "att", "melee");
                continue;
            } else if (block_has_armour(enemy)) {
                obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"melee -> armour fallback in {obj_ncombat.combat_debugger.resolve_label(enemy)}");
                scr_shoot(i, enemy, 1, "arp", "melee");
                continue;
            }
        }
    }
}

instance_activate_object(obj_pnunit);
