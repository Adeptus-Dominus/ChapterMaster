add_draw_return_values();

draw_set_alpha(title_alpha);
scr_image("title_splash", 0, 0, 0, room_width, room_height);
draw_set_alpha(1);

draw_set_alpha(0.6);
draw_set_font(fnt_cul_14);
draw_set_color(c_gray);
draw_set_halign(fa_right);

var _build_date_line = "";
var _version_line = "";

if (global.build_date != "unknown build") {
    _build_date_line = $"Build: {global.build_date}";
    draw_text(1598, 878, _build_date_line);
}

if (global.game_version != "unknown version") {
    _version_line = $"Version: {global.game_version}";
    draw_text(1598, 858, _version_line);
}

if (point_and_click([1400, 830, 1600, 900])) {
    clipboard_set_text($"{_build_date_line}\n{_version_line}");
    audio_play_sound(snd_click_small, 0, false);
}

// Update notification
if (UPDATE_CHECKER.update_available) {
    draw_set_font(fnt_cul_14);
    draw_set_color(update_blink_visible ? c_yellow : c_gray);
    draw_text(1598, 790, $"Update: {UPDATE_CHECKER.latest_version}\nClick to open download page");

    if (point_and_click([1400, 780, 1600, 830])) {
        url_open(UPDATE_CHECKER.latest_release_url);
        audio_play_sound(snd_click_small, 0, false);
    }
}

draw_set_halign(fa_left);
draw_set_alpha(1);

if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
}
pop_draw_return_values();
