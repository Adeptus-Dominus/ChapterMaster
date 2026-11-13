enum eBATTLE_TYPES {
	FLEET,
	GROUNDFORCES
}

function EndTurnBattle(_data) constructor{
	battle_type = eBATTLE_TYPES.GROUNDFORCES;
	location = "";
	opponent = eFACTION.NONE;
	object = noone;
	pobject = noone;
	special = "";
	planet = 0;
	move_data_to_current_scope(_data);

	if (location == "" && instance_exists(object)){
		location = object.name;
	}

	static flee_fleet_engagement = function(){
        // Run like hell, space
        with (obj_fleet_select) {
            instance_destroy();
        }
        pobject.alarm[3] = 1;
        var _pop = instance_create(0, 0, obj_popup);
        _pop.type = ePOPUP_TYPE.FLEET_MOVE;
        obj_controller.force_scroll = 1;		
	}

	static start_fleet_engagement = function(){
        // Fight fight fight, space
        var _battle_fleet = pobject;
        if (_battle_fleet.capital_number + _battle_fleet.frigate_number + _battle_fleet.escort_number <= 0) {
            obj_turn_end.alarm[4] = 1;
            exit;
        }

        obj_controller.cooldown = 8000;
        instance_activate_all();

        // Start battle here

        obj_turn_end.combating = 1;

        var _battle_instance = instance_create(0, 0, obj_fleet);

        var _map_i = 0;
        for (var i = 0; i < array_length(battle_data.enemy_fleets); i++){
        	var _fleet = battle_data.enemy_fleets[i];
        	_map_i = i + 1;
        	_battle_instance.enemy[_map_i] = _fleet.owner;
        	_battle_instance.enemy_status[_map_i] = -1;
	        _battle_instance.en_capital[_map_i] = _fleet.capitals;
	        _battle_instance.en_frigate[_map_i] = _fleet.frigates;
	        _battle_instance.en_escort[_map_i] = _fleet.escorts;
        }

        for (var i = 0; i < array_length(battle_data.allied_fleets); i++){
        	var _fleet = battle_data.allied_fleets[i];
        	_map_i++;
        	_battle_instance.enemy[_map_i] = _fleet.owner;
        	_battle_instance.enemy_status[_map_i] = 1;
	        _battle_instance.en_capital[_map_i] = _fleet.capitals;
	        _battle_instance.en_frigate[_map_i] = _fleet.frigates;
	        _battle_instance.en_escort[_map_i] = _fleet.escorts;
        }

        if (special == "CHAOS") {
            _battle_instance.chaos_exp = 1;
        }
        if (special == "BLOOD") {
            _battle_instance.chaos_exp = 2;
        }

        instance_activate_all();
        _battle_instance.star_name = location;

        add_fleet_ships_to_combat(pobject, _battle_instance);

        instance_deactivate_all_safe();
        instance_activate_object(_battle_instance);		
	}

	static start_ground_battle = function(stance){
        obj_controller.cooldown = 8;

        // Start battle here
        obj_turn_end.combating = 1;

        instance_deactivate_all_safe();
        instance_activate_object(object);

        instance_create(0, 0, obj_ncombat);
        obj_ncombat.enemy = opponent;
        obj_ncombat.battle_object = object;
        obj_ncombat.battle_loc = location;
        obj_ncombat.battle_id = planet;
        obj_ncombat.end_turn_battle_queue = true;

        var _enemy = obj_ncombat.enemy;

        var _planet_data = new PlanetData(planet, object);
        if (stance == "offensive") {
            obj_ncombat.formation_set = 1;
        } else if (stance == "defensive") {
            obj_ncombat.formation_set = 2;
        }

        var _allow_fortifications = false;
        var _fort_factions = [
            eFACTION.PLAYER,
            eFACTION.TYRANIDS,
            eFACTION.ORK,
        ];
        _allow_fortifications = array_contains(_fort_factions, _planet_data.current_owner);

        if (!_allow_fortifications) {
            var owner_fac_status;
            _allow_fortifications = _planet_data.owner_status() != "War";
        }

        if (_allow_fortifications) {
            obj_ncombat.fortified = _planet_data.fortification_level;
        }

        if (obj_ncombat.enemy == eFACTION.NECRONS) {
            obj_ncombat.fortified = 0;
        }

        if (is_struct(special)) {
            var _spec_data = special;
            obj_ncombat.battle_special = _spec_data.special_id;
            obj_ncombat.special_feature = _spec_data.special_feature;
            if (struct_exists(_spec_data, "battle_enemy_data")) {
                obj_ncombat.battle_enemy_data = _spec_data.battle_enemy_data;
            }
        } else {
            obj_ncombat.battle_special = special;
        }
        obj_ncombat.battle_climate = _planet_data.planet_type;

        if (_enemy == eFACTION.IMPERIUM) {
            obj_ncombat.threat = min(1000000, _planet_data.guardsmen);
        } else if (obj_ncombat.enemy <= eFACTION.NECRONS && _enemy >= eFACTION.ELDAR) {
            obj_ncombat.threat = _planet_data.planet_forces[_enemy];
        }

        var _roster = new Roster();
        _roster.roster_location = location;
        _roster.roster_planet = planet;
        _roster.determine_full_roster();
        _roster.only_locals();
        _roster.update_roster();
        if (array_length(_roster.selected_units)) {
            setup_battle_formations();
            _roster.add_to_battle();
        }
        delete _roster;
        instance_deactivate_object(object);
	}
	static prep_battle = function(){
		var _battle_data = {};
		var _battle_star = object;

		_battle_data.star_x = _battle_star.x;
		_battle_data.star_y = _battle_star.y;

		if (battle_type == eBATTLE_TYPES.FLEET) {
			_battle_data.player_fleet_count = {
                capitals : round(pobject.capital_number),
                frigates : round(pobject.frigate_number),
                escorts : round(pobject.escort_number),			
			}
			_battle_data.player_fleet_health = {
                capitals : round(pobject.capital_health),
                frigates : round(pobject.frigate_health),
                escorts : round(pobject.escort_health),				
			}
			// Fleet battle - collect enemy fleet data
			_battle_data.enemy_fleets = [];
			_battle_data.allied_fleets = [];

			for (var _e = 2; _e <= 11; _e++) {
				if (_e == 11) {
					_e = 13;
				}
				if (_battle_star.present_fleet[_e] > 0) {
					// Store lookup values on self so they're accessible inside `with`
					var _star_id = _battle_star.id;
					var _cap_total = 0;
					var _fri_total = 0;
					var _esc_total = 0;

					with (obj_en_fleet) {
						if ((orbiting == _star_id) && (owner == _e)) {
							_cap_total += round(capital_number);
							_fri_total += round(frigate_number);
							_esc_total += round(escort_number);
						}
					}

					var _fleet_entry = {
						owner: _e,
						capitals: _cap_total,
						frigates: _fri_total,
						escorts: _esc_total,
					};
					if (obj_controller.faction_status[_e] == "War" || _e == eFACTION.TYRANIDS || _e == eFACTION.NECRONS){
						array_push(_battle_data.enemy_fleets, _fleet_entry);
					} else {
						array_push(_battle_data.allied_fleets, _fleet_entry);
					}

				}
			}
		} else if (battle_type == eBATTLE_TYPES.GROUNDFORCES && planet > 0) {
			// Ground battle - collect ground forces data
			var _forces = scr_count_forces(location, planet, true, true);
			_battle_data.marines = _forces[0];
			_battle_data.vehicles = _forces[1];

			_battle_data.marines = info_mahreens;
			_battle_data.vehicles = info_vehicles;
			_battle_data.fortification = "";

			var _owner = object.p_owner[planet];
			if ((_owner == 1) || (_owner == 2) || (_owner == 3)) {
				var _array_string = [
					"",
					"Minimally",
					"Lightly",
					"Moderately",
					"Highly",
					"Extremely",
					"Maximally",
				];
				var _fort_level = object.p_fortified[planet];
				_battle_data.fortification = _array_string[clamp(_fort_level, 1, 6)];
			}

			var _enemy_forces = 0;
			if (opponent == eFACTION.ORK) {
				_enemy_forces = object.p_orks[planet];
			} else if (opponent == eFACTION.TAU) {
				_enemy_forces = object.p_tau[planet];
			} else if (opponent == eFACTION.TYRANIDS) {
				_enemy_forces = object.p_tyranids[planet];
			} else if (opponent == eFACTION.CHAOS) {
				_enemy_forces = object.p_chaos[planet];
			} else if (opponent == eFACTION.HERETICS) {
				_enemy_forces = object.p_traitors[planet];
			} else if (opponent == eFACTION.NECRONS) {
				_enemy_forces = object.p_necrons[planet];
			}

			if (_enemy_forces == 0) {
				LOGGER.debug("error : enemy forces for battle 0");
			}
			_battle_data.enemy_strength = global.force_strength_descriptions[clamp(_enemy_forces, 1, 6)];
		}

		battle_data = _battle_data;

		buttons = {};
		if (battle_type == eBATTLE_TYPES.FLEET){
			buttons.retreat = new UnitButtonObject({
				label : "Retreat",
				style : "pixel",
				text_scale : 1.1,
				x1 : 535 + 132,
				y1 : 200 + 354
			});
			buttons.fight = new UnitButtonObject({
				label : "Fight",
				style : "pixel",
				text_scale : 1.1,
				x1 : 535 + 272,
				y1 : 200 + 354
			});
		} else {
			buttons.offence = new UnitButtonObject({
				label : "Offensive",
				style : "pixel",
				text_scale : 1.1,
				x1 : 535 + 132,
				y1 : 200 + 354
			});
			buttons.defence = new UnitButtonObject({
				label : "Defensive",
				style : "pixel",
				text_scale : 1.1,
				x1 : 535 + 272,
				y1 : 200 + 354
			});			
		}
		return _battle_data;
	}

	static draw_fleet_selector = function(){
	    var xxx = 535;
	    var yyy = 200;	
	    draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_left);

        draw_text(xxx + 12, yyy + 237, "Enemy Fleets:");
        draw_text(xxx + 332, yyy + 237, "Allied Fleets:");

        var _types = ["capitals", "frigates", "escorts"];
        var _type_names = ["Battleship", "Frigate", "Escort"];
        var _p_fleet_y = 118;
        for (var i = 0; i < array_length(_types); i++){
        	var _type = _types[i];
	        if (battle_data.player_fleet_count[$ _type] > 0) {
	        	var _count = battle_data.player_fleet_count[$ _type];
	        	var _percentage = battle_data.player_fleet_health[$ _type];
	            draw_text(xxx + 310, yyy + _p_fleet_y + (20 * i),  $"{_count} {_type_names[i]} ({_percentage}% HP)");
	        }        	
        }

        draw_set_halign(fa_center);

        var _en_fleet_x = xxx + 12;
        var _text_offset = 32;
        for (var i = 0; i < array_length(battle_data.enemy_fleets); i++){
        	var _fleet = battle_data.enemy_fleets[i];
        	var _cur_fleet_x = _en_fleet_x + (110 * i)
        	scr_image("ui/force", _fleet.owner,  _cur_fleet_x, yyy + 237, 64, 64);
        	var _ships_string = "";
        	for (var e = 0; e < array_length(_types); e++){
        		var _num = _fleet[$ _types[e]];
        		if (_num > 0){
        			_ships_string +=  $"{_num} {string_plural(_type_names[e], _num)}\n";
        		}
        	}
            draw_text_transformed(_cur_fleet_x + _text_offset, yyy + 286, _ships_string, 0.7, 1, 0);
            draw_set_halign(fa_center);
            draw_set_font(fnt_40k_14b);
        }

        var _al_fleet_x = xxx + 342;
        var _text_offset = 32;
        for (var i = 0; i < array_length(battle_data.allied_fleets); i++){
        	var _fleet = battle_data.allied_fleets[i];
        	var _cur_fleet_x = _al_fleet_x + (110 * i)
        	scr_image("ui/force", _fleet.owner,  _cur_fleet_x, yyy + 237, 64, 64);
        	var _ships_string = "";
        	for (var e = 0; e < array_length(_types); e++){
        		var _num = _fleet[$ _types[e]];
        		if (_num > 0){
        			_ships_string +=  $"{_num} {string_plural(_type_names[e], _num)}\n";
        		}
        	}
            draw_text_transformed(_cur_fleet_x + _text_offset, yyy + 286, _ships_string, 0.7, 1, 0);
            draw_set_halign(fa_center);
            draw_set_font(fnt_40k_14b);
        }

        if (buttons.retreat.draw()){
        	flee_fleet_engagement();
        }

        if (buttons.fight.draw()){
        	start_fleet_engagement();
        }
	}

	draw_selector = function(){
	    var xxx = 535;
	    var yyy = 200;

	    draw_sprite(spr_purge_panel, 0, xxx, yyy);

	    if (battle_type == eBATTLE_TYPES.GROUNDFORCES) {
	        scr_image("attacked", 0, xxx + 12, yyy + 54, 254, 174);
	    }
	    else {
	        scr_image("attacked", 1, xxx + 12, yyy + 54, 254, 174);
	    }
	    draw_set_font(fnt_40k_14);
	    draw_set_halign(fa_left);
	    draw_set_color(c_gray);
	    draw_text(xxx + 8, yyy + 13, $"{obj_turn_end.current_battle}/{array_length(obj_turn_end.battles)}");

	    draw_set_halign(fa_center);
	    draw_set_font(fnt_40k_30b);

	    if (battle_type == eBATTLE_TYPES.GROUNDFORCES) {
	        draw_text_transformed(xxx + 265, yyy + 11, $"Forces Attacked! ({location} " + scr_roman(planet) + ")", 0.7, 0.7, 0);
	    }else {
	        draw_text_transformed(xxx + 265, yyy + 11, $"Fleet Attacked! ({location} System)", 0.7, 0.7, 0);
	    }

	    scr_image("ui/force", 1, xxx + 346, yyy + 54, 64, 64);

	    draw_set_font(fnt_40k_14);
	    draw_set_halign(fa_left);

	    if (battle_type == eBATTLE_TYPES.FLEET) {
	    	draw_fleet_selector();
	    }

	    else {
	        if (opponent <= 20) {
	            draw_text(xxx + 310, yyy + 118, $"{battle_data.marines} Marines");
	            draw_text(xxx + 310, yyy + 138, $"{battle_data.vehicles}  Vehicles");
	            if (battle_data.fortification != "") {
	                draw_text(xxx + 310, yyy + 158, $"{battle_data.fortification} Fortified");
	            } // Not / Barely / Lightly / Moderately / Highly / Maximally
	        }

	        draw_set_font(fnt_40k_14b);
	        draw_set_halign(fa_left);

	        draw_text(xxx + 12, yyy + 237, "Enemy Factions:");
	        draw_text(xxx + 332, yyy + 237, "Allies:");

	        draw_set_halign(fa_center);
	        scr_image("ui/force", opponent, xxx + 12, yyy + 257, 64, 64);
	        draw_text_transformed(xxx + 44, yyy + 316, battle_data.enemy_strength, 0.75, 1, 0);
	        draw_set_halign(fa_center);
	        draw_set_font(fnt_40k_14b);

	        var _offensive = buttons.offence.draw();
        	var _defensive = buttons.defence.draw();
        	if (_defensive || _offensive){
        		if (_defensive){
        			start_ground_battle("defensive")
        		} else {
        			start_ground_battle("offensive")
        		}
        	}
	    }		
	}
}
