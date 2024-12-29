
enum eSystemLoc {
	orbit,
	planet1,
	planet2,
	planet3,
	planet4
}
function calculate_full_chapter_spread(){
 	obj_controller.command=0;
 	obj_controller.marines=0;	
	var _mar_loc,is_healer,_is_tech,key_val,veh_location,array_slot,_unit;
	var _tech_spread = {};
	var _apoth_spread = {};
	var _unit_spread = {};
    for(var company=0;company<11;company++){
    	var _company_length = (array_length(obj_ini.name[company]));
    	for (var v=0; v < _company_length; v++) {
    		key_val = "";
    		if (obj_ini.name[company][v]=="") then continue;
    		_unit = fetch_unit([company, v]);
    		_mar_loc = _unit.marine_location();
    		if (_unit.base_group=="astartes"){
	    		if (_unit.IsSpecialist()){
	    			obj_controller.command++;
	    		} else {
	    			obj_controller.marines++;
	    		}
	    	}
	        tech_points_used += _unit.equipment_maintenance_burden();
		    _is_tech = (_unit.IsSpecialist("forge"));
		    if (_is_tech){
		    	add_forge_points_to_stack(_unit);
		    }
		    is_healer = (((_unit.IsSpecialist("apoth",true) && _unit.gear()=="Narthecium") || (_unit.role()=="Sister Hospitaler")) && _unit.hp()>=10);
		    if (is_healer){
		    	add_apoth_points_to_stack(_unit);
		    }
		  	if (_mar_loc[2]!="Warp" && _mar_loc[2]!="Lost"){
  	    		if (_mar_loc[0]=location_types.planet){
  	    			array_slot = _mar_loc[1];
  	    		} else if (_mar_loc[0] == location_types.ship){
  	    			array_slot=eSystemLoc.orbit;
  	    		}
  	    		key_val = _mar_loc[2];
  	    	} else if (_mar_loc[0] == location_types.ship){
  	    		if instance_exists(obj_p_fleet){
  	    			with (obj_p_fleet){
  	    				if (array_contains(capital_num, _mar_loc[1]) ||
  	    					array_contains(frigate_num, _mar_loc[1])||
  	    					array_contains(escort_num, _mar_loc[1])
  	    				){
  	    					key_val=$"{id}";
  	    					array_slot=eSystemLoc.orbit;
  	    					break;
  	    				}
  	    			}
  	    		}
  	    	}
  	    	if (key_val!=""){
				if (! struct_exists(_unit_spread, key_val)){
					_unit_spread[$key_val] = [[],[],[],[],[]];
					_tech_spread[$key_val]  = [[],[],[],[],[]];
					_apoth_spread[$key_val]  = [[],[],[],[],[]];
				}
				array_push(_unit_spread[$key_val][array_slot] ,_unit);
				if (_is_tech){
					array_push(_tech_spread[$key_val][array_slot] ,_unit);
				}
				if (is_healer)	{
					array_push(_apoth_spread[$key_val][array_slot] ,_unit);
				}		
			}
			key_val="";
            if (v<array_length(obj_ini.veh_hp[company]) && company>0){
            	if (obj_ini.veh_race[company][v]!=0){
            		if(obj_ini.veh_lid[company][v]>-1){
	            		veh_location = obj_ini.veh_lid[company][v];
	            		var _ship_loc = obj_ini.ship_location[veh_location];
	            		if (_ship_loc == "Warp" || _ship_loc=="Lost"){
			  	    		if instance_exists(obj_p_fleet){
			  	    			with (obj_p_fleet){
			  	    				if (array_contains(capital_num, veh_location) ||
			  	    					array_contains(frigate_num, veh_location)||
			  	    					array_contains(escort_num, veh_location)
			  	    				){
			  	    					key_val=string(id);
			  	    					array_slot=eSystemLoc.orbit;
			  	    					break;
			  	    				}
			  	    			}
			  	    		}
			  	    	} else if (obj_ini.ship_location[veh_location] != ""){
			  	    		array_slot=eSystemLoc.orbit;
			  	    		key_val=obj_ini.ship_location[veh_location];
			  	    	}
		            }            	
	            	if (obj_ini.veh_wid[company][v]>0){
	            		key_val = obj_ini.veh_loc[company][v];
	            		if (key_val!=""){
		            		array_slot = obj_ini.veh_wid[company][v];
						}     		
	            	}
	  	    		if (key_val!=""){
						if (! struct_exists(_unit_spread, key_val)){
							_unit_spread[$key_val] = [[],[],[],[],[]];
							_tech_spread[$key_val]  = [[],[],[],[],[]];
							_apoth_spread[$key_val]  = [[],[],[],[],[]];
						}
						array_push(_unit_spread[$key_val][array_slot] ,[company,v]);	  	    		
	            	}
	            }           	
            }			
	    }
	}
	return [_tech_spread,_apoth_spread,_unit_spread]	
}
function single_loc_point_data(){
	return {
		heal_points_use : 0,
		heal_points : 0,
		forge_points_use : 0,
		forge_points : 0,					
	};
}
function system_point_data_spawn(){
	var _single_point_pos = single_loc_point_data();
 	return [
				DeepCloneStruct(_single_point_pos),
				DeepCloneStruct(_single_point_pos),
				DeepCloneStruct(_single_point_pos),
				DeepCloneStruct(_single_point_pos),
				DeepCloneStruct(_single_point_pos),
			];
}

