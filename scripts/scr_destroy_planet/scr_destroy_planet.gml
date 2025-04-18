function scr_destroy_planet(destruction_method) {
    // destruction_method: method   (1 being combat exterminatus, 2 being star select cyclonic torpedo)

    var baid = 0;
    enemy9 = 0;

    if (destruction_method == 2) {
        var pip;
        pip = instance_create(0, 0, obj_popup);
        with (pip) {
            title = "Exterminatus";
            image = "exterminatus";
            text = "You give the order to fire the Cyclonic Torpedo.  After a short descent it lands upon the surface and detonates- the air itself igniting across ";
        }

        var you = obj_star_select.target;
        pip.text += you.name;
        pip.text += " " + scr_roman(obj_controller.selecting_planet);
        baid = obj_controller.selecting_planet;
        scr_add_item("Cyclonic Torpedo", -1);
        obj_star_select.torpedo -= 1;
        enemy9 = you.p_owner[obj_controller.selecting_planet];
    } else if (destruction_method == 1) {
        var pip = instance_create(0, 0, obj_popup);
        with (pip) {
            title = "Exterminatus";
            image = "exterminatus";
            if (obj_ncombat.defeat == 0) {
                text = "After ensuring proper placement your marines return to their vessels.  A short while later the Exterminatus activates- the air itself ignites across ";
            }
        }

        instance_activate_object(obj_star);
        var you = battle_object;
        pip.text += planet_numeral_name(obj_ncombat.battle_id, battle_object);

        baid = obj_ncombat.battle_id;
        scr_add_item("Exterminatus", -1);

        enemy9 = enemy;
    }

    // No survivors!
    var unit;
    for (var cah = 0; cah <= obj_ini.companies; cah++) {
        for (var ed = 0; ed < array_length(obj_ini.role[cah]); ed++) {
            unit = fetch_unit([cah, ed]);
            if ((obj_ini.loc[cah, ed] == you.name) && (unit.planet_location == baid)) {
                if (unit.role() == obj_ini.role[100][eROLE.ChapterMaster]) {
                    obj_controller.alarm[7] = 15;
                    if (global.defeat <= 1) {
                        global.defeat = 1;
                    }
                }

                if (obj_ini.race[cah, ed] == 1) {
                    var comm = unit.IsSpecialist(, true);

                    // if (obj_ini.race[cah,ed]=1) then obj_controller.marines-=1;
                    if (comm == false) {
                        obj_controller.marines -= 1;
                    }
                    if (comm == true) {
                        obj_controller.command -= 1;
                    }
                }

                scr_kill_unit(cah, ed);
            }
            if (ed < 200) {
                if ((obj_ini.veh_loc[cah, ed] == you.name) && (obj_ini.veh_wid[cah, ed] == baid)) {
                    reset_vehicle_variable_arrays(cah, ed);
                }
            }
        }
    }

    // Increase disposition for all Imperial factions when destroying daemon worlds
    // Relation penalties here, if applicable
    if (you.p_type[baid] == "Daemon") {
        obj_controller.disposition[eFACTION.Imperium] += 5;
        obj_controller.disposition[eFACTION.Mechanicus] += 5;
        obj_controller.disposition[4] += 5;
        obj_controller.disposition[5] += 5;
        var o = 0;
        if (scr_has_adv("Reverent Guardians")) {
            o = 500;
        }
        if (o > 100) {
            obj_controller.disposition[5] += 5;
        }

        if (obj_controller.blood_debt == 1) {
            obj_controller.penitent_current += 1500;
            obj_controller.penitent_turn = 0;
            obj_controller.penitent_turnly = 0;
        }
        //TODO a shitload of helper functions to make this sort of stuff easier
    } else if ((you.p_owner[baid] == eFACTION.Mechanicus || you.p_first[baid] == eFACTION.Mechanicus) && obj_controller.faction_status[eFACTION.Mechanicus] != "War") {
        obj_controller.loyalty -= 50;
        obj_controller.loyalty_hidden -= 50;
        obj_controller.disposition[eFACTION.Imperium] -= 50;
        obj_controller.disposition[3] -= 80;
        obj_controller.disposition[4] -= 40;
        obj_controller.disposition[5] -= 30;

        obj_controller.faction_status[eFACTION.Imperium] = "War";
        obj_controller.faction_status[eFACTION.Mechanicus] = "War";
        obj_controller.faction_status[eFACTION.Inquisition] = "War";
        obj_controller.faction_status[eFACTION.Ecclesiarchy] = "War";

        obj_controller.audiences += 1;
        obj_controller.audien[obj_controller.audiences] = 3;
        obj_controller.audien_topic[obj_controller.audiences] = "declare_war";
        obj_controller.audiences += 1;
        obj_controller.audien[obj_controller.audiences] = 2;
        obj_controller.audien_topic[obj_controller.audiences] = "declare_war";
        if (obj_controller.known[eFACTION.Inquisition] > 1) {
            obj_controller.audiences += 1;
            obj_controller.audien[obj_controller.audiences] = 4;
            obj_controller.audien_topic[obj_controller.audiences] = "declare_war";
        }
        if (obj_controller.known[eFACTION.Ecclesiarchy] > 1) {
            obj_controller.audiences += 1;
            obj_controller.audien[obj_controller.audiences] = 5;
            obj_controller.audien_topic[obj_controller.audiences] = "declare_war";
        }

        if (planet_feature_bool(you.p_feature[baid], P_features.Sororitas_Cathedral) == 1) {
            obj_controller.disposition[5] -= 30;
            if (obj_controller.known[eFACTION.Mechanicus] > 1) {
                obj_controller.audiences += 1;
                obj_controller.audien[obj_controller.audiences] = 3;
                obj_controller.audien_topic[obj_controller.audiences] = "declare_war";
            }
        }
    } else if (enemy9 == eFACTION.Ecclesiarchy && obj_controller.faction_status[eFACTION.Ecclesiarchy] != "War") {
        obj_controller.loyalty -= 50;
        obj_controller.loyalty_hidden -= 50;
        obj_controller.disposition[eFACTION.Imperium] -= 50;
        obj_controller.disposition[3] -= 80;
        obj_controller.disposition[4] -= 40;
        obj_controller.disposition[5] -= 30;

        obj_controller.faction_status[eFACTION.Imperium] = "War";
        obj_controller.faction_status[eFACTION.Mechanicus] = "War";
        obj_controller.faction_status[eFACTION.Inquisition] = "War";
        obj_controller.faction_status[eFACTION.Ecclesiarchy] = "War";

        obj_controller.audiences += 1;
        obj_controller.audien[obj_controller.audiences] = 5;
        obj_controller.audien_topic[obj_controller.audiences] = "declare_war";
        if (obj_controller.known[eFACTION.Inquisition] > 1) {
            obj_controller.audiences += 1;
            obj_controller.audien[obj_controller.audiences] = 4;
            obj_controller.audien_topic[obj_controller.audiences] = "declare_war";
        }
        obj_controller.audiences += 1;
        obj_controller.audien[obj_controller.audiences] = 2;
        obj_controller.audien_topic[obj_controller.audiences] = "declare_war";
    } else if (obj_controller.faction_status[eFACTION.Imperium] != "War" && planet_feature_bool(you.p_feature[baid], P_features.Daemonic_Incursion) == 0 && you.p_tyranids[baid] < 5) {
        if (you.p_first[baid] == eFACTION.Imperium && you.p_type[baid] == "Hive") {
            obj_controller.loyalty -= 50;
            obj_controller.loyalty_hidden -= 50;
            obj_controller.disposition[eFACTION.Imperium] -= 60;
            obj_controller.disposition[eFACTION.Mechanicus] -= 30;
            obj_controller.disposition[eFACTION.Inquisition] -= 40;
            obj_controller.disposition[eFACTION.Ecclesiarchy] -= 40;

            obj_controller.faction_status[eFACTION.Imperium] = "War";
            obj_controller.faction_status[eFACTION.Mechanicus] = "War";
            obj_controller.faction_status[eFACTION.Inquisition] = "War";
            obj_controller.faction_status[eFACTION.Ecclesiarchy] = "War";

            obj_controller.audiences += 1;
            obj_controller.audien[obj_controller.audiences] = 2;
            obj_controller.audien_topic[obj_controller.audiences] = "declare_war";
            if (obj_controller.known[eFACTION.Inquisition] > 1) {
                obj_controller.audiences += 1;
                obj_controller.audien[obj_controller.audiences] = 4;
                obj_controller.audien_topic[obj_controller.audiences] = "declare_war";
            }
            if (obj_controller.known[eFACTION.Ecclesiarchy] > 1) {
                obj_controller.audiences += 1;
                obj_controller.audien[obj_controller.audiences] = 5;
                obj_controller.audien_topic[obj_controller.audiences] = "declare_war";
            }
            if (obj_controller.known[eFACTION.Mechanicus] > 1) {
                obj_controller.audiences += 1;
                obj_controller.audien[obj_controller.audiences] = 3;
                obj_controller.audien_topic[obj_controller.audiences] = "declare_war";
            }

            if (planet_feature_bool(you.p_feature[baid], P_features.Sororitas_Cathedral) == 1) {
                obj_controller.disposition[5] -= 30;
            }
        } else if (you.p_owner[baid] == eFACTION.Imperium && (you.p_type[baid] == "Temperate" || you.p_type[baid] == "Desert")) {
            obj_controller.loyalty -= 30;
            obj_controller.loyalty_hidden -= 30;
            obj_controller.disposition[eFACTION.Imperium] -= 30;
            obj_controller.disposition[eFACTION.Mechanicus] -= 15;
            obj_controller.disposition[eFACTION.Inquisition] -= 30;
            obj_controller.disposition[eFACTION.Ecclesiarchy] -= 30;
        }
    }

    // Planet changes here
    //TODO make a plane_reset function
    with (you) {
        p_type[baid] = "Dead";
        p_feature[baid] = [];
        p_owner[baid] = 0;
        p_first[baid] = 0;
        p_population[baid] = 0;
        p_max_population[baid] = 0;
        p_large[baid] = 0;
        p_pop[baid] = "";
        p_guardsmen[baid] = 0;
        p_pdf[baid] = 0;
        p_fortified[baid] = 0;
        p_station[baid] = 0;
        // Whether or not player forces are on the planet

        p_player[baid] = 0;

        // v how much of a problem they are from 1-5
        p_orks[baid] = 0;
        p_tau[baid] = 0;
        p_eldar[baid] = 0;
        p_tyranids[baid] = 0;
        p_traitors[baid] = 0;
        p_chaos[baid] = 0;
        p_demons[baid] = 0;
        p_sisters[baid] = 0;
        p_necrons[baid] = 0;
        //
        p_problem[baid] = array_create(8, "");
        p_timer[baid] = array_create(8, 0);
        p_problem_other_data[baid] = array_create(8, {});
    }

    pip.text += ", scouring all life across the planet.  It has been rendered a barren, lifeless chunk of rock.";
    pip.number = 1;

    with (obj_temp5) {
        instance_destroy();
    }
    with (obj_temp8) {
        instance_destroy();
    }
}
