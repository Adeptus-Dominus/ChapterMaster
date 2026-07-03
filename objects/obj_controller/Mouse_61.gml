// Manages ship and unit selection depending on menus
if (!instance_exists(obj_popup)) {
    if ((menu == eMENU.MANAGE) && (managing > 0 || managing == -1) && (man_max > 0)) {
        if ((man_current + MANAGE_MAN_SEE + 1) < man_max) {
            man_current += 1;
        }
        if ((man_current + MANAGE_MAN_SEE + 1) < man_max) {
            man_current += 1;
        }
    }
    if ((menu == eMENU.GAME_HELP) && (managing > 0) && (man_max >= 10)) {
        if ((ship_current + ship_see + 1) < ship_max) {
            ship_current += 1;
        }
        if ((ship_current + ship_see + 1) < ship_max) {
            ship_current += 1;
        }
    }
    if ((menu == eMENU.GAME_HELP) && (managing > 0) && (man_max >= 50)) {
        if ((ship_current + ship_see + 1) < ship_max) {
            ship_current += 1;
        }
        if ((ship_current + ship_see + 1) < ship_max) {
            ship_current += 1;
        }
    }
    if ((menu == eMENU.FLEET) && (man_max > MANAGE_MAN_SEE)) {
        if ((man_current + MANAGE_MAN_SEE + 1) < man_max) {
            man_current += 1;
        }
        if ((man_current + MANAGE_MAN_SEE + 1) < man_max) {
            man_current += 1;
        }
    }
}
