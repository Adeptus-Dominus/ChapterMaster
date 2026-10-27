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
    obj_controller.diplo_handler.setup_faction_head_meeting(current_audience.faction, current_audience.topic, current_audience.audience_data)
    audience = true;

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
        if ((popup_special[current_popup] != "") && (pip.image == "inquisition") && (popup_special[current_popup] != "1") && (popup_special[current_popup] != "2") && (pip.image != "tech_build") && (popup_special[current_popup] != "contraband") && (string_count("mech_", popup_special[current_popup]) == 0) && (string_count("meeting", popup_special[current_popup]) == 0)) {
            explode_script(popup_special[current_popup], "|");
            pip.mission = string(explode[0]);
            pip.loc = string(explode[1]);
            pip.planet = real(explode[2]);
            pip.estimate = real(explode[3]);
        }
        if (string_count("target_marine", popup_special[current_popup]) > 0) {
            explode_script(popup_special[current_popup], "|");
            var aa = string(explode[0]);
            pip.ma_name = string(explode[1]);
            pip.ma_co = real(explode[2]);
            pip.ma_id = real(explode[3]);
        }
        if (string_count("mech_", popup_special[current_popup]) > 0) {
            explode_script(popup_special[current_popup], "|");
            pip.mission = string(explode[0]);
            pip.loc = string(explode[1]);
        }
        if (string_count("meeting_", popup_special[current_popup]) > 0) {
            pip.mission = popup_special[current_popup];
        }
        if (popup_special[current_popup] == "contraband") {
            pip.loc = "contraband";
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
