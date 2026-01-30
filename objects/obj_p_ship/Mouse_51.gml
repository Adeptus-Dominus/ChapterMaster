if ((selected == 1) && (!instance_exists(obj_circular)) && (obj_fleet.control != 0)) {
    var stahp;
    stahp = 0;
    var xx = __view_get(e__VW.XView, 0);
    var yy = __view_get(e__VW.YView, 0);

    if ((obj_fleet.start == 5) && (obj_controller.zoomed == 0)) {
        if (point_in_rectangle(mouse_x, mouse_y, xx + 12, yy + 436, xx + 48, yy + 480)) {
            stahp = 1;
        }
    } else if ((obj_fleet.start == 5) && (obj_controller.zoomed == 1)) {
        if (point_in_rectangle(mouse_x, mouse_y, xx + 24, yy + 872, xx + 90, yy + 960)) {
            stahp = 1;
        }
    } // and (room_speed<90)

    if (stahp == 0) {
        paction = "";
        /*target_x=mouse_x;
        target_y=mouse_y;
        
        if (instance_exists(obj_en_ship)){
            var tee,tee_dis;tee=0;tee_dis=0;
            tee=instance_nearest(mouse_x,mouse_y,obj_en_ship);
            tee_dis=point_distance(mouse_x,mouse_y,tee.x,tee.y);
            
            if (tee_dis<=40){
                paction="attack";
                target=tee;
            }
            if (tee_dis>40){
                paction="turn";
            }
        }
        if (!instance_exists(obj_en_ship)){
            paction="turn";
        }*/

        instance_create(20, 20, obj_circular);
    }
}

/* */
/*  */
