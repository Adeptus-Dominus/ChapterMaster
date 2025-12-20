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

function collect_role_group(group=SPECIALISTS_STANDARD, location="", opposite=false, search_conditions = {companies:"all"}){
	var _units = [], unit, count=0, _add=false, _is_special_group;
	var _max_count = 0;
	var _total_count = 0;
	if (struct_exists(search_conditions, "max")){
		_max_count =  search_conditions.max;
		search_conditions.max_wanted = search_conditions.max;
	}
	search_conditions.group = group;
	search_conditions.location = location;
	search_conditions.opposite = opposite;

	var _conditions = new SearchConditions(search_conditions);
	for (var com=0;com<=10;com++){
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
	    for (var i=0;i<array_length(obj_ini.TTRPG[com]);i++){
	    	if (_conditions.end_loop){
	    			break;
	    	}
			_unit=fetch_unit([com,i]);

	        if (_conditions.evaluate(_unit)){
	        	array_push(_units, _unit);
	        }
	    }    
	}
	return _units;
}


function SearchConditions(data) constructor{
	group = "all";
	opposite = false;
	location = "";
	max_wanted = 0;
	companies = "all";
	allegiance = "";

	static update_constants = function(data){
		move_data_to_current_scope(data);
		group_is_complex = is_array(group);
		if (group_is_complex){
			if (array_length(_group) == 3){
				group_search_heads = true;
			} else { 
				group_search_heads = false;
			}
		}
		complex_location = is_array(location);

		search_companies = !is_string(companies);
		if (search_companies){
			search_multiple_companies = is_array(search_companies);
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
		if (search_companies){
			if (search_multiple_companies){
				if (!array_contains(_wanted_companies, unit.company)){
					_add = false;
				}
			} else {
				if (_wanted_companies != unit.company){
					_add = false;
				}
			}
			_add = oposite_switch(_add);
		}

		return _add;
	}

	static group_evaluate = function(){

		var _add = true;
		if (group!="all"){
			var _group = group;
			if (group_is_array){
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
	       		_add=unit.is_at_location(location);
	       	} else {
	       		_add=unit.is_at_location(location[0], location[1], location[2]);
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
	    	});
		}

		if (_add){
			if (allegiance != ""){
				_add = oposite_switch(unit.allegiance == allegiance);
			}
		}

	    if (max_wanted > 0 && _add){
	    	found++;
	    	if (found>max_wanted){
	    		_add = false;
	    		end_loop = true;
	    	}
	    }


	    return _add;
	}

}


function UnitGroup(units) constructor{
	self.units = units;

	static number = function(){
		return array_length(units);
	}

	static has_role = function(role){
		for (var i=0;i<array_length(units);i++){
			if (units.role() == role){
				return true;
			}
		}

		return false;
	}

	static has_base_group = function(group){
		for (var i=0;i<array_length(units);i++){
			if (units.base_group == group){
				return true;
			}
		}

		return false;		
	}

	static has_allegiance = function(allegiance){
		for (var i=0;i<array_length(units);i++){
			if (units.allegiance == allegiance){
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
}

function stat_valuator(search_params, unit){
	match = true;
	for (var stat = 0;stat<array_length(search_params);stat++){
		var _stat_val = search_params[stat];		
		if (!struct_exists(unit,_stat_val[0])){
			match = false;
			break;
		}
		switch _stat_val[2] {
    		case "inmore":
	    	case "more":
    			if (unit[$ _stat_val[0]] < _stat_val[1]){
    				match = false;
					break;
    			}
			break;

    		case "exmore":
    			if (unit[$ _stat_val[0]] <= _stat_val[1]){
    				match = false;
					break;
    			}
			break;

    		case "inless":
	    	case "less":
    			if (unit[$ _stat_val[0]] > _stat_val[1]){
    				match = false;
					break;
    			}
			break;

    		case "exless":
    			if (unit[$ _stat_val[0]] >= _stat_val[1]){
    				match = false;
					break;
    			}
			break;
		}
	}
	return match;	
}

function collect_by_religeon(religion, sub_cult="", location=""){
	var _units = [], unit, count=0, _add=false;
	for (var com=0;com<=10;com++){
	    for (var i=1;i<array_length(obj_ini.TTRPG[com]);i++){
	    	_add=false;
			unit=obj_ini.TTRPG[com][i];
			if (unit.name()=="")then continue; 	
	        if (unit.religion == religion){
	        	if (sub_cult!=""){
	        		if (unit.religion_sub_cult != "sub_cult"){
	        			continue;
	        		}
	        	}
	        	if (location==""){
	        		_add=true;
	       		} else if (unit.is_at_location(location)){
	       			_add=true;
	       		}
	        }
	        if (_add) then array_push(_units, obj_ini.TTRPG[com][i]);
	    }    
	}
	return _units;
}

/// @description Processes the selection of units based on group parameters and updates controller data
/// @param {array} group The array of units to process for selection
/// @param {struct} selection_data Data structure containing selection parameters and state

enum MissionSelectType {
	Units,
	Squads
}


function group_selection(group, selection_data={}) {
    try {
        var unit, s, unit_location;
        obj_controller.selection_data = selection_data;
        set_zoom_to_default();
        with(obj_controller) {
        	if (menu != MENU.Manage){
        		scr_toggle_manage();
        	} else {
        		basic_manage_settings();
        	}

            exit_button = new ShutterButton();
            proceed_button = new ShutterButton();
            selection_data.start_count = 0;
           	instance_destroy(obj_managment_panel);
            if (!struct_exists(selection_data, "select_type")){
            	selection_data.select_type = MissionSelectType.Units;
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

                if (!struct_exists(selection_data , "purpose_code")){
                	selection_data.purpose_code = "manage";
                }
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

            if (selection_data.select_type == MissionSelectType.Squads){
            	new_company_struct();
            	company_data.has_squads = true;
            	company_data.squad_location = selection_data.system.name;
            	company_data.squad_search();
            	managing = -1;
            }
        }
    } catch (_exception) {
        //handle and send player back to map
        handle_exception(_exception);
        scr_toggle_manage();
    }
}