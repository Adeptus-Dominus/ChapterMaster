add_draw_return_values();

var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);

draw_set_color(c_black);
draw_set_alpha(0.6);
draw_rectangle(_vx, _vy, _vx + 1600, _vy + 900, false);
draw_set_alpha(1);

if (settings == 1) {
    scr_image("menu", 1, _vx + 476, _vy + 114, 562, 631);

    draw_set_color(c_gray);
    draw_set_halign(fa_center);
    draw_set_font(fnt_cul_14);
    draw_text_transformed(_vx + 763, _vy + 149, "Settings", 1.5, 1.5, 0);

    draw_set_halign(fa_left);
    draw_set_font(fnt_cul_18);
    draw_text(_vx + 493, _vy + 224, "Master Volume");
    draw_text(_vx + 493, _vy + 281, "Effects Volume");
    draw_text(_vx + 493, _vy + 339, "Music Volume");
    draw_text(_vx + 493, _vy + 423, "Full Screen?:");
    draw_text(_vx + 493, _vy + 483, "Enable Autosaves?:");

    var _vols = [global.settings.master_volume, global.settings.sfx_volume, global.settings.music_volume];
    var _vol_y = [_vy + 224, _vy + 282, _vy + 338];
    
    for (var i = 0; i < 3; i++) {
        draw_set_color(c_black);
        draw_rectangle(_vx + 710, _vol_y[i], _vx + 974, _vol_y[i] + 30, false);
        
        draw_set_color(CM_GREEN_COLOR);
        var _bar_w = _vols[i] * 264;
        if (_bar_w > 0) draw_rectangle(_vx + 710, _vol_y[i], _vx + 710 + _bar_w, _vol_y[i] + 30, false);
        
        draw_set_color(c_gray);
        draw_set_halign(fa_center);
        draw_text(_vx + 842, _vol_y[i] + 3, string(floor(_vols[i] * 100)) + "%");
        draw_rectangle(_vx + 710, _vol_y[i], _vx + 974, _vol_y[i] + 30, true);
        
        // Arrows
        draw_sprite_stretched(spr_creation_arrow, 0, _vx + 671, _vol_y[i] - 1, 32, 32);
        draw_sprite_stretched(spr_creation_arrow, 1, _vx + 981, _vol_y[i] - 1, 32, 32);
    }

    // Checkboxes
    draw_sprite(spr_creation_check, global.settings.fullscreen, _vx + 626, _vy + 426);
    draw_sprite(spr_creation_check, global.settings.autosave, _vx + 680, _vy + 485);

} else if (!instance_exists(obj_saveload)) {
    scr_image("menu", 0, _vx + 476, _vy + 114, 562, 631);
    draw_set_color(c_gray);
    draw_set_halign(fa_center);
    draw_set_font(fnt_cul_14);
    draw_text_transformed(_vx + 929, _vy + 149, "Menu", 1.5, 1.5, 0);
}

pop_draw_return_values();
