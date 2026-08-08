/// @self Struct.TTRPG_stats
/// @param {String} specialist
/// @param {Real} req_exp
function specialistfunct(specialist, req_exp) {
    var spec_tips = [
        string("{0} Potential", obj_ini.player_role_data[eROLE.TECHMARINE].role),
        string("{0} Potential", obj_ini.player_role_data[eROLE.APOTHECARY].role),
        string("{0} Potential", obj_ini.player_role_data[eROLE.CHAPLAIN].role),
        string("{0} Potential", obj_ini.player_role_data[eROLE.LIBRARIAN].role),
        string("{0} Applicant", obj_ini.player_role_data[eROLE.TECHMARINE].role),
        string("{0} Applicant", obj_ini.player_role_data[eROLE.APOTHECARY].role),
        string("{0} Applicant", obj_ini.player_role_data[eROLE.CHAPLAIN].role),
        string("{0} Applicant", obj_ini.player_role_data[eROLE.LIBRARIAN].role),
        string("Promote to Marine"),
    ];

    var colors;
    var tips_list = [
        0,
        0,
        spec_tips[8],
    ];
    var spec_tip;
    switch (specialist) {
        case "Techmarine":
            colors = [
                c_dkgray,
                c_red,
            ];
            tips_list[0] = spec_tips[0];
            tips_list[1] = spec_tips[4];
            if (role_tag[eROLE_TAG.Techmarine] == true) {
                colors[1] = c_navy;
            }
            break;
        case "Librarian":
            colors = [
                c_white,
                c_aqua,
            ];
            tips_list[0] = spec_tips[3];
            tips_list[1] = spec_tips[7];
            if (role_tag[eROLE_TAG.Librarian] == true) {
                colors[1] = c_navy;
            }
            break;
        case "Chaplain":
            colors = [
                c_black,
                c_yellow,
            ];
            tips_list[0] = spec_tips[2];
            tips_list[1] = spec_tips[6];
            if (role_tag[eROLE_TAG.Chaplain] == true) {
                colors[1] = c_navy;
            }
            break;
        case "Apothecary":
            colors = [
                c_red,
                c_white,
            ];
            tips_list[0] = spec_tips[1];
            tips_list[1] = spec_tips[5];
            if (role_tag[eROLE_TAG.Apothecary] == true) {
                colors[1] = c_navy;
            }
            break;
    }

    if (role() == obj_ini.player_role_data[eROLE.SCOUT].role) {
        colors[0] = c_fuchsia;
    }

    if (experience < req_exp) {
        colors = array_reverse(colors);
    }

    if (experience >= req_exp) {
        if (!(role() == obj_ini.player_role_data[eROLE.SCOUT].role)) {
            spec_tip = tips_list[1];
        } else {
            spec_tip = tips_list[2];
        }
    } else {
        spec_tip = tips_list[0];
    }

    return {
        spec_tip: spec_tip,
        colors: colors,
    };
}

// Function: spec_data_set(specialist)
// Description: Centralizes logic for retrieving a random marine based on specialist training data
// Parameters:
//   specialist - Integer index (0: Techmarine, 1: Librarian, 2: Chaplain, 3: Apothecary)
// Returns: Array containing company and position of selected marine, or "none" if no suitable marine found
/// @param {Real} specialist
function spec_data_set(specialist) {
    var _data = obj_controller.spec_train_data[specialist];
    var _search = {
        "stat": _data.req,
        "job": "none",
    };

    if (obj_controller.tagged_training == true) {
        _search.role_tag = _data.name;
    }

    var random_marine = scr_random_marine(
        // TODO LOW SEARCH_OPTIONAL // Make this function handle optional search_params
        [obj_ini.player_role_data[eROLE.TACTICAL].role, obj_ini.player_role_data[eROLE.SERGEANT].role, obj_ini.player_role_data[eROLE.ASSAULT].role, obj_ini.player_role_data[eROLE.DEVASTATOR].role],
        _data.min_exp,
        _search,
    );
    return random_marine;
}

