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

    if (!directory_exists("logs")) {
        directory_create("logs");
    }
    var _log_file = file_text_open_write($"logs/last_messages.log");
    file_text_close(_log_file);

    global.build_date = "unknown build";
    global.game_version = "unknown version";

    var _version_file_path = working_directory + "\\main\\version.json";
    var _parsed_json = json_to_gamemaker(_version_file_path, json_parse);

    if (_parsed_json != undefined) {
        var _build_date = _parsed_json[$ "build_date"];
        var _version = _parsed_json[$ "version"];
        global.build_date = _build_date;
        global.game_version = _version;
    }
}
