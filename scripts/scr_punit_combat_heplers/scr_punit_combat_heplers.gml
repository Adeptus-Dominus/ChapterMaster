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

function pnunit_is_valid(target) {
	try {
		var _is_valid = false;
		if (instance_exists(target)) {
			if (target.x > 0 && target.object_index == obj_pnunit) {
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

function enunit_is_valid(target) {
	try {
		var _is_valid = false;
		if (instance_exists(target)) {
			if (target.x > 0 && target.object_index == obj_enunit) {
				if (target.unit_count() > 0) {
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

function block_type_size(target, type) {
	try {
		if (type == "men") {
			return (target.men * 0.5) + target.medi;
		} else if (type == "veh") {
			return (target.veh * 2.5);
		} else if (type == "dread") {
			return (target.dreads * 2);
		} else if (type == "armour") {
			return (target.veh * 2.5) + (target.dreads * 2);
		}
		return 0;
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
		return round(point_distance(x, y, block.x, block.y) / 10);
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

/// @description Check if the current position of the unit block collides with the other.
/// @param {real} position_x X position of the unit block
/// @param {real} position_y Y position of the unit block
/// @return {bool}
function block_position_collision(position_x, position_y) {
	try {
		return collision_point(position_x, position_y, obj_enunit, 0, 1) || collision_point(position_x, position_y, obj_pnunit, 0, 1);
	} catch (_exception) {
		handle_exception(_exception);
	}
}

/// @description Attempts to move an unit block and returns whenever the move succeeded or not.
/// @param {string} direction In what direction to move ("east" or "west")
/// @param {real} blocks How far to move (in unit blocks)
/// @param {bool} allow_collision Are unit blocks allowed to passthrough other unit blocks
/// @return {bool}
/// @mixin
function move_unit_block(direction, blocks = 1, allow_collision = false) {
    try {
        var distance = 10 * blocks;
        var _new_pos = x;
        
        if (direction == "east") {
            _new_pos = x + distance;
        } else if (direction == "west") {
            _new_pos = x - distance;
        }

        if (allow_collision == true || !block_position_collision(_new_pos, y)) {
			x = _new_pos;
			return true;
        } else {
			return false;
		}
    } catch (_exception) {
        handle_exception(_exception);
    }
}

function player_blocks_movement() {
	if (instance_exists(obj_nfort)) {
		exit;
	}

	if ((obj_ncombat.defending || obj_ncombat.player_formation == 2)) {
		exit;
	}

	var _player_movement_queue = ds_priority_create();
	with (obj_pnunit) {
		ds_priority_add(_player_movement_queue, id, x);
	}
	while (!ds_priority_empty(_player_movement_queue)) {
		var _player_block = ds_priority_delete_max(_player_movement_queue);
		with (_player_block) {
			move_unit_block("east");
		}
	}
	ds_priority_destroy(_player_movement_queue);
}

/// @mixin
function block_composition_string() {
    var _composition_string = "";

	_composition_string = $"{unit_count}x Total; ";
	if (men > 0) {
		_composition_string += $"{string_plural_count("Normal Unit", men)}; ";
	}
	if (medi > 0) {
		_composition_string += $"{string_plural_count("Big Unit", medi)}; ";
	}
	if (dreads > 0) {
		_composition_string += $"{string_plural_count("Walker", dreads)}; ";
	}
	if (veh > 0) {
		_composition_string += $"{string_plural_count("Vehicle", veh)}; ";
	}
	_composition_string += $"\n";


	_composition_string += arrays_to_string_with_counts(dudes, dudes_num, true, false);

	return _composition_string;
}

function draw_block_composition(_x1, _composition_string) {
	draw_set_alpha(1);
	draw_set_color(38144);
	draw_line_width(_x1+5,450,817,685, 2);
	draw_set_font(fnt_40k_14b);
	draw_text(817,688,"Row Composition:");
	draw_set_font(fnt_40k_14);
	draw_text_ext(817,710,_composition_string,-1,758);   
}

function draw_block_fadein() {
	if (obj_ncombat.fading_strength > 0) {
		draw_set_color(c_black);
		draw_set_alpha(obj_ncombat.fading_strength);
		draw_rectangle(822,239,1574,662,0);
		draw_set_alpha(1);
	}
}

/// @mixin
function update_block_size() {
	column_size = (men*0.5)+(medi)+(dreads*2)+(veh*2.5);
}

/// @mixin
function update_block_unit_count() {
	unit_count = men + medi + dreads + veh;
}

function get_valid_weapon_stacks(_stacks_struct, _range_min, _range_max) {
	try {
		var valid = [];
	
		var _weapon_stack_names = struct_get_names(_stacks_struct);
		var _struct_len = array_length(_weapon_stack_names);
		for (var i = 0; i < _struct_len; i++){
			var _weapon_stack_name = _weapon_stack_names[i];
			var _weapon_stack = _stacks_struct[$ _weapon_stack_name];
		
			if (_weapon_stack.weapon_name == "" || _weapon_stack.weapon_count == 0) {
				continue;
			}
	
			if (_weapon_stack.range == 0) {
				log_error($"{_weapon_stack.weapon_name} has broken range! This shouldn't happen!");
				continue;
			}
	
			if (_weapon_stack.range < _range_min || _weapon_stack.range > _range_max) {
				continue;
			}
	
			array_push(valid, _weapon_stack);
		}
	
		return valid;
	} catch (_exception) {
		show_debug_message($"_stacks_struct: {_stacks_struct}");
		show_debug_message($"_weapon_stack: {_weapon_stack}");
		handle_exception(_exception);
	}
}

function get_valid_weapon_stacks_unique(_stacks_struct, _range_min, _range_max) {
	try {
		var valid = [];
	
		var _unique_names = struct_get_names(_stacks_struct);
		var _unique_len = array_length(_unique_names);
		for (var u = 0; u < _unique_len; u++){
			var _unique_name = _unique_names[u];
			var _unique_stack = _stacks_struct[$ _unique_name];
		
			var _weapon_stack_names = struct_get_names(_unique_stack);
			var _stacks_len = array_length(_weapon_stack_names);
			for (var i = 0; i < _stacks_len; i++){
				var _weapon_stack_name = _weapon_stack_names[i];
				var _weapon_stack = _unique_stack[$ _weapon_stack_name];

				if (_weapon_stack.weapon_name == "" || _weapon_stack.weapon_count == 0) {
					continue;
				}
		
				if (_weapon_stack.range == 0) {
					log_error($"{_weapon_stack.weapon_name} has broken range! This shouldn't happen!");
					continue;
				}
		
				if (_weapon_stack.range < _range_min || _weapon_stack.range > _range_max) {
					continue;
				}
		
				array_push(valid, _weapon_stack);
			}
		}
	
		return valid;
	} catch (_exception) {
		show_debug_message($"_stacks_struct: {_stacks_struct}");
		show_debug_message($"_unique_stack: {_unique_stack}");
		show_debug_message($"_weapon_stack: {_weapon_stack}");
		handle_exception(_exception);
	}
}

function get_alpha_strike_target() {
    if (obj_ncombat.enemy_alpha_strike <= 0) {
        return -1;
    }

    obj_ncombat.enemy_alpha_strike -= 0.5;
    with (obj_pnunit) {
        for (var u = 0; u < array_length(unit_struct); u++) {
            if (marine_type[u] == "Chapter Master") {
                return [id, u];
            }
        }
    }

    return -1;
}

function get_target_priority(_weapon_stack, _block) {
    var _distance = get_block_distance(_block);
    var _size = _block.column_size;

    // Distance weight (closer = higher priority)
    var _distance_bonus = (_weapon_stack.range - _distance - 1) * 20;

    // Column size influence (bigger columns = higher threat?)
    var _doomstack_malus = _weapon_stack.weapon_count / _size;

    // Column size influence (bigger columns = higher threat?)
    var _size_bonus = _size / 10;

    // Target type match bonus
    // var _type_bonus = 0;
    // if (_weapon_stack.target_type == eUNIT_TYPE.Armour) {
    //     _type_bonus = 20 * (block_type_size(_block, "armour") / _size);
    // } else {
    //     _type_bonus = 20 * (block_type_size(_block, "men") / _size);
    // }

    var _priority = 0;
    // _priority += _type_bonus;
    _priority += _size_bonus;
    _priority -= _doomstack_malus;
    _priority += _distance_bonus;
    _priority *= random_range(0.5, 1.5);

    // if (DEBUG_COLUMN_PRIORITY_ENEMY) {
    //     show_debug_message($"Priority: {_priority}\n Type: +{_type_bonus}\n Size: +{_size_bonus}\n Doomstack: -{_doomstack_malus}\n Distance: +{_distance_bonus}\n");
    // }

    return _priority;
}
