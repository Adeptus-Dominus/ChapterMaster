if (keyboard_check_pressed(192)) {
    var _open = is_debug_overlay_open();
    show_debug_log(!_open);
}

var _w = window_get_width();
var _h = window_get_height();

if (!window_get_fullscreen() && (_w != global.settings.window_rect.w || _h != global.settings.window_rect.h)) {
    global.settings.window_rect.w = _w;
    global.settings.window_rect.h = _h;
    global.settings.save();
    global.settings.sync_ui();
}

if (window_get_fullscreen() != global.settings.fullscreen) {
    global.settings.fullscreen = window_get_fullscreen();
    global.settings.save();
    global.settings.sync_ui();
}