// Ship attack logic
min_x = 9999;
min_y = 9999;
max_x = 0;
max_y = 0;
cen_x = 0;
cen_y = 0;

with (obj_p_ship) {
    if (selected == 1) {
        if (x < obj_circular.min_x) {
            obj_circular.min_x = x;
        }
        if (y < obj_circular.min_y) {
            obj_circular.min_y = y;
        }

        if (x > obj_circular.max_x) {
            obj_circular.max_x = x;
        }
        if (y > obj_circular.max_y) {
            obj_circular.max_y = y;
        }
    }
}

cen_x = (min_x + max_x) / 2;
cen_y = (min_y + max_y) / 2;
x = cen_x;
y = cen_y;

with (obj_p_ship) {
    if (selected == 1) {
        var act = "turn", ce = 0, ced = 0, med = 9999;

        if (instance_exists(obj_en_ship)) {
            ce = instance_nearest(mouse_x, mouse_y, obj_en_ship);
            ced = point_distance(mouse_x, mouse_y, ce.x, ce.y);

            if (ced <= 30) {
                act = "attack_turn";
            }
            med = point_distance(x, y, ce.x, ce.y);
            if (med <= o_dist + 50) {
                act = "attack";
                target = ce;
            }
        }

        action_dis = point_distance(x, y, obj_circular.x, obj_circular.y);
        action_dir = point_direction(x, y, obj_circular.x, obj_circular.y) - 180;
        action_fac = point_direction(x, y, mouse_x, mouse_y);
        paction = act;
        target_x = mouse_x + lengthdir_x(action_dis, action_dir);
        target_y = mouse_y + lengthdir_y(action_dis, action_dir);
    }
}
action_set_alarm(6, 0);
