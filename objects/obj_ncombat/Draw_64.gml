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
draw_rectangle(0 + l, 0 + l, 1600 - l, 900 - l, 1);

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
draw_set_alpha(1);

var cell_width = 6;
var cell_height = 426;

// Assuming `my_grid` is your custom grid struct
for (var _x = 0; _x < ds_grid_width(battlefield); _x++) {
    for (var _y = 0; _y < ds_grid_height(battlefield); _y++) {
        var _screen_x = 822 + _x * cell_width + _x;
        var _screen_y = 239 + _y * cell_height;

        // Draw cell rectangle
        draw_set_alpha(0.25);
        draw_set_color(c_gray);
        draw_rectangle(_screen_x, _screen_y, _screen_x + cell_width, _screen_y + cell_height, true);

        // Get cell data
        var _cell = ds_grid_get(battlefield, _x, _y);

        // Determine item count
        var _item_count = (is_array(_cell)) ? array_length(_cell) : 0;

        // Change color if occupied
        if (_item_count > 0) {
            draw_set_alpha(1);
            draw_set_color(c_green);
            draw_rectangle(_screen_x, _screen_y, _screen_x + cell_width, _screen_y + cell_height, false);
        }
    }
}

draw_set_color(c_white); // Reset color to default after

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
} else if (turn_phase == eBATTLE_TURN_PHASE.Movement) {
    draw_text(400, 860, "[Press Enter to Continue]");
}

draw_set_alpha(fading_strength);
draw_set_halign(fa_left);
draw_set_color(c_black);
draw_rectangle(0, 0, 1600, 900, 0);
draw_set_alpha(1);
