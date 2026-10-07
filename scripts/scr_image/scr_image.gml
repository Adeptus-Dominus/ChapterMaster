/// @description Draws a png image. Example:
/// `scr_image("creation/chapters/icons", 1, 450, 250, 32, 32);`
/// For actual sprites with multiple frames, don't use this.
/// @param {String} path the file path after 'images' in the 'datafiles' folder. e.g. "creation/chapters/icons"
/// @param {Real} image_id the name of the image. Convention follows using numbers, e.g. "1.png", so that loops are useful, and it can be stored at it's own array index in the cache.
/// @param {Real} x1 the x coordinates to start drawing
/// @param {Real} y1 the y coordinates to start drawing
/// @param {Real} width the width of the image
/// @param {Real} height the height of the image
function scr_image(path, image_id, x1, y1, width, height) {
    if (!instance_exists(obj_img)) {
        return;
    }

    var _entry = obj_img.image_registry[$ path];

    // Hot path: normal drawing
    if ((image_id >= 0) && (image_id != 666)) {
        if (!is_undefined(_entry)) {
            var _sprites = _entry.sprites;
            var _index = (_entry.fixed_index >= 0) ? _entry.fixed_index : image_id;

            if (_index < array_length(_sprites)) {
                var _sprite = _sprites[_index];
                if ((_sprite > 0) && sprite_exists(_sprite)) {
                    draw_sprite_stretched(_sprite, image_id, x1, y1, width, height);
                    return;
                }
            }

            scr_image_draw_missing(x1, y1, width, height);
            return;
        }

        if (string_pos("/", path) > 0) {
            scr_image_draw_file(path, image_id, x1, y1, width, height);
        }

        return;
    }

    // Filesystem image cache (non-draw ids)
    if (is_undefined(_entry) && (string_pos("/", path) > 0)) {
        scr_image_draw_file(path, image_id, x1, y1, width, height);
        return;
    }

    // Unload
    if ((image_id <= -666) || (image_id == 666)) {
        scr_image_unload(path);
        return;
    }

    // Load
    if ((image_id > -600) && (image_id < 0)) {
        scr_image_load(path);
    }
}

function scr_image_draw_missing(x1, y1, width, height) {
    var _old_alpha = draw_get_alpha();
    var _old_color = draw_get_color();

    draw_set_alpha(1);

    draw_set_color(c_black);
    draw_rectangle(x1, y1, x1 + width, y1 + height, false);

    draw_set_color(c_red);
    draw_rectangle(x1, y1, x1 + width, y1 + height, true);
    draw_rectangle(x1 + 1, y1 + 1, x1 + width - 1, y1 + height - 1, true);
    draw_rectangle(x1 + 2, y1 + 2, x1 + width - 2, y1 + height - 2, true);
    draw_line_width(x1 + 1.5, y1 + 1.5, x1 + width - 1.5, y1 + height - 1.5, 3);
    draw_line_width(x1 + width - 1.5, y1 + 1.5, x1 + 1.5, y1 + height - 1.5, 3);

    draw_set_alpha(_old_alpha);
    draw_set_color(_old_color);
}

function scr_image_draw_file(path, image_id, x1, y1, width, height) {
    var _sprite = scr_image_cache(path, image_id);

    if (is_undefined(_sprite) || !sprite_exists(_sprite)) {
        scr_image_draw_missing(x1, y1, width, height);
        return;
    }

    draw_sprite_stretched(_sprite, 1, x1, y1, width, height);
}

function scr_image_unload_entry(_entry, _reset_flag = true) {
    var _count = min(80, array_length(_entry.sprites));

    for (var _i = 0; _i < _count; _i++) {
        if (_entry.exists[_i] > 0) {
            if (sprite_exists(_entry.sprites[_i])) {
                sprite_delete(_entry.sprites[_i]);
            }

            _entry.exists[_i] = -1;
            _entry.sprites[_i] = 0;
        }
    }

    if (_reset_flag) {
        variable_instance_set(obj_img, _entry.good, false);
    }
}

function scr_image_unload(path) {
    var _registry = obj_img.image_registry;

    if ((path == "all") || (path == "")) {
        var _keys = variable_struct_get_names(_registry);

        for (var _k = 0; _k < array_length(_keys); _k++) {
            scr_image_unload_entry(_registry[$ _keys[_k]]);
        }

        return;
    }

    var _entry = _registry[$ path];

    if (!is_undefined(_entry)) {
        scr_image_unload_entry(_entry);
    }
}

