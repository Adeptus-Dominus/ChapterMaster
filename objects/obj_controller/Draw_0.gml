//TODO almost all of this can be handled in the gui layer
try {
    scr_ui_manage();
    scr_ui_advisors();
    scr_ui_tooltip();
    if (menu == eMENU.DIPLOMACY) {
        scr_ui_diplomacy();
    }
    if (menu == eMENU.SECRET_LAIR) {
        scr_secret_lair_view();
    }
} catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
    main_map_defaults();
}

//star fleet edbug options spawn
if (global.cheat_debug == true && mouse_check_button_pressed(mb_right)) {
    if (!instances_exist_any([obj_turn_end, obj_ncombat, obj_fleet, obj_fleet_select, obj_popup, obj_star_select])) {
        new_system_debug_popup();
    }
}
