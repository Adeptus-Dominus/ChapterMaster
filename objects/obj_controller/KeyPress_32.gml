// Manages zoom level
if (!instance_exists(obj_ncombat) && !instance_exists(obj_popup) && cooldown < 500) {
    if ((obj_controller.menu == 0 && !instance_exists(obj_popup_dialogue)) || (obj_controller.menu == 999)) {
        scr_zoom();
    }
}
