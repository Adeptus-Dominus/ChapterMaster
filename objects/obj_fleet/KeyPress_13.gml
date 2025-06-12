

//this is key press enter because who the fuck knows whar keypress_13 is
var _cool = obj_controller.cooldown;
if (_cool){
	exit;
}

//why 7? idk ask duke
if (start != 7){
	{
		start = 5;
		// show_message(string(ships_max));

		/*en_capital_max=en_capital;
		en_frigate_max=en_frigate;
		en_escort_max=en_escort;*/

		beg=1;

		/* */
	}
}else {

	// End battle crap heres

	instance_activate_all();
	room_speed=30;
	wait_and_execute(1, ship_combat_cleanup,[] , self);

	/* */
}
/*  */
