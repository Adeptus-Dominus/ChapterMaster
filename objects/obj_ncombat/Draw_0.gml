draw_sprite(spr_rock_bg, 0, 0, 0);

draw_set_color(c_black);
draw_set_alpha(1);
draw_rectangle(0, 0, 800, 900, 0);
draw_rectangle(818, 235, 1578, 666, 0);

draw_set_color(38144);

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

repeat (45) {
    l += 1;
    // draw_text(x+6,y-10+(l*14),"."+string(lines[31-l]));
    draw_set_color(38144);
    if (lines_color[l] == "red") {
        draw_set_color(c_red);
    }
    if (lines_color[l] == "yellow") {
        draw_set_color(3055825);
    }
    if (lines_color[l] == "purple") {
        draw_set_color(16646566);
    }
    if (lines_color[l] == "bright") {
        draw_set_color(65280);
    }
    if (lines_color[l] == "white") {
        draw_set_color(c_silver);
    }
    if (lines_color[l] == "blue") {
        draw_set_color(c_aqua);
    }
    draw_text(x + 6, y - 10 + (l * 18), string_hash_to_newline(string(lines[l])));
}

draw_set_color(38144);
draw_set_halign(fa_center);

if (battle_stage == eBATTLE_STAGE.Start) {
    draw_text(400, 860, string_hash_to_newline("[Press Enter to Begin]"));
} else if (battle_stage == eBATTLE_STAGE.PlayerWinEnd || battle_stage == eBATTLE_STAGE.EnemyWinEnd) {
    draw_text(400, 860, string_hash_to_newline("[Press Enter to Exit]"));
} else if (turn_stage == eBATTLE_TURN.PlayerStart || turn_stage == eBATTLE_TURN.EnemyStart) {
    draw_text(400, 860, string_hash_to_newline("[Press Enter to Continue]"));
}

draw_set_alpha(fading_strength);
draw_set_halign(fa_left);
draw_set_color(c_black);
draw_rectangle(0, 0, 1600, 900, 0);
draw_set_alpha(1);
