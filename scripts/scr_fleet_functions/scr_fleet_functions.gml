

function distribute_strength_to_fleet(strength, fleet){
	while(strength>0){
		var ship_type = choose(1,1,1,1,2,2,3);
		strength-=ship_type;
		if (ship_type==1){
			fleet.escort_number++;
		} else if (ship_type==2){
			fleet.frigate_number++;
		}else if (ship_type==3){
			fleet.capital_number++;
		}
	}
}

//to be run within with scope
function set_fleet_target(targ_x, targ_y, final_target){
	action_x = targ_x;
	action_y = targ_y;
	target = final_target;
	action_eta=floor(point_distance(x,y,targ_x,targ_y)/128)+1;
}

function scr_valid_fleet_target(target) {
    if (target == noone) {
        return false;
    }
    if (is_string(target)) {
        target = noone;
        return false;
    }
    var valid = instance_exists(target);
    if (valid) {
        valid = (target.object_index == obj_p_fleet || target.object_index == obj_en_fleet);
    }
    return valid;
}

function fleets_next_location(fleet = "none", visited = []) {
    var targ_location = "none";

    if (fleet == "none") {
        fleet = self;
    }

    if (instance_exists(fleet)) {
        // Add the current fleet's ID to the visited list to avoid rechecking it
        array_push(visited, fleet.id);

        // Check if the fleet has a 'target' variable
        if (variable_instance_exists(fleet, "target")) {
            // If the target is valid and not already in the visited list, proceed recursively
            var fleet_target_valid = scr_valid_fleet_target(fleet.target);
            if (!fleet_target_valid) {
                fleet.target = 0;
            }
            if (fleet_target_valid && !array_contains(visited, fleet.target.id)) {
                // Recursive call with the target and the updated visited list
                targ_location = fleets_next_location(fleet.target, visited);
            } else if (fleet.action != "") {
                // If no valid target, use the fleet's action coordinates
                targ_location = instance_nearest(fleet.action_x, fleet.action_y, obj_star);
            } else {
                // Default to nearest star to fleet's current position
                targ_location = instance_nearest(fleet.x, fleet.y, obj_star);
            }
        }
    }
    // If targ_location was not set to anything else, default to the nearest star
    if (targ_location == "none") {
        targ_location = instance_nearest(fleet.x, fleet.y, obj_star);
    }
    return targ_location;
}


function chase_fleet_target_set(target){
	var targ_location = fleets_next_location(target);
	if (targ_location!="none"){
		action_x=targ_location.x;
	    action_y=targ_location.y;
	    action="";
	    set_fleet_movement();
	}
}

function fleet_intercept_time_calculate(target_intercept){
	var intercept_time = -1
	targ_location = fleets_next_location(target_intercept);
	if (instance_exists(targ_location)){
		intercept_time=floor(point_distance(x,y,action_x,action_y)/action_spd)+1;
	}
	return intercept_time;
}


function get_largest_player_fleet(){

	var chosen_fleet = "none";
	if (instance_exists(obj_p_fleet)){
		with(obj_p_fleet){
			if (point_in_rectangle(x, y, 0, 0, room_width, room_height) && (point_in_rectangle(action_x, action_y, 0, 0, room_width, room_height))){
				if (chosen_fleet=="none"){
					chosen_fleet=self;
					continue;
				}
				if (!(capital_number==0 && chosen_fleet.capital_number==0)){
					if (capital_number>chosen_fleet.capital_number){
						chosen_fleet = self;
					}
				} else if (!(frigate_number==0 && chosen_fleet.frigate_number==0)) {
					if (frigate_number>chosen_fleet.frigate_number){
						chosen_fleet = self;
					}
				}else if (!(escort_number==0 && chosen_fleet.escort_number==0)) {
					if (escort_number>chosen_fleet.escort_number){
						chosen_fleet = self;
					}
				}
			}
		}
	}
	return chosen_fleet;
}

function is_orbiting(){
	if (action != "") then return false;
	try {
		var nearest = instance_nearest(x,y,obj_star);
		if (point_distance(x,y,nearest.x, nearest.y)<10 && nearest.name != ""){
			orbiting = nearest.id;
			return true
		}
		orbiting=false;
	} catch(_exception){
		return false;
	}
	return false;
}