/// @self Asset.GMObject.obj_controller
function apothecary_training() {
    // ** Training **
    // * Apothecary *
    var recruit_count = 0;
    var training_points_values = global.apothecary_training_tiers;
    apothecary_recruit_points += training_points_values[training_apothecary];

    var _apoth_role = obj_ini.player_role_data[eROLE.APOTHECARY];

    var novice_type = string("{0} Aspirant", _apoth_role.role);
    if (training_apothecary > 0) {
        recruit_count = scr_role_count(novice_type, "");

        if (apothecary_recruit_points >= 48) {
            if (recruit_count > 0) {
                var random_marine = scr_random_marine(novice_type, 0);
                if (random_marine == "none") {
                    return;
                }
                /// @type {Struct.TTRPG_stats}
                var _unit = fetch_unit(random_marine);
                if (!is_struct(_unit)) {
                    return;
                }

                apothecary_recruit_points -= 48;
                scr_alert("green", "recruitment", _unit.name_role() + " has finished training.", 0, 0);
                _unit.update_role(_apoth_role.role);
                _unit.role_tag = [
                    0,
                    0,
                    0,
                    0,
                ];
                _unit.add_exp(10);

                var _warn = "";
                var _outcome = _unit.alter_equipment(_apoth_role, true, true);

                if (!_outcome.success) {
                    scr_alert("red", "recruitment", $"{_outcome.description}!", 0, 0);
                }
            } else {
                apothecary_recruit_points = 0;
            }
        } else if ((apothecary_recruit_points >= 4) && (recruit_count == 0)) {
            var random_marine = spec_data_set(eROLE_TAG.Apothecary);
            if (random_marine == "none") {
                return;
            }
            var _unit = fetch_unit(random_marine);
            // This gets the last open slot for company 0
            _unit.move_to_company(0);

            _unit.update_role(novice_type);
            _unit.update_gear("");
            _unit.update_mobility_item("");
            scr_alert("green", "recruitment", _unit.name_role() + " begins training.", 0, 0);
        } else {
            training_apothecary = 0;
            scr_alert("red", "recruitment", $"No marines available for {obj_ini.player_role_data[eROLE.APOTHECARY].role} training", 0, 0);
        }
    }
}

/// @self Asset.GMObject.obj_controller
function chaplain_training() {
    // * Chaplain training *
    // TODO add functionality for Space Wolves and Iron Hands
    var recruit_count = 0;
    var training_points_values = global.chaplain_training_tiers;
    if ((global.chapter_name != "Space Wolves") && (global.chapter_name != "Iron Hands")) {
        chaplain_points += training_points_values[training_chaplain];
        var novice_type = string("{0} Aspirant", obj_ini.player_role_data[eROLE.CHAPLAIN].role);

        if (training_chaplain > 0) {
            recruit_count = scr_role_count(novice_type, "");
            if (chaplain_points >= 48) {
                if (recruit_count > 0) {
                    var random_marine = scr_random_marine(novice_type, 0);
                    if (random_marine == "none") {
                        return;
                    }
                    var _chap_role = obj_ini.player_role_data[eROLE.CHAPLAIN];
                    var _unit = fetch_unit(random_marine);

                    scr_alert("green", "recruitment", _unit.name_role() + " has finished training.", 0, 0);
                    chaplain_points -= 48;
                    _unit.update_role(_chap_role.role);
                    _unit.role_tag = [
                        0,
                        0,
                        0,
                        0,
                    ];
                    _unit.add_exp(10);
                    chaplain_aspirant = 0;
                    var _warn = "";
                    var _outcome = _unit.alter_equipment(_chap_role, true, true);

                    if (!_outcome.success) {
                        scr_alert("red", "recruitment", $"{_outcome.description}!", 0, 0);
                    }
                } else {
                    chaplain_points = 0;
                }
            } else if ((chaplain_points >= 4) && (recruit_count == 0)) {
                var random_marine = spec_data_set(eROLE_TAG.Chaplain);
                if (random_marine != "none") {
                    var _unit = fetch_unit(random_marine);
                    if (!is_struct(_unit)) {
                        return;
                    }

                    _unit.move_to_company(0);

                    chaplain_aspirant = 1;
                    _unit.update_role(novice_type);
                    _unit.update_gear("");
                    _unit.update_mobility_item("");
                    scr_alert("green", "recruitment", $"{_unit.name_role()} begins training.", 0, 0);
                    with (obj_ini) {
                        scr_company_order(marine_company);
                        scr_company_order(0);
                    }
                } else {
                    training_chaplain = 0;
                    scr_alert("red", "recruitment", $"No remaining {obj_ini.player_role_data[eROLE.CHAPLAIN].role} applicant marines for training", 0, 0);
                }
            }
        }
    }
}

/// @self Asset.GMObject.obj_controller
function librarian_training() {
    var recruit_count = 0;
    // * Psycher Training *
    var training_points_values = global.chaplain_training_tiers;
    psyker_points += training_points_values[training_psyker];

    var goal = 48;
    var novice_type = string("{0} Aspirant", obj_ini.player_role_data[eROLE.LIBRARIAN].role);

    if (training_psyker > 0) {
        recruit_count = scr_role_count(novice_type, "");
        if (psyker_points >= goal) {
            if (recruit_count > 0) {
                var random_marine = scr_random_marine(novice_type, 0, {"stat": [["psionic", 2, "more"]]});
                if (random_marine == "none") {
                    return;
                }
                var _unit = fetch_unit(random_marine);

                psyker_points -= goal;
                psyker_aspirant = 0;

                scr_alert("green", "recruitment", _unit.name_role() + " has finished training.", 0, 0);
                _unit.update_role("Lexicanum");
                _unit.role_tag = [
                    0,
                    0,
                    0,
                    0,
                ];
            } else {
                psyker_points = 0;
            }
        } else if ((psyker_points >= 4) && (recruit_count == 0)) {
            var random_marine = spec_data_set(eROLE_TAG.Librarian);
            if (random_marine == "none") {
                training_psyker = 0;
                scr_alert("red", "recruitment", "No remaining warp sensitive marines for training", 0, 0);
            } else if (random_marine != "none") {
                // This gets the last open slot for company 0
                var _unit = fetch_unit(random_marine);
                _unit.move_to_company(0);

                _unit.update_role(novice_type);
                _unit.update_powers();
                psyker_aspirant = 1;

                _unit.alter_equipment({gear: "", mobi: ""});
                _unit.update_mobility_item("");
                scr_alert("green", "recruitment", _unit.name_role() + " begins training.", 0, 0);
            }
        }
    }
}

