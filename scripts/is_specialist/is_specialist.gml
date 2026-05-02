#macro SPECIALISTS_APOTHECARIES "apothecaries"
#macro SPECIALISTS_CHAPLAINS "chaplains"
#macro SPECIALISTS_LIBRARIANS "librarians"
#macro SPECIALISTS_TECHS "techs"
#macro SPECIALISTS_TECHMARINES "techmarines"
#macro SPECIALISTS_STANDARD "standard"
#macro SPECIALISTS_VETERANS "veterans"
#macro SPECIALISTS_RANK_AND_FILE "rank_and_file"
#macro SPECIALISTS_SQUAD_LEADERS "squad_leaders"
#macro SPECIALISTS_COMMAND "command"
#macro SPECIALISTS_DREADNOUGHTS "dreadnoughts"
#macro SPECIALISTS_CAPTAIN_CANDIDATES "captain_candidates"
#macro SPECIALISTS_TRAINEES "trainees"
#macro SPECIALISTS_HEADS "heads"

/// @description Retrieves the active roles from the game, either from the obj_creation or obj_ini object.
/// @returns {array}
function active_roles() {
    var _roles = instance_exists(obj_creation) ? obj_creation.role[100] : obj_ini.role[100];
    return _roles;
}

/// @description Returns a list of roles based on the specified group, with optional inclusion of trainees and heads.
/// @param {integer} group The group of roles to retrieve (e.g., SPECIALISTS_STANDARD, SPECIALISTS_LIBRARIANS).
/// @param {bool} include_trainee Whether to include trainee roles (default is false).
/// @param {bool} include_heads Whether to include head roles (default is true).
/// @returns {array}
function role_groups(group, include_trainee = false, include_heads = true) {
    var _role_list = [];
    var _roles = active_roles();
    var _chap_name = instance_exists(obj_creation) ? obj_creation.chapter_name : global.chapter_name;

    switch (group) {
        case SPECIALISTS_STANDARD:
            _role_list = [
                _roles[eROLE.CAPTAIN],
                _roles[eROLE.DREADNOUGHT],
                $"Venerable {_roles[eROLE.DREADNOUGHT]}",
                _roles[eROLE.CHAMPION],
                _roles[eROLE.CHAPLAIN],
                _roles[eROLE.APOTHECARY],
                _roles[eROLE.TECHMARINE],
                _roles[eROLE.LIBRARIAN],
                "Codiciery",
                "Lexicanum",
                _roles[eROLE.HONOURGUARD]
            ];
            if (include_trainee) {
                _role_list = array_concat(_role_list, role_groups(SPECIALISTS_TRAINEES));
            }
            if (include_heads) {
                _role_list = array_concat(_role_list, role_groups(SPECIALISTS_HEADS));
            }
            break;

        case SPECIALISTS_LIBRARIANS:
            _role_list = [
                _roles[eROLE.LIBRARIAN],
                "Codiciery",
                "Lexicanum"
            ];
            if (include_trainee) {
                array_push(_role_list, $"{_roles[eROLE.LIBRARIAN]} Aspirant");
            }
            if (include_heads) {
                array_push(_role_list, $"Chief {_roles[eROLE.LIBRARIAN]}");
            }
            break;
        case SPECIALISTS_TECHS:
            _role_list = [
                _roles[eROLE.TECHMARINE],
                "Techpriest"
            ];
            if (include_trainee) {
                array_push(_role_list, $"{_roles[eROLE.TECHMARINE]} Aspirant");
            }
            if (include_heads) {
                array_push(_role_list, "Forge Master");
            }
            break;
        case SPECIALISTS_TECHMARINES:
            _role_list = [_roles[eROLE.TECHMARINE]];
            if (include_trainee) {
                array_push(_role_list, $"{_roles[eROLE.TECHMARINE]} Aspirant");
            }
            if (include_heads) {
                array_push(_role_list, "Forge Master");
            }
            break;
        case SPECIALISTS_CHAPLAINS:
            _role_list = [_roles[eROLE.CHAPLAIN]];
            if (_chap_name == "Iron Hands") {
                array_push(_role_list, _roles[eROLE.TECHMARINE]);
                if (include_trainee) {
                    array_push(_role_list, $"{_roles[eROLE.TECHMARINE]} Aspirant");
                }
                if (include_heads) {
                    array_push(_role_list, "Forge Master");
                }
            }
            if (include_trainee) {
                array_push(_role_list, $"{_roles[eROLE.CHAPLAIN]} Aspirant");
            }
            if (include_heads) {
                array_push(_role_list, "Master of Sanctity");
            }
            break;
        case SPECIALISTS_APOTHECARIES:
            _role_list = [_roles[eROLE.APOTHECARY]];
            if (_chap_name == "Space Wolves") {
                array_push(_role_list, _roles[eROLE.CHAPLAIN]);
                if (include_trainee) {
                    array_push(_role_list, $"{_roles[eROLE.CHAPLAIN]} Aspirant");
                }
                if (include_heads) {
                    array_push(_role_list, "Master of Sanctity");
                }
            }
            if (include_trainee) {
                array_push(_role_list, $"{_roles[eROLE.APOTHECARY]} Aspirant");
            }
            if (include_heads) {
                array_push(_role_list, "Master of the Apothecarion");
            }
            break;

        case SPECIALISTS_TRAINEES:
            _role_list = [
                $"{_roles[eROLE.LIBRARIAN]} Aspirant",
                $"{_roles[eROLE.APOTHECARY]} Aspirant",
                $"{_roles[eROLE.CHAPLAIN]} Aspirant",
                $"{_roles[eROLE.TECHMARINE]} Aspirant"
            ];
            break;
        case SPECIALISTS_HEADS:
            _role_list = [
                "Master of Sanctity",
                $"Chief {_roles[eROLE.LIBRARIAN]}",
                "Forge Master",
                obj_ini.role[100][eROLE.CHAPTERMASTER],
                "Master of the Apothecarion"
            ];
            break;
        case SPECIALISTS_VETERANS:
            _role_list = [
                _roles[eROLE.VETERAN],
                _roles[eROLE.TERMINATOR],
                _roles[eROLE.VETERANSERGEANT],
                _roles[eROLE.HONOURGUARD]
            ];
            break;
        case SPECIALISTS_RANK_AND_FILE:
            _role_list = [
                _roles[eROLE.TACTICAL],
                _roles[eROLE.DEVASTATOR],
                _roles[eROLE.ASSAULT],
                _roles[eROLE.SCOUT]
            ];
            break;
        case SPECIALISTS_SQUAD_LEADERS:
            _role_list = [
                _roles[eROLE.SERGEANT],
                _roles[eROLE.VETERANSERGEANT]
            ];
            break;
        case SPECIALISTS_COMMAND:
            _role_list = [
                _roles[eROLE.CAPTAIN],
                _roles[eROLE.APOTHECARY],
                _roles[eROLE.CHAPLAIN],
                _roles[eROLE.TECHMARINE],
                _roles[eROLE.LIBRARIAN],
                "Codiciery",
                "Lexicanum",
                _roles[eROLE.ANCIENT],
                _roles[eROLE.CHAMPION]
            ];
            break;
        case SPECIALISTS_DREADNOUGHTS:
            _role_list = [
                _roles[eROLE.DREADNOUGHT],
                $"Venerable {_roles[eROLE.DREADNOUGHT]}"
            ];
            break;
        case SPECIALISTS_CAPTAIN_CANDIDATES:
            _role_list = [
                _roles[eROLE.SERGEANT],
                _roles[eROLE.VETERANSERGEANT],
                _roles[eROLE.CHAMPION],
                _roles[eROLE.CAPTAIN],
                _roles[eROLE.TERMINATOR],
                _roles[eROLE.VETERAN],
                _roles[eROLE.ANCIENT]
            ];
            break;
    }

    return _role_list;
}

