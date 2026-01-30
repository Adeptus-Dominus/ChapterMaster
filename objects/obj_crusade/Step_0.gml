if (cooldown >= 0) {
    cooldown -= 1;
}

if (placing == true) {
    x = mouse_x;
    y = mouse_y;
    obj_controller.cooldown = 9999;
    obj_controller.menu = 9999;
}
