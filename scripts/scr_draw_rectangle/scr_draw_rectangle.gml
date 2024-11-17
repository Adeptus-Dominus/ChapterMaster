/// @function draw_rectangle_color_simple
/// @description This function will draw a rectangle in a similar way to draw_rectangle_color() and draw_rectangle, only now there is only 1 color param, alpha is optional and outline param is supported.
function draw_rectangle_color_simple(_x, _y, _x2, _y2, outline=false, _color, _alpha=1){
    var _cur_color = draw_get_color();
    var _cur_alpha = draw_get_alpha();
    draw_set_color(_color);
    draw_set_alpha(_alpha);
    draw_rectangle(_x, _y, _x2, _y2, outline);
    draw_set_color(_cur_color);
    draw_set_alpha(_cur_alpha);
}

function draw_rectangle_outline(_x, _y, _x2, _y2, _bg_color = c_black, _outline_color = c_gray, _alpha=1){
    var _cur_color = draw_get_color();
    var _cur_alpha = draw_get_alpha();

    draw_set_color(_bg_color);
    draw_set_alpha(_alpha);
    draw_rectangle(_x, _y, _x2, _y2, 0);
    draw_set_color(_outline_color);
    draw_rectangle(_x, _y, _x2, _y2, 1);

    draw_set_color(_cur_color);
    draw_set_alpha(_cur_alpha);
}