/// @description Checks if a given unit's role is a specialist within a specific role group.
/// @param {string} unit_role The role of the unit to check.
/// @param {integer} type The type of specialist group to check (default is SPECIALISTS_STANDARD).
/// @param {bool} include_trainee Whether to include trainee roles (default is false).
/// @param {bool} include_heads Whether to include head roles (default is true).
/// @returns {bool}
function is_specialist(unit_role, type = SPECIALISTS_STANDARD, include_trainee = false, include_heads = true) {
    var _specialists = role_groups(type, include_trainee, include_heads);

    return array_contains(_specialists, unit_role);
}

//TODO write this out with proper formatting when i can be assed
//Used to quikcly collect groups of marines with given parameters
// group takes a string relating to options in the role_groups function, to ignore filtering by group use "all"
// can also pass an array to filter for mutiple groups
// location takes wther a string with a system name or an array with 3 parameters [<location name>,<planet number>,<ship number>]
// if opposite is true then then the roles defined in the group argument are ignored and all others collected
// search conditions
// companies, takes either an int or an arrat to define which companies to search in
// any stat allowed by the stat_valuator basically allows you to look for marines whith certain stat lines
// job allows you to find marines forfuling certain tasks like garrison or forge etc

function collect_role_group(group = SPECIALISTS_STANDARD, location = "", opposite = false, search_conditions = {companies: "all"}) {
    var _units = [], unit, count = 0, _add = false, _is_special_group;
    var _max_count = 0;
    var _total_count = 0;
    if (struct_exists(search_conditions, "max")) {
        _max_count = search_conditions.max;
    }
    if (!struct_exists(search_conditions, "companies")) {
        search_conditions.companies = "all";
    }
    for (var com = 0; com <= 10; com++) {
        if (_max_count > 0) {
            if (array_length(_units) >= _max_count) {
                break;
            }
        }
        var _wanted_companies = search_conditions.companies;
        if (_wanted_companies != "all") {
            if (is_array(_wanted_companies)) {
                if (!array_contains(_wanted_companies, com)) {
                    continue;
                }
            } else {
                if (_wanted_companies != com) {
                    continue;
                }
            }
        }
        for (var i = 0; i < array_length(obj_ini.TTRPG[com]); i++) {
            if (_max_count > 0) {
                if (array_length(_units) >= _max_count) {
                    break;
                }
            }
            if (array_length(_units)) {
                _add = false;
            }
            unit = fetch_unit([com, i]);
            if (unit.name() == "") {
                continue;
            }
            if (group != "all") {
                if (is_array(group)) {
                    if (array_length(group) == 3) {
                        _is_special_group = unit.IsSpecialist(group[0], group[1], group[2]);
                    } else {
                        _is_special_group = unit.IsSpecialist(group[0], group[1]);
                    }
                } else {
                    _is_special_group = unit.IsSpecialist(group);
                }
            } else {
                _is_special_group = true;
            }
            if ((_is_special_group && !opposite) || (!_is_special_group && opposite)) {
                if (location == "") {
                    _add = true;
                } else if (!is_array(location)) {
                    _add = unit.is_at_location(location);
                } else {
                    _add = unit.is_at_location(location[0], location[1], location[2]);
                }
            }
            if (_add) {
                if (struct_exists(search_conditions, "stat")) {
                    _add = stat_valuator(search_conditions.stat, unit);
                }
                if (struct_exists(search_conditions, "job")) {
                    _add = unit.assignment() == search_conditions.job;
                }
            }
            if (_add) {
                array_push(_units, obj_ini.TTRPG[com][i]);
            }
        }
    }
    return _units;
}

