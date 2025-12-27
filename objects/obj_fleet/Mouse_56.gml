var pressy;
pressy = 0;
sel_x1 = 0;
sel_y1 = 0;

if (instance_exists(obj_p_ship) && (control == 1)) {
    left_down = 0;
    with (obj_p_ship) {
        var casey = 2;
        sel_x2 = mouse_x;
        sel_y2 = mouse_y;

        if (point_distance(sel_x1, sel_y1, sel_x2, sel_y2) < 30) {
            casey = 1;
        }

        if (casey == 1) {
            selected = 0;
            if (point_distance(mouse_x, mouse_y, x, y) <= 30) {
                selected = 1;
                obj_fleet.ships_selected += 1;
            }
        }

        if (casey == 2) {
            if (point_in_rectangle(x, y, sel_x1, sel_y1, sel_x2, sel_y2)) {
                selected = 1;
                obj_fleet.ships_selected += 1;
            } else {
                if (!keyboard_check(vk_shift)) {
                    selected = 0;
                }
            }
        }

        sel_x1 = 0;
        sel_y1 = 0;
        sel_x2 = 0;
        sel_y2 = 0;
    }
}

if ((start == 5) && (obj_controller.zoomed == 0)) {
    if ((mouse_x >= __view_get(e__VW.XView, 0) + 12) && (mouse_y >= __view_get(e__VW.YView, 0) + 436) && (mouse_x < __view_get(e__VW.XView, 0) + 48) && (mouse_y < __view_get(e__VW.YView, 0) + 480) && (gamespeed_fps < 90)) {
        game_set_speed(gamespeed_fps + 30, gamespeed_fps);
    }
}
if ((start == 5) && (obj_controller.zoomed == 1)) {
    if ((mouse_x > 24) && (mouse_y > 872) && (mouse_x < 90) && (mouse_y < 960) && (gamespeed_fps < 90)) {
        game_set_speed(gamespeed_fps + 30, gamespeed_fps);
    }
}
