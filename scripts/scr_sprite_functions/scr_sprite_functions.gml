function draw_sprite_rectangle(sprite_index, subimage, x1, y1, x2, y2) {
    var w = x1 - x2;
    var h = y1 - y2;
    draw_sprite_stretched(sprite_index, subimage, x1, y1, w, h);
}

function draw_centered_sprite_stretched(sprite_index, subimage, width, height) {
    var _gui_width = camera_get_view_width(view_camera[0]);
    var _gui_height = camera_get_view_height(view_camera[0]);

    // Calculate the center position
    var _x_center = (_gui_width / 2) - (width / 2);
    var _y_center = (_gui_height / 2) - (height / 2);

    // Draw the stretched sprite at the center of the screen
    draw_sprite_stretched(sprite_index, subimage, _x_center, _y_center, width, height);
}

function draw_sprite_fit(_sprite, _subimg, _x1, _y1, _x2, _y2) {
    var _target_w = _x2 - _x1;
    var _target_h = _y2 - _y1;

    var _sw = sprite_get_width(_sprite);
    var _sh = sprite_get_height(_sprite);

    var _scale = min(_target_w / _sw, _target_h / _sh);

    var _final_w = _sw * _scale;
    var _final_h = _sh * _scale;

    var _draw_x = _x1 + (_target_w - _final_w) * 0.5;
    var _draw_y = _y1 + (_target_h - _final_h) * 0.5;

    var _ox = sprite_get_xoffset(_sprite);
    var _oy = sprite_get_yoffset(_sprite);

    draw_sprite_ext(_sprite, _subimg, _draw_x + (_ox * _scale), _draw_y + (_oy * _scale), _scale, _scale, 0, c_white, 1);
}
