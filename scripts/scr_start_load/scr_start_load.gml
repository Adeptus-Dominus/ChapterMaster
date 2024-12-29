function scr_start_load(fleet, load_from_star, load_options) {
    // fleet: the fleet object
    // load_from_star: star object

    // this distributes the marines and vehicles to the correct ships if the chapter is fleet-based or a home-based chapter

	var  _unit, _comp, _marine, total_vehic_size;
	var total_distribute_squads = [[],[],[],[],[],[],[],[]];

	var escort_load = load_options[0];
	var split_scouts = load_options[1];
	var split_vets = load_options[2];
	var _splintered =  scr_has_disadv("Splintered");
	if (_splintered){
		split_vets = 1;
		split_scouts = 1;
		escort_load = 1;
	}
	var comp_has_units=[];
	for (_comp=0;_comp<10;_comp++;){
		comp_has_units[_comp]=false
		for (_unit=0;_unit<20;_unit++){
			if (obj_ini.name[_comp][_unit] != ""){
				comp_has_units[_comp] = true;
				break;
			}
		}
	}


	if (split_vets){
		var comp_split=0;
		for (var squads=0;squads<array_length(obj_ini.squads);squads++){
			if (comp_split>7 || !comp_has_units[comp_split+2]) then comp_split =0;
			if (obj_ini.squads[squads].base_company==1){
				array_push(total_distribute_squads[comp_split], squads);
				comp_split++;
			}
		}		
	}
	if (split_scouts){
		var comp_split=0;
		for (var squads=0;squads<array_length(obj_ini.squads);squads++){
			if (comp_split>7 || !comp_has_units[comp_split+2]) then comp_split =0;
			if (obj_ini.squads[squads].base_company==10){
				array_push(total_distribute_squads[comp_split], squads);
				comp_split++;
			}
		}
	}	
	// i feel like there definatly is or should be a generic function for this????
	var _vehicles = ["Rhino", "Predator", "Land Speeder", "Land Raider", "Whirlwind"]
	function load_vehicles(_companies, _equip ,_ship, size){
			obj_ini.veh_wid[_companies, _equip] = 0;
			obj_ini.veh_lid[_companies, _equip] = _ship;
			obj_ini.veh_loc[_companies, _equip] = obj_ini.ship_location[_ship];	
			obj_ini.ship_carrying[_ship] += size;
	}
    var  ship_size, _companies_loaded;
    _company_size = 0;
    var ship = 0;
    //ship_size = obj_ini.ship_size[ship];
    _companies_loaded = 1;
	var ship_return = 1;
	var ship_has_space =true;

	
		//loop through companies. try and load whole company onto single ship else spread company across largest ships with remaining space
	var ship_loop_start = 0;
	for (_comp = 0; _comp<10;_comp++){
		if ((split_vets == 1 && _comp == 1) || (!comp_has_units[_comp])) then continue;
		if (ship_loop_start>=array_length(obj_ini.ship_carrying)){
			ship_loop_start=array_length(obj_ini.ship_carrying);
		}
		total_vehic_size = 0;
		var _company_size = 0;
		var company_loader =[];//array of companies marines
		var company_vehicle = [];//array of companies vehicles
		var  ship_fit = true;

		for (_unit =0; _unit<(array_length(obj_ini.role[_comp])-1); _unit++){
			_marine = obj_ini.TTRPG[_comp, _unit];
					// check if marine exists
			if (_marine.name() != "") {						
				//calculate marine space
				var marine_size =  _marine.get_unit_size();
				_company_size += marine_size;
				array_push(company_loader, _marine);

			}
		}
		if (_comp > 1) and (_comp < 10){
			var squaddy;
			var company_squad_dist = total_distribute_squads[_comp-2];
			for (var squad=0;squad<array_length(company_squad_dist);squad++){
				for (var squad_member =0;squad_member<array_length(obj_ini.squads[company_squad_dist[squad]].members);squad_member++){
					squaddy = obj_ini.squads[company_squad_dist[squad]].members[squad_member]
					_marine = fetch_unit(squaddy);
					var marine_size =  _marine.get_unit_size();
					_company_size += marine_size;
					array_push(company_loader, _marine);
				}
			}
		}		
			
			 //fetch company vehicles
		for (_unit =1;_unit <array_length(obj_ini.veh_role[_comp]);_unit++){
			 if array_contains(_vehicles,obj_ini.veh_role[_comp, _unit]){
					 var _vehic_size = scr_unit_size(false, obj_ini.veh_role[_comp, _unit], false, false);
					 total_vehic_size += _vehic_size
				 array_push(company_vehicle,  [_comp, _unit, _vehic_size])
			 }
		}
		_company_size += total_vehic_size;
					//if company won't fit onto ship
		if ((obj_ini.ship_carrying[ship_loop_start] + _company_size) > obj_ini.ship_capacity[ship_loop_start]){
			ship_fit = false;
		}		
		//if entire company won't fit on ship test to see if there is any ship in the fleet the company will fit on;
		 if (ship_fit == false){
			 for (ship_loop =  ship_loop_start; ship_loop< array_length(obj_ini.ship_carrying);ship_loop++){
				 if (escort_load == 2) and (obj_ini.ship_capacity[ship_loop] < 250){continue}
				  if ((obj_ini.ship_carrying[ship_loop] + _company_size) <= obj_ini.ship_capacity[ship_loop]){
					  //load marines
					  for (var m = 0; m <array_length(company_loader);m++){
						   company_loader[m].load_marine(ship_loop);
					  }
					  //load vehicles
					  for (var m = 0; m <array_length(company_vehicle);m++){
						   load_vehicles(company_vehicle[m][0], company_vehicle[m][1], ship_loop,  company_vehicle[m][2]);
					  }
					  ship_fit = true;
					  ship_loop_start = ship_loop+1;
					  break;

				  }
			 }
			if (!ship_fit ){
				for (ship_loop =  1; ship_loop<ship_loop_start;ship_loop++){
					if (escort_load == 2) and (obj_ini.ship_capacity[ship_loop] < 250){continue}
					 if ((obj_ini.ship_carrying[ship_loop] + _company_size) <= obj_ini.ship_capacity[ship_loop]){
							  //load marines
							for (var m = 0; m <array_length(company_loader);m++){
								   company_loader[m].load_marine(ship_loop);
							}
							  //load vehicles
						 for (var m = 0; m <array_length(company_vehicle);m++){
						   load_vehicles(company_vehicle[m][0], company_vehicle[m][1], ship_loop,  company_vehicle[m][2]);
							}
							ship_fit = true;
							break;

						}
				}			  	
			}
			 if (!ship_fit ){
			 	//see if all troops can be grouped together
				 for (ship_loop =  ship_loop_start; ship_loop< array_length(obj_ini.ship_carrying);ship_loop++){
					 if (escort_load == 2) and (obj_ini.ship_capacity[ship_loop] < 250){continue}
					  if ((obj_ini.ship_carrying[ship_loop] + _company_size-total_vehic_size) <= obj_ini.ship_capacity[ship_loop]){
						  //load marines
						  for (var m = 0; m <array_length(company_loader);m++){
							   company_loader[m].load_marine(ship_loop);
						  }
						  ship_fit = true;
						  ship_loop_start++;
						  break;

					  }
				 }
				 if (!ship_fit){
					 for (ship_loop =  1; ship_loop< ship_loop_start;ship_loop++){
						 if (escort_load == 2) and (obj_ini.ship_capacity[ship_loop] < 250){continue}
						  if ((obj_ini.ship_carrying[ship_loop] + _company_size-total_vehic_size) <= obj_ini.ship_capacity[ship_loop]){
							  //load marines
							  for (var m = 0; m <array_length(company_loader);m++){
								   company_loader[m].load_marine(ship_loop);
							  }
							  ship_fit = true;
							  break;

						  }
					 }				 	
				 }
			}
			// if there are no ships that will hold the entire company or all the troops loop all ships and jam pac the fuckers in it
			if (!ship_fit ){	 	
				 for (var ship_loop = 1; ship_loop<array_length(obj_ini.ship_carrying); ship_loop++){
				 if (escort_load ==2) and (obj_ini.ship_capacity[ship_loop] < 250){continue}				 
				 if (obj_ini.ship_carrying[ship_loop] < obj_ini.ship_capacity[ship_loop]){
					 ship_has_space = true;	
					 // new arrays that will contain troops that didn't get loaded
					 var comp_edit =[];
					 var veh_edit = [];
					 
					 if (!ship_fit){
					 for (var m = 0; m <array_length(company_loader);m++){
						 if ((obj_ini.ship_carrying[ship_loop] + company_loader[m].size) <= obj_ini.ship_capacity[ship_loop]){
							company_loader[m].load_marine(ship_loop);
						 } else {array_push(comp_edit, company_loader[m])}
						 if (obj_ini.ship_carrying[ship_loop] = obj_ini.ship_capacity[ship_loop]){
							 ship_has_space = false;
						 }
					  }
					}
					  for (var m = 0; m <array_length(company_vehicle);m++){
						  if ((obj_ini.ship_carrying[ship_loop] + company_vehicle[m][2]) <= obj_ini.ship_capacity[ship_loop]){
							load_vehicles(company_vehicle[m][0], company_vehicle[m][1], ship_loop, company_vehicle[m][2]);
						  } else {array_push( veh_edit, company_vehicle[m])}
						  if (obj_ini.ship_carrying[ship_loop] = obj_ini.ship_capacity[ship_loop]){
							   ship_has_space = false;
						  }
					  }					  
					   company_loader = comp_edit;
					   company_vehicle = veh_edit;
					}
				}
			}
		 } else{
			 for (var m = 0; m <array_length(company_loader);m++){
				company_loader[m].load_marine(ship_loop_start);
			}
			for (var m = 0; m <array_length(company_vehicle);m++){
				load_vehicles(company_vehicle[m][0], company_vehicle[m][1], ship_loop_start,  company_vehicle[m][2]);
			}
			if (_comp!=0){
				ship_loop_start++;	
			} 
		 }
	}
	if (_splintered){
		var _imperial_stars = scr_get_stars(true, [eFACTION.Imperium]);
		var _empty_ships=[];
		var _fleets=[];
		with(obj_p_fleet){instance_destroy()};
		for (var i=0;i<array_length(obj_ini.ship);i++){
			if (obj_ini.ship[i]!=""){
				if (obj_ini.ship_carrying[i] ==0){
					array_push(_empty_ships, i);
				} else {
					var _star = array_pop(_imperial_stars);
					_new_fleet = instance_create(_star.x,_star.y,obj_p_fleet);
					_new_fleet.owner  = eFACTION.Player;
					add_ship_to_fleet(i,_new_fleet);	
					array_push(_fleets, _new_fleet)		;		
				}
			}
		}
		for (var i=0; i<array_length(_empty_ships); i++){
			var _add_fleet = array_random_element(_fleets);
			add_ship_to_fleet(_empty_ships[i], _add_fleet);
		}
	}
}
