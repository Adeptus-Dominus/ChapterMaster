/// @description Input, camera, and the simulation clock.

if (!boot_done) {
    boot_done = true;
    instance_deactivate_all(true);
    // instance_exists cannot see deactivated instances, so a guard here would
    // always fail and leave the cursor frozen. Unconditional activation is a
    // safe no-op if no cursor instance is around.
    instance_activate_object(obj_cursor);

    grid_setup_field(id, pending_width);
    grid_gen_cover(id);
    // A bigger fight keeps coming for longer, so the wave count follows threat
    // rather than sitting at the prototype's flat one.
    waves_left = clamp(round(clamp(pending_threat, 1, 7) / 2), 1, 4);
    if (array_length(pending_force) > 0) {
        grid_import_force(id, pending_force);
    } else {
        grid_gen_player_pool(id);
    }
    grid_spawn_enemy_force(id);
    grid_centre_view(id, GRIDC_DEPLOY_COLS, floor(rows / 2));
    if (pending_loc != "") {
        grid_log(id, $"Battle for {pending_loc}.", eMSG_COLOR.BRIGHT_BLUE);
    }
    grid_log(id, $"The ground holds {combat_width} squads on the line. The rest follow as reserves.", eMSG_COLOR.BRIGHT_BLUE);
    if (pending_live) {
        grid_log(id, "Live battle: these are your real companies and your losses are permanent.", eMSG_COLOR.YELLOW);
    }
    grid_log(id, "Left click selects, drag a box to select several, right click orders.", eMSG_COLOR.AQUA);
    grid_log(id, "Deploying: drag out the front rank and the block forms along it.", eMSG_COLOR.AQUA);
    grid_log(id, "Ctrl and a number binds a control group, the number recalls it.", eMSG_COLOR.AQUA);
    grid_log(id, "WASD pans the field. Tab toggles the overview.", eMSG_COLOR.AQUA);
}

if (exit_arm > 0) {
    exit_arm -= 1;
}

// Scrollback over the log strip, same wheel and scrollbar handling as a vanilla
// battle. Scoped to the strip, so it never competes with the deployment popup's
// own wheel scrolling.
log.update_scroll(GRIDC_BF_X1 + 4, GRIDC_LOG_Y1, GRIDC_BF_X2 - GRIDC_BF_X1, GRIDC_LOG_Y2 - GRIDC_LOG_Y1);

var _mgx = device_mouse_x_to_gui(0);
var _mgy = device_mouse_y_to_gui(0);
var _lc = mouse_check_button_pressed(mb_left);
var _rc = mouse_check_button_pressed(mb_right);
var _lheld = mouse_check_button(mb_left);
var _lrel = mouse_check_button_released(mb_left);

// Floating combat text drifts and fades every frame, independent of sim speed,
// pause, popups, and the end screen; hit flashes decay alongside it.
for (var _fu = array_length(floaters) - 1; _fu >= 0; _fu--) {
    var _fe = floaters[_fu];
    _fe.frise += GRIDC_FLOAT_RISE;
    _fe.flife -= 1;
    if (_fe.flife <= 0) {
        array_delete(floaters, _fu, 1);
    }
}
for (var _hf = 0; _hf < array_length(squads); _hf++) {
    if (squads[_hf].hit_flash > 0) {
        squads[_hf].hit_flash -= 1;
    }
}
for (var _su = array_length(shots) - 1; _su >= 0; _su--) {
    shots[_su].life -= 1;
    if (shots[_su].life <= 0) {
        array_delete(shots, _su, 1);
    }
}

if (phase == GRIDPH_END) {
    if (_lc && point_in_rectangle(_mgx, _mgy, 660, 560, 940, 616)) {
        grid_exit(id);
    }
    exit;
}

hover_c = grid_mouse_col(id, _mgx);
hover_r = grid_mouse_row(id, _mgy);
if (!grid_in_viewport(_mgx, _mgy) || !grid_in_bounds(id, hover_c, hover_r)) {
    hover_c = -1;
    hover_r = -1;
}

