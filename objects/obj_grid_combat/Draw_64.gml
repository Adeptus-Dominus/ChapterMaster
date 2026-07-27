/// @description All rendering. Fixed 1600x900 GUI, vanilla green on black.

// The field is built in the first Step; Draw can fire before that on the frame
// the object is created, so there is nothing to render yet.
if (!boot_done) {
    exit;
}

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _tp = grid_tile_px(id);

draw_set_alpha(1);
draw_set_font(fnt_40k_14);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// backdrop
draw_set_color(GRIDC_BG);
draw_rectangle(0, 0, 1600, 900, false);

// title bar
draw_set_color(GRIDC_GREEN);
draw_rectangle(GRIDC_LP_X1, 8, GRIDC_RP_X2, 48, true);
var _ph_name = (phase == GRIDPH_DEPLOY) ? "Deployment" : ((phase == GRIDPH_BATTLE) ? "Battle" : "Resolved");
draw_text(GRIDC_LP_X1 + 10, 16, $"Grid Combat ( Front {combat_width} ) - {_ph_name} - Tick {ticks}");
draw_set_halign(fa_right);
var _online = grid_deployed_count(id);
var _inres = grid_reserve_count(id);
draw_text(GRIDC_RP_X2 - 10, 16, $"On the line {_online} / {combat_width}   Reserve {_inres}");
draw_set_halign(fa_left);

// ---------------------------------------------------------------------------
// Battlefield
// ---------------------------------------------------------------------------
draw_set_color(GRIDC_PANEL);
draw_rectangle(GRIDC_BF_X1, GRIDC_BF_Y1, GRIDC_BF_X2, GRIDC_BF_Y2, false);

var _c0 = clamp(floor(view_x / _tp), 0, max(0, cols - 1));
var _c1 = clamp(ceil((view_x + (GRIDC_BF_X2 - GRIDC_BF_X1)) / _tp), 0, cols);
var _r0 = clamp(floor(view_y / _tp), 0, max(0, rows - 1));
var _r1 = clamp(ceil((view_y + (GRIDC_BF_Y2 - GRIDC_BF_Y1)) / _tp), 0, rows);

// zone tints
draw_set_alpha(0.14);
draw_set_color(GRIDC_GREEN);
var _dzx1 = max(GRIDC_BF_X1, grid_sx(id, 0));
var _dzx2 = min(GRIDC_BF_X2, grid_sx(id, GRIDC_DEPLOY_COLS));
var _dzy1 = max(GRIDC_BF_Y1, grid_sy(id, band_r1));
var _dzy2 = min(GRIDC_BF_Y2, grid_sy(id, band_r2 + 1));
if ((_dzx2 > _dzx1) && (_dzy2 > _dzy1)) {
    draw_rectangle(_dzx1, _dzy1, _dzx2, _dzy2, false);
}
draw_set_color(GRIDC_RED);
var _ezx1 = max(GRIDC_BF_X1, grid_sx(id, cols - GRIDC_ENEMY_COLS));
var _ezx2 = min(GRIDC_BF_X2, grid_sx(id, cols));
if (_ezx2 > _ezx1) {
    draw_rectangle(_ezx1, max(GRIDC_BF_Y1, grid_sy(id, 0)), _ezx2, min(GRIDC_BF_Y2, grid_sy(id, rows)), false);
}

// grid dividers
draw_set_alpha(0.30);
draw_set_color(GRIDC_DIM);
for (var _gc = _c0; _gc <= _c1; _gc++) {
    var _gx = grid_sx(id, _gc);
    if ((_gx >= GRIDC_BF_X1) && (_gx <= GRIDC_BF_X2)) {
        draw_line(_gx, max(GRIDC_BF_Y1, grid_sy(id, 0)), _gx, min(GRIDC_BF_Y2, grid_sy(id, rows)));
    }
}
for (var _gr = _r0; _gr <= _r1; _gr++) {
    var _gy = grid_sy(id, _gr);
    if ((_gy >= GRIDC_BF_Y1) && (_gy <= GRIDC_BF_Y2)) {
        draw_line(max(GRIDC_BF_X1, grid_sx(id, 0)), _gy, min(GRIDC_BF_X2, grid_sx(id, cols)), _gy);
    }
}
draw_set_alpha(1);

