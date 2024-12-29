function draw_sprite_rectangle(sprite_index, subimage, x1, y1, x2, y2){
    var w = x1 - x2;
    var h = y1 - y2;
    draw_sprite_stretched(sprite_index, subimage, x1, y1, w, h);
}

function draw_centered_sprite_stretched(sprite_index, subimage, width, height) {
    var _gui_width = camera_get_view_width(view_camera[0]);
    var _gui_height = camera_get_view_height(view_camera[0]);

    // Calculate the center position
    var _x_center = (_gui_width / 2) - (width / 2);
    var _y_center = (_gui_height / 2) - (height / 2);

    // Draw the stretched sprite at the center of the screen
    draw_sprite_stretched(sprite_index, subimage, _x_center, _y_center, width, height);
}

