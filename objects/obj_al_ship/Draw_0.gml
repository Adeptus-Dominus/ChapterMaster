if (name != "") {
    draw_self();

    draw_set_color(CM_GREEN_COLOR);
    draw_set_font(fnt_info);
    draw_set_halign(fa_center);

    if (maxhp != 0) {
        var _value = shields <= 0 ? hp / maxhp : shields / maxshields;

        if (obj_controller.zoomed == 0) {
            draw_text(x, y - sprite_height, string_hash_to_newline(string(floor(_value * 100)) + "%"));
        } else {
            draw_text_transformed(x, y - sprite_height, string_hash_to_newline(string(floor(_value * 100)) + "%"), 2, 2, 0);
        }
    }
}
