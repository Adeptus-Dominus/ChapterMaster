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

function scr_company_order(company) {
    try {
        // company : company number
        // This sorts and crunches the marine variables for the company
        var co = company;

        var i = -1;

        var _empty_squads = [];
        var _squadless = {};

        var _roles = active_roles();

        var _company_marines = collect_company(company);
        var _squadless = _company_marines.get_from({squadless: true});

        var _squadless_index = _squadless.index_roles();
        // find units not in a _squad

        //at this point check that all squads have the right types and numbers of units in them
        var _squad, wanted_roles;
        var _squad_ids = get_squad_ids();
        for (i = 0; i < array_length(_squad_ids); i++) {
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

        var _squadless = _squadless_index.turn_to_UnitGroup();

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

            _squadless
                .for_each(function(loop_unit) {
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

        var _squads = _company_marines.count_squads("all", true);

        for (var i = 0; i < array_length(_squads); i++) {
            _squad = fetch_squad(_squads[i]);
            _squad.members = [];
        }

        var _temps = [];
        for (i = 0; i < array_length(_company_marines.units); i++) {
            var _unit = _company_marines.units[i];
            array_push(_temps, {unit: _unit, race: _unit.race(), name: _unit.name(), role: _unit.role(), wep1: _unit.weapon_one(true), wep2: _unit.weapon_two(true), armour: _unit.armour(true), gear: _unit.gear(true), mobi: _unit.mobility_item(true), age: _unit.age(), spe: _unit.specials(), god: _unit.god_status()});
        }

        //position 2 in role order
        /*if (global.chapter_name!="Space Wolves") and (global.chapter_name!="Iron Hands"){
	i=0;repeat(300){i+=1;
	    if (role[co][i]=_roles[Roles.CHAPLAIN]){v+=1;
	        temp_marine_variables(co, i ,v);
	    }
	}*/

        for (i = 0; i < array_length(_temps); i++) {
            var _unit = _temps[i];
            var _struc = _unit.unit;
            TTRPG[co][i] = _struc;
            race[co][i] = _unit.race;
            name[co][i] = _unit.name;
            role[co][i] = _unit.role;
            wep1[co][i] = _unit.wep1;
            wep2[co][i] = _unit.wep2;
            armour[co][i] = _unit.armour;
            gear[co][i] = _unit.gear;
            mobi[co][i] = _unit.mobi;
            age[co][i] = _unit.age;
            spe[co][i] = _unit.spe;
            god[co][i] = _unit.god;
            if (_struc.marine_number != i) {
                if (TTRPG[_struc.company][_struc.marine_number].uid == _struc.uid) {
                    TTRPG[_struc.company][_struc.marine_number] = new TTRPG_stats("chapter", _struc.company, _struc.marine_number, "blank");
                    scr_wipe_unit(_struc.company, _struc.marine_number);
                }
            }
            _struc.company = co;
            _struc.marine_number = i;
            if (_struc.squad != "none") {
                var _squad = _struc.get_squad();
                array_push(_squad.members, [co, i]);
            }
            _struc.movement_after_math(co, i, false);
        }
        /*	i=0;repeat(300){i+=1;
	    if (role[co][i]="Death Company"){
	        if (string_count("Dreadnought",armour[co][i])>0){v+=1;
	            temp_marine_variables(co, i ,v);
	        }
	    }
	}

	i=0;repeat(300){i+=1;
	    if (role[co][i]="Death Company"){
	        if (string_count("Dreadnought",armour[co][i])=0) and (string_count("Terminator",armour[co][i])=0) and (armour[co][i]!="Tartaros"){v+=1;
	            temp_marine_variables(co, i ,v);
	        }
	    }
	}*/
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

function role_hierarchy() {
    var _roles = obj_ini.role[100];
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
    ];

    // Dynamically collect squad-specific sergeant role variants (e.g. "Biker Sergeant", "Tactical Sergeant")
    // so they sort immediately after the generic sergeant, keeping them at the top of their squads
    var _sgt_base  = _roles[eROLE.SERGEANT];
    var _vsgt_base = _roles[eROLE.VETERANSERGEANT];
    var _squad_type_names = struct_get_names(obj_ini.squad_types);
    for (var _si = 0; _si < array_length(_squad_type_names); _si++) {
        var _sq_data = obj_ini.squad_types[$ _squad_type_names[_si]];
        var _sq_keys = struct_get_names(_sq_data);
        for (var _ki = 0; _ki < array_length(_sq_keys); _ki++) {
            var _k = _sq_keys[_ki];
            if (_k == "type_data") continue;
            var _role_def = _sq_data[$ _k];
            if (!struct_exists(_role_def, "role")) continue;
            var _specific_role = _role_def.role;
            if (!array_contains(hierarchy, _specific_role)) {
                if (string_count(_vsgt_base, _specific_role) > 0) {
                    // Veteran-sergeant variant — insert just before _vsgt_base position
                    var _vpos = array_get_index(hierarchy, _vsgt_base);
                    array_insert(hierarchy, max(0, _vpos), _specific_role);
                } else if (string_count(_sgt_base, _specific_role) > 0) {
                    // Regular sergeant variant — insert just after _sgt_base position
                    var _spos = array_get_index(hierarchy, _sgt_base);
                    array_insert(hierarchy, _spos + 1, _specific_role);
                }
            }
        }
    }

    // Also add non-sergeant squad-specific role variants so they appear after their base role
    var _base_roles = [
        _roles[eROLE.TERMINATOR], _roles[eROLE.VETERAN],
        _roles[eROLE.TACTICAL], _roles[eROLE.ASSAULT],
        _roles[eROLE.DEVASTATOR], _roles[eROLE.SCOUT],
        _roles[eROLE.ANCIENT], _roles[eROLE.CHAMPION],
        _roles[eROLE.CHAPLAIN], _roles[eROLE.APOTHECARY],
        _roles[eROLE.TECHMARINE], _roles[eROLE.LIBRARIAN]
    ];
    for (var _si = 0; _si < array_length(_squad_type_names); _si++) {
        var _sq_data = obj_ini.squad_types[$ _squad_type_names[_si]];
        var _sq_keys = struct_get_names(_sq_data);
        for (var _ki = 0; _ki < array_length(_sq_keys); _ki++) {
            var _k = _sq_keys[_ki];
            if (_k == "type_data") continue;
            var _role_def = _sq_data[$ _k];
            if (!struct_exists(_role_def, "role")) continue;
            var _specific_role = _role_def.role;
            if (array_contains(hierarchy, _specific_role)) continue;
            // Skip sergeant variants (already handled above)
            if (string_count(_sgt_base, _specific_role) > 0) continue;
            // Find the closest matching base role and insert after it
            for (var _bi = 0; _bi < array_length(_base_roles); _bi++) {
                if (struct_exists(_role_def, "alternative_roles") &&
                    array_contains(_role_def.alternative_roles, _base_roles[_bi])) {
                    var _bpos = array_get_index(hierarchy, _base_roles[_bi]);
                    if (_bpos >= 0) {
                        array_insert(hierarchy, _bpos + 1, _specific_role);
                        break;
                    }
                }
            }
            // If not inserted via alternative_roles, just append before rank-and-file
            if (!array_contains(hierarchy, _specific_role)) {
                array_push(hierarchy, _specific_role);
            }
        }
    }

    array_push(hierarchy,
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
        "Ork Sniper"
    );

    return hierarchy;
}
