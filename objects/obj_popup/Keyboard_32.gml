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

if (array_length(options) == 0) and (type<5){
    obj_controller.cooldown=10;
    if (number!=0) and (obj_controller.complex_event=false){
        setup_audience_and_popup_timer(4);
    }
    instance_destroy();
}

if (type=POPUP_TYPE.BATTLE_OPTIONS){
    obj_controller.cooldown=10;
    end_turn_battle_next_sequence();
    obj_controller.force_scroll=0;
    instance_destroy();
}

}
