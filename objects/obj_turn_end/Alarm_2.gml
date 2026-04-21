if (fast == 0) {
    instance_activate_object(obj_star_event);
    if (instance_exists(obj_star_event)) {
        obj_star_event.image_alpha = 1;
        obj_star_event.image_speed = 1;
    }

    instance_activate_object(obj_star_select);
    instance_activate_object(obj_drop_select);
    instance_activate_object(obj_bomb_select);

    if (instance_exists(obj_star_select)) {
        obj_star_select.alarm[1] = 2;
    }
}

fast += 1;
if (fast < alerts) {
    alarm[2] = 10;
}

if (fast >= alerts) {
    alarm[2] = 9999;
    alarm[3] = max(230, (alerts * 60));
    alarm[3] = min(alarm[3], 360);
}

if (alerts == 0) {
    instance_destroy();
}
