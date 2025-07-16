if (room_get_name(room)="Creation"){
    if (hover[1]=1){
        cooldown=9999;button=1;fading=1;
    }
    exit;
}

if ((obj_main_menu.tim4/50)>=1) and (button=0){
    if (hover[6]=1){
        cooldown=8000;button=6;fading=1;// Return from load
    }
}




