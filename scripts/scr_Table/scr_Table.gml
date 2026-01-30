function Table(data) constructor {
    headings = [];
    row_data = [];
    standard_loc_data();
    row_h = 12;

    column_widths = [];

    set_column_widths = [];

    row_key_draw = [];

    halign = fa_center;

    header_h = 0;

    col_spacing = 5;

    move_data_to_current_scope(data);

    update();

    static update = function(data) {
        move_data_to_current_scope(data);
        w = 0;
        column_widths = [];
        header_h = 0;
        for (var i = 0; i < array_length(headings); i++) {
            var _col_width = 0;
            var _heading = headings[i];
            if (is_string(_heading)) {
                headings[i] = new ReactiveString(_heading, 0, 0, {scale_text: true});
            }

            var _heading = headings[i];

            if (i < array_length(set_column_widths) && set_column_widths[i] > 0) {
                array_push(column_widths, set_column_widths[i]);
            } else {
                if (array_length(column_widths) <= i) {
                    array_push(column_widths, _heading.w);
                }
                if (column_widths[i] == 0) {
                    column_widths[i] = _heading.w;
                }
            }

            _heading.update({max_width: column_widths[i], x1: x1 + w + (column_widths[i] / 2), y1: y1, halign: halign});

            if (_heading.h > header_h) {
                header_h = _heading.h;
            }

            w += column_widths[i] + col_spacing;
        }
    };

    static draw = function() {
        add_draw_return_values();

        draw_set_halign(halign);
        draw_set_valign(fa_top);

        var _col_draw_x = x1;
        for (var i = 0; i < array_length(headings); i++) {
            var _heading = headings[i];
            _heading.draw();
        }

        var _row_level = y1 + header_h + 5;
        var _cols = array_length(column_widths);
        for (var i = 0; i < array_length(row_data); i++) {
            //TODO add built in support for scrolling tables
            if (_row_level > y2 - row_h) {
                break;
            }
            _col_draw_x = x1;
            var _row = row_data[i];
            var _row_entered = scr_hit_dimensions(_col_draw_x, _row_level, w, row_h);
            if (is_array(row_data[i])) {
                for (var d = 0; d < array_length(_row) && d < _cols; d++) {
                    draw_text(_col_draw_x + (column_widths[d] / 2), _row_level, _row[d]);
                    _col_draw_x += column_widths[d] + col_spacing;
                }
            } else if (is_struct(_row)) {
                for (var d = 0; d < array_length(row_key_draw) && d < _cols; d++) {
                    var _key = row_key_draw[d];
                    draw_text(_col_draw_x + (column_widths[d] / 2), _row_level, _row[$ _key]);
                    _col_draw_x += column_widths[d] + col_spacing;
                }
                if (_row_entered && struct_exists(_row, "hover")) {
                    //global.logger.debug($"click : {struct_exists(_row,"click_left")}");
                    _row.hover();
                }
                if (_row_entered && struct_exists(_row, "click_left")) {
                    if (scr_click_left()) {
                        _row.click_left();
                    }
                }
            }

            _row_level += row_h;
        }
        pop_draw_return_values();
    };
}
