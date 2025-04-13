// Records or nullifies the association between a vehicle and its last ship
function set_vehicle_last_ship(vehic_array, empty = false) {
	if (!empty) {
		var vehic_ini = obj_ini.veh_lid[vehic_array[0]][vehic_array[1]];
		var _last_ship_data = {
			uid : obj_ini.ship_uid[vehic_ini],
			name : obj_ini.ship[vehic_ini],
		}
	} else {
		var _last_ship_data = {
			uid : "",
			name : "",
		}		
	}
	obj_ini.last_ship[vehic_array[0]][vehic_array[1]] = _last_ship_data;
}
