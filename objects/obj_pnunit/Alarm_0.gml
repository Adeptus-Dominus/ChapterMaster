try {
    if (instance_number(obj_enunit) != 1) {
        obj_ncombat.flank_x = self.x;
        with (obj_enunit) {
            if (x < (obj_ncombat.flank_x - 20)) {
                instance_deactivate_object(id);
            }
        }
    }

    enemy = instance_nearest(0, y, obj_enunit); // Left most enemy

    // Ported from upstream: instance_nearest returns noone when the last enemy
    // block dies between the turn driver pulsing alarm[0] and this block's tick,
    // and reading enemy.x below then throws "Unable to find instance for object
    // index -4". Exit early; set_up_player_blocks_turn re-arms this alarm next turn.
    if (!instance_exists(enemy)) {
        engaged = false;
        exit;
    }

    // Basic combat orders: every block carries a move_order ("advance" or "hold"),
    // seeded on its first tick from the vanilla movement rule (raids and attacks
    // advance, defense and the static formation hold) and toggled by clicking the
    // block's bar (obj_pnunit Step_0). Advancing blocks may leapfrog over friendly
    // blocks directly ahead. The Defenses pseudo-block takes no orders and never
    // moves.
    if (move_order == "") {
        move_order = (obj_ncombat.dropping || (!obj_ncombat.defending && obj_ncombat.formation_set != 2)) ? "advance" : "hold";
    }
    if ((move_order == "advance") && (veh_type[1] != "Defenses")) {
        // Leapfrogging only for blocks the player has clicked (order_manual):
        // default auto-advance keeps vanilla stall behavior, otherwise same-tick
        // processing order and an engaged front line make rear blocks vault their
        // own formation with no orders given.
        move_unit_block("east", 1, false, order_manual);
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
        obj_ncombat.ktally_target = undefined;
        obj_ncombat.ktally_weapons = {};
        obj_ncombat.ktally_order = [];
        obj_ncombat.ktally_leaders = [];
        for (var i = 0; i < array_length(wep); i++) {
            // Enemies wiped before every weapon got to fire (e.g. spill-over cleared the line).
            // Report who held fire and stop, rather than swinging at empty air.
            if (!instance_exists(obj_enunit)) {
                var _held_fire = [];
                for (var hf = i; hf < array_length(wep); hf++) {
                    // Only ranged weapons "hold fire"; melee (range 1) never shoots, so skip it.
                    if (wep[hf] != "" && wep_num[hf] > 0 && range[hf] > 1) {
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
            }
            // That destroy may have removed the last active enemy block, leaving the
            // reacquire with noone; and reads on noone throw. Skip the weapon; the
            // held-fire check at the top of the next iteration reports and stops.
            if (!instance_exists(enemy)) {
                continue;
            }

            // Speed Force sweeps the whole field - bypass normal targeting/range.
            if (wep[i] == "Speed Force" || wep[i] == "Speed Force (Ranged)") {
                scr_shoot_spread(i);
                continue;
            }

            if ((range[i] >= dist) && (ammo[i] != 0 || range[i] == 1)) {
                // Guard blocks (guard > 0) keep firing their ranged weapons even when
                // engaged: Guardsmen empty lasguns and heavy bolters into the enemy at
                // point-blank, and the tank line keeps its main guns firing once a unit
                // reaches it instead of standing mute. Marines keep the vanilla rule of
                // ranged only while not engaged. The bayonet (range 1) still resolves on
                // the melee line below, so engaged Guard both shoot and stab.
                // Vehicle-only blocks (men <= 0: Whirlwinds, Land Speeders, tank
                // remnants) also keep firing when engaged: they carry no melee weapons
                // at all, so the vanilla rule left them sitting mute in contact while
                // enemy knives chip uselessly at their hulls, the last-survivors
                // stalemate the battle timer exists to paper over. A vehicle firing
                // its guns point-blank is no stranger than the Guard doing it.
                if ((range[i] != 1) && ((engaged == 0) || (guard > 0) || (men <= 0))) {
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

                if (instance_exists(enemy)) {
                    if ((obj_enunit.veh > 0) && (obj_enunit.men == 0) && (apa[i] > 10)) {
                        ap = 1;
                    }

                    if ((ap == 1) && (once_only == 0)) {
                        // Check for vehicles
                        var g = 0;

                        if (enemy.veh > 0) {
                            good = scr_target(enemy, "veh"); // First target has vehicles, blow it to hell
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
                                        good = scr_target(enemy2, "veh"); // This target has vehicles, blow it to hell
                                        scr_shoot(i, enemy2, good, "arp", "ranged");
                                        once_only = 1;
                                    }
                                }
                            }
                        }
                        if (good == 0) {
                            ap = 0;
                        } // Fuck it, shoot at infantry
                    }
                }

                if (instance_exists(enemy) && (once_only == 0)) {
                    if ((enemy.medi > 0) && (enemy.veh == 0)) {
                        good = scr_target(enemy, "medi"); // First target has vehicles, blow it to hell
                        scr_shoot(i, enemy, good, "medi", "ranged");

                        if ((good == 0) && (instance_number(obj_enunit) > 1)) {
                            // First target does not have vehicles, cycle through objects to find one that has vehicles
                            var x2 = enemy.x;
                            repeat (instance_number(obj_enunit) - 1) {
                                if (good == 0) {
                                    x2 += 10;
                                    var enemy2 = instance_nearest(x2, y, obj_enunit);
                                    if ((enemy2.veh > 0) && (good == 0)) {
                                        good = scr_target(enemy2, "medi"); // This target has vehicles, blow it to hell
                                        scr_shoot(i, enemy2, good, "medi", "ranged");
                                        once_only = 1;
                                    }
                                }
                            }
                        }
                        if (good == 0) {
                            ap = 0;
                        } // Next up is infantry
                        // Was previously ap=1;
                    }
                }

                if (instance_exists(enemy)) {
                    if ((ap == 0) && (once_only == 0)) {
                        // Check for men
                        var g = 0;
                        good = 0;

                        if (enemy.men + enemy.medi > 0) {
                            good = scr_target(enemy, "men"); // First target has infantry, engage it
                            scr_shoot(i, enemy, good, "att", "ranged");
                        }
                        if ((good == 0) && (instance_number(obj_enunit) > 1)) {
                            // Column piercing (player side), mirroring the enemy mechanic. The
                            // front enemy block has no infantry (a tank wall). Vanilla walked a
                            // 10px instance_nearest probe and fired the FULL volley at the first
                            // men-bearing block found (a free 100% pass through armour), or
                            // silently wasted the whole volley when the probe found nothing.
                            // Instead: blocks beyond the front are collected along the
                            // shooter-to-front axis (so main and flank fronts both walk the right
                            // way), sorted nearest-first; the volley pierces by depth (see
                            // PIERCE_LINE_SOAK / PIERCE_MAX_DEPTH in macros.gml), each armour
                            // line soaking a third of the original volley, the rest landing on
                            // the first infantry rank, nothing reaching past the third line.
                            var _front_x = enemy.x;
                            var _dir = sign(_front_x - x);
                            if (_dir == 0) {
                                _dir = 1;
                            }
                            var _beyond = [];
                            with (obj_enunit) {
                                if (id == other.enemy) {
                                    continue;
                                }
                                if (((x - _front_x) * _dir) <= 0) {
                                    continue;
                                }
                                array_push(_beyond, id);
                            }
                            if (_dir > 0) {
                                array_sort(_beyond, function(_a, _b) {
                                    return _a.x - _b.x;
                                });
                            } else {
                                array_sort(_beyond, function(_a, _b) {
                                    return _b.x - _a.x;
                                });
                            }
                            var _wall_blocks = [];
                            var _wall_shots = [];
                            // Lines the volley can interact with: front wall plus blocks
                            // beyond, valid and in range, capped at PIERCE_MAX_DEPTH.
                            var _lines = [enemy];
                            for (var b = 0; b < array_length(_beyond); b++) {
                                if (array_length(_lines) >= PIERCE_MAX_DEPTH) {
                                    break;
                                }
                                var enemy2 = _beyond[b];
                                if (!target_block_is_valid(enemy2, obj_enunit)) {
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
                                if (block_has_armour(_line) > 0) {
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
                                var _rank_target = scr_target(_rank_block, "men");
                                if (_rank_target != 0) {
                                    scr_shoot(i, _rank_block, _rank_target, "att", "ranged", _remaining, !_ammo_spent);
                                    _ammo_spent = true;
                                }
                                // Soaked shots chip the armour lines they bounced off.
                                for (var w = 0; w < array_length(_wall_blocks); w++) {
                                    var _w_target = scr_target(_wall_blocks[w], "veh");
                                    if (_w_target != 0) {
                                        scr_shoot(i, _wall_blocks[w], _w_target, "att", "ranged", _wall_shots[w], !_ammo_spent);
                                        _ammo_spent = true;
                                    }
                                }
                                if (_ammo_spent) {
                                    once_only = 1;
                                }
                            } else if (block_has_armour(enemy) > 0) {
                                // No infantry in range beyond the wall: the whole volley chips
                                // the wall instead of vanishing silently (vanilla fired nothing
                                // at all here and the shots were simply lost).
                                var _w_target = scr_target(enemy, "veh");
                                if (_w_target != 0) {
                                    scr_shoot(i, enemy, _w_target, "att", "ranged");
                                    once_only = 1;
                                }
                            }
                        }
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
                    // Check for vehicles
                    var g = 0, good = 0;

                    if (enemy.veh > 0) {
                        good = scr_target(enemy, "veh"); // First target has vehicles, blow it to hell
                        if (range[i] == 1) {
                            scr_shoot(i, enemy, good, "arp", "melee");
                        }
                    }
                    if (good != 0) {
                        once_only = 1;
                    }
                    if ((good == 0) && (att[i] > 0)) {
                        ap = 0;
                    } // Fuck it, shoot at infantry
                }

                // instance_exists guard: the vehicle swing above can destroy the block
                // (emptied enemy formations are destroyed immediately), and reading a
                // destroyed instance throws. The ranged chain above already carries the
                // same guards between its sub-branches; the melee chain was missing them.
                if (instance_exists(enemy) && (enemy.veh == 0) && (enemy.medi > 0) && (once_only == 0)) {
                    // Check for vehicles
                    var g = 0, good = 0;

                    if (enemy.medi > 0) {
                        good = scr_target(enemy, "medi"); // First target has vehicles, blow it to hell
                        if (range[i] == 1) {
                            scr_shoot(i, enemy, good, "medi", "melee");
                        }
                    }
                    if (good != 0) {
                        once_only = 1;
                    }
                    if ((good == 0) && (att[i] > 0)) {
                        ap = 0;
                    } // Fuck it, shoot at infantry
                }

                if ((ap == 0) && (once_only == 0) && instance_exists(enemy)) {
                    // Check for men
                    var g = 0, good = 0;

                    if ((enemy.men > 0) && (once_only == 0)) {
                        good = scr_target(enemy, "men");
                        if (range[i] == 1) {
                            scr_shoot(i, enemy, good, "att", "melee");
                        }
                    }
                    if (good != 0) {
                        once_only = 1;
                    }
                }
            }
        }
    } else {
        // The field was already clear when this block's turn came up - its whole arsenal holds fire.
        var _skipped_fire = [];
        for (var s = 0; s < array_length(wep); s++) {
            // Only ranged weapons "hold fire"; melee (range 1) never shoots, so skip it.
            if (wep[s] != "" && wep_num[s] > 0 && range[s] > 1) {
                array_push(_skipped_fire, wep[s]);
            }
        }
        report_held_fire(_skipped_fire);
    }

    combat_tally_flush();
    combat_kill_tally_flush();

    instance_activate_object(obj_enunit);

    // Safety net: drop empty/zombie formations the firing loop never reached, so a lingering corpse
    // can't keep the battle alive.
    with (obj_enunit) {
        var _alive = 0;
        for (var _rr = 1; _rr <= 30; _rr++) {
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
