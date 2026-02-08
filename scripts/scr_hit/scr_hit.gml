/// @function scr_hit
/// @description Returns true if mouse is hovering on the specified rectangle area.
/// @returns {bool}
function scr_hit(x1 = 0, y1 = 0, x2 = 0, y2 = 0) {
    var _mouse_consts = return_mouse_consts();
    if (is_array(x1)) {
        return point_in_rectangle(_mouse_consts[0], _mouse_consts[1], x1[0], x1[1], x1[2], x1[3]);
    } else {
        return point_in_rectangle(_mouse_consts[0], _mouse_consts[1], x1, y1, x2, y2);
    }
}

function scr_hit_relative(x1, relative = [0, 0]) {
    var _mouse_consts = return_mouse_consts();
    return point_in_rectangle(_mouse_consts[0], _mouse_consts[1], relative[0] + x1[0], relative[1] + x1[1], relative[0] + x1[2], relative[1] + x1[3]);
}

function scr_hit_dimensions(x1 = 0, y1 = 0, w = 0, h = 0) {
    var _mouse_consts = return_mouse_consts();
    return point_in_rectangle(_mouse_consts[0], _mouse_consts[1], x1, y1, x1 + w, y1 + h);
}

function _point_and_click_logic(_rect, _cooldown = 60, _lock_bypass = false, _inverted = false) {
    if (!_lock_bypass && global.ui_click_lock) {
        return false;
    }

    var _mouse_clicked = (event_number == ev_gui) ? device_mouse_check_button_pressed(0, mb_left) : mouse_check_button_pressed(mb_left);

    if (!_mouse_clicked) {
        return false;
    }

    var _active_controller = noone;
    if (instance_exists(obj_controller)) {
        _active_controller = obj_controller;
    } else if (instance_exists(obj_main_menu)) {
        _active_controller = obj_main_menu;
    } else if (instance_exists(obj_creation)) {
        _active_controller = obj_creation;
    }

    if (_active_controller != noone && _active_controller.cooldown > 0) {
        if (is_debug_overlay_open()) {
            global.logger.warning($"Ignored click for cooldown, {_active_controller.cooldown} steps remaining!\n{array_to_string_list(debug_get_callstack(), true)}");
        }
        return false;
    }

    var _mouse_coords = return_mouse_consts();
    var _is_inside = point_in_rectangle(_mouse_coords[0], _mouse_coords[1], _rect[0], _rect[1], _rect[2], _rect[3]);

    var _success = _is_inside != _inverted;

    if (!_success) {
        return false;
    }

    var _mode = _inverted ? "Outside" : "Inside";

    if (_active_controller != noone && _cooldown > 0) {
        _active_controller.cooldown = _cooldown * (delta_time / 1000000);

        if (is_debug_overlay_open()) {
            global.logger.debug($"Cooldown Set via {_mode} Click!\n{array_to_string_list(debug_get_callstack(), true)}");
        }
    }

    if (is_debug_overlay_open()) {
        global.logger.debug($"{_mode} Click Detected at: x: {_mouse_coords[0]} y: {_mouse_coords[1]}");
    }

    return true;
}

/// @description Returns true if left mouse button was clicked on the desired rectangle area.
/// @param {Array<Real>} _rect The [x1, y1, x2, y2] array defining the exclusion zone.
/// @param {Real} _cooldown The cooldown duration in frames.
/// @param {Bool} _lock_bypass Whether to ignore the global UI click lock.
/// @returns {Bool}
function point_and_click(_rect, _cooldown = 60, _lock_bypass = false) {
    return _point_and_click_logic(_rect, _cooldown, _lock_bypass, false);
}

/// @description Returns true if left mouse button was clicked outside the desired rectangle area.
/// @param {Array<Real>} _rect The [x1, y1, x2, y2] array defining the exclusion zone.
/// @param {Real} _cooldown The cooldown duration in frames.
/// @param {Bool} _lock_bypass Whether to ignore the global UI click lock.
/// @returns {Bool}
function point_outside_and_click(_rect, _cooldown = 60, _lock_bypass = false) {
    return _point_and_click_logic(_rect, _cooldown, _lock_bypass, true);
}

function point_and_click_sprite(x1, y1, sprite, x_scale = 1, y_scale = 1) {
    var _width = sprite_get_width(sprite) * x_scale;
    var _height = sprite_get_height(sprite) * y_scale;
    return point_and_click([x1, y1, x1 + _width, y1 + _height]);
}

