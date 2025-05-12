message_log.draw();

draw_set_font(fnt_40k_14);
if ((display_p1 > 0) && (player_forces > 0)) {
    draw_set_color(COL_YELLOW);
    draw_set_halign(fa_left);
    draw_text(64, 880, string(display_p1n) + ": " + string(display_p1) + "HP");
}
if ((display_p2 > 0) && (enemy_forces > 0)) {
    draw_set_color(COL_YELLOW);
    draw_set_halign(fa_right);
    draw_text(800 - 64, 880, string(display_p2n) + ": " + string(display_p2) + "HP");
}

draw_set_halign(fa_left);
var _max_line_length = message_log.x2 - message_log.x1 - 6;
for (var i = 0, l = array_length(lines); i < l; i++) {
    draw_set_color(lines_color[i]);
    draw_text_ext(message_log.x1 + 6, message_log.y1 + 6 + (i * 18), lines[i], 1, _max_line_length);
}

draw_set_color(COL_YELLOW);
var _turn_text = "";
if (battle_stage == eBATTLE_STAGE.Main) {
    _turn_text = "[Press Enter to Begin]";
} else if (battle_stage == eBATTLE_STAGE.PlayerWinEnd || battle_stage == eBATTLE_STAGE.EnemyWinEnd) {
    _turn_text = "[Press Enter to Exit]";
} else if (turn_phase == eBATTLE_TURN_PHASE.Movement) {
    _turn_text = "[Press Enter to Continue]";
}

draw_set_color(COL_GREEN);
draw_set_halign(fa_center);
draw_text(message_log.x3, message_log.y2 - 26, _turn_text);
draw_set_halign(fa_left);

draw_set_alpha(fading_strength);
draw_set_color(c_black);
draw_rectangle(0, 0, 1600, 900, 0);
draw_set_alpha(1);
draw_set_color(c_white);
