//TODO almost all of this can be handled in the gui layer
try {
    scr_ui_manage();
    scr_ui_advisors();
    if (menu == eMENU.DIPLOMACY) {
        scr_ui_diplomacy();
    }
} catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
    main_map_defaults();
}

//star fleet edbug options spawn
if (global.cheat_debug && mouse_check_button_pressed(mb_right)) {
    if (!instances_exist_any([obj_turn_end, obj_ncombat, obj_fleet, obj_fleet_select, obj_popup, obj_star_select])) {
        new_system_debug_popup();
    }
}
