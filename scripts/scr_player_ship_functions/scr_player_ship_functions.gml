function return_lost_ships_chance(){
	if (array_contains(obj_ini.ship_location, "Lost")){
		if (roll_dice_chapter(1, 100, "high")>97){
			return_lost_ship();
		}
	}
}

function return_lost_ship(){
	var _return_id = get_valid_player_ship("Lost");
	if (_return_id!=-1){
		var _lost_fleet = "none";
		with (obj_p_fleet){
			if (action == "Lost"){
				_lost_fleet = id;
				break;
			}
		}
		var _star = instance_find(obj_star, irandom(instance_number(obj_star) - 1));
		_new_fleet = instance_create(_star.x,_star.y,obj_p_fleet);
		_new_fleet.owner  = eFACTION.Player;
		if (_lost_fleet!="none"){
			find_and_move_ship_between_fleets(_lost_fleet, _new_fleet,_return_id);
			if (player_fleet_ship_count(_lost_fleet)==0){
				with (_lost_fleet){
					instance_destroy();
				}
			}
		} else {
			add_ship_to_fleet(_return_id, _new_fleet);
		}

		var _return_defect = roll_dice_chapter(1, 100, "high");
		var _text = $"The ship {obj_ini.ship[_return_id]} has returned to real space and is now orbiting the {_star.name} system\n";
		if (_return_defect<90){
			if (_return_defect>80){
				obj_ini.ship_hp[_return_id] *= random_range(0.2,0.8);
				_text += $"Reports indicate it has suffered damage as a result of it's time in the warp";
			} else if (_return_defect>70){
				var techs = collect_role_group(SPECIALISTS_TECHS, [_star.name, 0, _return_id]);
				if (array_length(techs)){
					_text += $"One of the ships main reactors sufered a malfunction and the ships tech staff died to a man attempting to contain the damage";
					for (var i=0; i<array_length(techs);i++){
						var _tech = techs[i];
						kill_and_recover(_tech.company, _tech.marine_number);
					}
				}
			} else if (_return_defect>60){
				var _units = collect_role_group("all", [_star.name, 0, _return_id]);
				if (array_length(_units)){
					_text += $"While in the warp the geller fields temporarily went down leaving the ships crew to face the horror of the warp";
					for (var i=0;i<array_length(_units);i++){
						_units[i].edit_corruption(max(0,irandom_range(20, 120)-_unit.piety));
					}
				}
			} else if (_return_defect>50){
				var _units = collect_role_group("all", [_star.name, 0, _return_id]);
				if (array_length(_units)>1){
					_text += $"The ship was stuck in the warp for many years so many that even the resolve of the marines began to breakdown, there was a mutiney as many marines thought they would be best to try their luck as renegades in the warp. Those who remained loyal to you prevailed but their geneseed was burnt for fear of corruption";
					_units = array_shuffle(_units);
					for (var i=0;i<floor(array_length(_units)/2);i++){
						var _unit=_units[i];
						kill_and_recover(_unit.company, _unit.marine_number, true, false);
					}
				}
			} else if (_return_defect>40){
				var _units = collect_role_group("all", [_star.name, 0, _return_id]);
				if (array_length(_units)>0){
					_text += $"The ship is empty, what happened to the origional crew is a mystery";
					for (var i=0;i<array_length(_units);i++){
						var _unit=_units[i];
						kill_and_recover(_unit.company, _unit.marine_number, false, false);
					}					
				}
			}else if (_return_defect>20){
				//This would be an awsome oppertunity and ideal kick off place to allow a redemtion arc either liberating the ship or some of your captured marines  gene seed other bits
				_text += $"The fate of your ship {obj_ini.ship[_return_id]} has now become clear\n A Chaos fleet has warped into the {_star.name} system with your once prized ship now a part of it";
				var _units = collect_role_group("all", [_star.name, 0, _return_id]);
				if (array_length(_units)>0){
					_text += $"You must assume the worst for your crew";
					for (var i=0;i<array_length(_units);i++){
						var _unit=_units[i];
						kill_and_recover(_unit.company, _unit.marine_number, false, false);
					}				
				}
				scr_kill_ship(_return_id);
				var _chaos_fleet = spawn_chaos_fleet_at_system(_star);
				var fleet_strength = ((100 - roll_dice_chapter(1, 100, "low"))/10)+3;
				distribute_strength_to_fleet(fleet_strength, _chaos_fleet);
				with (_new_fleet){
					instance_destroy();
				}

			} else{
				var _units = collect_role_group("all", [_star.name, 0, _return_id]);
				_text += $"The fate of your ship {obj_ini.ship[_return_id]} has now become clear. While it did not survive it's travels through the warp and tore itself apart somewhere in the  {_star.name} system. ";
				scr_kill_ship(_return_id);
				if (array_length(_units)>0){
					_text += "Some of your astartes may have been able to jetison and survive the ships destruction";
				}
			}
			//More scenarios needed but this is a good start

		}
		scr_popup("Ship Returns",_text,"lost_warp","");
		if (_lost_fleet != "none"){
			if (!player_fleet_ship_count(_lost_fleet)){
				with (_lost_fleet){
					instance_destroy();
				}
			}
		}		
	}
}

