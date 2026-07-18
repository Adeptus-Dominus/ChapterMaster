global.default_view_width = 1600;
global.default_view_height = 900;

function scr_zoom() {
    // Zooms the view in or out when executed
    set_zoom_to_default();
    if (obj_controller.zoomed) {
        obj_controller.zoomed = 0;
        view_set_visible(0, true);
        view_set_visible(1, false);
        if (instance_exists(obj_cursor)) {
            obj_cursor.image_xscale = 1;
            obj_cursor.image_yscale = 1;
        }
    } else {
        obj_controller.zoomed = 1;
        view_set_visible(0, false);
        view_set_visible(1, true);
        if (instance_exists(obj_cursor)) {
            obj_cursor.image_xscale = 2;
            obj_cursor.image_yscale = 2;
        }
    }
}

function set_zoom_to_default() {
    camera_set_view_size(view_camera[0], global.default_view_width, global.default_view_height);
}

/// @function scr_zoom_keys
/// @description This script will zoom in and out of the game view based on the keys pressed.
/// @self obj_controller
function scr_zoom_keys() {
    static min_zoom = 0.3;
    static max_zoom = 2.5;

    var zoom_speed = 0.1;

    if (keyboard_check(vk_shift)) {
        zoom_speed *= 2;
    }

    //this is changes the zoom based on scolling but you can set it how ever you like
    var zoom_delta = 0;
    if (keyboard_check(vk_subtract) || keyboard_check(187) || keyboard_check(24) || mouse_wheel_down()) {
        if (obj_controller.map_scale > min_zoom) {
            zoom_delta = -1;
        }
    }
    if (keyboard_check(vk_add) || mouse_wheel_up()) {
        if (obj_controller.map_scale < max_zoom) {
            zoom_delta = +1;
        }
    }
    if (zoom_delta != 0) {
        // temporarily disable the view from automatically moving towards obj_controller
        var old_target = camera_get_view_target(view_camera[0]);
        camera_set_view_target(view_camera[0], noone);

        var mouse_pos = return_mouse_consts();
        var mouse_x_ = mouse_pos[0];
        var mouse_y_ = mouse_pos[1];
        var old_x = camera_get_view_x(view_camera[0]);
        var old_y = camera_get_view_y(view_camera[0]);
        var old_w = camera_get_view_width(view_camera[0]);
        var old_h = camera_get_view_height(view_camera[0]);
        if (old_w > 0 && old_h > 0) {
            var zoom_factor = max(0.1, 1 - zoom_speed * zoom_delta);
            var new_w = old_w * zoom_factor;
            var new_h = old_h * zoom_factor;
            camera_set_view_size(view_camera[0], new_w, new_h);
            var new_x = mouse_x_ - (mouse_x_ - old_x) * (new_w / old_w);
            var new_y = mouse_y_ - (mouse_y_ - old_y) * (new_h / old_h);
            camera_set_view_pos(view_camera[0], new_x, new_y);

            // update obj_controller as the new center of the view
            obj_controller.x = new_x + new_w / 2;
            obj_controller.y = new_y + new_h / 2;
        }
        camera_set_view_target(view_camera[0], old_target);
    }

    exit;
}
