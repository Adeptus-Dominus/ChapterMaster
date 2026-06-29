if ((action == "") && (orbiting != noone)) {
    orbiting = instance_nearest(x, y, obj_star);
    orbiting.present_fleet[1] += 1;
}
