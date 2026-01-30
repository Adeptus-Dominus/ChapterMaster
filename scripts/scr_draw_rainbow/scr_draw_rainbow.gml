function scr_draw_rainbow(x1, y1, x2, y2, colour_ratio) {
    // Draws a variable length and color rectangle based on a ratio of two variables

    with (obj_controller) {
        var wid, rat;
        wid = x2 - x1;
        rat = colour_ratio;

        if ((menu != MENU.Diplomacy) || (diplomacy != 0)) {
            if (colour_ratio <= 0.15) {
                draw_set_color(c_red);
            }
            if ((colour_ratio >= 0.15) && (colour_ratio <= 0.4)) {
                draw_set_color(c_orange);
            }
            if ((colour_ratio >= 0.4) && (colour_ratio <= 0.7)) {
                draw_set_color(c_yellow);
            }
            if (colour_ratio >= 0.7) {
                draw_set_color(c_green);
            }
        }
        if ((menu == MENU.Diplomacy) && (diplomacy == 0)) {
            if (colour_ratio <= 0.5) {
                draw_set_color(c_red);
            }
            if ((colour_ratio >= 0.5) && (colour_ratio <= 0.65)) {
                draw_set_color(c_orange);
            }
            if ((colour_ratio >= 0.65) && (colour_ratio <= 0.85)) {
                draw_set_color(c_yellow);
            }
            if (colour_ratio >= 0.85) {
                draw_set_color(c_green);
            }
        }
        if (rat > 1) {
            rat = 1;
        }
        if (rat < -1) {
            rat = -1;
        }
        draw_rectangle(x1, y1, x1 + (wid * rat), y2, 0);
        draw_set_color(c_gray);
        draw_rectangle(x1, y1, x2, y2, 1);
    }
}
