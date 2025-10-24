function draw_sprite_flipped(_sprite, _subimg, _x, _y) {
    var _sprite_width = sprite_get_width(_sprite);
    var _sprite_xoffset = sprite_get_xoffset(_sprite);
    _sprite_xoffset *= 2;

    draw_sprite_ext(_sprite, _subimg, _x + _sprite_width - _sprite_xoffset, _y, -1, 1, 0, c_white, 1)
}



/// @function return_sprite_mirrored(sprite)
/// @param sprite The sprite index to mirror
/// @returns A new sprite index that is the mirrored version
/// @function return_sprite_mirrored(sprite)
/// @param sprite The sprite index to mirror
/// @returns A new sprite index that is the mirrored version
function return_sprite_mirrored(_spr, delete_sprite=true) {
    var _w = sprite_get_width(_spr);
    var _h = sprite_get_height(_spr);
    var _frames = sprite_get_number(_spr);

    // New mirrored sprite we’ll build
    var _new_sprite = -1;

    for (var _i = 0; _i < _frames; _i++) {
        // Create surface for this frame
        var _surf = surface_create(_w, _h);
        surface_set_target(_surf);
        draw_clear_alpha(c_black, 0);

        // Draw sprite frame mirrored (scale_x = -1 flips horizontally)
        draw_sprite_ext(_spr, _i, _w, 0, -1, 1, 0, c_white, 1);

        surface_reset_target();

        // Add to new sprite (first frame creates, rest append)
        if (_i == 0) {
            _new_sprite = sprite_create_from_surface(_surf, 0, 0, _w, _h, false, false, 0, 0);
        } else {
            sprite_add_from_surface(_new_sprite, _surf, 0, 0, _w, _h, 0, 0);
        }

        // Free surface
        surface_free(_surf);
    }

    // Optional: delete old sprite to free memory
    if (delete_sprite){
        sprite_delete(_spr);
    }

    return _new_sprite;
}