function get_player_ships(location="", name=""){
	var _ships = [];
	for (var i = 0;i<array_length(obj_ini.ship);i++){
		if (obj_ini.ship[i] != ""){
			if (location == ""){
				array_push(_ships, i);
			} else {
				if (obj_ini.ship_location[i] == location){
					array_push(_ships, i);
				}
			}
		}
	}
	return _ships;
}

function new_player_ship_defaults(){
	with (obj_ini){
		array_push(ship, "");
		array_push(ship_uid,0);
		array_push(ship_owner,0);
		array_push(ship_class, "");
		array_push(ship_size,0);
		array_push(ship_leadership,0);
		array_push(ship_hp,0);
		array_push(ship_maxhp,0);
		array_push(ship_location, "");
		array_push(ship_shields,0);
		array_push(ship_conditions, "");
		array_push(ship_speed,0);
		array_push(ship_turning,0);
		array_push(ship_front_armour,0);
		array_push(ship_other_armour,0);
		array_push(ship_weapons,0);
		array_push(ship_wep, array_create(6,""));
		array_push(ship_wep_facing, array_create(6,""));
		array_push(ship_wep_condition, array_create(6,""));
		array_push(ship_capacity,0);
		array_push(ship_carrying,0);
		array_push(ship_contents, "");
		array_push(ship_turrets,0);
	}
	return array_length(obj_ini.ship)-1;
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


function loose_ship_to_warp_event(){  
		
	var eligible_fleets = [];
	with(obj_p_fleet) {
		if (action=="move") {
			array_push(eligible_fleets, id);
		}
	}
	
	if(array_length(eligible_fleets) == 0) {
		//show_debug_message("RE: Ship Lost, couldn't find a player fleet");   
		exit;
	}
	
	var _fleet = array_random_element(eligible_fleets);
	var _ships = fleet_full_ship_array(_fleet);
	var _ship_index = array_random_element(_ships);
	
	var text="The ";

	text += $"{ship_class_name(_ship_index)} has been lost to the miasma of the warp."		
	
	var marine_count = scr_count_marines_on_ship(_ship_index);				
	if (marine_count>0) {
		text += $"  {marine_count} Battle Brothers were onboard.";
	}
	scr_event_log("red",text);
	var _lost_ship_fleet = "none";
	with (obj_p_fleet){
		if (action == "Lost"){
			_lost_ship_fleet = id;
		}
	}
	if (_lost_ship_fleet=="none"){
		var _lost_ship_fleet = instance_create(-500,-500,obj_p_fleet);
		_lost_ship_fleet.owner = eFACTION.Player;
	}

	find_and_move_ship_between_fleets(_fleet, _lost_ship_fleet,_ship_index);
	with (_lost_ship_fleet){
		set_fleet_location("Lost");
	}

	var unit;
	for(var company = 0; company <= obj_ini.companies; company++){
		for(var marine = 0; marine < array_length(obj_ini.role[company]); marine++){
			if (obj_ini.name[company][marine] == "") then continue;
			unit = fetch_unit([company, marine]);
			if(unit.ship_location == _ship_index) {
				obj_ini.loc[company][marine] = "Lost";
			}
		}
		for(var vehicle = 1; vehicle <= 100; vehicle++){
			if(obj_ini.veh_lid[company, vehicle] == _ship_index){
				obj_ini.veh_loc[company, vehicle] = "Lost";
			}
		}
	}

	_lost_ship_fleet.action="Lost";
	_lost_ship_fleet.alarm[1]=2;
	
	scr_popup("Ship Lost",text,"lost_warp","");
           
    if (player_fleet_ship_count(_fleet)==0) then with(_fleet){
		instance_destroy();
	}	
}

//TODO make method for setting ship weaponry
function new_player_ship(type, start_loc="home", new_name=""){
    var ship_names="",index=0;
    var index = new_player_ship_defaults();
    
    for(var k=0; k<=200; k++){
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
        obj_ini.ship_wep[index,5]="Macro Bombardment Cannons";
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
    if (string_count("Gloriana",type)>0){
		obj_ini.ship[index]=new_name;
        obj_ini.ship_size[index]=3;
    
        obj_ini.ship_class[index]="Gloriana";
    
        obj_ini.ship_hp[index]=2400;
        obj_ini.ship_maxhp[index]=2400;
        obj_ini.ship_conditions[index]="";
        obj_ini.ship_speed[index]=25;
        obj_ini.ship_turning[index]=60;
        obj_ini.ship_front_armour[index]=8;
        obj_ini.ship_other_armour[index]=8;
        obj_ini.ship_weapons[index]=4;
        obj_ini.ship_shields[index]=24;
        obj_ini.ship_wep[index,1]="Lance Battery";
        obj_ini.ship_wep_facing[index,1]="most";
        obj_ini.ship_wep_condition[index,1]="";
        obj_ini.ship_wep[index,2]="Lance Battery";
		obj_ini.ship_wep_facing[index,2]="most";
        obj_ini.ship_wep_condition[index,2]="";
        obj_ini.ship_wep[index,3]="Lance Battery";
        obj_ini.ship_wep_facing[index,3]="most";
        obj_ini.ship_wep_condition[index,3]="";
        obj_ini.ship_wep[index,4]="Plasma Cannon";
        obj_ini.ship_wep_facing[index,4]="front";
        obj_ini.ship_wep_condition[index,4]="";
        obj_ini.ship_wep[index,5]="Macro Bombardment Cannons";
        obj_ini.ship_wep_facing[index,5]="most";
        obj_ini.ship_wep_condition[index,5]="";               
        obj_ini.ship_capacity[index]=800;
        obj_ini.ship_carrying[index]=0;
        obj_ini.ship_contents[index]="";
        obj_ini.ship_turrets[index]=8;
    }
    return index;
}

function ship_class_name(index){
	var _ship_name = obj_ini.ship[index];
	var _ship_class = obj_ini.ship_class[index];	
	return $"{_ship_class} '{_ship_name}'";
}

function player_ships_class(index){
	var _escorts = ["Escort", "Hunter", "Gladius"];
	var _capitals = ["Gloriana", "Battle Barge", "Capital"];
	var _frigates = ["Strike Cruiser", "Frigate"];	
	var _ship_name_class = obj_ini.ship_class[index];
	if (array_contains(_escorts, _ship_name_class)){
		return "escort";
	} else if (array_contains(_capitals, _ship_name_class)){
		return "capital";
	}else if (array_contains(_frigates, _ship_name_class)){
		return "frigate";
	}
	return _ship_name_class;
}

function ship_bombard_score(ship_id){
	var _bomb_score = 0;
	static weapon_bomb_scores = {
		"Bombardment Cannons" : {
			value : 1,
		},
		"Macro Bombardment Cannons" : {
			value : 2,
		},
		"Plasma Cannon" : {
			value : 4
		},
		"Torpedo Tubes" : {
			value : 1
		}
	}
	for (var b=0;b<array_length(obj_ini.ship_wep[ship_id]);b++){
		var _wep = obj_ini.ship_wep[ship_id][b];
		if (struct_exists(weapon_bomb_scores, _wep)){
			_bomb_score += weapon_bomb_scores[$ _wep].value;
		}
	}

	return _bomb_score;	
}
