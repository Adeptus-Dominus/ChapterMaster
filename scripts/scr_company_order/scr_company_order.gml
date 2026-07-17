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
            var _data = resolve_company_arrangement(obj_ini.chapter_squad_arrangement, co);
            if (_data != undefined) {
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
            var _squad = fetch_squad(_squads[i]);
            _squad.members = [];
        }

        var _temps = [];
        for (var i = 0; i < array_length(_company_marines.units); i++) {
            var _unit = _company_marines.units[i];
            array_push(_temps, {unit: _unit, race: _unit.race(), name: _unit.name(), role: _unit.role(), wep1: _unit.weapon_one(true), wep2: _unit.weapon_two(true), armour: _unit.armour(true), gear: _unit.gear(true), mobi: _unit.mobility_item(true), age: _unit.age(), spe: _unit.specials(), god: _unit.god_status()});
        }

        for (var i = 0; i < array_length(_temps); i++) {
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
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

// base role (JSON slot key) loads array of renamed "role"-override variants across all squad types
// cached across calls; pass true to rebuild after squad_types is loaded
function squad_role_renames(_rebuild = false) {
    static _cache = undefined;
    if (!instance_exists(obj_ini) || !variable_instance_exists(obj_ini, "squad_types")) {
        return {};
    }
    if (_rebuild || _cache == undefined) {
        _cache = {};
        var _types = struct_get_names(obj_ini.squad_types);
        for (var _si = 0; _si < array_length(_types); _si++) {
            var _sq = obj_ini.squad_types[$ _types[_si]];
            var _keys = struct_get_names(_sq);
            for (var _ki = 0; _ki < array_length(_keys); _ki++) {
                var _k = _keys[_ki];
                if (_k == "type_data") continue;
                if (!struct_exists(_sq[$ _k], "role")) continue;
                _cache[$ _k] = _cache[$ _k] ?? [];
                if (!array_contains(_cache[$ _k], _sq[$ _k].role)) {
                    array_push(_cache[$ _k], _sq[$ _k].role);
                }
            }
        }
    }
    return _cache;
}

function role_hierarchy(_rebuild = false) {
    static _cache = undefined;
    if (_rebuild || _cache == undefined) {
        var _roles = obj_ini.role[100];
        var _h = [
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
            _roles[eROLE.VETERANSERGEANT],
            _roles[eROLE.SERGEANT],
            _roles[eROLE.TERMINATOR],
            _roles[eROLE.VETERAN],
            _roles[eROLE.TACTICAL],
            _roles[eROLE.ASSAULT],
            _roles[eROLE.DEVASTATOR],
            _roles[eROLE.SCOUT],
            _roles[eROLE.BIKER],
            _roles[eROLE.ATTACK_BIKER],
            $"Venerable {_roles[eROLE.DREADNOUGHT]}",
            _roles[eROLE.DREADNOUGHT],
            "Skitarii",
            "Crusader",
            "Ranger",
            "Sister of Battle",
            "Flash Git",
            "Ork Sniper"
        ];

        // Splice renamed squad roles in directly after their base role via JSON key
        var _renames = squad_role_renames(_rebuild);
        var _bases = struct_get_names(_renames);
        for (var _bi = 0; _bi < array_length(_bases); _bi++) {
            var _anchor = array_get_index(_h, _bases[_bi]);
            var _variants = _renames[$ _bases[_bi]];
            for (var _vi = 0; _vi < array_length(_variants); _vi++) {
                if (array_contains(_h, _variants[_vi])) continue;
                if (_anchor >= 0) {
                    array_insert(_h, _anchor + 1, _variants[_vi]);
                } else {
                    array_push(_h, _variants[_vi]);
                }
            }
        }
        _cache = _h;
    }
    return variable_clone(_cache); //here so cache isn't killed by rewording
}
