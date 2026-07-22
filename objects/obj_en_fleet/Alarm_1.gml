try {
    var orb = orbiting;

    if ((round(owner) != eFACTION.IMPERIUM) && (navy == 1)) {
        owner = 0;
    }

    if (action == "" && owner != 0) {
        fleet_register_at_nearest_star(id);
    }
    var _khorne_cargo = fleet_has_cargo("warband");
    if (_khorne_cargo && owner == eFACTION.CHAOS) {
        khorne_fleet_cargo();
    }

    if (instance_exists(orbiting)) {
        turns_static++;
        if (turns_static > 5 && owner == eFACTION.ORK) {
            if (!irandom(7)) {
                ork_fleet_move();
            }
        }
        if (instance_exists(obj_crusade)) {
            try {
                fleet_respond_crusade();
            } catch (_exception) {
                ERROR_HANDLER.handle_exception(_exception);
            }
        }
    } else {
        turns_static = 0;
    }

    var dir = 0;

    if (navy && action == "" && instance_exists(orbiting)) {
        navy_orbiting_planet_end_turn_action();
    } else if (action == "" && instance_exists(orbiting)) {
        var max_dis = 400;

        if ((orbiting.owner == eFACTION.PLAYER) && (obj_controller.faction_status[eFACTION.IMPERIUM] == "War") && (owner == eFACTION.IMPERIUM)) {
            for (var i = 1; i <= orbiting.planets; i++) {
                if (orbiting.p_owner[i] == eFACTION.PLAYER) {
                    orbiting.p_pdf[i] -= capital_number * 50000;
                }
                if (orbiting.p_owner[i] == eFACTION.PLAYER) {
                    orbiting.p_pdf[i] -= frigate_number * 10000;
                }
                if (orbiting.p_pdf[i] < 0) {
                    orbiting.p_pdf[i] = 0;
                }
            }
        }

        if (instance_exists(obj_crusade) && (owner == eFACTION.ORK) && (orbiting.owner == eFACTION.ORK)) {
            // Ork crusade AI
            var fleet_owner = owner;
            with (obj_crusade) {
                if (owner != fleet_owner) {
                    x -= 40000;
                }
            }

            with (obj_star) {
                var ns = instance_nearest(x, y, obj_crusade);
                if (point_distance(x, y, ns.x, ns.y) > ns.radius) {
                    x -= 40000;
                }
                if (owner == ns.owner) {
                    x -= 40000;
                }
            }

            var ns = instance_nearest(x, y, obj_star);
            if ((ns.owner != eFACTION.ORK) && (point_distance(x, y, ns.x, ns.y) <= max_dis) && (point_distance(x, y, ns.x, ns.y) > 40) && instance_exists(obj_crusade) && (image_index > 3)) {
                action_x = ns.x;
                action_y = ns.y;
                set_fleet_movement();
                home_x = orbiting.x;
                home_y = orbiting.y;
                exit;
            }

            with (obj_star) {
                if (x < -30000) {
                    x += 40000;
                }
                if (x < -30000) {
                    x += 40000;
                }
                if (x < -30000) {
                    x += 40000;
                }
            }
            with (obj_crusade) {
                if (x < -30000) {
                    x += 40000;
                }
                if (x < -30000) {
                    x += 40000;
                }
                if (x < -30000) {
                    x += 40000;
                }
            }
        }

        instance_activate_object(obj_star);
        instance_activate_object(obj_crusade);
        instance_activate_object(obj_en_fleet);

        if (owner == eFACTION.INQUISITION) {
            var valid = true;
            if (instance_exists(target)) {
                if (instance_nearest(target.x, target.y, obj_star).id != instance_nearest(x, y, obj_star).id) {
                    valid = false;
                }
            }
            if (((orbiting.owner == eFACTION.PLAYER || system_feature_bool(orbiting.p_feature, eP_FEATURES.MONASTERY)) || (obj_ini.fleet_type != ePLAYER_BASE.HOME_WORLD)) && (trade_goods != "cancel_inspection") && valid) {
                if (obj_controller.disposition[6] >= 60) {
                    scr_loyalty("Xeno Associate", "+");
                }
                if (obj_controller.disposition[7] >= 60) {
                    scr_loyalty("Xeno Associate", "+");
                }
                if (obj_controller.disposition[8] >= 60) {
                    scr_loyalty("Xeno Associate", "+");
                }

                if ((orbiting.p_owner[2] == eFACTION.PLAYER) && (orbiting.p_heresy[2] >= 60)) {
                    scr_loyalty("Heretic Homeworld", "+");
                }

                var whom = inquisitor;
                var inquisitors = obj_controller.inquisitor;
                var inquis_string = $"Inquisitor {whom > -1 ? inquisitors[whom] : inquisitors[0]}";

                // INVESTIGATE DEAD HERE 137 ; INVESTIGATE DEAD HERE 137 ; INVESTIGATE DEAD HERE 137 ; INVESTIGATE DEAD HERE 137 ;
                var t = 0;
                var type = 0;
                var cha = 0;
                var dem = 0;
                var tem1 = 0;
                var popup = 0;
                var perc = 0;
                var tem1_base = 0;

                var cur_star = instance_nearest(x, y, obj_star);

                if (string_count("investigate", trade_goods) > 0) {
                    // Check for xenos or demon-equip items on those planets
                    //TODO update this to check weapon or artifact tags
                    var e = 0;
                    var ia = -1;
                    var ca = 0;
                    var _unit;
                    repeat (4400) {
                        if ((ca <= 10) && (ca >= 0)) {
                            ia += 1;
                            if (ia == 400) {
                                ca += 1;
                                ia = 1;
                                if (ca == 11) {
                                    ca = -5;
                                }
                            }
                            if ((ca >= 0) && (ca < 11)) {
                                _unit = fetch_unit([ca, ia]);
                                if ((_unit.location_string == cur_star.name) && (_unit.planet_location > 0)) {
                                    if ((_unit.role() == "Ork Sniper") && (obj_ini.race[ca][ia] != 1)) {
                                        tem1_base = 3;
                                    }
                                    if ((_unit.role() == "Flash Git") && (obj_ini.race[ca][ia] != 1)) {
                                        tem1_base = 3;
                                    }
                                    if ((_unit.role() == "Ranger") && (obj_ini.race[ca][ia] != 1)) {
                                        tem1_base = 3;
                                    }
                                    if (_unit.equipped_artifact_tag("daemon")) {
                                        tem1_base += 3;
                                        dem += 1;
                                    }
                                }
                            }
                        }
                    }
                    repeat (cur_star.planets) {
                        t += 1;
                        inquisitor_contraband_take_popup(cur_star, t);
                    }
                } else if (string_count("investigate", trade_goods) == 0) {
                    inquisition_inspection_logic();
                }
                // End Test-Slave Incubator Crap

                if (obj_controller.known[eFACTION.INQUISITION] == 1) {
                    obj_controller.known[eFACTION.INQUISITION] = 3;
                }
                if (obj_controller.known[eFACTION.INQUISITION] == 2) {
                    obj_controller.known[eFACTION.INQUISITION] = 4;
                }

                if (obj_controller.loyalty_hidden <= 0) {
                    var moo = false;
                    if ((obj_controller.penitent == 1) && (moo == false)) {
                        obj_controller.alarm[8] = 1;
                        moo = true;
                    }
                    if ((obj_controller.penitent == 0) && (moo == false)) {
                        scr_audience(4, "loyalty_zero", 0, "", 0, 0);
                    }
                }

                exit_star = distance_removed_star(x, y, choose(2, 3, 4));
                action_x = exit_star.x;
                action_y = exit_star.y;
                set_fleet_movement();
                trade_goods = "|DELETE|";
                exit;
            }
        }

        if (owner == eFACTION.TAU) {
            if (instance_exists(obj_p_fleet) && (obj_controller.known[eFACTION.TAU] == 0)) {
                var p_ship = instance_nearest(x, y, obj_p_fleet);
                if ((p_ship.action == "") && (point_distance(x, y, p_ship.x, p_ship.y) <= 80)) {
                    obj_controller.known[eFACTION.TAU] = 1;
                }
            }
        }

        if (owner == eFACTION.TYRANIDS) {
            // Juggle bio-resources
            if (capital_number * 2 > frigate_number) {
                capital_number -= 1;
                frigate_number += 2;
            }

            if (capital_number * 4 > escort_number) {
                var rand;
                rand = choose(1, 2, 3, 4);
                if (rand == 4) {
                    escort_number += 1;
                }
            }

            // ENGAGE: the Hive Fleet devours the worlds it's orbiting: seed the swarm
            // on up to capital_number food worlds so the biomass engine strips them over
            // the coming turns, even after the fleet moves on. (Replaces the old
            // p_tyranids[4]=5 engage, a hard-coded-index bug.)
            if (capital_number > 0 && instance_exists(orbiting)) {
                tyranid_fleet_engage(orbiting, capital_number);
            }

            // MIGRATE: only once this system is STRIPPED — every world a Dead husk with no
            // population and no biomass reserve left — does the tendril advance to the nearest
            // system with un-eaten worlds. The fleet sits over the whole meal rather than seeding
            // and wandering off, so a world the player still holds keeps the swarm besieging it.
            // (Old trigger was is_dead_star(), which the biomass system never sets, so the swarm
            // never spread at all.)
            if (instance_exists(orbiting) && !tyranid_system_needs_fleet(orbiting)) {
                tyranid_fleet_migrate(id);
            }
        }
    }

    if ((action == "move") && (action_eta > 5000)) {
        var woop = instance_nearest(x, y, obj_star);
        if (woop.storm == 0) {
            action_eta = max(1, action_eta - 10000);
        } else {
            if (!instance_nearest(target_x, target_y, obj_star).storm) {
                action_eta = max(1, action_eta - 10000);
            }
        }
    } else if ((action == "move") && (action_eta <= 5000)) {
        if (instance_nearest(action_x, action_y, obj_star).storm > 0) {
            exit;
        }
        if (action_x + action_y == 0) {
            exit;
        }

        var dos = 0;
        dos = point_distance(x, y, action_x, action_y);
        var _move_step = dos / max(1, action_eta); // keep the fork's div-by-zero guard on upstream's rename
        dir = point_direction(x, y, action_x, action_y);

        x = x + lengthdir_x(_move_step, dir);
        y = y + lengthdir_y(_move_step, dir);

        action_eta -= 1;

        if ((action_eta == 2) && (owner == eFACTION.INQUISITION) && (inquisitor > -1)) {
            inquisitor_ship_approaches();
        } else if (action_eta == 0) {
            action = "";
            if (array_length(complex_route) > 0) {
                var target_loc = find_star_by_name(complex_route[0]);
                if (target_loc != noone) {
                    array_delete(complex_route, 0, 1);
                    action_x = target_loc.x;
                    action_y = target_loc.y;
                    target = target_loc;
                    set_fleet_movement(false);
                } else {
                    complex_route = [];
                    fleet_arrival_logic();
                }
            } else {
                fleet_arrival_logic();
            }
        }
    }
} catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
}