// cover
if (_tp >= 14) {
    draw_set_font(fnt_tiny);
    for (var _cc = _c0; _cc < _c1; _cc++) {
        for (var _cr = _r0; _cr < _r1; _cr++) {
            var _cv = cov[_cc][_cr];
            if (_cv == 0) {
                continue;
            }
            draw_set_color((_cv == 1) ? GRIDC_GREEN : GRIDC_RED);
            draw_set_alpha(0.55);
            draw_text(grid_sx(id, _cc) + 3, grid_sy(id, _cr) + 2, (_cv == 1) ? "~~" : "xx");
        }
    }
    draw_set_alpha(1);
}

// hover
if ((hover_c >= 0) && (phase != GRIDPH_END)) {
    draw_set_alpha(0.20);
    draw_set_color(GRIDC_GREEN);
    draw_rectangle(grid_sx(id, hover_c), grid_sy(id, hover_r), grid_sx(id, hover_c) + _tp, grid_sy(id, hover_r) + _tp, false);
    draw_set_alpha(1);
}

// order markers for selected formations
for (var _sf = 0; _sf < array_length(selected); _sf++) {
    var _fo = formations[selected[_sf]];
    if (_fo.order == GRIDORD_MOVE) {
        draw_set_color(GRIDC_COL_ORDER);
        var _dx = grid_sx(id, _fo.dest_col);
        var _dy = grid_sy(id, _fo.dest_row);
        draw_rectangle(_dx + 3, _dy + 3, _dx + _tp - 3, _dy + _tp - 3, true);
    }
    if ((_fo.order == GRIDORD_ATTACK) && (_fo.order_target >= 0) && squads[_fo.order_target].alive) {
        var _tg = squads[_fo.order_target];
        draw_set_color(GRIDC_RED);
        var _tx = grid_sx(id, _tg.col);
        var _ty = grid_sy(id, _tg.row);
        draw_rectangle(_tx + 2, _ty + 2, _tx + _tp - 2, _ty + _tp - 2, true);
    }
}

// units
for (var _ui = 0; _ui < array_length(squads); _ui++) {
    var _s = squads[_ui];
    if (!_s.alive || !_s.deployed) {
        continue;
    }
    if ((_s.col < _c0 - 1) || (_s.col > _c1) || (_s.row < _r0 - 1) || (_s.row > _r1)) {
        continue;
    }
    var _ux = grid_sx(id, _s.col);
    var _uy = grid_sy(id, _s.row);
    if ((_ux + _tp < GRIDC_BF_X1) || (_ux > GRIDC_BF_X2) || (_uy + _tp < GRIDC_BF_Y1) || (_uy > GRIDC_BF_Y2)) {
        continue;
    }
    var _base = (_s.side == 0) ? ((_s.formation >= 0) ? formations[_s.formation].colr : GRIDC_GREEN) : GRIDC_RED;

    // strength shading behind the glyph
    var _frac = clamp(_s.hp_pool / max(1, _s.hp_max), 0, 1);
    draw_set_alpha(0.10 + 0.20 * _frac);
    draw_set_color(_base);
    draw_rectangle(_ux + 1, _uy + 1, _ux + _tp - 1, _uy + _tp - 1, false);
    draw_set_alpha(1);

    grid_draw_unit(_s, _ux + _tp / 2, _uy + _tp / 2, _tp, _base);

    if (_tp >= 22) {
        draw_set_font(fnt_tiny);
        draw_set_color(_base);
        draw_set_halign(fa_right);
        var _cnt_txt = _s.is_vehicle ? $"{round(_frac * 100)}%" : string(_s.men);
        draw_text(_ux + _tp - 3, _uy + _tp - 13, _cnt_txt);
        draw_set_halign(fa_left);
    }

    // sergeant pip
    if ((_s.sgt_hp >= 0) && (_tp >= 22)) {
        var _pc = (_s.sgt_hp == 2) ? GRIDC_GREEN : ((_s.sgt_hp == 1) ? GRIDC_RED : c_black);
        draw_set_color(_pc);
        draw_circle(_ux + 7, _uy + 7, 3, false);
        if (_s.sgt_hp == 0) {
            draw_set_color(GRIDC_RED);
            draw_circle(_ux + 7, _uy + 7, 3, true);
        }
    }

    // selection outline
    if ((_s.side == 0) && (_s.formation >= 0) && grid_sel_has(id, _s.formation)) {
        draw_set_color(c_white);
        draw_rectangle(_ux + 1, _uy + 1, _ux + _tp - 1, _uy + _tp - 1, true);
    }

    if (_s.hit_flash > 0) {
        draw_set_alpha(0.40 * _s.hit_flash / GRIDC_FLASH_FRAMES);
        draw_set_color(GRIDC_RED);
        draw_rectangle(_ux + 2, _uy + 2, _ux + _tp - 2, _uy + _tp - 2, false);
        draw_set_alpha(1);
    }
}

