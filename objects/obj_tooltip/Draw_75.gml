/// @description Insert description here
// You can write your code in this editor

for (var i = 0; i < array_length(tooltip_data); i++) {
    var _tooltip = string_hash_to_newline(tooltip_data[i].tooltip);
    var _width = tooltip_data[i].width;
    var _coords = tooltip_data[i].coords;
    var _text_color = tooltip_data[i].text_color;
    var _font = tooltip_data[i].font;
    var _header = string_hash_to_newline(tooltip_data[i].header);
    var _header_font = tooltip_data[i].header_font;
    var _footer = string_hash_to_newline(tooltip_data[i].footer);
    var _footer_font = tooltip_data[i].footer_font;
    var _force_width = tooltip_data[i].force_width;
    var _cost = tooltip_data[i].cost;
    var _screen_vpadding = 30;
    var _screen_hpadding = 60;
    var _header_h = 0;
    var _header_w = 0;
    var _footer_h = 0;
    var _footer_w = 0;
    var _cursor_offset = 20;

    // Calculate padding and rectangle size
    var _text_padding_x = 12;
    var _text_padding_y = 12;

    // Define tooltip position
    var _rect_x = _coords[0] + _cursor_offset;
    var _rect_y = _coords[1] + _cursor_offset;

    add_draw_return_values();

    // Set the font for the tooltip text and calculate its size
    draw_set_font(_font);
    var _text_w = _force_width ? _width : max(string_width(_tooltip), _width);
    var _text_h = string_height_ext(_tooltip, DEFAULT_LINE_GAP, _text_w);

    // If a header is provided, calculate its size and adjust the rectangle size
    if (_header != "") {
        // Set the font for the header and calculate its size
        draw_set_font(_header_font);
        _header_w = _force_width ? _width : max(string_width(_header), _width);
        _header_h = string_height_ext(_header, DEFAULT_LINE_GAP, _header_w);
    }

    // If a footer is also provided, recalculate its size and adjust the rectangle size a final time
    if (_footer != "") {
        // Set the font for the header and calculate its size
        draw_set_font(_footer_font);
        _footer_w = _force_width ? _width : max(string_width(_footer), _width);
        _footer_h = string_height_ext(_footer, DEFAULT_LINE_GAP, _footer_w);
    }

    // Calculate rectangle size
    var _rect_w = max(_header_w, _text_w, _footer_w) + _text_padding_x * 2;
    var _rect_h = _header_h + _text_padding_y + _text_h + _text_padding_y + _footer_h + _text_padding_y;

    // Check if the tooltip goes over the right part of the screen and flip left if so
    if (_rect_x + _rect_w > display_get_gui_width() - _screen_hpadding) {
        _rect_x = _coords[0] - _rect_w - _cursor_offset;
    }

    // Check if the tooltip goes over the bottom part of the screen and flip up if so
    if (_rect_y + _rect_h > display_get_gui_height() - _screen_vpadding) {
        _rect_y = _coords[1] - _rect_h - _cursor_offset;
    }

    draw_set_valign(fa_top);
    draw_set_halign(fa_left);
    draw_set_alpha(1);

    // Draw the tooltip background
    draw_sprite_stretched(spr_data_slate_back, 0, _rect_x, _rect_y, _rect_w, _rect_h);
    draw_rectangle_color_simple(_rect_x, _rect_y, _rect_w + _rect_x, _rect_h + _rect_y, 1, c_gray);
    draw_rectangle_color_simple(_rect_x + 1, _rect_y + 1, _rect_w + _rect_x - 1, _rect_h + _rect_y - 1, 1, c_black);
    draw_rectangle_color_simple(_rect_x + 2, _rect_y + 2, _rect_w + _rect_x - 2, _rect_h + _rect_y - 2, 1, c_gray);

    // Draw header text if it exists
    if (_header != "") {
        draw_set_font(_header_font);
        draw_text_ext_transformed_colour(_rect_x + _text_padding_x, _rect_y + _text_padding_y, _header, DEFAULT_LINE_GAP, _header_w, 1, 1, 0, _text_color, _text_color, _text_color, _text_color, 1);
        _text_padding_y += _header_h + DEFAULT_LINE_GAP;
    }

    // Draw tooltip text
    draw_set_font(_font);
    draw_text_ext_transformed_colour(_rect_x + _text_padding_x, _rect_y + _text_padding_y, _tooltip, DEFAULT_LINE_GAP, _text_w, 1, 1, 0, _text_color, _text_color, _text_color, _text_color, 1);
    var _line_multiplier = (_force_width && string_width(_tooltip) > _width) ? 2 : 1;
    var _text_height = string_height(_tooltip) * _line_multiplier;
    _text_padding_y += _text_height + DEFAULT_LINE_GAP;

    // Draw footer text if it exists
    if (_footer != "") {
        draw_set_font(_footer_font);
        draw_text_ext_transformed_colour(_rect_x + _text_padding_x, _rect_y + _text_padding_y, _footer, DEFAULT_LINE_GAP, _footer_w, 1, 1, 0, _text_color, _text_color, _text_color, _text_color, 1);
        _text_padding_y += _footer_h + DEFAULT_LINE_GAP;
        if (_cost != 0) {
            var _cost_color = (obj_controller.requisition < _cost) ? c_red : #F89823;
            draw_sprite(spr_requisition, 0, _rect_x + _text_padding_x, _rect_y + _text_padding_y);
            draw_text_ext_transformed_colour(_rect_x + _text_padding_x + sprite_get_width(spr_requisition), _rect_y + _text_padding_y, _cost, DEFAULT_LINE_GAP, string_width(string(_cost)), 1, 1, 0, _cost_color, _cost_color, _cost_color, _cost_color, 1);
        }
    }

    pop_draw_return_values();
}

tooltip_data = [];