function set_fleet_movement(fastest_route = true, new_action="move"){

	action = "";

	if (action==""){
		turns_static = 0;
	    var mine, fleet;
	    var connected=0,cont=0,target_dist=0;
	    if (fastest_route){
	    	mine=instance_nearest(x,y,obj_star);
	    	var star_travel = new FastestRouteAlgorithm(x,y,action_x,action_y, self.id,is_orbiting());
	    	var path =  star_travel.final_array_path();
	    	if (array_length(path)>1){
		    	var targ = star_by_name(path[1]);
		    	if (targ!="none"){
		    		array_delete(path,0,2);
		    		complex_route = path;
		    		action_x = targ.x;
					action_y = targ.y;
		    		set_fleet_movement(false, new_action);
		    	} else {
		    		set_fleet_movement(false, new_action);
		    	}
		    } else {
		    	set_fleet_movement(false, new_action);
		    }
	    } else {

		    var _target_sys = instance_nearest(action_x,action_y,obj_star);
		    var _target_is_sys = false;

		    if (instance_exists(_target_sys)){
		    	_target_is_sys = point_distance(_target_sys.x, _target_sys.y, action_x, action_y)<10;
		    }

		    mine=instance_nearest(x,y,obj_star);
	        
	        var eta = calculate_fleet_eta(x,y,action_x,action_y,action_spd,_target_is_sys,is_orbiting(),warp_able);
	        action_eta = eta;
	        if (action_eta<=0) or (owner  != eFACTION.Inquisition){
	            action_eta=eta;
	            if (owner  = eFACTION.Inquisition) and (action_eta<2) and (string_count("_her",trade_goods)=0) then action_eta=2;
	        }
	        
	        if (owner != eFACTION.Eldar && mine.storm) then action_eta+=10000;
	        
	        // action_x=sys.x;
	        // action_y=sys.y;
	        orbiting = false;
	        action=new_action;
	      	minimum_eta=1;
	        if (minimum_eta>action_eta) and (minimum_eta>0) then action_eta=minimum_eta;
		}
	}
}


//TODO build into unit struct
function load_unit_to_fleet(fleet, unit){
	var loaded = false;
	var all_ships = fleet_full_ship_array(fleet);

	for (var i=0;i<array_length(all_ships);i++){
		var ship_ident = all_ships[i];
		  if (obj_ini.ship_capacity[ship_ident]>obj_ini.ship_carrying[ship_ident]){
		  	obj_ini.ship_carrying[ship_ident]+=unit.size;
		  	unit.planet_location=0;
		  	obj_ini.loc[unit.company][unit.marine_number]=obj_ini.ship_location[ship_ident];
		  	unit.ship_location=ship_ident;
		  	loaded=true;
		  	break
		  }
	}
	return loaded;
}
function calculate_fleet_eta(xx,yy,xxx,yyy, fleet_speed,star1=true, star2=true,warp_able=false){
	var warp_lane = false;
	eta = 0;
		//Some duke unfinished webway stuff copied here for reference
		/*for (var w = 1;w<5;w++){
			if (planet_feature_bool(mine.p_feature[w], P_features.Webway)==1) then web1=1;
			if (planet_feature_bool(sys.p_feature[w], P_features.Webway)==1) then web2=1;
		}*/
	if (star1 && star2){
		star1 = instance_nearest(xx,yy, obj_star);
		star2 = instance_nearest(xxx,yyy, obj_star);
		warp_lane = determine_warp_join(star1.id,star2.id);
	} else if (star1){
		star1 = instance_nearest(xx,yy, obj_star);
	}
	eta=floor(point_distance(xx,yy,xxx,yyy)/fleet_speed)+1;
	if (!warp_lane) then eta*=2;
	if (warp_lane && warp_able) then eta = ceil(eta/warp_lane);
	if (!star2) then return eta;

	//check end location for warp storm
	if (instance_exists(star2)){
		if(star2.object_index == obj_star) {
			if (star2.storm){
				eta += 10000;
			}
		}

	}
	return eta;
}


function calculate_action_speed(fleet = "none", selected = false) {
	try {
		if (fleet == "none") {
			var capitals = 0, frigates = 0, escorts = 0, i;
			var _is_player_fleet = object_index == obj_p_fleet;
			if (_is_player_fleet) {
				if (!selected) {
					player_fleet_ship_count();
					capitals = capital_number;
					frigates = frigate_number;
					escorts = escort_number;
				} else {
					//TODO extract to a fleet selected function
					var types = selected_ship_types();
					capitals = types[0];
					frigates = types[1];
					escorts = types[2];
				}
			}
			var fleet_speed = 128;
			if (capitals > 0) {
				fleet_speed = 100;
			} else if (frigates > 0) {
				fleet_speed = 128;
			} else if (escorts > 0) {
				fleet_speed = 174;
			}
			if (_is_player_fleet) {
				if ((obj_controller.stc_ships >= 6) && (fleet_speed >= 100)) {
					fleet_speed *= 1.2;
				}
			}
			return fleet_speed;
		} else {
			with (fleet) {
				return calculate_action_speed(, selected);
			}
		}
	} catch (_exception) {
		handle_exception(_exception);
		return 200;
	}
}


