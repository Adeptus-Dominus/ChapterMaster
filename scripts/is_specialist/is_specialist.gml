function active_roles(){
	var _roles =  instance_exists(obj_creation) ?  obj_creation.role[100] : obj_ini.role[100];
	return _roles;
}

function role_groups(group){
	var role_list = [];
	var roles = active_roles();
	switch (group){
		case "lib":
			role_list = [
						string("Chief {0}",roles[17]),
						roles[17], //librarian
						"Codiciery",
						"Lexicanum",
			];
			break;
		case "trainee":
			role_list = [
				string("{0} Aspirant",roles[17]),
				string("{0} Aspirant",roles[15]),  
				string("{0} Aspirant",roles[14]),
				string("{0} Aspirant",roles[16]),
			];
			break;
		case "heads":
			role_list = [
				"Master of Sanctity",
				string("Chief {0}", roles[17]),
				"Forge Master", 
				"Chapter Master", 
				"Master of the Apothecarion"
			];
			break;
		case "veterans":
			role_list = [
				roles[3],  //veterans
				roles[4],  //terminatore
				roles[19], //vet sergeant
				roles[2],  //honour guard
			];
			break;
		case "rank_and_file":
			role_list = [
				roles[8], //tactical marine
				roles[9], //devastator
				roles[10], //assualt
				roles[12], //scout
			];
			break;

		case "squad_leaders":
			role_list = [
				roles[18], //sergeant
				roles[19],  //vet sergeant
			]
			break;
		case "command":
			role_list = [
	            roles[5],
	            roles[14],
	            roles[15],
	            roles[16],
	            roles[17],
	            "Codiciery",
	            "Lexicanum",
	            roles[11],
	            roles[7],
	        ]; 
	        break;
	    case "dreadnoughts":
	        role_list = [
				roles[6],//dreadnought
				string("Venerable {0}",roles[6]),
			];
			break;
		case "forge":
	        role_list = [
				roles[16],//techmarine
				"Forge Master",
				"Techpriest"
			];
			break;
		case "captain_candidates":
			role_list = [
				roles[eROLE.Sergeant], //sergeant
				roles[eROLE.VeteranSergeant],
				roles[eROLE.Champion],				
				roles[eROLE.Captain],								
				roles[eROLE.Terminator],				
				roles[eROLE.Veteran],
				 roles[11],			
			];
			break;
	}
	return role_list;
}

