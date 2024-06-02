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
    fleet.owner = eFACTION.Tyranids;
    fleet.sprite_index=spr_fleet_tyranid;
    fleet.image_index=1;
    fleet.capital_number=5;
    fleet.action_x=x;
    fleet.action_y=y;
    fleet.action="";
    with (fleet){
    	set_fleet_movement();
    }
}



function nid_ship_weapons_set(weapon,slot){
	var weapons = {
		"Feeder Tendrils":{
			weapon_facing : "most",
			weapon_dam : 12,
			weapon_range : 160,
			weapon_cooldown : 30,
		},
		"Bio-Plasma Discharge":{
			weapon_facing : "most",
			weapon_dam : 10,
			weapon_range : 260,
			weapon_cooldown : 30,
		},
		"Pyro-Acid Battery":{
			weapon_facing : "front",
			weapon_dam : 18,
			weapon_range : 500,
			weapon_cooldown : 40,
		},
		"Launch Glands":{
			weapon_facing : "special",
			weapon_dam : 9999,
			weapon_range : 6,
			weapon_cooldown : 120,
		},						
	}
	if (struct_exists(weapons, weapon)){
		var wep_choice = weapons[$ weapon];
	    weapon[slot]=weapon;
	    weapon_facing[slot]=wep_choice.weapon_facing;
	    weapon_dam[slot]=wep_choice.weapon_dam;
	    weapon_range[slot]=wep_choice.weapon_range;
	    weapon_cooldown[slot]=wep_choice.weapon_cooldown;		
	}
}



function set_nid_ships(){
	if (class="Leviathan"){
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
	    nid_ship_weapons_set("Feeder Tendrils", 1);
	    nid_ship_weapons_set("Bio-Plasma Discharge", 2);
	    nid_ship_weapons_set("Pyro-Acid Battery", 3);
	    nid_ship_weapons_set("Launch Glands", 4);
	}

	else if (class="Razorfiend"){
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
	    turrets=2;capacity=0;carrying=0;
	    weapon[1]="Pyro-Acid Battery";
	    weapon_facing[1]="front";
	    weapon_dam[1]=12;
	    weapon_range[1]=300;
	    weapon_cooldown[1]=30;
	    weapon[2]="Feeder Tendrils";
	    weapon_facing[2]="most";
	    weapon_dam[2]=8;
	    weapon_range[2]=100;
	    weapon_cooldown[2]=30;
	    weapon[3]="Massive Claws";
	    weapon_facing[3]="most";
	    weapon_dam[3]=20;
	    weapon_range[3]=64;
	    weapon_cooldown[3]=60;
	}

	if (class="Stalker"){
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
	    turrets=0;capacity=0;carrying=0;
	    weapon[1]="Pyro-Acid Battery";
	    weapon_facing[1]="front";
	    weapon_dam[1]=8;
	    weapon_range[1]=300;
	    weapon_cooldown[1]=60;
	    weapon[2]="Feeder Tendrils";
	    weapon_facing[2]="most";
	    weapon_dam[2]=8;
	    weapon_range[2]=100;
	    weapon_cooldown[2]=30;
	    weapon[3]="Bio-Plasma Discharge";
	    weapon_facing[3]="front";
	    weapon_dam[3]=6;
	    weapon_range[3]=200;
	    weapon_cooldown[3]=60;
	}

	else if (class="Prowler"){
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
	    turrets=0;capacity=0;carrying=0;
	    weapon[1]="Pyro-acid Battery";
	    weapon_facing[1]="most";
	    weapon_dam[1]=8;
	    weapon_range[1]=300;
	    weapon_cooldown[1]=30;
	    weapon[2]="Feeder Tendrils";
	    weapon_facing[2]="most";
	    weapon_dam[2]=8;
	    weapon_range[2]=100;
	    weapon_cooldown[1]=30;
	}




	if (owner = eFACTION.Tyranids){
	    var i=0;
	    repeat(2){
	        i+=1;
	        if (obj_fleet.en_mutation[i]="Spore Clouds") then shields=shields+100;
	        if (obj_fleet.en_mutation[i]="Health"){
	        	hp=floor(hp*1.1);
	            maxhp=hp;
	        }
	        if (obj_fleet.en_mutation[i]="Armour") then armour_front+=1;
	        if (obj_fleet.en_mutation[i]="Speed") then speed_bonus=speed_bonus*1.1;
	        if (obj_fleet.en_mutation[i]="Turn") then turn_bonus=1.2;
	        if (obj_fleet.en_mutation[i]="Turret") then turrets+=1;
	    }
	}

}