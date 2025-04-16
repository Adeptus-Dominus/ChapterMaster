draw_sprite(spr_rock_bg, 0, 0, 0);

draw_set_color(c_black);
draw_set_alpha(1);
draw_rectangle(0, 0, 800, 900, 0);
draw_rectangle(818, 235, 1578, 666, 0);

draw_set_color(COL_GREEN);

var l;
l = 0;
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

repeat (45) {
    l += 1;
    // draw_text(x+6,y-10+(l*14),"."+string(lines[31-l]));
    draw_set_color(lines_color[l]);
    draw_text_ext(x + 6, y - 10 + (l * 18), string(lines[l]), 1, 795);
}

draw_set_color(COL_GREEN);
draw_set_halign(fa_center);

if (battle_stage == eBATTLE_STAGE.Main) {
    draw_text(400, 860, "[Press Enter to Begin]");
} else if (battle_stage == eBATTLE_STAGE.PlayerWinEnd || battle_stage == eBATTLE_STAGE.EnemyWinEnd) {
    draw_text(400, 860, "[Press Enter to Exit]");
} else if (turn_stage == eBATTLE_TURN.PlayerStart || turn_stage == eBATTLE_TURN.EnemyStart) {
    draw_text(400, 860, "[Press Enter to Continue]");
}

draw_set_alpha(fading_strength);
draw_set_halign(fa_left);
draw_set_color(c_black);
draw_rectangle(0, 0, 1600, 900, 0);
draw_set_alpha(1);
