function scr_target(_battle_block, _target_type = -1) {
	var _biggest_target = -1;
	var _priority_queue = ds_priority_create();
	var _dudes_names = _battle_block.dudes;
	var _dudes_hps = _battle_block.dudes_hp;
	var _dudes_nums = _battle_block.dudes_num;
	var _dudes_vehicles = _battle_block.dudes_vehicle;

	for (var i = 0, dudes_len = array_length(_dudes_names); i < dudes_len; i++) {
		if (_dudes_hps[i] <= 0 || _dudes_names[i] == "") {
			continue;
		}

		if (_target_type == -1 || _dudes_vehicles[i] == _target_type) {
			ds_priority_add(_priority_queue, i, _dudes_nums[i]);
		}
	}

	if (!ds_priority_empty(_priority_queue)) {
		_biggest_target = ds_priority_delete_max(_priority_queue);
	}

	ds_priority_destroy(_priority_queue);

	return _biggest_target;
}
