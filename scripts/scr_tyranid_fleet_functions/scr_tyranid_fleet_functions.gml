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
            for (var i=1;i<planets;i++){
            	if (planet_feature_bool(p_feature[i], P_features.Gene_Stealer_Cult)){
            		if (p_influence[i][eFACTION.Tyranids]>50){
            			var alert = $"The Genestealer Cult on {planet_numeral_name(i)} is exceedingly thorough, there is almost no resistance as the swarm descends and what little resistance remains is quickly quelled by infiltrators, most of the populations willingly offer themselves to their new gods jumping into acid vats to form biomass for their newly arrived gods or otherwise allowing themselves to be devoured by the teaming ripper swarms";
            			scr_popup("Tyranids",alert,"","");
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

function summon_new_hive_fleet(){
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

	fleet=instance_create(start_coords[0],start_coords[1],obj_en_fleet);
	fleet.action_x=x;
	fleet.action_y=y;
    with (fleet){
	    owner = eFACTION.Tyranids;
	    sprite_index=spr_fleet_tyranid;
	    image_index=1;
	    capital_number=5;
	    action="";    	
    	action_spd = 10;
    	set_fleet_movement();
    }
}

function star_biomass_value(star){
	var _bio_val = 0;
	for (var i=0;i<array_length(planets);i++){
		if (p_large[i]){
			_bio_val += _bio_val;
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
	return _bio_val;
}

function sort_planets_by_biomass_potential(){
	var _stars = scr_get_stars();
	var _star_count = array_length(_stars);

	var _bio_vals = {};
	for (var i=0;i<_star_count;i++){
		var _star = _stars[i];
		_bio_vals[$ _star.name] = star_biomass_value(star);
	}

	for (var i=0;i<_star_count;i++){
		var _swaps = false
		for (var s=0;s<_star_count;s++){
			var _star = _stars[s];
			var _star2 = _stars[s + 1];
			var _bio = _bio_vals[$ _star.name];
			var _bio2 = _bio_vals[$ _star2.name]
			if (_bio2>_bio){
				var _temp = _star;
				_stars[s] = _star2;
				_stars[s + 1] = _temp;
				_swaps = true;
			}
		}
		if (!true){
			break;
		}
	}
}

function organise_tyranid_fleet_bio(){
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
            with (orbiting){
            	for (var i=1;i<planets;i++){
            		if (capitals_engaged=caps) then break;
            		if (p_type[i]!="Dead"){
            			p_tyranids[4]=5;
            			capitals_engaged+=1;
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
            if (capital_number>5){
            	_split_fleet=true;
            }
            
            
            repeat(100){
                if (good!=5){
                    xx=self.x+random_range(-300,300);
                    yy=self.y+random_range(-300,300);
                    if (good=0) then plin=instance_nearest(xx,yy,obj_star);
                    if (good=1) and (_is_dead=5) then plin2=instance_nearest(xx,yy,obj_star);
                    
                    good = !array_contains(plin.p_type, "dead");

                    if (good=1) and (_is_dead=5){
                        if (!instance_exists(plin2)) then break;
                        if (!array_contains(plin.p_type, "dead")) then good++
                        
                        var new_fleet;
                        new_fleet=instance_create(x,y,obj_en_fleet);
                        new_fleet.capital_number=floor(capital_number*0.4);
                        new_fleet.frigate_number=floor(frigate_number*0.4);
                        new_fleet.escort_number=floor(escort_number*0.4);
                        
                        capital_number-=new_fleet.capital_number;
                        frigate_number-=new_fleet.frigate_number;
                        escort_number-=new_fleet.escort_number;
                        
                        new_fleet.owner=eFACTION.Tyranids;
                        new_fleet.sprite_index=spr_fleet_tyranid;
                        new_fleet.image_index=1;
                        
                        /*with(new_fleet){
                            var ii;ii=0;ii+=capital_number;ii+=round((frigate_number/2));ii+=round((escort_number/4));
                            if (ii<=1) then ii=1;image_index=ii;
                        }*/
                        
                        new_fleet.action_x=plin2.x;
                        new_fleet.action_y=plin2.y;
                       with (new_fleet){
					    	set_fleet_movement();
					    }
                        break;
                    }
                    
                    
                    if (good=1) and (instance_exists(plin)){action_x=plin.x;action_y=plin.y;alarm[4]=1;if (_is_dead!=5) then good=5;}
                }
            }
            instance_activate_object(obj_star);
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
	    armour_other=5;
	    weapons=5;
	    turrets=3;
	    capacity=0;
	    carrying=0;
	    add_weapon_to_ship("Feeder Tendrils" : {dam : 12, range :160});
	    add_weapon_to_ship("Bio-Plasma Discharge" : {
	        dam : 10, 
	        range : 260,
	        cooldown : 10,
	        facing : "most",
	    });

	    add_weapon_to_ship("Pyro-Acid Battery" : {
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
	    armour_other=4;
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
	    armour_other=4;
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
	    armour_other=4;
	    weapons=1;
	    turrets=0;
	    capacity=0;
	    carrying=0;
	    add_weapon_to_ship("Pyro-acid Battery");
	    add_weapon_to_ship("Feeder Tendrils");
	}

}