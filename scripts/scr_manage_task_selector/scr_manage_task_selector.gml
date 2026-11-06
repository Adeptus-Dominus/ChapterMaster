/// @self Asset.GMObject.obj_controller
function scr_manage_task_selector() {
    if (exit_button.draw_shutter(400, 70, "Exit", 0.5, true)) {
        if (selection_data.purpose_code == "artifact_equip") {
            scr_toggle_lib();
            obj_controller.menu_artifact = selection_data.artifact;
            equip_artifact_popup_setup();
            exit;
        }

        if (struct_exists(selection_data, "target_company")) {
            if (is_real(selection_data.target_company) && selection_data.target_company <= 10 && selection_data.target_company >= 0) {
                managing = selection_data.target_company;
                update_general_manage_view();
                exit;
            }
        } else {
            exit_adhoc_manage();
            exit;
        }
    }
    var _man_count;
    if (selection_data.select_type == eMISSION_SELECT_TYPE.UNITS) {
        _man_count = array_sum(man_sel);
    } else {
        _man_count = array_length(company_data.selected_squads);
    }
    if (selection_data.purpose_code != "manage") {
        if (_man_count == 0 || _man_count > selection_data.number) {
            proceed_button.draw_shutter(1110, 70, "Proceed", 0.5, false);
        } else if (proceed_button.draw_shutter(1110, 70, "Proceed", 0.5, true)) {
            if (selection_data.select_type == eMISSION_SELECT_TYPE.UNITS) {
                task_selector_man_manage();
            } else {
                task_selector_squad_manage();
            }
        }
    }
}

/// @self Asset.GMObject.obj_controller
function task_selector_squad_manage() {
    var _squads = [];
    for (var i = 0; i < array_length(company_data.selected_squads); i++) {
        var _squad = fetch_squad(company_data.selected_squads[i]);
        /*switch (selection_data.purpose_code) {

        }*/
        array_push(_squads, _squad);
    }
    if (struct_exists(selection_data , "feature") && array_length(_squads)){
        var _feat = selection_data.feature;
        if (is_struct(_feat) && is_instanceof(_feat, PlanetProblem)){
            _feat.data.squads = _squads;
            _feat.on_squad_selection();
        }
    }
}

/// @self Asset.GMObject.obj_controller
function task_selector_man_manage() {
    var _selections = [];
    for (var i = 0; i < array_length(display_unit); i++) {
        if (ma_name[i] == "") {
            continue;
        }
        /// @type {Struct.TTRPG_stats}
        var _unit = display_unit[i];
        if (man_sel[i]) {
            array_push(_selections, _unit);
            switch (selection_data.purpose_code) {
                case "forge_assignment":
                    var _forge = selection_data.feature;
                    _forge.techs_working = 0;
                    _forge.techs_working++;
                    _unit.unload(selection_data.planet, selection_data.system);
                    _unit.job = {
                        type: "forge",
                        planet: selection_data.planet,
                        location: selection_data.system.name,
                    };
                    break;
                case "captain_promote":
                    _unit.update_role(obj_ini.player_role_data[eROLE.CAPTAIN].role);
                    _unit.squad = "none";
                    _unit.move_to_company(selection_data.target_company);
                    managing = selection_data.target_company;
                    update_general_manage_view();
                    exit;
                case "champion_promote":
                    _unit.update_role(obj_ini.player_role_data[eROLE.CHAMPION].role);
                    _unit.squad = "none";

                    with (obj_ini) {
                        scr_company_order(_unit.company);
                    }

                    managing = selection_data.target_company;
                    update_general_manage_view();
                    exit;
                case "ancient_promote":
                    _unit.update_role(obj_ini.player_role_data[eROLE.ANCIENT].role);
                    _unit.squad = "none";

                    with (obj_ini) {
                        scr_company_order(_unit.company);
                    }
                    managing = selection_data.target_company;
                    update_general_manage_view();
                    exit;
                case "chaplain_promote":
                    _unit.squad = "none";
                    _unit.move_to_company(selection_data.target_company);
                    managing = selection_data.target_company;
                    update_general_manage_view();
                    exit;
                case "apothecary_promote":
                    _unit.squad = "none";
                    _unit.move_to_company(selection_data.target_company);
                    managing = selection_data.target_company;
                    update_general_manage_view();
                    exit;
                case "tech_marine_promote":
                    _unit.squad = "none";
                    _unit.move_to_company(selection_data.target_company);
                    managing = selection_data.target_company;
                    update_general_manage_view();
                    exit;
                case "librarian_promote":
                    _unit.squad = "none";
                    _unit.move_to_company(selection_data.target_company);
                    managing = selection_data.target_company;
                    update_general_manage_view();
                    exit;
                case "artifact_equip":
                    scr_toggle_lib();
                    var _arti = fetch_artifact(selection_data.artifact);
                    _arti.equip_on_unit(_unit, selection_data.slot);
                    scr_toggle_lib();
                    obj_controller.menu_artifact = selection_data.artifact;
                    break;
            }
        } else {
            switch (selection_data.purpose_code) {
                case "forge_assignment":
                    var forge = selection_data.feature;
                    forge.techs_working = false;
                    var job = _unit.job;
                    if (job != "none") {
                        if (job.type == "forge" && job.planet == selection_data.planet) {
                            _unit.job = "none";
                            forge.techs_working--;
                        }
                    }
                    break;
            }
        }
    }
    selection_data.selections = _selections;
    if (struct_exists(selection_data, "feature")){
        var _feat = selection_data.feature;
        if (is_struct(_feat) && is_instanceof(_feat, PlanetProblem)){
            _feat.on_unit_selection();
        }
    }
    switch (selection_data.purpose_code) {
        case "forge_assignment":
            specialist_point_handler.calculate_research_points();
            break;
    }
    exit_adhoc_manage();
    exit;
}
