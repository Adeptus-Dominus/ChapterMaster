// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more informationype

function init_player_fleet_arrays(){
	ship=[];
	ship_uid=[];
	ship_owner=[];
	ship_class=[];
	ship_size=[];
	ship_leadership=[];
	ship_hp=[];
	ship_maxhp=[];

	ship_location=[];
	ship_shields=[];
	ship_conditions=[];
	ship_speed=[];
	ship_turning=[];

	ship_front_armour=[];
	ship_other_armour=[];
	ship_weapons=[];

	ship_wep = array_create(6, "");
	ship_wep_facing=array_create(6, "");
	ship_wep_condition=array_create(6, "");

	ship_capacity=[];
	ship_carrying=[];
	ship_contents=[];
	ship_turrets=[];
	ship_lost = [];	
}
function fleet_has_roles(fleet="none", roles){
	var all_ships = fleet_full_ship_array(fleet);
	var unit;
	for (var i=0;i<=10;i++){
		for (var s=0;s<array_length(obj_ini.TTRPG[i]);s++){
			unit=fetch_unit([i,s]);
			if (unit.planet_location<1){
				if (array_contains(all_ships,unit.ship_location)){
					if (array_contains(roles, unit.role())){

						return true;
					}
				}
			}
		}
	}
}

function split_selected_into_new_fleet(start_fleet="none"){
	var new_fleet;
	if (start_fleet=="none"){
		new_fleet = instance_create(x,y,obj_p_fleet);
		new_fleet.owner  = eFACTION.Player;
        // Pass over ships to the new fleet, if they are selected
        var cap_number = array_length(capital);

        for (i=0; i<cap_number;i++){
            if (capital[i]!="") and (capital_sel[i]){
            	move_ship_between_player_fleets(self, new_fleet,"capital", i);
            	i--;
            	cap_number--;
            }
        }
        var frig_number = array_length(frigate);
        for (i=0; i<frig_number;i++){
            if (frigate[i]!="") and (frigate_sel[i]){
            	move_ship_between_player_fleets(self, new_fleet,"frigate", i);
            	i--;
            	frig_number--;
            }
        }
        var esc_number = array_length(escort);
        for (i=0; i<esc_number;i++){
            if (escort[i]!="") and (escort_sel[i]){
            	move_ship_between_player_fleets(self, new_fleet,"escort", i)
            	i--;
            	esc_number--;
            }
        }
       	set_player_fleet_image();	
	} else {
		with (start_fleet){
			new_fleet = split_selected_into_new_fleet();
		}
	}
	return new_fleet;
}

function cancel_fleet_movement(){
	var nearest_star = instance_nearest(x,y, obj_star);
    action="";
    x=nearest_star.x;
    y=nearest_star.y;
    action_x=0;
    action_y=0;
    complex_route=[];
    just_left=false;
}


function set_new_player_fleet_course(target_array){
	if (array_length(target_array)>0){
		var target_planet = star_by_name(target_array[0]);
		var nearest_planet = instance_nearest(x,y,obj_star);
		var from_star = point_distance(nearest_planet.x,nearest_planet.y, x, y) <75;
		var valid = target_planet!="none";
		if (valid){
			valid = !(target_planet.id == nearest_planet.id && from_star);
		}
		if (!valid){
			if (array_length(target_array)>1){
				target_planet = star_by_name(target_array[1]);
				array_delete(target_array, 0, 2);
			} else {
				return "complex_route_finish";
			}
		} else {
			array_delete(target_array, 0, 1);
		}
		complex_route = target_array;
		var from_x = from_star ? nearest_planet.x : x;
		var from_y = from_star ? nearest_planet.y : y;
		action_eta=calculate_fleet_eta(from_x,from_y,target_planet.x,target_planet.y, action_spd, from_star, ,warp_able);
		action_x = target_planet.x;
		action_y = target_planet.y;
		action="move";
		just_left=true;
		orbiting=0;
        x=x+lengthdir_x(48,point_direction(x,y,action_x,action_y));
        y=y+lengthdir_y(48,point_direction(x,y,action_x,action_y));
        set_fleet_location("Warp");
	}

}

function find_and_move_ship_between_fleets(out_fleet, in_fleet, index){
	var _class = player_ships_class(index);
	var relative_index = -1;
	switch (_class){
		case "capital":
			relative_index = array_get_index(out_fleet.capital_num, index);
			break;
		case "frigate":
			relative_index = array_get_index(out_fleet.frigate_num, index);
			break;
		case "escort":
			relative_index = array_get_index(out_fleet.escort_num, index);
			break;
	}
	if (relative_index!=-1){
		move_ship_between_player_fleets(out_fleet, in_fleet, _class, relative_index);
	}
}

