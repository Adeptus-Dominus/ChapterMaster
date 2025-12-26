
//scr_dead_marines(1);


start=7;


with(obj_controller){
    if (zoomed=1) then scr_zoom();
    camera_set_view_size(view_camera[0], room_width, room_height);
    x = room_width/2;
    y = room_height/2;
}

