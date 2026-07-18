/// @description This alarm is responsible for the enemy target column selection

obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.SYSTEM, $"Enemy {obj_ncombat.combat_debugger.resolve_label(id)} at x={x}, flank={flank} is picking a target");

if (!instance_exists(obj_pnunit)) {
    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"No valid player blocks, exiting");
    exit;
}

enemy = flank ? get_leftmost() : get_rightmost();
if (enemy == noone || !target_block_is_valid(enemy, obj_pnunit)) {
    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"Couldn't find valid player blocks, exiting");
    exit;
}

obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"Initial target player block: {obj_ncombat.combat_debugger.resolve_label(enemy)} at x={enemy.x}");

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

        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"{wep[i]}(i{i}) is firing");

        if (range[i] == 0) {
            LOGGER.error($"{wep[i]} has broken range! This shouldn't happen! Range: {range[i]}; Ammo: {ammo[i]}; Owner: {wep_owner[i]}");
            continue;
        }

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
            enemy = instance_nearest(x, y, obj_nfort);
            dist = 2;
            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"Targeting Fort");
        } else {
            dist = get_block_distance(enemy);
        }

        var target_unit_index = 0;

        if (range[i] >= dist) {
            // The weapon is in range;
            var _target_vehicles = apa[i] > 2 ? true : false; // AP weapons target vehicles

            // Weird alpha strike mechanic, that changes target unit index to CM;
            if (((wep[i] == "Power Fist") || (wep[i] == "Bolter")) && (obj_ncombat.alpha_strike > 0) && (wep_num[i] > 5)) {
                obj_ncombat.alpha_strike -= 0.5;

                var cm_present = false;
                var cm_index = -1;
                var cm_block = noone;
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
                    } else if (instance_number(obj_pnunit) > 1) {
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
                                obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"AP -> vehicle found in next column {obj_ncombat.combat_debugger.resolve_label(enemy2)}, firing");
                                scr_shoot(i, enemy2, target_unit_index, "arp", "ranged");
                                _shot = true;
                                break;
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
                    var _column_size_value = enemy.column_size;
                    var x2 = enemy.x;

                    repeat (instance_number(obj_pnunit) - 1) {
                        x2 += !flank ? -10 : 10;
                        enemy2 = instance_nearest(x2, y, obj_pnunit);
                        if (!target_block_is_valid(enemy2, obj_pnunit)) {
                            continue;
                        }

                        if (range[i] < get_block_distance(enemy2)) {
                            break;
                        }

                        var _back_column_size_value = enemy2.column_size;

                        if (!check_column_obstruction(_column_size_value, _back_column_size_value)) {
                            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"non-AP -> infantry found in back column {obj_ncombat.combat_debugger.resolve_label(enemy2)}, firing");
                            scr_shoot(i, enemy2, target_unit_index, "att", "ranged");
                            _shot = true;
                            break;
                        } else {
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
                        } else if (instance_number(obj_pnunit) > 1) {
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
                                    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"non-AP fallback -> armour in next column {obj_ncombat.combat_debugger.resolve_label(enemy2)}, firing");
                                    scr_shoot(i, enemy2, target_unit_index, "att", "ranged");
                                    break;
                                }
                            }
                        }
                    } else {
                        enemy = instance_nearest(x, y, obj_nfort);
                        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"non-AP -> targeting fort, firing");
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
