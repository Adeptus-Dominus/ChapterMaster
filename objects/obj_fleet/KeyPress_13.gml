if (obj_controller.cooldown <= 0) {
    if (start != 7) {
        start = 5;
        beg = 1;
    }
    if (start == 7) {
        // End battle crap here
        instance_activate_all();
        room_speed = 30;
        alarm[7] = 1;
    }
}
