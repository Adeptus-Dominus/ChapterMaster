/// Grid combat prototype: input and simulation clock.

// Modal boot on the first step: freeze the whole game, keep only the cursor.
// Done here instead of Create so the launching cheat finishes its own event
// cleanly before deactivation sweeps the controller.
if (!boot_done) {
    boot_done = true;
    instance_deactivate_all(true);
    if (instance_exists(obj_cursor)) {
        instance_activate_object(obj_cursor);
    }
}

if (exit_arm > 0) {
    exit_arm -= 1;
}

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

hover_c = -1;
hover_r = -1;
if ((_mx >= GRIDC_BF_X) && (_my >= GRIDC_BF_Y) && (_mx < GRIDC_BF_X + GRIDC_COLS * GRIDC_TILE) && (_my < GRIDC_BF_Y + GRIDC_ROWS * GRIDC_TILE)) {
    hover_c = floor((_mx - GRIDC_BF_X) / GRIDC_TILE);
    hover_r = floor((_my - GRIDC_BF_Y) / GRIDC_TILE);
}

var _lc = mouse_check_button_pressed(mb_left);
var _rc = mouse_check_button_pressed(mb_right);

// End screen: only the Return button is live.
if (phase == GRIDPH_END) {
    if (_lc && point_in_rectangle(_mx, _my, 660, 560, 940, 616)) {
        instance_activate_all();
        instance_destroy();
    }
    exit;
}

// Formation creation popup (design point 5): scrollable, dismissed by
// right-click or a click outside the panel.
if (popup_open) {
    var _prc = grid_popup_rect();
    var _px = _prc[0];
    var _py = _prc[1];
    var _pw = _prc[2];
    var _ph = _prc[3];
    var _rows = grid_pool_indices(id, popup_type);
    var _vis = 8;
    var _maxs = max(0, array_length(_rows) - _vis);
    if (mouse_wheel_up()) {
        popup_scroll = max(0, popup_scroll - 1);
    }
    if (mouse_wheel_down()) {
        popup_scroll = min(_maxs, popup_scroll + 1);
    }
    popup_scroll = clamp(popup_scroll, 0, _maxs);

    if (_rc) {
        grid_clear_picks(id);
        popup_open = false;
        exit;
    }
    if (_lc) {
        if (!point_in_rectangle(_mx, _my, _px, _py, _px + _pw, _py + _ph)) {
            grid_clear_picks(id);
            popup_open = false;
            exit;
        }
        var _ps = grid_picked_stats(id);
        for (var _i = 0; _i < _vis; _i++) {
            var _ri = popup_scroll + _i;
            if (_ri >= array_length(_rows)) {
                break;
            }
            var _ry = _py + 46 + _i * 56;
            if (point_in_rectangle(_mx, _my, _px + 8, _ry, _px + _pw - 8, _ry + 52)) {
                var _sq = squads[_rows[_ri]];
                if (_sq.picked) {
                    _sq.picked = false;
                } else if (_ps.cost + _sq.cost <= points) {
                    _sq.picked = true;
                } else {
                    grid_log(id, "Not enough deployment points for that squad.", GRIDC_COL_WARN);
                }
            }
        }
        // Deploy button in the finalisation footer (design point 11)
        _ps = grid_picked_stats(id);
        if ((_ps.n > 0) && point_in_rectangle(_mx, _my, _px + _pw - 190, _py + _ph - 58, _px + _pw - 14, _py + _ph - 12)) {
            placing_list = grid_picked_indices(id);
            popup_open = false;
            placing = true;
        }
    }
    exit;
}

// Placement ghost (design points 2 and 6): left-click drops the block,
// right-click or Escape cancels and returns the picks to the pool.
if (placing) {
    if (_rc || keyboard_check_pressed(vk_escape)) {
        grid_clear_picks(id);
        placing = false;
        placing_list = [];
        exit;
    }
    if (_lc && (hover_c >= 0)) {
        if (grid_place_formation(id, hover_c, hover_r)) {
            placing = false;
        } else {
            grid_log(id, "Cannot place there: blocked or outside the deployment zone.", GRIDC_COL_WARN);
        }
    }
    exit;
}