function merge_player_fleets(main_fleet, merge_fleet){
	var _merge_ships = fleet_full_ship_array(merge_fleet);
	for (var i=0;i<array_length(_merge_ships);i++){
		if (_merge_ships[i]<array_length(obj_ini.ship)){
			find_and_move_ship_between_fleets(merge_fleet, main_fleet, _merge_ships[i]);
		}
	}
	main_fleet.alarm[7]=1;
    if (instance_exists(obj_fleet_select)){
        if (obj_fleet_select.x=merge_fleet.x) and (obj_fleet_select.y=merge_fleet.y){
            with(obj_fleet_select){instance_destroy();}
            main_fleet.alarm[3]=1;
        }
    }
    with (merge_fleet){
    	instance_destroy();
    }
}
function move_ship_between_player_fleets(out_fleet, in_fleet, class, index){
	if (class=="capital"){
		array_insert(in_fleet.capital, 0,out_fleet.capital[index]);
		array_insert(in_fleet.capital_num, 0,out_fleet.capital_num[index])
		array_insert(in_fleet.capital_uid, 0,out_fleet.capital_uid[index]);
		array_insert(in_fleet.capital_sel, 0,out_fleet.capital_sel[index]);

		in_fleet.capital_number++;
		array_delete(out_fleet.capital, index, 1);
		array_delete(out_fleet.capital_num, index, 1);
		array_delete(out_fleet.capital_uid, index, 1);
		array_delete(out_fleet.capital_sel, index, 1);

		out_fleet.capital_number--;

	} else if (class=="frigate"){
		array_insert(in_fleet.frigate, 0,out_fleet.frigate[index]);
		array_insert(in_fleet.frigate_num, 0,out_fleet.frigate_num[index])
		array_insert(in_fleet.frigate_uid, 0,out_fleet.frigate_uid[index]);
		array_insert(in_fleet.frigate_sel, 0,out_fleet.frigate_sel[index]);
		in_fleet.frigate_number++;
		array_delete(out_fleet.frigate, index, 1);
		array_delete(out_fleet.frigate_num, index, 1);
		array_delete(out_fleet.frigate_uid, index, 1);
		array_delete(out_fleet.frigate_sel, index, 1);
		out_fleet.frigate_number--;
	}else if (class=="escort"){
		array_insert(in_fleet.escort, 0,out_fleet.escort[index]);
		array_insert(in_fleet.escort_num, 0,out_fleet.escort_num[index])
		array_insert(in_fleet.escort_uid, 0,out_fleet.escort_uid[index]);
		array_insert(in_fleet.escort_sel, 0,out_fleet.escort_uid[index]);
		in_fleet.escort_number++;
		array_delete(out_fleet.escort, index, 1);
		array_delete(out_fleet.escort_num, index, 1);
		array_delete(out_fleet.escort_uid, index, 1);
		array_delete(out_fleet.escort_sel, index, 1);
		out_fleet.escort_number--;
	}
}
function delete_ship_from_fleet(index, fleet){
	var _ship_class = player_ships_class(index);
	if (_ship_class=="capital"){
		var _delete_index = array_get_index(fleet.capital_num, index);
		array_delete(fleet.capital, _delete_index, 1);
		array_delete(fleet.capital_num, _delete_index, 1);
		array_delete(fleet.capital_uid, _delete_index, 1);
		array_delete(fleet.capital_sel, _delete_index, 1);

		fleet.capital_number--;
	} else if (_ship_class=="frigate"){
		var _delete_index = array_get_index(fleet.frigate_num, index);
		array_delete(fleet.frigate, _delete_index, 1);
		array_delete(fleet.frigate_num, _delete_index, 1);
		array_delete(fleet.frigate_uid, _delete_index, 1);
		array_delete(fleet.frigate_sel, _delete_index, 1);
		fleet.frigate_number--;
	}else if (_ship_class=="escort"){
		var _delete_index = array_get_index(fleet.escort_num, index);
		array_delete(fleet.escort, _delete_index, 1);
		array_delete(fleet.escort_num, _delete_index, 1);
		array_delete(fleet.escort_uid, _delete_index, 1);
		array_delete(fleet.escort_sel, _delete_index, 1);
		fleet.escort_number--;
	}
}
function set_player_fleet_image(){
    var ii=0;
    ii+=capital_number;
    ii+=round((frigate_number/2));
    ii+=round((escort_number/4));
    if (ii<=1) then ii=1;
    image_index=min(ii,9);	
}

