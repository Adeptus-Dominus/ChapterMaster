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

    #macro PATH_last_messages $"Logs/last_messages.log"

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
        global.build_date = _build_date;
        if (string_char_at(_version, 1) != "v") {
            if (string_count("compile-", _version) > 0 || string_count("release-", _version) > 0) {
                var _format_version = string_delete(_version, 1, 8);
                var _parts = string_split(_format_version, ".");
                _format_version = _parts[0] + "." + _parts[1];
                _version = _format_version;
            }
            if (_commit_hash != "") {
                _version += $"/{_commit_hash}";
            }
            _version = $"dev-{_version}";
        } else {
            _version = string_delete(_version, 1, 1);
        }
        global.game_version = _version;
        global.commit_hash = _commit_hash;
    }
}
