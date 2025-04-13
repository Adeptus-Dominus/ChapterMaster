#macro STR_error_message_head $"Your game just encountered and caught an error!"
#macro STR_error_message_head2 $"Your game just encountered a critical error! :("
#macro STR_error_message_head3 "Your game just encountered and caught an error! ({0})"
#macro STR_error_message $"The error log is automatically copied into your clipboard and a copy is created at: \nC:>Users>(UserName)>AppData>Local>ChapterMaster>Logs\n\nPlease, follow these steps:\n1) Create a bug report on our 'Chapter Master Discord' server.\n2) Press CTRL+V to paste the error log.\n3) Title the report with the error log's first line.\n4) If the log isn't pasted, locate and attach the latest error log file.\n\nThank you!"
#macro STR_error_message_ps $"P.S. You can ALT-TAB and try to continue playing, though it’s recommended to wait for a response in the bug-report forum."

/// @description Logs the _message into a file in the Logs folder.
/// @param {string} _message - The message to log.
function create_error_file(_message) {
    if (string_length(_message) > 0) {
        var _log_file = file_text_open_write($"Logs/{DATE_TIME_1}_error.log");
        file_text_write_string(_log_file, _message);
        file_text_close(_log_file);
    }
    copy_last_messages_file();
}

/// @description Creates a copy of the last_messages.log file, with the current date in the name, in the same folder.
function copy_last_messages_file() {
    if (file_exists(PATH_last_messages)) {
        file_copy(PATH_last_messages, $"Logs/{DATE_TIME_1}_messages.log");
    }
}

/// @description Displays a popup, logs the error into file, and copies to clipboard.
/// @param {string} _header - Header for the error popup.
/// @param {string} _message - Detailed message for the error.
/// @param {string} _stacktrace - Optional.
/// @param {string} _critical - Optional.
/// @param {string} _report_title - Optional. Preset title for the bug report.
function handle_error(_header, _message, _stacktrace="", _critical = false, _report_title="") {
    var _full_message = "";
    var _header_section = "";
    var _info_section = "";
    var _save_section = "";
    var _error_section = "";
    var _footer_section = "";

    _header_section += $"{LB_92}\n";
    _header_section += $"{_header}\n\n";
    _full_message += _header_section;

    // _info_section += $"Operating System: {os_type_format(os_type)}\n"; // Uncomment this when we start compiling for different platforms;
    _info_section += $"Date-Time: {DATE_TIME_3}\n";
    _info_section += $"Game Version: {global.game_version}\n";
    _info_section += $"Build Date: {global.build_date}\n";
    _info_section += $"Commit Hash: {global.commit_hash}\n\n";
    _full_message += _info_section;

    if (global.chapter_name != "None") {
        _save_section += $"Chapter Name: {global.chapter_name}\n";
    }
    if (instance_exists(obj_controller)) {
        _save_section += $"Current Turn: {obj_controller.turn}\n";
    }
    if (global.game_seed != 0) {
        _save_section += $"Game Seed: {global.game_seed}\n";
    }
    if (_save_section != "") {
        _full_message += "Save Details:\n";
        _full_message += $"{_save_section}\n";
    }

    _error_section += "Error Details:\n";
    _error_section += $"{_message}\n\n";
    _error_section += "Stacktrace:\n";
    _error_section += $"{_stacktrace}\n";
    _full_message += _error_section;

    _footer_section += $"{LB_92}";
    _full_message += _footer_section;

    if (_report_title != "") {
        _report_title += "\n";
    }

    var _error_file_text = $"{_report_title}{_full_message}";
    var _commit_history_link = "";
    if (global.commit_hash != "unknown hash") {
        _commit_history_link = $"https://github.com/Adeptus-Dominus/ChapterMaster/commits/{global.commit_hash}";
        _error_file_text += $"\n{_commit_history_link}";
    }

    create_error_file(_error_file_text);
    show_debug_message($"{_header_section}{_error_section}{_footer_section}");

    var _clipboard_message = "";
    _clipboard_message += $"{_report_title}";
    _clipboard_message += $"{markdown_codeblock(_full_message, "log")}\n";
    if (_commit_history_link != "") {
        _clipboard_message += $"\n{_commit_history_link}";
    }
    clipboard_set_text(_clipboard_message);

    var _player_message = "";
    _player_message += $"{_header}\n\n";
    _player_message += $"{STR_error_message}";
    _player_message += _critical ? "" : $"\n\n{STR_error_message_ps}";
    show_message(_player_message);
}

