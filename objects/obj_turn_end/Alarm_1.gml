if (array_length(audience_stack) > 0) {
    var current_audience = audience_stack[0];

    // with (obj_controller) {
    //     if (zoomed == 1) {
    //         scr_zoom();
    //     }
    // }

    LOGGER.debug(current_audience);

    if (obj_controller.menu != eMENU.DIPLOMACY) {
        scr_toggle_diplomacy();
    }
    obj_controller.audience = current_audience.faction;
    obj_controller.diplomacy = current_audience.faction;
    obj_controller.audience_data = current_audience.audience_data;

    if ((obj_controller.diplomacy == 10) && (obj_controller.faction_gender[10] == 2)) {
        global.audio_manager.play_playlist(CONTEXT_DIPLOMACY, 60);
    }

    if (string_count("intro", current_audience.topic) > 0) {
        obj_controller.known[obj_controller.diplomacy] = 2;
        obj_controller.faction_justmet = 1;
        if (obj_controller.diplomacy == 6) {
            scr_dialogue("intro1");
        }
        if (obj_controller.diplomacy != 6) {
            //LOGGER.debug("new_intro");
            scr_dialogue("intro");
        }
    } else {
        scr_dialogue(current_audience.topic);
    }
    array_delete(audience_stack, 0, 1);
    exit;
}

current_popup += 1;

if (current_popup <= popups) {
    var pip = instance_create(0, 0, obj_popup);
    pip.title = popup_type[current_popup];
    pip.text = popup_text[current_popup];
    pip.image = popup_image[current_popup];
    if (is_struct(popup_special[current_popup])) {
        pip.pop_data = popup_special[current_popup];
        if (struct_exists(pip.pop_data, "options")) {
            pip.add_option(pip.pop_data.options);
        }
    } else {
        if ((popup_special[current_popup] != "") && (popup_special[current_popup] != "1") && (popup_special[current_popup] != "2")) {
            explode_script(popup_special[current_popup], "|");
            pip.mission = string(explode[0]);
            pip.loc = string(explode[1]);
            pip.planet = real(explode[2]);
            pip.estimate = real(explode[3]);
        }
        if (popup_special[current_popup] == "1") {
            pip.planet = 1;
        }
        if (popup_special[current_popup] == "2") {
            pip.planet = 2;
        }
    }
    pip.number = 1;
}
if ((current_popup > popups) || (popups == 0)) {
    if (popups_end == 0) {
        popups_end = 1;
    }
}

if (popups_end == 1) {
    obj_controller.x = first_x;
    obj_controller.y = first_y;

    alarm[2] = 10;
    obj_controller.menu = 0;
    combating = 0;

    obj_ini.sector_handler.increment_date();
}
