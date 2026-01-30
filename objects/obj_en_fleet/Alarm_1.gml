try_and_report_loop("enemy fleet main end turn action", function() {
    var orb = orbiting;

    if ((round(owner) != eFACTION.Imperium) && (navy == 1)) {
        owner = noone;
    }

    //TODO centralise orbiting logic
    var _is_orbiting = is_orbiting();
    if (orbiting != 0 && action == "" && owner != noone) {
        var orbiting_found = _is_orbiting;
        if (orbiting_found) {
            orbiting_found = variable_instance_exists(orbiting, "present_fleet");
            if (orbiting_found) {
                orbiting.present_fleet[owner] += 1;
            }
        } else if (!orbiting_found) {
            orbiting = instance_nearest(x, y, obj_star);
            orbiting.present_fleet[owner]++;
        }
    }
    var _khorne_cargo = fleet_has_cargo("warband");
    if (_khorne_cargo && owner == eFACTION.Chaos) {
        khorne_fleet_cargo();
    }

    if (_is_orbiting) {
        turns_static++;
        if (turns_static > 5 && owner == eFACTION.Ork) {
            if (!irandom(7)) {
                ork_fleet_move();
                _is_orbiting = false;
            }
        }
        if (instance_exists(obj_crusade)) {
            try {
                fleet_respond_crusade();
            } catch (_exception) {
                handle_exception(_exception);
            }
        }
    } else {
        turns_static = 0;
    }

    var dir = 0;
    var ret = 0;

    if (navy && action == "" && _is_orbiting) {
        navy_orbiting_planet_end_turn_action();
    } else if (action == "" && _is_orbiting) {
        var max_dis = 400;

        if ((orbiting.owner == eFACTION.Player) && (obj_controller.faction_status[eFACTION.Imperium] == "War") && (owner == eFACTION.Imperium)) {
            for (var i = 1; i <= orbiting.planets; i++) {
                if (orbiting.p_owner[i] == 1) {
                    orbiting.p_pdf[i] -= capital_number * 50000;
                }
                if (orbiting.p_owner[i] == 1) {
                    orbiting.p_pdf[i] -= frigate_number * 10000;
                }
                if (orbiting.p_pdf[i] < 0) {
                    orbiting.p_pdf[i] = 0;
                }
            }
        }

        // 1355;

        if (instance_exists(obj_crusade) && (owner == eFACTION.Ork) && (orbiting.owner == eFACTION.Ork)) {
            // Ork crusade AI
            var max_dis;
            max_dis = 400;

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
            if ((ns.owner != eFACTION.Ork) && (point_distance(x, y, ns.x, ns.y) <= max_dis) && (point_distance(x, y, ns.x, ns.y) > 40) && instance_exists(obj_crusade) && (image_index > 3)) {
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

        /*if (action="") and (owner = eFACTION.Imperium){// Defend nearby systems and return when done
        
        with(obj_star){
            // 137 ; might want for it to defend under other circumstances
            if (present_fleet[8]>0) and (owner<=5) and (x>2) and (y>2) then instance_create(x,y,obj_temp3);
        }
        if (instance_number(obj_temp3)=0) then ret=1;
        if (instance_number(obj_temp3)>0){
            var you,dis,mem;
            you=instance_nearest(x,y,obj_temp3);
            dis=point_distance(x,y,you.x,you.y);
            
            if (dis<300) and (image_index>=3){
                action_x=you.x;action_y=you.y;
                home_x=instance_nearest(x,y,obj_star).x;
                home_y=instance_nearest(x,y,obj_star).y;
                set_fleet_movement();with(obj_temp3){instance_destroy();}
                exit;
            }
            if (dis>=300) then ret=1;
        }
        
        if (instance_exists(obj_crusade)){
            var cru;cru=instance_nearest(x,y,obj_crusade);
            if (cru.owner=self.owner) and (point_distance(x,y,cru.x,cru.y)<cru.radius) then ret=0;
        }
        
        if (ret=1){
            var cls;cls=instance_nearest(x,y,obj_star);
            if ((cls.x!=home_x) or (cls.y!=home_y)) and (home_x+home_y>0){
                action_x=home_x;
                action_y=home_y;
                set_fleet_movement();
            }
        }

        with(obj_temp3){instance_destroy();}
    }*/

        if (owner == eFACTION.Inquisition) {
            var valid = true;
            if (instance_exists(target)) {
                if (instance_nearest(target.x, target.y, obj_star).id != instance_nearest(x, y, obj_star).id) {
                    valid = false;
                }
            }
            if (((orbiting.owner == eFACTION.Player || system_feature_bool(orbiting.p_feature, P_features.Monastery)) || (obj_ini.fleet_type != ePlayerBase.home_world)) && (trade_goods != "cancel_inspection") && valid) {
                if (obj_controller.disposition[6] >= 60) {
                    scr_loyalty("Xeno Associate", "+");
                }
                if (obj_controller.disposition[7] >= 60) {
                    scr_loyalty("Xeno Associate", "+");
                }
                if (obj_controller.disposition[8] >= 60) {
                    scr_loyalty("Xeno Associate", "+");
                }

                if ((orbiting.p_owner[2] == 1) && (orbiting.p_heresy[2] >= 60)) {
                    scr_loyalty("Heretic Homeworld", "+");
                }

                var whom = -1;
                whom = inquisitor;
                var inquisitors = obj_controller.inquisitor;
                var inquis_string = $"Inquisitor {whom > -1 ? inquisitors[whom] : inquisitors[0]}";

                // INVESTIGATE DEAD HERE 137 ; INVESTIGATE DEAD HERE 137 ; INVESTIGATE DEAD HERE 137 ; INVESTIGATE DEAD HERE 137 ;
                var cur_star, t, type, cha, dem, tem1, tem1_base, perc, popup;
                t = 0;
                type = 0;
                cha = 0;
                dem = 0;
                tem1 = 0;
                popup = 0;
                perc = 0;
                tem1_base = 0;

                cur_star = instance_nearest(x, y, obj_star);

                if (string_count("investigate", trade_goods) > 0) {
                    // Check for xenos or demon-equip items on those planets
                    //TODO update this to check weapon or artifact tags
                    var e = 0, ia = -1, ca = 0;
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
                        inquisitor_contraband_take_popup(_cur_star, planet);
                    }
                } else if (string_count("investigate", trade_goods) == 0) {
                    inquisition_inspection_logic();
                }
                // End Test-Slave Incubator Crap

                if (obj_controller.known[eFACTION.Inquisition] == 1) {
                    obj_controller.known[eFACTION.Inquisition] = 3;
                }
                if (obj_controller.known[eFACTION.Inquisition] == 2) {
                    obj_controller.known[eFACTION.Inquisition] = 4;
                }

                orbiting = instance_nearest(x, y, obj_star);

                // 135;
                if (obj_controller.loyalty_hidden <= 0) {
                    // obj_controller.alarm[7]=1;global.defeat=2;
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
                orbiting = exit_star;
                set_fleet_movement();
                trade_goods = "|DELETE|";
                exit;
            }
        }

        if (owner == eFACTION.Tau) {
            if (instance_exists(obj_p_fleet) && (obj_controller.known[eFACTION.Tau] == 0)) {
                var p_ship = instance_nearest(x, y, obj_p_fleet);
                if ((p_ship.action == "") && (point_distance(x, y, p_ship.x, p_ship.y) <= 80)) {
                    obj_controller.known[eFACTION.Tau] = 1;
                }
            }

            /*if (image_index>=4){
            with(obj_star){
                if (owner = eFACTION.Tau) and (present_fleets>0) and (tau_fleets=0){
                    instance_create(x,y,obj_temp5);
                }
            }
            if (instance_exists(obj_temp5)){
                var wop;wop=instance_nearest(x,y,obj_temp5);
                if (wop!=0) and (point_distance(x,y,wop.x,wop.y)<300) and (wop.x>5) and (wop.y>5){
                    target_x=wop.x;target_y=wop.y;
                    home_x=x;home_y=y;
                    set_fleet_movement();
                }
            }
            with(obj_temp5){instance_destroy();}
        }*/
        }

        if (owner == eFACTION.Tyranids) {
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

            if (capital_number > 0) {
                var capitals_engaged = 0;
                with (orbiting) {
                    for (var i = 1; i < planets; i++) {
                        if (capitals_engaged == capital_number) {
                            break;
                        }
                        if (p_type[i] != "Dead") {
                            p_tyranids[4] = 5;
                            capitals_engaged += 1;
                        }
                    }
                }
            }

            var n = false;
            with (orbiting) {
                n = is_dead_star();
            }

            if (n) {
                var xx, yy, good, plin, plin2;
                xx = 0;
                yy = 0;
                good = 0;
                plin = 0;
                plin2 = 0;

                if (capital_number > 5) {
                    n = 5;
                }

                instance_deactivate_object(orbiting);

                repeat (100) {
                    if (good != 5) {
                        xx = self.x + random_range(-300, 300);
                        yy = self.y + random_range(-300, 300);
                        if (good == 0) {
                            plin = instance_nearest(xx, yy, obj_star);
                        }
                        if ((good == 1) && (n == 5)) {
                            plin2 = instance_nearest(xx, yy, obj_star);
                        }

                        good = !array_contains(plin.p_type, "dead");

                        if ((good == 1) && (n == 5)) {
                            if (!instance_exists(plin2)) {
                                exit;
                            }
                            if (!array_contains(plin.p_type, "dead")) {
                                good++;
                            }

                            var new_fleet;
                            new_fleet = instance_create(x, y, obj_en_fleet);
                            new_fleet.capital_number = floor(capital_number * 0.4);
                            new_fleet.frigate_number = floor(frigate_number * 0.4);
                            new_fleet.escort_number = floor(escort_number * 0.4);

                            capital_number -= new_fleet.capital_number;
                            frigate_number -= new_fleet.frigate_number;
                            escort_number -= new_fleet.escort_number;

                            new_fleet.owner = eFACTION.Tyranids;
                            new_fleet.sprite_index = spr_fleet_tyranid;
                            new_fleet.image_index = 1;

                            /*with(new_fleet){
                            var ii;ii=0;ii+=capital_number;ii+=round((frigate_number/2));ii+=round((escort_number/4));
                            if (ii<=1) then ii=1;image_index=ii;
                        }*/

                            new_fleet.action_x = plin2.x;
                            new_fleet.action_y = plin2.y;
                            with (new_fleet) {
                                set_fleet_movement();
                            }
                            break;
                        }

                        if ((good == 1) && instance_exists(plin)) {
                            action_x = plin.x;
                            action_y = plin.y;
                            set_fleet_movement();
                            if (n != 5) {
                                good = 5;
                            }
                        }
                    }
                }
                instance_activate_object(obj_star);
            }
        }
    }

    if ((action == "move") && (action_eta > 5000)) {
        var woop = instance_nearest(x, y, obj_star);
        if (woop.storm == 0) {
            action_eta -= 10000;
        } else {
            if (!instance_nearest(target_x, target_y, obj_star).storm) {
                action_eta -= 10000;
            }
        }
    } else if ((action == "move") && (action_eta < 5000)) {
        if (instance_nearest(action_x, action_y, obj_star).storm > 0) {
            exit;
        }
        if (action_x + action_y == 0) {
            exit;
        }

        var dos = 0;
        dos = point_distance(x, y, action_x, action_y);
        orbiting = dos / action_eta;
        dir = point_direction(x, y, action_x, action_y);

        x = x + lengthdir_x(orbiting, dir);
        y = y + lengthdir_y(orbiting, dir);

        action_eta -= 1;

        /*if (owner>5){
        
    }*/

        if ((action_eta == 2) && (owner == eFACTION.Inquisition) && (inquisitor > -1)) {
            inquisitor_ship_approaches();
        } else if (action_eta == 0) {
            action = "";
            if (array_length(complex_route) > 0) {
                var target_loc = star_by_name(complex_route[0]);
                if (target_loc != "none") {
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
});

/* */
/*  */
