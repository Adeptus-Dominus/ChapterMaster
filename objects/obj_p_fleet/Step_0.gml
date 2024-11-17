ii_check-=1;

if (action!="") and (orbiting!=0){
    orbiting = instance_nearest(x,y,obj_star)
    orbiting.present_fleet[1]-=1;
    orbiting=0;
}

action_spd = calculate_action_speed();

if (ii_check=0){set_player_fleet_image()}

if (global.load>0) and (sprite_index!=spr_fleet_tiny) then sprite_index=spr_fleet_tiny;

if (fix>-1) then fix-=1;
if (fix=0) and (action=""){
    set_fleet_location(instance_nearest(x,y,obj_star).name);
}


