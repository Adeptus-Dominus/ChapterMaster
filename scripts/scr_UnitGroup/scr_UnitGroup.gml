function UnitGroup(units) constructor {
    self.units = units;

    static number = function() {
        return array_length(units);
    };

    static shuffle = function() {
        units = array_shuffle(units);
    };

    static has_role = function(role) {
        for (var i = 0; i < array_length(units); i++) {
            if (units[i].role() == role) {
                return true;
            }
        }

        return false;
    };

    static has_base_group = function(group) {
        for (var i = 0; i < array_length(units); i++) {
            if (units[i].base_group == group) {
                return true;
            }
        }
        return false;
    };

    static has_allegiance = function(allegiance) {
        for (var i = 0; i < array_length(units); i++) {
            if (units[i].allegiance == allegiance) {
                return true;
            }
        }
        return false;
    };

    static get_from = function(search_conditions = {}, as_UnitGroup = true, remove_from = false) {
        var _wanted = [];
        var conditions = new SearchConditions(search_conditions);
        var _search_len = array_length(units) - 1;
        var _has_conditions = !struct_empty(search_conditions);
        for (var i = _search_len; i >= 0; i--) {
            var _want = true;
            if (_has_conditions) {
                _want = conditions.evaluate(units[i]);
            }
            if (_want) {
                array_push(_wanted, units[i]);
                if (remove_from) {
                    array_delete(units, i, 1);
                }
            }
            if (conditions.end_loop) {
                break;
            }
        }

        if (as_UnitGroup) {
            return new UnitGroup(_wanted);
        } else {
            return _wanted;
        }
    };

    static add_units = function(group_two, conditions = {}, remove_from = false, join_index = -1) {
        var _new_adds = group_two.get_from(conditions, false, remove_from);
        if (!bool(array_length(_new_adds))) {
            return;
        }

        if (join_index > array_length(units) - 1) {
            join_index = -1;
        }
        if (join_index > -1) {
            for (var i = array_length(_new_adds) - 1; i >= 0; i--) {
                var _unit = _new_adds[i];
                array_insert(units, join_index, _unit);
            }
        } else {
            for (var i = 0; i < array_length(_new_adds); i++) {
                var _unit = _new_adds[i];
                array_push(units, _unit);
            }
        }
    };

    static index_roles = function() {
        return new UnitIndex(units);
    };

    static highest_exp = function() {
        var _highest_exp = 0;
        var _exp_unit;
        for (var i = 0; i < number(); i++) {
            var _unit = units[i];
            if (i == 0) {
                _highest_exp = _unit.experience;
                _exp_unit = _unit;
                continue;
            }

            if (_unit.experience > _highest_exp) {
                _highest_exp = _unit.experience;
                _exp_unit = _unit;
            }
        }

        return _exp_unit;
    };

    static kill_percent = function(kill_percent, equipment = true, gene_seed_collect = true) {
        var _kill_numb = floor((kill_percent / 100) * number());
        var _killed = 0;
        var i = 0;
        while (_killed < _kill_numb && i < number()) {
            var _unit = units[i];
            if (kill_percent < 100 && _unit.role() == active_roles()[eROLE.CHAPTERMASTER]) {
                i++;
                continue;
            }
            kill_and_recover(_unit.company, _unit.marine_number, equipment, gene_seed_collect);
            _killed++;
            i++;
        }
    };

    static for_each = function(unit_func) {
        for (var i = 0; i < array_length(self.units); i++) {
            unit_func(units[i]);
        }
    };

    static count_squads = function(squad_type = "all", return_array = false) {
        var _count = 0;
        var _squads = [];
        var _unit, _squad;
        var _all_squads = squad_type == "all";
        for (var i = 0; i < array_length(units); i++) {
            _unit = units[i];
            if (_unit.squad == "none") {
                continue;
            }
            if (array_contains(_squads, _unit.squad)) {
                continue;
            }

            _squad = _unit.get_squad();

            var _add = true;
            if (squad_type != "all") {
                if (_squad.type != squad_type) {
                    _add = false;
                }
            }
            if (_add) {
                _count++;
                array_push(_squads, _unit.squad);
            }
        }

        if (!return_array) {
            return _count;
        } else {
            return _squads;
        }
    };

    static index_squads = function() {
        var _count = 0;
        var _squads = [];
        var _squad_index = {};
        var _unit, _squad;
        for (var i = 0; i < array_length(units); i++) {
            _unit = units[i];
            if (_unit.squad == "none") {
                continue;
            }
            if (array_contains(_squads, _unit.squad)) {
                continue;
            }

            _squad = _unit.get_squad();

            if (!struct_exists(_squad_index, _squad.type)) {
                _squad_index[$ _squad.type] = [];
            }
            array_push(_squad_index[$ _squad.type], _unit.squad);
        }

        return _squad_index;
    };

    var _roles = active_roles();

    static sgt_types = role_groups(SPECIALISTS_SQUAD_LEADERS);

    static create_squad = function(squad_type, squad_loadout = true, squad_uid = "", game_start = false) {
        LOGGER.info($"sgts : ${sgt_types}");

        var roles = active_roles();

        var squad;
        if (squad_uid != "") {
            squad = fetch_squad(squad_uid);
        } else {
            squad = new UnitSquad(squad_type);
        }

        var squad_fulfilment = squad.squad_fulfilment;

        var sergeant_found = false;

        var squad_unit_types = squad.find_squad_unit_types();

        var _fill_squad = obj_ini.squad_types[$ squad_type];

        var _fulfilled = false;

        var _squadless = get_from({squadless: true, roles: squad_unit_types});

        for (var s = 0; s < 2; s++) {
            var _sgt_type = sgt_types[s];
            var _available_sgt = _squadless.get_from({role: _sgt_type, max_wanted: 1});

            if (_available_sgt.number() == 0) {
                continue;
            }

            var _sgt = _available_sgt.units[0];
            squad.add_member(_sgt);
            squad_fulfilment[$ _sgt_type]++;
            sergeant_found = true;
        }

        LOGGER.info($"ready to squad {_squadless.number()}");

        var _unit;
        for (var i = 0; i < _squadless.number(); i++) {
            //fill squad roles

            _unit = _squadless.units[i];

            //if no sergeant found add one marine to standard marine selection so that a marine can be promoted

            var _has_sgt_requirements = false;
            for (var s = 0; s < 2; s++) {
                var _sgt_type = sgt_types[s];
                if (array_contains(squad_unit_types, _sgt_type)) {
                    _has_sgt_requirements = true;
                }
            }

            if (_has_sgt_requirements && sergeant_found) {
                _has_sgt_requirements = false;
            }

            //clone or else keeps pushing up number
            var _max = variable_clone(_fill_squad[$ _unit.role()][$ "max"]);
            if (_has_sgt_requirements) {
                _max += 1;
            }

            if (squad_fulfilment[$ _unit.role()] < _max) {
                //if sergeants not required
                squad_fulfilment[$ _unit.role()]++;
                squad.add_member(_unit.company, _unit.marine_number);
            }
        }

        //if a new sergeant is needed find the marine with the highest experience in the squad
        //(which if everything works right should be a marine with the old_guard, seasoned, or ancient trait)
        /*and ((squad_fulfilment[$ obj_ini.role[100][8]] > 4)or (squad_fulfilment[$ obj_ini.role[100][10]] > 4) or (squad_fulfilment[$ obj_ini.role[100][9]] > 4)or (squad_fulfilment[$ obj_ini.role[100][3]] > 4) )*/

        var _members = squad.get_members(true);
        if (!bool(_members.number())) {
            return [false, squad.uid];
        }
        for (var s = 0; s < 2; s++) {
            var _sgt_type = sgt_types[s];
            if (struct_exists(squad_fulfilment, _sgt_type) && (!sergeant_found)) {
                var _exp_unit = _members.highest_exp();

                squad_fulfilment[$ _sgt_type]++;
            }
        }

        //evaluate if the minimum _unit type requirements have been met to create a new squad
        _fulfilled = true;
        for (var i = 0; i < array_length(squad_unit_types); i++) {
            var _unit_role = squad_unit_types[i];
            LOGGER.info($"{_unit_role}, {squad_fulfilment[$ _unit_role]}, {_fill_squad[$ _unit_role][$ "min"]}");
            if (squad_fulfilment[$ _unit_role] < _fill_squad[$ _unit_role][$ "min"]) {
                _fulfilled = false;
                break;
            }
        }
        if (_fulfilled) {
            for (var s = 0; s < 2; s++) {
                if (struct_exists(squad_fulfilment, sgt_types[s]) && (sergeant_found == false)) {
                    _exp_unit.update_role(sgt_types[s]); //if squad is viable promote marine to sergeant
                    if (game_start && irandom(1) == 0) {
                        _exp_unit.add_trait("lead_example");
                    }
                }
            }
            //update units squad marker
            squad.squad_fulfilment = squad_fulfilment;
            for (var i = 0; i < _members.number(); i++) {
                _unit = _members.units[i];
                _unit.squad = squad.uid;
            }
            obj_ini.squads[$ squad.uid] = squad;

            if (squad_loadout) {
                squad.sort_squad_loadout(!game_start, !game_start);
            }
        }

        return [_fulfilled, squad.uid];
    };

    /// @param {Struct} _template
    /// @param {Struct} _squad_index
    /// @param {Struct} _empty_squads_index
    /// @param {Bool} _is_game_start
    static organise_by_template = function(_template, _squad_index = {}, _empty_squads_index = {}, _is_game_start = true) {
        if (!_template || !struct_exists(_template, "squads")) {
            return;
        }

        var _required_squads = [];
        var _proportional_squads = [];
        var _valid_squad_types = obj_ini.squad_types;

        // 1. Template
        var _template_squad_list = _template.squads;
        for (var i = 0, _count = array_length(_template_squad_list); i < _count; i++) {
            var _squad_definition = _template_squad_list[i];
            var _squad_type_name = _squad_definition.squad;

            if (!struct_exists(_valid_squad_types, _squad_type_name)) {
                continue;
            }

            if (!struct_exists(_squad_index, _squad_type_name)) {
                _squad_index[$ _squad_type_name] = [];
            }

            if (_squad_definition[$ "require"]) {
                array_push(_required_squads, _squad_definition);
            } else if (_squad_definition[$ "proportion"]) {
                array_push(_proportional_squads, _squad_definition);
            }
        }

        // 2. Required Squads
        for (var i = 0, _count = array_length(_required_squads); i < _count; i++) {
            var _squad_data = _required_squads[i];
            var _squad_name = _squad_data.squad;
            var _current_count = array_length(_squad_index[$ _squad_name]);

            while (_current_count < _squad_data.min_count) {
                if (_process_squad_creation(_squad_name, _empty_squads_index, _template.company, _is_game_start)) {
                    _current_count++;
                } else {
                    break;
                }
            }
        }

        // 3. Proportional Squads
        var _has_created_squad_this_pass = true;
        while (_has_created_squad_this_pass) {
            _has_created_squad_this_pass = false;

            for (var i = 0, _count = array_length(_proportional_squads); i < _count; i++) {
                var _squad_data = _proportional_squads[i];
                var _squad_name = _squad_data.squad;
                var _proportion_amount = _squad_data.proportion;

                for (var p = 0; p < _proportion_amount; p++) {
                    if (_process_squad_creation(_squad_name, _empty_squads_index, _template.company, _is_game_start)) {
                        _has_created_squad_this_pass = true;
                    } else {
                        break;
                    }
                }
            }
        }
    };

    static _process_squad_creation = function(_type_name, _empty_index, _company, _start_flag) {
        var _target_uid = "";
        var _available_pool = _empty_index[$ _type_name];

        if (is_array(_available_pool) && array_length(_available_pool) > 0) {
            _target_uid = _available_pool[0].uid;
        }

        var _result = create_squad(_type_name, true, _target_uid, _start_flag);
        if (_result[0]) {
            var _new_squad_instance = fetch_squad(_result[1]);
            _new_squad_instance.base_company = _company;

            if (_target_uid != "") {
                array_delete(_available_pool, 0, 1);
                if (array_length(_available_pool) == 0) {
                    struct_remove(_empty_index, _type_name);
                }
            }
            return true;
        }
        return false;
    };

    static order_by_rank = function() {
        // the order that marines are displayed in the company view screen(this order is augmented by squads)
        var _role_orders = role_hierarchy();
        var _role_shuffle_length = array_length(_role_orders);
        var _match_roles = new UnitGroup([]);
        var _sorted_squads = [];
        for (var role_name = 0; role_name < _role_shuffle_length; role_name++) {
            var _wanted_role = _role_orders[role_name];
            _match_roles.add_units(self, {role: _wanted_role}, true, -1);
            for (var i = 0; i < array_length(_match_roles.units); i++) {
                var _unit = _match_roles.units[i];
                if (_unit.squad == "none" || array_contains(_sorted_squads, _unit.squad)) {
                    continue;
                }
                var _squad = fetch_squad(_unit.squad);
                var _members_count = array_length(_squad.members);
                var _conditions = {
                    squad: _unit.squad,
                    max_wanted: _members_count,
                };
                _match_roles.add_units(self, _conditions, true, i + 1);

                array_push(_sorted_squads, _unit.squad);
            }
        }
        _match_roles.add_units(self, {}, true);
        units = _match_roles.units;
    };
}

