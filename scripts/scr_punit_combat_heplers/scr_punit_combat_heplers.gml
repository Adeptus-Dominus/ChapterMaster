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
            if (target.x > -100 && target.object_index == desired_type) {
                if (target.men + target.veh + target.dreads > 0) {
                    _is_valid = true;
                } else {
                    target.x = -5000;
                    instance_deactivate_object(target);
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
                if (x < -100) {
                    continue;
                }
                if (block_type == obj_pnunit) {
                    if (men + veh + dreads <= 0) {
                        x = -5000;
                        instance_deactivate_object(id);
                        continue;
                    }
                }
                if (rightmost == noone && x > -100) {
                    // Was block_type.id, which resolves to obj_pnunit.id (the first
                    // instance in the list) rather than the current instance in this
                    // with-loop, so the first valid block reaching here was recorded as
                    // whatever block was created first. When that first-created block
                    // was not the actual edge, get_rightmost returned the wrong block
                    // and the enemy fired on the wrong column even with the formation
                    // in correct order. Bug exists verbatim in upstream main.
                    // Upstream (94ecc3f60) widened the bound from x > 0 to x > -100 so
                    // nearly-off-field blocks stay targetable and the enemy never
                    // disables itself hunting a valid edge.
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
                if (x < -100) {
                    continue;
                }
                if (block_type == obj_pnunit) {
                    if (men + veh + dreads <= 0) {
                        x = -5000;
                        instance_deactivate_object(id);
                        continue;
                    }
                }
                if (left_most == noone && x > -100) {
                    // Same bug as get_rightmost above: block_type.id is the first
                    // instance in the list, not the current one, so the first valid
                    // block was recorded as the first-created block. This is why a
                    // flanking force (which targets get_leftmost, the rear column) hit
                    // the wrong line, striking the bulk block created first rather than
                    // the block actually closest to it. Bug exists verbatim in upstream.
                    // Upstream (94ecc3f60) widened the bound from x > 0 to x > -100 so
                    // nearly-off-field blocks stay targetable and the enemy never
                    // disables itself hunting a valid edge.
                    left_most = id;
                } else {
                    if (x < left_most.x && x > -100) {
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
/// @desc Human-readable name for a formation type, for combat-log order confirmations.
function formation_display_name(_ftype) {
    switch (_ftype) {
        case "command": return "Command squad";
        case "honor": return "Honor Guard";
        case "librarian": return "Librarians";
        case "techmarine": return "Techmarines";
        case "terminator": return "Terminators";
        case "veteran": return "Veterans";
        case "tactical": return "Tactical Marines";
        case "devastator": return "Devastators";
        case "assault": return "Assault Marines";
        case "scout": return "Scouts";
        case "dreadnought": return "Dreadnoughts";
        case "hire": return "Hirelings";
        case "rhino": return "Rhinos";
        case "predator": return "Predators";
        case "landraider": return "Land Raiders";
        case "landspeeder": return "Land Speeders";
        case "whirlwind": return "Whirlwinds";
        case "deathco": return "Death Company";
    }
    return "formation";
}

/// @desc Battle block for a formation type ("tactical", "rhino", "deathco", ...). Blocks
/// are one per formation type rather than one per column, so two formations sharing a
/// column remain separate, individually orderable segments of that line instead of
/// merging into one blob. Finds the live block for the type, or creates it at the given
/// column (types with no units pre-created at battle start self-destroy; reinforcements
/// and Death Company arrive here). An empty type falls back to a per-column generic
/// block, mirroring the old one-block-per-column behaviour for anything untyped.
function formation_block(_ftype, _col) {
    if (_ftype == "") {
        _ftype = "col" + string(_col);
    }
    var _found = noone;
    with (obj_pnunit) {
        if (formation_type == _ftype) {
            _found = id;
            break;
        }
    }
    if (_found == noone) {
        _found = instance_create(_col * 10, 240, obj_pnunit);
        _found.formation_type = _ftype;
        // Mirror the battle-start alarm the pre-created blocks get from obj_ncombat's
        // Create, so a block created during the same-frame fill still runs its
        // started==0 accounting (player_forces / player_max) in Alarm_3.
        _found.alarm[3] = 1;
    }
    return _found;
}

/// @desc The enemy block this formation's ranged fire is aimed at. Default (0) is the
/// nearest (frontmost) enemy, matching vanilla. A focus-fire order (1..3, set by
/// right-clicking the formation's bar) aims at the Nth distinct enemy line by column
/// instead, falling back to the last line that exists. Melee always swings at the
/// nearest enemy regardless (a focused far line would fail the melee distance gate).
/// @self Asset.GMObject.obj_pnunit
function block_fire_target() {
    var _nearest = instance_nearest(0, y, obj_enunit);
    if (fire_target_line <= 0) {
        return _nearest;
    }
    var _cols = [];
    with (obj_enunit) {
        var _known = false;
        for (var _c = 0; _c < array_length(_cols); _c++) {
            if (_cols[_c] == x) {
                _known = true;
                break;
            }
        }
        if (!_known) {
            array_push(_cols, x);
        }
    }
    if (array_length(_cols) == 0) {
        return _nearest;
    }
    array_sort(_cols, true);
    var _idx = min(fire_target_line, array_length(_cols)) - 1;
    return instance_nearest(_cols[_idx], y, obj_enunit);
}

/// @param {bool} allow_collision Are unit blocks allowed to passthrough other unit blocks
/// @param {bool} leapfrog Retained for callers; the move-through behaviours this once
/// enabled (leapfrog teleport, parallel-lane pass) were tried and reverted, so a block
/// blocked by a friendly currently just holds. Movement-through will return with the
/// per-unit-type formation rework.
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

        // Formation merge (manual orders, player blocks only): a personally ordered
        // formation may enter a column held by friendly blocks. Per-type blocks coexist
        // in the same line as separate, individually orderable segments (drawn stacked),
        // so a formation moves through or joins another line without losing its own
        // order. Never onto a position an enemy holds, so contact still stops movement.
        // The seeded auto-advance keeps vanilla stall behaviour so the body forms a line
        // behind the front instead of piling into the front block's column.
        if (leapfrog && (object_index == obj_pnunit) && (_step != 0)
            && collision_point(_new_pos, y, obj_pnunit, 0, 1) && !collision_point(_new_pos, y, obj_enunit, 0, 1)) {
            x = _new_pos;
            return true;
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
    // Rear-guard delay: while this is the last fighting formation, it accrues hold
    // time; after RETREAT_REARGUARD_HOLD passes it may withdraw too.
    if ((move_order != "retreat") && (veh_type[1] != "Defenses") && instance_exists(obj_enunit)) {
        if (player_fighting_blocks_count() <= 1) {
            rearguard_ticks += 1;
            if (rearguard_ticks == RETREAT_REARGUARD_HOLD) {
                obj_ncombat.combat_log.push($"The {formation_display_name(formation_type)} have bought enough time; they may withdraw!", eMSG_COLOR.WHITE);
            }
        }
    }
    if ((move_order == "retreat") && (veh_type[1] != "Defenses")) {
        // Retreat: withdraw one column west per turn, merging back through friendly
        // lines (never onto an enemy), unable to fire and heavily protected (see
        // RETREAT_DAMAGE_MULT), until the formation leaves the field edge.
        if (x > 10) {
            if (move_unit_block("west", 1, false, true)) {
                moved_this_sweep = true;
            }
        } else if (!retreat_departed) {
            retreat_departed = true;
            obj_ncombat.combat_log.push($"The {formation_display_name(formation_type)} have withdrawn from the field.", eMSG_COLOR.WHITE);
            // Actually leave play: park past the -100 targeting bound, invisible and
            // out of melee reach. The instance stays alive so live-applied casualties
            // and the survivor return keep working; player_all_departed() below ends
            // the battle once no fighting blocks remain.
            x = RETREAT_ESCAPED_X;
            visible = false;
            engaged = 0;
        }
    }
    if ((move_order == "advance") && (veh_type[1] != "Defenses")) {
        // Assault jump: a personally ordered Assault formation within leaping range of
        // the enemy front vaults straight to contact (once per battle) instead of
        // closing a column at a time. Lands just short of the frontmost enemy, never on
        // one; friendly blocks there coexist per the formation-merge rule.
        if ((formation_type == "assault") && (fire_target_line == 1) && !assault_jumped && instance_exists(obj_enunit)) {
            var _front_x = 100000;
            with (obj_enunit) {
                if (x < _front_x) {
                    _front_x = x;
                }
            }
            if (((_front_x - x) > 10) && ((_front_x - x) <= ASSAULT_JUMP_RANGE)) {
                x = _front_x - 10;
                assault_jumped = true;
                moved_this_sweep = true;
                obj_ncombat.combat_log.push($"The {formation_display_name(formation_type)} leap into the fray!", eMSG_COLOR.AQUA);
            }
        }
        if (order_manual) {
            if (move_unit_block("east", 1, false, true)) {
                moved_this_sweep = true;
            }
        } else if (!obj_ncombat.player_front_contact) {
            if (move_unit_block("east", 1, false, false)) {
                moved_this_sweep = true;
            } else {
                // Lockstep for stacked segments. The plain auto-advance keeps the vanilla
                // stall (a block never enters an occupied column), which made segments
                // sharing a column step off one turn apart: on turn one only stack leaders
                // and solo blocks (the lone Predator) moved, the line advanced as an
                // arrowhead, and once the front-contact latch tripped the trailing
                // segments froze mid-field for the rest of the battle. Merge into the
                // destination column only when NO enemy holds it and EVERY friendly block
                // standing there moved during this same sweep: a stack follows its leader
                // in the same turn and advances as one line, while a HOLDING block still
                // dams everything behind it exactly as before.
                var _dest_x = x + 10;
                if (collision_point(_dest_x, y, obj_enunit, 0, 1) == noone) {
                    var _any_friendly = false;
                    var _all_moved = true;
                    with (obj_pnunit) {
                        if (id == other.id) {
                            continue;
                        }
                        if ((_dest_x >= bbox_left) && (_dest_x <= bbox_right) && (other.y >= bbox_top) && (other.y <= bbox_bottom)) {
                            _any_friendly = true;
                            if (!moved_this_sweep) {
                                _all_moved = false;
                                break;
                            }
                        }
                    }
                    if (_any_friendly && _all_moved) {
                        x = _dest_x;
                        moved_this_sweep = true;
                    }
                }
            }
        }
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
    // Fresh sweep: nobody has moved yet. The lockstep merge in move_player_block only
    // follows blocks that genuinely stepped during THIS sweep.
    with (obj_pnunit) {
        moved_this_sweep = false;
    }
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
    column_size = men + (medi * 3) + (dreads * 6) + (veh * 8);
}

/// @self Asset.GMObject.obj_enunit|Asset.GMObject.obj_pnunit
function update_block_unit_count() {
    unit_count = men + medi + dreads + veh;
}

/// Fighting player formations: on the field, not retreating, not the Defenses
/// pseudo-block. The retreat rules key off this count (rear-guard rule).
function player_fighting_blocks_count() {
    var _n = 0;
    with (obj_pnunit) {
        if ((veh_type[1] == "Defenses") || retreat_departed || (move_order == "retreat")) {
            continue;
        }
        _n += 1;
    }
    return _n;
}

/// True when player blocks remain but every one of them has withdrawn off-field:
/// the fighting withdrawal is complete and the battle should resolve as the field
/// being ceded (survivors keep their live-applied casualties and return home).
function player_all_departed() {
    if (!instance_exists(obj_pnunit)) {
        return false;
    }
    var _fighting = false;
    with (obj_pnunit) {
        if (!retreat_departed) {
            _fighting = true;
            break;
        }
    }
    return !_fighting;
}
