function scr_target(battle_block, man_or_vehicle = "any") {
	var _biggest_target = -1;
	var _priority_queue = ds_priority_create();
	var _target = -1;
	var _dudes_names = battle_block.dudes;
	var _dudes_hps = battle_block.dudes_hp;
	var _dudes_nums = battle_block.dudes_num;
	var _dudes_vehicles = battle_block.dudes_vehicle;

	if (man_or_vehicle == "arp") {
		_target = 1;
	} else if (man_or_vehicle == "att") {
		_target = 0;
	}

	for (var i = 0, dudes_len = array_length(_dudes_names); i < dudes_len; i++) {
		if (_dudes_hps[i] <= 0 || _dudes_names[i] == "") {
			continue;
		}

		if (_target == -1 || _dudes_vehicles[i] == _target) {
			ds_priority_add(_priority_queue, i, _dudes_nums[i]);
		}
	}

	if (!ds_priority_empty(_priority_queue)) {
		_biggest_target = ds_priority_delete_max(_priority_queue);
	}

	ds_priority_destroy(_priority_queue);

	return _biggest_target;
}
