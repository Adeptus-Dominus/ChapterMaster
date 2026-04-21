var _data = btn_map[button_id];

var _w = _data.width * scaling;
var _h = _data.height * scaling;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

highlighted = point_in_rectangle(_mx, _my, x, y, x + _w, y + _h);
if (highlighted && button_id == 3) {
    highlighted = false;
    high = "apoth";
}

// 3. State Constraints
if (highlighted && instance_exists(obj_ingame_menu)) {
    if (obj_ingame_menu.fading > 0 && target >= 10) {
        highlighted = false;
    }
}

// 4. Highlight Alpha
highlight = lerp(highlight, highlighted ? 0.5 : 0, highlighted ? 0.02 : 0.04);

// 5. Line Animation
if (line > 0) {
    line++;
}

var _line_max = (button_id <= 2) ? (141 * scaling) : (button_id == 3 ? 113 : 105);
if (line > _line_max) {
    line = 0;
}

if (line == 0 && irandom(150) == 3) {
    line = 1;
}

// 6. Interaction
if (highlighted && target > 10 && mouse_button_clicked(mb_left, 60, true)) {
    if (target == eIN_GAME_MENU_EFFECT.CLOSE_SAVELOAD) {
        instance_destroy(obj_saveload);
        instance_destroy();
    } else {
        obj_ingame_menu.effect = target;
    }
}
