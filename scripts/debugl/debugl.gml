/// @desc Writes a string into the last_messages.log.
/// @param {string} _string
function debugl(_string) {
    var _log_file = file_text_open_append("logs/" + $"last_messages.log");

    file_text_write_string(_log_file, _string + "\n");
    file_text_close(_log_file);
}
