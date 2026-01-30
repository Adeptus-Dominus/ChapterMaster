action_set_alarm(30, 4);

window_old = window_data;
window_data = string(window_get_x()) + "|" + string(window_get_y()) + "|" + string(window_get_width()) + "|" + string(window_get_height()) + "|";
if (window_get_fullscreen() == 1) {
    window_old = "fullscreen";
    window_data = "fullscreen";
}

if ((window_data != "fullscreen") && (window_get_fullscreen() == 0)) {
    if (window_data != window_old) {
        ini_open("saves.ini");
        ini_write_string("Settings", "window_data", string(window_get_x()) + "|" + string(window_get_y()) + "|" + string(window_get_width()) + "|" + string(window_get_height()) + "|");
        ini_close();
    }
}
