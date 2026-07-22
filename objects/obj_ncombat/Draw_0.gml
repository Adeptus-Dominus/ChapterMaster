draw_sprite(spr_rock_bg, 0, 0, 0);

draw_set_color(c_black);
draw_set_alpha(1);
draw_rectangle(0, 0, 800, 900, 0);
draw_rectangle(BATTLE_FIELD_X1, BATTLE_FIELD_Y1, BATTLE_FIELD_X2, BATTLE_FIELD_Y2, 0);

draw_set_color(CM_GREEN_COLOR);

for (var l = 0; l <= 3; l++) {
    draw_set_alpha(1 - (0.25 * l));
    draw_rectangle(0 + l, 0 + l, 800 - l, 900 - l, 1);
    draw_rectangle(BATTLE_FIELD_X1 + l, BATTLE_FIELD_Y1 + l, BATTLE_FIELD_X2 - l, BATTLE_FIELD_Y2 - l, 1);
}
draw_set_alpha(1);

draw_set_alpha(1);
