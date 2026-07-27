/// Grid combat prototype: full GUI-layer rendering. The GUI surface is fixed
/// at 1600x900, so camera zoom never affects this overlay.

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// Backdrop
draw_set_alpha(1);
draw_set_valign(fa_top);
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(13, 15, 20));
draw_rectangle(0, 0, 1600, 900, false);

// Title bar
draw_set_font(fnt_40k_14);
draw_set_color(c_white);
var _phn = "Deployment";
if (phase == GRIDPH_BATTLE) {
    _phn = "Battle";
}
if (phase == GRIDPH_END) {
    _phn = "Resolution";
}
draw_text(292, 14, $"GRID COMBAT PROTOTYPE   |   Phase: {_phn}   |   Tick {ticks}");
draw_set_halign(fa_right);
draw_text(1536, 14, $"Deployment Points: {points} / {GRIDC_POINTS}");
draw_set_halign(fa_left);

// Battlefield frame, zone tints, grid lines
var _bx = GRIDC_BF_X;
var _by = GRIDC_BF_Y;
var _bw = GRIDC_COLS * GRIDC_TILE;
var _bh = GRIDC_ROWS * GRIDC_TILE;
draw_set_color(make_color_rgb(24, 28, 36));
draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

draw_set_alpha(0.10);
draw_set_color(make_color_rgb(70, 120, 220));
draw_rectangle(_bx, _by, _bx + GRIDC_DEPLOY_COLS * GRIDC_TILE, _by + _bh, false);
draw_set_color(make_color_rgb(220, 70, 70));
draw_rectangle(_bx + (GRIDC_COLS - GRIDC_ENEMY_COLS) * GRIDC_TILE, _by, _bx + _bw, _by + _bh, false);
draw_set_alpha(1);

draw_set_font(fnt_tiny);
draw_set_color(make_color_rgb(120, 160, 230));
draw_text(_bx + 4, _by + 2, "DEPLOY");
draw_set_color(make_color_rgb(230, 120, 120));
draw_set_halign(fa_right);
draw_text(_bx + _bw - 4, _by + 2, "ENEMY");
draw_set_halign(fa_left);

draw_set_alpha(0.14);
draw_set_color(make_color_rgb(120, 130, 150));
for (var _gl1 = 0; _gl1 <= GRIDC_COLS; _gl1++) {
    draw_line(_bx + _gl1 * GRIDC_TILE, _by, _bx + _gl1 * GRIDC_TILE, _by + _bh);
}
for (var _gl2 = 0; _gl2 <= GRIDC_ROWS; _gl2++) {
    draw_line(_bx, _by + _gl2 * GRIDC_TILE, _bx + _bw, _by + _gl2 * GRIDC_TILE);
}
draw_set_alpha(1);

// Cover squiggles: green helps, red hurts (ranged fire only)
draw_set_font(fnt_small);
for (var _cc1 = 0; _cc1 < GRIDC_COLS; _cc1++) {
    for (var _cr1 = 0; _cr1 < GRIDC_ROWS; _cr1++) {
        var _cv1 = cov[_cc1][_cr1];
        if (_cv1 == 0) {
            continue;
        }
        if (_cv1 > 0) {
            draw_set_color(make_color_rgb(90, 200, 110));
        } else {
            draw_set_color(make_color_rgb(220, 90, 90));
        }
        draw_text(_bx + _cc1 * GRIDC_TILE + 6, _by + _cr1 * GRIDC_TILE + 30, "~~");
    }
}

// Hover highlight
if ((hover_c >= 0) && (phase != GRIDPH_END)) {
    draw_set_alpha(0.22);
    draw_set_color(c_white);
    draw_rectangle(_bx + hover_c * GRIDC_TILE, _by + hover_r * GRIDC_TILE, _bx + (hover_c + 1) * GRIDC_TILE - 1, _by + (hover_r + 1) * GRIDC_TILE - 1, false);
    draw_set_alpha(1);
}

