draw_set_font(fnt_40k_14b);
draw_set_halign(fa_left);
draw_set_color(CM_GREEN_COLOR);

if ((alerts > 0) && (popups_end == 1)) {
    for (var i = 0; i < alerts; i++) {
        var _alert = alerts_list[i];
        set_alert_draw_colour(_alert.colour);
        draw_set_alpha(min(1, _alert.alpha));
        draw_text(32, 46 + ((i + 1) * 20), string_hash_to_newline(string(_alert.txt)));
    }
}

draw_set_alpha(1);
draw_set_font(fnt_small);
draw_set_halign(fa_left);
draw_set_color(255);

if (obj_controller.force_scroll == 1) {
    exit;
}

if (combating > 0) {
    exit;
}
if (obj_controller.audience > 0) {
    exit;
}

if ((show == -1) && (current_popup == 0)) {
    draw_sprite(spr_loading, image_index, 23, 73);
}

if ((show > -1) && (current_battle < array_length(battles))) {
    if (!instances_exist_any([obj_saveload, obj_popup, obj_ncombat, obj_fleet])){
        battles[current_battle].draw_selector();
    }
}