function scr_efleet_arrive_at_trade_loc(){
	var chase_fleet =false;
	var arrive_at_player_fleet = (instance_exists(target));
    if (arrive_at_player_fleet){
    	arrive_at_player_fleet = target.object_index == obj_p_fleet;
    	if (arrive_at_player_fleet){
    		var chase_fleet = (target.action!="" || point_distance(x,y,target.x,target.y)>40) && obj_ini.fleet_type != ePlayerBase.home_world;
    	}
    } else {
    	arrive_at_player_fleet=false;
    	target=noone;
    }
    if (arrive_at_player_fleet && chase_fleet) {


        var mah_x=instance_nearest(x,y,obj_star).x;
        var mah_y=instance_nearest(x,y,obj_star).y;
        
        if  (string_count("Inqis",trade_goods)=0){

            
           
            if (target.action!="") {
				action_x=target.action_x;
				action_y=target.action_y;
			}
			else if (target.action=="" ){
                action_x=instance_nearest(target.x,target.y,obj_star).x;
                action_y=instance_nearest(target.x,target.y,obj_star).y;
            }
            action="";
            set_fleet_movement();
            if (owner!=eFACTION.Eldar) then obj_controller.disposition[owner]-=1;

        }
    }

  
        
    else if (arrive_at_player_fleet || obj_ini.fleet_type=ePlayerBase.home_world){
        
        var targ;
        var cur_star=nearest_star_proper(x, y);
        var bleh="";
        if (owner!=eFACTION.Inquisition) 
			bleh=$"{obj_controller.faction[owner]} Fleet finalizes trade at {cur_star.name}.";
        else{
			bleh=$"Inquisitor Ship finalizes trade at {cur_star.name}.";
        }
        log_message(bleh);
        scr_alert("green","trade",bleh,cur_star.x,cur_star.y);
        scr_event_log("",bleh,cur_star.name);
        
        // Drop off here
        if (trade_goods!="stuff") and (trade_goods!="none") then scr_trade_dep();
        
        trade_goods="return";
        if (target!=noone) then target=noone;
        
        if (owner==eFACTION.Eldar){
        	cur_star = nearest_star_with_ownership(xx,yy, eFACTION.Eldar);
        	if (cur_star!="none"){
				cur_star=targ.x;
				cur_star=targ.y;  
        	}                  	
        } else {
            action_x=home_x;
			action_y=home_y;                   	
        }
        
        action_eta=0;
		action="";

        set_fleet_movement();
        if (action_eta==0){
        	instance_destroy();
        }
    }
}
function scr_orbiting_fleet(faction, system="none"){
	var _found_fleet = "none";
	var _faction_list = is_array(faction);
	var xx = system == "none" ? x : system.x;
	var yy = system == "none" ? y : system.y;
	with (obj_en_fleet){
		if (x==xx && y==yy){
			var _valid = false;
			if (_faction_list){
				_valid = array_contains(faction, owner);
			} else {
				if (owner == faction){
					_valid = true;
				}
			}
			if (_valid && action == ""){
				_found_fleet = id;
			}					
		}
	}
	return _found_fleet;	
}

function get_orbiting_fleets(faction,system="none"){
	var _fleets = [];
	var _faction_list = is_array(faction);
	var xx = system == "none" ? x : system.x;
	var yy = system == "none" ? y : system.y;
	with (obj_en_fleet){
		if (x=xx && y==yy){
			var _valid = false;
			if (_faction_list){
				_valid = array_contains(faction, owner);
			} else {
				if (owner == faction){
					_valid = true;
				}
			}
			if (_valid && action == ""){
				array_push(_fleets, id);
			}					
		}
	}
	return _fleets;	
}