function is_specialist(unit_role, type="standard", include_trainee=false) {

	// unit_role
	//TODO need to make all string roles not strings but array references
	var roles = instance_exists(obj_creation) ?  obj_creation.role[100] : obj_ini.role[100];
	var _chap_name = instance_exists(obj_creation) ? obj_creation.chapter_name : global.chapter_name;
	switch(type){
		case "standard":
			specialists = ["Chapter Master",
							"Forge Master",
							"Master of Sanctity",
							"Master of the Apothecarion",
							string("Chief {0}",roles[17]),//chief librarian
							roles[5],//captain
							roles[6],//dreadnought
							string("Venerable {0}",roles[6]),
							roles[7],//company_champion
							roles[14],//chaplain
							roles[15],//apothecary
							roles[16],//techmarine
							roles[17], //librarian
							"Codiciery",
							"Lexicanum",
							roles[2],//honour guard
			];
			if (include_trainee){
				array_push(specialists, 
							 string("{0} Aspirant",roles[17]),
							 string("{0} Aspirant",roles[15]),  
							 string("{0} Aspirant",roles[14]),
							 string("{0} Aspirant",roles[16]),
							 );
			}
			break;
      
		case "libs":
			specialists = role_groups("lib");
			if (include_trainee){
				array_push(specialists,  string("{0} Aspirant",roles[17]));
			}
			break;
		case "forge":
			specialists = role_groups("forge");
			if (include_trainee){
				array_push(specialists,  string("{0} Aspirant",roles[16]));
			}			
			break;
		case "chap":
			specialists = [
						roles[14],//chaplain
						"Master of Sanctity",
			];
			if (include_trainee){
				array_push(specialists,  string("{0} Aspirant",roles[14]));
			}
			if (_chap_name == "Iron Hands"){
				array_push(specialists, roles[16]);
			}	
			break;
		case "apoth":
			specialists = [
						roles[15],
						"Master of the Apothecarion",
			];
			if (include_trainee){
				array_push(specialists,  string("{0} Aspirant",roles[15]));
			}	
			if (_chap_name == "Space Wolves"){
				array_push(specialists, roles[14]);
			}		
			break;
		case "heads":
			specialists = role_groups("heads");
			break;
		case "command":	
			specialists = role_groups("command");
			break;	
		case "trainee":	
			specialists = role_groups("trainee");
			break;
		case "rank_and_file":
			specialists = role_groups("rank_and_file");
			break;
		case "squad_leaders":
			specialists = role_groups("squad_leaders");
			break;
		case "dreadnoughts":
			specialists = role_groups("dreadnoughts");	
			break;
		case "veterans":
			specialists = role_groups("veterans");
			break;
		case "captain_candidates":
			specialists = role_groups("captain_candidates");
			break;			
	}

	return array_contains(specialists,unit_role);
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

function collect_role_group(group="standard", location="", opposite=false, search_conditions = {companies:"all"}){
	var _units = [], unit, count=0, _add=false, _is_special_group;
	var _max_count = 0;
	var _total_count = 0;
	if (struct_exists(search_conditions, "max")){
		_max_count =  search_conditions.max;
	}
	if (!struct_exists(search_conditions, "companies")){
		search_conditions.companies = "all";
	}
	for (var com=0;com<=10;com++){
    	if (_max_count>0){
    		if (array_length(_units)>=_max_count){
    			break;
    		}
    	}		
		var _wanted_companies = search_conditions.companies;
		if (_wanted_companies!="all"){
			if (is_array(_wanted_companies)){
				if (!array_contains(_wanted_companies, com)) then continue;
			} else {
				if (_wanted_companies != com) then continue;
			}
		}
	    for (var i=0;i<array_length(obj_ini.TTRPG[com]);i++){
	    	if (_max_count>0){
	    		if (array_length(_units)>=_max_count){
	    			break;
	    		}
	    	}
	    	if array_length(_units)
	    	_add=false;
			unit=fetch_unit([com,i]);
			if (unit.name()=="") then continue;
			if (group!="all"){
				if (is_array(group)){
					_is_special_group = unit.IsSpecialist(group[0], group[1]);
				} else {
					_is_special_group = unit.IsSpecialist(group);
				}
			} else {
				_is_special_group = true;
			}
	        if ((_is_special_group && !opposite) || (!_is_special_group && opposite)){
	        	if (location==""){
	        		_add=true;
	       		} else if (!is_array(location)){
		       		_add=unit.is_at_location(location);
		       	} else {
		       		_add=unit.is_at_location(location[0], location[1], location[2]);
		       	}
	        }
	        if (_add){
	        	if (struct_exists(search_conditions, "stat")){
	        		_add = stat_valuator(search_conditions.stat, unit);
	        	}
	        	if (struct_exists(search_conditions,"job")){
	        		_add =  (unit.assignment() == search_conditions.job);
	        	}
	        }
	        if (_add) then array_push(_units, obj_ini.TTRPG[com][i]);
	    }    
	}
	return _units;
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

function group_selection(group, selection_data){
	try {
		var unit, s, unit_location;
		obj_controller.selection_data = selection_data;
		set_zoom_to_default();
		with (obj_controller){
				basic_manage_settings();
				with(obj_fleet_select){instance_destroy();}
				with(obj_star_select){instance_destroy();}

				exit_button = new ShutterButton();
				proceed_button = new ShutterButton();
				selection_data.start_count=0;
			// Resets selections for next turn
				man_size=0;
				selecting_location="";
				selecting_types="";
				selecting_ship=-1;
				selecting_planet=0;
				sel_uid=0;
				reset_manage_arrays();
				alll=0;              
				cooldown=10;
				sel_loading=-1;
				unload=0;
				alarm[6]=7;
				company_data={};
				view_squad=false;
				managing =-1; 
				var vehicles = [];
				for (var i = 0; i< array_length(group);i++){
					if (!is_struct(group[i])){
						if (is_array(group[i])){
							array_push(vehicles, group[i]);
						}
						continue;
					}
					unit = group[i];
					add_man_to_manage_arrays(unit);

					if (selection_data.purpose_code=="forge_assignment"){
						if (unit.job != "none"){
							if (unit.job.type=="forge" && unit.job.planet== selection_data.planet){
								man_sel[array_length(display_unit)-1]=1;
								man_size++;
								selection_data.start_count++;

							}                		
						}
					}       	
				}
				var last_vehicle=0;
			if (array_length(vehicles)>0){
				for (var veh=0;veh<array_length(vehicles);veh++){
					unit = vehicles[veh];
					add_vehicle_to_manage_arrays(unit)       		
				}
			}
			other_manage_data();
			man_current=0;
			man_max=array_length(display_unit)+2;
			man_see=38-4;
		}
	} catch(_exception) {
		handle_exception(_exception);
		scr_toggle_manage();//handle and send player back to map
	}
}
