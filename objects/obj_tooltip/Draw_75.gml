/// @description Insert description here
// You can write your code in this editor






for (var i=0;i<array_length(queue);i++){
	var _tip = queue[i];
	var _tooltip = _tip.tooltip;
	var _width =_tip.width;
	var _coords = _tip.coords;
	var _text_color = _tip.text_color;
	var _font =_tip.font;
	var  _header = _tip.header;
	var _header_font = _tip.header_font;
	var _force_width = _tip.force_width;
	var _screen_vpadding = 30;
	var _screen_hpadding = 60;
	var _header_h=0;
	var _header_w=0;
	var _cursor_offset = 20;

	// Remember global variables
	var _curr_font = draw_get_font();
	var _curr_color = draw_get_color();
	var _curr_halign = draw_get_halign();
	var _curr_alpha = draw_get_alpha();

	draw_set_halign(fa_left);
	draw_set_alpha(1)

	// Calculate padding and rectangle size
	var _text_padding_x = 12;
	var _text_padding_y = 12;

	// Convert hash to newline in strings
	_header = string_hash_to_newline(string(_header));
	_tooltip = string_hash_to_newline(string(_tooltip));

	// Set the font for the tooltip text and calculate its size
	draw_set_font(_font);
	var _text_w = _force_width ? _width: min(string_width(_tooltip), _width);
	var text_h = string_height_ext(_tooltip, DEFAULT_LINE_GAP, _text_w);

	// Calculate rectangle size
	var _rect_w = _text_w + _text_padding_x * 2;
	var _rect_h = text_h + _text_padding_y * 2;

	// If a header is provided, calculate its size and adjust the rectangle size
	if (_header != "") {
		// Set the font for the header and calculate its size
		draw_set_font(_header_font);
		if _force_width = false{
			var _header_w = min(string_width(_header), _width);
		} else{
			var _header_w = _width;
		}
		var _header_h = string_height_ext(_header, DEFAULT_LINE_GAP, _header_w);
		// Adjust rectangle size
		_rect_w = max(_header_w, _text_w) + _text_padding_x * 2;
		_rect_h += _header_h;
	}

	// Define tooltip position
	var _rect_x = _coords[0];
	var _rect_y = _coords[1];

	// Check if the tooltip goes over the right part of the screen and flip left if so
	if (_rect_x + _rect_w > display_get_gui_width() - _screen_hpadding) {
		_rect_x = _coords[0] - _rect_w - _cursor_offset;
	} else {
		_rect_x += _cursor_offset;
	}

	// Check if the tooltip goes over the bottom part of the screen and flip up if so
	if (_rect_y + _rect_h > display_get_gui_height() - _screen_vpadding) {
		_rect_y = _coords[1] - _rect_h - _cursor_offset;
	} else {
		_rect_y += _cursor_offset;
	}

	// Draw the tooltip background
	// draw_sprite_ext(spr_tooltip1, 0, _rect_x, _rect_y, x_scale, y_scale, 0, c_white, 1);
	// draw_sprite_ext(spr_tooltip1, 1, _rect_x, _rect_y, x_scale, y_scale, 0, c_white, 1);
	draw_sprite_stretched(spr_data_slate_back, 0, _rect_x, _rect_y, _rect_w, _rect_h);
	draw_rectangle_color_simple(_rect_x, _rect_y, _rect_w + _rect_x, _rect_h + _rect_y, 1, c_gray);
	draw_rectangle_color_simple(_rect_x + 1, _rect_y + 1, _rect_w + _rect_x - 1, _rect_h + _rect_y - 1, 1, c_black);
	draw_rectangle_color_simple(_rect_x + 2, _rect_y + 2, _rect_w + _rect_x - 2, _rect_h + _rect_y - 2, 1, c_gray);

	// Draw header text if it exists
	if (_header != "") {
		draw_set_font(_header_font);
		draw_text_ext_transformed_colour(_rect_x + _text_padding_x, _rect_y + _text_padding_y, _header, DEFAULT_LINE_GAP, _header_w, 1,1,0,_text_color, _text_color, _text_color, _text_color, 1);
		_rect_y += _header_h + DEFAULT_LINE_GAP; // Adjust y-coordinate for tooltip text
		_text_padding_y *= 1.6;
	}

	// Draw tooltip text
	draw_set_font(_font);
	draw_text_ext_transformed_colour(_rect_x + _text_padding_x, _rect_y + _text_padding_y, _tooltip, DEFAULT_LINE_GAP, _text_w, 1,1,0, _text_color, _text_color, _text_color, _text_color, 1);

	// Revert global variables
	draw_set_font(_curr_font);
	draw_set_color(_curr_color);
	draw_set_halign(_curr_halign);
	draw_set_alpha(_curr_alpha);
}

queue=[];
