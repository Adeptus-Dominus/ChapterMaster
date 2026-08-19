try {
    tooltip = "";
    tooltip2 = "";

    if (type == ePOPUP_TYPE.LIVERYPICK) {
        if (livery_pick_type == eLIVERY_COLOURING_OPTIONS.BULK) {
            assign_picked_liveries();
        } else if (livery_pick_type == eLIVERY_COLOURING_OPTIONS.ADVANCED) {
            assign_complex_picked_liveries();
        }
    } else if (type == ePOPUP_TYPE.EQUIP) {
        draw_popup_equip(before_after_styling);
        draw_set_font(cjk_font(fnt_40k_30b));

        var _role_data = obj_creation.player_role_data[target_role];
        var _role_name = _role_data.role;

        role_name_input.tooltip = $"Astartes Role Name\nThe name of this Astartes Role.  The plural form will be ''{_role_name}s''.";
        role_name_input.draw(_role_name);
        if (role_name_input.value_allowed) {
            _role_data.role = role_name_input.draw(_role_name);
        }
    }
} catch (ex) {
    ERROR_HANDLER.handle_exception(ex);
    instance_destroy();
}
