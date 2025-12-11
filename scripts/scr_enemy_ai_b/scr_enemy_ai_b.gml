function scr_enemy_ai_b() {
    // Imperial Repleneshes numbers
    // If no enemies and guard < pop /470 then increase guardsman
    // If no enemies and population < max_pop then increase by like 1%
    var rando = 0,
        success = false,
        i = 0,
        is_garrison_force = false,
        total_garrison = 0,
        sabotage_force = false;

    i = 0;
    for (i = 1; i <= planets; i++) {
       system_datas[i].refresh_data();
       system_datas[i].end_of_turn_population_influence_and_enemy_growth();
        // if (p_heresy[i]>0) and (owner != eFACTION.Chaos) then p_heresy[i]-=2;
    }
    // Tau rebellions
    if ((present_fleet[8] >= 1) && (owner != eFACTION.Tau)) {
        var flit, ran1, ran2, tau_chance;
        flit = scr_orbiting_fleet(eFACTION.Tau);
        ran1 = 0;
        ran2 = floor(random(planets)) + 1;

        if (flit != "none") {
            ran1 = floor(random(100)) + 1;
            var tau_influence = p_influence[ran2][eFACTION.Tau];
            if (tau_influence < 90 && (p_type[ran2] != "Dead")) {
                if ((flit.image_index == 1) && (ran1 <= 90)) {
                    adjust_influence(eFACTION.Tau, choose(2, 3), ran2);
                    if ((p_type[ran2] == "Forge") && (tau_influence >= 3)) {
                        adjust_influence(eFACTION.Tau, -3, ran2);
                    }
                } else if ((flit.image_index > 1) && (flit.image_index < 4) && (ran1 <= 90)) {
                    adjust_influence(eFACTION.Tau, choose(7, 9, 11, 13), ran2);
                    if ((p_type[ran2] == "Forge") && (tau_influence >= 10)) {
                        adjust_influence(eFACTION.Tau, -10, ran2);
                    }
                } else if (flit.image_index >= 4) {
                    adjust_influence(eFACTION.Tau, choose(9, 11, 13, 15, 17), ran2);
                    if ((p_type[ran2] == "Forge") && (tau_influence >= 13)) {
                        adjust_influence(eFACTION.Tau, -13, ran2);
                    }
                }
            }
            if ((p_type[ran2] == "Lava") && (tau_influence < 90)) {
                tau_influence += 10;
            }
        }

        for (i = 1; i <= planets; i++) {
            var tau_influence = p_influence[i][eFACTION.Tau];
            tau_chance = floor(random(100)) + 1;

            if ((i <= planets) && (tau_influence >= 70) && (p_owner[i] != 8) && (p_owner[i] != 10) && (p_owner[i] != 7) && (p_owner[i] != 9) && (p_type[i] != "Space Hulk")) {
                for (var s = 1; s <= planets; s++) {
                    if (p_owner[s] == 8) {
                        tau_chance += 5;
                    }
                }

                if (flit != "none" && flit.owner == eFACTION.Tau) {
                    tau_chance += (flit.image_index * 5) - 5;
                }

                if (tau_chance >= 95) {
                    /*obj_controller.x=self.x;obj_controller.y=self.y;show_message(string(tau_chance)+" |"+string(p_orks[i])+"|"+string(p_traitors[i]));*/
                }

                if ((tau_chance >= 95) && (p_orks[i] == 0) && (p_traitors[i] == 0) && (p_necrons[i] == 0) && (p_demons[i] == 0) && (p_chaos[i] == 0)) {
                    p_owner[i] = 8;
                    if (p_guardsmen[i] > 0) {
                        p_pdf[i] += p_guardsmen[i];
                        p_guardsmen[i] = 0;
                    }

                    var targ = 0,
                        have = 0,
                        badd = 1;

                    targ = planets;
                    for (var s = 1; s <= planets; s++) {
                        if (p_type[s] == "Dead") {
                            targ -= 1;
                        }
                        if (p_owner[s] == 8) {
                            have += 1;
                        }
                    }

                    if (have == targ) {
                        badd = 2;
                    }

                    if (badd == 1) {
                        scr_alert("red", "owner", "Planet " + planet_string + " has succeeded to the Tau Empire!", x, y);
                        if (visited == 1) {
                            //visited variable checks whether the star has been visited by the chapter or not 1 for true 0 for false
                            if (p_type[i] == "Forge") {
                                dispo[i] -= 10; // 10 disposition decreases for the respective planet
                                obj_controller.disposition[eFACTION.Mechanicus] -= 10; // 10 disposition decrease for the toaster Fetishest since they aren't that many toasters in 41 millennia
                            } else if (planet_feature_bool(p_feature[i], P_features.Sororitas_Cathedral) || (p_type[i] == "Shrine")) {
                                dispo[i] -= 10; // 10 disposition decreases for the respective planet
                                obj_controller.disposition[5] -= 5;
                            } else {
                                dispo[i] -= 10;
                            } // you had only 1 job.
                        }
                    }

                    if (badd == 2) {
                        scr_popup("System Lost", $"The {name} system has been taken by the Tau Empire!", "tau", "");
                        owner = eFACTION.Tau;
                        scr_event_log("red", $"System {name} has been taken by the Tau Empire.", name);
                    }

                    if (p_pdf[i] != 0) {
                        p_pdf[i] = round(p_pdf[i] * 0.75);
                    }
                    if (p_guardsmen[i] != 0) {
                        p_guardsmen[i] = round(p_guardsmen[i] * 0.75);
                    }
                }
            }
            if ((p_owner[i] == 8) && (tau_influence < 80)) {
                if ((p_type[i] != "Forge") && (p_type[i] != "Shrine")) {
                    tau_influence += 2;
                } else if ((p_type[i] == "Forge") || (p_type[i] == "Shrine")) {
                    tau_influence += choose(0, 1);
                }
            }
        } // End repeat
    }
}
