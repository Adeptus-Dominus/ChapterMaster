
if (obj_main_menu.stage>2){        
    draw_set_alpha(0.6);
    draw_set_font(fnt_cul_14);
    draw_set_color(c_gray);
    draw_set_halign(fa_right);
    if (global.build_date != "") {
        var _build_date_line = $"Build: {global.build_date}";
        draw_text(1598, 878, _build_date_line);
    }
    if (global.game_version != "") {
        var _version_line = $"Version: {global.game_version}";
        draw_text(1598, 858, _version_line);
    }
    draw_set_halign(fa_left);
    draw_set_alpha(1);
    if (point_and_click([1400, 830, 1600, 900])) {
        clipboard_set_text($"{_build_date_line}\n{_version_line}");
        audio_play_sound(snd_click_small, 0, false);
    }
}



