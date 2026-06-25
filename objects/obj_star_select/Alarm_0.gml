if (loading == 0) {
    exit;
}

// check for the right star
with (obj_star) {
    if (name == obj_star_select.loading_name) {
        instance_create(x, y, obj_temp2);
    }
}
if (instance_exists(obj_temp2)) {
    target = instance_nearest(obj_temp2.x, obj_temp2.y, obj_star);
}
with (obj_temp2) {
    instance_destroy();
}

instance_activate_object(obj_star);