function find_ships_fleet(index){
	var _chosen_fleet = "none";
	with (obj_p_fleet){
		if ((array_contains(capital_num, index)) ||
			(array_contains(frigate_num, index)) ||
			(array_contains(escort_num, index))){
			_chosen_fleet = self;
		}
	}
	return _chosen_fleet;

}

function add_ship_to_fleet(index, fleet="none"){
	var _escorts = ["Escort", "Hunter", "Gladius"];
	var _capitals = ["Gloriana", "Battle Barge"];
	var _frigates = ["Strike Cruiser"];	

	if (fleet=="none"){
		if (array_contains(_capitals, obj_ini.ship_class[index])){
			array_push(capital, obj_ini.ship[index]);
			array_push(capital_num, index);
			array_push(capital_sel, 0);
			array_push(capital_uid, obj_ini.ship_uid[index]);
			capital_number++;
		} else if (array_contains(_frigates, obj_ini.ship_class[index])){
			array_push(frigate, obj_ini.ship[index]);
			array_push(frigate_num, index);
			array_push(frigate_sel, 0);
			array_push(frigate_uid, obj_ini.ship_uid[index]);
			frigate_number++;
		} else if (array_contains(_escorts, obj_ini.ship_class[index])){
			array_push(escort, obj_ini.ship[index]);
			array_push(escort_num, index);
			array_push(escort_sel, 0);
			array_push(escort_uid, obj_ini.ship_uid[index]);
			escort_number++;
		}
	} else {
		with (fleet){
			add_ship_to_fleet(index);
		}
	}
}
function player_retreat_from_fleet_combat(){
	try{
	var p_strength,ratio,diceh,_roll_100;
    var mfleet=obj_turn_end.battle_pobject[obj_turn_end.current_battle];;
    var _fleet_ships = fleet_full_ship_array(mfleet);
    var en_strength=0;

    var p_strength=mfleet.escort_number;
    p_strength+=mfleet.frigate_number*3;
    p_strength+=mfleet.capital_number*8;

    _roll_100=roll_dice_chapter(1, 100, "low");
    

    var _loc_star = star_by_name(obj_turn_end.battle_location[obj_turn_end.current_battle]);

    obj_controller.temp[2001]=real(_loc_star.id);
    obj_controller.temp[2002]=real(obj_turn_end.battle_opponent[obj_turn_end.current_battle]);
    var _battle_opponent = obj_turn_end.battle_opponent[obj_turn_end.current_battle]; 

    var cap_total=0,frig_total=0,escort_total=0;
    with(obj_en_fleet){
        if (orbiting==_loc_star.id) and (owner==_battle_opponent){
            cap_total += capital_number;
            frig_total += frigate_number;
            escort_total += escort_number;
        }
    }
    
    en_strength+=cap_total*4;
    en_strength+=frig_total*2;
    en_strength+=escort_total;

    
    ratio=9999;
    if (p_strength>0) and (en_strength>0){
        ratio=(en_strength/p_strength)*100;
    }
    
    var esc_lost=0,frig_lost=0,cap_lost=0,which=0,sayd=0;
    
    i=-1;// var ship_lost,i;
    var ship_lost = [];

    if (scr_has_adv("Kings of Space")) then _roll_100-=10;
    if (_roll_100<=80) and (p_strength<=2) then _roll_100=-5;
    
    if (_roll_100!=-5){
        repeat(50){
            diceh=roll_dice_chapter(1, 100, "high");
            if (diceh<=ratio){
                ratio-=100;
                var onceh=0;
                
                if (mfleet.escort_number>0) {
                    which=array_random_index(mfleet.escort_num);
                    sayd=mfleet.escort_num[which];
                    if (!array_contains(ship_lost, sayd)){
                    	esc_lost+=1;
                        obj_ini.ship_hp[sayd]=0;
                        ship_lost[sayd]=1;
                        mfleet.escort_number-=1;
                        array_push(ship_lost, sayd);
                    }
                }
                else if (mfleet.frigate_number>0) {
                    which=array_random_index(mfleet.frigate_num);
                    sayd=mfleet.frigate_num[which];
                    if (!array_contains(ship_lost, sayd)){
                    	frig_lost+=1;
                        obj_ini.ship_hp[sayd]=0;
                        ship_lost[sayd]=1;
                        mfleet.frigate_number-=1;
                        array_push(ship_lost, sayd);
                    }
                }
                else if (mfleet.capital_number>0) {
                    which=array_random_index(mfleet.capital_num);
                    sayd=mfleet.capital_num[which];
                    if (!array_contains(ship_lost, sayd)){
                    	cap_lost+=1;
                        obj_ini.ship_hp[sayd]=0;
                        ship_lost[sayd]=1;
                        mfleet.capital_number-=1;
                        array_push(ship_lost, sayd);
                    }
                }
                if (!(mfleet.capital_number+mfleet.frigate_number+mfleet.escort_number)){
                    break;
                }
                // show_message("Ship lost");
            }
        
        }
    }
    
    obj_p_fleet.selected=0;

    with(obj_fleet_select){
        instance_destroy();
    }
    obj_controller.popup=0;
    if (obj_controller.zoomed=1){
        with(obj_controller){
            scr_zoom();
        }
    }
    
    type=98;
    title="Fleet Retreating";
    cooldown=15;
    obj_controller.menu=0;
    
    // 139;
    with(obj_temp_inq){instance_destroy();}
    instance_create(obj_turn_end.battle_pobject[obj_turn_end.current_battle].x,obj_turn_end.battle_pobject[obj_turn_end.current_battle].y,obj_temp_inq);
    with(obj_en_fleet){
        if (navy=1) and (point_distance(x,y,obj_temp_inq.x,obj_temp_inq.y)<40) and (trade_goods="player_hold") then trade_goods="";
    }
    with(obj_temp_inq){instance_destroy();}
    
    if (esc_lost+frig_lost+cap_lost>0) and (mfleet.escort_number+mfleet.frigate_number+mfleet.capital_number>0){
        text="Your fleet is given the command to fall back.  The vesels turn and prepare to enter the Warp, constantly under a hail of enemy fire.  Some of your ships remain behind to draw off the attack and give the rest of your fleet a chance to escape.  ";
        
        if (cap_lost=1) then text+=string(cap_lost)+" Battle Barge is destroyed.  ";
        if (frig_lost=1) then text+=string(frig_lost)+" Strike Cruiser is destroyed.  ";
        if (esc_lost=1) then text+=string(esc_lost)+" Escort is destroyed.  ";
        
        if (cap_lost>1) then text+=string(cap_lost)+" Battle Barges were destroyed.  ";
        if (frig_lost>1) then text+=string(frig_lost)+" Strike Cruisers were destroyed.  ";
        if (esc_lost>1) then text+=string(esc_lost)+" Escorts were destroyed.  ";
    }
    var text = "Your fleet is given the command to fall back.  The vessels turn and prepare to enter the Warp, constantly under a hail of enemy fire. ";
    if (esc_lost+frig_lost+cap_lost=0){
        text+="The entire fleet manages to escape with minimal damage.";
    }
    
    if (mfleet.escort_number+mfleet.frigate_number+mfleet.capital_number=0){
        text+="All of your ships are destroyed attempting to flee.";
    }

    with (obj_p_fleet){
        scr_ini_ship_cleanup();

        if (player_fleet_ship_count() == 0){
            instance_destroy();
        } else {
            complex_route=[];
        }     
    }        
    with(obj_fleet_select){instance_destroy();}
    
    /*
    with(obj_ini){scr_dead_marines(1);}
    with(obj_ini){scr_ini_ship_cleanup();}
    */
	} catch(_exception){
		handle_exception(_exception)
	}
}
function fleet_full_ship_array(fleet="none", exclude_capitals=false, exclude_frigates = false, exclude_escorts = false){
	var all_ships = [];
	var i;
	var _ship_count = array_length(obj_ini.ship);
	if (fleet=="none"){
		if (!exclude_capitals){
			for (i=0; i<array_length(capital_num);i++){

				if (capital_num[i]<_ship_count){
					array_push(all_ships, capital_num[i]);
				}

			}
		}
		if (!exclude_frigates){
			for (i=0; i<array_length(frigate_num);i++){

				if (frigate_num[i]<_ship_count){
					array_push(all_ships, frigate_num[i]);
				}

			}
		}
		if (!exclude_escorts){
			for (i=0; i<array_length(escort_num);i++){
				if (escort_num[i]<_ship_count){
					array_push(all_ships, escort_num[i]);
				}
			}
		}			
	} else {
		with (fleet){
			all_ships = fleet_full_ship_array();
		}
	}
	return all_ships;
}
function set_fleet_location(location){
	var fleet_ships = fleet_full_ship_array();
	var temp;
	for (var i=0;i<array_length(fleet_ships);i++){
		temp = fleet_ships[i];
		if (temp>=0 && temp < array_length(obj_ini.ship_location)){
			obj_ini.ship_location[temp] = location;
		}
	}
	var unit;
	for (var co=0;co<=obj_ini.companies;co++){
		for (i=0;i<array_length(obj_ini.name[co]);i++){
			unit = fetch_unit([co,i]);
			if (array_contains(fleet_ships, unit.ship_location)){
				obj_ini.loc[co][i]=location;
			}
		}
	}
}

