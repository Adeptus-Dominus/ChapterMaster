try {
    instance_activate_object(obj_star);
    combating = 0;
    scr_battle_sort();
    
    if (current_battle < array_length(battles)){
        var _battle_prep_variables = battles[i].prep_battle();
        next_battle_data = _battle_prep_variables;
    }

    if (current_battle >= array_length(battles) {
        //                         This is temporary for the sake of testing
        obj_controller.x = first_x;
        obj_controller.y = first_y;
        alarm[1] = 1;
    }
} catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
}