function scr_image_load(path) {
    var _registry = obj_img.image_registry;

    // Legacy "splash" path only ever cleared the three splash groups
    if (path == "splash") {
        scr_image_unload_entry(_registry.main_splash, false);
        scr_image_unload_entry(_registry.existing_splash, false);
        scr_image_unload_entry(_registry.other_splash, false);
        return;
    }

    var _entry = _registry[$ path];

    if (is_undefined(_entry)) {
        return;
    }

    // Splash groups share one flag, so don't clear it when reloading one of them
    scr_image_unload_entry(_entry, false);

    // Single sprite sheets, always stored at index 1
    if (_entry.sheet_path != "") {
        if (file_exists(_entry.sheet_path)) {
            _entry.sprites[1] = sprite_add(_entry.sheet_path, _entry.sheet_frames, false, false, 0, 0);
            _entry.exists[1] = true;
            variable_instance_set(obj_img, _entry.good, true);
        }

        return;
    }

    // Numbered image groups
    var _found = 0;

    for (var _i = 1; _i <= 40; _i++) {
        var _file = $"{_entry.file_prefix}{_i}.png";

        if (file_exists(_file)) {
            _entry.sprites[_i - 1] = sprite_add(_file, 1, false, false, 0, 0);
            _entry.exists[_i - 1] = 1;
            _found++;
        }
    }

    if (_found > 0) {
        variable_instance_set(obj_img, _entry.good, true);
    }
}

/// @description Builds the lookup table used by scr_image. Call once from obj_img Create,
/// after the sprite/exists arrays have been created.
function scr_image_registry_build(_img) {
    var _registry = {};
    var _dir = working_directory + "/images/";

    // [key, sprite array var, folder, file prefix, good flag var]
    var _groups = [
        [
            "main_splash",
            "main",
            "creation",
            "main",
            "splash_good",
        ],
        [
            "existing_splash",
            "existing",
            "creation",
            "existing",
            "splash_good",
        ],
        [
            "other_splash",
            "others",
            "creation",
            "other",
            "splash_good",
        ],
        [
            "advisor",
            "advisor",
            "diplomacy",
            "advisor",
            "advisor_good",
        ],
        [
            "diplomacy_splash",
            "diplomacy_splash",
            "diplomacy",
            "diplomacy",
            "diplomacy_splash_good",
        ],
        [
            "diplomacy_daemon",
            "diplomacy_daemon",
            "diplomacy",
            "daemon",
            "diplomacy_daemon_good",
        ],
        [
            "loading",
            "loading",
            "loading",
            "loading",
            "loading_good",
        ],
        [
            "postbattle",
            "postbattle",
            "ui",
            "postbattle",
            "postbattle_good",
        ],
        [
            "postspace",
            "postspace",
            "ui",
            "postspace",
            "postspace_good",
        ],
        [
            "formation",
            "formation",
            "ui",
            "formation",
            "formation_good",
        ],
        [
            "popup",
            "popup",
            "popup",
            "popup",
            "popup_good",
        ],
        [
            "commander",
            "commander",
            "ui",
            "commander",
            "commander_good",
        ],
        [
            "planet",
            "planet",
            "ui",
            "planet",
            "planet_good",
        ],
        [
            "attacked",
            "attacked",
            "ui",
            "attacked",
            "attacked_good",
        ],
        [
            "force",
            "force",
            "ui",
            "force",
            "force_good",
        ],
        [
            "purge",
            "purge",
            "ui",
            "purge",
            "purge_good",
        ],
        [
            "event",
            "event",
            "ui",
            "event",
            "event_good",
        ],
        [
            "symbol",
            "symbol",
            "diplomacy",
            "symbol",
            "symbol_good",
        ],
        [
            "defeat",
            "defeat",
            "ui",
            "defeat",
            "defeat_good",
        ],
        [
            "slate",
            "slate",
            "creation",
            "slate",
            "slate_good",
        ],
    ];

    for (var _i = 0; _i < array_length(_groups); _i++) {
        var _g = _groups[_i];

        if (!variable_instance_exists(_img, _g[1]) || !variable_instance_exists(_img, _g[1] + "_exists")) {
            continue;
        }

        _registry[$ _g[0]] = {
            sprites: variable_instance_get(_img, _g[1]),
            exists: variable_instance_get(_img, _g[1] + "_exists"),
            good: _g[4],
            file_prefix: _dir + _g[2] + "/" + _g[3],
            sheet_path: "",
            sheet_frames: 1,
            fixed_index: -1,
        };
    }

    // [key, sprite array var, sheet file, subimages, good flag var]
    var _sheets = [
        [
            "creation",
            "creation",
            "creation/creation_icons.png",
            24,
            "creation_good",
        ],
        [
            "diplomacy_icon",
            "diplomacy_icon",
            "diplomacy/diplomacy_icons.png",
            28,
            "diplomacy_icon_good",
        ],
        [
            "menu",
            "menu",
            "ui/ingame_menu.png",
            2,
            "menu_good",
        ],
        [
            "title_splash",
            "title_splash",
            "title_splash.png",
            1,
            "title_splash_good",
        ],
    ];

    for (var _i = 0; _i < array_length(_sheets); _i++) {
        var _s = _sheets[_i];

        _registry[$ _s[0]] = {
            sprites: variable_instance_get(_img, _s[1]),
            exists: variable_instance_get(_img, _s[1] + "_exists"),
            good: _s[4],
            file_prefix: "",
            sheet_path: _dir + _s[2],
            sheet_frames: _s[3],
            fixed_index: 1,
        };
    }

    return _registry;
}

