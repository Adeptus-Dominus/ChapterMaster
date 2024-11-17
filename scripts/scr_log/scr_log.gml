/// @function log_into_file
/// @description Creates an error file in the logs folder and puts _message there.
/// @param {string} _message string to put into the error log.
function log_into_file(_message) {
    if (string_length(_message) > 0) {
        var _entry = string(_message);
        var _date_time = $"{START_DATE_TIME_1}";
        var _log_file = file_text_open_write("logs/" + $"{_date_time}_error.log");
    
        file_text_write_string(_log_file, _entry);
        file_text_close(_log_file);
    }
}

function try_and_report_loop(dev_marker="",func, turn_end=true, args=[], catch_custom=0, catch_args=[]) {
    try{
        method_call(func,args);
    } catch (_exception){
        handle_exception(_exception, string(STR_error_message_head3, dev_marker), undefined, true, dev_marker);

        if (is_method(catch_custom)) {
            method_call(catch_custom, catch_args);
        }
    }
}

/// @function handle_exception
/// @description Accepts an exception to display an error and log it.
/// @param {struct} _exception exception struct.
/// @param {string} custom_name custom error name to display in the title.
function handle_exception(_exception, custom_title = STR_error_message_head, custom_message = MSG_error_message, non_critical = true, error_marker = ""){
    #macro STR_error_message_head "Your game just encountered and caught an error :("
    #macro STR_error_message_head2 "Your game just encountered a critical error :("
    #macro STR_error_message_head3 "Your game just encountered and caught an error ({0}) :("
    #macro MSG_error_message $"The error log is automatically copied into your clipboard and a copy is created at: \nC:>Users>(UserName)>AppData>Local>ChapterMaster>ErrorLogs \n\nPlease, do the following: \n\n1) Create a bug report on the bug-report-forum in our 'Chapter Master Discord' server. \n\n2) Press CTRL+V to paste the error log into the bug report. \n\n3) Title your report by cutting and pasting the first line of the main message (it contains game version and file that caused the error). \n\n4) If for some reason the error log wasn't pasted, find the location that is mentioned above and attach the latest (sort by time) _error.log to your bug report. In this case you can name your report as you wish. \n\n\nThank you :)"
    #macro MSG_error_message_ps $"P.S. You can ALT-TAB and try to continue playing - if the error is not severe, the game should continue working, just try to avoid what caused it. \n\nBut it's recommended to wait for a response on the bug-report forum, otherwise you may make the issue worse."

    var _popup_header = $"{custom_title}\n\n";
    var _popup_message = $"{custom_message}";
    var _player_message = _popup_header + _popup_message;
    if (non_critical) then _player_message += $"\n\n\n{MSG_error_message_ps}";

    show_message(_player_message);

    var _formatted_stacktrace = array_to_string_list(_exception.stacktrace);
    var _line_break = LB_92;
    var _full_message = "";
    var _report_title = $"[{global.game_version}] {_exception.stacktrace[0]}\n";

    _full_message = $"{_line_break}\n";
    _full_message += non_critical ? $"Caught an Exception!" : $"Unhandled Exception!";
    _full_message += error_marker == "" ? $"\n" : $" ({error_marker})\n";
    _full_message += $"Game Version: {global.game_version}; Build Date: {global.build_date};\n\n";
    _full_message += $"{_exception.longMessage}\n\n";
    _full_message += $"Stacktrace:\n";
    _full_message += $"{_formatted_stacktrace}\n";
    _full_message += $"{_line_break}";

    log_into_file(_full_message);
    show_debug_message(_full_message);
    clipboard_set_text(_report_title + markdown_codeblock(_full_message));
}

exception_unhandled_handler(function(_exception) {
    handle_exception(_exception, STR_error_message_head2, undefined, false);
    return 0;
});

/// @function markdown_codeblock
/// @description Puts codeblock symbols around a string.
/// @param {string} _message
/// @return {string}
function markdown_codeblock(_message) {
    if (string_length(_message) > 0) {
        var _formatted_message = "```\n" +_message + "\n```";
        return _formatted_message;
    }
    return;
}