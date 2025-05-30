function find_nearest_edge_coords(x, y){
	var edge_coords = [0,0];
	var left_distance = x;
	var right_distance = room_width-x;
	var top_distance = y;
	var bottom_distance = room_height-y;
	var small_dist = min(left_distance,right_distance,top_distance,bottom_distance);
	switch(small_dist){
		case left_distance:
			edge_coords = [0,y];
			break;
		case right_distance:
			edge_coords = [room_width,y];
			break;
		case top_distance:
			edge_coords = [x,0];
			break;
		case bottom_distance:
			edge_coords = [x,room_height];
			break;									
	}

	return edge_coords;
}

function plus_or_minus_rand(figure, variation){
	return figure+(irandom(variation)*choose(-1,1));
}

function plus_or_minus_clamp(figure, variation, bottom,top){
	return clamp(plus_or_minus_rand(figure, variation), bottom,top);
}

function tyranid_fleet_planet_action(){

    var is_dead=false;
    with (orbiting){
    	is_dead = is_dead_star();
        if (!is_dead) {  		
            for (var i=1;i<=planets;i++){
            	if (planet_feature_bool(p_feature[i], P_features.Gene_Stealer_Cult)){
            		if (p_influence[i][eFACTION.Tyranids]>50){
            			var alert = $"The Genestealer Cult on {planet_numeral_name(i)} is exceedingly thorough, there is almost no resistance as the swarm descends and what little resistance remains is quickly quelled by infiltrators, most of the populations willingly offer themselves to their new gods jumping into acid vats to form biomass for their newly arrived gods or otherwise allowing themselves to be devoured by the teaming ripper swarms";
            			scr_popup("Tyranids",alert,"","");
            			p_pdf[i] = 0;
            			scr_alert("red","owner",$"Tyranid swarms begin the process of stripping {planet_numeral_name(i)} for biomass",x,y);
            		} else {
            			scr_alert("red","owner",$"The pdf of {planet_numeral_name(i)} is badly degraded by genestealer cult forces as the hive fleet decends",x,y);
            			scr_popup("Tyranids",scr_alert,"","");
            			p_pdf[i]*=(p_influence[i][eFACTION.Tyranids]/100);
            		}
            		delete_features(p_feature[i],  P_features.Gene_Stealer_Cult);
            	}
            }
        }   	
    }
    organise_tyranid_fleet_bio();	
}

function summon_new_hive_fleet(capitals = 5,frigates = 0, escorts = 0, biomass = 1000){
	var start_coords = find_nearest_edge_coords(x,y);

	if (start_coords[0] != 0 && start_coords[0]!= room_width){
		start_coords[0] = plus_or_minus_clamp(start_coords[0], 200, 0, room_width);
	} else {
		if (start_coords[0]==0){
			start_coords[0]+=100
		} else {
			start_coords[0]-=100
		}		
	}
	if (start_coords[1] != 0 && start_coords[1]!= room_height){
		start_coords[1] = plus_or_minus_clamp(start_coords[1], 200, 0, room_height);
	} else {
		if (start_coords[1]==0){
			start_coords[1]+=100
		} else {
			start_coords[1]-=100
		}
	}

	var _fleet=new_tyranid_fleet(start_coords[0],start_coords[1], capitals, frigates, escorts, biomass);
	_fleet.action_x = x;
	_fleet.action_y = y;
	with(_fleet){
    	set_fleet_movement();
	}

    return _fleet
}

