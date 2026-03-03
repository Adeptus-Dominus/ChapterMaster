fade_val = approach(fade_val, fade_target, 0.1);

if (fade_val >= 1) {
    if (is_quitting) {
        game_end();
    }
    if (target_room != -1) {
        if (instance_exists(obj_main_menu)) {
            instance_destroy(obj_main_menu);
        }
        room_goto(target_room);
    }
}

var can_interact = (fade_target == 0) && !instance_exists(obj_saveload) && !instance_exists(obj_ingame_menu);

if (instance_exists(obj_main_menu)) {
    if (obj_main_menu.title_alpha < 0.5) {
        can_interact = false;
    }
}

if (can_interact) {
    var mouse_clicked = mouse_check_button_pressed(mb_left);

    for (var i = 0; i < array_length(buttons); i++) {
        var b = buttons[i];
        var is_hovering = point_in_rectangle(mouse_x, mouse_y, b.x, b.y, b.x + b.w, b.y + b.h);

        b.hover = approach(b.hover, is_hovering ? 20 : 0, 2);

        if (is_hovering && mouse_clicked && b.action != undefined) {
            b.action();
        }
    }
}
