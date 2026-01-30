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
    var change = 0;
    var zoom_speed = 0.1;

    if (keyboard_check(vk_shift)) {
        zoom_speed *= 2;
    }

    //this is changes the zoom based on scolling but you can set it how ever you like
    if (keyboard_check(vk_add) || keyboard_check(187) || keyboard_check(24) || mouse_wheel_down()) {
        if (obj_controller.map_scale < 3) {
            var view_w = camera_get_view_width(view_camera[0]);
            var view_h = camera_get_view_height(view_camera[0]);
            if (view_w > (0.5 * global.default_view_width)) {
                camera_set_view_size(view_camera[0], view_w * (1 - zoom_speed), view_h * (1 - zoom_speed));
                change = true;
            }
        }
    }
    if (keyboard_check(vk_subtract) || mouse_wheel_up()) {
        if (obj_controller.map_scale > 0.1) {
            var view_w = camera_get_view_width(view_camera[0]);
            var view_h = camera_get_view_height(view_camera[0]);
            if (view_w < (5 * global.default_view_width)) {
                camera_set_view_size(view_camera[0], view_w * (1 + zoom_speed), view_h * (1 + zoom_speed));
                change = true;
            }
        }
    }
    if (change != 0) {
        var view_w = camera_get_view_width(view_camera[0]);
        var view_h = camera_get_view_height(view_camera[0]);
        // @stitch-ignore-next-line: undeclared-global
        x = clamp(x, 0, room_width);
        // @stitch-ignore-next-line: undeclared-global
        y = clamp(y, 0, room_height);
    }

    exit;
}

global.zoom_level = 1;

//Get the starting view size to be used for interpolation later
global.default_zoom_width = camera_get_view_width(view_camera[0]);
global.default_zoom_height = camera_get_view_height(view_camera[0]);
