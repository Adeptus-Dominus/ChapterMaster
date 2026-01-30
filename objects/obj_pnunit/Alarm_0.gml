try {
    // with(obj_enunit){show_message(string(dudes[1])+"|"+string(dudes_num[1])+"|"+string(men+medi)+"|"+string(dudes_hp[1]));}

    var rightest, charge = 0, enemy2 = 0; // psy=false;

    if (instance_number(obj_enunit) != 1) {
        obj_ncombat.flank_x = self.x;
        with (obj_enunit) {
            if (x < (obj_ncombat.flank_x - 20)) {
                instance_deactivate_object(id);
            }
        }
    }

    rightest = get_rightmost(); // Right most pnunit
    enemy = instance_nearest(0, y, obj_enunit); // Left most enemy
    enemy2 = enemy;

    if (obj_ncombat.dropping || (!obj_ncombat.defending && obj_ncombat.formation_set != 2)) {
        move_unit_block("east");
    }

    if (!instance_exists(enemy)) {
        engaged = false;
        exit;
    }

    engaged = collision_point(x - 14, y, obj_enunit, 0, 1) || collision_point(x + 14, y, obj_enunit, 0, 1);

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
        for (var i = 0; i < array_length(wep); i++) {
            if (wep[i] == "") {
                continue;
            }
            weapon_data = gear_weapon_data("weapon", wep[i]);
            once_only = 0;
            enemy = instance_nearest(0, y, obj_enunit);
            enemy2 = enemy;
            if (enemy.men + enemy.veh + enemy.medi <= 0) {
                var x5 = enemy.x;
                with (enemy) {
                    instance_destroy();
                }
                enemy = instance_nearest(0, y, obj_enunit);
                enemy2 = enemy;
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
                        var enemy2, g = 0, good = 0;

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
                                    enemy2 = instance_nearest(x2, y, obj_enunit);
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
                                    enemy2 = instance_nearest(x2, y, obj_enunit);
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
                        var g, good, enemy2;
                        g = 0;
                        good = 0;

                        if (enemy.men + enemy.medi > 0) {
                            good = scr_target(enemy, "men"); // First target has vehicles, blow it to hell
                            scr_shoot(i, enemy, good, "att", "ranged");
                        }
                        if ((good == 0) && (instance_number(obj_enunit) > 1)) {
                            // First target does not have vehicles, cycle through objects to find one that has vehicles
                            var x2;
                            x2 = enemy.x;
                            repeat (instance_number(obj_enunit) - 1) {
                                if (good == 0) {
                                    x2 += 10;
                                    enemy2 = instance_nearest(x2, y, obj_enunit);
                                    if ((enemy2.men > 0) && (good == 0)) {
                                        good = scr_target(enemy2, "men"); // This target has vehicles, blow it to hell
                                        scr_shoot(i, enemy2, good, "att", "ranged");
                                        once_only = 1;
                                    }
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
                    var enemy2, g = 0, good = 0;

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

                if ((enemy.veh == 0) && (enemy.medi > 0) && (once_only == 0)) {
                    // Check for vehicles
                    var enemy2, g = 0, good = 0;

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

                if ((ap == 0) && (once_only == 0)) {
                    // Check for men
                    var g = 0, good = 0, enemy2;

                    if ((enemy.men > 0) && (once_only == 0)) {
                        // show_message(string(wep[i])+" attacking");
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
    }

    instance_activate_object(obj_enunit);

    if (instance_exists(obj_enunit)) {
        for (var i = 0; i < array_length(unit_struct); i++) {
            if (marine_dead[i] == 0 && marine_casting[i] == true) {
                var caster_id = i;
                scr_powers(caster_id);
            }
        }
    }
}
// global.logger.debug($"known_powers: {known_powers}");
// global.logger.debug($"buff_powers: {buff_powers}");
// global.logger.debug($"buff_cast: {buff_cast}");
// global.logger.debug($"power_index: {power_index}");
// global.logger.debug($"known_attack_powers: {known_attack_powers}");
catch (_exception) {
    // global.logger.debug($"known_buff_powers: {known_buff_powers}");
    handle_exception(_exception);
}
