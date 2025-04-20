function scr_popup(type, text, image, popup_special="") {

	// title / text / image / speshul

	// Automatic quene of popups to be displayed at the end of the end of the turn
	// Do not use this for manual popups- only for important alerts that you force upon the player
	// Or, you know, you could fix it up

	if (instance_exists(obj_turn_end)){
	    obj_turn_end.popups++;
	    obj_turn_end.popup[obj_turn_end.popups]=1;
	    obj_turn_end.popup_type[obj_turn_end.popups]=type;
	    obj_turn_end.popup_text[obj_turn_end.popups]=text;
	    obj_turn_end.popup_image[obj_turn_end.popups]=image;
	    obj_turn_end.popup_special[obj_turn_end.popups]=popup_special;
	} else {
	    var pip=instance_create(0,0,obj_popup);
	    pip.title=type;
	    pip.text=text;
	    pip.image=image;	
	    if (is_struct(popup_special)){
	    	show_debug_message(popup_special);
	    	pip.pop_data = popup_special;
	    }
	}
}
