// Checks which systems you can see the planets
if (obj_controller.menu != eMENU.Default) {
    exit;
}
if (instances_exist_any([obj_drop_select, obj_saveload, obj_bomb_select])) {
    exit;
}
if (!global.ui_click_lock) {
    var m_dist = point_distance(x, y, mouse_x, mouse_y);
    var allow_click_distance = 20 * scale;

    if (obj_controller.location_viewer.is_entered) {
        exit;
    }
    // if ((obj_controller.zoomed==0) and (mouse_y <camera_get_view_y(view_camera[0])+62)) or (obj_controller.menu!=0) then exit;
    // if ((obj_controller.zoomed==0) and (mouse_y>camera_get_view_y(view_camera[0])+830)) or (obj_controller.menu!=0) then exit;
    if ((p_type[1] == "Craftworld") && (obj_controller.known[eFACTION.Eldar] == 0)) {
        exit;
    }
    if (vision == 0) {
        exit;
    }
    if (!scr_void_click()) {
        exit;
    }

    if (((obj_controller.zoomed == 0) && (m_dist < allow_click_distance)) || ((obj_controller.zoomed == 1) && (m_dist < 60)) && (obj_controller.cooldown <= 0)) {
        // This should prevent overlap with fleet object
        if (obj_controller.zoomed == 1) {
            obj_controller.x = self.x;
            obj_controller.y = self.y;
        }
        alarm[3] = 1;
    }
}