function sector_imperial_fleet_strength(){
	obj_controller.imp_ships = 0;
    var _imperial_planet_count = 0;
    var _mech_worlds = 0;
    with(obj_en_fleet){
        if (owner==eFACTION.Imperium){
            var _imperial_fleet_defence_score = capital_number + (frigate_number/2) + (escort_number/4);
            obj_controller.imp_ships += _imperial_fleet_defence_score;
        }
    }
    with(obj_star){
        for (var i=0;i<=planets;i++){
            var _owner_imperial = (p_owner[i] < 5 && p_owner[i] > 1);
            _imperial_planet_count += _owner_imperial;
        }
        if (owner == eFACTION.Mechanicus){
            _mech_worlds++;
        }
    }
    max_fleet_strength = (_imperial_planet_count/8)*(_mech_worlds*3);
}
function fleet_star_draw_offsets(){
	var coords = [0,0];	
	switch(owner){
		case eFACTION.Imperium:
			if (!navy){
				coords = [0,-24];//
			} else {
				coords = [0,24];
			}
			break;
		case eFACTION.Mechanicus:
			coords = [0,-32];//
			break;
		case eFACTION.Inquisition:
			coords = [0,-32];//	
			break;
		case eFACTION.Eldar:
			coords = [-24,-24];//	
			break;
		case eFACTION.Ork:
			coords = [30,0];//	
			break;
		case eFACTION.Tau:
			coords = [-24,-24];//	
			break;
		case eFACTION.Tyranids:	
			coords = [0,32];//	
			break;
		case eFACTION.Chaos:
			coords = [-30,0];//	
			break;
		case eFACTION.Necrons:
			coords = [32,32];//	
			break;									
	}
	return coords;
}
//TODO further split this shite up
function fleet_arrival_logic(){
	var cur_star, sta, steh_dist, old_x, old_y;
    cur_star=instance_nearest(action_x,action_y,obj_star);
    x = cur_star.x;
    y = cur_star.y;
    sta=instance_nearest(action_x,action_y,obj_star);
    
    // cur_star.present_fleets+=1;if (owner = eFACTION.Tau) then cur_star.tau_fleets+=1;
    
    
    if (owner == eFACTION.Mechanicus){
        if (string_count("spelunk1",trade_goods)=1){
            trade_goods="mars_spelunk2";
            action_x=home_x;
            action_y=home_y;
            action_eta=52;
            exit;
        }
        if (string_count("spelunk2",trade_goods)=1){
            // Unload techmarines nao plz
            scr_mission_reward("mars_spelunk",instance_nearest(home_x,home_y,obj_star),1);
            instance_destroy();
        }
    }
    
    
    //TODO create oppertunity to purge new colonisers if they have taint and the player has garrisons or control of the planet
    if (fleet_has_cargo("colonize")){
		deploy_colonisers(cur_star);
    }
    
    
    
    
    if (trade_goods="return"){
        // with(instance_nearest(x,y,obj_star)){present_fleets-=1;}
        instance_destroy();
    }
    
    
    
    
    
    if (trade_goods="female_her") or (trade_goods="male_her"){
        // if (owner  = eFACTION.Inquisition) then show_message("A");
        
        var next=0;
        if (!instance_exists(obj_p_fleet)) then next=1;
        if (instance_exists(obj_p_fleet)){
            with(obj_p_fleet){if (action!="") then instance_deactivate_object(id);}
            var pfa;pfa=instance_nearest(x,y,obj_p_fleet);
            if (point_distance(x,y,pfa.x,pfa.y)<40) then next=2;
            if (point_distance(x,y,pfa.x,pfa.y)>=40) then next=1;
        }
        instance_activate_object(obj_p_fleet);
        if (next=1){
            action_x=choose(room_width*-1,room_width*2);
            action_y=choose(room_height*-1,room_height*2);
            action_spd=256;
            action="";            
            set_fleet_movement();
            trade_goods="|DELETE|";
            obj_controller.disposition[4]-=15;
            scr_popup("Inquisitor Mission Failed","The radical Inquisitor has departed from the planned intercept coordinates.  They will now be nearly impossible to track- the mission is a failure.","inquisition","");
            scr_event_log("red","Inquisition Mission Failed: The radical Inquisitor has departed from the planned intercept coordinates.");
        }
        if (next=2){
            action="";
            var tixt,gender;
            if (trade_goods="male_her") then gender="he";if (trade_goods="female_her") then gender="she";
            tixt="You have located the radical Inquisitor.  As you prepare to destroy their ship, and complete the mission, you recieve a hail- it appears as though "+string(gender)+" wishes to speak.";
            if (trade_goods="male_her") then scr_popup("Inquisitor Located",tixt,"inquisition","1");
            if (trade_goods="female_her") then scr_popup("Inquisitor Located",tixt,"inquisition","2");
        }
        instance_deactivate_object(id);
        instance_deactivate_object(id);
        exit;
    }
    
    
    
    
    
    
    if (!navy){
	    if (trade_goods=="merge"){
	    	if (is_orbiting()){
	    		var _orbit = orbiting;
	    		var _viable_merge = false;
	    		var _merge_fleet = false;
	    		var _imperial_fleets = get_orbiting_fleets(eFACTION.Imperium, _orbit);
	    		for (var i=0;i<array_length(_imperial_fleets);i++){
	    			var _fleet = _imperial_fleets[i];
	    			if (!_fleet.navy && _fleet.id != id){
	    				_viable_merge = true;
	    				_merge_fleet = _fleet;
	    				break;
	    			}
	    		}
	    		if (_viable_merge){
	    			merge_fleets(_merge_fleet.id, id);
	    			exit;
	    		} else {
	    			trade_goods = "";
	    		}
	    	}

	    }    	

		var cancel=false;
        if (string_count("Inqis",trade_goods)>0) then cancel=true;
        if (string_count("merge",trade_goods)>0) then cancel=true;
        if (trade_goods="cancel_inspection") then cancel=true;
        if (trade_goods="|DELETE|") then cancel=true;
        if (trade_goods="return") then cancel=true;
        if (string_count("_her",trade_goods)>0) then cancel=true;
        if (string_count("investigate_dead",trade_goods)>0) then cancel=true;
        if (string_count("spelunk",trade_goods)>0) then cancel=true;
        if (string_count("BLOOD",trade_goods)>0) then cancel=true;
        if (fleet_has_cargo("ork_warboss")) cancel=true;
        if (trade_goods="csm") then cancel=true;

        if (!cancel && trade_goods!="" && trade_goods!="return" && owner!=eFACTION.Tyranids && owner!=eFACTION.Chaos){
        	scr_efleet_arrive_at_trade_loc();
        }    
    }
    

    if (owner==eFACTION.Inquisition) and (string_count("_her",trade_goods)=0){
        if (cur_star.owner  == eFACTION.Player) and (trade_goods="cancel_inspection"){
            instance_deactivate_object(cur_star);
            repeat(choose(1,2)){
                orbiting=instance_nearest(x,y,obj_star);
                instance_deactivate_object(orbiting);
            }
            
            repeat(5){
                orbiting=instance_nearest(x,y,obj_star);
                if (orbiting.owner = eFACTION.Eldar) then instance_deactivate_object(orbiting);
            }
            
            orbiting=instance_nearest(x,y,obj_star);
            action_x=orbiting.x;
            action_y=orbiting.y;
            alarm[4]=1;
            instance_activate_object(obj_star);
            trade_goods+="|DELETE|";
            exit;
        }
    }
    
    
    /*if (owner = eFACTION.Imperium) and (guardsmen>0){// 135 ; guardsmen onto planet
        var en_p,en_planets,land,i;
        i=0;en_planets=0;land=0;
        
        if (sta.x=home_x) and (sta.y=home_y){
            repeat(4){i+=1;
                en_p[i]=0;
                if (sta.p_owner[i]<=5){en_p[i]=1;en_planets+=1;}
            }
            
            if (guardsmen>0) and (en_planets>0){
                land=floor(guardsmen/en_planets);
                i=0;
                repeat(4){i+=1;
                    if (en_p[i]=1){guardsmen-=land;sta.p_guardsmen[i]+=land;}
                }
                if (guardsmen<5) then guardsmen=0;
            }
        }
        if (sta.owner>5) or ((sta.owner  = eFACTION.Player) and (obj_controller.faction_status[eFACTION.Imperium]="War")){
            repeat(4){i+=1;
                en_p[i]=0;
                if (sta.p_player[i]>0) and (obj_controller.faction_status[eFACTION.Imperium]="War"){en_p[i]=1;en_planets+=1;}
            }
            
            if (guardsmen>0) and (en_planets>0){
                land=floor(guardsmen/en_planets);
                i=0;
                repeat(4){i+=1;
                    if (en_p[i]=1){guardsmen-=land;sta.p_guardsmen[i]+=land;}
                }
                if (guardsmen<5) then guardsmen=0;
            }
        }
    }*/
    
    
    
    
    action="";

    if (owner= eFACTION.Inquisition){

        if (string_count("DELETE",trade_goods)>0) then instance_destroy();
        if (obj_controller.known[eFACTION.Inquisition]=0) then obj_controller.known[eFACTION.Inquisition]=1;
    }

    else if (owner=eFACTION.Tau) {

        if (instance_exists(obj_p_ship)){
            var p_ship=instance_nearest(x,y,obj_p_ship);
            if (p_ship.action="") and (point_distance(x,y,p_ship.x,p_ship.y)<80){
                if (obj_controller.p_known[8]=0) then obj_controller.p_known[8]=1;
            }
        }
    }
    else if (owner=eFACTION.Tyranids){

        var mess=1,plap=instance_nearest(action_x,action_y,obj_p_fleet);
        
        if (instance_exists(plap)){
        	if (point_distance(plap.x,plap.y,action_x,action_y)<80) then mess=0;
        }
        
        if (mess=1) and (sta.vision!=0){
            scr_alert("red","owner",$"Contact has been lost with {sta.name}!",sta.x,sta.y);
            scr_event_log("red",$"Contact has been lost with {sta.name}.");sta.vision=0;}
    }
    action_x=0;
    action_y=0;
    
    
    
    
    
    
    // 135 ; fleet chase
    if (string_count("Inqis",trade_goods)>0) and (string_count("fleet",trade_goods)>0) and (!string_count("_her",trade_goods)) {
        inquisition_fleet_inspection_chase();
    }


    old_x=x;old_y=y;
    x=-100;y=-100;
    
    cur_star=instance_nearest(old_x,old_y,obj_en_fleet);
    var mergus=false;
    
    mergus=cur_star.image_index;
    if (mergus<3) then mergus=0;
    if (mergus>=3) then mergus=10;
    if (owner = eFACTION.Tau) and (mergus>=3) then mergus=0;
    if (string_count("_her",trade_goods)=0) then mergus=99;// was 999
    
    // Think this might be causing the crash
    if (owner=eFACTION.Tau) and (sta.present_fleet[eFACTION.Imperium]+sta.present_fleet[eFACTION.Player]>=1) 
		and (sta.present_fleet[eFACTION.Tau]=1) and (image_index=1) and (ret=0) then mergus=15;
    if (cur_star.owner=eFACTION.Tau) and (owner=eFACTION.Tau) and (ret=1) then mergus=0;
    
    
    
    
    if (owner=eFACTION.Tau) and (image_index=1){
        // show_message("Tau|||  Other Owner: "+string(cur_star.owner)+"   ret: "+string(ret)+"    mergus: "+string(mergus));
    }
    
    if (owner=eFACTION.Chaos) and (trade_goods="csm") or (trade_goods="Khorne_warband") then mergus=0;
    // if (cur_star.owner!=owner) then mergus=0;
    
    
    
    
    if (cur_star.x=old_x) and (cur_star.y=old_y) and (cur_star.owner=self.owner) and (cur_star.action="") and (mergus=1999){// Merge the fleets
        cur_star.escort_number+=self.escort_number;
        cur_star.frigate_number+=self.frigate_number;// show_message("Tau fleet merging");
        cur_star.capital_number+=self.capital_number;
        cur_star.guardsmen+=self.guardsmen;
        
        
        
        cur_star=instance_nearest(old_x,old_y,obj_star);
        // if (cur_star.present_fleets>=1) then cur_star.present_fleets-=1;
        if (owner = eFACTION.Tau){obj_controller.tau_fleets-=1;cur_star.tau_fleets-=1;}
        if (owner = eFACTION.Chaos) then obj_controller.chaos_fleets-=1;
        
        instance_destroy();
    }// End merge fleets
    
    
    
    if (owner=eFACTION.Tau) and (mergus=15){                                               // Get the fuck out
        var new_star, stue;new_star=0;stue=0;ret=1;
        
        
        instance_activate_object(obj_star);// new_star
        stue=instance_nearest(x,y,obj_star);
        
        
        
        if (image_index=1){// Start influence thing
            var  tau_influence;
            var tau_influence_chance=irandom(100)+1;
            var tau_influence_planet=irandom(stue.planets)+1;
            
            with (stue){
                if (p_type[tau_influence_planet]!="Dead"){
                
                    scr_alert("green","owner",$"Tau ship broadcasts subversive messages to {planet_numeral_name(tau_influence_planet)}.",sta.x,sta.y);
                    tau_influence = p_influence[tau_influence_planet][eFACTION.Tau]
                
                    if (tau_influence_chance<=70) and (tau_influence<70){
                    	adjust_influence[tau_influence_planet](eFACTION.Tau, 10, tau_influence_planet);
                        if (p_type[tau_influence_planet]=="Forge") then adjust_influence(eFACTION.Tau, -5, tau_influence_planet);
                    }
                    
                    if (tau_influence_chance<=3) and (tau_influence<70){
                        adjust_influence(eFACTION.Tau, 30, tau_influence_planet);
                        if (p_type[tau_influence_planet]=="Forge") then adjust_influence(eFACTION.Tau, -25, tau_influence_planet);
                    }
                }
            }
        } 
        
        
        
        instance_deactivate_object(stue);
        
        with(obj_star){
        	if (owner != eFACTION.Tau) then instance_deactivate_object(instance_id);
        }
        
        var good;good=0;
        
        repeat(100){
            var xx, yy;
            if (good=0){
                xx=x+choose(random(300),random(300)*-1);
                yy=y+choose(random(300),random(300)*-1);
                new_star=instance_nearest(xx,yy,obj_star);
                if (new_star.owner!=eFACTION.Tau) then with(new_star){instance_deactivate_object(id);}
                if (new_star.owner=eFACTION.Tau) then good=1;
            }
        }
        
        // show_message("Get the fuck out working?: "+string(good));
        
        if (new_star.owner=eFACTION.Tau){
            // show_message("Tau fleet actually fleeing");
            action="";action_x=new_star.x;action_y=new_star.y;alarm[4]=1;
        }
        
        instance_activate_object(obj_star);
        // This appears bugged
    }
    
    
    
    
    
    
    x=old_x;
    y=old_y;
    
    if (cur_star.x=old_x) and (cur_star.y=old_y) and (cur_star.owner=self.owner) and (cur_star.action="") and ((owner = eFACTION.Tau) or (owner = eFACTION.Chaos)) and (mergus=10) and (trade_goods!="csm") and (trade_goods!="Khorne_warband"){// Move somewhere new
        var stue, stue2;stue=0;stue2=0;
        var goood=0;
        
        with(obj_star){if (planets=1) and (p_type[1]="Dead") then instance_deactivate_object(id);}
        stue=instance_nearest(x,y,obj_star);
        instance_deactivate_object(stue);
        repeat(10){
            if (goood=0){
                stue2=instance_nearest(x+choose(random(400),random(400)*-1),y+choose(random(400),random(400)*-1),obj_star);
                if (owner = eFACTION.Tau) and (stue2.owner = eFACTION.Tau) then goood=1;
                if (owner = eFACTION.Chaos) and (stue2.owner != eFACTION.Chaos) then goood=1;
                if (stue2.planets=0) then goood=0;
                if (stue.present_fleet[eFACTION.Imperium]>0) or (stue.present_fleet[eFACTION.Player]>0) then goood=0;
                if (stue2.planets=1) and (stue2.p_type[1]="Dead") then goood=0;
                }
            }
        action_x=stue2.x;
        action_y=stue2.y;
        alarm[4]=1;// stue.present_fleets-=1;
        instance_activate_object(obj_star);
    }
    
    
    // ORKS
    // Right here check to see if the fleet is being useless
    // If yes check for connected planet, see if not owned by orks
    // If not owned by orks then start heading that way
    // If the connected planet is owned by orks then choose a random one within 400 not owned by orks
    
    
    if (owner = eFACTION.Ork){
    	if (is_orbiting()){
    		with (orbiting){
    			ork_fleet_arrive_target();
    		}
    	}
        var kay, temp5, temp6, temp7;
        kay=0;temp5=0;temp6=0;temp7=0;

		var cur_star=instance_nearest(x,y,obj_star);
    
        
        // This is the new check to go along code; if doesn't add up to all planets = 7 then they exit
        if (!is_dead_star(cur_star)) then kay=5;
        
        if (kay=5){// KILL the enemy
            if (cur_star.present_fleet[1]>1) or (cur_star.present_fleet[2]>1) then exit;
        }
        
        if ((cur_star.owner = eFACTION.Chaos) and (image_index>=5) and (owner = eFACTION.Chaos)) or ((owner = eFACTION.Chaos) and (image_index>=5) and (cur_star.planets=0)) then kay=50;

        if (kay=50){
        
            if (owner = eFACTION.Ork) then with(obj_star){if (owner = eFACTION.Ork) then instance_deactivate_object(instance_id);}
        
            repeat(20){
                if (kay=50){
                    temp5=x+choose(random(300),random(300)*-1);temp6=y+choose(random(300),random(300)*-1);
                    temp7=instance_nearest(temp5,temp6,obj_star);
                    
                    if (owner = eFACTION.Ork) and (temp7.owner != eFACTION.Ork) and (temp7.planets>0) and (temp7.image_alpha>=1) then kay=55;
                    if (owner = eFACTION.Tau) and (temp7.owner != eFACTION.Tau) and (temp7.planets>0) and (temp7.image_alpha>=1) then kay=55;
                    if (owner = eFACTION.Chaos) and (temp7.owner != eFACTION.Chaos) and (temp7.planets>0) and (temp7.image_alpha>=1) then kay=55;
                }
            }
        
            if (kay=55) and (instance_exists(temp7)){
                action_x=temp7.x;
                action_y=temp7.y;
                alarm[4]=1;
                
                // cur_star.present_fleets-=1;
            }
            
            instance_activate_object(obj_star);
        }
       

        instance_activate_object(obj_star);
 
    }


    exit;// end of eta=0	
}