/// @self Asset.GMObject.obj_controller
function techmarine_training() {
    var recruit_count = 0;

    var training_points_values = [
        0,
        1,
        2,
        4,
        6,
        10,
        14,
    ];

    var _tech_role = obj_ini.player_role_data[eROLE.TECHMARINE];

    tech_points += training_points_values[training_techmarine];
    var novice_type = string("{0} Aspirant", _tech_role.role);
    if (training_techmarine > 0) {
        recruit_count = scr_role_count(novice_type, "");
        var _threshold = 252;

        if (obj_controller.faction_status[eFACTION.MECHANICUS] != "War") {
            _threshold = 360;
        }

        if (tech_points >= _threshold) {
            if (recruit_count > 0) {
                var random_marine = scr_random_marine(novice_type, 0);
                if (random_marine == "none") {
                    return;
                }
                var _unit = fetch_unit(random_marine);
                if (!is_struct(_unit)) {
                    return;
                }
                tech_points -= _threshold;

                _unit.update_role(_tech_role.role);
                _unit.role_tag = [
                    0,
                    0,
                    0,
                    0,
                ];
                _unit.add_exp(30);

                _unit.religion = "cult_mechanicus";
                if (obj_controller.faction_status[eFACTION.MECHANICUS] != "War") {
                    _unit.add_trait("mars_trained");
                    _unit.alter_equipment(_tech_role, false, true);
                    scr_alert("green", "recruitment", $"{_unit.name()} returns from Mars, a {_unit.role()}.", 0, 0);
                } else {
                    _unit.add_trait("chapter_trained_tech");
                    scr_alert("green", "recruitment", $"{_unit.name_role()} has finished training.", 0, 0);

                    var _outcome = _unit.alter_equipment(_tech_role, true, true);

                    if (!_outcome.success) {
                        scr_alert("red", "recruitment", $"{_outcome.description}!", 0, 0);
                    }
                }

                if (_unit.location_string == "Terra") {
                    _unit.allocate_unit_to_fresh_spawn("default");
                }

                var extra_bio = 0;
                if (global.chapter_name != "Iron Hands" || !_unit.has_trait("flesh_is_weak")) {
                    extra_bio = _unit.bionics < 4 ? choose(1, 2, 3) : 1;
                } else {
                    extra_bio = choose(4, 5, 6);
                }
                repeat (extra_bio) {
                    _unit.add_bionics();
                }
                // 135 ; probably also want to increase the p_player by 1 just because
                with (obj_ini) {
                    scr_company_order(0);
                }
            } else {
                tech_points = 0;
            }
        } else if ((tech_points >= 4) && (recruit_count == 0)) {
            var random_marine = spec_data_set(eROLE_TAG.Techmarine);
            if (random_marine != "none") {
                var _unit = fetch_unit(random_marine);
                if (!is_struct(_unit)) {
                    return;
                }
                _unit.move_to_company(0);
                _unit.update_role(novice_type);

                // Remove from ship
                if (obj_controller.faction_status[eFACTION.MECHANICUS] != "War") {
                    if (_unit.ship_location > -1) {
                        var man_size = _unit.get_unit_size();
                        obj_ini.ship_carrying[_unit.ship_location] -= man_size;
                    }
                    _unit.location_string = "Terra";
                    _unit.planet_location = 4;
                    _unit.ship_location = -1;
                }
                _unit.alter_equipment({wep1: "", wep2: "", armour: "", gear: "", mobi: ""});

                if (obj_controller.faction_status[eFACTION.MECHANICUS] != "War") {
                    scr_alert("green", "recruitment", $"{_unit.name_role()} journeys to Mars.", 0, 0);
                } else {
                    scr_alert("green", "recruitment", $"{_unit.name_role()} begins training.", 0, 0);
                }
            } else {
                training_techmarine = 0;
                scr_alert("red", "recruitment", $"No marines with sufficient technology aptitude for {_tech_role.role} training", 0, 0);
            }
        }
    }
}