function selected_ship_types(){
	var capitals=0,frigates=0,escorts=0,i;
    for (i=0; i<array_length(capital);i++){
        if(capital[i]!="" && capital_sel[i]){
            capitals=true
            break;
        }
    } 
    for (i=0; i<array_length(frigate);i++){
        if(frigate[i]!="" && frigate_sel[i]){
            frigates=true
            break;
        }
    } 
    for (i=0; i<array_length(escort);i++){
        if(escort[i]!="" && escort_sel[i]){
            escorts=true
            break;
        }
    }
    return [capitals,frigates,escorts];
}
function player_fleet_ship_count(fleet="none"){
	var ship_count = 0;
	if (fleet=="none"){
		capital_number = 0;
		frigate_number = 0;
		escort_number = 0;

		for (i=0; i<array_length(capital);i++){
			if (capital[i]!=""){
				ship_count++;
				capital_number++;
			}
		}
		for (i=0; i<array_length(frigate);i++){
			if (frigate[i]!=""){
				ship_count++;
				frigate_number++;
			}
		}
		for (i=0; i<array_length(escort);i++){
			if (escort[i]!=""){
				ship_count++;
				escort_number++;
			}
		}
	} else {
		with(fleet){
			ship_count = player_fleet_ship_count();
		}
	}
	return ship_count;		
}

