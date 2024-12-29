
if (current_audience<=audiences) then current_audience+=1;

if (audien[current_audience]!=0){
    with(obj_controller){if (zoomed=1) then scr_zoom();}

    obj_controller.audience=self.audien[self.current_audience];
    obj_controller.menu=20;
    obj_controller.diplomacy=obj_controller.audience;
    
    if (obj_controller.diplomacy=10) and (obj_controller.faction_gender[10]=2) then scr_music("blood",60);
    
    if (string_count("intro",audien_topic[current_audience])>0){
        obj_controller.known[obj_controller.diplomacy]=2;
        obj_controller.faction_justmet=1;
        if (obj_controller.diplomacy=6) then with(obj_controller){scr_dialogue("intro1");}
        if (obj_controller.diplomacy!=6) then with(obj_controller){scr_dialogue("intro");}
    }
    
    if (audien_topic[current_audience]!="intro"){
        with(obj_controller){scr_dialogue(obj_turn_end.audien_topic[obj_turn_end.current_audience]);}
        
        // "mission1"
        
    }
    exit;
}









// if (current_audience<=audiences) then alarm[1]=5;


if (audien[1]=0) or (current_audience>audiences){
    current_popup+=1;
    
    
    if (popup[current_popup]!=0){
        var pip;
        pip=instance_create(0,0,obj_popup);
        pip.title=popup_type[current_popup];
        pip.text=popup_text[current_popup];
        pip.image=popup_image[current_popup];
        if (popup_special[current_popup]!="") and ((pip.image="inquisition") or (pip.image="necron_cave")) and (popup_special[current_popup]!="1") and (popup_special[current_popup]!="2") and (pip.image!="tech_build") and (popup_special[current_popup]!="contraband") and (string_count("mech_",popup_special[current_popup])=0) and (string_count("meeting",popup_special[current_popup])=0){
            explode_script(popup_special[current_popup],"|");
            pip.mission=string(explode[0]);
            pip.loc=string(explode[1]);
            pip.planet=real(explode[2]);
            pip.estimate=real(explode[3]);
        }
        if (string_count("target_marine",popup_special[current_popup])>0){
            var aa;
            explode_script(popup_special[current_popup],"|");
            aa=string(explode[0]);
            pip.ma_name=string(explode[1]);
            pip.ma_co=real(explode[2]);
            pip.ma_id=real(explode[3]);
        }
        if (string_count("mech_",popup_special[current_popup])>0){
            explode_script(popup_special[current_popup],"|");
            pip.mission=string(explode[0]);
            pip.loc=string(explode[1]);
            // "mech_raider!0!|"+string(you2.name));        "mech_bionics!0!|"+string(you2.name));
        }
        if (string_count("meeting_",popup_special[current_popup])>0){
            pip.mission=popup_special[current_popup];
        }
        if (popup_special[current_popup]="contraband") then pip.loc="contraband";
        if (popup_special[current_popup]="1") then pip.planet=1;
        if (popup_special[current_popup]="2") then pip.planet=2;
        pip.number=1;
        
        
    }
    if (current_popup>popups) or (popup[1]=0){
        if (popups_end=0) then popups_end=1;
        // obj_controller.x=first_x;
        // obj_controller.y=first_y;
        // instance_destroy();
    }




    // obj_controller.x=first_x;
    // obj_controller.y=first_y;
    // instance_destroy();
}


// if (current_popup>popups) or (popup[1]=0) then popups_end=1;

if (popups_end=1){


    /*if (popups=0){
        obj_controller.x=first_x;
        obj_controller.y=first_y;
        instance_destroy();
    }*/


    obj_controller.x=first_x;
    obj_controller.y=first_y;
    
    alarm[2]=10;
    obj_controller.menu=0;
    combating=0;
    
    with(obj_controller){
        year_fraction+=84;
        if (year_fraction>999){
            year+=1;year_fraction=0;
        }
        if (year>=1000){
            millenium+=1;year-=1000;
        }
        // menu=0;
    }
    
}

/* */
/*  */
