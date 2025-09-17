
if ((cooldown<=0)){
    if (hide){
        exit;
    }
    if (instances_exist_any([obj_fleet])){
        exit;
    }
    if (!instance_exists(obj_controller)){
        exit;
    }
    if (obj_controller.scrollbar_engaged){
        exit;
    }

    if (battle_special>0){
        alarm[0]=1;
        cooldown=10;
        exit;
    }

    if (type=POPUP_TYPE.BATTLE_OPTIONS){
        obj_controller.cooldown=10;
        if (instance_exists(obj_turn_end)){
            obj_turn_end.current_battle+=1;
            obj_turn_end.alarm[0]=1;
        }
        obj_controller.force_scroll=0;
        instance_destroy();
        exit;
    }

    if (option1=="" && type<5){
        obj_controller.cooldown=10;
        if (instance_exists(obj_turn_end) && obj_controller.complex_event==false){
            if (number!=0){
                obj_turn_end.alarm[1]=4;
            }
        }
        instance_destroy();
        exit;
    }
}
/*  */
