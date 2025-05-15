function scr_return_ship(ship_name, object, planet_number) {

	// ship_name: name of ship
	// object: object with man_selecting
	// planet_number: planet number
	var man_size,i;
	i=0;man_size=0;

	i=0;

	var unit;
	var return_planet = obj_controller.return_object;
	with (object){
		var man_size
		for (var i=0; i<array_length(display_unit);i++){
			if (object.man_sel[i]>0){
				unit = display_unit[i];
				if (is_struct(unit)){
		            if (return_place[i]>0){
		            	unit.load_marine(return_place[i], return_planet);
		        	}
				} else if (is_array(unit)) {
					 if (return_place[i]>0){
						obj_ini.veh_lid[unit[0]][unit[1]]=return_place[i];
						obj_ini.veh_wid[unit[0]][unit[1]]=0;
						var man_size =scr_unit_size("",obj_ini.veh_role[unit[0]][unit[1]], true);
						return_planet.p_player[planet_number]-=man_size;
						var _ship = obj_ini.ship_data[return_place[i]];
						_ship.carrying += man_size;
					 }
				}
			}
		}	
	}
}
