// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function squeeze_map_forces() {
	try {
		var _player_front_row = get_rightmost();
		var _enemy_front = get_leftmost(obj_enunit, false);
		if (_player_front_row != "none" && _enemy_front != "none") {
			if (!collision_point(_player_front_row.x + 10, _player_front_row.y, obj_enunit, 0, 1)) {
				var _enemy_front = get_leftmost(obj_enunit, false);
				if (_enemy_front != "none") {
					var _move_distance = calculate_block_distances(_player_front_row, _enemy_front) - 2;
					with (obj_pnunit) {
						move_unit_block("east", _move_distance, true);
					}
				}
			}
		}

		/* var _enemy_front =  get_leftmost(obj_enunit, false);
		if (_enemy_front!="none"){
			var _player_front_row=get_rightmost();
			if (_player_front_row!="none"){
				var _move_distance = calculate_block_distances(_player_front_row, _enemy_front) -1;
				with (obj_enunit){
					if (!flank && _player_front_row.x<x){
						move_unit_block("west", _move_distance);
					}
				}
			}
		}*/

		var _player_rear = get_leftmost();
		if (_player_rear != "none") {
			var _enemy_flank = get_rightmost(obj_enunit, true, false);
			if (_enemy_flank != "none") {
				if (_enemy_flank.flank) {
					var _move_distance = calculate_block_distances(_player_rear, _enemy_flank) - 1;
					with (obj_enunit) {
						if (flank && _player_rear.x > x) {
							move_unit_block("east", _move_distance, true);
						}
					}
				}
			}
		}
	} catch (_exception) {
		handle_exception(_exception);
	}
}

function target_block_is_valid(target, desired_type) {
	try {
		var _is_valid = false;
		if (target == "none") {
			return false;
		}
		if (instance_exists(target)) {
			if (target.x > 0 && target.object_index == desired_type) {
				if (target.men + target.veh + target.dreads > 0) {
					_is_valid = true;
				} else {
					x = -5000;
					instance_deactivate_object(id);
				}
			}
		}
		return _is_valid;
	} catch (_exception) {
		handle_exception(_exception);
	}
}

function get_rightmost(block_type = obj_pnunit, include_flanking = true, include_main_force = true) {
	try {
		var rightmost = "none";
		if (instance_exists(block_type)) {
			with (block_type) {
				if (!include_flanking && flank) {
					continue;
				}
				if (!include_main_force && !flank) {
					continue;
				}
				if (x <= 0) {
					continue;
				}
				if (block_type == obj_pnunit) {
					if (men + veh + dreads <= 0) {
						x = -5000;
						instance_deactivate_object(id);
						continue;
					}
				}
				if (rightmost == "none" && x > 0) {
					rightmost = block_type.id;
				} else {
					if (x > rightmost.x) {
						rightmost = id;
					}
				}
			}
		}
		return rightmost;
	} catch (_exception) {
		handle_exception(_exception);
	}
}

function block_has_armour(target) {
	try {
		return target.veh + target.dreads;
	} catch (_exception) {
		handle_exception(_exception);
	}
}

function get_leftmost(block_type = obj_pnunit, include_flanking = true) {
	try {
		var left_most = "none";
		if (instance_exists(block_type)) {
			with (block_type) {
				if (!include_flanking && flank) {
					continue;
				}
				if (x <= 0) {
					continue;
				}
				if (block_type == obj_pnunit) {
					if (men + veh + dreads <= 0) {
						x = -5000;
						instance_deactivate_object(id);
						continue;
					}
				}
				if (left_most == "none" && x > 0) {
					left_most = block_type.id;
				} else {
					if (x < left_most.x && x > 0) {
						left_most = id;
					}
				}
			}
		}
		return left_most;
	} catch (_exception) {
		handle_exception(_exception);
	}
}

function get_block_distance(block) {
	try {
		return point_distance(x, y, block.x, block.y) / 10;
	} catch (_exception) {
		handle_exception(_exception);
	}
}

function calculate_block_distances(first_block, second_block) {
	try {
		if (first_block.x == second_block.x) {
			return 0;
		} else {
			if (first_block.x < second_block.x) {
				var _temp_holder = second_block;
				second_block = first_block;
				first_block = _temp_holder;
			}
		}
		return floor(floor((first_block.x - second_block.x) / 10));
	} catch (_exception) {
		handle_exception(_exception);
	}
}

function block_position_collision(position_x, position_y) {
	try {
		return collision_point(position_x, position_y, obj_enunit, 0, 1) || collision_point(position_x, position_y, obj_pnunit, 0, 1);
	} catch (_exception) {
		handle_exception(_exception);
	}
}

function move_unit_block(direction = "east", blocks = 1, allow_collision = false, allow_passing = false) {
	try {
		distance = 10 * blocks;
		if (direction == "east") {
			var _new_pos = x + distance;
			if (allow_collision == false) {
				if (!block_position_collision(_new_pos, y)) {
					x = _new_pos;
				}
			} else {
				x = _new_pos;
			}
		} else if (direction == "west") {
			var _new_pos = x - distance;
			if (allow_collision == false) {
				if (!block_position_collision(_new_pos, y)) {
					x = _new_pos;
				}
			} else {
				x = _new_pos;
			}
		}
	} catch (_exception) {
		handle_exception(_exception);
	}
}
