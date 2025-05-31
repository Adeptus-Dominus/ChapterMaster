
if (placing=true) and (cooldown<=0){
    placing=false;show=false;
    obj_controller.cooldown=8;
    obj_controller.menu=0;
    obj_controller.x=mouse_x;
    obj_controller.y=mouse_y;
    if (obj_controller.zoomed=1) then with(obj_controller){scr_zoom();}
    
    // Return to diplomacy here?
    
    if (instance_exists(obj_turn_end)){
        if (obj_turn_end.audience>0){
            with(obj_turn_end){
                cooldown=8;
                diplomacy=0;
                alarm[1]=1;
                audience=0;
                force_goodbye=0;
            }
        }
    }
}