function choose_fleet_sprite_image(){
    if (owner = eFACTION.Imperium && !fleet_has_cargo("colonize")){
    	sprite_index=spr_fleet_imperial;
    }
    else if (owner = eFACTION.Imperium && fleet_has_cargo("colonize")){
    	sprite_index=spr_fleet_civilian;
    }
    else if (owner == eFACTION.Mechanicus) { sprite_index=spr_fleet_mechanicus;}
    else if (owner  == eFACTION.Inquisition) && (string_count("_fleet",trade_goods)>0) and (target>0){
        target=instance_nearest(target_x,target_y,obj_p_fleet);
    }
    else if (owner  == eFACTION.Inquisition) { sprite_index=spr_fleet_inquisition;}
    else if (owner == eFACTION.Eldar) { sprite_index=spr_fleet_eldar;}
    else if (owner == eFACTION.Ork) { sprite_index=spr_fleet_ork;}
    else if (owner == eFACTION.Tau) { sprite_index=spr_fleet_tau;}
    else if (owner == eFACTION.Tyranids) { sprite_index=spr_fleet_tyranid;}
    else if (owner == eFACTION.Chaos) { sprite_index=spr_fleet_chaos;}
    image_speed=0;	
}



function merge_fleets(main_fleet, merge_fleet){
	main_fleet.capital_number += merge_fleet.capital_number;
	main_fleet.frigate_number += merge_fleet.frigate_number;
	main_fleet.escort_number += merge_fleet.escort_number;
	var _merge_cargo = struct_get_names(merge_fleet.cargo_data);
	//TODO custom merge stuff
	for (var i=0;i<array_length(_merge_cargo);i++){
		if (!struct_exists(main_fleet.cargo_data, _merge_cargo[i])){
			main_fleet.cargo_data[$ _merge_cargo[i]] = merge_fleet.cargo_data[$ _merge_cargo[i]];
		}
	}
	instance_destroy(merge_fleet.id);
}

