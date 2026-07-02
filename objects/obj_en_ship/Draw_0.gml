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

    if (class == "Battlekroozer") {
        draw_sprite_ext(sprite_index, 0, x, y, 0.75, 0.75, direction, c_white, 1);
    } else {
        draw_self();
    }

    draw_ship_status_overlay(self, CM_GREEN_COLOR, COL_REQUISITION);
}