// formation name tags
if (_tp >= 20) {
    draw_set_font(fnt_tiny);
    for (var _fi = 0; _fi < array_length(formations); _fi++) {
        var _f = formations[_fi];
        if (!_f.alive || (array_length(_f.members) <= 0)) {
            continue;
        }
        var _tc = -1;
        var _tr = -1;
        for (var _mi = 0; _mi < array_length(_f.members); _mi++) {
            var _m = squads[_f.members[_mi]];
            if (!_m.alive) {
                continue;
            }
            if ((_tc < 0) || (_m.row < _tr) || ((_m.row == _tr) && (_m.col < _tc))) {
                _tc = _m.col;
                _tr = _m.row;
            }
        }
        if (_tc < 0) {
            continue;
        }
        var _tgx = grid_sx(id, _tc);
        var _tgy = grid_sy(id, _tr) - 13;
        if ((_tgx < GRIDC_BF_X1) || (_tgx > GRIDC_BF_X2 - 20) || (_tgy < GRIDC_BF_Y1) || (_tgy > GRIDC_BF_Y2)) {
            continue;
        }
        draw_set_color(GRIDC_PANEL);
        draw_rectangle(_tgx, _tgy, _tgx + string_width(_f.name) + 6, _tgy + 12, false);
        draw_set_color(_f.colr);
        draw_text(_tgx + 3, _tgy, _f.name);
    }
}

// placement ghost
if (placing) {
    var _pn = array_length(placing_list);
    var _fp = grid_footprint(id, _pn);
    var _ok = (hover_c >= 0) && grid_placement_valid(id, placing_list, hover_c, hover_r);
    if (hover_c >= 0) {
        var _kk = 0;
        for (var _gy2 = 0; _gy2 < _fp[1]; _gy2++) {
            for (var _gx2 = 0; _gx2 < _fp[0]; _gx2++) {
                if (_kk >= _pn) {
                    break;
                }
                var _bx = grid_sx(id, hover_c + _gx2);
                var _by = grid_sy(id, hover_r + _gy2);
                draw_set_alpha(0.25);
                draw_set_color(_ok ? GRIDC_GREEN : GRIDC_RED);
                draw_rectangle(_bx + 2, _by + 2, _bx + _tp - 2, _by + _tp - 2, false);
                draw_set_alpha(1);
                draw_rectangle(_bx + 2, _by + 2, _bx + _tp - 2, _by + _tp - 2, true);
                _kk += 1;
            }
        }
    }
}

// drag selection box
if (drag_active && (point_distance(drag_x0, drag_y0, _mx, _my) >= GRIDC_DRAG_MIN)) {
    draw_set_color(GRIDC_GREEN);
    draw_set_alpha(0.15);
    draw_rectangle(drag_x0, drag_y0, _mx, _my, false);
    draw_set_alpha(1);
    draw_rectangle(drag_x0, drag_y0, _mx, _my, true);
}

// floating combat text, clipped to the viewport
draw_set_font(fnt_small);
draw_set_halign(fa_center);
for (var _fd = 0; _fd < array_length(floaters); _fd++) {
    var _fe = floaters[_fd];
    var _fx = grid_sx(id, _fe.fc) + _tp / 2 + _fe.fjit;
    var _fy = grid_sy(id, _fe.fr) - 2 - _fe.frise;
    if (!point_in_rectangle(_fx, _fy, GRIDC_BF_X1, GRIDC_BF_Y1, GRIDC_BF_X2, GRIDC_BF_Y2)) {
        continue;
    }
    draw_set_alpha(min(1, _fe.flife / 30));
    draw_set_color(_fe.fcol);
    draw_text(_fx, _fy, _fe.ftxt);
}
draw_set_alpha(1);
draw_set_halign(fa_left);

