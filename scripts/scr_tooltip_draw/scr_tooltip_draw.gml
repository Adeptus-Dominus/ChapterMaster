function tooltip_draw(_tooltip = "", _width = 350, _coords = return_mouse_consts_tooltip(), _text_color = #50a076, _font = fnt_40k_14, _header = "", _header_font = fnt_40k_14b, _force_width = false) {
    if (!instance_exists(obj_tooltip)) {
        instance_create(0, 0, obj_tooltip);
    }
    var scale = (instance_exists(obj_controller)) ? obj_controller.map_scale : 1;
    if (event_number != ev_gui) {
        _coords[0] = (_coords[0] - __view_get(e__VW.XView, 0)) * scale;
        _coords[1] = (_coords[1] - __view_get(e__VW.YView, 0)) * scale;
    }
    array_push(obj_tooltip.queue, {tooltip: _tooltip, width: _width, coords: _coords, text_color: _text_color, font: _font, header: _header, header_font: _header_font, force_width: _force_width});
}

function setup_tooltip_list(list) {
    var tip, coords;
    for (var i = 0; i < array_length(list); i++) {
        tip = list[i];
        coords = tip[1];
        if (scr_hit(coords)) {
            tooltip_draw(tip[0], 350,,,, tip[2]);
        }
    }
}