// Formation move markers and focus fire lines
for (var _fd1 = 0; _fd1 < array_length(formations); _fd1++) {
    var _fm1 = formations[_fd1];
    if (!_fm1.alive) {
        continue;
    }
    if ((_fm1.order == GRIDORD_MOVE) && grid_in_bounds(_fm1.dest_col, _fm1.dest_row)) {
        draw_set_alpha(0.8);
        draw_set_color(c_aqua);
        draw_rectangle(_bx + _fm1.dest_col * GRIDC_TILE + 8, _by + _fm1.dest_row * GRIDC_TILE + 8, _bx + (_fm1.dest_col + 1) * GRIDC_TILE - 8, _by + (_fm1.dest_row + 1) * GRIDC_TILE - 8, true);
        draw_set_alpha(1);
    }
    if ((_fm1.order == GRIDORD_ATTACK) && (_fm1.order_target >= 0)) {
        var _tgt1 = squads[_fm1.order_target];
        if (_tgt1.alive && _tgt1.deployed) {
            var _cx1 = 0;
            var _cy1 = 0;
            var _cn1 = 0;
            for (var _mm1 = 0; _mm1 < array_length(_fm1.members); _mm1++) {
                var _msq1 = squads[_fm1.members[_mm1]];
                if (_msq1.alive && _msq1.deployed) {
                    _cx1 += _bx + _msq1.col * GRIDC_TILE + GRIDC_TILE / 2;
                    _cy1 += _by + _msq1.row * GRIDC_TILE + GRIDC_TILE / 2;
                    _cn1 += 1;
                }
            }
            if (_cn1 > 0) {
                var _tpx1 = _bx + _tgt1.col * GRIDC_TILE + GRIDC_TILE / 2;
                var _tpy1 = _by + _tgt1.row * GRIDC_TILE + GRIDC_TILE / 2;
                draw_set_alpha(0.45);
                draw_set_color(c_red);
                draw_line_width(_cx1 / _cn1, _cy1 / _cn1, _tpx1, _tpy1, 2);
                draw_set_alpha(0.9);
                draw_rectangle(_bx + _tgt1.col * GRIDC_TILE + 2, _by + _tgt1.row * GRIDC_TILE + 2, _bx + (_tgt1.col + 1) * GRIDC_TILE - 2, _by + (_tgt1.row + 1) * GRIDC_TILE - 2, true);
                draw_set_alpha(1);
            }
        }
    }
}

// Squads
for (var _si2 = 0; _si2 < array_length(squads); _si2++) {
    var _s2 = squads[_si2];
    if (!_s2.alive || !_s2.deployed) {
        continue;
    }
    var _px2 = _bx + _s2.col * GRIDC_TILE;
    var _py2 = _by + _s2.row * GRIDC_TILE;
    if (_s2.side == 0) {
        var _fc2 = (_s2.formation >= 0) ? formations[_s2.formation].colr : _s2.colr;
        draw_set_alpha(0.85);
        draw_set_color(_fc2);
        draw_rectangle(_px2 + 3, _py2 + 3, _px2 + GRIDC_TILE - 3, _py2 + GRIDC_TILE - 3, false);
        draw_set_alpha(1);
        draw_set_color(merge_color(_fc2, c_black, 0.5));
        draw_rectangle(_px2 + 3, _py2 + 3, _px2 + GRIDC_TILE - 3, _py2 + GRIDC_TILE - 3, true);
        // squad label and strength counter (design point 7)
        draw_set_font(fnt_small);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text(_px2 + GRIDC_TILE / 2, _py2 + 12, _s2.label);
        draw_set_halign(fa_right);
        draw_set_font(fnt_tiny);
        if (_s2.is_vehicle) {
            var _pct2 = (_s2.hp_max > 0) ? ceil(100 * _s2.hp_pool / _s2.hp_max) : 0;
            draw_text(_px2 + GRIDC_TILE - 5, _py2 + GRIDC_TILE - 16, $"{_pct2}%");
        } else {
            draw_text(_px2 + GRIDC_TILE - 5, _py2 + GRIDC_TILE - 16, string(_s2.men));
        }
        draw_set_halign(fa_left);
        // sergeant pip: green fine, red wounded, black with red border down
        if (_s2.sgt_hp >= 0) {
            if (_s2.sgt_hp >= 2) {
                draw_set_color(c_lime);
                draw_circle(_px2 + 9, _py2 + 9, 4, false);
            } else if (_s2.sgt_hp == 1) {
                draw_set_color(c_red);
                draw_circle(_px2 + 9, _py2 + 9, 4, false);
            } else {
                draw_set_color(c_black);
                draw_circle(_px2 + 9, _py2 + 9, 4, false);
                draw_set_color(c_red);
                draw_circle(_px2 + 9, _py2 + 9, 4, true);
            }
        }
        // selection highlight
        if ((selected_form >= 0) && (_s2.formation == selected_form)) {
            draw_set_color(c_white);
            draw_rectangle(_px2 + 1, _py2 + 1, _px2 + GRIDC_TILE - 1, _py2 + GRIDC_TILE - 1, true);
        }
    } else {
        // enemy squads as ASCII glyphs (design point 8)
        draw_set_alpha(0.35);
        draw_set_color(make_color_rgb(60, 40, 40));
        draw_rectangle(_px2 + 4, _py2 + 4, _px2 + GRIDC_TILE - 4, _py2 + GRIDC_TILE - 4, false);
        draw_set_alpha(1);
        draw_set_font(fnt_40k_14);
        draw_set_color(_s2.colr);
        draw_set_halign(fa_center);
        draw_text(_px2 + GRIDC_TILE / 2, _py2 + 8, _s2.ascii);
        draw_set_font(fnt_tiny);
        draw_set_halign(fa_right);
        draw_text(_px2 + GRIDC_TILE - 5, _py2 + GRIDC_TILE - 16, string(_s2.men));
        draw_set_halign(fa_left);
    }
}

