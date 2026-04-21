if ((obj_controller.popup < 3) && (loading == 0)) {
    obj_controller.sel_system_x = 0;
    obj_controller.sel_system_y = 0;
    obj_controller.selecting_planet = 0;

    with (obj_star_select) {
        instance_destroy();
    }
}

/* */
/*  */
