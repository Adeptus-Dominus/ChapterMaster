function squeeze_map_forces() {
    try {
        var _player_front_row = get_rightmost();
        var _enemy_front = get_leftmost(obj_enunit, false);
        if (_player_front_row != noone && _enemy_front != noone) {
            if (!collision_point(_player_front_row.x + 10, _player_front_row.y, obj_enunit, 0, 1)) {
                var _move_distance = calculate_block_distances(_player_front_row, _enemy_front) - 2;
                with (obj_pnunit) {
                    move_unit_block("east", _move_distance, true);
                }
            }
        }

        var _player_rear = get_leftmost();
        if (_player_rear != noone) {
            var _enemy_flank = get_rightmost(obj_enunit, true, false);
            if (_enemy_flank != noone) {
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
        ERROR_HANDLER.handle_exception(_exception);
    }
}

function target_block_is_valid(target, desired_type) {
    try {
        var _is_valid = false;
        if (target == noone) {
            return _is_valid;
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
        ERROR_HANDLER.handle_exception(_exception);
    }
}

function get_rightmost(block_type = obj_pnunit, include_flanking = true, include_main_force = true) {
    try {
        var rightmost = noone;
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
                if (rightmost == noone && x > 0) {
                    // Was block_type.id, which resolves to obj_pnunit.id (the first
                    // instance in the list) rather than the current instance in this
                    // with-loop, so the first valid block reaching here was recorded as
                    // whatever block was created first. When that first-created block
                    // was not the actual edge, get_rightmost returned the wrong block
                    // and the enemy fired on the wrong column even with the formation
                    // in correct order. Bug exists verbatim in upstream main.
                    rightmost = id;
                } else {
                    if (x > rightmost.x) {
                        rightmost = id;
                    }
                }
            }
        }
        return rightmost;
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

function block_has_armour(target) {
    try {
        return target.veh + target.dreads;
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

function get_leftmost(block_type = obj_pnunit, include_flanking = true) {
    try {
        var left_most = noone;
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
                if (left_most == noone && x > 0) {
                    // Same bug as get_rightmost above: block_type.id is the first
                    // instance in the list, not the current one, so the first valid
                    // block was recorded as the first-created block. This is why a
                    // flanking force (which targets get_leftmost, the rear column) hit
                    // the wrong line, striking the bulk block created first rather than
                    // the block actually closest to it. Bug exists verbatim in upstream.
                    left_most = id;
                } else {
                    if (x < left_most.x && x > 0) {
                        left_most = id;
                    }
                }
            }
        }
        return left_most;
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

function get_block_distance(block) {
    try {
        return point_distance(x, y, block.x, block.y) / 10;
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
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
        ERROR_HANDLER.handle_exception(_exception);
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
        ERROR_HANDLER.handle_exception(_exception);
    }
}

/// @description Attempts to move an unit block and returns whenever the move succeeded or not.
/// @param {string} direction In what direction to move ("east" or "west")
/// @param {real} blocks How far to move (in unit blocks)
/// @param {bool} allow_collision Are unit blocks allowed to passthrough other unit blocks
/// @param {bool} leapfrog When the destination is blocked by a FRIENDLY block, step into a
/// free parallel lane (offset from the home lane by PLAYER_LANE_OFFSET) and advance past it
/// instead of stalling, keeping this formation's own order; the block re-forms onto the home
/// lane once its column is clear (see move_player_block). Never steps onto a position an
/// enemy holds, so contact is still made by normal one-step movement and engagement.
/// @return {bool}
/// @self Asset.GMObject.obj_pnunit
function move_unit_block(direction, blocks = 1, allow_collision = false, leapfrog = false) {
    try {
        var distance = 10 * blocks;
        var _new_pos = x;
        var _step = 0;

        if (direction == "east") {
            _step = distance;
            _new_pos = x + distance;
        } else if (direction == "west") {
            _step = -distance;
            _new_pos = x - distance;
        }

        if (allow_collision == true || !block_position_collision(_new_pos, y)) {
            x = _new_pos;
            return true;
        }

        // Lane side-step (basic combat orders): a personally ordered formation blocked by
        // a friendly block ahead steps into a free parallel lane and advances past it,
        // keeping its own order, instead of teleporting over the line. It re-forms onto the
        // home lane once its column is clear (see move_player_block). It never steps onto a
        // position an enemy holds. This replaces the old leapfrog teleport, which jumped the
        // block to the next empty column and tangled formations (the back line snapping to
        // the front). Only manual orders pass leapfrog == true, so the auto-advancing body
        // never side-steps; it still advances to contact in lane.
        if (leapfrog && (_step != 0) && collision_point(_new_pos, y, obj_pnunit, 0, 1) && !collision_point(_new_pos, y, obj_enunit, 0, 1)) {
            var _lane_tries = [PLAYER_LANE_OFFSET, -PLAYER_LANE_OFFSET, PLAYER_LANE_OFFSET * 2, -PLAYER_LANE_OFFSET * 2];
            for (var _lt = 0; _lt < array_length(_lane_tries); _lt++) {
                var _lane_y = COMBAT_HOME_LANE_Y + _lane_tries[_lt];
                if (!block_position_collision(_new_pos, _lane_y)) {
                    x = _new_pos;
                    y = _lane_y;
                    return true;
                }
            }
        }

        return false;
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

/// @description Attempts to move an enemy unit block, choosing direction based on whenever they are flanking or not, only if `obj_nfort` doesn't exists.
/// @self Asset.GMObject.obj_enunit
function move_enemy_block() {
    if (instance_exists(obj_nfort)) {
        exit;
    }

    var _direction = flank ? "east" : "west";
    move_unit_block(_direction);
}

/// @description Creates a priority queue of enemy units based on their x-position and then moves each with `move_enemy_block()`.
function move_enemy_blocks() {
    var _enemy_movement_queue = ds_priority_create();
    with (obj_enunit) {
        ds_priority_add(_enemy_movement_queue, id, x);
    }
    while (!ds_priority_empty(_enemy_movement_queue)) {
        var _enemy_block = ds_priority_delete_min(_enemy_movement_queue);
        with (_enemy_block) {
            move_enemy_block();
        }
    }
    ds_priority_destroy(_enemy_movement_queue);
}

/// @self Asset.GMObject.obj_pnunit
/// @desc One player block's advance-to-contact step. Seeds this block's order on its
/// first tick (raids/attacks advance, defense/static hold), advances one column east if
/// ordered to (a personally ordered block leapfrogs; the auto-advancing body stops once
/// the formation has met the enemy line), then latches formation contact so blocks
/// processed later in the same front-first sweep hold instead of surging into gaps.
/// Extracted from obj_pnunit Alarm_0 so movement can run in a single ordered pass.
function move_player_block() {
    if (move_order == "") {
        move_order = (obj_ncombat.dropping || (!obj_ncombat.defending && obj_ncombat.formation_set != 2)) ? "advance" : "hold";
    }
    if ((move_order == "advance") && (veh_type[1] != "Defenses")) {
        if (order_manual) {
            move_unit_block("east", 1, false, true);
        } else if (!obj_ncombat.player_front_contact) {
            move_unit_block("east", 1, false, false);
        }
    }
    // Re-form: a formation that stepped into a parallel lane to pass slides back onto the
    // home lane as soon as its column there is clear, so the line closes up instead of
    // leaving blocks strung out in side lanes.
    if ((y != COMBAT_HOME_LANE_Y) && !block_position_collision(x, COMBAT_HOME_LANE_Y)) {
        y = COMBAT_HOME_LANE_Y;
    }
    if (collision_point(x + 14, y, obj_enunit, 0, 1)) {
        obj_ncombat.player_front_contact = true;
    }
}

/// @self Asset.GMObject.obj_controller
/// @desc Advance the whole player line front-first, mirroring move_enemy_blocks. Player
/// front is the high-x (east) side, so the queue is drained highest-x first: the frontmost
/// block advances and clears its column before the block behind it tries to move, so a rear
/// block (a Rhino sitting behind the infantry) no longer stalls against a slot the front
/// block has not vacated yet and drift out of the line. Replaces the old arbitrary
/// instance-order per-block advance in obj_pnunit Alarm_0.
function move_player_blocks() {
    var _player_movement_queue = ds_priority_create();
    with (obj_pnunit) {
        ds_priority_add(_player_movement_queue, id, x);
    }
    while (!ds_priority_empty(_player_movement_queue)) {
        var _player_block = ds_priority_delete_max(_player_movement_queue);
        if (instance_exists(_player_block)) {
            with (_player_block) {
                move_player_block();
            }
        }
    }
    ds_priority_destroy(_player_movement_queue);
}

/// @self Asset.GMObject.obj_enunit|Asset.GMObject.obj_pnunit
function block_composition_string() {
    var _composition_string = $"{unit_count}x Total; ";
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
    draw_set_color(CM_GREEN_COLOR);
    draw_line_width(_x1 + 5, 450, 817, 685, 2);
    draw_set_font(fnt_40k_14b);
    draw_text(817, 688, "Row Composition:");
    draw_set_font(fnt_40k_14);
    draw_text_ext(817, 710, _composition_string, -1, 758);
}

function draw_block_fadein() {
    if (obj_ncombat.fadein > 0) {
        draw_set_color(c_black);
        draw_set_alpha(obj_ncombat.fadein / 30);
        draw_rectangle(822, 239, 1574, 662, 0);
        draw_set_alpha(1);
    }
}

/// @self Asset.GMObject.obj_enunit|Asset.GMObject.obj_pnunit
function update_block_size() {
    column_size = (men * 0.5) + medi + (dreads * 2) + (veh * 2.5);
}

/// @self Asset.GMObject.obj_enunit|Asset.GMObject.obj_pnunit
function update_block_unit_count() {
    unit_count = men + medi + dreads + veh;
}
