
function scr_kill_ship(index){
	try {
		with(obj_ini){
			var _units_on_ship = [];
			var _unit;
			for (var co=0;co<=companies;co++){
				for (var i=0;i<array_length(name[co]);i++){
					_unit = fetch_unit([co,i]);
					if (_unit.ship_location>-1){
						if (_unit.ship_location == index){
							if (!(irandom(_unit.luck)-3)){
								scr_kill_unit(_unit.company, _unit.marine_number);
							} else {
								array_push(_units_on_ship, _unit);
							}
						} else {
							if (_unit.ship_location>index){
								_unit.ship_location--;
							}
						}
					}
				}
				for (var i=0;i<array_length(veh_role[co]);i++){
					if (veh_lid[co][i]==index){
						reset_vehicle_variable_arrays(co, i);
					} else if (veh_lid[co][i]>index){
						veh_lid[co][i]--;
					}
				}
			}
			var in_warp = ship_location[index] == "Warp";
			var _available_ships = [];
			var _ship_fleet = find_ships_fleet(index);
			if (!in_warp){
				var _nearest_star = star_by_name(ship_location[index]);
			}
			if (_ship_fleet!="none"){
				delete_ship_from_fleet(index,_ship_fleet);
				_available_ships = fleet_full_ship_array(_ship_fleet);
			}
			_units_on_ship = array_shuffle(_units_on_ship);
			for (var i=0;i<array_length(_available_ships);i++){
				if (_available_ships[i]==index) then continue;
				var _cur_ship = _available_ships[i];
				var f=0;
				var _total_units = array_length(_units_on_ship);
				while (ship_carrying[_cur_ship]<ship_capacity[_cur_ship] && f<_total_units && array_length(_units_on_ship)>0){
					f++;
					if (_units_on_ship[0].get_unit_size()+ship_carrying[_cur_ship]<=ship_capacity[_cur_ship]){
						_units_on_ship[0].load_marine(_cur_ship);
						array_delete(_units_on_ship, 0, 1);
					}
				}
			}				
			array_delete(ship,index,1);
			array_delete(ship_uid,index,1);
			array_delete(ship_owner,index,1);
			array_delete(ship_class,index,1);
			array_delete(ship_size,index,1);
			array_delete(ship_leadership,index,1);
			array_delete(ship_hp,index,1);
			array_delete(ship_maxhp,index,1);

			array_delete(ship_location,index,1);
			array_delete(ship_shields,index,1);
			array_delete(ship_conditions,index,1);
			array_delete(ship_speed,index,1);
			array_delete(ship_turning,index,1);

			array_delete(ship_front_armour,index,1);
			array_delete(ship_other_armour,index,1);
			array_delete(ship_weapons,index,1);

			array_delete(ship_wep ,index,1);
			array_delete(ship_wep_condition,index,1);
			array_delete(ship_wep_facing,index,1);

			array_delete(ship_capacity,index,1);
			array_delete(ship_carrying,index,1);
			array_delete(ship_contents,index,1);
			array_delete(ship_turrets,index,1);

			if (!in_warp){
				if (_nearest_star!="none"){
					while(array_length(_units_on_ship)>0){
						_unit = array_pop(_units_on_ship);
						if (irandom(100)>100-_unit.luck){
							_unit.unload(irandom_range(1, _nearest_star.planets), _nearest_star);
						}
					}
				}
			}
			for (var i=0;i<array_length(_units_on_ship);i++){
				scr_kill_unit(_units_on_ship[i].company, _units_on_ship[i].marine_number)
			}
		}
	}catch(_exception) {
	    handle_exception(_exception);
	}
}

function scr_ini_ship_cleanup() {
	// If the ship is dead then make it fucking dead man
	with(obj_ini){
		if (array_length(ship)){
			for (var i=array_length(ship)-1;i>=0;i--){
			    if (ship[i]!="") and (ship_hp[i]<=0){
			        scr_kill_ship(i);
			    }
			}
		}
	}

}
