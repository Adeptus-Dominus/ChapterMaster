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

combat_log.draw(x, y);

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

// ---- Formation orders legend ----
// MEASURED geometry, do not relocate on guesswork again: obj_ncombat is created at
// (0,0) and the combat log draws from it, 45 lines x 18px = a full-height column
// owning the LEFT side of the screen. The RIGHT side is the empty one (HP sits at
// the bottom corners, popups dock right only transiently). Right-aligned, top.
// Toggled with the small header button; persists on obj_controller.
if (!variable_instance_exists(obj_controller, "combat_orders_legend_hidden")) {
    obj_controller.combat_orders_legend_hidden = false;
}
draw_set_font(fnt_40k_14);
draw_set_halign(fa_right);
draw_set_alpha(1);
var _legend_x = 792;
var _legend_y = 8;
var _legend_header = obj_controller.combat_orders_legend_hidden ? "[+] Orders" : "[-] Orders";
var _legend_hw = string_width(_legend_header);
var _legend_hover = scr_hit(_legend_x - _legend_hw, _legend_y, _legend_x, _legend_y + 18);
draw_set_color(_legend_hover ? c_white : c_yellow);
draw_text(_legend_x, _legend_y, _legend_header);
if (_legend_hover && mouse_check_button_pressed(mb_left)) {
    obj_controller.combat_orders_legend_hidden = !obj_controller.combat_orders_legend_hidden;
}
if (!obj_controller.combat_orders_legend_hidden) {
    draw_set_color(c_ltgray);
    var _legend_lines = [
        "Left-click a formation: advance / hold",
        "Shift + left-click: retreat (no return)",
        "R: general retreat (cursor block stays as rear guard)",
        "Right-click: cycle fire target (nearest / line 1 / 2 / 3)",
        "Devastators holding ground fire braced",
        "Assault squads ordered onto line 1 leap in (once)",
    ];
    for (var _ll = 0; _ll < array_length(_legend_lines); _ll++) {
        draw_text(_legend_x, _legend_y + 20 + (_ll * 16), _legend_lines[_ll]);
    }
}
draw_set_color(c_white);
draw_set_halign(fa_left);

draw_set_color(c_black);
draw_set_alpha(fadein / 30);
draw_rectangle(0, 0, 1600, 900, 0);
draw_set_color(c_white);
draw_set_alpha(1);
