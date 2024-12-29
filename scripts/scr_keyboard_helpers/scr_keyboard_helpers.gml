


#macro ARR_virtual_keys [vk_left, vk_right, vk_up,vk_down,vk_enter,vk_escape,vk_space,vk_shift,vk_control,vk_alt,vk_backspace,vk_tab,vk_home,vk_end,vk_delete,vk_insert,vk_pageup,vk_pagedown,vk_pause,vk_printscreen,vk_f1,vk_f2,vk_f3,vk_f4,vk_f5,vk_f6,vk_f7,vk_f8,vk_f9,vk_f10,vk_f11,vk_f12,vk_numpad0,vk_numpad1,vk_numpad2,vk_numpad3,vk_numpad4,vk_numpad5,vk_numpad6,vk_numpad7,vk_numpad8,vk_numpad9, vk_multiply,vk_divide,vk_add,vk_subtract,vk_decimal]

//,vk_lshift,vk_lcontrol,vk_lalt,vk_rshift,vk_rcontrol,vk_ralt these ones can cause issues


function press_exclusive(press_choice){
	if (keyboard_check_pressed(vk_nokey)) then return false;
	if (!keyboard_check_pressed(press_choice)) then return false;
	var _virtual_keys = ARR_virtual_keys;
	for (var i=0;i<array_length(_virtual_keys);i++){
		if (keyboard_check(_virtual_keys[i]) && _virtual_keys[i] != press_choice){
			return false;
		}
	}
	return true;
}


function hold_exclusive(press_choice) {
	if (keyboard_check(vk_nokey)) then return false;
	if (!keyboard_check(press_choice)) then return false;
	var _virtual_keys = ARR_virtual_keys;
	for (var i=0;i<array_length(_virtual_keys);i++){
		if (keyboard_check(_virtual_keys[i]) && _virtual_keys[i] != press_choice){
			return false;
		}
	}
	return true;
}



function press_with_held(press_choice, hold_choice){
	if (keyboard_check_pressed(vk_nokey)) then return false;
	if (!keyboard_check_pressed(press_choice) || !keyboard_check(hold_choice)) then return false;
	var cur_vert_key;
	var _virtual_keys = ARR_virtual_keys;
	for (var i=0;i<array_length(_virtual_keys);i++){
		cur_vert_key =  _virtual_keys[i];
		if (cur_vert_key==press_choice || cur_vert_key==hold_choice) then continue;
		if (keyboard_check(cur_vert_key)){
			show_debug_message($"non viable click {keyboard_check_pressed(press_choice)},{keyboard_check(hold_choice)}");
			return false;
		}

	}
	return true;
}