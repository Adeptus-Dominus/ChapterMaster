function scr_add_corruption(is_fleet, modifier_type) {

	// is_fleet: fleet (true) or planet (false)
	// modifier_type: amount

	// Corrupts marines at the target location

	var shi,m,co,ide, unit;
	shi=0;m=0;co=0;ide=0;
	ships = [];

	if (is_fleet=true){
		var _ships = fleet_full_ship_array();
		for (var i=0;i<array_length(_ships);i++){
			var _ship = obj_ini.ship_data[_ships[i]];
			if (_ship.carrying){
				array_push(ships, _ships[i]);
			}
		} 
		for (var co=0;co<=10;co++){
			for (var i=0;i<array_length(obj_ini.name[co]);i++){
				if (obj_ini.name[co][i] == "") then continue;
				unit = fetch_unit([co,i]);
				if (array_contains(ships, unit.ship_location)){
					if (modifier_type=="1d3") then unit.edit_corruption(choose(1,2,3));
				}
			}
		}
	}
}
