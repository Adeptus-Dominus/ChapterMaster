function draw_line_dashed(x_start, y_start, x_end, y_end, dash_length, line_width) {
    // Script draw_line_dashed()
    // x_start, y_start: x,y coords of start
    // x_end, y_end: x,y coords of end
    // dash_length: Length of dashes
    // line_width: Width of line

    var len, ang, inc_x, inc_y, c, m;
    len = point_distance(x_start, y_start, x_end, y_end);
    ang = point_direction(x_start, y_start, x_end, y_end);
    inc_x = lengthdir_x(dash_length, ang);
    inc_y = lengthdir_y(dash_length, ang);
    c = 0;
    for (m = 0; m < len; m += dash_length * 2) {
        draw_line_width(x_start + inc_x * c, y_start + inc_y * c, x_start + inc_x * (c + 1), y_start + inc_y * (c + 1), line_width);
        c += 2;
    }
}