// ---------------------------------------------------------------------------
// Deployment popup.
// ---------------------------------------------------------------------------
if (popup_open) {
    var _pr = grid_popup_rect();
    var _px = _pr[0];
    var _py = _pr[1];
    var _pw = _pr[2] - _pr[0];
    var _ph = _pr[3] - _pr[1];
    var _pool = grid_pool_indices(id, popup_type);
    var _rows_vis = 8;
    var _maxs = max(0, array_length(_pool) - _rows_vis);
    if (mouse_wheel_up()) {
        popup_scroll = max(0, popup_scroll - 1);
    }
    if (mouse_wheel_down()) {
        popup_scroll = min(_maxs, popup_scroll + 1);
    }
    if (_rc || (_lc && !point_in_rectangle(_mgx, _mgy, _px, _py, _px + _pw, _py + _ph))) {
        popup_open = false;
        grid_clear_picks(id);
        exit;
    }
    if (_lc) {
        for (var _i = 0; _i < _rows_vis; _i++) {
            var _idx = popup_scroll + _i;
            if (_idx >= array_length(_pool)) {
                break;
            }
            var _ry = _py + 52 + _i * 56;
            if (point_in_rectangle(_mgx, _mgy, _px + 8, _ry, _px + _pw - 8, _ry + 52)) {
                var _sq = squads[_pool[_idx]];
                if (_sq.picked) {
                    _sq.picked = false;
                } else {
                    var _ps0 = grid_picked_stats(id);
                    var _room0 = combat_width - grid_deployed_count(id);
                    if (_ps0.n >= _room0) {
                        grid_log(id, $"Only {_room0} squads still fit on the line.", eMSG_COLOR.YELLOW);
                    } else {
                        _sq.picked = true;
                    }
                }
            }
        }
        var _ps = grid_picked_stats(id);
        if ((_ps.n > 0) && point_in_rectangle(_mgx, _mgy, _px + _pw - 190, _py + _ph - 58, _px + _pw - 14, _py + _ph - 12)) {
            placing_list = grid_picked_indices(id);
            placing_w = max(1, ceil(sqrt(array_length(placing_list))));
            popup_open = false;
            placing = true;
        }
    }
    exit;
}

// ---------------------------------------------------------------------------
// Placing a block. Wheel reshapes it, R rotates it.
// ---------------------------------------------------------------------------
if (placing) {
    var _pln = array_length(placing_list);
    if (mouse_wheel_up()) {
        placing_w = min(max(1, _pln), placing_w + 1);
    }
    if (mouse_wheel_down()) {
        placing_w = max(1, placing_w - 1);
    }
    if (keyboard_check_pressed(ord("R"))) {
        placing_w = clamp(ceil(_pln / max(1, placing_w)), 1, max(1, _pln));
    }
    if (_rc || keyboard_check_pressed(vk_escape)) {
        placing = false;
        placing_list = [];
        grid_clear_picks(id);
        exit;
    }
    // Drag out the front rank the way a Total War player would: press where the
    // line starts, release where it ends, and the block forms along it. A plain
    // click with no drag still drops the old rectangle, so nothing that worked
    // before stops working.
    if (_lc && (hover_c >= 0)) {
        place_drag = true;
        place_c0 = hover_c;
        place_r0 = hover_r;
    }
    if (place_drag && _lrel) {
        place_drag = false;
        var _put = false;
        if (place_c0 >= 0) {
            if ((hover_c >= 0) && ((hover_c != place_c0) || (hover_r != place_r0))) {
                _put = grid_place_formation_slots(id, grid_drag_slots(id, place_c0, place_r0, hover_c, hover_r, _pln));
            } else {
                _put = grid_place_formation(id, place_c0, place_r0);
            }
        }
        if (!_put) {
            grid_log(id, "Cannot deploy there.", eMSG_COLOR.YELLOW);
        }
        place_c0 = -1;
        place_r0 = -1;
    }
    if (place_drag && !_lheld) {
        place_drag = false;
        place_c0 = -1;
        place_r0 = -1;
    }
    exit;
}

