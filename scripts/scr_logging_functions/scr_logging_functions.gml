#macro STR_ERROR_MESSAGE_HEAD $"Your game just encountered and caught an error!"
#macro STR_ERROR_MESSAGE_HEAD2 $"Your game just encountered a critical error! :("
#macro STR_ERROR_MESSAGE_HEAD3 "Your game just encountered and caught an error! ({0})"
#macro STR_ERROR_MESSAGE_PS $"P.S. You can ALT-TAB and try to continue playing, though it’s recommended to wait for a response in the bug-report forum."
#macro ERR_LOG_DIRECTORY "Logs/"
#macro ERR_PATH_LAST_MESSAGES "last_messages.log"

enum eLOG_LEVEL {
    DEBUG,
    INFO,
    WARNING,
    ERROR,
    CRITICAL,
}

/// @description Logs the _message into a file in the Logs folder.
/// @param {string} _message - The message to log.
function create_error_file(_message) {
    if (string_length(_message) == 0) {
        return;
    }

    if (!directory_exists(ERR_LOG_DIRECTORY)) {
        directory_create(ERR_LOG_DIRECTORY);
    }

    var _log_file = file_text_open_write($"{ERR_LOG_DIRECTORY}{DATE_TIME_1}_error.log");
    file_text_write_string(_log_file, _message);
    file_text_close(_log_file);

    copy_last_messages_file();
}

/// @description Creates a copy of the last_messages.log file, with the current date in the name, in the same folder.
function copy_last_messages_file() {
    if (!file_exists(ERR_PATH_LAST_MESSAGES)) {
        return;
    }

    if (!directory_exists(ERR_LOG_DIRECTORY)) {
        directory_create(ERR_LOG_DIRECTORY);
    }

    file_copy(ERR_PATH_LAST_MESSAGES, $"{ERR_LOG_DIRECTORY}{DATE_TIME_1}_messages.log");
}

/// @desc Provides game-specific state data to the error handler without tight coupling.
/// @returns {Struct}
function error_get_context() {
    var _context = {
        chapter: global.chapter_name ?? "???",
        seed: global.game_seed ?? "???",
        turn: "???",
    };

    if (instance_exists(obj_controller)) {
        _context.turn = obj_controller.turn;
    }

    return _context;
}

/// @description Displays a popup, logs the error into file, and copies to clipboard.
/// @param {string} _header - Header for the error popup.
/// @param {string} _message - Detailed message for the error.
/// @param {string} _stacktrace - Optional.
/// @param {string} _critical - Optional.
/// @param {string} _report_title - Optional. Preset title for the bug report.
function handle_error(_header, _message, _stacktrace = "", _critical = false, _report_title = "") {
    var _context = error_get_context();
    var _full_log = "";

    var _sections = [
        LB_92,
        _header,
        "",
        $"Date-Time: {DATE_TIME_3}",
        $"Game Version: {global.game_version}",
        $"Build Date: {global.build_date}",
        $"Commit Hash: {global.commit_hash}",
        "",
        "Save Details:",
        $"Chapter Name: {_context.chapter}",
        $"Current Turn: {_context.turn}",
        $"Game Seed: {_context.seed}",
        "",
        "Error Details:",
        _message,
        "",
        "Stacktrace:",
        _stacktrace,
        LB_92
    ];

    for (var i = 0, _len = array_length(_sections); i < _len; i++) {
        _full_log += $"{_sections[i]}\n";
    }

    var _error_file_text = (_report_title != "") ? $"{_report_title}\n{_full_log}" : _full_log;
    create_error_file(_error_file_text);

    var _clipboard = (_report_title != "") ? $"{_report_title}\n" : "";
    _clipboard += markdown_codeblock(_full_log, "log");
    clipboard_set_text(_clipboard);

    var _path_hint = string_replace(game_save_id, "/", "\\");
    var _player_msg = $"{_header}\n\n{_message}\n\n";
    _player_msg += $"The error log is in your clipboard and saved at:\n{_path_hint}Logs\\\n\n";
    _player_msg += "1) Create a bug report on Discord.\n2) Press CTRL+V to paste the log.\n\nThank you!";

    if (!_critical) {
        _player_msg += $"\n\n{STR_ERROR_MESSAGE_PS}";
    }

    show_debug_message(_full_log);
    show_message(_player_msg);
}

