if (type == 99) {
    var onceh;
    onceh = 0;
    if ((obj_controller.zoomed == 0) && (onceh == 0)) {
        obj_controller.zoomed = 1;
        onceh = 1;
        view_visible[0] = false;
        view_visible[1] = true;
        obj_cursor.image_xscale = 2;
        obj_cursor.image_yscale = 2;
    }
    if ((obj_controller.zoomed == 1) && (onceh == 0)) {
        obj_controller.zoomed = 0;
        onceh = 1;
        view_visible[0] = true;
        view_visible[1] = false;
        obj_cursor.image_xscale = 1;
        obj_cursor.image_yscale = 1;
    }
}
