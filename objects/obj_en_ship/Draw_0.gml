if (name != "") {
    draw_set_font(fnt_info);
    draw_set_halign(fa_center);
    draw_set_alpha(1);

    if ((lightning > 1) && instance_exists(target)) {
        draw_set_color(c_lime);
        lightning -= 1;
        scr_bolt(x, y, target.x, target.y, 0);
    }
    if ((whip > 0) && instance_exists(target)) {
        draw_set_color(c_lime);
        whip -= 1;
        scr_bolt(x, y, target.x, target.y, 0);
        scr_bolt(x - 1, y + 1, target.x - 1, target.y + 1, 0);
    }

    draw_set_color(CM_GREEN_COLOR);

    if (class == "Battlekroozer") {
        draw_sprite_ext(sprite_index, 0, x, y, 0.75, 0.75, direction, c_white, 1);
    } else {
        draw_self();
    }

    if (maxhp != 0) {
        var _value = shields <= 0 ? hp / maxhp : shields / maxshields;

        if (obj_controller.zoomed == 0) {
            draw_text(x, y - sprite_height, string_hash_to_newline(string(floor(_value * 100)) + "%"));
        } else {
            draw_text_transformed(x, y - sprite_height, string_hash_to_newline(string(floor(_value * 100)) + "%"), 2, 2, 0);
        }
    }
}
