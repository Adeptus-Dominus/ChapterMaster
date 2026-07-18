/// @param {Id.Instance.obj_p_ship} _ship
function draw_ship_status_overlay(_ship, _hp_color, _shield_color) {
    if (!instance_exists(_ship)) {
        return;
    }

    var _maxhp = _ship.maxhp;
    if (_maxhp <= 0) {
        return;
    }

    var _shields = _ship.shields;
    var _maxshields = _ship.maxshields;
    var _has_shields = _shields > 0 && _maxshields > 0;

    var _display_value = _has_shields ? (_shields / _maxshields) : (_ship.hp / _maxhp);
    var _color = _has_shields ? _shield_color : _hp_color;

    var _zoomed = false;
    if (instance_exists(obj_controller)) {
        _zoomed = obj_controller.zoomed != 0;
    }

    var _scale = _zoomed ? 2 : 1;
    var _text = $"{floor(_display_value * 100)}%";

    draw_text_transformed_outline(_ship.x, _ship.y - _ship.sprite_height, _text, _scale, _scale, 0,, _color);
}