// Formation name tags above the topmost-left member (design point 10 naming)
draw_set_font(fnt_tiny);
for (var _ft3 = 0; _ft3 < array_length(formations); _ft3++) {
    var _f3 = formations[_ft3];
    if (!_f3.alive) {
        continue;
    }
    var _bk3 = 999999;
    var _bs3 = -1;
    for (var _bm3 = 0; _bm3 < array_length(_f3.members); _bm3++) {
        var _ms3 = squads[_f3.members[_bm3]];
        if (_ms3.alive && _ms3.deployed) {
            if (_ms3.row * 1000 + _ms3.col < _bk3) {
                _bk3 = _ms3.row * 1000 + _ms3.col;
                _bs3 = _f3.members[_bm3];
            }
        }
    }
    if (_bs3 < 0) {
        continue;
    }
    var _tx3 = _bx + squads[_bs3].col * GRIDC_TILE;
    var _ty3 = _by + squads[_bs3].row * GRIDC_TILE - 14;
    if (squads[_bs3].row == 0) {
        _ty3 = _by + squads[_bs3].row * GRIDC_TILE + GRIDC_TILE + 1;
    }
    var _tw3 = string_width(_f3.name) + 8;
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(_tx3, _ty3, _tx3 + _tw3, _ty3 + 13, false);
    draw_set_alpha(1);
    draw_set_color(_f3.colr);
    draw_text(_tx3 + 4, _ty3 + 1, _f3.name);
}

// Placement ghost (design point 6): green cells legal, red cells blocked
if (placing) {
    var _pn4 = array_length(placing_list);
    if ((_pn4 > 0) && (hover_c >= 0)) {
        var _fp4 = grid_footprint(id, _pn4);
        var _valid4 = grid_placement_valid(id, hover_c, hover_r);
        for (var _k4 = 0; _k4 < _pn4; _k4++) {
            var _c4 = hover_c + (_k4 mod _fp4[0]);
            var _r4 = hover_r + (_k4 div _fp4[0]);
            if (!grid_in_bounds(_c4, _r4)) {
                continue;
            }
            var _gx4 = _bx + _c4 * GRIDC_TILE;
            var _gy4 = _by + _r4 * GRIDC_TILE;
            draw_set_alpha(0.18);
            draw_set_color(_valid4 ? c_lime : c_red);
            draw_rectangle(_gx4 + 2, _gy4 + 2, _gx4 + GRIDC_TILE - 2, _gy4 + GRIDC_TILE - 2, false);
            draw_set_alpha(0.9);
            draw_rectangle(_gx4 + 2, _gy4 + 2, _gx4 + GRIDC_TILE - 2, _gy4 + GRIDC_TILE - 2, true);
            draw_set_alpha(1);
        }
    }
}

