/// @mixin
function scr_enemy_ai_a() {
    system_garrison = [];
    system_sabatours = [];
    system_datas = [0];

    for (var i = 1; i <= planets; i++) {
        array_push(system_datas, new PlanetData(i, self));
    }
    // guardsmen hop from planet to planet
    //not sure we really need this as it's handled with tht navy fleet functions but fuck it updated it and leaving it fot the sec
    if (system_guard_total() > 0 && present_fleet[eFACTION.IMPERIUM]) {
        global.logger.debug($"system_has_guard {p_guardsmen}");
        var cur_planet = 0, most_enemies_found = 0, current_guard_planet = 0, most_enemies_planet = 0;

        var _guard_planets = guard_find_planet_with_most_enemy_forces(self);

        if (_guard_planets[0] > 0 && _guard_planets[1] > 0) {
            var _next = _guard_planets[0];
            var _current = _guard_planets[1];
            p_guardsmen[_next] = p_guardsmen[_current];
            p_guardsmen[_current] = 0;
        }
        global.logger.debug($"system_has_guard {p_guardsmen}");
    }

    if ((obj_controller.faction_defeated[10] > 0) && (obj_controller.faction_gender[10] == 2)) {
        var cur_planet = 0;
        repeat (planets) {
            cur_planet += 1;
            if (array_length(p_feature[cur_planet]) != 0) {
                if ((planet_feature_bool(p_feature[cur_planet], eP_FEATURES.CHAOSWARBAND) == 1) && (p_chaos[cur_planet] <= 0)) {
                    delete_features(p_feature[cur_planet], eP_FEATURES.CHAOSWARBAND);
                }
            }
        }
    }

    // checking for inquisition dead world inspections here
    if (present_fleet[eFACTION.PLAYER] >= 0 && !present_fleet[eFACTION.INQUISITION]) {
        inquisitor_inspect_base();
    }

    var stop;
    var rand = 0;
    var garrison_force = false, total_garrison = 0;
    var _planet_data;
    for (var _run = 1; _run <= planets; _run++) {
        _planet_data = system_datas[_run];
        garrison_force = false;
        var garrison = new GarrisonForce(p_operatives[_run], true);
        var sabatours = new GarrisonForce(p_operatives[_run], true, "sabotage");
        _planet_data.garrison = garrison;
        _planet_data.sabatours = sabatours;

        garrison_force = garrison.garrison_force;
        array_push(system_garrison, garrison);
        array_push(system_sabatours, sabatours);

        stop = 0;
        ensure_no_planet_negatives(_run);

        planet_forces = _planet_data.planet_forces;

        var present_forces = [];
        for (var i = 0; i < array_length(planet_forces); i++) {
            if (planet_forces[i] > 0) {
                array_push(present_forces, i);
            }
        }

        if (array_length(present_forces) == 1 && !p_pdf[_run]) {
            // if there is only one faction with present forces the planet belongs ot that faction
            p_owner[_run] = present_forces[0];
            stop = 1;
            continue;
        } else if ((planet_forces[eFACTION.PLAYER] <= 0) && (planet_forces[eFACTION.ORK] > 0)) {
            //orks prevail  over other factions
            if (p_owner[_run] == 2 || p_owner[_run] == 6) {
                p_owner[_run] = eFACTION.ORK;
            }
        }
        if (!stop) {
            stop = _planet_data.continue_to_planet_battle(stop);
            if (stop) {
                continue;
            }
        }
        var large = 0;
        var guard_score = 0;
        var pdf_score = 0;
        var eldar_score = 0;

        var guard_attack = "", pdf_attack = "", ork_attack = "", tau_attack = "", traitors_attack = "", csm_attack = "";
        var eldar_attack = "", tyranids_attack = "", necrons_attack = "", sisters_attack = "";

        var traitors_score = p_traitors[_run];
        var csm_score = p_chaos[_run];
        var tyranids_score = p_tyranids[_run];
        var necrons_score = p_necrons[_run];
        var sisters_score = p_sisters[_run];
        // if (p_eldar[_run]>0) then eldar_score=p_eldar[_run]+1;

        if ((p_tyranids[_run] > 0) && (stop != 1) && (p_owner[_run] != 9)) {
            // This might have been causing the problem
            /*if (p_tyranids[_run]<5) and (p_guardsmen[_run]>0){
	            if (p_tyranids[_run]=4) then p_guardsmen[_run]=max(0,p_guardsmen[_run]-100000);
	            if (p_tyranids[_run]=3) then p_guardsmen[_run]=max(0,p_guardsmen[_run]-20000);
	            if (p_tyranids[_run]=2) then p_guardsmen[_run]=max(0,p_guardsmen[_run]-5000);
	            if (p_tyranids[_run]=1) then p_guardsmen[_run]=max(0,p_guardsmen[_run]-500);
	        }*/
            if (p_tyranids[_run] >= 5) {
                tyranids_score = 7;
            }
        }
        var pdf_with_player = _planet_data.pdf_will_support_player();
        var pdf_loss_reduction = _planet_data.pdf_loss_reduction_calc(); //redues man loss from battle loss if higher defences

        if (!stop) {
            guard_score = _planet_data.guard_score_calc();
        }
        if ((p_guardsmen[_run] > 0) && (stop != 1)) {
            guard_score = _planet_data.guard_score_calc();
            guard_attack = _planet_data.guard_attack_matrix();

            if (guard_attack == "tyranids") {
                tyranids_score = p_tyranids[_run];
            }
            // Tend to prioritize traitors > Orks > Tau
            // Eldar don't get into pitched battles so nyuck nyuck nyuck
        }
        if (_planet_data.pdf > 0 && !stop) {
            var pdf_mod;
            var defence_mult = _planet_data.fortification_level * 0.1;

            try {
                if (pdf_with_player && garrison_force) {
                    //if player supports give garrison bonus
                    pdf_score = determine_pdf_defence(_planet_data.pdf, garrison, _planet_data.fortification_level)[0];
                } else {
                    pdf_score = determine_pdf_defence(_planet_data.pdf,, _planet_data.fortification_level)[0];
                }
            } catch (_exception) {
                handle_exception(_exception, "Pdf defence error",, $"{_run}");
            }
            //
            // if (p_eldar[_run]>0) and (p_owner[_run]!=6) then pdf_attack="eldar";
            pdf_attack = _planet_data.pdf_attack_matrix();
        }

        if ((p_sisters[_run] > 0) && (stop != 1)) {
            // THEY MARCH FOR THE ECCLESIARCHY
            if ((p_player[_run] > 0) && (obj_controller.faction_status[5] == "War")) {
                sisters_attack = "player";
            } else {
                if (p_tau[_run] > 0) {
                    sisters_attack = "tau";
                }
                if (p_orks[_run] > 0) {
                    sisters_attack = "ork";
                }
                if (p_necrons[_run] > 0) {
                    sisters_attack = "necrons";
                }
                if ((p_pdf[_run] > 0) && (p_owner[_run] == 8)) {
                    sisters_attack = "pdf";
                }
                if ((p_pdf[_run] > 0) && (p_owner[_run] == 1) && (obj_controller.faction_status[5] == "War")) {
                    sisters_attack = "pdf";
                }
                if (p_traitors[_run] > 0) {
                    sisters_attack = "traitors";
                }
                if (p_chaos[_run] > 0) {
                    sisters_attack = "csm";
                }
                if ((p_player[_run] > 0) && (obj_controller.faction_status[5] == "War")) {
                    sisters_attack = "player";
                }
                // Always goes after traitors first
                if (sisters_attack == "tyranids") {
                    tyranids_score = p_tyranids[_run];
                }
            }
        }

        if ((p_orks[_run] > 0) && (stop != 1)) {
            if ((p_traitors[_run] == 0) && (p_tau[_run] == 0) && (p_eldar[_run] == 0)) {
                ork_attack = "imp";
            }
            rand = choose(1, 2, 3, 4, 5);
            // if (rand=1) and (ork_attack="imp") then ork_attack="imp";
            if ((ork_attack == "imp") && (p_guardsmen[_run] > 0)) {
                ork_attack = "guard";
            }

            if ((rand == 2) && (p_tau[_run] > 0)) {
                ork_attack = "tau";
            }
            if ((rand == 3) && (p_traitors[_run] > 0)) {
                ork_attack = "traitors";
            }
            if ((rand == 4) && (p_chaos[_run] > 0)) {
                ork_attack = "csm";
            }
            if ((rand == 5) && (p_sisters[_run] > 0)) {
                ork_attack = "sisters";
            }
            // if (rand=5) and (p_necrons[_run]>0) then ork_attack="necrons";

            if ((ork_attack == "") && (p_player[_run] > 0)) {
                ork_attack = "player";
            }
        }

        if ((p_traitors[_run] > 0) && (stop != 1)) {
            if ((planet_forces[eFACTION.ORK] == 0) && (planet_forces[eFACTION.TAU] == 0)) {
                traitors_attack = "imp";
            }
            if ((planet_forces[eFACTION.ORK] > planet_forces[eFACTION.TAU]) && (planet_forces[eFACTION.ORK] > guard_score) && (planet_forces[eFACTION.ORK] > pdf_score)) {
                traitors_attack = "orks";
            }
            if ((sisters_score > planet_forces[eFACTION.TAU]) && (sisters_score > planet_forces[eFACTION.ORK]) && (sisters_score > pdf_score)) {
                traitors_attack = "sisters";
            }
            if ((guard_score > planet_forces[eFACTION.TAU]) && (guard_score > planet_forces[eFACTION.ORK])) {
                traitors_attack = "imp";
            }
            if ((traitors_attack == "") && (p_player[_run] > 0)) {
                traitors_attack = "player";
            }
        }
        if ((p_chaos[_run] > 0) && (stop != 1)) {
            if ((planet_forces[eFACTION.ORK] == 0) && (planet_forces[eFACTION.TAU] == 0)) {
                csm_attack = "imp";
            }
            if ((planet_forces[eFACTION.ORK] > planet_forces[eFACTION.TAU]) && (planet_forces[eFACTION.ORK] > guard_score) && (planet_forces[eFACTION.ORK] > pdf_score)) {
                csm_attack = "orks";
            }
            if ((sisters_score > planet_forces[eFACTION.TAU]) && (sisters_score > planet_forces[eFACTION.ORK]) && (sisters_score > pdf_score)) {
                csm_attack = "sisters";
            }
            if ((guard_score > planet_forces[eFACTION.TAU]) && (guard_score > planet_forces[eFACTION.ORK])) {
                csm_attack = "imp";
            }
            if ((csm_attack == "") && (p_player[_run] > 0)) {
                csm_attack = "player";
            }
        }

        if ((p_tau[_run] > 0) && (stop != 1) && (p_owner[_run] != 8)) {
            // They don't own the planet, go ham
            // if (eldar_score>0) then tau_attack="eldar";
            if (guard_score > 0) {
                tau_attack = "imp";
            }
            if (traitors_score > 0) {
                tau_attack = "traitors";
            }
            if (csm_score > 0) {
                tau_attack = "csm";
            }
            if (planet_forces[eFACTION.ORK] > 0) {
                tau_attack = "ork";
            }
            if ((traitors_score >= 3) && (planet_forces[eFACTION.ORK] <= 2)) {
                tau_attack = "traitors";
            }
            if (traitors_score >= 4) {
                tau_attack = "traitors";
            }
            if ((csm_score >= 3) && (planet_forces[eFACTION.ORK] <= 2)) {
                tau_attack = "csm";
            }
            if (csm_score >= 4) {
                tau_attack = "csm";
            }
            if (planet_forces[eFACTION.ORK] >= 4) {
                tau_attack = "ork";
            }
            if ((tau_attack == "") && (p_sisters[_run] > 0)) {
                tau_attack = "sisters";
            }
            if ((tau_attack == "") && (obj_controller.faction_status[8] == "War") && (p_player[_run] > 0)) {
                tau_attack = "player";
            }
        }
        if ((p_tau[_run] > 0) && (stop != 1) && (p_owner[_run] == 8)) {
            // They own the planet
            // if (eldar_score>0) then tau_attack="eldar";
            if (traitors_score > 0) {
                tau_attack = "traitors";
            }
            if (planet_forces[eFACTION.ORK] > 0) {
                tau_attack = "ork";
            }
            if (guard_score > 0) {
                tau_attack = "imp";
            }
            if (traitors_score >= 4) {
                tau_attack = "traitors";
            }
            if (csm_score >= 4) {
                tau_attack = "csm";
            }
            if (planet_forces[eFACTION.ORK] >= 4) {
                tau_attack = "ork";
            }
            if ((tau_attack == "") && (p_sisters[_run] > 0)) {
                tau_attack = "sisters";
            }
            if ((tau_attack == "") && (obj_controller.faction_status[8] == "War") && (p_player[_run] > 0)) {
                tau_attack = "player";
            }
        }

        if (((p_tyranids[_run] >= 4) || (guard_attack == "tyranids")) && (stop != 1)) {
            if ((p_traitors[_run] == 0) && (p_tau[_run] == 0) && (p_eldar[_run] == 0) && (p_orks[_run] == 0)) {
                tyranids_attack = "imp";
            }

            rand = choose(1, 2, 3, 4, 5, 6);
            if ((rand == 1) && (tyranids_attack == "imp")) {
                tyranids_attack = "imp";
            }
            if ((rand == 2) && (p_tau[_run] > 0)) {
                tyranids_attack = "tau";
            }
            if ((rand == 3) && (p_traitors[_run] > 0)) {
                tyranids_attack = "traitors";
            }
            if ((rand == 4) && (p_orks[_run] > 0)) {
                tyranids_attack = "orks";
            }
            if ((rand == 5) && (p_chaos[_run] > 0)) {
                tyranids_attack = "csm";
            }
            if ((rand == 6) && (p_sisters[_run] > 0)) {
                tyranids_attack = "sisters";
            }

            if ((tyranids_attack == "") && (p_player[_run] > 0)) {
                tyranids_attack = "player";
            }
        }

        if ((p_necrons[_run] > 0) && (stop != 1)) {
            if ((p_traitors[_run] == 0) && (p_tau[_run] == 0) && (p_eldar[_run] == 0) && (p_orks[_run] == 0) && (p_chaos[_run] == 0)) {
                necrons_attack = "imp";
            }

            rand = choose(1, 2, 3, 4, 5, 6);
            if ((rand == 1) && (necrons_attack == "imp")) {
                necrons_attack = "imp";
            }
            if ((rand == 2) && (p_tau[_run] > 0)) {
                necrons_attack = "tau";
            }
            if ((rand == 3) && (p_traitors[_run] > 0)) {
                necrons_attack = "traitors";
            }
            if ((rand == 4) && (p_orks[_run] > 0)) {
                necrons_attack = "orks";
            }
            if ((rand == 5) && (p_chaos[_run] > 0)) {
                necrons_attack = "csm";
            }
            if ((rand == 6) && (p_sisters[_run] > 0)) {
                necrons_attack = "sisters";
            }

            if ((necrons_attack == "") && (p_player[_run] > 0)) {
                necrons_attack = "player";
            }
        }

        if (!stop) {
            // Start stop

            default_imperium_attack = guard_score > 0 && !((guard_score <= 0.5) && (pdf_score > 0)) ? "guard" : "pdf";

            if (ork_attack == "imp") {
                ork_attack = default_imperium_attack;
            }

            if (traitors_attack == "imp") {
                traitors_attack = default_imperium_attack;
            }

            if (csm_attack == "imp") {
                csm_attack = default_imperium_attack;
            }

            if (necrons_attack == "imp") {
                necrons_attack = default_imperium_attack;
            }

            if (tau_attack == "imp") {
                tau_attack = default_imperium_attack;
            } // if (tau_attack="imp") and (guard_score<=0) then tau_attack="pdf";

            if ((sisters_attack == "imp") && (pdf_score > 0)) {
                sisters_attack = "pdf";
            }

            // if (eldar_attack="imp") and (guard_score>0) then eldar_attack="guard";if (eldar_attack="imp") and (guard_score<=0) then eldar_attack="pdf";

            // if (eldar_attack="guard") and ((guard_score<=0.5) and (pdf_score>1)) then eldar_attack="pdf";

            // if ((traitors_attack="guard") or (traitors_attack="pdf")) and (traitors_score>=3){obj_controller.x=self.x;obj_controller.y=self.y;}

            var after_combat_guard = guard_score;
            var after_combat_guard_count = p_guardsmen[_run];
            var after_combat_pdf = pdf_score;
            var after_combat_ork_force = planet_forces[eFACTION.ORK];
            var after_combat_tau = planet_forces[eFACTION.TAU];
            var after_combat_traitor = traitors_score;
            var after_combat_csm = csm_score;
            if (csm_score == 6.1) {
                csm_score = 8;
            }
            var after_combat_necrons = necrons_score;
            var after_combat_tyranids = tyranids_score;
            var after_combat_sisters = sisters_score;
            var tempor = 0, rand1 = 0, rand2 = 0;

            var _active_garrison = pdf_with_player && garrison.viable_garrison > 0;
            // Guard attack
            if ((guard_score > 0) && (guard_attack != "") && (guard_score > 0.5)) {
                global.logger.debug($"{name}:{guard_attack}");
                if (guard_attack == "ork") {
                    tempor = choose(1, 2, 3, 4, 5, 6) * planet_forces[eFACTION.ORK];
                }
                if (guard_attack == "tau") {
                    tempor = choose(1, 2, 3, 4, 5, 6) * planet_forces[eFACTION.TAU];
                }
                if (guard_attack == "traitors") {
                    tempor = choose(1, 2, 3, 4, 5, 6) * traitors_score;
                }
                if (guard_attack == "csm") {
                    tempor = choose(2, 3, 4, 5, 6, 7) * csm_score;
                }
                if (guard_attack == "tyranids") {
                    tempor = choose(2, 3, 4, 5, 6, 7) * tyranids_score;
                }

                rand1 = choose(1, 2, 3, 4, 5) * guard_score;

                if ((guard_attack == "ork") && (planet_forces[eFACTION.ORK] > guard_score)) {
                    rand1 = 0;
                }
                if ((guard_attack == "tau") && (planet_forces[eFACTION.TAU] > guard_score)) {
                    rand1 = 0;
                }
                if ((guard_attack == "traitors") && (traitors_score > guard_score)) {
                    rand1 = 0;
                }
                if ((guard_attack == "csm") && (csm_score > guard_score)) {
                    rand1 = 0;
                }
                if ((guard_attack == "tyranids") && (tyranids_score > guard_score)) {
                    rand1 = 0;
                }

                if (guard_attack == "pdf") {
                    if (pdf_with_player) {
                        pdf_mod = irandom_range(1, 6 + garrison.total_garrison * 0.1);
                    } else {
                        pdf_mod = irandom(5) + 1;
                    }
                    rand1 = (choose(3, 4, 5, 6) * guard_score) * choose(1, 1.25, 1.25);
                    rand2 = (pdf_mod * pdf_score) * choose(1, 1.25);
                    global.logger.debug($"{name} guard attack guard_Win:{rand1 > rand2}");
                    if (rand1 > rand2) {
                        var _pdf_before = p_pdf[_run];
                        if (guard_score <= 3) {
                            p_pdf[_run] = floor(p_pdf[_run] * min(0.95, 0.7 + pdf_loss_reduction));
                        }
                        if (guard_score >= 4) {
                            p_pdf[_run] = floor(p_pdf[_run] * min(0.95, 0.55 + pdf_loss_reduction));
                        }
                        if ((guard_score >= 4) && (p_pdf[_run] < 30000)) {
                            p_pdf[_run] *= min(0.95, 1 + pdf_loss_reduction);
                        }
                        if ((guard_score >= 3) && (p_pdf[_run] < 10000)) {
                            p_pdf[_run] *= min(0.95, 0 + pdf_loss_reduction);
                        }
                        if ((guard_score >= 2) && (p_pdf[_run] < 2000)) {
                            p_pdf[_run] = 0;
                        }
                        if ((guard_score >= 1) && (p_pdf[_run] < 200)) {
                            p_pdf[_run] = 0;
                        }
                        if (_planet_data.population_influences[eFACTION.TYRANIDS] > 50 && _planet_data.has_feature(eP_FEATURES.GENE_STEALER_CULT)) {
                            var _cur_influ = p_influence[_run][eFACTION.TYRANIDS];
                            var _influence_reduction = _cur_influ * (p_pdf[_run] / _pdf_before);
                            adjust_influence(eFACTION.TYRANIDS, -min(_influence_reduction, _cur_influ - 3), _run);
                            if (p_influence[_run][eFACTION.TYRANIDS] < 20) {
                                _planet_data.delete_feature(eP_FEATURES.GENE_STEALER_CULT);
                            }
                        }
                    }
                    if ((p_pdf[_run] == 0) && pdf_with_player) {
                        if ((!_planet_data.has_feature(eP_FEATURES.MONASTERY)) && (p_player[_run] <= 0)) {
                            p_owner[_run] = 2;
                            dispo[_run] = -50;
                        }
                    }
                }
                if ((guard_attack != "pdf") && (rand1 > tempor)) {
                    if (guard_attack == "ork") {
                        after_combat_ork_force -= 1;
                    }
                    if (guard_attack == "tau") {
                        after_combat_tau -= 1;
                    }
                    if (guard_attack == "traitors") {
                        after_combat_traitor -= 1;
                    }
                    if (guard_attack == "csm") {
                        after_combat_csm -= 1;
                    }
                    if (guard_attack == "tyranids") {
                        after_combat_tyranids -= 1;
                    }
                }
            }

            // PDF attack
            if (((pdf_score > 0) && (pdf_attack != "")) || ((pdf_score > 1) && (guard_score < 0.5))) {
                if (pdf_attack == "ork") {
                    tempor = planet_forces[eFACTION.ORK];
                }
                if (pdf_attack == "tau") {
                    tempor = planet_forces[eFACTION.TAU];
                }
                if (pdf_attack == "traitors") {
                    tempor = traitors_score;
                }
                if (pdf_attack == "csm") {
                    tempor = csm_score;
                }
                if (pdf_attack == "guard") {
                    tempor = guard_score;
                }
                if (pdf_attack == "tyranids") {
                    tempor = tyranids_score;
                }
                if (pdf_attack == "sisters") {
                    tempor = sisters_score;
                }

                rand1 = floor(random(pdf_score + tempor + 2));

                rand2 = choose(1, 1, 2);
                if ((pdf_attack == "ork") && (planet_forces[eFACTION.ORK] >= 3) && (pdf_score <= 2)) {
                    rand2 = 1;
                }
                if ((pdf_attack == "traitors") && (traitors_score >= 6)) {
                    rand2 = 1;
                }
                if ((pdf_attack == "csm") && (csm_score >= 3)) {
                    rand2 = 1;
                }
                if ((pdf_attack == "tyranids") && (tyranids_score >= pdf_score)) {
                    rand2 = 1;
                }
                if ((pdf_attack == "sisters") && (traitors_score >= 5)) {
                    rand2 = 1;
                }

                if ((rand1 <= pdf_score) && (rand2 == 2)) {
                    tempor -= 1;
                }
                if ((tempor == 1) && (pdf_score >= 6) && (rand2 == 2)) {
                    tempor = 0;
                }

                if (pdf_attack == "ork") {
                    after_combat_ork_force = tempor;
                }
                if (pdf_attack == "tau") {
                    after_combat_tau = tempor;
                }
                if (pdf_attack == "traitors") {
                    after_combat_traitor = tempor;
                }
                if (pdf_attack == "csm") {
                    after_combat_csm = tempor;
                }
                if ((pdf_attack == "tyranids") && (tyranids_score >= 4)) {
                    after_combat_tyranids = tempor;
                }
                if (pdf_attack == "sisters") {
                    after_combat_sisters = tempor;
                }

                if (pdf_attack == "guard") {
                    rand2 = (choose(1, 2, 3, 4, 5, 6) * guard_score) * choose(1, 1.25, 2);
                    global.logger.debug($"{name} : pdf attack ,pdf win {rand1 > rand2}");
                    if (rand1 > rand2) {
                        if (pdf_score <= 3) {
                            p_guardsmen[_run] = floor(p_guardsmen[_run] * 0.7);
                        }
                        if (pdf_score >= 4) {
                            p_guardsmen[_run] = floor(p_guardsmen[_run] * 0.6);
                        }
                        if ((pdf_score >= 4) && (p_guardsmen[_run] < 15000)) {
                            p_guardsmen[_run] = 0;
                        }
                        if ((pdf_score >= 3) && (p_guardsmen[_run] < 5000)) {
                            p_guardsmen[_run] = 0;
                        }
                    }
                }
            }

            // sisters attack
            if ((sisters_score > 0) && (sisters_attack != "") && (sisters_attack != "player")) {
                rand1 = choose(2, 3, 4, 5, 6) * sisters_score;

                if (sisters_attack == "tau") {
                    rand2 = (choose(2, 3, 4, 5) * planet_forces[eFACTION.TAU]) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_tau -= 1;
                    }
                } else if (sisters_attack == "ork") {
                    rand2 = (choose(2, 3, 4, 5) * planet_forces[eFACTION.ORK]) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_ork_force -= 1;
                    }
                } else if (sisters_attack == "traitors") {
                    rand2 = (choose(1, 2, 3, 4, 5) * traitors_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_traitor -= 1;
                    }
                } else if (sisters_attack == "csm") {
                    rand2 = (choose(2, 3, 4, 5, 6) * csm_score) * choose(1, 1.25);
                    if (csm_score == 6.1) {
                        rand2 = 999;
                    }
                    if (rand1 > rand2) {
                        after_combat_csm -= 1;
                    }
                } else if (sisters_attack == "necrons") {
                    rand2 = (choose(4, 5, 6, 7) * necrons_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_necrons -= 1;
                    }
                } else if (sisters_attack == "tyranids") {
                    rand2 = (choose(3, 4, 5, 6, 7) * tyranids_score) * choose(1, 1.25);
                    if ((rand1 > rand2) && (tyranids_score >= 4)) {
                        after_combat_tyranids -= 1;
                    }
                } else if (sisters_attack == "pdf") {
                    rand2 = (choose(1, 2, 3, 4, 5) * pdf_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        if (csm_score >= 6) {
                            p_pdf[_run] = 0;
                        }
                        if (csm_score <= 3) {
                            p_pdf[_run] = floor(p_pdf[_run] * min(0.95, 0.75 + pdf_loss_reduction));
                        }
                        if (csm_score >= 4) {
                            p_pdf[_run] = floor(p_pdf[_run] * min(0.95, 0.65 + pdf_loss_reduction));
                        }
                        if ((csm_score >= 4) && (p_pdf[_run] < 60000)) {
                            p_pdf[_run] = 0;
                        }
                        if ((csm_score >= 3) && (p_pdf[_run] < 20000)) {
                            p_pdf[_run] = 0;
                        }
                        if ((csm_score >= 2) && (p_pdf[_run] < 3000)) {
                            p_pdf[_run] = 0;
                        }
                        if ((csm_score >= 1) && (p_pdf[_run] < 1000)) {
                            p_pdf[_run] = 0;
                        }
                    }
                }
            }

            // Tau attack
            if ((planet_forces[eFACTION.TAU] > 0) && (tau_attack != "") && (tau_attack != "player")) {
                rand1 = choose(1, 2, 3, 4, 5, 6) * planet_forces[eFACTION.TAU];

                if (tau_attack == "ork") {
                    rand2 = (choose(1, 2, 3, 4, 5, 6) * planet_forces[eFACTION.ORK]) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_ork_force -= 1;
                    }
                } else if (tau_attack == "traitors") {
                    rand2 = (choose(1, 2, 3, 4, 5, 6) * traitors_score) * choose(1, 1.25);
                    if ((rand1 > rand2) && (traitors_score != 7)) {
                        after_combat_traitor -= 1;
                    }
                } else if (tau_attack == "csm") {
                    rand2 = (choose(1, 2, 3, 4, 5, 6) * csm_score) * choose(1, 1.25);
                    if (csm_score == 6.1) {
                        rand2 = 999;
                    }
                    if (rand1 > rand2) {
                        after_combat_csm -= 1;
                    }
                } else if (tau_attack == "guard") {
                    rand2 = (choose(1, 2, 3, 4, 5, 6) * guard_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        if (planet_forces[eFACTION.TAU] <= 3) {
                            p_guardsmen[_run] = floor(p_guardsmen[_run] * 0.7);
                        }
                        if (planet_forces[eFACTION.TAU] >= 4) {
                            p_guardsmen[_run] = floor(p_guardsmen[_run] * 0.6);
                        }
                    }
                } else if (tau_attack == "pdf") {
                    rand2 = (choose(1, 2, 3, 4, 5, 6) * pdf_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        if (planet_forces[eFACTION.TAU] <= 3) {
                            p_pdf[_run] = floor(p_pdf[_run] * min(0.95, 0.7 + pdf_loss_reduction));
                        }
                        if (planet_forces[eFACTION.TAU] >= 4) {
                            p_pdf[_run] = floor(p_pdf[_run] * min(0.95, 0.55 + pdf_loss_reduction));
                        }
                    }
                } else if (tau_attack == "sisters") {
                    rand2 = (choose(1, 2, 3, 4, 5, 6) * sisters_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_sisters -= 1;
                    }
                }
            }

            // ork attack
            if ((planet_forces[eFACTION.ORK] > 0) && (ork_attack != "") && (ork_attack != "player")) {
                rand1 = choose(1, 2, 3, 4, 5, 6) * planet_forces[eFACTION.ORK];

                if (ork_attack == "tau") {
                    rand2 = (choose(1, 2, 3, 4, 5, 6) * planet_forces[eFACTION.TAU]) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_tau -= 1;
                    }
                } else if (ork_attack == "traitors") {
                    rand2 = (choose(1, 2, 3, 4, 5, 6, 7) * traitors_score) * choose(1, 1.25);
                    if ((rand1 > rand2) && (traitors_score < 6)) {
                        after_combat_traitor -= 1;
                    }
                } else if (ork_attack == "csm") {
                    rand2 = (choose(1, 2, 3, 4, 5, 6) * csm_score) * choose(1, 1.25);
                    if ((rand1 > rand2) && (csm_score != 6)) {
                        after_combat_csm -= 1;
                    }
                } else if (ork_attack == "guard") {
                    var onc = 0;
                    rand2 = (choose(1, 2, 3, 4, 5, 6) * guard_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        if ((planet_forces[eFACTION.ORK] <= 3) && (onc == 0)) {
                            p_guardsmen[_run] = floor(p_guardsmen[_run] * min(0.95, 0.7 + pdf_loss_reduction));
                            onc = 1;
                        }
                        if ((planet_forces[eFACTION.ORK] >= 4) && (onc == 0)) {
                            p_guardsmen[_run] = floor(p_guardsmen[_run] * min(0.95, 0.55 + pdf_loss_reduction));
                            onc = 1;
                        }
                        if ((planet_forces[eFACTION.ORK] >= 4) && (p_guardsmen[_run] < 15000) && (onc == 0)) {
                            p_guardsmen[_run] = 0;
                            onc = 1;
                        }
                        if ((planet_forces[eFACTION.ORK] >= 3) && (p_guardsmen[_run] < 5000) && (onc == 0)) {
                            p_guardsmen[_run] = 0;
                            onc = 1;
                        }
                    }
                } else if (ork_attack == "pdf") {
                    var pdf_random = choose(1, 2, 3, 4, 5, 6);
                    rand2 = pdf_random * pdf_score;
                    if (rand1 > rand2) {
                        _planet_data.pdf_defence_loss_to_orks();

                        if (_active_garrison) {
                            var tixt = $"Chapter Forces led by {garrison.garrison_leader.name_role()} on {name} {scr_roman_numerals()[_run - 1]} were unable to secure PDF victory chapter support requested";
                            if (garrison.garrison_sustain_damages("loose") > 0) {
                                tixt += $". {garrison.garrison_sustain_damages("loose")} Marines Lost";
                            }
                            scr_alert("red", "owner", tixt, x, y);
                            //garrison.determine_battle(false,rand2-rand1, eFACTION.ORK);
                        }
                    } else {
                        if (_active_garrison) {
                            var tixt = $"Chapter Forces led by {garrison.garrison_leader.name_role()} on {name} {scr_roman_numerals()[_run - 1]} secure PDF victory";
                            if (garrison.garrison_sustain_damages("win") > 0) {
                                tixt += $". {garrison.garrison_sustain_damages("win")} Marines Lost";
                            }
                            scr_alert("green", "owner", tixt, x, y);
                        }
                    }
                    if ((p_pdf[_run] == 0) && (p_player[_run] <= 0)) {
                        var badd = 1;

                        if ((array_sum(p_pdf) == 0) && (p_guardsmen[1] + p_guardsmen[2] + p_guardsmen[3] + p_guardsmen[4] == 0)) {
                            badd = 2;
                        }

                        if (owner <= 5) {
                            if ((badd == 1) && (p_tyranids[_run] == 0) && (p_necrons[_run] == 0) && (p_sisters[_run] == 0)) {
                                scr_alert("red", "owner", string(name) + " " + string(_run) + " has been overwhelmed by Orks!", x, y);
                                if (visited == 1) {
                                    //visited variable check whether the star has been visisted or not 1 for true 0 for false
                                    if (p_type[_run] == "Forge") {
                                        dispo[_run] -= 5; // 10 Disposition decrease for the planet govrnor if it's overrun by orks
                                        obj_controller.disposition[3] -= 5; // obj_controller.disposition[3] refer to the disposition of the toaster jocks.
                                    } else if (planet_feature_bool(p_feature[_run], eP_FEATURES.SORORITAS_CATHEDRAL) || (p_type[_run] == "Shrine")) {
                                        dispo[_run] -= 10; // diso[_run] is the disposition of the planet. where _run refer to the planet that is currently running the code.
                                        obj_controller.disposition[5] -= 3; // obj_controller.disposition[2] refer to the disposition of the sororitas while 3 refer to mechanicus
                                    } else {
                                        dispo[_run] -= 5;
                                    }
                                }
                            } // diso[_run] is the disposition of the planet. where _run refer to the planet that is currently running the code.
                            if ((badd == 2) && (p_tyranids[_run] == 0) && (p_necrons[_run] == 0) && (p_sisters[_run] == 0)) {
                                scr_popup("System Lost", "The " + string(name) + " system has been ovewhelmed by Orks!", "orks", "");
                                scr_event_log("red", "System " + string(name) + " has been overwhelmed by Orkz.", name);
                                // owner=7;p_owner[1]=7;p_owner[2]=7;p_owner[3]=7;p_owner[4]=7;
                            }
                        }
                    }
                }
                if (ork_attack == "sisters") {
                    rand2 = (choose(1, 2, 3, 4, 5, 6) * sisters_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_sisters -= 1;
                    }
                }
            }

            // traitors attack
            if ((traitors_score > 0) && (traitors_attack != "") && (traitors_attack != "player")) {
                rand1 = choose(1, 2, 3, 4, 5, 6, 7) * traitors_score;
                if (traitors_score == 6) {
                    rand1 = choose(30, 36);
                } else if (traitors_score == 7) {
                    rand1 = 999;
                }

                if (traitors_attack == "tau") {
                    rand2 = (choose(1, 2, 3, 4, 5) * planet_forces[eFACTION.TAU]) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_tau -= 1;
                    }
                } else if (traitors_attack == "ork") {
                    rand2 = (choose(1, 2, 3, 4, 5) * planet_forces[eFACTION.ORK]) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_ork_force -= 1;
                    }
                } else if (traitors_attack == "guard") {
                    /*if (traitors_attack="eldar"){
	            rand2=(choose(1,2,3,4,5)*eldar_score)*choose(1,1.25);
	            if (rand1>rand2) then after_combat_csm-=1;
	        }*/
                    rand2 = (choose(1, 2, 3, 4, 5) * guard_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        if (traitors_score <= 3) {
                            p_guardsmen[_run] = floor(p_guardsmen[_run] * 0.7);
                        }
                        if (traitors_score >= 4) {
                            p_guardsmen[_run] = floor(p_guardsmen[_run] * 0.6);
                        }
                        if (traitors_score >= 6) {
                            p_guardsmen[_run] = floor(p_guardsmen[_run] * 0.3);
                        }
                        if ((traitors_score >= 4) && (p_guardsmen[_run] < 15000)) {
                            p_guardsmen[_run] = 0;
                        }
                        if ((traitors_score >= 3) && (p_guardsmen[_run] < 5000)) {
                            p_guardsmen[_run] = 0;
                        }
                        if ((traitors_score >= 2) && (p_guardsmen[_run] < 1000)) {
                            p_guardsmen[_run] = 0;
                        }
                        if ((traitors_score >= 1) && (p_guardsmen[_run] < 500)) {
                            p_guardsmen[_run] = 0;
                        }
                    }
                } else if (traitors_attack == "pdf") {
                    rand2 = (choose(1, 2, 3, 4, 5) * pdf_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        if (traitors_score >= 6) {
                            p_pdf[_run] = 0;
                        }
                        if (traitors_score <= 3) {
                            p_pdf[_run] = floor(p_pdf[_run] * min(0.95, 0.75 + pdf_loss_reduction));
                        }
                        if (traitors_score >= 4) {
                            p_pdf[_run] = floor(p_pdf[_run] * min(0.95, 0.55 + pdf_loss_reduction));
                        }
                        if ((traitors_score >= 4) && (p_pdf[_run] < 60000)) {
                            p_pdf[_run] = 0;
                        }
                        if ((traitors_score >= 3) && (p_pdf[_run] < 20000)) {
                            p_pdf[_run] = 0;
                        }
                        if ((traitors_score >= 2) && (p_pdf[_run] < 3000)) {
                            p_pdf[_run] = 0;
                        }
                        if ((traitors_score >= 1) && (p_pdf[_run] < 1000)) {
                            p_pdf[_run] = 0;
                        }
                    }
                } else if (traitors_attack == "sisters") {
                    rand2 = (choose(1, 2, 3, 4, 5, 6, 7) * sisters_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_sisters -= 1;
                    }
                }
            }

            // CSM attack
            if ((csm_score > 0) && (csm_attack != "") && (csm_attack != "player")) {
                rand1 = choose(2, 3, 4, 5, 6, 7) * csm_score;
                if (csm_score >= 5) {
                    rand1 = choose(30, 36);
                }

                if (csm_attack == "tau") {
                    rand2 = (choose(1, 2, 3, 4, 5) * planet_forces[eFACTION.TAU]) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_tau -= 1;
                    }
                } else if (csm_attack == "ork") {
                    rand2 = (choose(1, 2, 3, 4, 5) * planet_forces[eFACTION.ORK]) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_ork_force -= 1;
                    }
                } else if (csm_attack == "guard") {
                    rand2 = (choose(1, 2, 3, 4, 5) * guard_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        if (csm_score <= 3) {
                            p_guardsmen[_run] = floor(p_guardsmen[_run] * 0.7);
                        }
                        if (csm_score >= 4) {
                            p_guardsmen[_run] = floor(p_guardsmen[_run] * 0.6);
                        }
                        if (csm_score >= 6) {
                            p_guardsmen[_run] = floor(p_guardsmen[_run] * 0.3);
                        }
                        if ((csm_score >= 4) && (p_guardsmen[_run] < 15000)) {
                            p_guardsmen[_run] = 0;
                        }
                        if ((csm_score >= 3) && (p_guardsmen[_run] < 5000)) {
                            p_guardsmen[_run] = 0;
                        }
                        if ((csm_score >= 2) && (p_guardsmen[_run] < 1000)) {
                            p_guardsmen[_run] = 0;
                        }
                        if ((csm_score >= 1) && (p_guardsmen[_run] < 500)) {
                            p_guardsmen[_run] = 0;
                        }
                    }
                } else if (csm_attack == "pdf") {
                    rand2 = (choose(1, 2, 3, 4, 5) * pdf_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        if (csm_score >= 6) {
                            p_pdf[_run] = 0;
                        }
                        if (csm_score <= 3) {
                            p_pdf[_run] = floor(p_pdf[_run] * min(0.95, 0.75 + pdf_loss_reduction));
                        }
                        if (csm_score >= 4) {
                            p_pdf[_run] = floor(p_pdf[_run] * min(0.95, 0.55 + pdf_loss_reduction));
                        }
                        if ((csm_score >= 4) && (p_pdf[_run] < 60000)) {
                            p_pdf[_run] = 0;
                        }
                        if ((csm_score >= 3) && (p_pdf[_run] < 20000)) {
                            p_pdf[_run] = 0;
                        }
                        if ((csm_score >= 2) && (p_pdf[_run] < 3000)) {
                            p_pdf[_run] = 0;
                        }
                        if ((csm_score >= 1) && (p_pdf[_run] < 1000)) {
                            p_pdf[_run] = 0;
                        }
                    }
                } else if (csm_attack == "sisters") {
                    rand2 = (choose(2, 3, 4, 5, 6) * sisters_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_sisters -= 1;
                    }
                }
            }

            // Tyranids attack
            if (((tyranids_score > 4) || (guard_attack == "tyranids")) && (tyranids_attack != "") && (tyranids_attack != "player")) {
                // if (tyranids_score>4) and (tyranids_attack!="") and (tyranids_attack!="player"){
                rand1 = choose(3, 4, 5, 6, 7) * tyranids_score;
                if (tyranids_score >= 6) {
                    rand1 = choose(30, 36);
                }

                if (tyranids_attack == "tau") {
                    rand2 = (choose(1, 2, 3, 4, 5) * planet_forces[eFACTION.TAU]) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_tau -= 1;
                    }
                } else if (tyranids_attack == "ork") {
                    rand2 = (choose(1, 2, 3, 4, 5) * planet_forces[eFACTION.ORK]) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_ork_force -= 1;
                    }
                } else if (tyranids_attack == "csm") {
                    rand2 = (choose(1, 2, 3, 4, 5) * csm_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_csm -= 1;
                    }
                } else if (tyranids_attack == "traitors") {
                    rand2 = (choose(1, 2, 3, 4, 5) * traitors_score) * choose(1, 1.25);
                    if ((rand1 > rand2) && (traitors_score != 7)) {
                        after_combat_traitor -= 1;
                    }
                } else if (tyranids_attack == "imp") {
                    if (p_pdf[_run] > 0) {
                        tyranids_attack = "pdf";
                    }
                    if (p_guardsmen[_run] > 0) {
                        tyranids_attack = "guard";
                    }
                } else if (tyranids_attack == "guard") {
                    rand1 = (choose(1, 2, 3, 4, 5, 6, 7) * tyranids_score) * choose(1, 1.25);
                    rand2 = (choose(1, 2, 3, 4, 5) * guard_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        /*if (tyranids_score<=3) then p_guardsmen[_run]=floor(p_guardsmen[_run]*0.6);
	                if (tyranids_score>=4) then p_guardsmen[_run]=floor(p_guardsmen[_run]*0.5);*/
                        var onh = 0;
                        if ((tyranids_score == 1) && (onh == 0)) {
                            p_guardsmen[_run] -= 2000;
                            onh = 1;
                        }
                        if ((tyranids_score == 2) && (onh == 0)) {
                            p_guardsmen[_run] -= 30000;
                            onh = 1;
                        }
                        if ((tyranids_score == 3) && (onh == 0)) {
                            p_guardsmen[_run] -= 100000;
                            onh = 1;
                        }
                        if ((tyranids_score == 4) && (onh == 0)) {
                            p_guardsmen[_run] -= 500000;
                            onh = 1;
                        }
                        if ((tyranids_score >= 4) && (onh == 0) && (p_guardsmen[_run] <= 15000)) {
                            p_guardsmen[_run] = 0;
                            onh = 1;
                        }
                        if ((tyranids_score >= 5) && (onh == 0)) {
                            p_guardsmen[_run] -= max(floor(p_guardsmen[_run] * 0.2), 2000000);
                            onh = 1;
                        }
                        // if (tyranids_score>=6) and (onh=0){p_guardsmen[_run]=floor(p_guardsmen[_run]*0.2);onh=1;}

                        if (p_guardsmen[_run] < 0) {
                            p_guardsmen[_run] = 0;
                        }
                    }
                } else if (tyranids_attack == "pdf") {
                    rand2 = (choose(1, 2, 3, 4, 5) * pdf_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        if (tyranids_score >= 6) {
                            p_pdf[_run] = 0;
                        }
                        if (tyranids_score <= 3) {
                            p_pdf[_run] = floor(p_pdf[_run] * min(0.95, 0.4 + pdf_loss_reduction));
                        }
                        if (tyranids_score >= 4) {
                            p_pdf[_run] = floor(p_pdf[_run] * min(0.95, 0.2 + pdf_loss_reduction));
                        }
                        if ((tyranids_score >= 4) && (p_pdf[_run] < 60000)) {
                            p_pdf[_run] = 0;
                        }
                    }
                } else if (tyranids_attack == "sisters") {
                    rand2 = (choose(1, 2, 3, 4, 5) * sisters_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_sisters -= 1;
                    }
                }
            }

            // Necrons attack
            if ((necrons_score > 0) && (necrons_attack != "") && (necrons_attack != "player")) {
                rand1 = choose(3, 4, 5, 6, 7) * necrons_score;
                if (necrons_score >= 6) {
                    rand1 = choose(30, 36);
                }

                if (necrons_attack == "tau") {
                    rand2 = (choose(1, 2, 3, 4, 5) * planet_forces[eFACTION.TAU]) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_tau -= 1;
                    }
                } else if (necrons_attack == "ork") {
                    rand2 = (choose(1, 2, 3, 4, 5) * planet_forces[eFACTION.ORK]) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_ork_force -= 1;
                    }
                } else if (necrons_attack == "csm") {
                    rand2 = (choose(1, 2, 3, 4, 5) * csm_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_csm -= 1;
                    }
                } else if (necrons_attack == "traitors") {
                    rand2 = (choose(1, 2, 3, 4, 5) * traitors_score) * choose(1, 1.25);
                    if ((rand1 > rand2) && (traitors_score != 7)) {
                        after_combat_csm -= 1;
                    }
                } else if (necrons_attack == "imp") {
                    if (p_pdf[_run] > 0) {
                        necrons_attack = "pdf";
                    }
                    if (p_guardsmen[_run] > 0) {
                        necrons_attack = "guard";
                    }
                } else if (necrons_attack == "guard") {
                    rand2 = (choose(1, 2, 3, 4, 5) * guard_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        if (necrons_score <= 3) {
                            p_guardsmen[_run] = floor(p_guardsmen[_run] * 0.6);
                        } else if (necrons_score >= 6) {
                            p_guardsmen[_run] = floor(p_guardsmen[_run] * 0.2);
                        } else if (necrons_score >= 4) {
                            if (p_guardsmen[_run] < 15000) {
                                p_guardsmen[_run] = 0;
                            } else {
                                p_guardsmen[_run] = floor(p_guardsmen[_run] * 0.5);
                            }
                        }
                    }
                } else if (necrons_attack == "pdf") {
                    rand2 = (choose(1, 2, 3, 4, 5) * pdf_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        if (necrons_score >= 6) {
                            p_pdf[_run] = 0;
                        }
                        if (necrons_score <= 3) {
                            p_pdf[_run] = floor(p_pdf[_run] * min(0.95, 0.4 + pdf_loss_reduction));
                        }
                        if (necrons_score >= 4) {
                            p_pdf[_run] = floor(p_pdf[_run] * min(0.95, 0.2 + pdf_loss_reduction));
                        }
                        if ((necrons_score >= 4) && (p_pdf[_run] < 60000)) {
                            p_pdf[_run] = 0;
                        }
                    }

                    if ((p_pdf[_run] == 0) && (p_player[_run] <= 0) && (p_necrons[_run] > 0)) {
                        var _system_overrun = false;

                        if (!array_sum(p_pdf, 0, 1, planets) && !array_sum(p_guardsmen, 0, 1, planets)) {
                            _system_overrun = true;
                        }

                        if ((!_system_overrun) && (p_tyranids[_run] < 5) && (p_orks[_run] == 0) && (p_traitors[_run] == 0)) {
                            scr_alert("red", "owner", $"{_planet_data.name()} has been overwhelmed by Necrons!", x, y);
                            if (visited == 1) {
                                if (p_type[_run] == "Forge") {
                                    //visited variable check whether the star has been visisted or not 1 for true 0 for false
                                    dispo[_run] -= 10; // 10 Disposition decrease for the planet govrnor if it's overrun by necrons
                                    obj_controller.disposition[3] -= 10; // 10 dis decrease for the faction mechanicus
                                } else if (planet_feature_bool(p_feature[_run], eP_FEATURES.SORORITAS_CATHEDRAL) || (p_type[_run] == "Shrine")) {
                                    dispo[_run] -= 10; // 10 Disposition decrease for the planet govrnor if it's overrun by necrons
                                    obj_controller.disposition[5] -= 5; // 5 dis decrease for the Nurses
                                } else {
                                    dispo[_run] -= 10;
                                }
                            }
                        }

                        if (_system_overrun && p_tyranids[_run] < 5 && p_orks[_run] == 0 && p_traitors[_run] == 0) {
                            scr_popup("System Lost", $"The {name} system has been ovewhelmed by Necrons!", "necron_army", "");
                            scr_event_log("red", $"System {name} has been overwhelmed by Necrons.", name);
                        }
                    }
                }
                if (necrons_attack == "sisters") {
                    rand2 = (choose(1, 2, 3, 4, 5) * sisters_score) * choose(1, 1.25);
                    if (rand1 > rand2) {
                        after_combat_sisters -= 1;
                    }
                }
            }

            p_orks[_run] = after_combat_ork_force;
            p_tau[_run] = after_combat_tau;
            p_traitors[_run] = after_combat_traitor;
            p_chaos[_run] = after_combat_csm;
            p_necrons[_run] = after_combat_necrons;
            if (p_tyranids[_run] != after_combat_tyranids) {
                p_tyranids[_run] = after_combat_tyranids;
                if (_planet_data.has_feature(eP_FEATURES.GENE_STEALER_CULT)) {
                    adjust_influence(eFACTION.TYRANIDS, -min(p_influence[_run][eFACTION.TYRANIDS] - 4, 5), _run);
                    var _cult = _planet_data.get_features(eP_FEATURES.GENE_STEALER_CULT)[0];
                    if (p_influence[_run][eFACTION.TYRANIDS] < 5) {
                        _cult.hiding = true;
                    }
                }
            }

            p_sisters[_run] = after_combat_sisters;

            // End stop
        }

        // 135;

        var planet_saved = (p_player[_run] + p_raided[_run]) > 0 && p_orks[_run] == 0 && p_tyranids[_run] < 4 && p_chaos[_run] == 0 && p_traitors[_run] == 0 && p_necrons[_run] == 0 && p_tau[_run] == 0;

        if (planet_saved) {
            var who_cleansed = "";
            var who_return = "";
            var make_alert = false;
            var planet_string = $"{name} {scr_roman(_run)}";
            if (p_owner[_run] == 7) {
                who_cleansed = "Orks";
                make_alert = true;
            } else if (p_owner[_run] == 8 && p_pdf[_run] == 0) {
                who_cleansed = "Tau";
                make_alert = true;
            } else if (p_owner[_run] == 13) {
                who_cleansed = "Necrons";
                make_alert = true;
            } else if (p_owner[_run] == 10) {
                who_cleansed = "Chaos";
                make_alert = true;
            } else if (planet_feature_bool(p_feature[_run], eP_FEATURES.GENE_STEALER_CULT) && p_tyranids[_run] <= 0) {
                who_cleansed = "Gene Stealer Cult";
                make_alert = true;
                delete_features(p_feature[_run], eP_FEATURES.GENE_STEALER_CULT);
                adjust_influence(eFACTION.TYRANIDS, -25, _run);
            }
            if (make_alert) {
                if (p_first[_run] == 1) {
                    p_owner[_run] = eFACTION.PLAYER;
                    who_return = "your";
                } else if (p_first[_run] == 3 || p_type[_run] == "Forge") {
                    who_return = "mechanicus";
                    obj_controller.disposition[3] += 10;
                    p_owner[_run] = eFACTION.MECHANICUS;
                } else if (p_type[_run] != "Dead") {
                    who_return = "the governor";
                    if (who_cleansed == "tau") {
                        who_return = "a more suitable governer";
                    }
                    p_owner[_run] = eFACTION.IMPERIUM;
                }
                dispo[_run] += 10;
                scr_event_log("", $"{who_cleansed} cleansed from {planet_string}", name);
                scr_alert("green", "owner", $"{who_cleansed} cleansed from {planet_string}. Control returned to {who_return}", x, y);
                if (dispo[_run] >= 101) {
                    p_owner[_run] = 1;
                }
            }
        }

        if (p_raided[_run] > 0) {
            p_raided[_run] = 0;
        }
        delete _planet_data;
    } // end repeat here

    // quene player battles here

    // End quene player battles

    scr_star_ownership(true);

    // Restock PDF and military
    var i;
    i = 0;
    repeat (planets) {
        i += 1;
        if (p_type[i] == "Daemon") {
            p_heresy[i] = 200;
            p_owner[i] = 10;
        }

        if ((p_population[i] <= 0) && (p_large[i] == 0) && (p_chaos[i] == 0) && (p_traitors[i] == 0) && (p_tau[i] == 0) && (p_type[i] != "Daemon")) {
            p_heresy[i] = 0;
        }
        if ((p_population[i] < 1) && (p_large[i] == 1)) {
            p_population[i] = p_population[i] * 100000000;
            p_large[i] = 0;
        }

        if ((p_owner[i] == 2) && (p_type[i] != "Dead") && (planets >= i) && (p_tyranids[i] == 0) && (p_chaos[i] == 0) && (p_traitors[i] == 0) && (p_eldar[i] == 0) && (p_tau[i] == 0)) {
            var military, pdf, rando, contin;
            military = 0;
            pdf = 0;
            contin = 0;
            rando = floor(random(100)) + 1;

            if (p_population[i] >= 10000000) {
                military = p_population[i] / 470;
                pdf = floor(military * 0.75);
                military = floor(military * 0.25);
            }
            if ((p_population[i] >= 5000000) && (p_population[i] < 10000000)) {
                military = p_population[i] / 200;
                pdf = floor(military * 0.75);
                military = floor(military * 0.25);
            }
            if ((p_population[i] >= 100000) && (p_population[i] < 5000000)) {
                military = p_population[i] / 50;
                pdf = floor(military * 0.75);
                military = floor(military * 0.25);
            }
            if (p_large[i] == 1) {
                military = military * 1000000000;
                pdf = pdf * 1000000000;
            }

            if ((p_large[i] == 0) && (rando < 50) && (military != 0) && (pdf != 0)) {
                // if (p_guardsmen[i]<military) and (rando<50){rando=10;contin=max(floor(p_guardsmen[i]*1.05),500);p_population[i]-=contin;p_guardsmen[i]+=contin;}/
                if ((p_pdf[i] < pdf) && (rando < 50)) {
                    rando = 1;
                    rando = 10;
                    contin = max(floor(p_pdf[i] * 1.02), 1000);
                    p_population[i] -= contin;
                    p_pdf[i] += contin;
                }
            }
            if ((p_large[i] == 1) && (rando < 50) && (military != 0) && (pdf != 0)) {
                // if (p_guardsmen[i]<military) and (rando<50){rando=10;contin=0.01*p_population[i];p_guardsmen[i]+=contin*1250000;}
                if ((p_pdf[i] < pdf) && (rando < 50)) {
                    rando = 1;
                    rando = 10;
                    contin = 0.01 * p_population[i];
                    p_pdf[i] += contin * 1250000;
                }
            }

            if (p_large[i] == 1) {
                military = floor(p_population[i] * 1250000);
                pdf = military * 3;
            }
            if ((p_population[i] < 100000) && (p_population[i] > 5) && (p_large[i] == 0)) {
                pdf = floor(p_population[i] / 25);
                military = 0;
            }
            if ((p_population[i] < 2000) && (p_population[i] > 5) && (p_large[i] == 0)) {
                pdf = floor(p_population[i] / 10);
                military = 0;
            }

            if ((p_large[i] == 0) && (rando < 3)) {
                // if (p_guardsmen[i]<military) and (rando<3){rando=1;contin=max(floor(p_guardsmen[i]*1.05),500);p_population[i]-=contin;p_guardsmen[i]+=contin;}
                if ((p_pdf[i] < pdf) && (rando < 3)) {
                    rando = 1;
                    rando = 1;
                    contin = max(floor(p_pdf[i] * 1.02), 1000);
                    p_population[i] -= contin;
                    p_pdf[i] += contin;
                }
            }
            if ((p_large[i] == 1) && (rando < 3)) {
                // if (p_guardsmen[i]<military) and (rando<3){rando=1;contin=0.01*p_population[i];p_guardsmen[i]+=floor(contin*1250000);}
                if ((p_pdf[i] < pdf) && (rando < 3)) {
                    rando = 1;
                    rando = 1;
                    contin = 0.01 * p_population[i];
                    p_pdf[i] += floor(contin * 1250000);
                }
            }
        }
    }
}