function stat_valuator(search_params, unit) {
    var match = true;
    for (var stat = 0; stat < array_length(search_params); stat++) {
        var _stat_val = search_params[stat];
        if (!struct_exists(unit, _stat_val[0])) {
            match = false;
            break;
        }
        switch (_stat_val[2]) {
            case "inmore":
            case "more":
                if (unit[$ _stat_val[0]] < _stat_val[1]) {
                    match = false;
                    break;
                }
                break;

            case "exmore":
                if (unit[$ _stat_val[0]] <= _stat_val[1]) {
                    match = false;
                    break;
                }
                break;

            case "inless":
            case "less":
                if (unit[$ _stat_val[0]] > _stat_val[1]) {
                    match = false;
                    break;
                }
                break;

            case "exless":
                if (unit[$ _stat_val[0]] >= _stat_val[1]) {
                    match = false;
                    break;
                }
                break;
        }
    }
    return match;
}

function collect_by_religeon(religion, sub_cult = "", location = "") {
    var _units = [], unit, count = 0, _add = false;
    for (var com = 0; com <= 10; com++) {
        for (var i = 1; i < array_length(obj_ini.TTRPG[com]); i++) {
            _add = false;
            unit = obj_ini.TTRPG[com][i];
            if (unit.name() == "") {
                continue;
            }
            if (unit.religion == religion) {
                if (sub_cult != "") {
                    if (unit.religion_sub_cult != "sub_cult") {
                        continue;
                    }
                }
                if (location == "") {
                    _add = true;
                } else if (unit.is_at_location(location)) {
                    _add = true;
                }
            }
            if (_add) {
                array_push(_units, obj_ini.TTRPG[com][i]);
            }
        }
    }
    return _units;
}

