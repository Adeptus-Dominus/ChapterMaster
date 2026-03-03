if (cooldown > 0) {
    cooldown--;
}

var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);

switch (effect) {
    case eIN_GAME_MENU_EFFECT.SAVE:
    case eIN_GAME_MENU_EFFECT.LOAD:
        with (obj_new_button) {
            x -= 2000;
            y -= 2000;
        }

        if (effect == eIN_GAME_MENU_EFFECT.SAVE && !file_exists(PATH_AUTOSAVE_FILE)) {
            var _sl = instance_create_depth(0, 0, -20005, obj_saveload);
            _sl.autosaving = true;
            with (obj_controller) {
                scr_save(0, 0, true);
            }
            instance_destroy(_sl);
        }

        var _sav = instance_create_depth(0, 0, -20005, obj_saveload);
        _sav.menu = (effect == eIN_GAME_MENU_EFFECT.SAVE) ? 1 : 2;

        var _b = instance_create_depth(_vx + 707, _vy + 830, -20010, obj_new_button);
        _b.button_text = "Back";
        _b.target = eIN_GAME_MENU_EFFECT.BACK_FROM_SAVELOAD;
        _b.scaling = 1.5;
        _b.button_id = 1;
        break;

    case eIN_GAME_MENU_EFFECT.OPTIONS:
        with (obj_new_button) {
            x -= 2000;
            y -= 2000;
        }
        var _b = instance_create_depth(_vx + 653, _vy + 664, -20010, obj_new_button);
        _b.sprite_index = spr_ui_but_1;
        _b.button_text = "Back";
        _b.target = eIN_GAME_MENU_EFFECT.BACK_FROM_SETTINGS;
        _b.scaling = 1.5;
        _b.button_id = 1;

        settings = 1;
        cooldown = 8;
        break;

    case eIN_GAME_MENU_EFFECT.EXIT:
        instance_create(0, 0, obj_fade);
        fading = 0.1;
        break;

    case eIN_GAME_MENU_EFFECT.RETURN:
        if (instance_exists(obj_controller)) {
            obj_controller.cooldown = 8000;
        }
        with (obj_new_button) {
            if (target >= 10) {
                instance_destroy();
            }
        }
        instance_destroy();
        break;

    case eIN_GAME_MENU_EFFECT.BACK_FROM_SAVELOAD:
        with (obj_saveload) {
            instance_destroy();
        }
        with (obj_new_button) {
            if (target == eIN_GAME_MENU_EFFECT.BACK_FROM_SAVELOAD) {
                instance_destroy();
            } else {
                x += 2000;
                y += 2000;
            }
        }
        break;

    case eIN_GAME_MENU_EFFECT.BACK_FROM_SETTINGS:
        settings = 0;
        cooldown = 2;

        if (room == rm_main_menu) {
            with (obj_new_button) {
                instance_destroy();
            }
            instance_destroy();
        } else {
            with (obj_new_button) {
                if (target == eIN_GAME_MENU_EFFECT.BACK_FROM_SETTINGS) {
                    instance_destroy();
                } else {
                    if (x < _vx) {
                        x += 2000;
                    }
                    if (y < _vy) {
                        y += 2000;
                    }
                }
            }
        }
        break;
}

if (effect > 0) {
    effect = 0;
}

if (settings == 1 && mouse_button_clicked(mb_left, 0, true)) {
    var _changed = false;

    var _vol_y = [
        _vy + 223,
        _vy + 281,
        _vy + 337
    ];
    var _keys = [
        "master_volume",
        "sfx_volume",
        "music_volume"
    ];

    for (var i = 0; i < 3; i++) {
        if (scr_hit(_vx + 671, _vol_y[i], _vx + 671 + 32, _vol_y[i] + 32)) {
            global.settings[$ _keys[i]] = clamp(global.settings[$ _keys[i]] - 0.1, 0, 1);
            global.settings.apply_audio();
            _changed = true;
        }

        if (scr_hit(_vx + 981, _vol_y[i], _vx + 981 + 32, _vol_y[i] + 32)) {
            global.settings[$ _keys[i]] = clamp(global.settings[$ _keys[i]] + 0.1, 0, 1);
            global.settings.apply_audio();
            _changed = true;
        }
    }

    if (scr_hit(_vx + 626, _vy + 426, _vx + 658, _vy + 458)) {
        global.settings.fullscreen = !global.settings.fullscreen;
        global.settings.apply_video();
        _changed = true;
    }

    if (scr_hit(_vx + 680, _vy + 485, _vx + 712, _vy + 517)) {
        global.settings.autosave = !global.settings.autosave;
        _changed = true;
    }

    if (_changed) {
        global.settings.save();
    }
}

if (fading > 0) {
    fading += 1;
    if (instance_exists(obj_fade)) {
        obj_fade.alpha = fading / 30;
    }
    if (fading >= 35) {
        global.returned = 1;
        audio_stop_all();
        with (obj_ini) {
            instance_destroy();
        }
        room_goto(rm_main_menu);
    }
}
