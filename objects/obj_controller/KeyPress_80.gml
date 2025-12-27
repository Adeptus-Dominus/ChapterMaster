if (menu == false && managing == false && formating == false) {
    if (!instance_number(obj_saveload) && !instance_number(obj_credits) && !instance_number(obj_popup_dialogue) && !instance_number(obj_star_select)) {
        get_diag_string("Enter a cheatcode", "controller", "controller", 1);
    }
}
