/// @description Insert description here
// You can write your code in this editor

draw_set_font(fnt_40k_14b);
draw_set_halign(fa_left);
draw_set_color(CM_GREEN_COLOR);

if ((alerts > 0) && (popups_end == 1)) {
    for (var i = 1; i <= alerts; i++) {
        set_alert_draw_colour(alert_color[i]);
        draw_set_alpha(min(1, alert_alpha[i]));

        if (obj_controller.zoomed == 0) {
            draw_text(32, +46 + (i * 20), string_hash_to_newline(string(alert_txt[i])));
        }

        if (obj_controller.zoomed == 1) {
            draw_text_transformed(32, 92 + (i * 40), string_hash_to_newline(string(alert_txt[i])), 2, 2, 0);
        }
    }
}
