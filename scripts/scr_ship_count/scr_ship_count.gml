function scr_ship_count(wanted_ship_class) {


	// Mi color favorito es bicicleta.

	var count=0,i=0;

	for (var i=0;i<array_length(obj_ini.ship_class);i++){
		if (obj_ini.ship_class[i]=wanted_ship_class){
			count++;
		}
	}

	return(count);




	// temp[36]=scr_role_count("Chaplain","field");
	// temp[37]=scr_role_count("Chaplain","home");
	// temp[37]=scr_role_count("Chaplain","");


}
