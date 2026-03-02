function SettingsManager() constructor {
    master_volume = 1.0;
    music_volume = 1.0;
    sfx_volume = 1.0;
    fullscreen = true;
    window_rect = {
        x: 0,
        y: 0,
        w: 1600,
        h: 900,
    };
    last_window_w = window_rect.w;
    last_window_h = window_rect.h;
    settings_autosave = true;

    static load = function() {
        ini_open("saves.ini");
        master_volume = ini_read_real("Settings", "master_volume", 1);
        music_volume = ini_read_real("Settings", "music_volume", 1);
        sfx_volume = ini_read_real("Settings", "effect_volume", 1);
        fullscreen = ini_read_real("Settings", "fullscreen", 1);
        settings_autosave = ini_read_real("Settings", "settings_autosave", true);

        var rect_str = ini_read_string("Settings", "window_data", "0|0|1600|900|");
        var parts = string_split(rect_str, "|");
        if (array_length(parts) >= 4) {
            window_rect.x = real(parts[0]);
            window_rect.y = real(parts[1]);
            window_rect.w = real(parts[2]);
            window_rect.h = real(parts[3]);
        }
        ini_close();
    };

    static save = function() {
        ini_open("saves.ini");
        ini_write_real("Settings", "master_volume", master_volume);
        ini_write_real("Settings", "effect_volume", sfx_volume);
        ini_write_real("Settings", "music_volume", music_volume);
        ini_write_real("Settings", "fullscreen", fullscreen);
        ini_write_real("Settings", "settings_autosave", settings_autosave);
        ini_close();
    };

    static apply_video = function() {
        if (fullscreen) {
            window_set_fullscreen(true);
        } else {
            window_set_fullscreen(false);
            window_set_size(window_rect.w, window_rect.h);
            window_set_position(window_rect.x, window_rect.y);
        }
        last_window_w = window_rect.w;
        last_window_h = window_rect.h;
        display_set_gui_size(1600, 900);
        surface_resize(application_surface, 1600, 900);
    };

    static sync_ui = function() {
        var _w = window_get_width();
        var _h = window_get_height();
        
        if (_w > 0 && _h > 0) {
            display_set_gui_size(1600, 900);
            surface_resize(application_surface, 1600, 900);
        }
    }
}

function approach(current, target, amount) {
    if (current < target) {
        return min(current + amount, target);
    }
    return max(current - amount, target);
}

function start_room_transition(_target_room) {
    if (instance_exists(obj_main_menu_buttons)) {
        obj_main_menu_buttons.target_room = _target_room;
        obj_main_menu_buttons.fade_target = 1;
    } else {
        room_goto(_target_room);
    }
}
