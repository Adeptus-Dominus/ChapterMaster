#macro LOGGER global.logger

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