// viewport frame drawn last so units never spill over the border
draw_set_color(GRIDC_GREEN);
draw_rectangle(GRIDC_BF_X1, GRIDC_BF_Y1, GRIDC_BF_X2, GRIDC_BF_Y2, true);

// ---------------------------------------------------------------------------
// Left panel: the deployment bar.
// ---------------------------------------------------------------------------
draw_set_color(GRIDC_PANEL);
draw_rectangle(GRIDC_LP_X1, GRIDC_BF_Y1, GRIDC_LP_X2, GRIDC_PANEL_Y2, false);
draw_set_color(GRIDC_GREEN);
draw_rectangle(GRIDC_LP_X1, GRIDC_BF_Y1, GRIDC_LP_X2, GRIDC_PANEL_Y2, true);
draw_set_font(fnt_40k_14);
draw_text(GRIDC_LP_X1 + 10, GRIDC_BF_Y1 + 8, "Available Forces:");
draw_set_font(fnt_40k_12);
draw_set_color(GRIDC_DIM);
draw_text(GRIDC_LP_X1 + 10, GRIDC_BF_Y1 + 40, $"Front holds {combat_width} squads");
draw_text(GRIDC_LP_X1 + 10, GRIDC_BF_Y1 + 62, $"On the line {_online}, reserve {_inres}");
draw_set_color(GRIDC_GREEN);
draw_line(GRIDC_LP_X1 + 8, GRIDC_LIST_Y1 - 12, GRIDC_LP_X2 - 8, GRIDC_LIST_Y1 - 12);

// ---------------------------------------------------------------------------
// Right panel: orders and controls.
// ---------------------------------------------------------------------------
draw_set_color(GRIDC_PANEL);
draw_rectangle(GRIDC_RP_X1, GRIDC_BF_Y1, GRIDC_RP_X2, GRIDC_PANEL_Y2, false);
draw_set_color(GRIDC_GREEN);
draw_rectangle(GRIDC_RP_X1, GRIDC_BF_Y1, GRIDC_RP_X2, GRIDC_PANEL_Y2, true);
draw_set_font(fnt_40k_14);
draw_text(GRIDC_RP_X1 + 10, GRIDC_BF_Y1 + 6, "Orders");
draw_set_font(fnt_40k_12);

var _iy = GRIDC_BF_Y1 + 36;
if (array_length(selected) > 0) {
    var _sel0 = formations[selected[0]];
    var _men = 0;
    var _live = 0;
    for (var _q = 0; _q < array_length(_sel0.members); _q++) {
        var _qs = squads[_sel0.members[_q]];
        if (_qs.alive) {
            _live += 1;
            _men += _qs.men;
        }
    }
    var _ostr = "Advance and engage";
    if (_sel0.order == GRIDORD_HOLD) {
        _ostr = "Holding position";
    } else if (_sel0.order == GRIDORD_MOVE) {
        _ostr = $"Moving to {_sel0.dest_col}, {_sel0.dest_row}";
    } else if ((_sel0.order == GRIDORD_ATTACK) && (_sel0.order_target >= 0)) {
        _ostr = $"Attacking {squads[_sel0.order_target].name}";
    }
    draw_set_color(GRIDC_GREEN);
    if (array_length(selected) > 1) {
        draw_text(GRIDC_RP_X1 + 10, _iy, $"{array_length(selected)} formations selected");
    } else {
        draw_text(GRIDC_RP_X1 + 10, _iy, $"Formation {_sel0.name}");
    }
    draw_text(GRIDC_RP_X1 + 10, _iy + 22, $"{_live} squads, {_men} models");
    draw_text(GRIDC_RP_X1 + 10, _iy + 44, _ostr);
    var _stt = (_sel0.stance == 1) ? "Charge" : ((_sel0.stance == 2) ? "Avoid melee" : "Auto");
    draw_text(GRIDC_RP_X1 + 10, _iy + 66, $"Stance: {_stt}");
} else {
    draw_set_color(GRIDC_DIM);
    if (phase == GRIDPH_DEPLOY) {
        draw_text(GRIDC_RP_X1 + 10, _iy, "Pick a type on the left.");
        draw_text(GRIDC_RP_X1 + 10, _iy + 22, "Wheel reshapes a block.");
        draw_text(GRIDC_RP_X1 + 10, _iy + 44, "R rotates it.");
        draw_text(GRIDC_RP_X1 + 10, _iy + 66, "Terminators drop anywhere.");
        draw_text(GRIDC_RP_X1 + 10, _iy + 88, "Right click a squad: recall.");
    } else {
        draw_text(GRIDC_RP_X1 + 10, _iy, "Left click: select.");
        draw_text(GRIDC_RP_X1 + 10, _iy + 22, "Left drag: box select.");
        draw_text(GRIDC_RP_X1 + 10, _iy + 44, "Right click ground: move.");
        draw_text(GRIDC_RP_X1 + 10, _iy + 66, "Right click foe: focus fire.");
        draw_text(GRIDC_RP_X1 + 10, _iy + 88, "Assaults leap on focus fire.");
    }
    draw_text(GRIDC_RP_X1 + 10, _iy + 110, "WASD pans, Tab zooms.");
}

