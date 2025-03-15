
if (fast=0){
    instance_activate_object(obj_star_event);
    if (instance_exists(obj_star_event)){
        obj_star_event.image_alpha=1;
        obj_star_event.image_speed=1;
    }
    
    instance_activate_object(obj_star_select);
    instance_activate_object(obj_drop_select);
    instance_activate_object(obj_bomb_select);
    
    if (instance_exists(obj_star_select)) then obj_star_select.alarm[1]=2;
}



fast += 1;
if (fast < alerts) { alarm[2] = int64(global.frame_timings.i10); }

if (fast >= alerts) {
    alarm[2] = int64(global.frame_timings.i9999);
    alarm[3] = int64(max(230, (alerts * 60)) * global.invert_frame_pacing);
    alarm[3] = int64(min(alarm[3], 360) * global.invert_frame_pacing);
}

if (alerts == 0) { instance_destroy(); }
