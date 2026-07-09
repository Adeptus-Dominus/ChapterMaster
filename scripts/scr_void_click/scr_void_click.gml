function scr_void_click() {
    var good = true;

    var xx = camera_get_view_x(view_camera[0]);
    var yy = camera_get_view_y(view_camera[0]);

    var scale = obj_controller.scale_mod;
    if (obj_controller.cooldown > 0) {
        return false;
    }
    if (obj_controller.menu != 0) {
        return false;
    }
    if (!obj_controller.zoomed) {
        if (mouse_y < camera_get_view_y(view_camera[0]) + (62 * scale)) {
            return false;
        }
        if (mouse_y > camera_get_view_y(view_camera[0]) + (830 * scale)) {
            return false;
        }
    }

    if (instance_exists(obj_fleet_select)) {
        if (obj_fleet_select.currently_entered) {
            good = false;
        }
    } else if (instance_exists(obj_star_select)) {
        if (obj_controller.selecting_planet > 0) {
            var _shutters = obj_star_select.shutters;
            for (var i = 0; i < array_length(_shutters); i++) {
                if (_shutters[i].hit()) {
                    good = false;
                    break;
                }
            }
        }
    } else {
        if (obj_controller.helpful_places != false) {
            if (!instances_exist_any([obj_turn_end, obj_ncombat, obj_fleet, obj_fleet_select, obj_popup, obj_star_select])) {
                if (obj_controller.helpful_places.entered()) {
                    good = false;
                }
            }
        }
    }

    if (obj_controller.popup == 3) {
        // Prevent hitting through the planet select
        if (scr_hit(xx + (27 * scale), yy + (165 * scale), xx + (347 * scale), yy + (459 * scale)) == true) {
            good = false;
        }
        if (obj_controller.selecting_planet > 0) {
            if (scr_hit(xx + (27 * scale), yy + (165 * scale), xx + (728 * scale), yy + (459 * scale)) == true) {
                good = false;
            } // The area with the planetary info
        }
    }

    if ((obj_controller.menu == 60) && scr_hit(xx + (27 * scale), yy + (165 * scale), xx + (651 * scale), yy + (597 * scale))) {
        good = false;
    } // Build menu

    return good;
}
