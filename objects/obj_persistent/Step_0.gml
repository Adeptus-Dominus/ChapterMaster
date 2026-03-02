if (keyboard_check_pressed(192)) {
    var _open = is_debug_overlay_open();
    show_debug_log(!_open);
}

var _w = window_get_width();
var _h = window_get_height();

if (_w != global.settings.last_window_w || _h != global.settings.last_window_h) {
    global.settings.last_window_w = _w;
    global.settings.last_window_h = _h;

    global.settings.sync_ui();
}

if (window_get_fullscreen() != global.settings.fullscreen) {
    global.settings.fullscreen = window_get_fullscreen();
    global.settings.save();
    global.settings.sync_ui();
}