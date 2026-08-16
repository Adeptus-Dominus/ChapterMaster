function sort_all_companies() {
    with (obj_ini) {
        for (var i = 0; i <= obj_ini.companies; i++) {
            scr_company_order(i);
        }
    }
}

function sort_all_companies_to_map(map) {
    with (obj_ini) {
        for (var i = 0; i < array_length(map); i++) {
            if (map[i]) {
                scr_company_order(i);
            }
        }
    }
}

function company_length(company) {
    return array_length(obj_ini.TTRPG[company]);
}

function normalise_marine_numbers(company, start_index,length){
    for (var l = start_index; l < length; l++) {
        obj_ini.TTRPG[company][l].marine_number = l;
    }
}

function tally_marines() {
    obj_controller.command = 0;
    obj_controller.marines = 0;
    for (var co = 0; co <= obj_ini.companies; co++) {
        var _len = company_length(co);
        for (var i = _len - 1; i >= 0 ; i--) {
            var _unit = fetch_unit([co, i]);
            if (!is_struct(_unit)){
                array_delete(obj_ini.TTRPG[co],i,1);
                _len--;
                normalise_marine_numbers(co, i, _len);
                continue;
            }
            if (_unit.base_group != "astartes") {
                continue;
            }
            if (!_unit.IsSpecialist()) {
                obj_controller.marines++;
            } else {
                obj_controller.command++;
            }
        }
    }
}

function scr_company_order(company) {
    try {
        // company : company number
        // This sorts and crunches the marine variables for the company
        var co = company;

        var _empty_squads = [];

        var _roles = active_roles();

        var _company_marines = collect_company(company);
        var _squadless = _company_marines.get_from({squadless: true});

        var _squadless_index = _squadless.index_roles();
        // find units not in a _squad

        //at this point check that all squads have the right types and numbers of units in them
        var wanted_roles;
        var _squad_ids = get_squad_ids();
        for (var i = 0; i < array_length(_squad_ids); i++) {
            var _squad = fetch_squad(_squad_ids[i]);
            if (_squad.base_company != co) {
                if (!bool(array_length(_squad.members))) {
                    array_push(_empty_squads, _squad);
                }
                continue;
            }

            _squad.update_fulfilment(_squadless_index);

            if (!_squad.fulfilled && _squad.base != "command") {
                _squad.empty_squad_to_index(_squadless_index);
            }
        }

        var _empty_index = {};
        for (var i = 0; i < array_length(_empty_squads); i++) {
            var _squad = _empty_squads[i];
            _squad.update_fulfilment(_squadless_index);
            if (!_squad.fulfilled && _squad.base != "command") {
                _squad.empty_squad_to_index(_squadless_index);
            } else {
                _squad.base_company = co;
                if (!struct_exists(_empty_index, _squad.type)) {
                    _empty_index[$ _squad.type] = [];
                }
                array_push(_empty_index[$ _squad.type], _squad);
            }
        }

        _squadless = _squadless_index.turn_to_UnitGroup();

        if (_squadless.number() > 3) {
            var _squad_index = _company_marines.index_squads();
            var _data_match = false;
            var _data;
            if (struct_exists(obj_ini.chapter_squad_arrangement, "companies")) {
                var _comp_datas = obj_ini.chapter_squad_arrangement.companies;
                for (var i = 0; i < array_length(_comp_datas); i++) {
                    if (_comp_datas[i].company == co) {
                        _data_match = true;
                        _data = _comp_datas[i];
                    }
                }
            }
            if (_data_match) {
                _squadless.organise_by_template(_data, _squad_index, _empty_index, false);
            }

            _squadless = _squadless.get_from({group: SPECIALISTS_SQUAD_LEADERS, squadless: true});

            _squadless.for_each(function(loop_unit) {
                var _sgts = role_groups(SPECIALISTS_SQUAD_LEADERS);
                var _role_h_len = array_length(loop_unit.role_history);
                for (var i = _role_h_len - 1; i >= 0; i--) {
                    var _role = loop_unit.role_history[i][0];
                    if (!array_contains(_sgts, _role)) {
                        loop_unit.update_role(_role);
                        break;
                    }
                }
            });
        }

        _company_marines.order_by_rank();

        TTRPG[co] = _company_marines.units;

        for (var i = 0; i < array_length(TTRPG[co]); i++) {
            TTRPG[co][i].marine_number = i;
        }
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

function role_hierarchy() {
    var _roles = active_roles();
    var hierarchy = [
        _roles[eROLE.CHAPTERMASTER],
        "Forge Master",
        "Master of Sanctity",
        "Master of the Apothecarion",
        string("Chief {0}", _roles[eROLE.LIBRARIAN]),
        _roles[eROLE.HONOURGUARD],
        _roles[eROLE.CAPTAIN],
        _roles[eROLE.CHAPLAIN],
        string("{0} Aspirant", _roles[eROLE.CHAPLAIN]),
        "Death Company",
        _roles[eROLE.TECHMARINE],
        string("{0} Aspirant", _roles[eROLE.TECHMARINE]),
        "Techpriest",
        _roles[eROLE.APOTHECARY],
        string("{0} Aspirant", _roles[eROLE.APOTHECARY]),
        "Sister Hospitaler",
        _roles[eROLE.LIBRARIAN],
        "Codiciery",
        "Lexicanum",
        string("{0} Aspirant", _roles[eROLE.LIBRARIAN]),
        _roles[eROLE.ANCIENT],
        _roles[eROLE.CHAMPION],
        "Death Company",
        _roles[eROLE.VETERANSERGEANT],
        _roles[eROLE.SERGEANT],
        _roles[eROLE.TERMINATOR],
        _roles[eROLE.VETERAN],
        _roles[eROLE.TACTICAL],
        _roles[eROLE.ASSAULT],
        _roles[eROLE.DEVASTATOR],
        _roles[eROLE.SCOUT],
        $"Venerable {_roles[eROLE.DREADNOUGHT]}",
        _roles[eROLE.DREADNOUGHT],
        "Skitarii",
        "Crusader",
        "Ranger",
        "Sister of Battle",
        "Flash Git",
        "Ork Sniper",
    ];

    return hierarchy;
}
