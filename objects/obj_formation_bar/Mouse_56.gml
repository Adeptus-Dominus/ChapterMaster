var mah_target;
mah_target = 0;
/*if (dragging=true) and (nobar=true) then mah_target=col_target;
if (dragging=true) and (nobar=false) then mah_target=nearest_col;*/

mah_target = col_target;

if ((dragging == true) && instance_exists(mah_target)) {
    if (mah_target.col_parent == col_parent) {
        obj_controller.click = 1;
        obj_controller.cooldown = 20;
        x = old_x;
        y = old_y;
        rel_mousex = 0;
        rel_mousey = 0;
        old_x = 0;
        old_y = 0;
        col_target = 0;
        nearest_col = 0;
        nobar = false;
        obj_cursor.dragging = 0;
        obj_cursor.image_index = 0;
        dragging = false;
        exit;
    }
}

if ((dragging == true) && instance_exists(mah_target)) {

}

/* */
/*  */
