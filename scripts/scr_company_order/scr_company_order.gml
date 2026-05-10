
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
        var _squadless = _company_marines.get_from({squadless : true});

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

            if (!_squad.fulfilled && _squad.type != "command_squad"){
                _squad.empty_squad_to_index(_squadless_index);
            }
        }

        var _empty_index = {};
        for (var i=0;i<array_length(_empty_squads);i++){
            var _squad = _empty_squads[i];
            _squad.update_fulfilment(_squadless_index);
            if (!_squad.fulfilled && _squad.type != "command_squad"){
                _squad.empty_squad_to_index(_squadless_index);
            } else {
                _squad.base_company = co;
                if (!struct_exists(_empty_index, _squad.type)){
                    _empty_index[$ _squad.type] = [];
                }
                array_push(_empty_index[$ _squad.type], _squad);
            }
        }

        var _squadless = _squadless_index.turn_to_UnitGroup();

        if (_squadless.number() > 3){
            var _squad_index = _company_marines.index_squads();
            var _data_match=false;
            var _data;
            if (struct_exists(obj_ini.chapter_squad_arrangement, "companies")){
                var _comp_datas = obj_ini.chapter_squad_arrangement.companies;
                for (var i=0;i<array_length(_comp_datas);i++){
                   if (_comp_datas[i].company == co){
                        _data_match = true;
                        _data = _comp_datas[i];
                   }
                }
            }
            if (_data_match){
                _squadless.organise_by_template(_data, _squad_index, _empty_index, false);
            }

        }

        _company_marines.order_by_rank();

        var _squads = _company_marines.count_squads("all",true);

        for (var i=0;i<array_length(_squads);i++){
            _squad = fetch_squad(_squads[i]);
            _squad.members = [];
        }

        var _temps = [];
        for (i = 0; i < array_length(_company_marines.units); i++) {
            var _unit = _company_marines.units[i];
            array_push(_temps , {
                unit : _unit,
                race : _unit.race(),
                name : _unit.name(),
                role : _unit.role(),
                wep1 : _unit.weapon_one(true),
                wep2 : _unit.weapon_two(true),
                armour : _unit.armour(true),
                gear : _unit.gear(true),
                mobi : _unit.mobility_item(true),
                age : _unit.age(),
                spe : _unit.specials(),
                god : _unit.god_status(),
            });
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
            TTRPG[co][i]  = _struc;
            race[co][i]   = _unit.race;
            name[co][i]   = _unit.name;
            role[co][i]   = _unit.role;
            wep1[co][i]   = _unit.wep1;
            wep2[co][i]   = _unit.wep2;
            armour[co][i] = _unit.armour;
            gear[co][i]   = _unit.gear;
            mobi[co][i]   = _unit.mobi;
            age[co][i]    = _unit.age;
            spe[co][i]    = _unit.spe;
            god[co][i]    = _unit.god;
            if (_struc.marine_number != i){
                if (TTRPG[_struc.company][_struc.marine_number].uid == _struc.uid){
                    TTRPG[_struc.company][_struc.marine_number] = new TTRPG_stats("chapter", _struc.company , _struc.marine_number, "blank");
                    scr_wipe_unit(_struc.company , _struc.marine_number);
                }
            }
            _struc.company       = co;
            _struc.marine_number = i;
            if (_struc.squad != "none"){
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
        handle_exception(_exception);
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
    ];

    return hierarchy;
}
