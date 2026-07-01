draw_sprite(spr_rock_bg, 0, 0, 0);

draw_set_color(c_black);
draw_set_alpha(1);
draw_rectangle(0, 0, 800, 900, 0);
draw_rectangle(818, 235, 1578, 666, 0);

draw_set_color(CM_GREEN_COLOR);

for (var l = 0; l <= 3; l++) {
    draw_set_alpha(1 - (0.25 * l));
    draw_rectangle(0 + l, 0 + l, 800 - l, 900 - l, 1);
    draw_rectangle(818 + l, 235 + l, 1578 - l, 666 - l, 1);
}
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

draw_set_color(c_black);
draw_set_alpha(fadein / 30);
draw_rectangle(0, 0, 1600, 900, 0);
draw_set_color(c_white);
draw_set_alpha(1);
