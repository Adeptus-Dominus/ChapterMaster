add_draw_return_values();

var _sprite_index = asset_get_index("spr_ui_but_" + string(button_id));
var _hover_index = asset_get_index("spr_ui_hov_" + string(button_id));

var _base_w = sprite_get_width(_sprite_index);
var _base_h = sprite_get_height(_sprite_index);

draw_set_alpha(1);
if (sprite_exists(_sprite_index)) {
    draw_sprite_ext(_sprite_index, 0, x, y, scaling, scaling, 0, c_white, 1);
}

if (highlight > 0 && sprite_exists(_hover_index)) {
    draw_set_blend_mode(bm_add);
    draw_sprite_ext(_hover_index, 0, x, y, scaling, scaling, 0, c_white, highlight * 2);
    draw_set_blend_mode(bm_normal);
}

draw_set_color(c_white);
draw_set_font(fnt_cul_14);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _tx = x + (_base_w * scaling * 0.5);
var _ty = y + (_base_h * scaling * 0.4);

draw_text_transformed(_tx, _ty, string(button_text), scaling, scaling, 0);

if (line > 0) {
    draw_set_alpha(0.15);
    var _l_why = 0;
    var _line_x = x + line;
    var _y_top = y + 1;
    var _y_bottom = y + (37 * scaling);

    switch (button_id) {
        case 1:
        case 2:
            if (line > 131 * scaling) {
                _l_why = min(line - (133 * scaling), 11 * scaling);
            }
            draw_line(_line_x, _y_top + _l_why, _line_x, _y_bottom);
            break;

        case 3:
            if (line > 101 * scaling) {
                _l_why = min(line - (103 * scaling), 11 * scaling);
            }
            draw_line(_line_x, _y_top + _l_why, _line_x, _y_bottom);
            break;

        case 4:
            _y_top = y + (10 * scaling) + 1;
            _y_bottom = y + (47 * scaling);
            if (line > 94 * scaling) {
                _l_why = min(line - (96 * scaling), 11 * scaling);
            }
            draw_line(_line_x, _y_top, _line_x, _y_bottom - _l_why);
            break;
    }
}

pop_draw_return_values();