function mouse_button_clicked(button = mb_left, cooldown = 60, lock_bypass = false) {
    if (lock_bypass == false && global.ui_click_lock == true) {
        return false;
    }

    var mouse_clicked = event_number == ev_gui ? device_mouse_check_button_pressed(0, button) : mouse_check_button_pressed(button);
    if (!mouse_clicked) {
        return false;
    }

    var controller_exist = instance_exists(obj_controller);
    if (controller_exist && obj_controller.cooldown > 0) {
        if (is_debug_overlay_open()) {
            global.logger.warning($"Ignored click for cooldown, {obj_controller.cooldown} steps remaining!\n{array_to_string_list(debug_get_callstack(), true)}");
        }
        return false;
    } else if (controller_exist && cooldown > 0) {
        obj_controller.cooldown = cooldown * delta_time / 1000000;
        if (is_debug_overlay_open()) {
            global.logger.debug($"Cooldown Set!\n{array_to_string_list(debug_get_callstack(), true)}");
        }
    } else if (!controller_exist) {
        var main_menu_exists = instance_exists(obj_main_menu);
        var creation_screen_exists = instance_exists(obj_creation);
        if (main_menu_exists) {
            if (obj_main_menu.cooldown > 0) {
                if (is_debug_overlay_open()) {
                    global.logger.warning($"Ignored click for cooldown, {obj_main_menu.cooldown} steps remaining!\n{array_to_string_list(debug_get_callstack(), true)}");
                }
                return false;
            } else if (cooldown > 0) {
                obj_main_menu.cooldown = cooldown * delta_time / 1000000;
                if (is_debug_overlay_open()) {
                    global.logger.debug($"Cooldown Set!\n{array_to_string_list(debug_get_callstack(), true)}");
                }
            }
        } else if (creation_screen_exists) {
            if (obj_creation.cooldown > 0) {
                if (is_debug_overlay_open()) {
                    global.logger.warning($"Ignored click for cooldown, {obj_creation.cooldown} steps remaining!\n{array_to_string_list(debug_get_callstack(), true)}");
                }
                return false;
            } else if (cooldown > 0) {
                obj_creation.cooldown = cooldown * delta_time / 1000000;
                if (is_debug_overlay_open()) {
                    global.logger.debug($"Cooldown Set!\n{array_to_string_list(debug_get_callstack(), true)}");
                }
            }
        }
    }

    return mouse_clicked;
}

function mouse_button_held(_button = mb_left) {
    var mouse_held = event_number == ev_gui ? device_mouse_check_button(0, _button) : mouse_check_button(_button);
    if (!mouse_held) {
        return false;
    }

    var controller_exist = instance_exists(obj_controller);
    if (controller_exist && obj_controller.cooldown > 0) {
        if (is_debug_overlay_open()) {
            global.logger.warning($"Ignored click for cooldown, {obj_controller.cooldown} steps remaining!\n{array_to_string_list(debug_get_callstack(), true)}");
        }
        return false;
    } else if (!controller_exist) {
        var main_menu_exists = instance_exists(obj_main_menu);
        var creation_screen_exists = instance_exists(obj_creation);
        if (main_menu_exists) {
            if (obj_main_menu.cooldown > 0) {
                if (is_debug_overlay_open()) {
                    global.logger.warning($"Ignored click for cooldown, {obj_main_menu.cooldown} steps remaining!\n{array_to_string_list(debug_get_callstack(), true)}");
                }
                return false;
            }
        } else if (creation_screen_exists) {
            if (obj_creation.cooldown > 0) {
                if (is_debug_overlay_open()) {
                    global.logger.warning($"Ignored click for cooldown, {obj_creation.cooldown} steps remaining!\n{array_to_string_list(debug_get_callstack(), true)}");
                }
                return false;
            }
        }
    }

    return mouse_held;
}

function return_mouse_consts() {
    var mouse_const_x;
    var mouse_const_y;
    if (event_number == ev_gui) {
        mouse_const_x = device_mouse_x_to_gui(0);
        mouse_const_y = device_mouse_y_to_gui(0);
    } else {
        mouse_const_x = mouse_x;
        mouse_const_y = mouse_y;
    }
    return [mouse_const_x, mouse_const_y];
}

function mouse_distance_less(xx, yy, distance) {
    var _mouse_consts = return_mouse_consts();
    return point_distance(xx, yy, _mouse_consts[0], _mouse_consts[1]) <= distance;
}