/// @function handle_exception
/// @description Manages exception display and logging with optional severity.
/// @param {exception} _exception - The exception to handle.
/// @param {string} custom_title - Optional custom title for the error popup.
/// @param {bool} critical - Whether the error is critical (default: false).
/// @param {string} error_marker - Optional marker for the error.
function handle_exception(_exception, custom_title = STR_ERROR_MESSAGE_HEAD, critical = false, error_marker = "") {
    var _header = critical ? STR_ERROR_MESSAGE_HEAD2 : custom_title;
    var _message = _exception.longMessage;
    var _stacktrace = _exception.stacktrace;
    clean_stacktrace(_stacktrace);

    var _critical = critical ? "CRASH! " : "";
    var _build_date = global.build_date == "unknown build" ? "" : $"/{global.build_date}";
    var _problem_line = (array_length(_stacktrace) > 0) ? _stacktrace[0] : "unknown";
    var _report_title = $"{_critical}[{global.game_version}{_build_date}] {_problem_line}";

    _stacktrace = array_to_string_list(_stacktrace);

    handle_error(_header, _message, _stacktrace, critical, _report_title);
}

/// @description Shows a popup for errors triggered by an unexpected condition(s).
/// @param {string} _message - The message to display to the user.
/// @param {string} _header - Optional header for the popup (default: "Your game just encountered an error!").
function assert_error_popup(_message, _header = "Your game just encountered an error!") {
    var _stacktrace_array = debug_get_callstack();

    array_shift(_stacktrace_array); // throw away the first line, it's this function
    array_pop(_stacktrace_array); // and the last line, it's the `0` debug_get_callstack returns for the top of the stack
    clean_stacktrace(_stacktrace_array);

    var _stacktrace = array_to_string_list(_stacktrace_array);

    handle_error(_header, _message, _stacktrace);
}

exception_unhandled_handler(function(_exception) {
    handle_exception(_exception,, true);
    return 0;
});

/// @function markdown_codeblock
/// @description Formats text as a code block.
/// @param {string} _message The message to format.
/// @param {string} _language (Optional) Code language prefix to add into the codeblock.
/// @returns {string} The formatted message.
function markdown_codeblock(_message, _language = "") {
    return string_length(_message) > 0 ? $"```{_language}\n{_message}\n```" : "";
}

/// @function format_time
/// @description Converts to string and adds a 0 at the start, if input is less than 10.
/// @param {real} _time - Usually hours, minutes or seconds.
/// @returns {string}
function format_time(_time) {
    return (_time < 10) ? $"0{_time}" : string(_time);
}

function clean_callstack_prefixes(_string) {
    _string = string_replace_all(_string, "gml_Object_", "");
    _string = string_replace_all(_string, "gml_Script_", "");
    _string = string_replace_all(_string, "gml_GlobalScript_", "");
    return _string;
}

/// @desc Reformats: "Location:[LineNum] > Method > Code Snippet"
/// @param {array} _stacktrace_array The array from debug_get_callstack()
function clean_stacktrace(_stacktrace_array) {
    for (var i = 0, l = array_length(_stacktrace_array); i < l; i++) {
        _stacktrace_array[@ i] = clean_stacktrace_line(_stacktrace_array[i]);
    }
}

/// @desc Reformats: "Location:[LineNum] > Method > Code Snippet"
/// @param {string} _line_string The raw string from debug_get_callstack()
/// @returns {string}
function clean_stacktrace_line(_line_string) {
    var _work_string = _line_string;
    var _code_snippet = "";

    // 1. Extract Code Snippet (Suffix after -)
    var _divider_pos = string_pos(") - ", _work_string);
    if (_divider_pos > 0) {
        _code_snippet = string_delete(_work_string, 1, _divider_pos + 3);
        _code_snippet = string_trim(_code_snippet);
        _work_string = string_copy(_work_string, 1, _divider_pos);
    }

    // 2. Extract Line Number
    var _line_number = "";
    var _line_tag_pos = string_last_pos("(line ", _work_string);
    if (_line_tag_pos > 0) {
        _line_number = string_copy(_work_string, _line_tag_pos, string_length(_work_string));
        _line_number = string_digits(_line_number);
        _work_string = string_copy(_work_string, 1, _line_tag_pos - 1);
        _work_string = string_trim(_work_string);
    }

    // 3. Cleanup Prefixes
    _work_string = clean_callstack_prefixes(_work_string);

    // 4. Handle Method/Anonymous Chains (@ symbols)
    var _final_callsite = "";
    if (string_contains("@", _work_string)) {
        var _parts = string_split(_work_string, "@");
        var _method_name = _parts[0];
        var i = array_length(_parts) - 1;
        var _location = _parts[i];
        
        if (_method_name == "anon") {
            _method_name = "anonymous";
        }

        _final_callsite = $"{_location}:{_line_number} >> {_method_name}";
    } else {
        _final_callsite = $"{_work_string}:{_line_number}";
    }

    // 5. Append Snippet
    if (_code_snippet != "") {
        _final_callsite += $" >> {_code_snippet}";
    }

    return _final_callsite;
}