// Panel buttons: hit-test the shared rect list from grid_buttons.
var _blist = grid_buttons(id);
var _consumed = false;
if (_lc) {
    for (var _b = 0; _b < array_length(_blist); _b++) {
        var _bt = _blist[_b];
        if (!_bt.benabled) {
            continue;
        }
        if (!point_in_rectangle(_mx, _my, _bt.bx, _bt.by, _bt.bx + _bt.bw, _bt.by + _bt.bh)) {
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
            grid_log(id, "Battle begins. The greenskins advance!", GRIDC_COL_WARN);
        } else if (_bid == "pause") {
            paused = !paused;
        } else if (_bid == "speed") {
            speed_mult = (speed_mult == 1) ? 2 : ((speed_mult == 2) ? 4 : 1);
        } else if (_bid == "exit") {
            if (exit_arm > 0) {
                instance_activate_all();
                instance_destroy();
                exit;
            }
            exit_arm = 90;
        } else if (_bid == "ord_adv") {
            if (selected_form >= 0) {
                formations[selected_form].order = GRIDORD_ADVANCE;
                formations[selected_form].order_target = -1;
                grid_log(id, $"{formations[selected_form].name}: advance!", GRIDC_COL_ORDER);
            }
        } else if (_bid == "ord_hold") {
            if (selected_form >= 0) {
                formations[selected_form].order = GRIDORD_HOLD;
                grid_log(id, $"{formations[selected_form].name}: hold position!", GRIDC_COL_ORDER);
            }
        }
        break;
    }
}

// Battlefield interaction: select formations, issue move, focus fire, recall.
if (!_consumed && (hover_c >= 0)) {
    var _hit = grid_squad_at(id, hover_c, hover_r);
    if (_lc) {
        if ((_hit >= 0) && (squads[_hit].side == 0)) {
            selected_form = squads[_hit].formation;
        } else if ((_hit < 0) && (selected_form >= 0) && (phase == GRIDPH_BATTLE)) {
            var _fm = formations[selected_form];
            _fm.order = GRIDORD_MOVE;
            _fm.dest_col = hover_c;
            _fm.dest_row = hover_r;
            _fm.order_target = -1;
            grid_log(id, $"{_fm.name}: reposition to {hover_c},{hover_r}.", GRIDC_COL_ORDER);
        } else if (_hit < 0) {
            selected_form = -1;
        }
    }
    if (_rc) {
        if ((_hit >= 0) && (squads[_hit].side == 1) && (selected_form >= 0) && (phase == GRIDPH_BATTLE)) {
            // Directed attack on a chosen enemy squad (design point 10)
            var _fa = formations[selected_form];
            _fa.order = GRIDORD_ATTACK;
            _fa.order_target = _hit;
            grid_log(id, $"{_fa.name}: concentrate fire on {squads[_hit].name}!", GRIDC_COL_ORDER);
        } else if ((_hit >= 0) && (squads[_hit].side == 0) && (phase == GRIDPH_DEPLOY)) {
            grid_undeploy_formation(id, squads[_hit].formation);
        } else {
            selected_form = -1;
        }
    }
} else if (!_consumed && _lc) {
    selected_form = -1;
}

// Selection sanity: a wiped or recalled formation cannot stay selected.
if (selected_form >= 0) {
    if ((selected_form >= array_length(formations)) || !formations[selected_form].alive) {
        selected_form = -1;
    }
}

// Hotkeys during battle.
if (phase == GRIDPH_BATTLE) {
    if (keyboard_check_pressed(vk_space)) {
        paused = !paused;
    }
    if ((selected_form >= 0) && keyboard_check_pressed(ord("H"))) {
        formations[selected_form].order = GRIDORD_HOLD;
        grid_log(id, $"{formations[selected_form].name}: hold position!", GRIDC_COL_ORDER);
    }
    if ((selected_form >= 0) && keyboard_check_pressed(ord("A"))) {
        formations[selected_form].order = GRIDORD_ADVANCE;
        formations[selected_form].order_target = -1;
        grid_log(id, $"{formations[selected_form].name}: advance!", GRIDC_COL_ORDER);
    }
}

// Battle simulation clock: speed multiplies frame accumulation.
if ((phase == GRIDPH_BATTLE) && !paused) {
    frame_ctr += speed_mult;
    while (frame_ctr >= GRIDC_TICK_FRAMES) {
        frame_ctr -= GRIDC_TICK_FRAMES;
        grid_battle_tick(id);
        if (phase != GRIDPH_BATTLE) {
            break;
        }
    }
}
