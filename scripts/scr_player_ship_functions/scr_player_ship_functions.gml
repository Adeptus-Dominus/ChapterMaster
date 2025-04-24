#macro INI_USHIPROOT obj_ini.USHIPROOT
#macro USHIPROOT UUID_ship
function fetch_ship(fUUID) {
    gml_pragma("forceinline");
    return struct_get(INI_USHIPROOT, fUUID);
}

function fetch_ship_from_hash(fUUID_hash) {
    gml_pragma("forceinline");
    return struct_get_from_hash(INI_USHIPROOT, fUUID_hash);
}

function return_lost_ships_chance(){
	if (array_contains(obj_ini.ship_location, "Lost")){
		if (roll_dice(1, 100, "high")>97){
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

		var _return_defect = roll_dice(1, 100, "high");
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
				var fleet_strength = ((100 - roll_dice(1, 100, "low"))/10)+3;
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

function get_player_ships(location = "") {
    var _ships = [];
    var _ship_UUIDs = struct_get_names(INI_USHIPROOT);
    var _ship_count = array_length(_ship_UUIDs);
    for (var i = 0; i < _ship_count; i++){
        if (location == "") {
            _ships = _ship_UUIDs;
        } else if (INI_USHIPROOT[$ _ship_UUIDs[i]].location == location) {
            array_push(_ships, _ship_UUIDs[i]);
        }
    }
    return _ships;
}

function new_player_ship_defaults() {
    var _ship = {
        UUID : scr_uuid_generate(),
        name : "",
        owner : 1, //TODO: determine if this means the player or not
        class : "",
        size : 1,
        leadership : 100,
        location : "",
        conditions : "",
        speed : 0,
        turning : 0,
        health : {
            maxhp : 0,
            hp : 0,
            shields : 0
        },
        armor : {
            front : 0,
            other : 0
        },
        weapons : {
            count : 0,
            name : array_create(6, ""),
            facing : array_create(6, ""),
            condition : array_create(6, ""),
            turrets : 0
        },
        cargo : {
            capacity : 0,
            carrying : 0,
            unit_list : [],
            vehicle_list : [],
            contents : ""
        },
        lost : 0
    }

    return _ship;
}

function get_valid_player_ship(location = "") {
    var _ship_UUIDs = struct_get_names(INI_USHIPROOT);
    var _ship_count = array_length(_ship_UUIDs);
    for (var i = 0; i < _ship_count; i++) {
        if (location == "" || INI_USHIPROOT[$ _ship_UUIDs[i]].location == location) {
            return _ship_UUIDs[i];
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
function new_player_ship(type, start_loc = "home", new_name = "") {
    var _ship_names = [];
    var _ship = new_player_ship_defaults();
    var _ship_UUIDs = struct_get_names(INI_USHIPROOT);
    var _ship_count = array_length(_ship_UUIDs);
    for (var i = 0; i < _ship_count; i++) {
        array_push(_ship_names, fetch_ship(_ship_UUIDs[i]).name);
    }

    if (new_name != "") {
        for (var k = 0; k <= 200; k++) {
            new_name = global.name_generator.generate_imperial_ship_name();
            if (!array_contains(_ship_names, new_name)) { break };
        }
    }

    if (start_loc == "home") { start_loc = obj_ini.home_name; }
    _ship.name = new_name;
    _ship.location = start_loc;
    if (string_count("Battle Barge", type) > 0){
        _ship.class = "Battle Barge";
        _ship.size = 3;
        _ship.health.maxhp = 1200;
        _ship.health.hp = _ship.health.maxhp;
        _ship.health.shields = 12;
        _ship.speed = 20;
        _ship.turning = 45;
        _ship.armor.front = 6;
        _ship.armor.other = 6;

        _ship.weapons.count = 5;
        _ship.weapons.name = [
            "",
            "Weapons Battery",
            "Weapons Battery",
            "Thunderhawk Launch Bays",
            "Torpedo Tubes",
            "Macro Bombardment Cannons"
        ];

        _ship.weapons.facing = [
            "",
            "left",
            "right",
            "special",
            "front",
            "most"
        ];
        _ship.weapons.turrets = 3;

        _ship.cargo.capacity = 600;
    }

    if (string_count("Strike Cruiser", type) > 0) {
        _ship.class = "Strike Cruiser";
        _ship.size = 2;
        _ship.health.maxhp = 600;
        _ship.health.shields = 6;
        _ship.speed = 25;
        _ship.turning = 90;
        _ship.armor.front = 6;
        _ship.armor.other = 6;

        _ship.weapons.count = 4;
        _ship.weapons.name = [
            "",
            "Weapons Battery",
            "Weapons Battery",
            "Thunderhawk Launch Bays",
            "Bombardment Cannons",
            ""
        ];

        _ship.weapons.facing = [
            "",
            "left",
            "right",
            "special",
            "most",
            ""
        ];
        _ship.weapons.turrets = 1;

        _ship.cargo.capacity = 250;
    }

    if (string_count("Gladius", type) > 0) {
        _ship.class = "Gladius";
        _ship.health.maxhp = 200;
        _ship.health.shields = 1;
        _ship.speed = 30;
        _ship.turning = 90;
        _ship.armor.front = 5;
        _ship.armor.other = 5;

        _ship.weapons.count = 1;
        _ship.weapons.name[1] = "Weapons Battery";
        _ship.weapons.facing[1] = "most";
        _ship.weapons.turrets = 1;

        _ship.cargo.capacity = 30;
    }

    if (string_count("Hunter", type) > 0) {
        _ship.class = "Hunter";
        _ship.health.maxhp = 200;
        _ship.health.shields = 1;
        _ship.speed = 30;
        _ship.turning = 90;
        _ship.armor.front = 5;
        _ship.armor.other = 5;

        _ship.weapons.count = 2;
        _ship.weapons.name[1] = "Torpedoes";
        _ship.weapons.facing[1] = "front";
        _ship.weapons.name[2] = "Weapons Battery";
        _ship.weapons.facing[2] = "most";
        _ship.weapons.turrets = 1;

        _ship.cargo.capacity = 25;
    }

    if (string_count("Gloriana", type) > 0) {
        _ship.class = "Gloriana";
        _ship.size = 3;
        _ship.health.maxhp = 2400;
        _ship.health.shields = 24;
        _ship.speed = 25;
        _ship.turning = 60;
        _ship.armor.front = 8;
        _ship.armor.other = 8;

        _ship.weapons.count = 5;
        _ship.weapons.name = [
            "",
            "Lance Battery",
            "Lance Battery",
            "Lance Battery",
            "Plasma Cannon",
            "Macro Bombardment Cannons",
        ];

        _ship.weapons.facing = [
            "",
            "most",
            "most",
            "most",
            "front",
            "most"
        ];
        _ship.weapons.turrets = 8;

        _ship.cargo.capacity = 800;
    }
    _ship.health.hp = _ship.health.maxhp;

    struct_set(USHIPROOT, _ship.UUID, _ship);

    return _ship;
}

function ship_class_name(UUID) {
    var _ship_struct = fetch_ship(UUID);

    var _ship_name = _ship_struct.name;
    var _ship_class = _ship_struct.class;
    return $"{_ship_class} '{_ship_name}'";
}

function player_ships_class(UUID) {
    var _escorts = ["Escort", "Hunter", "Gladius"];
    var _capitals = ["Gloriana", "Battle Barge", "Capital"];
    var _frigates = ["Strike Cruiser", "Frigate"];
    var _ship_struct = fetch_ship(UUID);
    var _ship_class = _ship_struct.class;

    if (array_contains(_escorts, _ship_class)) {
        return "escort";
    } else if (array_contains(_capitals, _ship_class)) {
        return "capital";
    } else if (array_contains(_frigates, _ship_class)) {
        return "frigate";
    }

    return _ship_class;
}

function ship_bombard_score(UUID) {
    var _ship_struct = fetch_ship(UUID);

    var _bomb_score = 0;
    var weapon_bomb_scores = {
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
    };

    var _array_count = array_length(_ship_struct.weapons.name);
    for (var b = 0; b < _array_count; b++) {
        var _wep = _ship_struct.weapons.name[b];
        if (struct_exists(weapon_bomb_scores, _wep)){
            _bomb_score += weapon_bomb_scores[$ _wep].value;
        }
    }

    return _bomb_score;
}