// ---------------------------------------------------------------------------
// Buttons.
// ---------------------------------------------------------------------------
var _consumed = false;
if (_lc) {
    var _btns = grid_buttons(id);
    for (var _bi = 0; _bi < array_length(_btns); _bi++) {
        var _bt = _btns[_bi];
        if (!_bt.benabled) {
            continue;
        }
        if (!point_in_rectangle(_mgx, _mgy, _bt.bx, _bt.by, _bt.bx + _bt.bw, _bt.by + _bt.bh)) {
            continue;
        }
        _consumed = true;
        var _bid = _bt.bid;
        if (string_copy(_bid, 1, 5) == "type:") {
            popup_type = string_delete(_bid, 1, 5);
            popup_open = true;
            popup_scroll = 0;
            grid_clear_picks(id);
        } else if (_bid == "deployall") {
            grid_deploy_all(id);
        } else if (_bid == "start") {
            phase = GRIDPH_BATTLE;
            grid_log(id, "Battle begins. The greenskins advance!", eMSG_COLOR.YELLOW);
        } else if (_bid == "pause") {
            paused = !paused;
        } else if (_bid == "speed") {
            speed_mult = (speed_mult == 0.5) ? 1 : ((speed_mult == 1) ? 2 : ((speed_mult == 2) ? 4 : 0.5));
        } else if (_bid == "zoom") {
            var _kc = (hover_c >= 0) ? hover_c : floor(cols / 2);
            var _kr = (hover_r >= 0) ? hover_r : floor(rows / 2);
            zoom_mode = (zoom_mode == 0) ? 1 : 0;
            grid_centre_view(id, _kc, _kr);
        } else if (_bid == "ord_adv") {
            for (var _oa = 0; _oa < array_length(selected); _oa++) {
                formations[selected[_oa]].order = GRIDORD_ADVANCE;
                formations[selected[_oa]].order_target = -1;
            }
            grid_log(id, "Advance and engage.", eMSG_COLOR.AQUA);
        } else if (_bid == "ord_hold") {
            for (var _oh = 0; _oh < array_length(selected); _oh++) {
                formations[selected[_oh]].order = GRIDORD_HOLD;
            }
            grid_log(id, "Hold position.", eMSG_COLOR.AQUA);
        } else if (_bid == "stance") {
            for (var _os = 0; _os < array_length(selected); _os++) {
                var _fs = formations[selected[_os]];
                _fs.stance = (_fs.stance + 1) mod 3;
            }
            if (array_length(selected) > 0) {
                var _sv = formations[selected[0]].stance;
                var _sl = (_sv == 1) ? "seek melee" : ((_sv == 2) ? "avoid melee" : "melee at will");
                grid_log(id, $"Stance: {_sl}.", eMSG_COLOR.AQUA);
            }
        } else if (_bid == "exit") {
            if (exit_arm > 0) {
                grid_exit(id);
                exit;
            }
            exit_arm = 90;
            if (pending_live) {
                grid_log(id, "Withdrawing hands the field to the enemy and is recorded as a defeat. Click again to confirm.", eMSG_COLOR.YELLOW);
            } else {
                grid_log(id, "Click Exit again to leave the prototype.", eMSG_COLOR.YELLOW);
            }
        }
        break;
    }
}

// ---------------------------------------------------------------------------
// Battlefield: left selects and drags, right commands. Standard RTS handling.
// ---------------------------------------------------------------------------
if (!_consumed && grid_in_viewport(_mgx, _mgy)) {
    if (_lc) {
        drag_active = true;
        drag_x0 = _mgx;
        drag_y0 = _mgy;
    }
    if (_rc) {
        var _hit = grid_squad_at(id, hover_c, hover_r);
        if ((_hit >= 0) && (squads[_hit].side == 1) && (array_length(selected) > 0)) {
            grid_order_attack(id, _hit);
            grid_log(id, $"Concentrate fire on {squads[_hit].name}!", eMSG_COLOR.AQUA);
        } else if ((_hit >= 0) && (squads[_hit].side == 0) && (phase == GRIDPH_DEPLOY)) {
            grid_undeploy_formation(id, squads[_hit].formation);
            grid_sel_prune(id);
        } else if ((hover_c >= 0) && (array_length(selected) > 0)) {
            grid_order_move(id, hover_c, hover_r);
            if (array_length(selected) > 1) {
                grid_log(id, $"{array_length(selected)} formations advance on {hover_c}, {hover_r} in formation.", eMSG_COLOR.AQUA);
            } else {
                grid_log(id, $"Move to {hover_c}, {hover_r}.", eMSG_COLOR.AQUA);
            }
        }
    }
}

