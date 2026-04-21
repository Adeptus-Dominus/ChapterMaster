// Manages zoom level
var __b__ = action_if_number(obj_ncombat, 0, 0);
if (__b__) {
    __b__ = action_if_number(obj_popup, 0, 0);
    if (__b__) {
        __b__ = action_if_variable(cooldown, 500, 1);
        if (__b__) {
            if ((obj_controller.menu == 0 && !instance_exists(obj_popup_dialogue)) || ((obj_controller.menu == 999) && instance_exists(obj_ncombat))) {
                if (instance_exists(obj_ncombat)) {
                    if (obj_ncombat.start == 7) {
                        exit;
                    }
                }
                scr_zoom();
            }
        }
    }
}
