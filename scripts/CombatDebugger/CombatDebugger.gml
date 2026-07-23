enum eCOMBAT_CATEGORY {
    SYSTEM,
    TARGETING,
    SHOOTING,
    DAMAGE,
    CLEANUP,
    __COUNT,
}

// TODO: Convert this into a BufferedFileWriter or BufferedFileLogger, decoupling from specific combat logic; Then maybe even use in the Logger class for 0 I/O overhead;
/// @description Buffers structured combat debug entries directly to memory and dumps them to a log file.
/// @param {Bool} _active Whether this debugger starts active (default: false)
function CombatDebugger(_active = false) constructor {
    active = _active;

    categories = array_create(eCOMBAT_CATEGORY.__COUNT, true);

    __log_buffer = buffer_create(16384, buffer_grow, 1);

    static category_names = [
        "SYSTEM",
        "TARGETING",
        "SHOOTING",
        "DAMAGE",
        "CLEANUP",
    ];

    /// @description Writes a single line to the given buffer.
    /// @param {Id.Buffer} _buf
    /// @param {String} _str
    static __write_line = function(_buf, _str) {
        buffer_write(_buf, buffer_text, _str + "\n");
    };

    /// @description Add a debug entry to the buffer.
    /// @param {Enum.eCOMBAT_CATEGORY} _category Message prefix
    /// @param {String} _message The message to log
    static add = function(_category, _message) {
        if (!active) {
            return self;
        }

        if (_category < 0 || _category >= eCOMBAT_CATEGORY.__COUNT) {
            return self;
        }

        var _enabled = categories[_category];
        if (!_enabled) {
            return self;
        }

        var _cat_name = category_names[_category];

        var _time = $"{format_time(current_hour)}:{format_time(current_minute)}:{format_time(current_second)}";
        var _line = $"{_time} | [{_cat_name}] {_message}\n";

        buffer_write(__log_buffer, buffer_text, _line);

        return self;
    };

    /// @description Writes to disk, and resets.
    /// @param {Struct} _battle_info Optional battle info struct to include in the header
    static flush = function(_battle_info = undefined) {
        if (!buffer_exists(__log_buffer)) {
            return self;
        }

        var _log_size = buffer_tell(__log_buffer);
        if (_log_size == 0) {
            reset();
            return self;
        }

        var _date_str = $"{current_year}-{format_time(current_month)}-{format_time(current_day)}";
        var _time_str = $"{format_time(current_hour)}{format_time(current_minute)}{format_time(current_second)}";
        var _filename = $"{PATH_LOG_DIRECTORY}combat_debug_{_date_str}_{_time_str}.log";

        var _final_buffer = buffer_create(_log_size + 1024, buffer_grow, 1);

        __write_line(_final_buffer, "=== COMBAT DEBUG LOG ===");
        __write_line(_final_buffer, $"Date: {date_datetime_string(date_current_datetime())}");

        if (is_struct(_battle_info)) {
            var _keys = variable_struct_get_names(_battle_info);
            var _len = array_length(_keys);
            for (var i = 0; i < _len; i++) {
                var _key = _keys[i];
                __write_line(_final_buffer, $"{_key}: {_battle_info[$ _key]}");
            }
        }

        __write_line(_final_buffer, "========================================");
        __write_line(_final_buffer, "");

        var _dest_offset = buffer_tell(_final_buffer);
        buffer_copy(__log_buffer, 0, _log_size, _final_buffer, _dest_offset);

        buffer_seek(_final_buffer, buffer_seek_start, _dest_offset + _log_size);
        __write_line(_final_buffer, "\n=== END OF COMBAT DEBUG LOG ===");

        buffer_save_ext(_final_buffer, _filename, 0, buffer_tell(_final_buffer));
        buffer_delete(_final_buffer);

        reset();

        return self;
    };

    /// @description Rewind the buffer pointer, resetting state.
    static reset = function() {
        if (buffer_exists(__log_buffer)) {
            buffer_seek(__log_buffer, buffer_seek_start, 0);
        }

        return self;
    };

    /// @description MUST be called when destroying this struct to prevent memory leaks.
    static cleanup = function() {
        if (buffer_exists(__log_buffer)) {
            buffer_delete(__log_buffer);
            __log_buffer = -1;
        }

        return self;
    };
}
