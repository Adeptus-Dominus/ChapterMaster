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
