
//general functions to help with dealing with ship data
function fetch_ship(id){
	return obj_ini.ship_data[id];
}

function get_ship_by_name(ship_name){
	for (var i=0;i<array_length(obj_ini.ship_data);i++){
		var _ship = fetch_ship(i);
		if (ship_name == ship.name){
			return i;
		}
	}
}

function convert_to_kilometers(pix_distance){
	return pix_distance/50;
}

function per_step_to_kilometers(rate_dist){
	return convert_to_kilometers((rate_dist*60));
}

function fps_to_secs(val){
	return val/60;
}


//The actual ship struct
function ShipStruct() constructor{
	crew_exp = 0;
	machine_spirit_exp = 0;
	features = [];
	turrets = [];
	weapons = [];
	location = [];
	owner = 0;
	size = 1;
	capacity = 0;
	carrying = 0;
	hp = 0;
	max_hp = 0;
	acceleration = 0.008;
	max_speed = 20;
	turning_speed = 0.2;

	front_armour = 6;
	side_armour = 3;
	rear_armour = 1;

	name = "";
	shields = 0;
	shields_damage = 0;
	shields_recharge_rate = 0.2;
	shields_reboot_time = 20;

	engineer = "";
	left_broad_positions = [];
	right_broad_positions = [];
	forward_positions = [];
	captain = "";
	captain_data = false;

	minimum_tech_requirements = 8;
	tech_fulfilment = 0;
	tech_suppliers = [];
	docked = false;
	refittment_time = 0;
	minimum_tech = true;

	uid = scr_uuid_generate();

	static ship_hp_percentage = function(){
		return (hp/max_hp )* 100
	}

	static fetch_captain = function(){
		if (captain!=""){
			var _cap = fetch_unit_uid(captain);
			if (_cap != "none"){
				captain_data = _cap;
			} else {
				determine_new_captain();
			}
		} else {
			determine_new_captain();
		}
	}

	static determine_new_captain = function(fetch_new_occupants=true){
		if (fetch_new_occupants){
			var _occupants = get_occupants();
		} else {
			var _occupants = occupants;
		}
		if (array_length(_occupants)){
			var _new_cap = determine_highest_ranking(_occupants);
			captain = _new_cap.uid;
			captain_data = _new_cap;
		} else {
			captain = "";
		}
	}

  /// @description figers out how many forge points the ship has working towards it's running.
  /// @param {bool} collect ship occupants again if done recently this can be false, saves overhead
	static calc_tech_fulfilment = function(fetch_new_occupants=true){
		tech_suppliers = [];
		if (fetch_new_occupants){
			var _occupants = get_occupants();
		}else {
			var _occupants = occupants;
		}
		for (var i=0;i<array_length(occupants);i++){
			var _unit = _occupants[i];
			var _point_gen = _unit.forge_point_generation(false, true);
			if (_point_gen[0]){
				tech_fulfilment += _point_gen[0];
				array_push(tech_suppliers, _unit);
			}
		}
		minimum_tech = tech_fulfilment >= minimum_tech_requirements;
	}

	static get_dock = function(){
		if (docked != false){
			var _dock = search_system_features_uid(star.p_feature,docked);
			return _dock;
		}
		return false;
	}


	static dock_space = function(){
		if (location == "Warp" || location == "Lost"){
			possible_dock = false;
		} else {
			var star = star_by_name(location);
			if (star == "none"){
				possible_dock = false;
			} else {
				var _dock = get_dock();
				if (is_struct(_dock)){
					return false;
				} else {
					docked = false;
				}				
				_planet = system_feature_bool(star.p_feature,P_features.ShipDock);
				if (_planet <= 0){
					possible_dock = false;
				} else {
					var _dock = return_planet_features(star.p_feature[_planet], P_features.ShipDock);
					if (array_length(_dock)){
						_dock = _dock[0];
						if (_dock.has_dock_space(size)){
							possible_dock = _dock;
							possible_dock.planet = _planet;
						} else {
							possible_dock = false;
						}						
					} else {
						possible_dock = false;
					}

				}
			}
		}
		return possible_dock;
	}

	static update_ship_combat_data = function(){
		get_occupants();
		fetch_captain();
		calc_tech_fulfilment(false);
		dock_space();
	}

	static find_array_pos = function(){
		for (var i=0;i<array_length(obj_ini.ship_data);i++){
			if (obj_ini.ship_data[i].uid == uid){
				return i;
			}
		}
	}
	static get_occupants = function(){
		var _ship_id = find_array_pos();
		var _occupants = collect_role_group("all", ["", 0,_ship_id]);
		occupants = _occupants;
		return _occupants;
	}

	static final_acceleration = function(){

		var _acel = acceleration;
	    if (obj_controller.stc_bonus[6]=3){
	        _acel *= 1.2;
	    }	
	    return 	_acel;
	}

	static deceleration = function(){
		var _decel = final_acceleration()/2;
		return _decel;
	}

	static ship_self_heal = function(){
        if (hp<0){
        	exit;
        } else if (hp<max_hp){
            hp = min(max_hp,hp+round(max_hp*0.06));
        }	
	}

	static free_space = function(){
		return capacity - carrying;
	}

	static has_space = function(required = 1){
		return free_space() >= required;
	}

	static calc_turn_speed = function(){
	    var _final_speed = turning_speed;
        if (obj_controller.stc_bonus[5]=3){
            _final_speed *= 1.05;
        }
        if (!minimum_tech){
        	_final_speed *= 0.9;
        }
        return _final_speed;
	}

    static add_weapon_to_slot = function(weapon_name,overide_data,slot){
    	var _s_data = slot;
    	with (overide_data){
    		move_data_to_current_scope(_s_data);
    	}
    	var _wep = new ShipWeapon(weapon_name, overide_data);
    	array_push(weapons, _wep);
    	slot.weapon = _wep;
    }

	static draw_ui_manage = function(x, y){
		var _x_offset = sprite_get_xoffset(sprite_index);
		var _y_offset = sprite_get_yoffset(sprite_index);
		draw_sprite(sprite_index, 0, x+280, y+210);
		var _draw_corner = [x+280 - _x_offset, y+210-_y_offset];
		var _l_length = array_length(left_broad_positions);
		var _r_length = array_length(right_broad_positions);
		var _f_length = array_length(forward_positions);
		var iter = max(_l_length, _r_length, _f_length);
		var draw_weapon_box = function(pos, corner){
			var coords = pos.ship_position;
			var _box_size = pos.slot_size *3;
			var draw_coords = [corner[0]+ coords[0]-_box_size, corner[1]+coords[1]-_box_size, corner[0]+coords[0]+_box_size, corner[1]+coords[1]+_box_size];
			if (scr_hit(draw_coords)){
				draw_set_colour(c_green);
				var _re_equip_s = docked ? "\nclick to equip new weapon" : "\ndock ship to re-equip";
				tooltip_draw($"Emplacement direction : {pos.facing}\nEmplacement Size : {pos.slot_size}{_re_equip_s}");
				obj_controller.weapon_slate.weapon = pos.weapon;
				obj_controller.weapon_slate.slot = pos;
				if (docked && scr_click_left()){
					obj_controller.fleet_temps.weapon_equip = true;
					obj_controller.fleet_temps.wep_change_slot = slot;
				}
			} else {
				draw_set_colour(c_blue);
			}
			draw_rectangle_array(draw_coords,true);
		}
		if (possible_dock != false){
			var _dock_button = draw_unit_buttons([x+280 - (string_width("Dock Ship")/2), y+300], "Dock Ship");
			if (point_and_click(_dock_button)){
				docked = possible_dock.uid;
				possible_dock.space_taken += size;
				var _loc = location;
				for (var i=0;i<array_length(obj_ini.ship_data);i++){
					var _ship = obj_ini.ship_data[i];
					if (_ship.location = _loc){
						_ship.dock_space();
					}
				}
			}
		}
		else if (docked != false){
			if (!refittment_time){
				var _refit_string = "The ship is ready to move from docking";
				var _undock_button = draw_unit_buttons([x+280 - (string_width("Un-Dock Ship")/2), y+320], "Un-Dock Ship");
			} else {
				var _refit_string = $"The ship requires {refittment_time} to finish being outfitted for service";
			}

			draw_text(x+280, y+295, $"Ship currently docked at {location} {_refit_string}");

			if (point_and_click(_undock_button)){
				var _dock = get_dock();
				if (_dock != false){
					possible_dock.space_taken -= size;
					docked = false;
				}
			}

		}
		draw_set_font(fnt_40k_30b);
		draw_set_halign(fa_left);
		var _h_scale = 0.6;
		draw_text_transformed(x + 30, y + 350, "Left Batteries", _h_scale, _h_scale, 0);
		draw_text_transformed(x + 200, y + 350, "Forward Batteries", _h_scale, _h_scale, 0);
		draw_text_transformed(x + 370, y + 350, "Right Batteries", _h_scale, _h_scale, 0);
		draw_set_font(fnt_40k_12);
		for (var i=0;i<iter;i++){
			if (i < _l_length){
				var _pos = left_broad_positions[i];
				draw_weapon_box(_pos, _draw_corner);
				if (_pos.weapon = false){
					draw_text(x + 35, y + 370 + (10*i), "Empty");
				}else{
					draw_text(x + 35, y + 370 + (10*i), _pos.weapon.name);
				}
			}
			if (i < _f_length){
				var _pos = forward_positions[i];
				draw_weapon_box(_pos, _draw_corner);
				if (_pos.weapon = false){
					draw_text(x + 235, y + 370 + (10*i), "Empty");
				}else{
					draw_text(x + 235, y + 370 + (10*i), _pos.weapon.name);
				}				
			}
			if (i < _r_length){
				var _pos = right_broad_positions[i];
				draw_weapon_box(_pos, _draw_corner);
				if (_pos.weapon = false){
					draw_text(x + 435, y + 370 + (10*i), "Empty");
				}else{
					draw_text(x + 435, y + 370 + (10*i), _pos.weapon.name);
				}				
			}						
		}
	}
}