/// @desc Writes a string into the last_messages.log.
/// @param {string} _string
function debugl(_string) {
    var _log_file = file_text_open_append(PATH_last_messages);

    file_text_write_string(_log_file, $"[{DATE_TIME_2}] {_string}" + "\n");
    file_text_close(_log_file);
}

function show_debug_message_time(_string) {
    show_debug_message($"[{TIME_1}] {_string}");
}