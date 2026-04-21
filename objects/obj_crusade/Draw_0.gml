if (show == true) {
    draw_set_color(CM_GREEN_COLOR);
    draw_set_alpha(0.5);
    draw_circle(x, y, radius, 0);
    draw_set_alpha(0.5);
    draw_set_color(c_red);
    draw_circle(x, y, 350, 1);
    draw_circle(x, y, 350.5, 1);
    draw_set_alpha(1);
    draw_set_color(CM_GREEN_COLOR);

    if (obj_controller.zoomed == 1) {
        draw_set_font(fnt_large);
        draw_set_halign(fa_center);
        draw_text(room_width / 2, 885, string_hash_to_newline("SELECT AREA"));
        draw_set_halign(fa_left);
    }
}
