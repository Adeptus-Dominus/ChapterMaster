if ((target != 0) && (!instance_exists(target))) {
    instance_destroy();
}

if ((obj_controller.popup < 1) || (obj_controller.popup > 2)) {
    instance_destroy();
}

if ((target != 0) && instance_exists(target)) {
    x = target.x;
    y = target.y;
}
