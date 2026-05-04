
function UnitGroup(units) constructor{
	self.units = units;

	static number = function(){
		return array_length(units);
	}

	static shuffle = function(){
		units = array_shuffle(units);
	}

	static has_role = function(role){
		for (var i=0;i<array_length(units);i++){
			if (units[i].role() == role){
				return true;
			}
		}

		return false;
	}

	static has_base_group = function(group){
		for (var i=0;i<array_length(units);i++){
			if (units[i].base_group == group){
				return true;
			}
		}

		return false;		
	}

	static has_allegiance = function(allegiance){
		for (var i=0;i<array_length(units);i++){
			if (units[i].allegiance == allegiance){
				return true;
			}
		}
		return false;		
	}

	static get_from = function(search_conditions = {}){
		var _wanted = [];
		var conditions = new SearchConditions(search_conditions);
		for (var i=0;i<array_length(units);i++){
			if (conditions.evaluate(units[i])){
				array_push(_wanted,units[i]);
			}
			if (conditions.end_loop){
				break;
			}
		}

		return new UnitGroup(_wanted);
	}

	static kill_percent = function(kill_percent, equipment = true, gene_seed_collect = true){
		var _kill_numb = floor((kill_percent/100) * number());
		var _killed = 0;
		var i = 0;
		while(_killed <  _kill_numb && i < number()){
			var _unit = units[i];
			if (kill_percent < 100 && _unit.role() == active_roles()[eROLE.CHAPTERMASTER]){
				i++;
				continue;
			}
			kill_and_recover(_unit.company, _unit.marine_number, equipment, gene_seed_collect);
			_killed++;
			i++;
		}
	}

	static for_each = function(unit_func){
		for (var i=0; i<array_length(self.units); i++){
			unit_func(units[i]);
		}
	}

	var _roles = active_roles();
	static sgt_types = role_groups(SPECIALISTS_RANK_AND_FILE);

	static create_squad = function(squad_type, squad_loadout = true, squad_index = -1, game_start = false){

		var roles = active_roles();

	    var squad = new UnitSquad(squad_type);

	    var squad_fulfilment = squad.squad_fulfilment;

	    var sergeant_found = false;

	    var squad_unit_types = squad.find_squad_unit_types();

	    var _fill_squad = obj_ini.squad_types[$ squad_type];

	    var _fulfilled = false;

	    for (var s = 0; s < 2; s++) {

	    	var _sgt_type = sgt_types[s];
	    	var _available_sgt = get_from(
		    	{
		    		squadless : true,
		    		role : _sgt_type,
		    		squadless : true,
		    		max_wanted : 1
		    	}
		    );
		    if (_available_sgt.number() == 0){
		    	continue;
		    }

		    var _sgt = _available_sgt.units[0];
		    squad.add_member(_sgt);
		    squad_fulfilment[$ _sgt_type] += 1;
		    sergeant_found = true;
	    }

	    var _squadless = get_from(
	    	{
	    		squadless : true,
	    		roles : squad_unit_types
	    	}
	    );
	    for (var i = 0; i < array_length(_squadless); i++) {
	        //fill squad roles

	        unit = _squadless[i]

	            //if no sergeant found add one marine to standard marine selection so that a marine can be promoted

	        var _has_sgt_requirements = false;
			for (var s = 0; s < 2; s++) {
	    		var _sgt_type = sgt_types[s];
	    		if (array_contains(squad_unit_types,_sgt_type)){
	    			_has_sgt_requirements = true;
	    		}
	    	}

	    	if (_has_sgt_requirements && sergeant_found){
	    		_has_sgt_requirements = false;
	    	}

	    	//clone or else keeps pushing up number
	    	var _max = variable_clone(_fill_squad[$ unit.role()][$ "max"]);
            if (_has_sgt_requirements) {
            	_max += 1;
            }

            if (squad_fulfilment[$ unit.role()] < _max) {
                //if sergeants not required
                squad_fulfilment[$ unit.role()]++;
                squad.add_member(unit.company, unit.marine_number);
            }

	    }

	    //if a new sergeant is needed find the marine with the highest experience in the squad
	    //(which if everything works right should be a marine with the old_guard, seasoned, or ancient trait)
	    /*and ((squad_fulfilment[$ obj_ini.role[100][8]] > 4)or (squad_fulfilment[$ obj_ini.role[100][10]] > 4) or (squad_fulfilment[$ obj_ini.role[100][9]] > 4)or (squad_fulfilment[$ obj_ini.role[100][3]] > 4) )*/

	    var _members = squad.get_members(true);
	    for (var s = 0; s < 2; s++) {

	    	var _sgt_type = sgt_types[s];
	        if (struct_exists(squad_fulfilment, _sgt_type) && (!sergeant_found)) {
	            var highest_exp = 0;
	            var exp_unit;
	            
	            for (var i = 0; i < _members.number(); i++) {
	            	var _unit = _members.units[i];
	                if (i == 0) {
	                    highest_exp = _unit.experience;
	                    continue;
	                }

	                if (_unit.experience > highest_exp) {
	                    highest_exp = _unit.experience;
	                    exp_unit = _unit;
	                }
	            }
	            squad_fulfilment[$ _sgt_type]++;
	        }
	    }

	    //evaluate if the minimum unit type requirements have been met to create a new squad
	    _fulfilled = true;
	    for (var i = 0; i < array_length(squad_unit_types); i++) {
	        if (squad_fulfilment[$ squad_unit_types[i]] < _fill_squad[$ squad_unit_types[i]][$ "min"]) {
	            fulfilled = false;
	            break;
	        }
	    }
	    if (_fulfilled) {
	        for (var s = 0; s < 2; s++) {
	            if (struct_exists(squad_fulfilment, sgt_types[s]) && (sergeant_found == false)) {
	                exp_unit.update_role(sgt_types[s]); //if squad is viable promote marine to sergeant
	                if (game_start && irandom(1) == 0) {
	                    exp_unit.add_trait("lead_example");
	                }
	            }
	        }
	        //update units squad marker
	        squad.squad_fulfilment = squad_fulfilment;
	        for (var i = 0; i < _members.number(); i++) {
	            unit = _members.units[i];
	            if (!squad_index) {
	                unit.squad = squad_count;
	            } else {
	                unit.squad = squad_index;
	            }
	        }
	        if (squad_index == -1) {
	            array_push(obj_ini.squads, squad); //push squad to squads array thus creating squad
	        } else {
	            obj_ini.squads[squad_index] = squad;
	        }

	        if (squad_loadout) {
	            squad.sort_squad_loadout(false, false);
	        }
	    }

	    return _fulfilled;
	}
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

function collect_role_group(group=SPECIALISTS_STANDARD, location="", opposite=false, search_conditions = {}, return_as_UnitGroup = false){
	var _units = [], unit, count=0, _add=false, _is_special_group;
	var _max_count = 0;
	var _total_count = 0;
	if (struct_exists(search_conditions, "max")){
		_max_count =  search_conditions.max;
		search_conditions.max_wanted = search_conditions.max;
	}
	if (!struct_exists(search_conditions , "companies")){
		search_conditions.companies = "all";
	}
	search_conditions.group = group;
	search_conditions.location = location;
	search_conditions.opposite = opposite;

	var _conditions = new SearchConditions(search_conditions);
	for (var com=0;com<=obj_ini.companies;com++){
    	if (_max_count>0){
    		if (array_length(_units)>=_max_count){
    			break;
    		}
    	}		
		var _wanted_companies = search_conditions.companies;
		if (_wanted_companies!="all"){
			if (is_array(_wanted_companies)){
				if (!array_contains(_wanted_companies, com)){
					continue;
				}
			} else {
				if (_wanted_companies != com){
					continue;
				}
			}
		}
		var _company = obj_ini.TTRPG[com]
	    for (var i = 0;i < array_length(_company); i++){
	    	if (_conditions.end_loop){
	    		break;
	    	}
			_unit=fetch_unit([com,i]);

	        if (_conditions.evaluate(_unit)){
	        	array_push(_units, _unit);
	        }
	    }    
	}
	if (return_as_UnitGroup){
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

	static update_constants = function(data){
		move_data_to_current_scope(data);
		group_is_complex = is_array(group);
		if (group_is_complex){
			if (array_length(group) == 3){
				group_search_heads = true;
			} else { 
				group_search_heads = false;
			}
		}

		complex_location = is_array(location);

		search_companies = !is_string(companies);

		if (search_companies){
			search_multiple_companies = is_array(companies);
		}

		if (max_wanted > 0){
			found = 0;
		}

		end_loop = false;
	}

	update_constants(data);

	static oposite_switch = function(val){
		return opposite ? !val : val;
	}

	static company_evaluate = function(){
		var _add = true;
		if (!search_companies){
			return true;
		}

		if (search_multiple_companies){
			if (!array_contains(companies, unit.company)){
				_add = false;
			}
		} else {
			if (companies != unit.company){
				_add = false;
			}
		}

		_add = oposite_switch(_add);

		return _add;
	}

	static group_evaluate = function(){

		var _add = true;
		if (group!="all"){
			var _group = group;
			if (group_is_complex){
				if (group_search_heads) {
					_add = unit.IsSpecialist(_group[0], _group[1], _group[2]);
				} else {
					_add = unit.IsSpecialist(_group[0], _group[1]);
				}
			} else {
				_add = unit.IsSpecialist(_group);
			}
			_add = oposite_switch(_add);
		}
		return _add;
	}

	static location_evaluate = function(){
		var _add = true;
		if (location!=""){
	   		if (!complex_location){
	       		_add = unit.is_at_location(location);
	       	} else {
	       		_add = unit.is_at_location(location[0], location[1], location[2]);
	       	}
	       	_add = oposite_switch(_add);
		}

		return _add;
	}

	static checks_order = [
		company_evaluate,
		group_evaluate,
		location_evaluate
	];


	static evaluate = function(unit){
		self.unit = unit;
		if (unit.name()==""){
			return false;
		}

		var _add = true;
		for (var i=0;i<array_length(checks_order);i++){
			_add = checks_order[i]();
			if (!_add){
				return false;
			}
		}

	    if (_add){
	    	if (struct_exists(self, "stat")){
	    		_add = oposite_switch(stat_valuator(stat, unit));
	    	}
	    }

	    if (_add){
	    	if (struct_exists(self,"job")){
	    		_add = oposite_switch((unit.assignment() == job));
	    	}
		}

		if (_add){
			if (allegiance != ""){
				_add = oposite_switch(unit.allegiance == allegiance);
			}
		}

		if (_add){
			if (squadless){
				_add = oposite_switch(unit.squad == "none");
			}
		}

		if (_add){
			if (role != ""){
				_add = oposite_switch(unit.role() == role);
			}
		}

		if (_add){
			if (array_length(roles)){
				_add = oposite_switch(array_contains(roles, unit.role()));
			}
		}

	    if (max_wanted > 0 && _add){
	    	found++;
	    	if (found > max_wanted){
	    		_add = false;
	    		end_loop = true;
	    	}
	    }


	    return _add;
	}

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


//TOODO probably just roll this into other checks
function collect_by_religeon(religion, sub_cult = "", location = "") {
    var _units = [], unit, count = 0, _add = false;
    for (var com = 0; com <= obj_ini.companies; com++) {
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
                array_push(_units, unit);
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