#macro STR_error_message_head $"Your game just encountered and caught an error!"
#macro STR_error_message_head2 $"Your game just encountered a critical error! :("
#macro STR_error_message_head3 $"Your game just encountered and caught an error! ({0})"
#macro STR_error_message $"The error log is automatically copied into your clipboard and a copy is created at: \nC:>Users>(UserName)>AppData>Local>ChapterMaster>Logs\n\nPlease, follow these steps:\n1) Create a bug report on our 'Chapter Master Discord' server.\n2) Press CTRL+V to paste the error log.\n3) Title the report with the error log's first line.\n4) If the log isn't pasted, locate and attach the latest error log file.\n\nThank you!"
#macro STR_error_message_ps $"P.S. You can ALT-TAB and try to continue playing, though it’s recommended to wait for a response in the bug-report forum."

/// @description Logs the _message into a file in the Logs folder.
/// @param {string} _message - The message to log.
function create_error_file(_message) {
    if (string_length(_message) > 0) {
        var _date_time = $"{DATE_TIME_1}";
        var _log_file = file_text_open_write("Logs/" + $"{_date_time}_error.log");
        file_text_write_string(_log_file, _message);
        file_text_close(_log_file);
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
    _full_message += $"{LB_92}\n";
    _full_message += $"{_header}\n\n";
    _full_message += $"Date-Time: {DATE_TIME_3}\n"; 
    var _format_version = string_split(global.game_version, "/");
    _full_message += $"Game Version: {_format_version[0]}\n"; 
    _full_message += $"Build Date: {global.build_date}\n";
    _full_message += $"Commit Hash: {global.commit_hash}\n\n";
    _full_message += $"Details:\n";
    _full_message += $"{_message}\n\n";
    _full_message += $"Stacktrace:\n";
    _full_message += $"{_stacktrace}\n";
    _full_message += $"{LB_92}";

    if (_report_title != "") {
        _report_title += "\n";
    }

    var _commit_history_link = $"https://github.com/EttyKitty/ChapterMaster/commits/{global.commit_hash}";

    create_error_file($"{_report_title}{_full_message}\n{_commit_history_link}");
    show_debug_message(_full_message);

    var _clipboard_message = "";
    _clipboard_message += $"{_report_title}";
    _clipboard_message += $"{markdown_codeblock(_full_message, "log")}\n";
    _clipboard_message += $"{_commit_history_link}";
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
    var _report_title = $"[{global.game_version}] {_exception.stacktrace[0]}";
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
