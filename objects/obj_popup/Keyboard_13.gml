var __b__;
__b__ = action_if_variable(cooldown, 0, 2);
if !__b__
{

if (hide=true) then exit;
if (!instance_exists(obj_controller)) then exit;
if (instance_exists(obj_fleet)) then exit;


if (battle_special>0){
    alarm[0]=1;
    cooldown=10;exit;
}

if (array_length(options == 0) && type<5){
    obj_controller.cooldown=10;
    if (number!=0) and (obj_controller.complex_event=false){
        if (instance_exists(obj_turn_end)){
            obj_turn_end.alarm[1]=4;
        }
    }
    instance_destroy();
}

if (type=POPUP_TYPE.BATTLE_OPTIONS){
    end_turn_battle_next_sequence();
    instance_destroy();
}



}
