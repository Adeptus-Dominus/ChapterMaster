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

///@mixin FleetEvent
function mech_fleet_explore_battle_grounds(){
	var _navy_fleet = get_fleet_uid(fleet_uid);

	if (!is_orbiting(_navy_fleet)){
		return;
	}

	var _has_battle = system_feature_bool(orbiting.p_feature,P_features.OldBattleGround);
	if (_has_battle){
		var _p_data = orbiting.system_datas[_has_battle];
		_p_data.refresh_data();
	} else{
		return;
	}

	var _battle_ground = _p_data.get_features(P_features.OldBattleGround)[0];

	if (_battle_ground.explored == 0){
		var _text = $"The Mechanicus have arrived on {_p_data.name()} It will now be impossible to access the site without Mechanicus surveillance any potential rescources will now be fully put towards their aimsin service of the Ommnissiah";
		scr_popup($"Mechanicus Scavange {_p_data.name()}", _text, "mech");
	} else {
		var _marines = _p_data.collect_planet_group("all");
		if (array_length(_marines)){
			var _heritecs = obj_controller.tech_status == "heretics";
			if (_heritecs){
				_text = "The Rumours of the heretical practices of your marines have not gone un-noticed your presence is thusly even more enraging to mechanicus";
			}

		}
	}
}