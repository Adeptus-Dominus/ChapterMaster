/// @mixin
function scr_enemy_ai_c() {
    var rando, contin, i;
    rando = 0;
    contin = 0;
    i = 0;

    with (obj_star) {
        if ((craftworld == 1) || (space_hulk == 1)) {
            x -= 20000;
            y -= 20000;
        }
    }

    // Orks spread
    orks_end_turn_growth();

    // traitors below here
    i = 0;
    if (array_sum(p_traitors)) {
        var traitor_system = true;
        for (i = 1; i <= planets; i++) {
            if (p_owner[i] != 10) {
                traitor_system = false;
            } else if ((p_pdf[i] > 0) || (p_guardsmen[i] > 0) || (p_orks[i] > 0) || (p_tau[i] > 0)) {
                traitor_system = false;
            }
            if (!traitor_system) {
                break;
            }
        }
        for (i = 1; i <= planets; i++) {
            contin = 0;
            rando = irandom(100) + 1; // This part handles the spreading
            // if (rando<30){
            contin = floor(random(planets)) + 1;
            repeat (30) {
                if ((p_type[contin] == "Dead") || (contin == i)) {
                    contin = floor(random(planets)) + 1;
                }
            }

            if ((p_pdf[i] > 0) || (p_guardsmen[i] > 0) || (p_orks[i] > 0) || (p_tau[i] > 0) || (p_traitors[i] < 2)) {
                contin = 500;
            }

            // if (contin<100) then show_message(string(name)+"."+string(i)+" to "+string(contin));

            if (contin < 100) {
                if ((p_traitors[i] >= 3) && (p_traitors[contin] < ceil(p_traitors[i] / 2)) && (p_type[contin] != "Dead")) {
                    p_traitors[contin] += 1;
                    contin = 500;
                }
            }
            // }

            contin = 0;
            rando = floor(random(100)) + 1; // This part handles the ship building

            if (traitor_system) {
                rando = floor(random(100)) + 1;
                // Check for industrial facilities
                if ((p_type[i] != "Dead") && (p_type[i] != "Lava")) {
                    if ((p_traitors[i] >= 2) && (p_heresy[i] >= 80)) {
                        // Have the proppa facilities and size
                        var fleet;
                        fleet = 0;
                        contin = 2;
                        if (instance_number(obj_en_fleet) == 0) {
                            contin = 3;
                        }
                        if (instance_number(obj_en_fleet) > 0) {
                            contin = 2;
                        }

                        if (instance_exists(obj_p_fleet)) {
                            var ppp;
                            ppp = instance_nearest(x, y, obj_p_fleet);
                            if ((point_distance(x, y, ppp.x, ppp.y) < 50) && (ppp.action == "")) {
                                contin = 0;
                            }
                        }

                        if (contin == 2) {
                            fleet = scr_orbiting_fleet(eFACTION.CHAOS);
                            if (fleet == "none") {
                                contin = 3;
                            } else if ((fleet.action == "") && (contin != 3)) {
                                // Increase ship number for this object?
                                if (rando <= 20) {
                                    // was 25
                                    rando = choose(1, 2, 2, 3, 3, 3, 3);
                                    if (rando == 1) {
                                        fleet.capital_number += 1;
                                    }
                                    if (rando == 2) {
                                        fleet.frigate_number += 1;
                                    }
                                    if (rando == 3) {
                                        fleet.escort_number += 1;
                                    }
                                }

                                if (fleet.image_index >= 5) {
                                    // eh heh heh
                                    var stue, stue2;
                                    stue = 0;
                                    stue2 = 0;
                                    var goood;
                                    goood = 0;

                                    with (obj_star) {
                                        if ((planets == 1) && (p_type[1] == "Dead")) {
                                            x -= 20000;
                                            y -= 20000;
                                        }
                                    }
                                    stue = instance_nearest(fleet.x, fleet.y, obj_star);
                                    with (stue) {
                                        x -= 20000;
                                        y -= 20000;
                                    }

                                    repeat (10) {
                                        if (goood == 0) {
                                            stue2 = instance_nearest(fleet.x + choose(random(400), random(400) * -1), fleet.y + choose(random(100), random(100) * -1), obj_star);
                                            if (stue2.owner != eFACTION.CHAOS) {
                                                goood = 1;
                                            }
                                            if (stue2.planets == 0) {
                                                goood = 0;
                                            }
                                            if (stue.present_fleet[10] > 0) {
                                                goood = 0;
                                            }
                                            if ((stue2.planets == 1) && (stue2.p_type[1] == "Dead")) {
                                                goood = 0;
                                            }
                                        }
                                    }
                                    fleet.action_x = stue2.x;
                                    fleet.action_y = stue2.y;
                                    with (fleet) {
                                        set_fleet_movement();
                                    }
                                    instance_activate_object(obj_star);
                                }
                            }
                        }
                        if ((contin == 3) && (rando <= 25) && ((obj_controller.chaos_fleets + 15) < instance_number(obj_star))) {
                            // Create a fleet
                            // fleet=instance_create
                            fleet = instance_create(x, y, obj_en_fleet);
                            fleet.owner = eFACTION.CHAOS;
                            fleet.sprite_index = spr_fleet_chaos;
                            fleet.image_index = 1;
                            fleet.frigate_number = 1;
                            fleet.escort_number = 2;
                            present_fleet[10] += 1;
                            obj_controller.chaos_fleets += 1;
                        }
                        /*if (fleet!=0){
		                    if (instance_exists(fleet)) then with(fleet){
		                        var ii;ii=0;ii+=capital_number;ii+=round((frigate_number/2));ii+=round((escort_number/4));
		                        if (ii<=1) then ii=1;image_index=ii;
		                    }
		                }*/
                    }
                }
            }
        }
    }

    // This is the traitors corruption code
    var boat, kay, temp5, temp6, temp7;
    boat = 0;
    kay = 0;
    temp5 = 0;
    temp6 = 0;
    temp7 = 0;

    boat = scr_orbiting_fleet(eFACTION.CHAOS);

    if ((present_fleet[10] > 0) && (present_fleet[1] + present_fleet[2] == 0) && (boat != "none") && (owner != eFACTION.CHAOS) && (planets > 0)) {
        var i = 0;
        repeat (5) {
            if ((p_type[1] != "Dead") && (p_owner[1] != 10)) {
                kay = 1;
            }
            if ((p_type[2] != "Dead") && (p_owner[2] != 10)) {
                kay = 2;
            }
            if ((p_type[3] != "Dead") && (p_owner[3] != 10)) {
                kay = 3;
            }
            if ((p_type[4] != "Dead") && (p_owner[4] != 10)) {
                kay = 4;
            }

            if ((p_type[4] == "Desert") && (p_owner[4] != 10)) {
                kay = 14;
            }
            if ((p_type[3] == "Desert") && (p_owner[3] != 10)) {
                kay = 3;
            }
            if ((p_type[2] == "Desert") && (p_owner[2] != 10)) {
                kay = 12;
            }
            if ((p_type[1] == "Desert") && (p_owner[1] != 10)) {
                kay = 1;
            }

            if ((p_type[4] == "Temperate") && (p_owner[4] != 10)) {
                kay = 4;
            }
            if ((p_type[3] == "Temperate") && (p_owner[3] != 10)) {
                kay = 3;
            }
            if ((p_type[2] == "Temperate") && (p_owner[2] != 10)) {
                kay = 2;
            }
            if ((p_type[1] == "Temperate") && (p_owner[1] != 10)) {
                kay = 1;
            }

            if ((p_type[4] == "Hive") && (p_owner[4] != 10)) {
                kay = 4;
            }
            if ((p_type[3] == "Hive") && (p_owner[3] != 10)) {
                kay = 3;
            }
            if ((p_type[2] == "Hive") && (p_owner[2] != 10)) {
                kay = 2;
            }
            if ((p_type[1] == "Hive") && (p_owner[1] != 10)) {
                kay = 1;
            }

            if (kay > 4) {
                kay = 50;
            }

            if ((kay > 0) && (kay != 50)) {
                // Ere we go!
                var cor;
                cor = floor(image_index) + 1;

                if (p_type[kay] == "Shrine") {
                    cor = round(cor / 3);
                }
                if (p_type[kay] != "Dead") {
                    alter_planet_corruption(cor, kay);
                    if ((p_heresy[kay] >= 70) && (p_traitors[kay] < 2)) {
                        p_traitors[kay] += 1;
                    }
                }
            }
            i += 1;
        } // End repeat
    } // End corruption code

    // This is the CSM landing code
    var boat, kay, temp5, temp6, temp7;
    boat = 0;
    kay = 0;
    temp5 = 0;
    temp6 = 0;
    temp7 = 0;

    boat = scr_orbiting_fleet(eFACTION.CHAOS);

    var aler = 0;
    if ((present_fleet[10] > 0) && (present_fleet[1] + present_fleet[2] == 0) && (boat != "none") && (planets > 0)) {
        var ii = 0, gud = 0;
        repeat (planets) {
            ii += 1;
            if (gud == 0) {
                if ((planets >= ii) && (p_type[ii] != "Dead") && (p_owner[ii] != 10)) {
                    gud = ii;
                }
            }
        }

        if ((gud != 0) && instance_exists(boat)) {
            if (fleet_has_cargo("csm", boat)) {
                if (p_chaos[gud] < 4) {
                    p_chaos[gud] += max(1, floor(boat.image_index * 0.5));
                    if (p_chaos[gud] > 4) {
                        p_chaos[gud] = 4;
                    }
                }
                if (p_traitors[gud] < 5) {
                    p_traitors[gud] += max(2, floor(boat.image_index * 0.5));
                    if (p_traitors[gud] > 5) {
                        p_traitors[gud] = 5;
                    }
                }
            }
        }
    } // End landing portion of code

    // Tau Here
    i = 0;

    if (array_sum(p_tau) > 0) {
        repeat (4) {
            i += 1;

            contin = 0;
            rando = floor(random(100)) + 1; // This part handles the spreading
            // if (rando<30){
            contin = floor(random(planets)) + 1;
            repeat (30) {
                if ((p_type[contin] == "Dead") || (contin == i)) {
                    contin = floor(random(planets)) + 1;
                }
            }

            if ((p_pdf[i] > 0) || (p_guardsmen[i] > 0) || (p_orks[i] > 0) || (p_traitors[i] > 0) || (p_eldar[i] > 2) || (p_tau[i] < 2)) {
                contin = 500;
            }

            // if (contin<100) then show_message(string(name)+"."+string(i)+" to "+string(contin));

            if (contin < 100) {
                if ((p_tau[i] == 3) && (p_tau[contin] < 2) && (p_type[contin] != "Dead") && (p_population[contin] > 0)) {
                    p_tau[contin] += 1;
                    contin = 500;
                }
            }
            if (contin < 100) {
                if ((p_tau[i] == 4) && (p_tau[contin] < 2) && (p_type[contin] != "Dead") && (p_population[contin] > 0)) {
                    p_tau[contin] += 1;
                    contin = 500;
                }
            }
            if (contin < 100) {
                if ((p_tau[i] == 5) && (p_tau[contin] < 3) && (p_type[contin] != "Dead") && (p_population[contin] > 0)) {
                    p_tau[contin] += 1;
                    contin = 500;
                }
            }
            if (contin < 100) {
                if ((p_tau[i] == 6) && (p_tau[contin] < 3) && (p_type[contin] != "Dead") && (p_population[contin] > 0)) {
                    p_tau[contin] += 1;
                    contin = 500;
                }
            }
            // }

            contin = 0;
            rando = floor(random(100)) + 1; // This part handles the ship building

            if ((planets == 1) && (p_owner[1] == 8)) {
                contin = 1;
            }
            if ((planets == 2) && (p_owner[1] == 8) && (p_owner[2] == 8)) {
                contin = 1;
            }
            if ((planets == 3) && (p_owner[1] == 8) && (p_owner[2] == 8) && (p_owner[3] == 8)) {
                contin = 1;
            }
            if ((planets == 4) && (p_owner[1] == 8) && (p_owner[2] == 8) && (p_owner[3] == 8) && (p_owner[4] == 8)) {
                contin = 1;
            }

            if (contin == 1) {
                if ((planets >= 1) && ((p_orks[1] > 0) || (p_traitors[1] > 0) || (p_eldar[1] > 0))) {
                    contin = 0;
                }
                if ((planets >= 2) && ((p_orks[2] > 0) || (p_traitors[2] > 0) || (p_eldar[2] > 0))) {
                    contin = 0;
                }
                if ((planets >= 3) && ((p_orks[3] > 0) || (p_traitors[3] > 0) || (p_eldar[3] > 0))) {
                    contin = 0;
                }
                if ((planets >= 4) && ((p_orks[4] > 0) || (p_traitors[4] > 0) || (p_eldar[4] > 0))) {
                    contin = 0;
                }
            }

            if (contin == 1) {
                rando = floor(random(100)) + 1;
                // Check for industrial facilities
                if ((p_type[i] != "Dead") && (p_type[i] != "Lava")) {
                    if ((p_tau[i] >= 2) && (p_influence[i][eFACTION.TAU] >= 70)) {
                        // Have the proppa facilities and size
                        var fleet;
                        fleet = 0;
                        contin = 2;
                        if (instance_number(obj_en_fleet) == 0) {
                            contin = 3;
                        }
                        if (instance_number(obj_en_fleet) > 0) {
                            contin = 2;
                        }

                        if (instance_exists(obj_p_fleet)) {
                            var ppp = instance_nearest(x, y, obj_p_fleet);
                            if ((point_distance(x, y, ppp.x, ppp.y) < 50) && (ppp.action == "")) {
                                contin = 0;
                            }
                        }

                        if (contin == 2) {
                            fleet = scr_orbiting_fleet(eFACTION.TAU);

                            if (fleet == "none") {
                                contin = 3;
                            }
                            if ((fleet != "none") && (contin != 3)) {
                                // Increase ship number for this object?
                                if ((rando <= 10) && (fleet.image_index < 5)) {
                                    rando = choose(1, 2, 2, 3, 3, 3, 3);
                                    if (rando == 1) {
                                        fleet.capital_number += 1;
                                    }
                                    if (rando == 2) {
                                        fleet.frigate_number += 1;
                                    }
                                    if (rando == 3) {
                                        fleet.escort_number += 1;
                                    }
                                }

                                if (fleet.image_index >= 5) {
                                    var kawaii, think, xx, yy;
                                    kawaii = 0;
                                    think = 0;
                                    xx = 0;
                                    yy = 0;

                                    repeat (50) {
                                        if ((think == 0) && (kawaii == 0)) {
                                            xx = x + floor(choose(random(300), random(300) * -1));
                                            yy = y + floor(choose(random(300), random(300) * -1));
                                            think = instance_nearest(xx, yy, obj_star);
                                            if ((think.owner != eFACTION.TAU) && (think.owner != eFACTION.ELDAR) && (think.present_fleet[8] + think.present_fleet[1] + think.present_fleet[2] == 0) && (think.planets > 0)) {
                                                kawaii = 1;
                                            }
                                            if ((think.owner == eFACTION.TAU) || (think.present_fleet[8] + think.present_fleet[1] + think.present_fleet[2] > 0) || (think.planets == 0)) {
                                                kawaii = 0;
                                            }
                                            if ((think.planets == 1) && (think.p_type[1] == "Dead")) {
                                                kawaii = 0;
                                            }
                                            if (think.present_fleet[8] > 0) {
                                                kawaii = 0;
                                            }

                                            if (kawaii == 0) {
                                                think = 0;
                                            }
                                        }
                                    }

                                    if ((kawaii == 1) && instance_exists(obj_crusade)) {
                                        // NOPE, stay home and defend
                                        var him, own, dis;
                                        him = instance_nearest(x, y, obj_crusade);
                                        own = him.owner;
                                        dis = him.radius;
                                        if (point_distance(x, y, him.x, him.y) <= dis) {
                                            kawaii = 0;
                                        }
                                    }
                                    if (kawaii == 1) {
                                        //Go out and take planet
                                        fleet.action_x = think.x;
                                        fleet.action_y = think.y;
                                        fleet.alarm[4] = 1;
                                    }

                                    instance_activate_object(obj_star);
                                }
                            }
                        }
                        if ((contin == 3) && (rando <= 25) && (obj_controller.tau_fleets < (obj_controller.tau_stars + 1))) {
                            // Create a fleet
                            fleet = instance_create(x, y, obj_en_fleet);
                            fleet.owner = eFACTION.TAU;
                            fleet.sprite_index = spr_fleet_tau;
                            fleet.image_index = 1;
                            fleet.capital_number = 1;
                            present_fleet[8] += 1;
                            obj_controller.tau_fleets += 1;
                        }
                        /*if (fleet!=0){
	                    if (instance_exists(fleet)) then with(fleet){
	                        var ii;ii=0;ii+=capital_number;ii+=round((frigate_number/2));ii+=round((escort_number/4));
	                        if (ii<=1) then ii=1;image_index=ii;
	                    }
	                }*/
                    }
                }
            }
        }
    }

    // Tyranids here
    var i = 0;
    repeat (planets) {
        i += 1;
        if ((p_tyranids[i] >= 5) && (planets >= i) && (p_player[i] + p_orks[i] + p_guardsmen[i] + p_pdf[i] + p_chaos[i] == 0)) {
            var ship = scr_orbiting_fleet(eFACTION.TYRANIDS);
            if ((ship != "none") && (p_type[i] != "Dead") && (array_length(p_feature[i]) != 0)) {
                if (ship.capital_number > 0) {
                    if (planet_feature_bool(p_feature[i], eP_FEATURES.RECLAMATION_POOLS) == 1) {
                        p_tyranids[i] = 0;
                        if ((p_type[i] == "Death") || (p_type[i] == "Hive")) {
                            ship.capital_number += choose(0, 1, 1);
                        }
                        ship.capital_number += 1;
                        ship.escort_number += 3;
                        ship.image_index = floor(ship.capital_number + (ship.frigate_number / 2) + (ship.escort_number / 4));
                        p_type[i] = "Dead";
                        delete_features(p_feature[i], eP_FEATURES.RECLAMATION_POOLS); // show_message("D");
                        if ((planets == 1) && (p_type[1] == "Dead")) {
                            image_alpha = 0.33;
                        }
                        if ((planets == 2) && (p_type[1] == "Dead") && (p_type[2] == "Dead")) {
                            image_alpha = 0.33;
                        }
                        if ((planets == 3) && (p_type[1] == "Dead") && (p_type[2] == "Dead") && (p_type[3] == "Dead")) {
                            image_alpha = 0.33;
                        }
                        if ((planets == 4) && (p_type[1] == "Dead") && (p_type[2] == "Dead") && (p_type[3] == "Dead") && (p_type[4] == "Dead")) {
                            image_alpha = 0.33;
                        }

                        // if image_alpha = 0.33 then send the ship somewhere new
                    }
                    if ((planet_feature_bool(p_feature[i], eP_FEATURES.CAPILLARY_TOWERS) == 1) && (p_type[i] != "Dead")) {
                        p_population[i] = floor(p_population[i] * 0.3);
                    }
                    if ((planet_feature_bool(p_feature[i], eP_FEATURES.CAPILLARY_TOWERS) == 1) && (p_type[i] != "Dead")) {
                        p_feature[i] = [];
                        array_push(p_feature[i], new NewPlanetFeature(eP_FEATURES.CAPILLARY_TOWERS), new NewPlanetFeature(eP_FEATURES.RECLAMATION_POOLS));
                        p_population[i] = 0; // show_message("C");
                    }
                    if ((planet_feature_bool(p_feature[i], eP_FEATURES.CAPILLARY_TOWERS) == 0) && (planet_feature_bool(p_feature[i], eP_FEATURES.RECLAMATION_POOLS) == 0) && (p_type[i] != "Dead")) {
                        array_push(p_feature[i], new NewPlanetFeature(eP_FEATURES.CAPILLARY_TOWERS)); // show_message("B");
                    }
                }
            }
        }
    }

    with (obj_star) {
        if (x < -10000) {
            x += 20000;
            y += 20000;
        }
        if (x < -10000) {
            x += 20000;
            y += 20000;
        }
        if (x < -10000) {
            x += 20000;
            y += 20000;
        }
    }
}
