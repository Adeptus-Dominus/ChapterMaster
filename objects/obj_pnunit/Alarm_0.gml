try {
    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.SYSTEM, $"Player block {obj_ncombat.combat_debugger.resolve_label(id)} at x={x} is picking a target");
    enemy = instance_nearest(0, y, obj_enunit); // Left most enemy

    if (!instance_exists(enemy)) {
        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"no enemy exists, exiting");
        engaged = false;
        exit;
    }

    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"initial target {obj_ncombat.combat_debugger.resolve_label(enemy)} at x={enemy.x}");

    if (instance_number(obj_enunit) != 1) {
        obj_ncombat.flank_x = self.x;
        with (obj_enunit) {
            if (x < (obj_ncombat.flank_x - 20)) {
                instance_deactivate_object(id);
            }
        }
    }

    if (obj_ncombat.dropping || (!obj_ncombat.defending && obj_ncombat.formation_set != 2)) {
        move_unit_block("east");
    }

    engaged = collision_point(x - 14, y, obj_enunit, 0, 1) != noone || collision_point(x + 14, y, obj_enunit, 0, 1) != noone;

    var once_only = 0;
    var range_shoot = "";
    var dist = point_distance(x, y, enemy.x, enemy.y) / 10;

    //* Psychic power buffs
    for (var i = 0; i < array_length(unit_struct); i++) {
        if (marine_mshield[i] > 0) {
            marine_mshield[i] -= 1;
        }
        if (marine_quick[i] > 0) {
            marine_quick[i] -= 1;
        }
        if (marine_might[i] > 0) {
            marine_might[i] -= 1;
        }
        if (marine_fiery[i] > 0) {
            marine_fiery[i] -= 1;
        }
        if (marine_fshield[i] > 0) {
            marine_fshield[i] -= 1;
        }
        if (marine_dome[i] > 0) {
            marine_dome[i] -= 1;
        }
        if (marine_spatial[i] > 0) {
            marine_spatial[i] -= 1;
        }
    }

    if (instance_exists(obj_enunit)) {
        obj_ncombat.ctally_target = undefined;
        obj_ncombat.ctally_bounce = [];
        obj_ncombat.ctally_injure = [];
        for (var i = 0; i < array_length(wep); i++) {
            // Enemies wiped before every weapon got to fire (e.g. spill-over cleared the line).
            // Report who held fire and stop, rather than swinging at empty air.
            if (!instance_exists(obj_enunit)) {
                var _held_fire = [];
                for (var hf = i; hf < array_length(wep); hf++) {
                    // Only ranged weapons "hold fire"; melee (range 1) never shoots, so skip it.
                    // Mirror the firing ammo gate (ammo != 0) so out-of-ammo weapons that could not
                    // have fired aren't reported as having held fire.
                    if (wep[hf] != "" && wep_num[hf] > 0 && range[hf] > 1 && ammo[hf] != 0) {
                        array_push(_held_fire, wep[hf]);
                    }
                }
                report_held_fire(_held_fire);
                break;
            }
            if (wep[i] == "") {
                continue;
            }
            once_only = 0;
            enemy = instance_nearest(0, y, obj_enunit);
            if (enemy.men + enemy.veh + enemy.medi <= 0) {
                var x5 = enemy.x;
                with (enemy) {
                    instance_destroy();
                }
                enemy = instance_nearest(0, y, obj_enunit);
                if (!instance_exists(enemy)) {
                    engaged = false;
                    break;
                }
            }

            if ((range[i] >= dist) && (ammo[i] != 0 || range[i] == 1)) {
                if ((range[i] != 1) && (engaged == 0)) {
                    range_shoot = "ranged";
                }
                if ((range[i] != floor(range[i]) || floor(range[i]) == 1) && engaged == 1) {
                    range_shoot = "melee";
                }
            }

            if ((range_shoot == "ranged") && (range[i] >= dist)) {
                // Weapon meets preliminary checks
                var ap = 0;
                var good = 0;
                if (apa[i] > att[i]) {
                    ap = 1;
                } // Determines if it is AP or not
                if (wep[i] == "Missile Launcher") {
                    ap = 1;
                }
                if (string_count("Lascan", wep[i]) > 0) {
                    ap = 1;
                }
                if ((instance_number(obj_enunit) == 1) && (obj_enunit.men == 0) && (obj_enunit.veh > 0)) {
                    ap = 1;
                }

                if ((obj_enunit.veh > 0) && (obj_enunit.men == 0) && (apa[i] > 10)) {
                    ap = 1;
                }

                if ((ap == 1) && (once_only == 0)) {
                    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"weapon[{i}] ({wep[i]}) AP -> targeting vehicles");
                    // Check for vehicles
                    if (enemy.veh > 0) {
                        good = scr_target(enemy, "veh");
                        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"weapon[{i}] scr_target(veh) -> {enemy.dudes_vehicle[good]} in {obj_ncombat.combat_debugger.resolve_label(enemy)}");
                        scr_shoot(i, enemy, good, "arp", "ranged");
                    }
                    if ((good == 0) && (instance_number(obj_enunit) > 1)) {
                        // First target does not have vehicles, cycle through objects to find one that has vehicles
                        var x2 = enemy.x;
                        repeat (instance_number(obj_enunit) - 1) {
                            if (good == 0) {
                                x2 += 10;
                                var enemy2 = instance_nearest(x2, y, obj_enunit);
                                if ((enemy2.veh > 0) && (good == 0)) {
                                    good = scr_target(enemy2, "veh");
                                    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"weapon[{i}] scr_target(veh) at next column -> {enemy2.dudes_vehicle[good]} in {obj_ncombat.combat_debugger.resolve_label(enemy2)}");
                                    scr_shoot(i, enemy2, good, "arp", "ranged");
                                    once_only = 1;
                                }
                            }
                        }
                    }
                    if (good == 0) {
                        ap = 0;
                        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"weapon[{i}] ({wep[i]}) AP -> no vehicles found, falling back to infantry");
                    }
                    if (!instance_exists(enemy)) {
                        engaged = false;
                        continue;
                    }
                }

                if (once_only == 0) {
                    if ((enemy.medi > 0) && (enemy.veh == 0)) {
                        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"weapon[{i}] ({wep[i]}) medi -> targeting monsters");
                        good = scr_target(enemy, "medi");
                        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"weapon[{i}] scr_target(medi) -> {enemy.dudes[good]} in {obj_ncombat.combat_debugger.resolve_label(enemy)}");
                        scr_shoot(i, enemy, good, "medi", "ranged");

                        if ((good == 0) && (instance_number(obj_enunit) > 1)) {
                            var x2 = enemy.x;
                            repeat (instance_number(obj_enunit) - 1) {
                                if (good == 0) {
                                    x2 += 10;
                                    var enemy2 = instance_nearest(x2, y, obj_enunit);
                                    if ((enemy2.veh > 0) && (good == 0)) {
                                        good = scr_target(enemy2, "medi");
                                        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"weapon[{i}] scr_target(medi) at next column -> {enemy2.dudes[good]} in {obj_ncombat.combat_debugger.resolve_label(enemy2)}");
                                        scr_shoot(i, enemy2, good, "medi", "ranged");
                                        once_only = 1;
                                    }
                                }
                            }
                        }
                        if (good == 0) {
                            ap = 0;
                            obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"weapon[{i}] ({wep[i]}) medi -> no monsters found, falling back to infantry");
                        }
                    }
                    if (!instance_exists(enemy)) {
                        engaged = false;
                        continue;
                    }
                }

                if ((ap == 0) && (once_only == 0)) {
                    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"weapon[{i}] ({wep[i]}) -> targeting infantry");
                    good = 0;

                    if (enemy.men + enemy.medi > 0) {
                        good = scr_target(enemy, "men");
                        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"weapon[{i}] scr_target(men) -> {enemy.dudes[good]} in {obj_ncombat.combat_debugger.resolve_label(enemy)}");
                        scr_shoot(i, enemy, good, "att", "ranged");
                    }
                    if ((good == 0) && (instance_number(obj_enunit) > 1)) {
                        var x2 = enemy.x;
                        repeat (instance_number(obj_enunit) - 1) {
                            if (good == 0) {
                                x2 += 10;
                                var enemy2 = instance_nearest(x2, y, obj_enunit);
                                if ((enemy2.men > 0) && (good == 0)) {
                                    good = scr_target(enemy2, "men");
                                    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"weapon[{i}] scr_target(men) at next column -> {enemy2.dudes[good]} in {obj_ncombat.combat_debugger.resolve_label(enemy2)}");
                                    scr_shoot(i, enemy2, good, "att", "ranged");
                                    once_only = 1;
                                }
                            }
                        }
                    }
                    if (!instance_exists(enemy)) {
                        engaged = false;
                        continue;
                    }
                }
            } else if ((range_shoot == "melee") && ((range[i] == 1) || (range[i] != floor(range[i])))) {
                // Weapon meets preliminary checks
                var ap = 0;
                if (apa[i] == 1) {
                    ap = 1;
                } // Determines if it is AP or not

                if ((enemy.men == 0) && (apa[i] == 0) && (att[i] >= 80)) {
                    apa[i] = floor(att[i] / 2);
                    ap = 1;
                }

                if ((apa[i] == 1) && (once_only == 0)) {
                    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"melee weapon[{i}] ({wep[i]}) AP -> targeting vehicles");
                    // Check for vehicles
                    var g = 0, good = 0;

                    if (enemy.veh > 0) {
                        good = scr_target(enemy, "veh");
                        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"melee scr_target(veh) -> {enemy.dudes_vehicle[good]} in {obj_ncombat.combat_debugger.resolve_label(enemy)}");
                        if (range[i] == 1) {
                            scr_shoot(i, enemy, good, "arp", "melee");
                        }
                    }
                    if (good != 0) {
                        once_only = 1;
                    }
                    if ((good == 0) && (att[i] > 0)) {
                        ap = 0;
                        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"melee weapon[{i}] AP -> no vehicles, fallback to infantry");
                    }
                    if (!instance_exists(enemy)) {
                        engaged = false;
                        continue;
                    }
                }

                if ((enemy.veh == 0) && (enemy.medi > 0) && (once_only == 0)) {
                    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"melee weapon[{i}] ({wep[i]}) -> targeting monsters");
                    var g = 0, good = 0;

                    if (enemy.medi > 0) {
                        good = scr_target(enemy, "medi");
                        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"melee scr_target(medi) -> {enemy.dudes[good]} in {obj_ncombat.combat_debugger.resolve_label(enemy)}");
                        if (range[i] == 1) {
                            scr_shoot(i, enemy, good, "medi", "melee");
                        }
                    }
                    if (good != 0) {
                        once_only = 1;
                    }
                    if ((good == 0) && (att[i] > 0)) {
                        ap = 0;
                        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"melee weapon[{i}] medi -> no monsters, fallback to infantry");
                    }
                    if (!instance_exists(enemy)) {
                        engaged = false;
                        continue;
                    }
                }

                if ((ap == 0) && (once_only == 0)) {
                    obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"melee weapon[{i}] ({wep[i]}) -> targeting infantry");
                    var good = 0;

                    if ((enemy.men > 0) && (once_only == 0)) {
                        good = scr_target(enemy, "men");
                        obj_ncombat.combat_debugger.add(eCOMBAT_CATEGORY.TARGETING, $"melee scr_target(men) -> {enemy.dudes[good]} in {obj_ncombat.combat_debugger.resolve_label(enemy)}");
                        if (range[i] == 1) {
                            scr_shoot(i, enemy, good, "att", "melee");
                        }
                    }
                    if (good != 0) {
                        once_only = 1;
                    }
                    if (!instance_exists(enemy)) {
                        engaged = false;
                        continue;
                    }
                }
            }
        }
    } else {
        // The field was already clear when this block's turn came up - its whole arsenal holds fire.
        var _skipped_fire = [];
        for (var s = 0; s < array_length(wep); s++) {
            // Only ranged weapons "hold fire"; melee (range 1) never shoots, so skip it.
            // Mirror the firing ammo gate (ammo != 0) so out-of-ammo weapons that could not have
            // fired aren't reported as having held fire.
            if (wep[s] != "" && wep_num[s] > 0 && range[s] > 1 && ammo[s] != 0) {
                array_push(_skipped_fire, wep[s]);
            }
        }
        report_held_fire(_skipped_fire);
    }

    combat_tally_flush();

    instance_activate_object(obj_enunit);

    // Safety net: drop empty/zombie formations the firing loop never reached, so a lingering corpse
    // can't keep the battle alive.
    with (obj_enunit) {
        var _alive = 0;
        for (var _rr = 1; _rr < array_length(dudes_num); _rr++) {
            if (dudes_num[_rr] > 0 && dudes_hp[_rr] > 0) {
                _alive += dudes_num[_rr];
            }
        }
        if ((_alive == 0) && (owner != 1)) {
            instance_destroy();
        }
    }

    if (instance_exists(obj_enunit)) {
        // Accumulate this formation's attack casts, then emit one summary line per power instead
        // of one line per Librarian (see flush_psychic_summary in scr_powers).
        var _psy_log = {};
        for (var i = 0; i < array_length(unit_struct); i++) {
            if (marine_dead[i] == 0 && marine_casting[i] == true) {
                var caster_id = i;
                scr_powers(caster_id, _psy_log);
            }
        }
        flush_psychic_summary(_psy_log);
    }
}
catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
}
