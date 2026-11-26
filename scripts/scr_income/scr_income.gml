/// @self Asset.GMObject.obj_controller
function scr_income() {
    // Determines income

    income_base = 32;
    income_tribute = 0;
    income_home = 0;
    income_forge = 0;
    income_agri = 0;
    income_training = 0;

    var _player_base = obj_ini.sector_handler.player_base_location();
    if (obj_ini.fleet_type == ePLAYER_BASE.HOME_WORLD) {
        income_home = 8;
        with (obj_star){
            var _distance_to_player_home = point_distance(x, y, _player_base.x, _player_base.y);

            // Nearby star system
            if ((_distance_to_player_home > 10) && (_distance_to_player_home <= 180)) {
                for (var i = 1; i <= planets; i++) {
                    if ((p_type[i] == "Forge") && (p_owner[i] == eFACTION.MECHANICUS)) {
                        obj_controller.income_forge += 6;
                    }
                    if ((p_type[i] == "Agri") && (p_owner[i] == eFACTION.IMPERIUM)) {
                        obj_controller.income_agri += 3;
                    }
                }
            }
            var connected = determine_warp_join(_player_base, id);
            if ((_player_base.owner == eFACTION.PLAYER) && (_distance_to_player_home > 180) && connected) {
                for (var i = 1; i <= planets; i++) {
                    if ((p_type[i] == "Forge") && (p_owner[i] == eFACTION.MECHANICUS)) {
                        obj_controller.income_forge += 6;
                    }
                    if ((p_type[i] == "Agri") && (p_owner[i] == eFACTION.IMPERIUM)) {
                        obj_controller.income_agri += 3;
                    }
                }
            }
        }
    } // Homeworld-based income

    income_fleet = 0;
    with (obj_p_fleet) {
        obj_controller.income_fleet -= capital_number;
        obj_controller.income_fleet -= frigate_number / 2;
        obj_controller.income_fleet -= escort_number / 10;
    }

    if (obj_ini.fleet_type == ePLAYER_BASE.HOME_WORLD) {
        income_fleet = round(income_fleet / 2);
    }

    if (faction_status[eFACTION.MECHANICUS] != "War") {
        var _chapter_tech_count = scr_role_count(obj_ini.player_role_data[eROLE.TECHMARINE].role, "");
        if (_chapter_tech_count >= ((disposition[3] / 2) + 5)) {
            training_techmarine = 0;
        }
    }

    if (training_apothecary > 0){
        income_training -= global.apothecary_training_costs[training_apothecary];
    }

    if (training_chaplain > 0){
        income_training -= global.chaplain_training_costs[training_chaplain];
    }

    if (training_psyker > 0){
        income_training -= global.psyker_training_costs[training_psyker];
    }

    if (training_techmarine > 0){
        income_training -= global.techmarine_training_costs[training_techmarine];
    }

    tau_stars = 0;
    if (instance_exists(obj_turn_end)) {
        tau_messenger += 1;
    }

    with (obj_star) {
        if (owner == eFACTION.TAU) {
            obj_controller.tau_stars += 1;
        }
    }


    with (obj_p_fleet) {
        if ((action == "") && (capital_number > 0)) {
            var mine = instance_nearest(x, y, obj_star);
            for (var i = 1; i <= 4; i++) {
                if ((mine.p_owner[i] == eFACTION.IMPERIUM) || (mine.p_owner[i] == eFACTION.MECHANICUS)) {
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


    with (obj_star) {
        for (var o = 1; o <= planets; o++) {
            if (dispo[o] >= 100) {
                if (planet_feature_bool(p_feature[o], eP_FEATURES.MONASTERY) == 0) {
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

    alarm[4] = 10;
    // This tells the controller to give moolah if it is the end of the turn
}