function fleet_respond_crusade(){
	if (owner != eFACTION.Imperium) then exit;
	if (!navy) then exit;
	if (orbiting.owner > eFACTION.Ecclesiarchy) then exit;
	if (trade_goods!="") then exit;
	if (action!="") then exit;
	if (guardsmen_unloaded>0) then exit;

	// Crusade AI
    obj_controller.temp[88]=owner;
    with(obj_crusade){
		if (owner!=obj_controller.temp[88]){
			y-=20000;
		}
	}

	var enemu;
	//var cs
    with(obj_star) {
		var cs = instance_nearest(x,y,obj_crusade);
		
        if (point_distance(x,y,cs.x,cs.y)>cs.radius) {
			y-=20000;
		}
		enemu=0;
		
		var nids = array_reduce(p_tyranids, function(prev, curr) {
			return prev || curr > 3
		}, false);

		var tau = array_reduce(p_tau, function(prev, curr) {
			return prev || curr > 0;
		}, false);

		
		enemu += nids + tau

        if (present_fleet[eFACTION.Eldar]>0)	then enemu+=2;
		if (present_fleet[eFACTION.Ork]>0)		then enemu+=2;
        if (present_fleet[eFACTION.Tau]>0)		then enemu+=2;
		if (present_fleet[eFACTION.Tyranids]>0) then enemu+=2;
        if (present_fleet[eFACTION.Chaos]>0)	then enemu+=2;
		//nothing for heritics faction
		if (present_fleet[eFACTION.Necrons]>0)	then enemu+=2;

    }
	var ns = instance_nearest(x,y,obj_star);
	var ok=false;
	var max_dist = 800;
	var min_dist = 40;
	var to_ignore = [eFACTION.Imperium, eFACTION.Mechanicus,eFACTION.Inquisition, eFACTION.Ecclesiarchy];
	
	var dist = point_distance(x,y,ns.x,ns.y)
	var valid_target = !array_contains_ext(ns.p_owner, to_ignore, false)
    if valid_target and dist <= max_dist and dist >= min_dist and (owner = eFACTION.Imperium) 
		then ok = true;

    // if ((ns.owner>5) or (ns.owner  = eFACTION.Player)) and (point_distance(x,y,ns.x,ns.y)<=max_dis) and (point_distance(x,y,ns.x,ns.y)>40) and (owner = eFACTION.Imperium){
    if (ok){
        action_x=ns.x;
		action_y=ns.y;
		alarm[4]=1;
        orbiting.present_fleet[owner]-=1;
        home_x=orbiting.x;
        home_y=orbiting.y;
		
        var i;
		i=0;
        repeat(orbiting.planets){
			i+=1;
            if (orbiting.p_owner[i]=eFACTION.Imperium) and (orbiting.p_guardsmen[i]>500) {
				guardsmen +=round(orbiting.p_guardsmen[i]/2);
				orbiting.p_guardsmen[i]=round(orbiting.p_guardsmen[i]/2);}
        }

        alarm[5]=2;
        
        with(obj_crusade){if (y<-10000) then y+=20000;}
        with(obj_crusade){if (y<-10000) then y+=20000;}
        with(obj_star){if (y<-10000) then y+=20000;}
        with(obj_star){if (y<-10000) then y+=20000;}
        
        exit;
    }
    
    with(obj_crusade){if (y<-10000) then y+=20000;}
    with(obj_crusade){if (y<-10000) then y+=20000;}
    with(obj_star){if (y<-10000) then y+=20000;}
    with(obj_star){if (y<-10000) then y+=20000;}
}
