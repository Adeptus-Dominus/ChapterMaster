function scr_target(battle_block, man_or_vehicle) {
	var _biggest_target = -1;
	var _priority_queue = ds_priority_create();
	var _target;

	if (man_or_vehicle == "arp"){
		_target = 1;
	}else if (man_or_vehicle == "att"){
		_target = 0;
	} else {
		_target = -1;
	}

	for (var i = 0, dudes_len = array_length(battle_block.dudes); i < dudes_len; i++) {
		if (battle_block.dudes_hp[i] <= 0 || battle_block.dudes[i] == "") {
			continue;
		}

		if (_target == -1 || battle_block.dudes_vehicle[i] == _target) {
			ds_priority_add(_priority_queue, i, battle_block.dudes_num[i]);
		}
	}

	_biggest_target = ds_priority_delete_max(_priority_queue);
	ds_priority_destroy(_priority_queue);

	return _biggest_target;
}
