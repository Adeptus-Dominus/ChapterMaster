// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function imperial_navy_fleet_construction(){
	// ** Check number of navy fleets **

	var new_navy_fleets = [];
	with(obj_en_fleet){
	    if (owner==eFACTION.Imperium) and (navy==1) {
	    	array_push(new_navy_fleets, id);
	    }
	}
	//delete navy fleets if more than required
	var navy_fleet_count = array_length(new_navy_fleets);
	var cur_fleet;
	if (navy_fleet_count>target_navy_number) {
		for (var i=0;i<navy_fleet_count;i++){
			cur_fleet = new_navy_fleets[i];
			if (cur_fleet.guardsmen_unloaded){
				continue;
			} else {
				instance_destroy(cur_fleet);
				navy_fleet_count--;
				array_delete(new_navy_fleets, i, 1);
				i--;
				if (navy_fleet_count<=target_navy_number) then break;
			}
		} 

		//if system needs more navy fleets get forge world to make some
	} else if (navy_fleet_count<target_navy_number) {
		var forge_systems = [];
	    with(obj_star){
	        var good=false;
	        for(var o=1; o<=planets; o++) {
	            if (p_type[o]=="Forge") 
					and (p_owner[o]==eFACTION.Mechanicus) 
					and (p_orks[o]+p_tau[o]+p_tyranids[o]+p_chaos[o]+p_traitors[o]+p_necrons[o]==0) {
						
						var enemy_fleets = [
							eFACTION.Ork,
							eFACTION.Tau,
							eFACTION.Tyranids,
							eFACTION.Chaos,
							eFACTION.Necrons
						]
					
						var enemy_fleet_count = array_reduce(enemy_fleets, function(prev, curr) {
							return prev + present_fleet[curr]
						})
			            if (enemy_fleet_count == 0){
			                good=true;
			                if (instance_nearest(x,y,obj_en_fleet).navy) then good=false;
			            }
	            }
	        }
	        if (good){
	        	good = x<=room_width && y<=room_height;
	        }
	        if (good==true) then array_push(forge_systems, id);
	    }
	// After initial navy fleet construction fleet growth is handled in obj_en_fleet.alarm_5
		if (array_length(forge_systems)){
		    var construction_forge,new_navy_fleet;
		    construction_forge=array_random_element(forge_systems);
		    build_new_navy_fleet(construction_forge)
		}
	}
}

