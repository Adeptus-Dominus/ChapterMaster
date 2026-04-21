obj_controller.menu = 0;
obj_controller.zui = 0;
obj_controller.invis = false;
obj_cursor.image_alpha = 1;

if (global.restart > 0) {
    with (obj_ini) {
        instance_destroy();
    }
    room_goto(rm_creation);
}

instance_destroy();
