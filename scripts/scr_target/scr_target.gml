function scr_target(_battle_block, _target_type = -1) {
	var _biggest_target = noone;
	var _priority_queue = ds_priority_create();
	var _unit_stacks = _battle_block.unit_stacks;

	for (var i = 0, dudes_len = array_length(_unit_stacks); i < dudes_len; i++) {
		var _unit_stack = _unit_stacks[i];
		var _unit_stack_count = _unit_stack.count;
		var _unit_stack_type = _unit_stack.unit_type;

		if (_target_type == -1 || _unit_stack_type == _target_type) {
			ds_priority_add(_priority_queue, _unit_stack, _unit_stack_count);
		}
	}

	if (!ds_priority_empty(_priority_queue)) {
		_biggest_target = ds_priority_delete_max(_priority_queue);
	}

	ds_priority_destroy(_priority_queue);

	return _biggest_target;
}
