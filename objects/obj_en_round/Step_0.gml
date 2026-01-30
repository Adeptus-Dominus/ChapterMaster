image_angle = direction;

if ((x < -1000) || (x > room_width + 1000) || (y < -1000) || (y > room_height + 1000)) {
    instance_destroy();
}

var th, thd;
if (dam <= 4) {
    if (instance_exists(obj_p_small)) {
        th = instance_nearest(x, y, obj_p_small);
        thd = point_distance(x, y, th.x, th.y);
        if (thd < 6) {
            th.hp -= self.dam - 1;
            instance_destroy();
        }
    }
    if (instance_exists(obj_al_in)) {
        th = instance_nearest(x, y, obj_al_in);
        thd = point_distance(x, y, th.x, th.y);
        if (thd < 6) {
            th.hp -= self.dam - 1;
            instance_destroy();
        }
    }
}
