// Manages zoom level
if (!instance_exists(obj_ncombat) && !instance_exists(obj_popup) && cooldown < 500) {
    if ((menu == eMENU.DEFAULT && !instance_exists(obj_popup_dialogue)) || (menu == eMENU.TURN_END)) {
        scr_zoom();
    }
}
