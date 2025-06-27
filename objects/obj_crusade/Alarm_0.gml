
duration-=1;

if (duration=0){
    with(obj_en_ship){
        var ns;ns=instance_nearest(x,y,obj_crusade);
        if (owner=ns.owner) and (action="") and (home_x+home_y!=0) and (point_distance(x,y,ns.x,ns.y)<=ns.radius){
            action_x=home_x;
            action_y=home_y;
            set_fleet_movement();
        }
    }
    if (instance_exists(obj_turn_end)){
        if (owner = eFACTION.Imperium) then scr_alert("green","crusade","Imperial Crusade ends.",0,0);
    }
    instance_destroy();
}



