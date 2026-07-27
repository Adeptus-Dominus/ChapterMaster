draw_sprite(spr_rock_bg, 0, 0, 0);

draw_set_color(c_black);
draw_set_alpha(1);
draw_rectangle(0, 0, 800, 900, 0);

// After a grid battle this object exists only to run the after-action report, so
// the old battlefield panel on the right has nothing left to show: its blocks
// never moved and its frame would just be an empty box beside the log. The flag
// is set by grid_handoff_result and read defensively, since a vanilla battle
// never sets it at all.
if (variable_instance_exists(id, "grid_report_only") && grid_report_only) {
    draw_rectangle(BATTLE_FIELD_X1, BATTLE_FIELD_Y1, BATTLE_FIELD_X2, BATTLE_FIELD_Y2, 0);
    draw_set_color(CM_GREEN_COLOR);
    for (var _rl = 0; _rl <= 3; _rl++) {
        draw_set_alpha(1 - (0.25 * _rl));
        draw_rectangle(_rl, _rl, 800 - _rl, 900 - _rl, 1);
    }
    draw_set_alpha(1);
    exit;
}

draw_rectangle(BATTLE_FIELD_X1, BATTLE_FIELD_Y1, BATTLE_FIELD_X2, BATTLE_FIELD_Y2, 0);

draw_set_color(CM_GREEN_COLOR);

for (var l = 0; l <= 3; l++) {
    draw_set_alpha(1 - (0.25 * l));
    draw_rectangle(0 + l, 0 + l, 800 - l, 900 - l, 1);
    draw_rectangle(BATTLE_FIELD_X1 + l, BATTLE_FIELD_Y1 + l, BATTLE_FIELD_X2 - l, BATTLE_FIELD_Y2 - l, 1);
}
draw_set_alpha(1);

draw_set_alpha(1);
