var _ui_green = CM_GREEN_COLOR;
var _text_color = #080000;
var _surface_w = surface_get_width(application_surface);
var _surface_h = surface_get_height(application_surface);
var _padding_x = 16;
var _padding_y = 8;
var _text_draw_width;
var _text_draw_height;
var _text_draw_point_x;
var _text_draw_point_y;
var _bbox_x1;
var _bbox_y1;
var _bbox_x2;
var _bbox_y2;
var _bbox_x_from_center;
var _bbox_y_from_center;

if (left_down) {
    draw_set_alpha(0.5);
    draw_set_color(_ui_green);
    draw_rectangle(sel_x1, sel_y1, mouse_x, mouse_y, 1);
}

draw_set_font(fnt_menu);

// begin box
if (start == 0) {
    var _begin_x = _surface_w / 2;
    var _begin_y = 56;
    var _begin_w_half = 128;
    var _begin_h_half = 16;
    var _begin_text = "[ Enter ] to Begin";
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    _text_draw_width = string_width(_begin_text);
    _text_draw_height = string_height(_begin_text);
    _bbox_x_from_center = (_text_draw_width / 2) + _padding_x;
    _bbox_y_from_center = (_text_draw_height / 2) + _padding_y;
    _bbox_x1 = _begin_x - _bbox_x_from_center;
    _bbox_y1 = _begin_y - _bbox_y_from_center;
    _bbox_x2 = _begin_x + _bbox_x_from_center;
    _bbox_y2 = _begin_y + _bbox_y_from_center;
    draw_set_color(_ui_green);
    draw_set_alpha(0.75);
    draw_rectangle(_bbox_x1, _bbox_y1, _bbox_x2, _bbox_y2, false);
    draw_set_alpha(1);
    draw_rectangle(_bbox_x1, _bbox_y1, _bbox_x2, _bbox_y2, true);
    draw_set_color(_text_color);
    draw_text(_begin_x, _begin_y, _begin_text);
}

// fast forward icon
if (gamespeed_fps != 90 && start == 5) {
    draw_set_alpha(1);
    var _ff_h = sprite_get_height(spr_fast_forward);
    draw_sprite(spr_fast_forward, 0, 12, (_surface_h / 2) - (_ff_h / 2));
}

// battle stat box
if (start < 7) {
    var _stat_headers = "";
    var _stat_numbers = "";
    var _newline;

    if (capital) {
        _stat_headers += "Battleships:";
        _stat_numbers += string(capital);
    }
    if (frigate) {
        _newline = capital ? "\n" : "";
        _stat_headers += $"{_newline}Cruisers:";
        _stat_numbers += $"{_newline}{string(frigate)}";
    }
    if (escort) {
        _newline = capital || frigate ? "\n" : "";
        _stat_headers += $"{_newline}Escorts:";
        _stat_numbers += $"{_newline}{string(escort)}";
    }

    if (string_length(_stat_headers)) {
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);

        // add the widths for the box size plus a bit between
        _text_draw_width = string_width(_stat_headers) + string_width(_stat_numbers) + 8;
        _text_draw_height = string_height(_stat_numbers);

        _bbox_x1 = 1;
        _bbox_y1 = 1;
        _bbox_x2 = 1 + _text_draw_width + (2 * _padding_x);
        _bbox_y2 = 1 + _text_draw_height + (2 * _padding_y);

        draw_set_color(_ui_green);
        draw_set_alpha(0.75);
        draw_rectangle(_bbox_x1, _bbox_y1, _bbox_x2, _bbox_y2, false);

        draw_set_alpha(1);
        draw_rectangle(_bbox_x1, _bbox_y1, _bbox_x2, _bbox_y2, true);

        draw_set_color(_text_color);
        draw_text(_padding_x, _padding_y, _stat_headers);

        draw_set_halign(fa_right);
        draw_text(_text_draw_width + _padding_x, _padding_y, _stat_numbers);
    }
}

// end of combat fade
if (combat_end <= 120) {
    draw_set_color(0);
    draw_set_alpha((120 - combat_end) / 100);
    draw_rectangle(0, 0, room_width, room_height, 0);
}

