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

if (option1="" && type<5){
    obj_controller.cooldown=10;
    if (number!=0) and (obj_controller.complex_event=false){
        if (instance_exists(obj_turn_end)){
            obj_turn_end.alarm[1]=4;
        }
    }
    instance_destroy();
}

if (type=98){
    obj_controller.cooldown=10;
    obj_turn_end.current_battle+=1;
    obj_turn_end.alarm[0]=1;
    obj_controller.force_scroll=0;
    instance_destroy();
}



}
