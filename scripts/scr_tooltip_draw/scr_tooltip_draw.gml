/// @function tooltip_draw(_tooltip, _width, _coords, _text_color, _font, _header, _header_font, _force_width)
/// @category UI
/// @description Logic to draw a tooltip object with optional header
function tooltip_draw(_tooltip = "", _width = 350, _coords = return_mouse_consts(), _text_color = #50a076, _font = fnt_40k_14, _header = "", _header_font = fnt_40k_14b, _force_width = false, _footer = "", _footer_font = fnt_40k_12, _cost = 0) {
    if (!instance_exists(obj_tooltip)) {
        instance_create(0, 0, obj_tooltip);
    }
    var scale = (instance_exists(obj_controller)) ? obj_controller.map_scale : 1;
    if (event_number != ev_gui) {
        _coords[0] = (_coords[0] - camera_get_view_x(view_camera[0])) * scale;
        _coords[1] = (_coords[1] - camera_get_view_y(view_camera[0])) * scale;
    }
    array_push(obj_tooltip.tooltip_data, {tooltip: _tooltip, width: _width, coords: _coords, text_color: _text_color, font: _font, header: _header, header_font: _header_font, force_width: _force_width, footer: _footer, footer_font: _footer_font, cost: _cost});
}

function setup_tooltip_list(list) {
    for (var i = 0; i < array_length(list); i++) {
        if (scr_hit(list[i][1])) {
            tooltip_draw(list[i][0], 350,,,, list[i][2]);
        }
    }
}
