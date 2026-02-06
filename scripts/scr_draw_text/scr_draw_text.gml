/// @function draw_text_bold
/// @description This function will draw text in a similar way to draw_text(), only now the text will be drawn twice with a slight offset, to make it look thicker.
function draw_text_bold(_x, _y, _text) {
    draw_text(_x, _y, _text);
    draw_text(_x + 0.5, _y + 0.5, _text);
}

/// @function draw_text_color_simple(_x, _y, _string, _color, _alpha=1)
/// @description
function draw_text_color_simple(_x, _y, _string, _color, _alpha = 1) {
    var _cur_color = draw_get_color();
    var _cur_alpha = draw_get_alpha();
    draw_set_color(_color);
    draw_set_alpha(_alpha);
    draw_text(_x, _y, _string);
    draw_set_color(_cur_color);
    draw_set_alpha(_cur_alpha);
}

/// @function draw_text_glow
/// @description This function will draw text in a similar way to draw_text(), only now the text will have a glow effect.
function draw_text_glow(_x, _y, _text, _text_color, _glow_color) {
    var _cur_color = draw_get_color();
    // Draw the glow by repeatedly drawing the text with a slight offset and reduced alpha
    draw_set_color(_glow_color);
    for (var i = -3; i <= 3; i++) {
        for (var j = -3; j <= 3; j++) {
            if (i != 0 || j != 0) {
                // Avoid drawing the main text here
                draw_set_alpha(0.05); // Adjust the alpha for the desired intensity of the glow
                draw_text(_x + i, _y + j, _text);
            }
        }
    }
    draw_set_alpha(1);
    draw_set_color(_text_color);
    draw_text(_x, _y, _text);
    draw_set_color(_cur_color);
}

/// @function draw_text_glow_transformed
/// @description This function will draw text in a similar way to draw_text(), only now the text will have a glow effect.
function draw_text_glow_transformed(_x, _y, _text, _text_scale = [1, 1], _angle = 0, _text_color, _glow_color) {
    var _cur_color = draw_get_color();
    var _x_scale = _text_scale[0];
    var _y_scale = _text_scale[1];
    // Draw the glow by repeatedly drawing the text with a slight offset and reduced alpha
    draw_set_color(_glow_color);
    for (var i = -3; i <= 3; i++) {
        for (var j = -3; j <= 3; j++) {
            if (i != 0 || j != 0) {
                // Avoid drawing the main text here
                draw_set_alpha(0.05); // Adjust the alpha for the desired intensity of the glow
                draw_text(_x + i, _y + j, _text);
            }
        }
    }
    draw_set_alpha(1);
    draw_set_color(_text_color);
    draw_text_transformed(_x, _y, _text, _x_scale, _y_scale, _angle);
    draw_set_color(_cur_color);
}

/// @function draw_text_outline
/// @description This function will draw text in a similar way to draw_text(), only now the text will have an outline that may improve readability.
function draw_text_outline(_x, _y, _text, _outl_col = c_black, _text_col = -1) {
    var _cur_color = draw_get_color();
    draw_set_color(_outl_col);
    draw_text(_x - 1.5, _y, _text);
    draw_text(_x + 1.5, _y, _text);
    draw_text(_x, _y - 1.5, _text);
    draw_text(_x, _y + 1.5, _text);
    if (_text_col != -1) {
        draw_set_color(_text_col);
    } else {
        draw_set_color(_cur_color);
    }
    draw_text(_x, _y, _text);
    draw_set_color(_cur_color);
}

/// @function draw_text_ext_outline
/// @description This function will draw text in a similar way to draw_text_ext(), only now the text will have an outline that may improve readability.
function draw_text_ext_outline(_x, _y, _text, _sep = -1, _w = 9999, _outl_col = c_black, _text_col = 0) {
    var _cur_color = draw_get_color();
    draw_set_color(_outl_col);
    draw_text_ext(_x - 1.5, _y, _text, _sep, _w);
    draw_text_ext(_x + 1.5, _y, _text, _sep, _w);
    draw_text_ext(_x, _y - 1.5, _text, _sep, _w);
    draw_text_ext(_x, _y + 1.5, _text, _sep, _w);
    if (_text_col != 0) {
        draw_set_color(_text_col);
    } else {
        draw_set_color(_cur_color);
    }
    draw_text_ext(_x, _y, _text, _sep, _w);
    draw_set_color(_cur_color);
}

/// @function draw_text_transformed_outline
/// @description This function will draw text in a similar way to draw_text_transformed(), only now the text will have an outline that may improve readability.
function draw_text_transformed_outline(_x, _y, _text, _xscale = -1, _yscale = 1, _angle = 0, _outl_col = c_black, _text_col = 0) {
    var _cur_color = draw_get_color();
    draw_set_color(_outl_col);
    draw_text_transformed(_x - 1.5, _y, _text, _xscale, _yscale, _angle);
    draw_text_transformed(_x + 1.5, _y, _text, _xscale, _yscale, _angle);
    draw_text_transformed(_x, _y - 1.5, _text, _xscale, _yscale, _angle);
    draw_text_transformed(_x, _y + 1.5, _text, _xscale, _yscale, _angle);
    if (_text_col != 0) {
        draw_set_color(_text_col);
    } else {
        draw_set_color(_cur_color);
    }
    draw_text_transformed(_x, _y, _text, _xscale, _yscale, _angle);
    draw_set_color(_cur_color);
}

/// @function draw_text_shadow
/// @description This function will draw text in a similar way to draw_text(), only now the text will have a diagonal shadow.
function draw_text_shadow(_x, _y, _text) {
    var _cur_color = draw_get_color();
    draw_set_color(c_black);
    draw_text(_x - 1, _y + 1, _text);
    draw_set_color(_cur_color);
    draw_text(_x, _y, _text);
}

function calc_text_scale_confines(text, width, buffer = 0) {
    var _scale = 1;
    var _string_width = string_width(text);
    if (_string_width > (width - buffer)) {
        _scale = (width - buffer) / _string_width;
    }

    return _scale;
}

/// @function draw_text_ext_shadow
/// @description This function will draw text in a similar way to draw_text_ext(), only now the text will have a diagonal shadow.
function draw_text_ext_shadow(_x, _y, _text, _sep = -1, _w = 9999) {
    var _cur_color = draw_get_color();
    draw_set_color(c_black);
    draw_text_ext(_x - 1, _y + 1, _text, _sep, _w);
    draw_set_color(_cur_color);
    draw_text_ext(_x, _y, _text, _sep, _w);
}

/// @desc This function will draw text like draw_text(), but with a custom alpha.
function draw_text_alpha(_x, _y, _text, _alpha) {
    var _cur_alpha = draw_get_alpha();
    draw_set_alpha(_alpha);
    draw_text(_x, _y, _text);
    draw_set_alpha(_cur_alpha);
}
