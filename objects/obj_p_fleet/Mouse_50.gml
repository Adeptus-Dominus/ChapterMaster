if (!instance_exists(obj_drop_select) && !instance_exists(obj_bomb_select)) {
    if (!scr_void_click()) {
        exit;
    }
    if (obj_controller.zoomed == 0) {
        if (mouse_y < camera_get_view_y(view_camera[0]) + 60) {
            exit;
        } else if (mouse_y > camera_get_view_y(view_camera[0]) + 836) {
            exit;
        }
        if (obj_controller.menu != 0) {
            exit;
        }
    }

    if ((obj_controller.popup == 1) && (obj_controller.cooldown <= 0)) {
        obj_controller.selected = 0;
        obj_controller.popup = 0;
        selected = 0;
    }
}