function hive_fleet_arrives_from_out_of_system(){
    if (has_problem_planet_and_time(i,"Hive Fleet", 3)>-1){
        var _chief_lib=scr_role_count("Chief "+string(obj_ini.role[100,17]),,"units");
        var _has_chief_lib = array_length(_chief_lib);
        if (_has_chief_lib){
        	_chief_lib = _chief_lib[0];
        }
    
        var _master_psy = false;

        var _intolerant = scr_has_disadv("Psyker Intolerant");
        
        if (obj_controller.known[eFACTION.Tyranids]=0 && _has_chief_lib && !_intolerant){
            scr_popup("Shadow in the Warp",$"Chief {_chief_lib.name_role()} reports a disturbance in the warp.  He claims it is like a shadow.","shadow","");
            scr_event_log("red",$"Chief {_chief_lib.name_role()} reports a disturbance in the warp.  He claims it is like a shadow.");
        }
        if (!obj_controller.known[eFACTION.Tyranids] && !_has_chief_lib  && !_intolerant){
            var q=0,q2=0;
            repeat(90){
                if (q2=0){
                	q+=1;
                    if (obj_ini.role[0,q]==obj_ini.role[100][eROLE.ChapterMaster]){q2=q;
                        if (string_count("0",obj_ini.spe[0,q2])>0) then _master_psy=true;
                    }
                }
            }
            if (_master_psy=true){
                scr_popup("Shadow in the Warp","You are distracted and bothered by a nagging sensation in the warp.  It feels as though a shadow descends upon your sector.","shadow","");
                scr_event_log("red","You sense a disturbance in the warp.  It feels something like a massive shadow.");
            }
        }
    
        g=50;
        i=50;
        obj_controller.known[eFACTION.Tyranids]=1;
    }	
}

function new_tyranid_fleet(xx, yy, capitals = 5,frigates = 0, escorts = 0, fleet_biomass = 1000){
	var _fleet = instance_create(xx, yy,obj_en_fleet);
	var _mass = fleet_biomass
	with (_fleet){
	    owner = eFACTION.Tyranids;
	    sprite_index = spr_fleet_tyranid;
	    image_index = 1;
	    capital_number = capitals;
	    frigate_number = frigates;
	    escort_number = escorts;
	    action = "";    	
    	action_spd = 10;
    	biomass = _mass;
    	warp_able = false;
	}
	return _fleet;
}

function star_biomass_value(star, fleet=false){
	var _bio_val = 0;
	if (is_dead_star(star)){
		_bio_val = -1;
	} else {
		for (var i=0;i<array_length(star.planets);i++){
			if (p_large[i]){
				_bio_val += p_population[i];
			} else {
				if (p_type[i] == "Death" || p_type[i] == "Agri"){
					_bio_val++;
				}
			}
			var _cults = return_planet_features(p_features[i], P_features.Gene_Stealer_Cult)
			if (array_length(_cults)){
				var _cult = _cults[0];
				_bio_val++;
				_bio_val += (p_influence[i][eFACTION.Tyranids]/20);
			}
		}
		_bio_val*=20;
	}
	if (instance_exists(fleet)){
		var _travel_time = calculate_fleet_eta(x,y,visit_star.x,visit_star.y, fleet.ship_speed, true, true, fleet.warp_able);
	}
	bio_val -= _travel_timel;
	return bio_val;
}

function sort_planets_by_biomass_potential(){
    var _stars = scr_get_stars();
    var _star_count = array_length(_stars);

    var _bio_vals = {};
    for (var i = 0; i < _star_count; i++){
        var _star = _stars[i];
        _bio_vals[$ _star.name] = star_biomass_value(_star);
    }

    for (var i = 0; i < _star_count; i++){
        var _swaps = false;
        for (var s = 0; s < _star_count - 1; s++){
            var _star = _stars[s];
            var _star2 = _stars[s + 1];
            var _bio = _bio_vals[$ _star.name];
            var _bio2 = _bio_vals[$ _star2.name];
            if (_bio2 > _bio){
                var _temp = _star;
                _stars[s] = _star2;
                _stars[s + 1] = _temp;
                _swaps = true;
            }
        }
        if (!_swaps){
            break;
        }
    }

    return [_stars, _bio_vals];
}

function split_off_new_nid_splinter(){
	var _systems = sort_planets_by_biomass_potential();
	var _bio = _systems[1];
	_systems = _systems[0];
	var _target = _systems[irandom(2)];
	var _new_fleet = new_tyranid_fleet(x, y, 4,0,0,100);
	biomass -= 500;
                        
	_new_fleet.action_x=_target.x;
	_new_fleet.action_y=_target.y;
	with (new_fleet){
		set_fleet_movement();
	}

}

