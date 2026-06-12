image_angle = direction;

if ((x < -1000) || (x > room_width + 1000) || (y < -1000) || (y > room_height + 1000)) {
    instance_destroy();
}

if (dam <= 4) {
    if (instance_exists(obj_p_th)) {
        var th = instance_nearest(x, y, obj_p_th);
        var thd = point_distance(x, y, th.x, th.y);
        if (thd < 6) {
            th.hp -= self.dam - 1;
            instance_destroy();
        }
    }
}
