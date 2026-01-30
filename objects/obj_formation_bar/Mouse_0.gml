if ((obj_cursor.dragging == 0) && (obj_controller.cooldown <= 0)) {
    obj_cursor.dragging = 1;
    dragging = true;
    obj_controller.cooldown = 9999;
    obj_controller.click = 1;

    // save crap
    rel_mousex = x - mouse_x;
    rel_mousey = y - mouse_y - 1000;
    old_x = x;
    old_y = y;

    // Establish drop areas
    /*with(obj_temp8){instance_destroy();}
    with(obj_formation_bar){
        if (y<=view_yview[0]+230) then instance_create(x,y,obj_temp8);
    }*/
}

/* */
/*  */
