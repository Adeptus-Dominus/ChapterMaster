company = 0;
manage = 0;
header = 0;

title = "";
occupants = "";

panel_width = 0;
panel_height = 0;

line = [];
slate_panel = new DataSlate();

scroll_active = 0;
scroll_delay = 0;
scroll_offset = 0;
draw_lines = function(_x, _y, increment, truncate_line) {
    var _total_lines = array_length(line);

    if (_total_lines > 16) {
        if (!scroll_active) {
            scroll_delay++;
        }
        if (scroll_delay > 45) {
            scroll_active = 1;
            scroll_delay = 0;
        }
        if (scroll_active == 1) {
            scroll_offset++;
        } else if (scroll_active == 2) {
            scroll_offset--;
        }
    }

    for (var l = 0; l < array_length(line); l++) {
        var _y_depth = l * increment;

        if ((_y_depth - scroll_offset) < 0) {
            continue;
        }

        if (_y_depth - scroll_offset > (increment * 16)) {
            continue;
        }

        draw_set_font(fnt_40k_12);
        var _draw_func = draw_text;
        var _is_struct = is_struct(line[l]);
        if (_is_struct) {
            var _struc = line[l];
            if (_struc.italic) {
                draw_set_font(fnt_40k_12i);
            }
            if (_struc.bold) {
                _draw_func = draw_text_bold;
            }
            var _line = truncate_line ? string_truncate(_struc.str1, 134) : _struc.str1;
        } else {
            var _line = truncate_line ? string_truncate(line[l], 134) : line[l];
        }
        _draw_func(_x, _y + _y_depth - scroll_offset, _line);

        if (scroll_active == 1 && l == _total_lines - 1) {
            if (_y_depth - scroll_offset < increment * 12) {
                scroll_active = 2;
            }
        }
        if (scroll_active == 2 && scroll_offset == 0) {
            scroll_active = 0;
        }
    }
};
