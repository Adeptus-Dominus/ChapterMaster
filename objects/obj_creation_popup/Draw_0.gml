try {
    tooltip = "";
    tooltip2 = "";

    if (type == ePOPUP_TYPE.LIVERYPICK && target_role > 0) {
        assign_picked_liveries();
    } else if (type == ePOPUP_TYPE.EQUIP) {
        draw_popup_equip(before_after_styling);
        draw_set_font(fnt_40k_30b);

        var _role_data = obj_creation.player_role_data[target_role];
        var _role_name = _role_data.role;

        role_name_input.tooltip = $"Astartes Role Name/nThe name of this Astartes Role.  The plural form will be ''{_role_name}s''.";
        role_name_input.draw(_role_name);
        if (role_name_input.value_allowed) {
            _role_data.role = role_name_input.draw(_role_name);
        }
    }

    if ((tooltip != "") && (obj_creation.change_slide <= 0)) {
        draw_set_alpha(1);
        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);
        draw_set_color(0);
        draw_rectangle(mouse_x + 18, mouse_y + 20, mouse_x + string_width_ext(string_hash_to_newline(tooltip2), -1, 500) + 24, mouse_y + 44 + string_height_ext(string_hash_to_newline(tooltip2), -1, 500), 0);
        draw_set_color(CM_GREEN_COLOR);
        draw_rectangle(mouse_x + 18, mouse_y + 20, mouse_x + string_width_ext(string_hash_to_newline(tooltip2), -1, 500) + 24, mouse_y + 44 + string_height_ext(string_hash_to_newline(tooltip2), -1, 500), 1);
        draw_set_font(fnt_40k_14b);
        draw_text(mouse_x + 22, mouse_y + 22, string_hash_to_newline(string(tooltip)));
        draw_set_font(fnt_40k_14);
        draw_text_ext(mouse_x + 22, mouse_y + 42, string_hash_to_newline(string(tooltip2)), -1, 500);
    }
} catch (ex) {
    ERROR_HANDLER.handle_exception(ex);
    instance_destroy();
}
