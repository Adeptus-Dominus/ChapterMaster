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

function draw_sprite_flipped(_sprite, _subimg, _x, _y) {
    var _sprite_width = sprite_get_width(_sprite);
    var _sprite_xoffset = sprite_get_xoffset(_sprite);
    _sprite_xoffset *= 2;

    draw_sprite_ext(_sprite, _subimg, _x + _sprite_width - _sprite_xoffset, _y, -1, 1, 0, c_white, 1);
}

/// @function return_sprite_mirrored(sprite)
/// @param {Asset.GMSprite} _spr The sprite index to mirror
/// @param {Bool} delete_sprite
/// @returns {Asset.GMSprite} A new sprite index that is the mirrored version
function return_sprite_mirrored(_spr, delete_sprite = true) {
    var _w = sprite_get_width(_spr);
    var _h = sprite_get_height(_spr);
    var _frames = sprite_get_number(_spr);
    var _sprite_xoffset = sprite_get_xoffset(_spr);
    var _sprite_yoffset = sprite_get_yoffset(_spr);

    // New mirrored sprite we’ll build
    var _new_sprite = undefined;

    for (var _i = 0; _i < _frames; _i++) {
        // Create surface for this frame
        var _surf = surface_create(_w, _h);
        surface_set_target(_surf);
        draw_clear_alpha(c_black, 0);

        // Draw sprite frame mirrored (scale_x = -1 flips horizontally)
        draw_sprite_ext(_spr, _i, _w - _sprite_xoffset, _sprite_yoffset, -1, 1, 0, c_white, 1);

        surface_reset_target();

        // Add to new sprite (first frame creates, rest append)
        if (_i == 0) {
            _new_sprite = sprite_create_from_surface(_surf, 0, 0, _w, _h, false, false, _sprite_xoffset, _sprite_yoffset);
        } else {
            sprite_add_from_surface(_new_sprite, _surf, 0, 0, _w, _h, 0, 0);
        }

        // Free surface
        surface_free(_surf);
    }

    // Optional: delete old sprite to free memory
    if (delete_sprite) {
        sprite_delete(_spr);
    }

    return _new_sprite;
}

function draw_sprite_centered(sprite, subimg, x, y, xscale, yscale, rot, col, alpha) {
    draw_set_halign(fa_left);
    var width = (sprite_get_width(sprite) * xscale) / 2;
    var height = (sprite_get_height(sprite) * yscale) / 2;
    draw_sprite_ext(sprite, subimg, x, y, xscale, yscale, rot, col, alpha);
}
