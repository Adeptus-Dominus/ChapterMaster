// Checks which systems you can see the planets
if (obj_controller.menu != eMENU.DEFAULT) {
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
    if (p_type[1] == "Craftworld") {
        if (obj_controller.known[eFACTION.ELDAR] == 0) {
            exit;
        }
        // A revealed craftworld is fully visible and clickable regardless of the
        // fog-of-war vision flag. It spawns unseen at the galaxy's edge and nothing
        // ever granted it vision, so the star drew after the reveal but rejected
        // every click: it could not be selected, targeted for travel, or attacked
        // (tester arrived "next to" it because move orders fell to the neighboring
        // system). Setting vision here also self-heals saves where the reveal
        // already happened.
        vision = 1;
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
