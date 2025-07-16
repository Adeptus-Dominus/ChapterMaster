
if (cooldown>0) and (cooldown<=5000) then cooldown-=1;

var xx,yy;
xx=__view_get( e__VW.XView, 0 )+0;
yy=__view_get( e__VW.YView, 0 )+0;

if (effect=11) and (!instance_exists(obj_saveload)){
    var sav,butt;
    with(obj_new_button){x-=2000;y-=2000;}

    // Force an autosave if none exists the first time someone clicks into the save menu
    if(!file_exists(PATH_autosave_file)){
        if(!instance_exists(obj_saveload)){
            instance_create(0,0,obj_saveload);
        }
        obj_saveload.autosaving = true;
        with (obj_controller){
            scr_save(0,0,true);
        }
        with(obj_saveload){
            instance_destroy();
        }
    }

    sav=instance_create(0,0,obj_saveload);
    sav.menu=1;
    butt=instance_create(xx+707,yy+830,obj_new_button);
    butt.sprite_index=spr_ui_but_1;
    butt.depth=-20010;
    butt.button_text="Back";
    butt.button_id=1;
    butt.scaling=1.5;
    butt.target=18;
}
if (effect=12) and (!instance_exists(obj_saveload)){var sav,butt;
    with(obj_new_button){x-=2000;y-=2000;}
    sav=instance_create(0,0,obj_saveload);sav.menu=2;
    butt=instance_create(xx+707,yy+830,obj_new_button);butt.sprite_index=spr_ui_but_1;
    butt.depth=-20010;butt.button_text="Back";butt.button_id=1;butt.scaling=1.5;butt.target=18;
}
if (effect=13){var butt;
    with(obj_new_button){x-=2000;y-=2000;}
    butt=instance_create(xx+653,yy+664,obj_new_button);butt.sprite_index=spr_ui_but_1;
    butt.depth=-20010;butt.button_text="Back";butt.button_id=1;butt.scaling=1.5;butt.target=25;
    settings=1;cooldown=8;
}
if (effect=14){
    instance_create(0,0,obj_fade);
    fading=0.1;
}
if (effect=15){
    if (instance_exists(obj_controller)){obj_controller.cooldown=8000;}
    with(obj_new_button){if (target>=10) then instance_destroy();}
    instance_destroy();
}


if (effect=18){with(obj_saveload){instance_destroy();}
    with(obj_new_button){if (target=18) then instance_destroy();x+=2000;y+=2000;}
}
if (effect=25){
    if (room_get_name(room)!="Main_Menu"){settings=0;cooldown=8;
        with(obj_new_button){if (target=25) then instance_destroy();x+=2000;y+=2000;}
        with(obj_new_button){if (x<=0) then x+=2000;if (y<=0) then y+=2000;}
    }
    if (room_get_name(room)="Main_Menu"){settings=0;cooldown=8;
        with(obj_new_button){instance_destroy();}
        instance_destroy();
    }
}
if (effect=26){settings=0;cooldown=8;if (instance_exists(obj_controller)){obj_controller.cooldown=8;}
    with(obj_new_button){instance_destroy();}instance_destroy();
}



if (effect>0) then effect=0;
if (fading>0){
    fading+=1;obj_fade.alpha=fading/30;
    if (fading>=35){
        global.returned=1;
        audio_stop_all();
        with(obj_ini){instance_destroy();}
        room_goto(Main_Menu);
    }
}
/*if (effect=0) and (settings=0) and (fading=0){
    if (instance_number(obj_new_button)>0){
        with(obj_new_button){
            if (x<=0) then x+=2000;
            if (y<=0) then y+=2000;
        }
    }
    if (instance_number(obj_new_button)=0){
        instance_create(0,0,obj_ingame_menu);
        instance_destroy();
    }
}*/

/* */
/*  */
