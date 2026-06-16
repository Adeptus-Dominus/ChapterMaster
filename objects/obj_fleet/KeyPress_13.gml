if (obj_controller.cooldown <= 0) {
    if (start != 7) {
        start = 5;
        beg = 1;
    }
    if (start == 7) {
        // End battle crap here
        instance_activate_all();
        game_set_speed(30, gamespeed_fps);
        alarm[7] = 1;
    }
}