/// @function handle_exception
/// @description Manages exception display and logging with optional severity.
/// @param {exception} _exception - The exception to handle.
/// @param {string} custom_title - Optional custom title for the error popup.
/// @param {bool} critical - Whether the error is critical (default: false).
/// @param {string} error_marker - Optional marker for the error.
function handle_exception(_exception, custom_title=STR_error_message_head, critical=false, error_marker="") {
    var _header = critical ? STR_error_message_head2 : custom_title;
    var _message = _exception.longMessage;
    var _stacktrace = array_to_string_list(_exception.stacktrace);
    var _critical = critical ? "CRASH! " : "";
    var _build_date = global.build_date == "unknown build" ? "" : $"/{global.build_date}";
    var _problem_line = clean_stacktrace_line(_exception.stacktrace[0]);
    var _report_title = $"{_critical}[{global.game_version}{_build_date}] {_problem_line}";

    handle_error(_header, _message, _stacktrace, critical, _report_title);
}

/// @description Attempts to run a function and reports any errors caught.
/// @param {string} dev_marker - Developer marker for the error.
/// @param {function} func - The function to run.
/// @param {bool} turn_end - Whether to end the turn after an error.
/// @param {array} args - Arguments to pass to the function.
/// @param {function} catch_custom - Custom function to run on error.
/// @param {array} catch_args - Arguments to pass to the custom function.
function try_and_report_loop(dev_marker="Generic Error", func, turn_end=true, args=[], catch_custom=0, catch_args=[]) {
    try {
        method_call(func, args);
    } catch (_exception) {
        handle_exception(_exception, string(STR_error_message_head3, dev_marker), false, dev_marker);
        if (is_method(catch_custom)) {
            method_call(catch_custom, catch_args);
        }
    }
}

/// @description Shows a popup for errors triggered by an unexpected condition(s).
/// @param {string} _message - The message to display to the user.
/// @param {string} _header - Optional header for the popup (default: "Assertion Error").
function assert_error_popup(_message, _header="Assertion Error") {
    var _stacktrace_array = debug_get_callstack();

    array_shift(_stacktrace_array); // throw away the first line, it's this function
    array_pop(_stacktrace_array); // and the last line, it's the `0` debug_get_callstack returns for the top of the stack

    var _stacktrace = array_to_string_list(_stacktrace_array);

    handle_error(_header, _message, _stacktrace);
}

exception_unhandled_handler(function(_exception) {
    handle_exception(_exception, , true);
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
    if (_time < 10) {
        _time = $"0{_time}"
    }
    return string(_time);
}

/// @description Cleans up a stack trace line string by removing the "anon@number@", "gml_Object_" and "gml_Script_".
/// @param {string} _stacktrace_line - The stack trace line string to be cleaned.
/// @returns {string}
function clean_stacktrace_line(_stacktrace_line) {
    _stacktrace_line = string_replace(_stacktrace_line, "gml_Object_", "");
    _stacktrace_line = string_replace(_stacktrace_line, "gml_Script_", "");

    if (string_count("@", _stacktrace_line) == 2) {
        var split_parts = string_split(_stacktrace_line, "@");
        _stacktrace_line = split_parts[0] + split_parts[2];
    }

    return _stacktrace_line;
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
        os_unknown: "Unknown OS"
    };

    if (struct_exists(_os_type_dictionary, _os_type)) {
        return _os_type_dictionary[$ _os_type];
    } else {
        return _os_type_dictionary.os_unknown;
    }
}
