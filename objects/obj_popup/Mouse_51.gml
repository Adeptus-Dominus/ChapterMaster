
if (hide=true) then exit;

if (battle_special>0){
    alarm[0]=1;cooldown=10;exit;
}

if (instance_exists(obj_controller)){
    if (obj_controller.force_scroll=1) and (type=99) and (instance_exists(obj_turn_end)){
        player_retreat_from_fleet_combat();
    }
}

/* */
/*  */
