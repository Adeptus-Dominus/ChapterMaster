


if (start=5) and (obj_controller.zoomed=0){
    if (mouse_x>=__view_get( e__VW.XView, 0 )+12) and (mouse_y>=__view_get( e__VW.YView, 0 )+436) and (mouse_x<__view_get( e__VW.XView, 0 )+48) and (mouse_y<__view_get( e__VW.YView, 0 )+480) and (room_speed<90) then room_speed+=30;
}
if (start=5) and (obj_controller.zoomed=1){
    if (mouse_x>24) and (mouse_y>872) and (mouse_x<90) and (mouse_y<960) and (room_speed<90) then room_speed+=30;
}



