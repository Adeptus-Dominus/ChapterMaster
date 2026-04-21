add_draw_return_values();

draw_set_color(c_black);
draw_set_alpha(0.6);
draw_rectangle(0, 0, 1600, 900, false);
draw_set_alpha(1);

if (settings == 1) {
    scr_image("menu", 1, 476, 114, 562, 631);

    draw_set_color(c_gray);
    draw_set_halign(fa_center);
    draw_set_font(fnt_cul_14);
    draw_text_transformed(763, 149, "Settings", 1.5, 1.5, 0);

    draw_set_halign(fa_left);
    draw_set_font(fnt_cul_18);
    draw_text(493, 224, "Master Volume");
    draw_text(493, 281, "Effects Volume");
    draw_text(493, 339, "Music Volume");
    draw_text(493, 423, "Full Screen?:");
    draw_text(493, 483, "Enable Autosaves?:");

    var _vols = [
        global.settings.master_volume,
        global.settings.sfx_volume,
        global.settings.music_volume
    ];
    var _vol_y = [
        224,
        282,
        338
    ];

    for (var i = 0; i < 3; i++) {
        draw_set_color(c_black);
        draw_rectangle(710, _vol_y[i], 974, _vol_y[i] + 30, false);

        draw_set_color(CM_GREEN_COLOR);
        var _bar_w = _vols[i] * 264;
        if (_bar_w > 0) {
            draw_rectangle(710, _vol_y[i], 710 + _bar_w, _vol_y[i] + 30, false);
        }

        draw_set_color(c_gray);
        draw_set_halign(fa_center);
        draw_text(842, _vol_y[i] + 3, string(floor(_vols[i] * 100)) + "%");
        draw_rectangle(710, _vol_y[i], 974, _vol_y[i] + 30, true);

        // Arrows
        draw_sprite_stretched(spr_creation_arrow, 0, 671, _vol_y[i] - 1, 32, 32);
        draw_sprite_stretched(spr_creation_arrow, 1, 981, _vol_y[i] - 1, 32, 32);
    }

    // Checkboxes
    draw_sprite(spr_creation_check, global.settings.fullscreen, 626, 426);
    draw_sprite(spr_creation_check, global.settings.autosave, 680, 485);
} else if (!instance_exists(obj_saveload)) {
    scr_image("menu", 0, 476, 114, 562, 631);
    draw_set_color(c_gray);
    draw_set_halign(fa_center);
    draw_set_font(fnt_cul_14);
    draw_text_transformed(929, 149, "Menu", 1.5, 1.5, 0);
}

pop_draw_return_values();
