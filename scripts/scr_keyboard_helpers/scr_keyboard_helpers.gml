#macro VIRTUAL_KEYS_LIST [vk_left, vk_right, vk_up,vk_down,vk_enter,vk_escape,vk_space,vk_shift,vk_control,vk_alt,vk_backspace,vk_tab,vk_home,vk_end,vk_delete,vk_insert,vk_pageup,vk_pagedown,vk_pause,vk_printscreen,vk_f1,vk_f2,vk_f3,vk_f4,vk_f5,vk_f6,vk_f7,vk_f8,vk_f9,vk_f10,vk_f11,vk_f12,vk_numpad0,vk_numpad1,vk_numpad2,vk_numpad3,vk_numpad4,vk_numpad5,vk_numpad6,vk_numpad7,vk_numpad8,vk_numpad9, vk_multiply,vk_divide,vk_add,vk_subtract,vk_decimal]

// vk_lshift,vk_lcontrol,vk_lalt,vk_rshift,vk_rcontrol,vk_ralt these ones can cause issues

/// @function press_exclusive
/// @description Checks if a specific key was pressed this frame while ensuring no other keys in the tracked array are currently held.
/// @param {Constant.VirtualKey} _press_choice The keyboard constant to check for a pressed state.
/// @returns {bool}
function press_exclusive(_press_choice) {
    if (keyboard_check_pressed(vk_nokey)) {
        return false;
    }
    if (!keyboard_check_pressed(_press_choice)) {
        return false;
    }

    var _virtual_keys = VIRTUAL_KEYS_LIST;
    var _count = array_length(_virtual_keys);

    for (var i = 0; i < _count; i++) {
        var _key = _virtual_keys[i];
        if (keyboard_check(_key) && _key != _press_choice) {
            return false;
        }
    }

    return true;
}

/// @function hold_exclusive
/// @description Checks if a specific key is currently held while ensuring no other keys in the tracked array are currently held.
/// @param {Constant.VirtualKey} _press_choice The keyboard constant to check for a held state.
/// @returns {bool}
function hold_exclusive(_press_choice) {
    if (keyboard_check(vk_nokey)) {
        return false;
    }
    if (!keyboard_check(_press_choice)) {
        return false;
    }

    var _virtual_keys = VIRTUAL_KEYS_LIST;
    var _count = array_length(_virtual_keys);

    for (var i = 0; i < _count; i++) {
        var _key = _virtual_keys[i];
        if (keyboard_check(_key) && _key != _press_choice) {
            return false;
        }
    }

    return true;
}

/// @function press_with_held
/// @description Checks if a primary key was pressed this frame while a secondary modifier key is held, ensuring no other keys in the tracked array are currently held.
/// @param {Constant.VirtualKey} _press_choice The key that must be pressed this frame.
/// @param {Constant.VirtualKey} _hold_choice The modifier key that must be currently held.
/// @returns {bool}
function press_with_held(_press_choice, _hold_choice) {
    if (keyboard_check_pressed(vk_nokey)) {
        return false;
    }
    if (!keyboard_check_pressed(_press_choice) || !keyboard_check(_hold_choice)) {
        return false;
    }

    var _virtual_keys = VIRTUAL_KEYS_LIST;
    var _count = array_length(_virtual_keys);

    for (var i = 0; i < _count; i++) {
        var _cur_key = _virtual_keys[i];
        if (_cur_key == _press_choice || _cur_key == _hold_choice) {
            continue;
        }

        if (keyboard_check(_cur_key)) {
            return false;
        }
    }

    return true;
}
