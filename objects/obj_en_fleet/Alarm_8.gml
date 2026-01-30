var wop;
wop = instance_nearest(x, y, obj_star);
if (instance_exists(wop)) {
    if (point_distance(x, y, wop.x, wop.y) <= 40) {
        wop.present_fleet[owner] += 1;
    }
}
