gml_pragma( "global", "__init_external();");

function __init_external() {
    // Delete leftover files from old versions;
    // Remove these lines after a couple of months;
    // ========================
    if (directory_exists("ErrorLogs")) {
        directory_destroy("ErrorLogs");
    }
    if (file_exists("debug_log.ini")) {
        file_delete("debug_log.ini");
    }
    if (file_exists("message_log.log")) {
        file_delete("message_log.log");
    }
    // ========================

    if (!directory_exists("Logs")) {
        directory_create("Logs");
    }
    if (!directory_exists("Custom Files\\Custom Icons")) {
        directory_create("Custom Files\\Custom Icons");
    }
    if (!directory_exists("Save Files")) {
        directory_create("Save Files");
    }

    #macro PATH_save_files "Save Files\\save{0}.json"
    #macro PATH_autosave_file "Save Files\\save0.json"
    #macro PATH_custom_icons "Custom Files\\Custom Icons\\"
    #macro PATH_chapter_icons working_directory + "\\images\\creation\\chapters\\icons\\"
    #macro PATH_included_icons working_directory + "\\images\\creation\\customicons\\"
    #macro PATH_last_messages "Logs/last_messages.log"

    global.chapter_icon = {
        // sprite filename, without the extension
        name: "",
        /// the sprite id once loaded from file
        sprite: -1
    }
    global.chapter_icons_map = ds_map_create();

    var _icon_paths = [PATH_chapter_icons, PATH_included_icons, PATH_custom_icons];
    for (var i = 0; i < array_length(_icon_paths); i++) {
        var _file_wildcard = _icon_paths[i] + "*.png";
        var _file = file_find_first(_file_wildcard, fa_none);  
        while (_file != "") {
            var _file_path = _icon_paths[i] + _file;
            var _sprite  = sprite_add(_file_path, 1, false, true, 0, 0);
            var _icon_name = string_delete(_file, string_length(_file) - 3, 4);
            if (ds_map_exists(global.chapter_icons_map, _icon_name)) {
                sprite_delete(global.chapter_icons_map[? _icon_name]);
                log_message($"A duplicate {_icon_name} icon replaced another existing one with the same name!");
            }
            ds_map_replace(global.chapter_icons_map, _icon_name, _sprite);
            _file = file_find_next();  
        }
        file_find_close();
    }

    global.chapter_icons_array = ds_map_keys_to_array(global.chapter_icons_map);
    array_sort(global.chapter_icons_array, true);

    var _log_file = file_text_open_write(PATH_last_messages);
    file_text_close(_log_file);

    global.build_date = "unknown build";
    global.game_version = "unknown version";
    global.commit_hash = "unknown hash";

    var _version_file_path = working_directory + "\\main\\version.json";
    var _parsed_json = json_to_gamemaker(_version_file_path, json_parse);

    if (_parsed_json != undefined) {
        var _build_date = _parsed_json[$ "build_date"];
        var _version = _parsed_json[$ "version"];
        var _commit_hash = _parsed_json[$ "commit_hash"];

        if (string_char_at(_version, 1) != "v") {
            if (string_count("compile-", _version) > 0 || string_count("release-", _version) > 0) {
                var _format_version = string_delete(_version, 1, 8);
                var _parts = string_split(_format_version, ".");
                _format_version = _parts[0] + "." + _parts[1];
                _version = _format_version;
            }
        } else {
            _version = string_delete(_version, 1, 1);
        }

        global.build_date = _build_date;
        global.game_version = _version;
        global.commit_hash = _commit_hash;
    }
}
