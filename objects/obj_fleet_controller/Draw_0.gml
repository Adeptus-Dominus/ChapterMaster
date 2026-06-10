if (obj_controller.zoomed == 0) {
    draw_sprite(spr_space_bg, 0, (obj_controller.x / 8) - 48, (obj_controller.y / 8) - 48);
}
if (obj_controller.zoomed == 1) {
    draw_sprite(spr_space_bg, 0, 0, 0);
}

exit;

draw_set_color(CM_GREEN_COLOR);
draw_set_font(fnt_menu);
