function SimplePanel(_x1, _y1, _x2, _y2) constructor {
    x1 = _x1;
    y1 = _y1;
    x2 = _x2;
    y2 = _y2;
    x3 = (x1 + x2) / 2;
    y3 = (y1 + y2) / 2;
    width = x2 - x1;
    height = y2 - y1;
    back_colour = c_black;
    border_colour = COL_GREEN;
    alpha = 1;

    static draw = function() {
        draw_set_alpha(alpha);

        draw_set_color(back_colour);
        draw_rectangle(x1, y1, x2, y2, false);

        draw_set_color(border_colour);
        var _offset_step = 3 / (4 - 1);
        var _alpha_step = alpha / 4;
        for (var i = 0; i < 4; i++) {
            var _current_offset = round(i * _offset_step);
            var _current_alpha = alpha - (i * _alpha_step);
            _current_alpha = clamp(_current_alpha, 0, 1);

            draw_set_alpha(_current_alpha);

            draw_rectangle(x1 + _current_offset, y1 + _current_offset, x2 - _current_offset, y2 - _current_offset, true);
        }

        draw_set_alpha(1);
        draw_set_color(c_white);
    };
}
