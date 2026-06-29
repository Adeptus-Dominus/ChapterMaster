try {
    if (action != "") {
        var sys = instance_nearest(action_x, action_y, obj_star);
        act_dist = point_distance(x, y, sys.x, sys.y);
        var mine = instance_nearest(x, y, obj_star);

        if ((owner == eFACTION.INQUISITION) && (action_eta < 2)) {
            action_eta = 2;
        }
        action = "move";

        if ((owner != eFACTION.ELDAR) && (mine.storm > 0)) {
            action_eta += 10000;
        }

        x = x + lengthdir_x(24, point_direction(x, y, sys.x, sys.y));
        y = y + lengthdir_y(24, point_direction(x, y, sys.x, sys.y));
    }

    if (action == "") {
        var sys = instance_nearest(action_x, action_y, obj_star);
        var sys_dist = point_distance(action_x, action_y, sys.x, sys.y);
        var target_dist = 0;
        if (scr_valid_fleet_target(target)) {
            target_dist = point_distance(x, y, target.action_x, target.action_y);
        } else {
            target = noone;
        }

        act_dist = point_distance(x, y, sys.x, sys.y);
        var mine = instance_nearest(x, y, obj_star);

        var connected = determine_warp_join(mine, sys);

        // Move the entire fleet, don't worry about the other crap
        turns_static = 0;

        if ((trade_goods != "") && (owner != eFACTION.TYRANIDS) && (owner != eFACTION.CHAOS) && (string_count("Inqis", trade_goods) == 0) && (string_count("merge", trade_goods) == 0) && (string_count("_her", trade_goods) == 0) && (trade_goods != "cancel_inspection") && (trade_goods != "return")) {
            if (scr_valid_fleet_target(target)) {
                if (target.action != "") {
                    if (target_dist > sys_dist) {
                        action_x = target.action_x;
                        action_y = target.action_y;
                        sys = instance_nearest(action_x, action_y, obj_star);
                    }
                }
            } else {
                target = noone;
            }
        }

        var eta = floor(point_distance(x, y, action_x, action_y) / action_spd) + 1;
        if (connected == 0) {
            eta = eta * 2;
        }

        if ((action_eta <= 0) || (owner != eFACTION.INQUISITION)) {
            action_eta = eta;
            if ((owner == eFACTION.INQUISITION) && (action_eta < 2) && (string_count("_her", trade_goods) == 0)) {
                action_eta = 2;
            }
        }

        if ((owner != eFACTION.ELDAR) && (mine.storm > 0)) {
            action_eta += 10000;
        }

        action = "move";

        if ((minimum_eta > action_eta) && (minimum_eta > 0)) {
            action_eta = minimum_eta;
        }
        minimum_eta = 0;
        if ((etah > action_eta) && (etah != 0)) {
            action_eta = etah;
        }

        x = x + lengthdir_x(24, point_direction(x, y, sys.x, sys.y));
        y = y + lengthdir_y(24, point_direction(x, y, sys.x, sys.y));
    }

    etah = 0;
} catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
}
