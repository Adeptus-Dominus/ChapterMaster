function scr_ship_count(wanted_ship_class) {


	// Mi color favorito es bicicleta.

	var count=0,i=0;

	for (var i=0;i<array_length(obj_ini.ship_data);i++){
		var _ship = fetch_ship(i);
		if (_ship.class=wanted_ship_class){
			count++;
		}
	}

	return(count);




	// temp[36]=scr_role_count("Chaplain","field");
	// temp[37]=scr_role_count("Chaplain","home");
	// temp[37]=scr_role_count("Chaplain","");


}
