// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more informationype

enum ePlayerBase {
	home_world = 1,
	fleet_based = 2,
	penitent = 3,
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
	show_debug_message("cancel");
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


function move_ship_between_player_fleets(out_fleet, in_fleet, class, index){
	if (class=="capital"){
		array_insert(in_fleet.capital, 1,out_fleet.capital[index]);
		array_insert(in_fleet.capital_num, 1,out_fleet.capital_num[index])
		array_insert(in_fleet.capital_uid, 1,out_fleet.capital_uid[index]);
		array_insert(in_fleet.capital_sel, 1,out_fleet.capital_sel[index]);

		in_fleet.capital_number++;
		array_delete(out_fleet.capital, index, 1);
		array_delete(out_fleet.capital_num, index, 1);
		array_delete(out_fleet.capital_uid, index, 1);
		array_delete(out_fleet.capital_sel, index, 1);

		out_fleet.capital_number--;

	} else if (class=="frigate"){
		array_insert(in_fleet.frigate, 1,out_fleet.frigate[index]);
		array_insert(in_fleet.frigate_num, 1,out_fleet.frigate_num[index])
		array_insert(in_fleet.frigate_uid, 1,out_fleet.frigate_uid[index]);
		array_insert(in_fleet.frigate_sel, 1,out_fleet.frigate_sel[index]);
		in_fleet.frigate_number++;
		array_delete(out_fleet.frigate, index, 1);
		array_delete(out_fleet.frigate_num, index, 1);
		array_delete(out_fleet.frigate_uid, index, 1);
		array_delete(out_fleet.frigate_sel, index, 1);
		out_fleet.frigate_number--;
	}else if (class=="escort"){
		array_insert(in_fleet.escort, 1,out_fleet.escort[index]);
		array_insert(in_fleet.escort_num, 1,out_fleet.escort_num[index])
		array_insert(in_fleet.escort_uid, 1,out_fleet.escort_uid[index]);
		array_insert(in_fleet.escort_sel, 1,out_fleet.escort_uid[index]);
		in_fleet.escort_number++;
		array_delete(out_fleet.escort, index, 1);
		array_delete(out_fleet.escort_num, index, 1);
		array_delete(out_fleet.escort_uid, index, 1);
		array_delete(out_fleet.escort_sel, index, 1);
		out_fleet.escort_number--;
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

function fleet_full_ship_array(fleet="none", exclude_capitals=false, exclude_frigates = false, exclude_escorts = false){
	var all_ships = [];
	var i;
	if (fleet=="none"){
		if (!exclude_capitals){
			for (i=0; i<=capital_number;i++){
				if (i>=0 && i < array_length(capital_num)){
					array_push(all_ships, capital_num[i]);
				}
			}
		}
		if (!exclude_frigates){
			for (i=0; i<=frigate_number;i++){
				if (i>=0 && i < array_length(frigate_num)){
					array_push(all_ships, frigate_num[i]);
				}
			}
		}
		if (!exclude_escorts){
			for (i=0; i<=escort_number;i++){
				if (i>=0 && i < array_length(escort_num)){
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
	fleet_ships = fleet_full_ship_array();
	var temp;
	for (var i=0;i<array_length(fleet_ships);i++){
		temp = fleet_ships[i];
		if (temp>=0 && temp < array_length(obj_ini.ship_location)){
			obj_ini.ship_location[temp] = location;
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




function new_player_ship(type, start_loc="home"){
    var ship_names="",new_name="",index=0;
    for(var k=1; k<array_length(obj_ini.ship); k++){
        if (index==0) and (obj_ini.ship[k]=="") then index=k;
    }
    
    for(var k=1; k<=200; k++){
        if (new_name==""){
            new_name=global.name_generator.generate_imperial_ship_name();
            if (array_contains(obj_ini.ship,new_name)) then new_name="";
        } else {break};
    }
    if (start_loc == "home") then start_loc = obj_ini.home_name;
   obj_ini.ship[index]=new_name;
    obj_ini.ship_uid[index]=floor(random(99999999))+1;
    obj_ini.ship_owner[index]=1; //TODO: determine if this means the player or not
    obj_ini.ship_size[index]=1;
    obj_ini.ship_location[index]=start_loc;
    obj_ini.ship_leadership[index]=100;	
    if (string_count("Battle Barge",type)>0){
        obj_ini.ship_class[index]="Battle Barge";
        obj_ini.ship_size[index]=3;
        obj_ini.ship_hp[index]=1200;
        obj_ini.ship_maxhp[index]=1200;
        obj_ini.ship_conditions[index]="";
        obj_ini.ship_speed[index]=20;
        obj_ini.ship_turning[index]=45;
        obj_ini.ship_front_armour[index]=6;
        obj_ini.ship_other_armour[index]=6;
        obj_ini.ship_weapons[index]=5;
        obj_ini.ship_shields[index]=12;
        obj_ini.ship_wep[index,1]="Weapons Battery";
        obj_ini.ship_wep_facing[index,1]="left";
        obj_ini.ship_wep_condition[index,1]="";
        obj_ini.ship_wep[index,2]="Weapons Battery";
        obj_ini.ship_wep_facing[index,2]="right";
        obj_ini.ship_wep_condition[index,2]="";
        obj_ini.ship_wep[index,3]="Thunderhawk Launch Bays";
        obj_ini.ship_wep_facing[index,3]="special";
        obj_ini.ship_wep_condition[index,3]="";
        obj_ini.ship_wep[index,4]="Torpedo Tubes";
        obj_ini.ship_wep_facing[index,4]="front";
        obj_ini.ship_wep_condition[index,4]="";
        obj_ini.ship_wep[index,5]="Bombardment Cannons";
        obj_ini.ship_wep_facing[index,5]="most";
        obj_ini.ship_wep_condition[index,5]="";
        obj_ini.ship_capacity[index]=600;
        obj_ini.ship_carrying[index]=0;
        obj_ini.ship_contents[index]="";
        obj_ini.ship_turrets[index]=3;
    }
    if (string_count("Strike Cruiser",type)>0){
        obj_ini.ship_class[index]="Strike Cruiser";
        obj_ini.ship_size[index]=2;
        obj_ini.ship_hp[index]=600;
        obj_ini.ship_maxhp[index]=600;
        obj_ini.ship_conditions[index]="";
        obj_ini.ship_speed[index]=25;
        obj_ini.ship_turning[index]=90;
        obj_ini.ship_front_armour[index]=6;
        obj_ini.ship_other_armour[index]=6;
        obj_ini.ship_weapons[index]=4;
        obj_ini.ship_shields[index]=6;
        obj_ini.ship_wep[index,1]="Weapons Battery";
        obj_ini.ship_wep_facing[index,1]="left";
        obj_ini.ship_wep_condition[index,1]="";
        obj_ini.ship_wep[index,2]="Weapons Battery";
        obj_ini.ship_wep_facing[index,2]="right";
        obj_ini.ship_wep_condition[index,2]="";
        obj_ini.ship_wep[index,3]="Thunderhawk Launch Bays";
        obj_ini.ship_wep_facing[index,3]="special";
        obj_ini.ship_wep_condition[index,3]="";
        obj_ini.ship_wep[index,4]="Bombardment Cannons";
        obj_ini.ship_wep_facing[index,4]="most";
        obj_ini.ship_wep_condition[index,4]="";
        obj_ini.ship_capacity[index]=250;
        obj_ini.ship_carrying[index]=0;
        obj_ini.ship_contents[index]="";
        obj_ini.ship_turrets[index]=1;
    }
    if (string_count("Gladius",type)>0){
        obj_ini.ship_class[index]="Gladius";
        obj_ini.ship_hp[index]=200;
        obj_ini.ship_maxhp[index]=200;
        obj_ini.ship_conditions[index]="";
        obj_ini.ship_speed[index]=30;
        obj_ini.ship_turning[index]=90;
        obj_ini.ship_front_armour[index]=5;
        obj_ini.ship_other_armour[index]=5;
        obj_ini.ship_weapons[index]=1;
        obj_ini.ship_shields[index]=1;
        obj_ini.ship_wep[index,1]="Weapons Battery";
        obj_ini.ship_wep_facing[index,1]="most";
        obj_ini.ship_wep_condition[index,1]="";
        obj_ini.ship_capacity[index]=30;
        obj_ini.ship_carrying[index]=0;
        obj_ini.ship_contents[index]="";
        obj_ini.ship_turrets[index]=1;
    }
    if (string_count("Hunter",type)>0){
        obj_ini.ship_class[index]="Hunter";
        obj_ini.ship_hp[index]=200;
        obj_ini.ship_maxhp[index]=200;
        obj_ini.ship_conditions[index]="";
        obj_ini.ship_speed[index]=30;
        obj_ini.ship_turning[index]=90;
        obj_ini.ship_front_armour[index]=5;
        obj_ini.ship_other_armour[index]=5;
        obj_ini.ship_weapons[index]=2;
        obj_ini.ship_shields[index]=1;
        obj_ini.ship_wep[index,1]="Torpedoes";
        obj_ini.ship_wep_facing[index,1]="front";
        obj_ini.ship_wep_condition[index,1]="";
        obj_ini.ship_wep[index,2]="Weapons Battery";
        obj_ini.ship_wep_facing[index,2]="most";
        obj_ini.ship_wep_condition[index,2]="";
        obj_ini.ship_capacity[index]=25;
        obj_ini.ship_carrying[index]=0;
        obj_ini.ship_contents[index]="";
        obj_ini.ship_turrets[index]=1;
    }
    return index;
}


function get_nearest_player_fleet(nearest_x, nearest_y, is_static=false, is_moving=false){
	var chosen_fleet = "none";
	if instance_exists(obj_p_fleet){
		with(obj_p_fleet){
			var viable = !(is_static && action!="");
			if (viable && is_moving){
				if (action!="move") then viable = false;
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

function get_valid_player_ship(location="", name=""){
	for (var i = 0;i<array_length(obj_ini.ship);i++){
		if (obj_ini.ship[i] != ""){
			if (location == ""){
				return i;
			} else {
				if (obj_ini.ship_location[i] == location){
					return i;
				}
			}
		}
	}
	return -1;
}



