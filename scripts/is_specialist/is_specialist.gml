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
