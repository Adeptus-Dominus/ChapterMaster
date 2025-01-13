function role_groups(group){
	var role_list = [];
	var roles = obj_ini.role[100];
	switch (group){
		case "lib":
			role_list = [
						string("Chief {0}",obj_ini.role[100,17]),
						obj_ini.role[100,17], //librarian
						"Codiciery",
						"Lexicanum",
			];
			break;
		case "trainee":
			role_list = [
				string("{0} Aspirant",obj_ini.role[100,17]),
				string("{0} Aspirant",obj_ini.role[100,15]),  
				string("{0} Aspirant",obj_ini.role[100,14]),
				string("{0} Aspirant",obj_ini.role[100,16]),
			];
			break;
		case "heads":
			role_list = [
				"Master of Sanctity",
				string("Chief {0}", obj_ini.role[100,17]),
				"Forge Master", 
				"Chapter Master", 
				"Master of the Apothecarion"
			];
			break;
		case "veterans":
			role_list = [
				obj_ini.role[100,3],  //veterans
				obj_ini.role[100,4],  //terminatore
				obj_ini.role[100,19], //vet sergeant
				obj_ini.role[100,2],  //honour guard
			];
			break;
		case "rank_and_file":
			role_list = [
				obj_ini.role[100,8], //tactical marine
				obj_ini.role[100,9], //devastator
				obj_ini.role[100,10], //assualt
				obj_ini.role[100,12], //scout
			];
			break;

		case "squad_leaders":
			role_list = [
				obj_ini.role[100][18], //sergeant
				obj_ini.role[100][19],  //vet sergeant
			]
			break;
		case "command":
			role_list = [
	            obj_ini.role[100][5],
	            obj_ini.role[100][14],
	            obj_ini.role[100][15],
	            obj_ini.role[100][16],
	            obj_ini.role[100][17],
	            "Codiciery",
	            "Lexicanum",
	            obj_ini.role[100][11],
	            obj_ini.role[100][7],
	        ]; 
	        break;
	    case "dreadnoughts":
	        role_list = [
				obj_ini.role[100][6],//dreadnought
				string("Venerable {0}",obj_ini.role[100][6]),
			];
			break;
		case "forge":
	        role_list = [
				obj_ini.role[100][16],//techmarine
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
				 obj_ini.role[100][11],			
			];
			break;
	}
	return role_list;
}

function is_specialist(unit_role, type="standard", include_trainee=false) {

	// unit_role
	//TODO need to make all string roles not strings but array references
	switch(type){
		case "standard":
			specialists = ["Chapter Master",
							"Forge Master",
							"Master of Sanctity",
							"Master of the Apothecarion",
							string("Chief {0}",obj_ini.role[100][17]),//chief librarian
							obj_ini.role[100][5],//captain
							obj_ini.role[100][6],//dreadnought
							string("Venerable {0}",obj_ini.role[100][6]),
							obj_ini.role[100][7],//company_champion
							obj_ini.role[100][14],//chaplain
							obj_ini.role[100][15],//apothecary
							obj_ini.role[100][16],//techmarine
							obj_ini.role[100][17], //librarian
							"Codiciery",
							"Lexicanum",
							obj_ini.role[100,2],//honour guard
			];
			if (include_trainee){
				array_push(specialists, 
							 string("{0} Aspirant",obj_ini.role[100][17]),
							 string("{0} Aspirant",obj_ini.role[100][15]),  
							 string("{0} Aspirant",obj_ini.role[100][14]),
							 string("{0} Aspirant",obj_ini.role[100][16]),
							 );
			}
			break;
      
		case "libs":
			specialists = role_groups("lib");
			if (include_trainee){
				array_push(specialists,  string("{0} Aspirant",obj_ini.role[100][17]));
			}
			break;
		case "forge":
			specialists = role_groups("forge");
			if (include_trainee){
				array_push(specialists,  string("{0} Aspirant",obj_ini.role[100][16]));
			}			
			break;
		case "chap":
			specialists = [
						obj_ini.role[100][14],//chaplain
						"Master of Sanctity",
			];
			if (include_trainee){
				array_push(specialists,  string("{0} Aspirant",obj_ini.role[100][14]));
			}
			if (global.chapter_name == "Iron Hands"){
				array_push(specialists, obj_ini.role[100][16]);
			}	
			break;
		case "apoth":
			specialists = [
						obj_ini.role[100][15],
						"Master of the Apothecarion",
			];
			if (include_trainee){
				array_push(specialists,  string("{0} Aspirant",obj_ini.role[100][15]));
			}	
			if (global.chapter_name == "Space Wolves"){
				array_push(specialists, obj_ini.role[100][14]);
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
	        		_add = stat_valuator(search_conditions[$ "stat"], unit);
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
		if (search_params[stat][2] =="more"){
			if (unit[$ search_params[stat][0]] < search_params[stat][1]){
				match = false;
				break;
			}
		} else if(search_params[stat][2] =="less"){
				if (unit[$ search_params[stat][0]] > search_params[stat][1]){
				match = false;
				break;
			}           					
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
				menu=1;
				onceh=1;
				cooldown=8000;
				click=1;
				popup=0;
				selected=0;
				hide_banner=1;
				with(obj_fleet_select){instance_destroy();}
				with(obj_star_select){instance_destroy();}
				view_squad=false;
				managing=0;		
				zoomed=0;
				menu=1;
				managing=0;
				diplomacy=0;
				cooldown=8000;
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
