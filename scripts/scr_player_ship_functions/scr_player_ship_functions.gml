function return_lost_ships_chance(){
	for (var i=0;i<array_length(obj_ini.ship_data);i++){
		if (fetch_ship(i).location == "Lost"){
			if (roll_dice_chapter(1, 100, "high")>97){
				return_lost_ship();
			}			
		}
	}
}

function return_lost_ship(){
	var _return_id = get_valid_player_ship("Lost");
	if (_return_id!=-1){
		var _ship = fetch_ship(_return_id);
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
		var _text = $"The ship {_ship.name} has returned to real space and is now orbiting the {_star.name} system\n";
		if (_return_defect<90){
			if (_return_defect>80){
				_ship.hp *= random_range(0.2,0.8);
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
				_text += $"The fate of your ship {_ship.name} has now become clear\n A Chaos fleet has warped into the {_star.name} system with your once prized ship now a part of it";
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
				_text += $"The fate of your ship {_ship.name} has now become clear. While it did not survive it's travels through the warp and tore itself apart somewhere in the  {_star.name} system. ";
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
	for (var i = 0;i<array_length(obj_ini.ship_data);i++){
		var _ship = obj_ini.ship_data[i];

		if (location == ""){
			array_push(_ships, i);
		} else {
			if (_ship.location == location){
				array_push(_ships, i);
			}
		}

	}
	return _ships;
}

function new_player_ship_defaults(class){
	with (obj_ini){
		array_push(ship_data,new ShipStruct(class));
	}
	return array_length(obj_ini.ship_data)-1;
}

function get_valid_player_ship(location="", name=""){
	for (var i = 0;i<array_length(obj_ini.ship_data);i++){
		var _ship = obj_ini.ship_data[i];
		if (location == ""){
			return i;
		} else {
			if (_ship.location == location){
				return i;
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
		for(var vehicle = 0; vehicle <= 100; vehicle++){
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
    var index = new_player_ship_defaults(type);
    var _names = [];
    for (var i=0;i<array_length(obj_ini.ship_data);i++){
    	array_push(_names, fetch_ship(i).name);
    }
    for(var k=0; k<=200; k++){
        if (new_name==""){
            new_name=global.name_generator.generate_imperial_ship_name();
            if (array_contains(_names, new_name)){
            	new_name="";
            }
        } else {
        	break
        };
    }
    if (start_loc == "home") then start_loc = obj_ini.home_name;
    var _struct = obj_ini.ship_data[index];
    _struct.location = start_loc;
    _struct.name=new_name;
    _struct.class = type;

    if (string_count("Battle Barge",type)>0){
        with(_struct){
	        left_broad_positions = [
	        {
	        	ship_position : [162, 36],
	        	slot_size : 2,
	        	weapon : false,
	        	facing : "left"
	        },
	        {
	        	ship_position : [173, 36],
	        	slot_size : 2,
	        	weapon : false,
	        	facing : "left"
	        },
	        {
	        	ship_position : [185,36],
	        	slot_size : 2,
	        	weapon : false,
	        	facing : "left"
	        },
	        {
	        	ship_position : [197, 36],
	        	slot_size : 2,
	        	weapon : false,
	        	facing : "left"
	        },
	        {
	        	ship_position : [210,36],
	        	slot_size : 2,
	        	weapon : false,
	        	facing : "left"
	        },
	        {
	        	ship_position : [222, 36],
	        	slot_size : 2,
	        	weapon : false,
	        	facing : "left"
	        },	        	        	        	        	        
	       ];
	        right_broad_positions = [
	        {
	        	ship_position : [162, 75],
	        	slot_size : 2,
	        	weapon : false,
	        	facing : "right"
	        },
	        {
	        	ship_position : [173, 75],
	        	slot_size : 2,
	        	weapon : false,
	        	facing : "right"
	        },
	        {
	        	ship_position : [185,75],
	        	slot_size : 2,
	        	weapon : false,
	        	facing : "right"
	        },
	        {
	        	ship_position : [197, 75],
	        	slot_size : 2,
	        	weapon : false,
	        	facing : "right"
	        },
	        {
	        	ship_position : [210,75],
	        	slot_size : 2,
	        	weapon : false,
	        	facing : "right"
	        },
	        {
	        	ship_position : [222, 75],
	        	slot_size : 2,
	        	weapon : false,
	        	facing : "right"
	        },	        	        	        	        	        
	       ];	       
	        var _broadsl = left_broad_positions;
	        var _broadsr = right_broad_positions;
	        for (var i=0;i<array_length(_broadsl);i++){
	        	add_weapon_to_slot("Macro Cannon",{}, _broadsl[i]);
	        	add_weapon_to_slot("Macro Cannon",{}, _broadsr[i]);
	        }
	        forward_positions = [
		        {
		        	ship_position: [88, 6],
		        	slot_size : 3,
		        	facing : "Front",

		        },
		        {
		        	ship_position: [88, 106],
		        	slot_size : 3,
		        	facing : "Front",

		        },
		        {
		        	ship_position: [281, 90],
		        	slot_size : 3,
		        	facing : "Front",

		        },
		        {
		        	ship_position: [281, 19],
		        	slot_size : 3,
		        	facing : "Front",

		        },
		        {
		        	ship_position: [283, 56],	
		        	slot_size : 4,
		        	facing : "Front",	        	
		        }
	        ];
	        var _for = forward_positions;  
	       	for (var i=0;i<array_length(_for);i++){
	       		if (_for[i].slot_size == 3){
	       			add_weapon_to_slot("Torpedoes",{}, _for[i]);
	       		} else {
	       			add_weapon_to_slot("Macro Bombardment Cannons",{}, _for[i]);       			
	       		}
	        }        
	        add_weapon_to_ship("Thunderhawk Launch Bays");
	        size = 3;
	        capacity = 600;
	        turning_speed = 0.2;
	        max_speed = 20;
	        hp = 1200;
	        max_hp = 1200;
	        side_armour = 6;
	        rear_armour = 3;
	        shields = 1;
	        sprite_index=spr_ship_bb;
	        minimum_tech_requirements = 20;
       	}

        
        
        _struct.turrets = [{},{},{}];
    }

    if (string_count("Strike Cruiser",type)>0){
        with(_struct){
	         left_broad_positions = [
		        {
		        	ship_position : [56, 37],
		        	slot_size : 2,
		        	weapon : false,
		        	facing : "left"
		        },
		        {
		        	ship_position : [65, 37],
		        	slot_size : 2,
		        	weapon : false,
		        	facing : "left"
		        },
		        {
		        	ship_position : [74,37],
		        	slot_size : 2,
		        	weapon : false,
		        	facing : "left"
		        },
		        {
		        	ship_position : [83, 37],
		        	slot_size : 2,
		        	weapon : false,
		        	facing : "left"
		        },
	        ]
	        right_broad_positions = [
	        	{
	        		ship_position : [56, 37],
	    	        slot_size : 2,
		        	weapon : false,
		        	facing : "right"
	        	},
	        	{
	        		ship_position : [65, 37],
	    	        slot_size : 2,
		        	weapon : false,
		        	facing : "right"
	        	},
	        	{
	        		ship_position : [74,37],
	    	        slot_size : 2,
		        	weapon : false,
		        	facing : "right"
	        	},
	        	{
	        		ship_position : [83, 37],
	    	        slot_size : 2,
		        	weapon : false,
		        	facing : "right"
	        	}
	        ];
	        var _broadsl = left_broad_positions;
	        var _broadsr = right_broad_positions;
	        for (var i=0;i<array_length(_broadsl);i++){
	        	add_weapon_to_slot("Macro Cannon",{}, _broadsl[i]);
	        	add_weapon_to_slot("Macro Cannon",{}, _broadsr[i]);
	        }
	        add_weapon_to_ship("Thunderhawk Launch Bays");
	        add_weapon_to_ship("Bombardment Cannons");
	        size = 2;
	        capacity = 250;
	       	turning_speed = 0.25;
	       	max_speed = 25;
	       	hp = 600;
	       	max_hp = 600
			front_armour = 6;
			side_armour = 4;
			rear_armour = 3;
			shields = 6;
			sprite_index=spr_ship_stri;
			minimum_tech_requirements = 14;	       	
	    }
        
        _struct.turrets = [{}];
    }
    if (string_count("Gladius",type)>0){
        with(_struct){
        	class = "Gladius";
	        add_weapon_to_ship("Macro Cannon");
	        turrets = [{}];
	        hp = 200;
	        max_hp = 200;
	        capacity = 30;	
	        turning_speed = 0.3;
	        max_speed = 30;
			front_armour = 5;
			side_armour = 4;
			rear_armour = 1;
			shields = 1;
			sprite_index=spr_ship_glad;
			minimum_tech_requirements = 6;            
	    }
    }
    if (string_count("Hunter",type)>0){
        with(_struct){
        	class = "Hunter";
	        add_weapon_to_ship("Torpedoes");
	        add_weapon_to_ship("Macro Cannon");
	        turrets = [{}];
	        hp = 200;
	        max_hp = 200;
	        capacity = 25;
	        turning_speed = 0.4;
	        max_speed = 38; 
			front_armour = 4;
			side_armour = 3;
			rear_armour = 1;
			shields = 1;
			sprite_index=spr_ship_hunt;	
			minimum_tech_requirements = 8;               	            	
	    }

        
    }
    if (string_count("Gloriana",type)>0){        

        with(_struct){
        	class = "Gloriana";
	        add_weapon_to_ship("Lance Battery", {facing : "right"});
	        add_weapon_to_ship("Lance Battery",{facing : "left"});
	        add_weapon_to_ship("Lance Battery",{facing : "front"});
	        add_weapon_to_ship("Plasma Cannon");
	        add_weapon_to_ship("Macro Bombardment Cannons");  
	        turrets = [{},{},{},{},{},{},{},{}];
	        hp = 2400;
	        max_hp = 2400;	
	        size = 3;
	        capacity = 800;
	        turning_speed = 0.23;
	        max_speed = 23; 
			front_armour = 6;
			side_armour = 8;
			rear_armour = 2;
			shields = 24;
			sprite_index=spr_ship_song;	      	   	            	    
	    }          
        
    }
    return index;
}

function ship_class_name(index){
	var _ship = fetch_ship(index);	
	return $"{_ship.class} '{_ship.name}'";
}

function player_ships_class(index){
	var _escorts = ["Escort", "Hunter", "Gladius"];
	var _capitals = ["Gloriana", "Battle Barge", "Capital"];
	var _frigates = ["Strike Cruiser", "Frigate"];	
	var _ship_name_class = fetch_ship(index).class;
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

	var _weapons = obj_ini.ship_data[ship_id].weapons;
	for (var b=0;b<array_length(_weapons);b++){
		_bomb_score += _weapons.bombard_value;
	}

	return _bomb_score;	
}
