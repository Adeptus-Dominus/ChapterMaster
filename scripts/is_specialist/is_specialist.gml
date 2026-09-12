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
#macro SPECIALISTS_BRANCHES "branches"
#macro SPECIALISTS_HEADS "heads"

/// @description Retrieves the active roles from the game, either from the obj_creation or obj_ini object.
/// @returns {Array<String>}
function active_roles() {
    var _obj = active_game_ini().player_role_data;
    var _roles = [];
    for (var i = 0; i < array_length(_obj); i++) {
        array_push(_roles, struct_exists(_obj[i], "role") ? _obj[i].role : "");
    }
    return _roles;
}

/// @description Returns a list of roles based on the specified group, with optional inclusion of trainees and heads.
/// @param {String} group The group of roles to retrieve (e.g., SPECIALISTS_STANDARD, SPECIALISTS_LIBRARIANS).
/// @param {Bool} include_trainee Whether to include trainee roles (default is false).
/// @param {Bool} include_heads Whether to include head roles (default is true).
/// @returns {Array<String>}
function role_groups(group, include_trainee = false, include_heads = true, allow_subsearches = true) {
    var _role_list = [];
    var _roles = active_roles();
    var _chap_name = instance_exists(obj_creation) ? obj_creation.chapter_name : global.chapter_name;

    switch (group) {
        case SPECIALISTS_STANDARD:
            _role_list = [
                _roles[eROLE.CAPTAIN],
                _roles[eROLE.DREADNOUGHT],
                _roles[eROLE.CHAMPION],
                _roles[eROLE.CHAPLAIN],
                _roles[eROLE.APOTHECARY],
                _roles[eROLE.TECHMARINE],
                _roles[eROLE.LIBRARIAN],
                _roles[eROLE.CODICIERY],
                _roles[eROLE.LEXICANUM],
                _roles[eROLE.HONOURGUARD],
            ];
            if (include_trainee) {
                _role_list = array_concat(_role_list, role_groups(SPECIALISTS_TRAINEES));
            }
            if (include_heads) {
                _role_list = array_concat(_role_list, role_groups(SPECIALISTS_HEADS));
            }
            break;

        case SPECIALISTS_BRANCHES:
            _role_list = [
                _roles[eROLE.CHAPLAIN],
                _roles[eROLE.APOTHECARY],
                _roles[eROLE.TECHMARINE],
                _roles[eROLE.LIBRARIAN],
                _roles[eROLE.CODICIERY],
                _roles[eROLE.LEXICANUM],
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
                _roles[eROLE.CODICIERY],
                _roles[eROLE.LEXICANUM],
            ];
            if (include_trainee) {
                array_push(_role_list, _roles[eROLE.LIBRARIANASPIRANT]);
            }
            if (include_heads) {
                array_push(_role_list, _roles[eROLE.CHIEFLIBRARIAN]);
            }
            break;
        case SPECIALISTS_TECHS:
            _role_list = [
                "Techpriest",
            ];
            _role_list = array_concat(_role_list, role_groups(SPECIALISTS_TECHMARINES, include_trainee, include_heads, false));
            break;
        case SPECIALISTS_TECHMARINES:
            _role_list = [_roles[eROLE.TECHMARINE]];
            if (include_trainee) {
                array_push(_role_list, _roles[eROLE.TECHMARINEASPIRANT]);
            }
            if (include_heads) {
                array_push(_role_list, _roles[eROLE.FORGEMASTER]);
            }
            if (_chap_name == "Iron Hands" && allow_subsearches) {
                _role_list = array_concat(_role_list, role_groups(SPECIALISTS_CHAPLAINS, include_trainee, include_heads, false));
            }
            break;
        case SPECIALISTS_CHAPLAINS:
            _role_list = [_roles[eROLE.CHAPLAIN]];
            if (include_trainee) {
                array_push(_role_list, _roles[eROLE.CHAPLAINASPIRANT]);
            }
            if (include_heads) {
                array_push(_role_list, _roles[eROLE.MASTERCHAPLAIN]);
            }
            if (scr_has_adv("Spiritual Healers") && allow_subsearches) {
                _role_list = array_concat(_role_list, role_groups(SPECIALISTS_APOTHECARIES, include_trainee, include_heads, false));
            }
            if (_chap_name == "Iron Hands" && allow_subsearches) {
                _role_list = array_concat(_role_list, role_groups(SPECIALISTS_TECHS, include_trainee, include_heads, false));
            }
            break;
        case SPECIALISTS_APOTHECARIES:
            _role_list = [_roles[eROLE.APOTHECARY]];
            if (include_trainee) {
                array_push(_role_list, _roles[eROLE.APOTHECARYASPIRANT]);
            }
            if (include_heads) {
                array_push(_role_list, _roles[eROLE.MASTERAPOTHECARY]);
            }
            if (scr_has_adv("Spiritual Healers") && allow_subsearches) {
                _role_list = array_concat(_role_list, role_groups(SPECIALISTS_CHAPLAINS, include_trainee, include_heads, false));
            }
            break;

        case SPECIALISTS_TRAINEES:
            _role_list = [
                _roles[eROLE.LIBRARIANASPIRANT],
                _roles[eROLE.APOTHECARYASPIRANT],
                _roles[eROLE.CHAPLAINASPIRANT],
                _roles[eROLE.TECHMARINEASPIRANT],
            ];
            break;
        case SPECIALISTS_HEADS:
            _role_list = [
                _roles[eROLE.FORGEMASTER],
                _roles[eROLE.CHIEFLIBRARIAN],
                _roles[eROLE.MASTERAPOTHECARY],
                _roles[eROLE.CHAPTERMASTER],
                _roles[eROLE.MASTERCHAPLAIN],
            ];
            break;
        case SPECIALISTS_VETERANS:
            _role_list = [
                _roles[eROLE.VETERAN],
                _roles[eROLE.TERMINATOR],
                _roles[eROLE.VETERANSERGEANT],
                _roles[eROLE.HONOURGUARD],
            ];
            break;
        case SPECIALISTS_RANK_AND_FILE:
            _role_list = [
                _roles[eROLE.TACTICAL],
                _roles[eROLE.DEVASTATOR],
                _roles[eROLE.ASSAULT],
                _roles[eROLE.SCOUT],
            ];
            break;
        case SPECIALISTS_SQUAD_LEADERS:
            _role_list = [
                _roles[eROLE.SERGEANT],
                _roles[eROLE.VETERANSERGEANT],
            ];
            break;
        case SPECIALISTS_COMMAND:
            _role_list = [
                _roles[eROLE.CAPTAIN],
                _roles[eROLE.APOTHECARY],
                _roles[eROLE.CHAPLAIN],
                _roles[eROLE.TECHMARINE],
                _roles[eROLE.LIBRARIAN],
                _roles[eROLE.CODICIERY],
                _roles[eROLE.LEXICANUM],
                _roles[eROLE.ANCIENT],
                _roles[eROLE.CHAMPION],
            ];
            break;
        case SPECIALISTS_DREADNOUGHTS:
            _role_list = [_roles[eROLE.DREADNOUGHT]];
            break;
        case SPECIALISTS_CAPTAIN_CANDIDATES:
            _role_list = [
                _roles[eROLE.SERGEANT],
                _roles[eROLE.VETERANSERGEANT],
                _roles[eROLE.CHAMPION],
                _roles[eROLE.CAPTAIN],
                _roles[eROLE.TERMINATOR],
                _roles[eROLE.VETERAN],
                _roles[eROLE.ANCIENT],
            ];
            break;
    }

    return _role_list;
}

/// @description Checks if a given unit's role is a specialist within a specific role group.
/// @param {String} unit_role The role of the unit to check.
/// @param {String} type The type of specialist group to check (default is SPECIALISTS_STANDARD).
/// @param {Bool} include_trainee Whether to include trainee roles (default is false).
/// @param {Bool} include_heads Whether to include head roles (default is true).
/// @returns {Bool}
function is_specialist(unit_role, type = SPECIALISTS_STANDARD, include_trainee = false, include_heads = true) {
    var _specialists = role_groups(type, include_trainee, include_heads);
    var _check_string = "";
    if (is_string(unit_role)) {
        _check_string = unit_role;
    } else {
        var _obj = instance_exists(obj_ini) ? obj_ini : obj_creation;
        _check_string = _obj.player_role_data[unit_role].role;
    }
    return array_contains(_specialists, _check_string);
}