// ---------------------------------------------------------------------------
// Bottom log: the full feed, vanilla combat readout style.
// ---------------------------------------------------------------------------
draw_set_color(GRIDC_PANEL);
draw_rectangle(GRIDC_BF_X1, GRIDC_LOG_Y1, GRIDC_BF_X2, GRIDC_LOG_Y2, false);
draw_set_color(GRIDC_GREEN);
draw_rectangle(GRIDC_BF_X1, GRIDC_LOG_Y1, GRIDC_BF_X2, GRIDC_LOG_Y2, true);
draw_set_font(fnt_40k_12);
var _lines = 13;
var _start = max(0, array_length(feed) - _lines);
var _ly = GRIDC_LOG_Y1 + 8;
for (var _li = _start; _li < array_length(feed); _li++) {
    draw_set_color(feed[_li].lcol);
    draw_text(GRIDC_BF_X1 + 10, _ly, feed[_li].ltxt);
    _ly += 18;
}

// ---------------------------------------------------------------------------
// Buttons, drawn from the same table the Step event hit tests.
// ---------------------------------------------------------------------------
draw_set_font(fnt_40k_12);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var _btns = grid_buttons(id);
for (var _bi = 0; _bi < array_length(_btns); _bi++) {
    var _bt = _btns[_bi];
    var _hov = _bt.benabled && point_in_rectangle(_mx, _my, _bt.bx, _bt.by, _bt.bx + _bt.bw, _bt.by + _bt.bh);
    if (_hov) {
        draw_set_alpha(0.18);
        draw_set_color(GRIDC_GREEN);
        draw_rectangle(_bt.bx, _bt.by, _bt.bx + _bt.bw, _bt.by + _bt.bh, false);
        draw_set_alpha(1);
    }
    draw_set_color(_bt.benabled ? GRIDC_GREEN : GRIDC_DIM);
    draw_rectangle(_bt.bx, _bt.by, _bt.bx + _bt.bw, _bt.by + _bt.bh, true);
    draw_text(_bt.bx + _bt.bw / 2, _bt.by + _bt.bh / 2, _bt.blabel);
}
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ---------------------------------------------------------------------------
// Deployment popup.
// ---------------------------------------------------------------------------
if (popup_open) {
    var _pr = grid_popup_rect();
    var _px = _pr[0];
    var _py = _pr[1];
    var _pw = _pr[2] - _pr[0];
    var _ph = _pr[3] - _pr[1];
    draw_set_color(GRIDC_PANEL);
    draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
    draw_set_color(GRIDC_GREEN);
    draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);
    var _pd = grid_unit_def(popup_type);
    var _pool = grid_pool_indices(id, popup_type);
    draw_set_font(fnt_40k_14);
    draw_text(_px + 12, _py + 10, $"{_pd.disp}: choose members ({array_length(_pool)} available)");
    draw_set_font(fnt_tiny);
    draw_set_color(GRIDC_DIM);
    draw_text(_px + 12, _py + 34, "Wheel scrolls. Right click or click outside to cancel.");

    draw_set_font(fnt_40k_12);
    for (var _i = 0; _i < 8; _i++) {
        var _idx = popup_scroll + _i;
        if (_idx >= array_length(_pool)) {
            break;
        }
        var _sq = squads[_pool[_idx]];
        var _ry = _py + 52 + _i * 56;
        if (_sq.picked) {
            draw_set_alpha(0.12);
            draw_set_color(GRIDC_GREEN);
            draw_rectangle(_px + 8, _ry, _px + _pw - 8, _ry + 52, false);
            draw_set_alpha(1);
        }
        draw_set_color(_sq.picked ? GRIDC_GREEN : GRIDC_DIM);
        draw_rectangle(_px + 8, _ry, _px + _pw - 8, _ry + 52, true);
        draw_rectangle(_px + 18, _ry + 18, _px + 34, _ry + 34, true);
        if (_sq.picked) {
            draw_line(_px + 20, _ry + 26, _px + 26, _ry + 32);
            draw_line(_px + 26, _ry + 32, _px + 32, _ry + 20);
        }
        draw_set_color(GRIDC_GREEN);
        draw_text(_px + 46, _ry + 6, _sq.name);
        draw_set_font(fnt_tiny);
        draw_set_color(GRIDC_DIM);
        var _hp = _sq.hp_pool;
        var _ar = _sq.armour;
        var _ml = _sq.mel;
        var _bl = _sq.bal;
        var _mv = _sq.spd;
        draw_text(_px + 46, _ry + 30, $"HP {_hp}   Armour {_ar}   Melee {_ml}   Ballistic {_bl}   Speed {_mv}");
        draw_set_font(fnt_40k_12);
        draw_set_color(GRIDC_GREEN);

    }

    var _ps = grid_picked_stats(id);
    var _pn2 = _ps.n;

    var _pp2 = _ps.pow;
    var _pm2 = _ps.mv;
    draw_set_font(fnt_40k_12);
    draw_set_color(GRIDC_GREEN);
    draw_text(_px + 14, _py + _ph - 44, $"Formation: {_pn2} squads   Power {_pp2}   Speed {_pm2}");
    draw_set_color((_pn2 > 0) ? GRIDC_GREEN : GRIDC_DIM);
    draw_rectangle(_px + _pw - 190, _py + _ph - 58, _px + _pw - 14, _py + _ph - 12, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_px + _pw - 102, _py + _ph - 35, "Deploy");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ---------------------------------------------------------------------------
