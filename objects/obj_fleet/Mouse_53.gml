if ((sel_x1 + sel_y1 == 0) && (control == 1)) {
    if (instance_exists(obj_p_ship)) {
        left_down = 50;
        sel_x1 = mouse_x;
        sel_y1 = mouse_y;
        ships_selected = 0;

        with (obj_p_ship) {
            if (keyboard_check(vk_shift) == false) {
                selected = 0;
            }
            sel_x1 = mouse_x;
            sel_y1 = mouse_y;
        }
    }
}
