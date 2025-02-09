/// @desc Writes a string into the last_messages.log.
/// @param {string} _text
function debugl(_type, _source, _text) {
    var _log_file = file_text_open_append(PATH_last_messages);

    file_text_write_string(_log_file, $"[{DATE_TIME_2}] [{_type}] ({_source}): {_text}" + "\n");
    file_text_close(_log_file);
}

function log_error(_text) {
    var _current_call = debug_get_current_call(2);
    debugl("Error", _current_call, _text);
}

function log_message(_text) {
    var _current_call = debug_get_current_call(2);
    debugl("Message", _current_call, _text);
}

function log_warning(_text) {
    var _current_call = debug_get_current_call(2);
    debugl("Warning", _current_call, _text);
}

function show_debug_message_time(_text) {
    show_debug_message($"[{TIME_1}] {_text}");
}

function debug_get_current_call(_depth = 1) {
    var _callstack = debug_get_callstack();
    return string(_callstack[_depth]);
}