// Left panel: the Deployment Bar (design point 1)
draw_set_color(make_color_rgb(18, 21, 28));
draw_rectangle(8, 8, 272, 892, false);
draw_set_color(make_color_rgb(70, 80, 95));
draw_rectangle(8, 8, 272, 892, true);
draw_set_font(fnt_40k_14);
draw_set_color(c_white);
draw_text(20, 18, "STRIKE FORCE");
draw_set_font(fnt_small);
draw_set_color(make_color_rgb(180, 190, 205));
draw_text(20, 52, $"Points remaining: {points}");
draw_text(20, 76, (phase == GRIDPH_DEPLOY) ? "Pick a type to form a group." : "Deployment locked.");

// Bottom left: battle log (design point 9)
draw_set_color(make_color_rgb(18, 21, 28));
draw_rectangle(288, 736, 980, 892, false);
draw_set_color(make_color_rgb(70, 80, 95));
draw_rectangle(288, 736, 980, 892, true);
draw_set_font(fnt_tiny);
draw_set_color(make_color_rgb(150, 160, 175));
draw_text(296, 740, "BATTLE LOG");
draw_set_font(fnt_small);
var _st5 = max(0, array_length(feed) - 8);
var _ly5 = 758;
for (var _l5 = _st5; _l5 < array_length(feed); _l5++) {
    var _e5 = feed[_l5];
    draw_set_color(_e5.c);
    draw_text(296, _ly5, _e5.t);
    _ly5 += 16;
}

// Bottom middle: orders and info context panel
draw_set_color(make_color_rgb(18, 21, 28));
draw_rectangle(986, 736, 1336, 892, false);
draw_set_color(make_color_rgb(70, 80, 95));
draw_rectangle(986, 736, 1336, 892, true);
draw_set_font(fnt_tiny);
draw_set_color(make_color_rgb(150, 160, 175));
draw_text(994, 740, "ORDERS / INFO");
draw_set_font(fnt_small);
if (selected_form >= 0) {
    var _cf6 = formations[selected_form];
    var _ot6 = "Advance";
    if (_cf6.order == GRIDORD_HOLD) {
        _ot6 = "Hold position";
    }
    if (_cf6.order == GRIDORD_MOVE) {
        _ot6 = $"Move to {_cf6.dest_col},{_cf6.dest_row}";
    }
    if ((_cf6.order == GRIDORD_ATTACK) && (_cf6.order_target >= 0)) {
        var _tn6 = squads[_cf6.order_target].name;
        _ot6 = $"Attack {_tn6}";
    }
    var _mem6 = 0;
    var _men6 = 0;
    for (var _m6 = 0; _m6 < array_length(_cf6.members); _m6++) {
        var _ms6 = squads[_cf6.members[_m6]];
        if (_ms6.alive && _ms6.deployed) {
            _mem6 += 1;
            _men6 += _ms6.men;
        }
    }
    draw_set_color(_cf6.colr);
    draw_text(994, 760, $"Formation {_cf6.name}");
    draw_set_color(c_white);
    draw_text(994, 782, $"Order: {_ot6}");
    draw_text(994, 804, $"Squads: {_mem6}   Men: {_men6}");
    draw_set_color(make_color_rgb(150, 160, 175));
    draw_text(994, 826, "Right-click a foe to focus fire.");
} else if (phase == GRIDPH_DEPLOY) {
    draw_set_color(make_color_rgb(180, 190, 205));
    draw_text(994, 760, "Left bar: pick a type, build a group.");
    draw_text(994, 782, "Right-click a placed squad: recall it.");
    draw_text(994, 804, "Terminators may deep strike anywhere.");
    draw_text(994, 826, "Begin Battle when ready.");
    draw_text(994, 848, "Wheel reshapes a block, R rotates it.");
} else {
    draw_set_color(make_color_rgb(180, 190, 205));
    draw_text(994, 760, "Click a squad to select its group.");
    draw_text(994, 782, "Click open ground: reposition.");
    draw_text(994, 804, "Right-click a foe: focus fire.");
    draw_text(994, 826, "H hold, A advance, Space pause.");
}

