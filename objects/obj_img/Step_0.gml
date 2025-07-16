

//if ((instance_exists(obj_turn_end)) or (instance_exists(obj_fleet)) or (instance_exists(obj_star_select))) and (force_good=false) then scr_image("force",-50,0,0,0,0);
//if (!instance_exists(obj_turn_end)) and (!instance_exists(obj_fleet) and (!instance_exists(obj_star_select))) and (force_good=true) then scr_image("force",-666,0,0,0,0);


if (!instance_exists(obj_fleet)) and (!instance_exists(obj_ncombat)){
    
    if (instance_exists(obj_controller)){
        if (obj_controller.diplomacy=0) and (obj_controller.menu==MENU.Diplomacy) and (diplomacy_icon_good=false){
            scr_image("diplomacy_icon",-50,0,0,0,0);
            scr_image("symbol",-50,0,0,0,0);
        }
        if (obj_controller.menu!=20) and (diplomacy_icon_good=true){
            scr_image("diplomacy_icon",-666,0,0,0,0);
            scr_image("symbol",-666,0,0,0,0);
        }
        
        if (obj_controller.diplomacy>0) and (diplomacy_splash_good=false) then scr_image("diplomacy_splash",-50,0,0,0,0);
        if (obj_controller.diplomacy=0) and (diplomacy_splash_good=true) then scr_image("diplomacy_splash",-666,0,0,0,0);
        
        var adv_goo;adv_goo=0;
        if (obj_controller.diplomacy<-5) and (obj_controller.diplomacy>-6){adv_goo+=1;}
        if (obj_controller.menu>=11) and (obj_controller.menu<=16){adv_goo+=1;}
        if (obj_controller.menu>=500) and (obj_controller.menu<=510){adv_goo+=1;}
        if (adv_goo>0) and (advisor_good=false) then scr_image("advisor",-50,0,0,0,0);
        if (adv_goo=0) and (advisor_good=true) then scr_image("advisor",-666,0,0,0,0);
        
        //if (obj_controller.diplomacy>10) and (obj_controller.diplomacy<11) and (diplomacy_daemon_good=false) then scr_image("diplomacy_daemon",-50,0,0,0,0);
		//if (obj_controller.diplomacy<=10) or (obj_controller.diplomacy>=11) and (diplomacy_daemon_good=true) then scr_image("diplomacy_daemon",-666,0,0,0,0);
    
        if (obj_controller.menu=24) and (obj_controller.formating>0) and (formation_good=false) then scr_image("formation",-50,0,0,0,0);
        if (obj_controller.menu!=24) or (obj_controller.formating<=0) and (formation_good=true) then scr_image("formation",-666,0,0,0,0);
    }
    
    var crea_goo;crea_goo=0;
    if (instance_exists(obj_controller)){if (!instance_exists(obj_fleet)) and (!instance_exists(obj_ncombat)) then crea_goo+=1;}
    if (instance_exists(obj_creation)) then crea_goo+=1;
    if (room_get_name(room)="Defeat") then crea_goo+=1;
    if (crea_goo>0) and (creation_good=false) then scr_image("creation",-50,0,0,0,0);
    if (crea_goo<=0) and (creation_good=true) then scr_image("creation",-666,0,0,0,0);
    
    if (instance_exists(obj_ingame_menu)) and (menu_good=false) then scr_image("menu",-50,0,0,0,0);
    if (!instance_exists(obj_ingame_menu)) and (menu_good=true) then scr_image("menu",-666,0,0,0,0);
    
    if (instance_exists(obj_fleet)) and (postspace_good=false) then scr_image("postspace",-50,0,0,0,0);
    if (!instance_exists(obj_fleet)) and (postspace_good=true) then scr_image("postspace",-666,0,0,0,0);
    
    if (instance_exists(obj_popup)) and (popup_good=false) then scr_image("popup",-50,0,0,0,0);
    if (!instance_exists(obj_popup)) and (popup_good=true) then scr_image("popup",-666,0,0,0,0);
    
    if (instance_exists(obj_creation)) and (commander_good=false) then scr_image("commander",-50,0,0,0,0);
    if (!instance_exists(obj_creation)) and (commander_good=true) then scr_image("commander",-666,0,0,0,0);
    if (instance_exists(obj_creation)) and (slate_good=false) then scr_image("slate",-50,0,0,0,0);
    if (!instance_exists(obj_creation)) and (slate_good=true) then scr_image("slate",-666,0,0,0,0);
    
    if ((instance_exists(obj_creation)) or (instance_exists(obj_star_select))) and (planet_good=false) then scr_image("planet",-50,0,0,0,0);
    if (!instance_exists(obj_creation)) and (!instance_exists(obj_star_select)) and (planet_good=true) then scr_image("planet",-666,0,0,0,0);
    
    if (instance_exists(obj_turn_end)) and (attacked_good=false) then scr_image("attacked",-50,0,0,0,0);
    if (!instance_exists(obj_turn_end)) and (attacked_good=true) then scr_image("attacked",-666,0,0,0,0);
    
    if (instance_exists(obj_drop_select)) and (purge_good=false) then scr_image("purge",-50,0,0,0,0);
    if (!instance_exists(obj_drop_select)) and (purge_good=true) then scr_image("purge",-666,0,0,0,0);
    
    if (instance_exists(obj_event)) and (event_good=false) then scr_image("event",-50,0,0,0,0);
    if (!instance_exists(obj_event)) and (event_good=true) then scr_image("event",-666,0,0,0,0);
    
    if (room_get_name(room)="Main_Menu") and (title_splash_good=false) then scr_image("title_splash",-50,0,0,0,0);
    if (room_get_name(room)!="Main_Menu") and (title_splash_good=true) then scr_image("title_splash",-666,0,0,0,0);
    
    if (room_get_name(room)="Defeat") and (defeat_good=false) then scr_image("defeat",-50,0,0,0,0);
    if (room_get_name(room)!="Defeat") and (defeat_good=true) then scr_image("defeat",-666,0,0,0,0);

}



