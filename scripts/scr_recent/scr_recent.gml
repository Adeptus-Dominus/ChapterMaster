function scr_recent(recent_type = "", keyword = "", numerical_data = 0) {
    // recent_type: type
    // keyword: keyword
    // numerical_data: number, if applicable

    // Add an entry to the end of the argument2array
    if ((string(recent_type) != "") && (string(keyword) != "")) {
        i = obj_controller.recent_happenings;
        array_push(obj_controller.recent_type, recent_type);
        array_push(obj_controller.recent_keyword, keyword);
        array_push(obj_controller.recent_turn, obj_controller.turn);
        array_push(obj_controller.recent_number, numerical_data);
    }

    // Squish the array when asked to
    if ((string(recent_type) == "") && (string(keyword) == "") && (real(numerical_data) == 0)) {
        obj_controller.recent_happenings -= 1;
        delete_positions = [];
        for (var i = 0; i < array_length(obj_controller.recent_type); i++) {
            if (obj_controller.recent_type[i] == "") {
                array_push(delete_positions, i);
            }
        }
        var del_pos;
        for (var i = 0; i < array_length(delete_positions); i++) {
            del_pos = delete_positions[i];
            array_delete(obj_controller.recent_type, del_pos, 1);
            array_delete(obj_controller.recent_keyword, del_pos, 1);
            array_delete(obj_controller.recent_turn, del_pos, 1);
            array_delete(obj_controller.recent_number, del_pos, 1);
        }
    }
}
