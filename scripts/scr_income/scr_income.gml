function scr_income() {
    // Determines income

    income_base = 32;
    income_tribute = 0;
    income_controlled_planets = 0;
    if (obj_ini.fleet_type != ePlayerBase.home_world) {
        income_base = 40;
    }

    income_home = 0;
    if (obj_ini.fleet_type == ePlayerBase.home_world) {
        income_home = 8;
    } // Homeworld-based income

    income_fleet = 0;
    with (obj_p_fleet) {
        obj_controller.income_fleet -= capital_number;
        obj_controller.income_fleet -= frigate_number / 2;
        obj_controller.income_fleet -= escort_number / 10;
    }
    if (obj_ini.fleet_type == ePlayerBase.home_world) {
        obj_controller.income_fleet = round(obj_controller.income_fleet / 2);
    }

    income_forge = 0;
    income_agri = 0;
    income_training = 0;

    if (obj_controller.faction_status[eFACTION.Mechanicus] != "War") {
        var _chapter_tech_count = scr_role_count(obj_ini.role[100][eROLE.Techmarine], "");
        if (_chapter_tech_count >= ((disposition[3] / 2) + 5)) {
            training_techmarine = 0;
        }
    }

    if (training_apothecary == 1) {
        income_training -= 1;
    }
    if (training_apothecary == 2) {
        income_training -= 2;
    }
    if (training_apothecary == 3) {
        income_training -= 3;
    }
    if (training_apothecary == 4) {
        income_training -= 4;
    }
    if (training_apothecary == 5) {
        income_training -= 6;
    }
    if (training_apothecary == 6) {
        income_training -= 12;
    }

    if (training_chaplain == 1) {
        income_training -= 1;
    }
    if (training_chaplain == 2) {
        income_training -= 2;
    }
    if (training_chaplain == 3) {
        income_training -= 3;
    }
    if (training_chaplain == 4) {
        income_training -= 4;
    }
    if (training_chaplain == 5) {
        income_training -= 6;
    }
    if (training_chaplain == 6) {
        income_training -= 12;
    }

    if (training_psyker == 1) {
        income_training -= 1;
    }
    if (training_psyker == 2) {
        income_training -= 2;
    }
    if (training_psyker == 3) {
        income_training -= 3;
    }
    if (training_psyker == 4) {
        income_training -= 4;
    }
    if (training_psyker == 5) {
        income_training -= 6;
    }
    if (training_psyker == 6) {
        income_training -= 12;
    }

    if (training_techmarine == 1) {
        income_training -= 1;
    }
    if (training_techmarine == 2) {
        income_training -= 2;
    }
    if (training_techmarine == 3) {
        income_training -= 3;
    }
    if (training_techmarine == 4) {
        income_training -= 4;
    }
    if (training_techmarine == 5) {
        income_training -= 6;
    }
    if (training_techmarine == 6) {
        income_training -= 12;
    }

    tau_stars = 0;
    if (instance_exists(obj_turn_end)) {
        tau_messenger += 1;
    }

    if (obj_ini.fleet_type == ePlayerBase.home_world) {
        with (obj_star) {
            if (planet_feature_bool(p_feature[1], P_features.Monastery) == 1) {
                obj_controller.income += 10;
                instance_create(x, y, obj_temp1);
            }
            if (planet_feature_bool(p_feature[2], P_features.Monastery) == 1) {
                obj_controller.income += 10;
                instance_create(x, y, obj_temp1);
            }
            if (owner == eFACTION.Tau) {
                obj_controller.tau_stars += 1;
            }
            alarm[2] = 1;
        }
    }

    if (obj_ini.fleet_type != ePlayerBase.home_world) {
        with (obj_p_fleet) {
            if ((action == "") && (capital_number > 0)) {
                var mine;
                mine = instance_nearest(x, y, obj_star);
                var i;
                i = 0;
                repeat (4) {
                    i += 1;
                    if ((mine.p_owner[i] == eFACTION.Imperium) || (mine.p_owner[i] == eFACTION.Mechanicus)) {
                        if ((mine.p_type[i] == "Desert") || (mine.p_type[i] == "Temperate")) {
                            obj_controller.income_home += 2 * capital_number;
                        }
                        if ((mine.p_type[i] == "Forge") || (mine.p_type[i] == "Hive")) {
                            obj_controller.income_home += 4 * capital_number;
                        }
                    }
                }
            }
        }
    }

    with (obj_star) {
        var o;
        o = 0;
        repeat (4) {
            o += 1;
            if (dispo[o] >= 100) {
                if (planet_feature_bool(p_feature[1], P_features.Monastery) == 0) {
                    obj_controller.income_controlled_planets += 1;
                    obj_controller.income_tribute += 1;
                    if (p_type[o] == "Feudal") {
                        obj_controller.income_tribute += 1;
                    }
                    if ((p_type[o] == "Desert") || (p_type[o] == "Temperate")) {
                        obj_controller.income_tribute += 2;
                    }
                    if ((p_type[o] == "Forge") || (p_type[o] == "Hive")) {
                        obj_controller.income_tribute += 3;
                    }
                }
            }
        }
    }

    obj_controller.alarm[4] = 10;
    // This tells the controller to give moolah if it is the end of the turn
}