function player_fleet_selected_count(fleet="none"){
	var ship_count = 0;
	if (fleet=="none"){
		for (i=0; i<array_length(capital);i++){
			if(capital[i]!="" && capital_sel[i]) then ship_count++;
		}
		for (i=0; i<array_length(frigate);i++){
			if(frigate[i]!="" && frigate_sel[i]) then ship_count++;
		}
		for (i=0; i<array_length(escort);i++){
			if(escort[i]!="" && escort_sel[i]) then ship_count++;
		}
	} else {
		with(fleet){
			ship_count = player_fleet_selected_count();
		}		
	}
	return ship_count;			
}



function get_nearest_player_fleet(nearest_x, nearest_y, is_static=false, is_moving=false, stop_complex_actions = true){
	var chosen_fleet = "none";
	if instance_exists(obj_p_fleet){
		with(obj_p_fleet){
			var viable = !(is_static && action!="");
			if (viable && is_moving){
				if (action!="move") then viable = false;
			}
			if (stop_complex_actions){
				if (string_count("crusade", action) || action == "Lost"){
					viable = false;
				}
			}
			if (!viable) then continue;
			if (point_in_rectangle(x, y, 0, 0, room_width, room_height)){
				if (chosen_fleet=="none"){
					chosen_fleet=self;
				}
				if (point_distance(nearest_x, nearest_y,x,y) < point_distance(nearest_x, nearest_y,chosen_fleet.x,chosen_fleet.y)){
					chosen_fleet=self;
				}
			}
		}
	}
	return chosen_fleet;	
}

function calculate_fleet_content_size(ship_array){
	var total_content = 0;
	for (var i=0;i<array_length(ship_array);i++){
		var _ship_id  = ship_array[i];
		if (_ship_id<array_length(obj_ini.ship)){
			total_content += obj_ini.ship_carrying[_ship_id];
		}
	}
	return total_content;	
}


function calculate_fleet_bombard_score(ship_array){
	var bomb_score = 0;
	for (var i=0;i<array_length(ship_array);i++){
		var _ship_id  = ship_array[i];
		if (_ship_id<array_length(obj_ini.ship)){
			bomb_score += ship_bombard_score(_ship_id);
		}
	}
	return bomb_score;
}

