function spawn_mechanicus_explore_fleet(){

	var _forges = get_imperium_forge_systems();
	if (!array_length(_forges)){
		return -1;
	}

	var _forge = array_random_element(_forges);
	var _fleet = instance_create(_forge.x, _forge.y, obj_en_fleet);

	with (_fleet){
		owner = eFACTION.Mechanicus;
		warp_able = true;
		capital_number = 2;
		frigate_number = 5;
		escort_number = 20;
		navy = 0;
		choose_fleet_sprite_image();
	}

	return _fleet;
}