// Buttons: rendered from the same rect list the Step event hit-tests
var _blist7 = grid_buttons(id);
draw_set_font(fnt_small);
for (var _b7 = 0; _b7 < array_length(_blist7); _b7++) {
    var _bt7 = _blist7[_b7];
    var _hov7 = point_in_rectangle(_mx, _my, _bt7.bx, _bt7.by, _bt7.bx + _bt7.bw, _bt7.by + _bt7.bh);
    var _fill7 = _bt7.benabled ? make_color_rgb(40, 60, 90) : make_color_rgb(30, 33, 40);
    if (_bt7.benabled && _hov7) {
        _fill7 = make_color_rgb(58, 84, 122);
    }
    draw_set_color(_fill7);
    draw_rectangle(_bt7.bx, _bt7.by, _bt7.bx + _bt7.bw, _bt7.by + _bt7.bh, false);
    draw_set_color(make_color_rgb(90, 105, 130));
    draw_rectangle(_bt7.bx, _bt7.by, _bt7.bx + _bt7.bw, _bt7.by + _bt7.bh, true);
    draw_set_color(_bt7.benabled ? c_white : make_color_rgb(120, 125, 135));
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_bt7.bx + _bt7.bw / 2, _bt7.by + _bt7.bh / 2, _bt7.blabel);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Formation creation popup (design point 5)
if (popup_open) {
    var _prc8 = grid_popup_rect();
    var _px8 = _prc8[0];
    var _py8 = _prc8[1];
    var _pw8 = _prc8[2];
    var _ph8 = _prc8[3];
    draw_set_color(make_color_rgb(22, 26, 34));
    draw_rectangle(_px8, _py8, _px8 + _pw8, _py8 + _ph8, false);
    draw_set_color(make_color_rgb(110, 125, 150));
    draw_rectangle(_px8, _py8, _px8 + _pw8, _py8 + _ph8, true);
    var _rows8 = grid_pool_indices(id, popup_type);
    var _dd8 = grid_unit_def(popup_type);
    draw_set_font(fnt_small);
    draw_set_color(c_white);
    draw_text(_px8 + 12, _py8 + 8, $"{_dd8.disp} squads: pick members ({array_length(_rows8)} available)");
    draw_set_color(make_color_rgb(150, 160, 175));
    draw_text(_px8 + 12, _py8 + 26, "Wheel scrolls. Right-click closes.");
    var _vis8 = 8;
    for (var _i8 = 0; _i8 < _vis8; _i8++) {
        var _ri8 = popup_scroll + _i8;
        if (_ri8 >= array_length(_rows8)) {
            break;
        }
        var _ry8 = _py8 + 46 + _i8 * 56;
        var _sq8 = squads[_rows8[_ri8]];
        if (_sq8.picked) {
            draw_set_alpha(0.25);
            draw_set_color(c_aqua);
            draw_rectangle(_px8 + 8, _ry8, _px8 + _pw8 - 8, _ry8 + 52, false);
            draw_set_alpha(1);
        }
        draw_set_color(make_color_rgb(70, 80, 95));
        draw_rectangle(_px8 + 8, _ry8, _px8 + _pw8 - 8, _ry8 + 52, true);
        // checkbox
        draw_set_color(make_color_rgb(110, 125, 150));
        draw_rectangle(_px8 + 16, _ry8 + 18, _px8 + 32, _ry8 + 34, true);
        if (_sq8.picked) {
            draw_set_color(c_aqua);
            draw_rectangle(_px8 + 19, _ry8 + 21, _px8 + 29, _ry8 + 31, false);
        }
        draw_set_font(fnt_small);
        draw_set_color(_sq8.picked ? c_aqua : c_white);
        draw_text(_px8 + 44, _ry8 + 6, _sq8.name);
        draw_set_font(fnt_tiny);
        draw_set_color(make_color_rgb(170, 180, 195));
        draw_text(_px8 + 44, _ry8 + 30, $"HP {_sq8.hp_pool}  Armour {_sq8.armor}  Melee {_sq8.mel}  Ballistic {_sq8.bal}  Move {_sq8.mv}");
        draw_set_font(fnt_small);
        draw_set_halign(fa_right);
        draw_set_color(c_white);
        draw_text(_px8 + _pw8 - 18, _ry8 + 6, $"{_sq8.cost}pt");
        draw_set_halign(fa_left);
    }
    // finalisation footer (design point 11)
    var _ps8 = grid_picked_stats(id);
    draw_set_color(make_color_rgb(70, 80, 95));
    draw_line(_px8 + 8, _py8 + _ph8 - 70, _px8 + _pw8 - 8, _py8 + _ph8 - 70);
    draw_set_font(fnt_small);
    draw_set_color(c_white);
    draw_text(_px8 + 14, _py8 + _ph8 - 58, $"Formation: {_ps8.n} squads   Power {_ps8.pow}");
    draw_text(_px8 + 14, _py8 + _ph8 - 36, $"Move {_ps8.mv}   Cost {_ps8.cost}pt");
    var _den8 = (_ps8.n > 0);
    var _dhov8 = point_in_rectangle(_mx, _my, _px8 + _pw8 - 190, _py8 + _ph8 - 58, _px8 + _pw8 - 14, _py8 + _ph8 - 12);
    draw_set_color(_den8 ? (_dhov8 ? make_color_rgb(58, 84, 122) : make_color_rgb(40, 60, 90)) : make_color_rgb(30, 33, 40));
    draw_rectangle(_px8 + _pw8 - 190, _py8 + _ph8 - 58, _px8 + _pw8 - 14, _py8 + _ph8 - 12, false);
    draw_set_color(make_color_rgb(90, 105, 130));
    draw_rectangle(_px8 + _pw8 - 190, _py8 + _ph8 - 58, _px8 + _pw8 - 14, _py8 + _ph8 - 12, true);
    draw_set_color(_den8 ? c_white : make_color_rgb(120, 125, 135));
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_px8 + _pw8 - 102, _py8 + _ph8 - 35, "DEPLOY");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// End overlay
if (phase == GRIDPH_END) {
    draw_set_alpha(0.6);
    draw_set_color(c_black);
    draw_rectangle(0, 0, 1600, 900, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(18, 21, 28));
    draw_rectangle(560, 300, 1040, 640, false);
    draw_set_color(make_color_rgb(110, 125, 150));
    draw_rectangle(560, 300, 1040, 640, true);
    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    if (result == 1) {
        draw_set_color(c_lime);
        draw_text(800, 324, "VICTORY");
    } else {
        draw_set_color(c_red);
        draw_text(800, 324, "DEFEAT");
    }
    draw_set_font(fnt_40k_12);
    draw_set_color(c_white);
    draw_text(800, 396, $"Greenskins slain: {total_ekills}");
    draw_text(800, 424, $"Brothers and auxiliaries lost: {total_pkills}");
    draw_text(800, 452, $"Enemy mobs wiped: {wiped_e}");
    draw_text(800, 480, $"Our squads lost: {wiped_p}");
    draw_text(800, 508, $"Duration: {ticks} ticks");
    var _rhov9 = point_in_rectangle(_mx, _my, 660, 560, 940, 616);
    draw_set_color(_rhov9 ? make_color_rgb(58, 84, 122) : make_color_rgb(40, 60, 90));
    draw_rectangle(660, 560, 940, 616, false);
    draw_set_color(make_color_rgb(90, 105, 130));
    draw_rectangle(660, 560, 940, 616, true);
    draw_set_color(c_white);
    draw_set_valign(fa_middle);
    draw_text(800, 588, "Return to Map");
    draw_set_valign(fa_top);
    draw_set_halign(fa_left);
}

// Reset draw state for anything else on the GUI layer (the cursor)
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_small);

// Fallback pointer: obj_cursor normally draws itself on top of this overlay,
// but if no cursor instance is active the pointer must never vanish.
if (!instance_exists(obj_cursor)) {
    draw_sprite(spr_cursor, 0, _mx, _my);
}