function apothecary_simple(){
	var  _unit;
	var _spreads = chapter_spread();
	var _tech_spread = _spreads[0];
	var _apoth_spread = _spreads[1];
	var _unit_spread = _spreads[2];
	forge_string += $"Equipment Maintenance : -{tech_points_used}#";
    //marines-=1;

	var _locations = struct_get_names(_unit_spread);
	var cur_apoths;

	with (obj_star){
		var marines_present = false;
		for (var i=0;i<array_length(_locations);i++){
			if (_locations[i] == name){
				array_push(_unit_spread[$ _locations[i]], self);
				marines_present=true;
			}
		}
		if (!marines_present){
			if (obj_controller.gene_seed == 0) and (obj_controller.recruiting > 0) {
				var _training_ground = system_feature_bool(self, P_features.Recruiting_World);
				if (_training_ground){
                    obj_controller.recruiting = 0;
                    obj_controller.income_recruiting = 0;
                    scr_alert("red", "recruiting", "The Chapter has run out of gene-seed!", 0, 0);		
				}
			}
		}
	}

	var cur_units, cur_techs, _loc_heal_points, veh_health, points_spent, cur_system, features;
	var total_bionics = scr_item_count("Bionics");
	for (i=0;i<array_length(_locations);i++){
		var _cur_loc = _locations[i];
		cur_system="";
		if (array_length(_unit_spread[$_cur_loc]) == 6){
			cur_system = _unit_spread[$_cur_loc][5];
		}
		if (cur_system!=""){
			point_breakdown.systems[$ cur_system.name] = system_point_data_spawn();
		}

		var _loc_forge_points = 0;	
		var _point_breakdown = {};	
		for (var p=0; p<5; p++){
			_point_breakdown = {
				heal_points:0,
				forge_points:0,
				heal_points_use:0,
				forge_points_use:0,
			};

			_loc_heal_points=0;
			_loc_forge_points=0;

			if (array_length(_unit_spread[$_cur_loc][p]) == 0) then continue;
			cur_units = _unit_spread[$_cur_loc][p];
			cur_apoths = _apoth_spread[$_cur_loc][p];
			cur_techs = _tech_spread[$_cur_loc][p];
			for (var a=0;a<array_length(cur_apoths);a++){
				_unit = cur_apoths[a];
				_loc_heal_points+=_unit.apothecary_point_generation(turn_end)[0];
			}
			for (var a=0;a<array_length(cur_techs);a++){
				_unit = cur_techs[a];
				var tech_gen = _unit.forge_point_generation(turn_end)[0];
				_loc_forge_points += tech_gen;
			}
			_point_breakdown.heal_points = _loc_heal_points;
			_point_breakdown.forge_points = _loc_forge_points;
			for (var a=0;a<array_length(cur_units);a++){
				points_spent = 0;
				_unit = cur_units[a];
				if (is_array(_unit) && _loc_forge_points>0){				
					if (array_length(_unit)>1){
						var _role = obj_ini.veh_role[_unit[0]][_unit[1]];
		                if (_role=="Land Raider"){
		                    forge_veh_maintenance.land_raider = struct_exists(forge_veh_maintenance, "land_raider") ?forge_veh_maintenance.land_raider + 1 : 1;
							_loc_forge_points--;
							tech_points_used++;		                    
		                } else if (array_contains(["Rhino","Predator", "Whirlwind"],_role)){
		                    forge_veh_maintenance.small_vehicles = struct_exists(forge_veh_maintenance, "small_vehicles") ?forge_veh_maintenance.small_vehicles + 0.2 :0.2;
		                    _loc_forge_points-=0.2;
		                    tech_points_used+=0.2;
		                }							
						while (points_spent<10 && obj_ini.veh_hp[_unit[0]][_unit[1]]<100 && _loc_forge_points>0){
							points_spent++;
							if (turn_end){
								obj_ini.veh_hp[_unit[0]][_unit[1]]++;
							}
							forge_veh_maintenance.repairs++;
							_loc_forge_points--;
							tech_points_used++;
						}
					}
				} else if (is_struct(_unit)){
					_loc_forge_points -= _unit.equipment_maintenance_burden();
					if  (_unit.hp() < _unit.max_health()){
						if (_unit.armour() != "Dreadnought"){
							if (_unit.hp()>0){
			        			if (_loc_heal_points >0){
			        				if (turn_end){
			        					_unit.healing(true);
			        				}
			        				_loc_heal_points--;
			        				apothecary_points_used--;
			        			} else {
			        				if (turn_end){
			        					_unit.healing(false);
			        				}
			        			}	
							} else if (_loc_heal_points>0 && _loc_forge_points>=3 && _unit.bionics<10){
								_unit.add_bionics();
								_loc_heal_points--;
								apothecary_points_used--;
								tech_points_used++;
								_loc_forge_points--;
							}			
						} else {
							if (_loc_heal_points>0 && _loc_forge_points>=3 && _unit.hp()>0){
		        				if (turn_end){
		        					_unit.healing(true);
		        				}
								_loc_heal_points--;
								apothecary_points_used--;
								tech_points_used+=3;
								_loc_forge_points-=3;							
							}
						}
					}
				}
			}
			_point_breakdown.heal_points_use = _point_breakdown.heal_points - _loc_heal_points;
			_point_breakdown.forge_points_use = _point_breakdown.forge_points - _loc_forge_points;	
			if (cur_system!=""){
				point_breakdown.systems[$ cur_system.name][p] = DeepCloneStruct(_point_breakdown);
			} else if (p==0 && (string_count("ref instance", _cur_loc))){
				try {
					var _instance_int = real(string_replace(_cur_loc, "ref instance ", ""));
					if (instance_exists(_instance_int)){
						var _instance = _instance_int;
						_instance.point_breakdown = DeepCloneStruct(_point_breakdown);
					}
				}catch(_exception) {
					handle_exception(_exception);
				}
			}	
			if (cur_system!="" && p>0 && turn_end){
				with (cur_system){
		 			if (array_length(p_feature[p])!=0){
		 				var _planet_data = new PlanetData(p, self);
		 				_planet_data.recover_starship(cur_techs);
			            if (_planet_data.planet_training(_loc_heal_points)){

			            }
			        }
			    }
		    }		
		}
	}
}