/// @description Use this to load the image at given path and id into the image cache so it can be
/// referenced in a different function to scr_image. Obtain the image later with `obj_img.image_cache[$path][image_id]`
/// returns the sprite id if it exists or -1 if it doesnt
/// @param {String} path the filepath after "images" in the 'datafiles' folder, OR, the filepath after "ChapterMaster" in the %LocalAppData% foler if `use_app_data` is true
/// @param {Real} image_id the number of the image file, convention follows that numbers are "1.png" and so on, if using a prefix, include this in the `path`
/// @param {Bool} use_app_data determines whether reading from `datafiles` or `%LocalAppData%\ChapterMaster` folder
function scr_image_cache(path, image_id, use_app_data = false) {
    try {
        var drawing_sprite = undefined;
        var cache_arr_exists = struct_exists(obj_img.image_cache, path);
        if (!cache_arr_exists) {
            variable_struct_set(obj_img.image_cache, path, array_create(100, -1));
        }
        // Start with 100 slots but allow it to expand if needed
        if (image_id > 100) {
            for (var i = 100; i <= image_id; i++) {
                array_push(obj_img.image_cache[$ path], -1);
            }
        }

        var existing_sprite = -1;
        try {
            existing_sprite = array_get(obj_img.image_cache[$ path], image_id);
        } catch (_ex) {
            LOGGER.error($"error trying to fetch image {path}/{image_id}.png from cache: {_ex}");
            existing_sprite = -1;
        }

        if (sprite_exists(existing_sprite)) {
            drawing_sprite = existing_sprite;
        } else if (image_id > -1) {
            var folders = string_replace_all(path, "\\", "/");
            var dir;
            if (use_app_data) {
                dir = $"{folders}{string(image_id)}.png";
            } else {
                dir = $"{working_directory}/images/{folders}/{string(image_id)}.png";
            }
            if (file_exists(dir)) {
                drawing_sprite = sprite_add(dir, 1, false, false, 0, 0);
                if (image_id >= array_length(obj_img.image_cache[$ path])) {
                    array_resize(obj_img.image_cache[$ path], image_id + 1);
                }
                array_set(obj_img.image_cache[$ path], image_id, drawing_sprite);
            } else {
                drawing_sprite = -1;
                LOGGER.error($"No directory/file found matching {dir}"); // too much noise
            }
        }
        return drawing_sprite;
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

/// @description Simplified handling of chapter icon stuff for both Creation and player chapter icon
/// attempting to keep things consistent and easy through save/load and etc
/// @param {String} _name
/// @param {Bool} update_global_var set to true when wanting to update the player's icon, false if you just want to return the sprite for further use
function scr_load_chapter_icon(_name, update_global_var = false) {
    if (!ds_map_exists(global.chapter_icons_map, _name)) {
        _name = "unknown";
    }

    var _icon_sprite = global.chapter_icons_map[? _name];

    if (update_global_var) {
        global.chapter_icon.name = _name;
        global.chapter_icon.sprite = _icon_sprite;
    }

    // Return the loaded sprite
    return _icon_sprite;
}