// End screen.
// ---------------------------------------------------------------------------
if (phase == GRIDPH_END) {
    draw_set_alpha(0.72);
    draw_set_color(c_black);
    draw_rectangle(0, 0, 1600, 900, false);
    draw_set_alpha(1);
    draw_set_color(GRIDC_PANEL);
    draw_rectangle(560, 300, 1040, 640, false);
    draw_set_color(GRIDC_GREEN);
    draw_rectangle(560, 300, 1040, 640, true);
    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    draw_set_color((result > 0) ? GRIDC_GREEN : GRIDC_RED);
    draw_text(800, 330, (result > 0) ? "VICTORY" : "DEFEAT");
    draw_set_font(fnt_40k_12);
    draw_set_color(GRIDC_GREEN);
    draw_text(800, 400, $"Greenskins slain: {total_ekills}");
    draw_text(800, 424, $"Battle brothers lost: {total_pkills}");
    draw_text(800, 448, $"Mobs wiped out: {wiped_e}");
    draw_text(800, 472, $"Squads lost: {wiped_p}");
    draw_text(800, 496, $"Duration: {ticks} ticks");
    draw_rectangle(660, 560, 940, 616, true);
    draw_set_valign(fa_middle);
    draw_text(800, 588, "Return to Map");
    draw_set_valign(fa_top);
    draw_set_halign(fa_left);
}

// Reset draw state for the cursor, which draws on top of this overlay.
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_small);
if (!instance_exists(obj_cursor)) {
    draw_sprite(spr_cursor, 0, _mx, _my);
}