function organise_tyranid_fleet_bio(){
	if (capital_number < 5 && biomass > 300){
		capital_number++;
		biomass -= 100;
	}
	if (capital_number*2>frigate_number){
        capital_number-=1;
        frigate_number+=2;
    }
    
    if (capital_number*4>escort_number){
        var rand=choose(1,2,3,4);
        if (rand=4) then escort_number+=1;
    }
    
    
    
    if (capital_number>0){
        var capitals_engaged=0;
        var caps = capital_number;
        var _planets = [];
        for (var i=1;i<=array_length(orbiting.planets);i++){
        	array_push(_planets, i);
        }
        _planets = array_shuffle(_planets);
        capitals_engaged = 0;
        for (var i=0;i<array_length(orbiting.planets);i++){
        	if (capitals_engaged >= capital_number){
        		break;
        	}
        	var _planet = _planets[i];
        	if (orbiting.p_tyranids[_planet] < 6 && biomass > 0){
        		var _all_except_nids = planet_all_forces(orbiting, _planet) - orbiting.p_tyranids[_planet];
        		if (orbiting.p_pdf[_planet] > 0 || orbiting.p_guardsmen[_planet] || _all_except_nids>0){
        			for (var n=0;orbiting.p_tyranids[_planet]<6 && biomass>9;n++){
        				orbiting.p_tyranids[_planet]++;
        				biomass -=10;
        			}
        			capitals_engaged++;
        		}
        	}
        	
        }        
    }
    
    

    var _is_dead=false;
    with (orbiting){
    	_is_dead = is_dead_star();
    }
    
    if (_is_dead){

        var xx=0,yy=0,good=0,plin=0,plin2=0;
        var _split_fleet = false;
        if (bio_mass > 1000){
        	_split_fleet=true;
        }

        if (split_fleet){
        	split_off_new_nid_splinter();
        }
    }
}


function set_nid_ships(){
	if (class=="Leviathan"){
	    sprite_index=spr_ship_leviathan;
	    ship_size=3;
	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=300;
	    maxshields=300;
	    leadership=100;
	    armour_front=7;
	    side_armour=5;
	    weapons=5;
	    turrets=3;
	    capacity=0;
	    carrying=0;
	    add_weapon_to_ship("Feeder Tendrils" , {
	    	dam : 12, 
	    	range :160
	    });
	    add_weapon_to_ship("Bio-Plasma Discharge" , {
	        dam : 10, 
	        range : 260,
	        cooldown : 10,
	        facing : "most",
	    });

	    add_weapon_to_ship("Pyro-Acid Battery" , {
	        dam : 18, 
	        range : 500,
	        cooldown : 40,
	        facing : "front",
	    });

	    add_weapon_to_ship("Launch Glands");

	}else 
	if (class=="Razorfiend"){
	    sprite_index=spr_ship_razorfiend;
	    ship_size=2;
	    name="";
	    hp=600;
	    maxhp=600;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    armour_front=5;
	    side_armour=4;
	    weapons=3;
	    turrets=2;
	    capacity=0;
	    carrying=0;

	    add_weapon_to_ship("Pyro-Acid Battery" , {dam : 12, facing : "front"});
	    add_weapon_to_ship("Feeder Tendrils");
	    add_weapon_to_ship("Massive Claws");

	}else 
	if (class=="Stalker"){
	    sprite_index=spr_ship_stalker;
	    ship_size=1;
	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=100;
	    armour_front=5;
	    side_armour=4;
	    weapons=1;
	    turrets=0;
	    capacity=0;
	    carrying=0;
	    add_weapon_to_ship("Pyro-acid Battery", {cooldown : 60});
	    add_weapon_to_ship("Feeder Tendrils", {cooldown : 20});
	    add_weapon_to_ship("Bio-Plasma Discharge");

	}else 
	if (class=="Prowler"){
	    sprite_index=spr_ship_prowler;
	    ship_size=1;
	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=100;
	    armour_front=5;
	    side_armour=4;
	    weapons=1;
	    turrets=0;
	    capacity=0;
	    carrying=0;
	    add_weapon_to_ship("Pyro-acid Battery");
	    add_weapon_to_ship("Feeder Tendrils");
	}

}