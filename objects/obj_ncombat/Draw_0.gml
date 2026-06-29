draw_sprite(spr_rock_bg, 0, 0, 0);

draw_set_color(c_black);
draw_set_alpha(1);
draw_rectangle(0, 0, 800, 900, 0);
draw_rectangle(818, 235, 1578, 666, 0);

draw_set_color(CM_GREEN_COLOR);

var l = 0;
draw_set_alpha(1);
draw_rectangle(0 + l, 0 + l, 800 - l, 900 - l, 1);
l += 1;
draw_set_alpha(0.75);
draw_rectangle(0 + l, 0 + l, 800 - l, 900 - l, 1);
l += 1;
draw_set_alpha(0.5);
draw_rectangle(0 + l, 0 + l, 800 - l, 900 - l, 1);
l += 1;
draw_set_alpha(0.25);
draw_rectangle(0 + l, 0 + l, 6800 - l, 900 - l, 1);

l = 0;
draw_set_alpha(1);
draw_rectangle(818 + l, 235 + l, 1578 - l, 666 - l, 1);
l += 1;
draw_set_alpha(0.75);
draw_rectangle(818 + l, 235 + l, 1578 - l, 666 - l, 1);
l += 1;
draw_set_alpha(0.5);
draw_rectangle(818 + l, 235 + l, 1578 - l, 666 - l, 1);
l += 1;
draw_set_alpha(0.25);
draw_rectangle(818 + l, 235 + l, 1578 - l, 666 - l, 1);

l = 0;
draw_set_alpha(1);
draw_set_font(fnt_40k_14);

if ((display_p1 > 0) && (player_forces > 0)) {
    draw_set_color(c_yellow);
    draw_set_halign(fa_left);
    draw_text(64, 880, string_hash_to_newline(string(display_p1n) + ": " + string(display_p1) + "HP"));
}
if ((display_p2 > 0) && (enemy_forces > 0)) {
    draw_set_color(c_yellow);
    draw_set_halign(fa_right);
    draw_text(800 - 64, 880, string_hash_to_newline(string(display_p2n) + ": " + string(display_p2) + "HP"));
}

draw_set_halign(fa_left);

// When pinned to the bottom (log_scroll == 0) the live 45-row window is drawn exactly as before;
// when scrolled up, page back through the retained log_history instead.
var _log_total = array_length(log_history);
var _log_start = (log_scroll <= 0) ? -1 : max(0, _log_total - log_view_lines - log_scroll);

repeat (45) {
    l += 1;

    var _row_txt, _row_col;
    if (_log_start < 0) {
        _row_txt = lines[l];
        _row_col = lines_color[l];
    } else {
        var _hi = _log_start + (l - 1);
        if ((_hi >= 0) && (_hi < _log_total)) {
            _row_txt = log_history[_hi].text;
            _row_col = log_history[_hi].color;
        } else {
            _row_txt = "";
            _row_col = "";
        }
    }

    draw_set_color(CM_GREEN_COLOR);
    if (_row_col == "red") {
        draw_set_color(c_red);
    }
    if (_row_col == "yellow") {
        draw_set_color(3055825);
    }
    if (_row_col == "purple") {
        draw_set_color(16646566);
    }
    if (_row_col == "bright") {
        draw_set_color(65280);
    }
    if (_row_col == "white") {
        draw_set_color(c_silver);
    }
    if (_row_col == "blue") {
        draw_set_color(c_aqua);
    }
    if (_row_col == "lightgreen") {
        draw_set_color(make_color_rgb(150, 255, 150));
    }
    draw_text(x + 6, y - 10 + (l * 18), string_hash_to_newline(string(_row_txt)));
}

// Combat-log scrollbar: a thin draggable thumb in the gutter between the frame and the text column.
// Only shown when there's more history than the visible window. Thumb height tracks visible/total;
// it sits at the bottom when live (log_scroll == 0) and rises as the player pages back.
if (_log_total > log_view_lines) {
    var _sb_x1 = x + 2;
    var _sb_x2 = x + 4;
    var _sb_y1 = y + 8;
    var _sb_h = log_view_lines * 18;
    var _sb_max_scroll = _log_total - log_view_lines;
    var _sb_thumb_h = max(20, _sb_h * (log_view_lines / _log_total));
    var _sb_frac = log_scroll / _sb_max_scroll; // 0 = live bottom, 1 = oldest
    var _sb_thumb_y1 = _sb_y1 + (1 - _sb_frac) * (_sb_h - _sb_thumb_h);

    draw_set_color(CM_GREEN_COLOR);
    draw_set_alpha(0.3);
    draw_rectangle(_sb_x1, _sb_y1, _sb_x2, _sb_y1 + _sb_h, false);
    draw_set_alpha(1);
    draw_rectangle(_sb_x1, _sb_thumb_y1, _sb_x2, _sb_thumb_y1 + _sb_thumb_h, false);
}
draw_set_alpha(1);

draw_set_color(CM_GREEN_COLOR);
if (click_stall_timer <= 0) {
    if ((fadein < 0) && (fadein > -100) && (started == 0)) {
        draw_set_alpha((fadein * -1) / 30);
        draw_set_halign(fa_center);
        draw_text(400, 860, string_hash_to_newline("[Press Enter to Begin]"));
    }
    if ((started == 2) || ((started == 1) && ((timer_stage == 3) || (timer_stage == 5) || (timer_stage == 0))) || (started == 4)) {
        draw_set_halign(fa_center);
        draw_text(400, 860, string_hash_to_newline("[Press Enter to Continue]"));
    }
    if ((started == 3) || (started == 5)) {
        draw_set_halign(fa_center);
        draw_text(400, 860, string_hash_to_newline("[Press Enter to Exit]"));
    }
}

draw_set_halign(fa_left);
draw_set_alpha(1);

draw_set_color(c_black);
draw_set_alpha(fadein / 30);
draw_rectangle(0, 0, 1600, 900, 0);
draw_set_alpha(1);