function build_planet_defence_fleets(){
	imp_ships=0;
	var _defence_fleet_log = {};
    with(obj_en_fleet){
        if (owner==eFACTION.Imperium){
        	var _imperial_fleet_defence_score = capital_number + (frigate_number/2) + (escort_number/4);
            obj_controller.imp_ships += _imperial_fleet_defence_score;
            //log this to prevent double work later figuring out if a planet has an orbiting defence fleet
            if (!navy && action=="" && is_orbiting()){
            	_defence_fleet_log[$ orbiting.name] = _imperial_fleet_defence_score;
            }
        }
    }
    var _imperial_systems=[];
    var _mechanicus_worlds=[];
    var _imperial_planet_count=0;
    var _value_hierarchy = [];
    with(obj_star){
        //empty object simply acts as a counter for the number of imperial systems
        if (owner == eFACTION.Imperium){
            array_push(_imperial_systems, id);
        }else if (owner == eFACTION.Mechanicus){
            array_push(_mechanicus_worlds, id);
        }
        var _system_value = 0;
        for (var i=0;i<=planets;i++){
        	var _owner_imperial = (p_owner[i] < 5 && p_owner[i] > 1);
        	_imperial_planet_count += _owner_imperial;
        	if (p_type[i] == "Forge") then continue;
        	//probably abstract else where this could also be useful for 
        	if (_owner_imperial){
        		var _imperial_value = 0;
        		static planet_types_value = {
        			"Dead": 0,
        			"Ice" : 1,
        			"Temperate": 4,
        			"Feudal" : 3,
        			"Shrine" : 5,
        			"Agri" : 5,
        			"Death" : 2,
        			"Hive" : 5,
        			"Forge" : 7,
        			"Desert" : 2,
        			"Lava" : 2,
        		}
        		if (struct_exists(planet_types_value, p_type[i])){
	        		_imperial_value = planet_types_value[$ p_type[i]] + p_fortified[i];
	        		_system_value += _imperial_value;
        		}
        	}
        } 
        if (struct_exists(_defence_fleet_log, name)){
        	_system_value -= (_defence_fleet_log[$ name]*2);
        }
        if (_system_value){
        	if (array_length(_value_hierarchy) == 0){
        		array_push(_value_hierarchy, [id, _system_value]);
        	} else {
        		for (var i=0;i<array_length(_value_hierarchy);i++){
        			if (_system_value>_value_hierarchy[i][1]){
        				array_insert(_value_hierarchy, i, [id, _system_value]);
        				break;
        			}
        		}
        	}
        }
        //unknown function of temp5 same as temp6 but for mechanicus worlds
        if (space_hulk || craftworld){
        	instance_deactivate_object(id)
        }
    }
    // Former: var sha;sha=instance_number(obj_temp6)*1.3;
    var mechanicus_world_total = array_length(_mechanicus_worlds);

   	max_fleet_strength =(_imperial_planet_count/8)*(mechanicus_world_total*3);// new

            /*in order for new ships to spawn the number of total imperial ships must be smaller than 
             one third of the total imperial star systems*/
    if (mechanicus_world_total>0 && imp_ships<max_fleet_strength){
        var rando=roll_dice(1, 100), rando2=choose(1,2,2,3,3,3);
        if (rando>(12)*mechanicus_world_total){
        	instance_activate_object(obj_star);
        	scr_alert("", "forge_world", "No new imperial defence ships built this month");
        	return "no new imperial defence ships built this month";
        } 
        var forge=array_random_element(_mechanicus_worlds);
        var _current_imperial_fleet = scr_orbiting_fleet(eFACTION.Imperium,forge);        
        var _defence_fleet = false;
        if (_current_imperial_fleet != "none"){
        	if (!_current_imperial_fleet.navy){
        		_defence_fleet = true;	        		
        	}
        } else {
        	var _current_imperial_fleet = instance_create(forge.x,forge.y,obj_en_fleet);
        	_defence_fleet = true;
        	with (_current_imperial_fleet){
        		navy = false
        		owner = eFACTION.Imperium;
        		choose_fleet_sprite_image();
        	}
        }
        if (_defence_fleet && array_length(_value_hierarchy)){
        	_current_imperial_fleet.trade_goods = "merge";
            switch(rando2){
                case 1:
                    _current_imperial_fleet.capital_number++;
                    break;
                case 2:
                    _current_imperial_fleet.frigate_number++;
                    break;
                case 3:
                    _current_imperial_fleet.escort_number++;
                	break;
            }        	
        	var _thirds = ceil(array_length(_value_hierarchy)/3);
        	var _nearest = false;
        	var _distance = 10000000;
        	for (var i=0;i<_thirds;i++){
        		var _sys = _value_hierarchy[i];
        		var _sys_distance = point_distance(forge.x, forge.y, _sys[0].x,_sys[0].y);
        		if (_sys_distance<_distance){
        			_nearest = _sys[0].id;
        			_distance = _sys_distance;
        		}
        	}
	  
            if (instance_exists(_nearest)){ 
                _current_imperial_fleet.action_x=_nearest.x;
                _current_imperial_fleet.action_y=_nearest.y;
                with (_current_imperial_fleet){
                    set_fleet_movement();
                }
                instance_activate_object(obj_star);
                scr_alert("", "forge_world", $"New imperial defence ship sets off for {_nearest.name} from {forge.name}");
                return $"New imperial defence ships set off for {_nearest.name} from {forge.name}";
            }	        	
        }
        
        //the less mechanicus forge worlds the less likely to spawn a new fleet
    }

    instance_activate_object(obj_star);
}