// end of combat results
if (start == 7) {
    // ## todo: calculate all of this once at the end of the battle ##

    var _margin_categories = max(bool(capital_max) + bool(frigate_max) + bool(escort_max), 1);
    var _margin_percent = (max(capital, 0) / max(1, capital_max)) + (max(frigate, 0) / max(1, frigate_max)) + (max(escort, 0) / max(1, escort_max));
    _margin_percent /= max(_margin_categories, 1);
    var _result_box_header;
    if (_margin_percent >= 0.95) {
        _result_box_header = "Major Victory";
    } else if (_margin_percent >= 0.75) {
        _result_box_header = "Victory";
    } else if (_margin_percent > 0.01) {
        _result_box_header = "Minor Victory";
    } else if (_margin_percent <= 0.01) {
        _result_box_header = "Defeat";
    }
    var _result_box_footer = "[ Enter ] to Continue";
    var _result_box_text = "";
    var _all_lost = capital_lost + frigate_lost + escort_lost;
    var _wiped_out = _all_lost >= (capital_max + frigate_max + escort_max);

    if (capital_max) {
        _result_box_text += $"\nBattleships Lost: {string(capital_lost)} ({string((capital_lost / max(0, capital_max)) * 100)}%)";
    }
    if (frigate_max) {
        _result_box_text += $"\nCruisers Lost: {string(frigate_lost)} ({string((frigate_lost / max(0, frigate_max)) * 100)}%)";
    }
    if (escort_max) {
        _result_box_text += $"\nEscorts Lost: {string(escort_lost)} ({string((escort_lost / max(0, escort_max)) * 100)}%)";
    }
    if (ships_max && (_all_lost > 0) && !_wiped_out) {
        _result_box_text += $"\nShips Damaged: {string(ships_damaged)} ({string((ships_damaged / (ships_max - _all_lost)) * 100)}%)";
    } else if (!_wiped_out) {
        _result_box_text += "\nShips Damaged: 0 (0%)";
    }
    _result_box_text += $"\nMarines Lost: {string(fallen)}";

    var _result_text_gap = 4;
    var _x = string_width(_result_box_header);
    var _a = string_width(_result_box_text);
    var _b = string_width(_result_box_footer);
    var _result_text_header_height = string_height(_result_box_header);
    var _result_text_width = max(string_width(_result_box_header), string_width(_result_box_footer), string_width(_result_box_text));
    var _result_text_height = _result_text_header_height + string_height(_result_box_footer) + string_height(_result_box_text) + (2 * _result_text_gap);

    // ## end todo ##

    var _result_image_w = 409;
    var _result_image_h = 247;

    var _result_center_x = _surface_w / 2;
    var _result_center_y = (_surface_h / 2) + (_result_image_h / 2) + _padding_y;

    _bbox_x_from_center = (_result_text_width / 2) + _padding_x;
    _bbox_y_from_center = (_result_text_height / 2) + _padding_y;
    _bbox_x1 = _result_center_x - _bbox_x_from_center;
    _bbox_y1 = _result_center_y - _bbox_y_from_center;
    _bbox_x2 = _result_center_x + _bbox_x_from_center;
    _bbox_y2 = _result_center_y + _bbox_y_from_center;

    // todo: image

    var _result_image_x = _result_center_x - (_result_image_w / 2);
    var _result_image_y = _bbox_y1 - _padding_y - _result_image_h;

    scr_image("postspace", 2, _result_image_x, _result_image_y, _result_image_w, _result_image_h);

    draw_set_color(_ui_green);
    draw_set_alpha(0.75);
    draw_rectangle(_bbox_x1, _bbox_y1, _bbox_x2, _bbox_y2, false);

    draw_set_alpha(1);
    draw_rectangle(_bbox_x1, _bbox_y1, _bbox_x2, _bbox_y2, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(#ffffff);
    draw_text(_result_center_x + 1, _bbox_y1 + _padding_y + 1, _result_box_header);
    draw_set_color(_text_color);
    draw_text(_result_center_x, _bbox_y1 + _padding_y, _result_box_header);

    draw_set_halign(fa_left);
    draw_text(_bbox_x1 + _padding_x, _bbox_y1 + _padding_y + _result_text_header_height + _result_text_gap, _result_box_text);

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_text(_result_center_x, _bbox_y2 - _padding_y, _result_box_footer);
}
