function Table(data) constructor {
    headings = [];
    row_data = [];
    standard_loc_data();
    row_h = 12;

    column_widths = [];

    set_column_widths = [];

    row_key_draw = [];

    halign = fa_center;

    colour = CM_GREEN_COLOR;

    header_h = 0;

    col_spacing = 5;

    font = fnt_40k_14;

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

    static row_method = function(_row, _row_entered){

        if (!_row_entered){
            return;
        }

        if (struct_exists(_row, "hover")) {
            //LOGGER.debug($"click : {struct_exists(_row,"click_left")}");
            _row.hover();
        }

        if (struct_exists(_row, "click_left")) {
            if (mouse_button_clicked()) {
                _row.click_left();
            }
        }

        if (struct_exists(_row,"click_right")){
            if (mouse_button_clicked(mb_right)){
                _row.click_right();
            }
        } 
    }

    static row_count = function(){
        return array_length(row_data);
    }


    static draw = function() {
        add_draw_return_values();

        draw_set_halign(halign);
        draw_set_valign(fa_top);
        draw_set_color(colour);
        draw_set_font(font);

        row_h = max(row_h, string_height("a") + 1);

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
            var _row_entered = scr_hit_dimensions(_col_draw_x, _row_level, w, row_h);
            
            var _row = row_data[i];
            if (is_array(row_data[i])) {
                for (var d = 0; d < array_length(_row) && d < _cols; d++) {
                    draw_text(_col_draw_x + (column_widths[d] / 2), _row_level, _row[d]);
                    _col_draw_x += column_widths[d] + col_spacing;
                }
            } else if (is_struct(_row)) {
                for (var d = 0; d < array_length(row_key_draw) && d < _cols; d++) {
                    var _key = row_key_draw[d];
                    var _scale_edits = calc_text_scale_confines(_row[$ _key], column_widths[d], 0);
                    var _scale = min(1,_scale_edits.scale);
                    var _text = _scale_edits.text;
                    draw_text_transformed(_col_draw_x + (column_widths[d] / 2),_row_level, _text, _scale,_scale, 0)
                    _col_draw_x += column_widths[d] + col_spacing;
                }
            }

            if (_row_entered){
                draw_rectangle(x1, _row_level, x1 + w, _row_level + row_h, 1);
            }

            if (is_struct(_row)) {
                row_method(_row, _row_entered);
            }

            _row_level += row_h;
        }
        pop_draw_return_values();
    };
}