function UnitIndex(units) constructor {
    role_index = {};

    static add_to_index = function(units) {
        for (var i = 0; i < array_length(units); i++) {
            var _unit = units[i];
            if (!struct_exists(role_index, _unit.role())) {
                role_index[$ _unit.role()] = [_unit];
            } else {
                array_push(role_index[$ _unit.role()], _unit);
            }
        }
    };

    add_to_index(units);

    static has_role = function(role) {
        return struct_exists(role_index, role) && array_length(role_index[$ role]) > 0;
    };

    static keys = function() {
        return struct_get_names(role_index);
    };

    static pop_role_member = function(role) {
        return array_pop(role_index[$ role]);
    };

    static turn_to_UnitGroup = function() {
        var _units = [];
        var _keys = keys();
        for (var i = 0; i < array_length(_keys); i++) {
            var _role = _keys[i];
            for (var u = 0; u < array_length(role_index[$ _role]); u++) {
                array_push(_units, role_index[$ _role][u]);
            }
        }
        return new UnitGroup(_units);
    };
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

function collect_company(company) {
    return collect_role_group("all", "", false, {companies: company}, true);
}

function collect_role_group(group = SPECIALISTS_STANDARD, location = "", opposite = false, search_conditions = {}, return_as_UnitGroup = false) {
    var _units = [], _unit, count = 0, _add = false, _is_special_group;
    var _max_count = 0;
    var _total_count = 0;
    if (struct_exists(search_conditions, "max")) {
        _max_count = search_conditions.max;
        search_conditions.max_wanted = search_conditions.max;
    }
    if (!struct_exists(search_conditions, "companies")) {
        search_conditions.companies = "all";
    }
    search_conditions.group = group;
    search_conditions.location = location;
    search_conditions.opposite = opposite;

    var _conditions = new SearchConditions(search_conditions);
    for (var com = 0; com <= obj_ini.companies; com++) {
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
        var _company = obj_ini.TTRPG[com];
        for (var i = 0; i < array_length(_company); i++) {
            if (_conditions.end_loop) {
                break;
            }
            _unit = fetch_unit([com, i]);

            if (_conditions.evaluate(_unit)) {
                array_push(_units, _unit);
            }
        }
    }
    if (return_as_UnitGroup) {
        return new UnitGroup(_units);
    }
    return _units;
}

function SearchConditions(data) constructor {
    group = "all";
    opposite = false;
    location = "";
    max_wanted = 0;
    companies = "all";
    allegiance = "";
    squadless = false;
    role = "";
    roles = [];
    squad = "";

    checks_order = [];

    static update_constants = function(data) {
        move_data_to_current_scope(data);
        group_is_complex = is_array(group);
        if (group_is_complex) {
            if (array_length(group) == 3) {
                group_search_heads = true;
            } else {
                group_search_heads = false;
            }
        }

        complex_location = is_array(location);

        search_companies = !is_string(companies);

        if (search_companies) {
            array_push(checks_order, company_evaluate);
            search_multiple_companies = is_array(companies);
        }

        if (max_wanted > 0) {
            found = 0;
        }

        if (location != "") {
            array_push(checks_order, location_evaluate);
        }

        if (group != "all") {
            array_push(checks_order, group_evaluate);
        }

        if (struct_exists(self, "stat")) {
            array_push(checks_order, stat_valuate);
        }
        if (struct_exists(self, "job")) {
            array_push(checks_order, oposite_switch);
        }

        if (allegiance != "") {
            array_push(checks_order, allegiance_valuate);
        }

        if (squadless) {
            array_push(checks_order, squadless_valuate);
        }
        if (role != "") {
            array_push(checks_order, role_valuate);
        }
        if (bool(array_length(roles))) {
            array_push(checks_order, roles_valuate);
        }
        if (squad != "") {
            array_push(checks_order, squad_valuate);
        }
        end_loop = false;
    };

    update_constants(data);

    static oposite_switch = function(val) {
        return opposite ? !val : val;
    };

    static squad_valuate = function() {
        return oposite_switch(unit.squad == squad);
    };

    static roles_valuate = function() {
        return oposite_switch(array_contains(roles, unit.role()));
    };

    static role_valuate = function() {
        return oposite_switch(unit.role() == role);
    };

    static squadless_valuate = function() {
        return oposite_switch(unit.squad == "none");
    };

    static allegiance_valuate = function() {
        return oposite_switch(unit.allegiance == allegiance);
    };

    static job_valuate = function() {
        return oposite_switch((unit.assignment() == job));
    };

    static stat_valuate = function() {
        return oposite_switch(stat_valuator(stat, unit));
    };

    static company_evaluate = function() {
        var _add = true;

        if (search_multiple_companies) {
            if (!array_contains(companies, unit.company)) {
                _add = false;
            }
        } else {
            _add = companies == unit.company;
        }

        _add = oposite_switch(_add);
        return _add;
    };

    static group_evaluate = function() {
        var _add = true;

        var _group = group;
        if (group_is_complex) {
            if (group_search_heads) {
                _add = unit.IsSpecialist(_group[0], _group[1], _group[2]);
            } else {
                _add = unit.IsSpecialist(_group[0], _group[1]);
            }
        } else {
            _add = unit.IsSpecialist(_group);
        }
        _add = oposite_switch(_add);

        return _add;
    };

    static location_evaluate = function() {
        var _add = true;

        if (!complex_location) {
            _add = unit.is_at_location(location);
        } else {
            _add = unit.is_at_location(location[0], location[1], location[2]);
        }
        _add = oposite_switch(_add);

        return _add;
    };

    static evaluate = function(unit) {
        self.unit = unit;
        if (unit.name() == "") {
            return false;
        }

        var _add = true;
        for (var i = 0; i < array_length(checks_order); i++) {
            _add = checks_order[i]();
            if (!_add) {
                return false;
            }
        }

        if (max_wanted > 0 && _add) {
            found++;
            if (found >= max_wanted) {
                end_loop = true;
            }
        }

        return _add;
    };
}

function stat_valuator(search_params, _unit) {
    var match = true;
    for (var stat = 0; stat < array_length(search_params); stat++) {
        var _stat_val = search_params[stat];
        if (!struct_exists(_unit, _stat_val[0])) {
            match = false;
            break;
        }
        switch (_stat_val[2]) {
            case "inmore":
            case "more":
                if (_unit[$ _stat_val[0]] < _stat_val[1]) {
                    match = false;
                    break;
                }
                break;

            case "exmore":
                if (_unit[$ _stat_val[0]] <= _stat_val[1]) {
                    match = false;
                    break;
                }
                break;

            case "inless":
            case "less":
                if (_unit[$ _stat_val[0]] > _stat_val[1]) {
                    match = false;
                    break;
                }
                break;

            case "exless":
                if (_unit[$ _stat_val[0]] >= _stat_val[1]) {
                    match = false;
                    break;
                }
                break;
        }
    }
    return match;
}

//TOODO probably just roll this into other checks
function collect_by_religeon(religion, sub_cult = "", location = "") {
    var _units = [], _unit, count = 0, _add = false;
    for (var com = 0; com <= obj_ini.companies; com++) {
        for (var i = 1; i < array_length(obj_ini.TTRPG[com]); i++) {
            _add = false;
            _unit = obj_ini.TTRPG[com][i];
            if (_unit.name() == "") {
                continue;
            }
            if (_unit.religion == religion) {
                if (sub_cult != "") {
                    if (_unit.religion_sub_cult != "sub_cult") {
                        continue;
                    }
                }
                if (location == "") {
                    _add = true;
                } else if (_unit.is_at_location(location)) {
                    _add = true;
                }
            }
            if (_add) {
                array_push(_units, _unit);
            }
        }
    }
    return _units;
}

/// @description Processes the selection of units based on group parameters and updates controller data
/// @param {array} group The array of units to process for selection
/// @param {struct} selection_data Data structure containing selection parameters and state

/// @description Processes the selection of units based on group parameters and updates controller data
/// @param {array} group The array of units to process for selection
/// @param {struct} selection_data Data structure containing selection parameters and state

enum eMISSION_SELECT_TYPE {
    UNITS,
    SQUADS,
}

function group_selection(group, selection_data = {}) {
    try {
        var _unit, s, unit_location;
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
                _unit = group[i];
                add_man_to_manage_arrays(_unit);

                if (selection_data.purpose_code == "forge_assignment") {
                    if (_unit.job != "none") {
                        if (_unit.job.type == "forge" && _unit.job.planet == selection_data.planet) {
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
                    _unit = vehicles[veh];
                    add_vehicle_to_manage_arrays(_unit);
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