/// @description Formats the GM constant to a readable OS name.
/// @param {string} _os_type - GM constant for the OS.
/// @returns {string}
function os_type_format(_os_type) {
    var _os_type_dictionary = {
        os_windows: "Windows OS",
        os_gxgames: "GX.games",
        os_linux: "Linux",
        os_macosx: "macOS X",
        os_ios: "iOS",
        os_tvos: "Apple tvOS",
        os_android: "Android",
        os_ps4: "Sony PlayStation 4",
        os_ps5: "Sony PlayStation 5",
        os_gdk: "Microsoft GDK",
        os_xboxseriesxs: "Xbox Series X/S",
        os_switch: "Nintendo Switch",
        os_unknown: "Unknown OS",
    };

    if (struct_exists(_os_type_dictionary, _os_type)) {
        return _os_type_dictionary[$ _os_type];
    } else {
        return _os_type_dictionary.os_unknown;
    }
}

/// @function Logger() constructor
/// @description A Python-inspired logger that traces the callsite and timestamp for every message.
function Logger() constructor {
    static active_level = eLOG_LEVEL.DEBUG;
    static file_logging = true;
    static file_logging_level = eLOG_LEVEL.INFO;
    static log_filename = PATH_LAST_MESSAGES;

    /// @description Physically writes the queue to the file.
    /// @param {Any} _message
    static log_to_file = function(_message) {
        var _f = file_text_open_append(log_filename);
        if (_f == -1) {
            return;
        }

        file_text_write_string(_f, string(_message) + "\n");

        file_text_close(_f);
    };

    /// @description Extracts the calling script and line number.
    /// @returns {string}
    static _get_caller = function() {
        var _stack = debug_get_callstack(4);
        if (array_length(_stack) < 4) {
            return "unknown_caller";
        }

        var _raw = _stack[3];
        var _clean = clean_stacktrace_line(_raw);

        return _clean;
    };

    static _write = function(_level, _level_label, _message, _exception = "") {
        if (_level < active_level) {
            return;
        }

        var _t = date_current_datetime();
        var _time = $"{format_time(date_get_hour(_t))}:{format_time(date_get_minute(_t))}:{format_time(date_get_second(_t))}";
        var _caller = _get_caller();

        var _out = $"{_time} | {_level_label} | {_caller} >> {_message}";

        if (_exception != "") {
            _out += $"\n{_exception}";
        }

        show_debug_message(_out);

        if (file_logging && _level >= file_logging_level) {
            log_to_file(_out);
        }
    };

    /// @param {Any} _message
    static debug = function(_message) {
        _write(eLOG_LEVEL.DEBUG, "DEBUG", _message);
    };

    /// @param {Any} _message
    static info = function(_message) {
        _write(eLOG_LEVEL.INFO, "INFO", _message);
    };

    /// @param {Any} _message
    static warning = function(_message) {
        _write(eLOG_LEVEL.WARNING, "WARNING", _message);
    };

    /// @param {Any} _message
    static error = function(_message) {
        _write(eLOG_LEVEL.ERROR, "ERROR", _message);
    };

    /// @param {Any} _message
    static critical = function(_message) {
        _write(eLOG_LEVEL.CRITICAL, "CRITICAL", _message);
    };

    /// @param {Any} _message
    static exception = function(_message, _exception) {
        _write(eLOG_LEVEL.ERROR, "ERROR", _message, _exception);
    };
}