if (drag_active && _lrel) {
    drag_active = false;
    // Every outcome is reported, including the empty ones. Silence on a failed
    // selection is indistinguishable from the input never arriving.
    if (point_distance(drag_x0, drag_y0, _mgx, _mgy) >= GRIDC_DRAG_MIN) {
        var _n = grid_sel_box(id, drag_x0, drag_y0, _mgx, _mgy);
        if (_n > 0) {
            grid_log(id, $"{_n} formations selected.", eMSG_COLOR.AQUA);
        } else {
            grid_log(id, "Nothing in the box: selection cleared.", eMSG_COLOR.YELLOW);
        }
    } else {
        var _pick = grid_squad_at(id, hover_c, hover_r);
        if ((_pick >= 0) && (squads[_pick].side == 0) && (squads[_pick].formation >= 0)) {
            grid_sel_clear(id);
            grid_sel_add(id, squads[_pick].formation);
            grid_log(id, $"{formations[squads[_pick].formation].name} selected.", eMSG_COLOR.AQUA);
        } else {
            grid_sel_clear(id);
            grid_log(id, "Selection cleared.", eMSG_COLOR.YELLOW);
        }
    }
}
if (drag_active && !_lheld) {
    drag_active = false;
}

grid_sel_prune(id);

// ---------------------------------------------------------------------------
// Camera and hotkeys.
// ---------------------------------------------------------------------------
if (keyboard_check(ord("A")) || keyboard_check(vk_left)) {
    view_x -= GRIDC_SCROLL_SPEED;
}
if (keyboard_check(ord("D")) || keyboard_check(vk_right)) {
    view_x += GRIDC_SCROLL_SPEED;
}
if (keyboard_check(ord("W")) || keyboard_check(vk_up)) {
    view_y -= GRIDC_SCROLL_SPEED;
}
if (keyboard_check(ord("S")) || keyboard_check(vk_down)) {
    view_y += GRIDC_SCROLL_SPEED;
}
grid_clamp_view(id);

// Control groups. Ctrl and a number binds the current selection, the number on
// its own recalls it, which is what every RTS has trained hands to expect.
var _ctrl_held = keyboard_check(vk_control);
for (var _gk = 0; _gk <= 9; _gk++) {
    if (!keyboard_check_pressed(ord(string(_gk)))) {
        continue;
    }
    if (_ctrl_held) {
        grid_group_bind(id, _gk);
    } else {
        var _gn = grid_group_recall(id, _gk);
        if (_gn > 0) {
            grid_log(id, $"Group {_gk} selected: {_gn} formations.", eMSG_COLOR.AQUA);
        }
    }
}

if (keyboard_check_pressed(vk_tab)) {
    var _tc = (hover_c >= 0) ? hover_c : floor(cols / 2);
    var _tr = (hover_r >= 0) ? hover_r : floor(rows / 2);
    zoom_mode = (zoom_mode == 0) ? 1 : 0;
    grid_centre_view(id, _tc, _tr);
}
if ((phase == GRIDPH_BATTLE) && keyboard_check_pressed(vk_space)) {
    paused = !paused;
}

// ---------------------------------------------------------------------------
// Simulation clock.
// ---------------------------------------------------------------------------
if ((phase == GRIDPH_BATTLE) && !paused && !popup_open && !placing) {
    frame_ctr += speed_mult;
    while (frame_ctr >= GRIDC_TICK_FRAMES) {
        frame_ctr -= GRIDC_TICK_FRAMES;
        grid_battle_tick(id);
        if (phase != GRIDPH_BATTLE) {
            break;
        }
    }
}
