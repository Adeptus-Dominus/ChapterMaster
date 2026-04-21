if ((action == "") && (orbiting != 0)) {
    orbiting = instance_nearest(x, y, obj_star);
    orbiting.present_fleet[1] += 1;
}
