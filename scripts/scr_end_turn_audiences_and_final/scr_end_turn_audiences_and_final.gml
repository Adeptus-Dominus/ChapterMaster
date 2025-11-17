function scr_end_turn_check_audiences_and_popups(){
	var _is_audience = false;
	if (array_length(audience_stack) > 0){
	    var current_audience = audience_stack[0];
	    _is_audience = true;
	}


	if (_is_audience){
	    with(obj_controller){
	        if (zoomed=1){
	            scr_zoom();
	        }
	    }

	    //show_debug_message(current_audience);

	    if (obj_controller.menu != MENU.Diplomacy){
	        scr_toggle_diplomacy();
	    }
	    obj_controller.audience = current_audience.faction;
	    obj_controller.diplomacy = current_audience.faction;
	    obj_controller.audience_data = current_audience.audience_data;
	    
	    if (obj_controller.diplomacy=10) and (obj_controller.faction_gender[10]=2){
	        scr_music("blood",60);
	    }
	    
	    if (string_count("intro",current_audience.topic)>0){
	        obj_controller.known[obj_controller.diplomacy]=2;
	        obj_controller.faction_justmet=1;
	        if (obj_controller.diplomacy=6){

	             scr_dialogue("intro1");

	        }
	        if (obj_controller.diplomacy!=6){
	            //show_debug_message("new_intro");
	            scr_dialogue("intro");

	        }
	    }else {
	        scr_dialogue(current_audience.topic);
	        
	    }
	    array_delete(audience_stack, 0, 1);
	    exit;
	}


	if (!_is_audience){
	    turn_end_popups();
	}

}

function setup_audience_and_popup_timer(timer = 1){
	wait_and_execute(timer,scr_end_turn_check_audiences_and_popups,[], obj_turn_end);
}

function turn_end_popups(){
	current_popup+=1;
	    
	    
    if (current_popup>=0 && current_popup<array_length(popup)){
        var pip=instance_create(0,0,obj_popup);
        pip.title=popup_type[current_popup];
        pip.text=popup_text[current_popup];
        pip.image=popup_image[current_popup];
        if (is_struct(popup_special[current_popup])){
            pip.pop_data = popup_special[current_popup];
            if (struct_exists(pip.pop_data , "options")){
                pip.add_option(pip.pop_data.options);
            }
        } else {
            if (popup_special[current_popup]!="") and ((pip.image="inquisition")) and (popup_special[current_popup]!="1") and (popup_special[current_popup]!="2") and (pip.image!="tech_build") and (popup_special[current_popup]!="contraband") and (string_count("mech_",popup_special[current_popup])=0) and (string_count("meeting",popup_special[current_popup])=0){
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
        }
        pip.number=1;
        
        
    }
    popups_end = current_popup>=array_length(popup);


	if (popups_end){
		final_end_turn_sequence();
	}
    // obj_controller.x=first_x;
    // obj_controller.y=first_y;
    // instance_destroy();
}

	    /*if (popups=0){
	        obj_controller.x=first_x;
	        obj_controller.y=first_y;
	        instance_destroy();
	    }*/

function final_end_turn_sequence(){
    obj_controller.x = first_x;
    obj_controller.y = first_y;
    
    alarm[2]=10;
    obj_controller.menu=0;
    combating=0;
    increment_in_game_time();
}

function increment_in_game_time(){
    with(obj_controller){
        year_fraction+=84;
        if (year_fraction>999){
            year+=1;
            year_fraction=0;
        }
        if (year>=1000){
            millenium+=1;
            year-=1000;
        }
        // menu=0;
    }
}
