enum eMSG_COLOR {
    DEFAULT = 0,
    WHITE = 1,
    AQUA = 5,
    RED = 6,
    YELLOW = 8,
}

/// @param {Id.Instance} _owner The optional owning instance or controller.
function CombatLog(_owner = undefined) constructor {
    // Private fields
    __owner = _owner;
    /// @type {Array<Struct>}
    __pending_messages = [];
    /// @type {Array<Struct>}
    __log_history = [];
    __log_scroll = 0;
    __log_dragging = false;

    // Public readonly fields
    pending_count = 0;
    log_size = 0;

    // Public fields
    log_max_width = 780;
    log_line_height = 18;
    log_font = undefined;
    log_messages_per_frame = 3;
    log_history_max = 500;
    log_view_lines = 45;

    /// @desc Helper to wrap text into an array of lines based on the max width.
    /// @param {String} _text Input text.
    /// @param {Real} _max_w Maximum width.
    /// @return {Array<String>}
    static wrap_text = function(_text, _max_w) {
        if (_max_w <= 0) {
            return [_text];
        }

        // If the entire text already fits, skip word-by-word loop entirely.
        if (string_width(_text) <= _max_w) {
            return [_text];
        }

        var _words = string_split(_text, " ");
        var _lines = [];
        var _current_line = "";
        var _word_count = array_length(_words);

        for (var i = 0; i < _word_count; i++) {
            var _word = _words[i];
            if (_word == "" && _current_line != "") {
                continue;
            }

            var _test_line = (_current_line == "") ? _word : (_current_line + " " + _word);

            if (string_width(_test_line) > _max_w) {
                if (_current_line != "") {
                    array_push(_lines, _current_line);
                    _current_line = _word;
                } else {
                    array_push(_lines, _word);
                    _current_line = "";
                }
            } else {
                _current_line = _test_line;
            }
        }

        if (_current_line != "") {
            array_push(_lines, _current_line);
        }

        return (array_length(_lines) > 0) ? _lines : [_text];
    };

    /// @desc Push a new message onto the combat log queue.
    /// @param {String} _text The text to log.
    /// @param {Real} _color Optional eMSG_COLOR enum.
    static push = function(_text = "", _color = eMSG_COLOR.WHITE) {
        array_push(__pending_messages, {text: _text, color: _color});
        pending_count++;
    };

    /// @desc Drain all pending messages from the queue, format them, and append to scrollback.
    static drain = function() {
        if (pending_count == 0) {
            return;
        }

        var _process_count = (log_messages_per_frame > 0) ? min(log_messages_per_frame, pending_count) : pending_count;

        var _old_font = draw_get_font();
        if (log_font != undefined) {
            draw_set_font(log_font);
        }

        for (var k = 0; k < _process_count; k++) {
            var _msg = __pending_messages[k];
            var _text = _msg.text;
            var _color_enum = _msg.color;

            // Resolve message base color
            var _final_color = CM_GREEN_COLOR;
            switch (_color_enum) {
                case eMSG_COLOR.DEFAULT:
                    _final_color = CM_GREEN_COLOR;
                    break;
                case eMSG_COLOR.WHITE:
                    _final_color = c_silver;
                    break;
                case eMSG_COLOR.AQUA:
                    _final_color = c_aqua;
                    break;
                case eMSG_COLOR.RED:
                    _final_color = CM_RED_COLOR;
                    break;
                case eMSG_COLOR.YELLOW:
                    _final_color = 3055825;
                    break;
            }

            // Wrap individual line segment if width limits are set
            var _wrapped_lines = wrap_text(_text, log_max_width);
            var _line_count = array_length(_wrapped_lines);

            for (var j = 0; j < _line_count; j++) {
                array_push(__log_history, {text: _wrapped_lines[j], color: _final_color});
                log_size++;
            }
        }

        if (_process_count == pending_count) {
            array_resize(__pending_messages, 0);
            pending_count = 0;
        } else {
            array_delete(__pending_messages, 0, _process_count);
            pending_count -= _process_count;
        }

        if (log_font != undefined) {
            draw_set_font(_old_font);
        }

        var _history_len = array_length(__log_history);
        if (_history_len > log_history_max) {
            array_delete(__log_history, 0, _history_len - log_history_max);
            log_size -= _history_len - log_history_max;
        }
    };

    /// @desc Render the combat log display.
    /// @param {Real} _x The x coordinate.
    /// @param {Real} _y The y coordinate.
    static draw = function(_x, _y) {
        // Drain pending queue at draw time
        drain();

        var _log_total = array_length(__log_history);
        if (_log_total == 0) {
            return;
        }

        // Calculate active slice of log history based on scroll settings
        var _start_index = max(0, _log_total - log_view_lines - __log_scroll);
        var _draw_count = min(log_view_lines, _log_total - _start_index);

        // Draw active lines
        add_draw_return_values();

        if (log_font != undefined) {
            draw_set_font(log_font);
        }

        for (var i = 0; i < _draw_count; i++) {
            var _item = __log_history[_start_index + i];
            draw_set_color(_item.color);

            var _line_y = _y - 10 + ((i + 1) * log_line_height);
            draw_text(_x + 6, _line_y, string(_item.text));
        }

        // Render scrollbar if the list overflows the panel limits
        if (_log_total > log_view_lines) {
            var _sb_x1 = _x + 2;
            var _sb_x2 = _x + 4;
            var _sb_y1 = _y + 8;
            var _sb_h = log_view_lines * log_line_height;
            var _sb_max_scroll = _log_total - log_view_lines;
            var _sb_thumb_h = max(20, _sb_h * (log_view_lines / _log_total));
            var _sb_frac = __log_scroll / _sb_max_scroll;
            var _sb_thumb_y1 = _sb_y1 + (1 - _sb_frac) * (_sb_h - _sb_thumb_h);

            draw_set_color(CM_GREEN_COLOR);
            draw_set_alpha(0.3);
            draw_rectangle(_sb_x1, _sb_y1, _sb_x2, _sb_y1 + _sb_h, false);
            draw_set_alpha(1.0);
            draw_rectangle(_sb_x1, _sb_thumb_y1, _sb_x2, _sb_thumb_y1 + _sb_thumb_h, false);
        }

        pop_draw_return_values();
    };

    /// @desc Update scroll state from mouse input over the log panel boundaries.
    /// @param {Real} _x The x coordinate.
    /// @param {Real} _y The y coordinate.
    /// @param {Real} _w The width.
    /// @param {Real} _h The height.
    static update_scroll = function(_x, _y, _w, _h) {
        var _log_total = array_length(__log_history);
        var _log_max_scroll = max(0, _log_total - log_view_lines);

        // Handle scroll wheel interactions
        if (scr_hit(_x, _y, _x + _w, _y + _h)) {
            if (mouse_wheel_up()) {
                __log_scroll += 3;
            }

            if (mouse_wheel_down()) {
                __log_scroll -= 3;
            }
        }

        // Handle scrollbar drag interactions
        var _sb_y1 = _y + 8;
        var _sb_h = log_view_lines * log_line_height;
        var _mouse_on_scrollbar = (mouse_x >= _x + 1) && (mouse_x <= _x + 5) && (mouse_y >= _sb_y1) && (mouse_y <= _sb_y1 + _sb_h);

        if (mouse_check_button_pressed(mb_left) && (_log_max_scroll > 0) && _mouse_on_scrollbar) {
            __log_dragging = true;
        }

        if (!mouse_check_button(mb_left)) {
            __log_dragging = false;
        }

        if (__log_dragging && (_log_max_scroll > 0)) {
            var _sb_thumb_h = max(20, _sb_h * (log_view_lines / _log_total));
            var _sb_usable = max(1, _sb_h - _sb_thumb_h);
            var _sb_rel = clamp((mouse_y - _sb_y1 - _sb_thumb_h * 0.5) / _sb_usable, 0, 1);
            __log_scroll = round((1 - _sb_rel) * _log_max_scroll);
        }

        __log_scroll = clamp(__log_scroll, 0, _log_max_scroll);
    };
}
