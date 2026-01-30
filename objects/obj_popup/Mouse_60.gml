if (hide == true) {
    exit;
}
if ((type == 8) && (target_comp >= 0) && (obj_controller.man_max > 0)) {
    if (obj_controller.man_current > 0) {
        obj_controller.man_current -= 1;
    }
    if (obj_controller.man_current > 0) {
        obj_controller.man_current -= 1;
    }
}
