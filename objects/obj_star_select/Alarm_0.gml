/*if (instance_exists(target)){
    if (target.craftworld=1) or (target.space_hulk=1){
        // 135 ;
        obj_controller.selecting_planet=1;
    
        if (instance_exists(obj_p_fleet)){
            var targ_targ;targ_targ=instance_nearest(target.x+24,target.y-24,obj_p_fleet);
            
            if (instance_exists(targ_targ)){
                if (targ_targ.action="") and (point_distance(target.x+24,target.y-24,targ_targ.x,targ_targ.y)<=40){
                    
                    // if (target.p_owner[obj_controller.selecting_planet]>5){
                        if (button1!=""){button1="Raid";if (targ_targ.capital_number>0) or (targ_targ.frigate_number>0) then button2="Bombard";}
                        if (button1=""){button2="Raid";if (targ_targ.capital_number>0) or (targ_targ.frigate_number>0) then button3="Bombard";}
                    // }
                }
            }
        }
    }
}*/

if (loading == 0) {
    exit;
}

// check for the right star

var xb, yb, good, tiber;
xb = 0;
yb = 0;
good = 0;
tiber = 0;

with (obj_star) {
    if (name == obj_star_select.loading_name) {
        instance_create(x, y, obj_temp2);
    }
}
if (instance_exists(obj_temp2)) {
    tiber = instance_nearest(obj_temp2.x, obj_temp2.y, obj_star);
    target = tiber;
}
with (obj_temp2) {
    instance_destroy();
}

instance_activate_object(obj_star);

/* */
/*  */
