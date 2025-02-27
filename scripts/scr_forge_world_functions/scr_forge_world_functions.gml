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
		    construction_forge=choose_array(forge_systems);
		    build_new_navy_fleet(construction_forge)
		}
	}
}

function build_planet_defence_fleets(){
		imp_ships=0;
	    with(obj_en_fleet){
	        if (owner==eFACTION.Imperium){
	            obj_controller.imp_ships+=capital_number;
	            obj_controller.imp_ships+=frigate_number/2;
	            obj_controller.imp_ships+=escort_number/4;
	        }
	    }
	    var _imperial_systems=[];
	    var _mechanicus_worlds=[];
	    var _imperial_planet_count=0;
	    with(obj_star){
	        //empty object simply acts as a counter for the number of imperial systems
	        if (owner == eFACTION.Imperium){
	            array_push(_imperial_Systems, id);
	        }else if (owner == eFACTION.Mechanicus){
	            array_push(_mechanicus_worlds, id);
	        }
            for (var i=0;i<=planets;i++){
            	var _owner_imperial = p_owner[i] < 5 && p_owner[i] > 1;
            	_imperial_planet_count += _owner_imperial;
            } 
	        //unknown function of temp5 same as temp6 but for mechanicus worlds
	        if (space_hulk || craftworld){
	        	instance_deactivate_object(id)
	        }
	    }
	    // Former: var sha;sha=instance_number(obj_temp6)*1.3;
	    var mechanicus_world_total = array_length(_mechanicus_worlds);

	    var ship_allowance=array_length(_imperial_planet_count)*(0.65+(mechanicus_world_total*3));// new

	            /*in order for new ships to spawn the number of total imperial ships must be smaller than 
	             one third of the total imperial star systems*/
	    if (mechanicus_world_total>0) and (imp_ships<ship_allowance){
	        var rando=d100_roll(), rando2=choose(1,2,2,3,3,3);
	        var forge=array_random_element(_mechanicus_worlds);
	        var _current_imperial_fleet = scr_orbiting_fleet(eFACTION.Imperium,forge);
	        if (rando>(12)*mechanicus_world_total) return "no new imperial ships";
	        var _defence_fleet = false;
	        if (_current_imperial_fleet != "none"){
	        	if (!_current_imperial_fleet.navy){
	        		_defence_fleet = true;
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
	        	}
	        } else {
	        	var _current_imperial_fleet = instance_create(forge.x,forge.y,obj_en_fleet);
	        	_defence_fleet = true;
	        	with (_current_imperial_fleet){
	        		owner= eFACTION.Imperium;
	        		choose_fleet_sprite_image();
	        		trade_goods = "merge";
	        	}
	        }
	        if (_defence_fleet){

	        }
	        
	        //the less mechanicus forge worlds the less likely to spawn a new fleet
	        if (rando<=(12)*mechanicus_world_total){

	    		
	    		var system_4 = [];
	    		var system_3 = [];
	    		var system_other = [];
	    		
	            with(obj_star) {
	                if (x>10) and (y>10) and ((owner==eFACTION.Imperium) or (owner==eFACTION.Mechanicus)){
	                    var system_fleet_elements=0;
	    				
	    				var fleet_types = [
	    					eFACTION.Player,
	    					eFACTION.Imperium,
	    					eFACTION.Mechanicus,
	    					eFACTION.Inquisition,
	    					eFACTION.Ecclesiarchy,
	    					eFACTION.Eldar,
	    					eFACTION.Ork,
	    					eFACTION.Tau,
	    					eFACTION.Tyranids,
	    					eFACTION.Chaos,
	    					eFACTION.Necrons
	    				];
	    				
	                    system_fleet_elements = array_sum(present_fleet)

	    				var coords = [x,y];
	    				
	                    if (system_fleet_elements==0) {
	                        switch(planets){
	                            case 4:
	                                array_push(system_4, coords);
	                                break;
	                            case 3:
	                                array_push(system_3, coords);
	                                break;
	    						default:
	    							if (p_type[1]!="Dead") {
	    								array_push(system_other, coords);
	    							}
	                                break;
	                        }
	                    };
	                }
	            }
	    		
	            var targeted=false;
	            var target;
	    		//shuffle the contents, if any
	    		array_shuffle_ext(system_4);
	    		array_shuffle_ext(system_3);
	    		array_shuffle_ext(system_other);

	            if (targeted) {
	    			target = array_pop(system_4)
	                targeted=true;
	    		}
	    		if (targeted) {
	    			target = array_pop(system_3)
	                targeted=true;
	    		}
	    		if (targeted) {
	    			target = array_pop(system_other)
	                targeted=true;
	    		}

	            if (targeted){ 
	                new_defense_fleet.action_x=target[0];
	                new_defense_fleet.action_y=target[1];
	                with (new_defense_fleet){
	                    set_fleet_movement();
	                }
	            }
	        }
	    }

	    instance_activate_object(obj_star);
	}
}






