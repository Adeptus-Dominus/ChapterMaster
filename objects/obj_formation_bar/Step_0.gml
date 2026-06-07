/*

dragging=false;
rel_mousex=0;
rel_mousey=0;
old_x=0;
old_y=0;

unit_type="";
unit_id=0;

size=0;
col_parent=0;
col_target=0;
above_neighbor=0;
nearest_col=0;

height=0;
width=0;
text_xscale=1.25;
image_speed=0;



*/

if (dragging == true) {
    x = mouse_x + rel_mousex;
    y = mouse_y + rel_mousey;
    obj_cursor.image_index = 3;
    col_target = instance_nearest(x, __view_get(e__VW.YView, 0) + 224, obj_temp8);
    nearest_col = instance_nearest(col_target.x, col_target.y, obj_formation_bar);
    nobar = false;
    if (point_distance(col_target.x, col_target.y, nearest_col.x, nearest_col.y) > 2) {
        nobar = true;
    }
}
if (dragging == false) {
    rel_mousex = 0;
    rel_mousey = 0;
    old_x = 0;
    old_y = 0;
    col_parent = 0;
    col_target = 0;
    above_neighbor = 0;
    nearest_col = 0;
}

/* */
/*  */
