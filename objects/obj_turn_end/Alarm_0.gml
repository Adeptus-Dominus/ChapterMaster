try {
    instance_activate_object(obj_star);
    combating = 0;
    
    if (current_battle < array_length(battles)){
        battles[current_battle].prep_battle();
        show = current_battle;

    } else {
	    obj_controller.x = first_x;
        obj_controller.y = first_y;
        alarm[1] = 1;
	}

} catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
}