/// @description Processes the selection of units based on group parameters and updates controller data
/// @param {array} group The array of units to process for selection
/// @param {struct} selection_data Data structure containing selection parameters and state

enum eMISSION_SELECT_TYPE {
    UNITS,
    SQUADS,
}

function group_selection(group, selection_data = {}) {
    try {
        var unit, s, unit_location;
        obj_controller.selection_data = selection_data;
        set_zoom_to_default();
        with (obj_controller) {
            if (menu != eMENU.MANAGE) {
                scr_toggle_manage();
            } else {
                basic_manage_settings();
            }

            exit_button = new ShutterButton();
            proceed_button = new ShutterButton();
            selection_data.start_count = 0;
            instance_destroy(obj_managment_panel);
            if (!struct_exists(selection_data, "select_type")) {
                selection_data.select_type = eMISSION_SELECT_TYPE.UNITS;
            }
            // Resets selections for next turn
            scr_ui_refresh();
            managing = -1;
            new_company_struct();
            var vehicles = [];
            for (var i = 0; i < array_length(group); i++) {
                if (!is_struct(group[i])) {
                    if (is_array(group[i])) {
                        array_push(vehicles, group[i]);
                    }
                    continue;
                }
                unit = group[i];
                add_man_to_manage_arrays(unit);

                if (selection_data.purpose_code == "forge_assignment") {
                    if (unit.job != "none") {
                        if (unit.job.type == "forge" && unit.job.planet == selection_data.planet) {
                            man_sel[array_length(display_unit) - 1] = 1;
                            man_size++;
                            selection_data.start_count++;
                        }
                    }
                }
            }
            var last_vehicle = 0;
            if (array_length(vehicles) > 0) {
                for (var veh = 0; veh < array_length(vehicles); veh++) {
                    unit = vehicles[veh];
                    add_vehicle_to_manage_arrays(unit);
                }
            }
            other_manage_data();
            man_current = 0;
            man_max = MANAGE_MAN_MAX;

            if (selection_data.select_type == eMISSION_SELECT_TYPE.SQUADS) {
                new_company_struct();
                company_data.has_squads = true;
                company_data.squad_location = selection_data.system.name;
                company_data.squad_search();
                managing = -1;
            }
        }
        LOGGER.debug($"manage_success {obj_controller.menu}");
    }
    catch (_exception) {
        //handle and send player back to map
        handle_exception(_exception);
        scr_toggle_manage();
    }
}
