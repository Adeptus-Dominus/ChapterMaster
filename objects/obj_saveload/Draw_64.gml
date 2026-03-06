if (!hide) {
    if (autosaving) {
        exit;
    }

    if (save_part + load_part > 0) {
        draw_set_color(0);

        //
        // draw_sprite(spr_load_splash,splash,0+0,0+0);
        scr_image("loading", splash, 0, 0, 1600, 900);
        //

        draw_sprite(spr_loadbar_empty, 0, 1047, 875);
        draw_sprite(spr_loadbar, 0, 1047, 875);
        draw_sprite(spr_loadbar_cover, bar, 1047, 875);

        if (save_part > 0) {
            draw_sprite(spr_load_text, 1, 1068, 821);
        }
        if ((load_part > 0) && (global.restart == 0)) {
            draw_sprite(spr_load_text, 0, 1068, 821);
        }
        if ((load_part > 0) && (global.restart > 0)) {
            draw_sprite(spr_load_text, 2, 1068, 821);
        }
    }

    if ((menu == 1) || (menu == 2)) {
        // This is the other one
        draw_set_color(0);
        draw_set_alpha(0.75);
        if (room_get_name(room) != "rm_main_menu") {
            draw_rectangle(0, 0, room_width, room_height, 0);
        }
        if (room_get_name(room) == "rm_main_menu") {
            draw_rectangle(0, 0, room_width, 707, 0);
        }
        draw_set_alpha(1);

        draw_set_halign(fa_center);
        draw_set_color(0);

        draw_sprite(spr_save_header, 0, 0, 27);
        if (menu == 1) {
            draw_sprite(spr_save_headers, 1, 800, 60);
        }
        if (menu == 2) {
            draw_sprite(spr_save_headers, 0, 800, 60);
        }
        draw_sprite(spr_save_footer, 0, 0, 797);

        var slot_index = top;
        var slot_left = 32;
        var slot_top = 166;
        repeat (4) {
            if (((save[slot_index] >= 0) || ((first_open == slot_index) && (menu == 1)) || (global.load == slot_index) || (save_number == slot_index)) && (save_number == 0)) {
                draw_set_font(fnt_40k_30b);
                draw_set_halign(fa_left);
                draw_set_color(0);

                draw_rectangle(slot_left + 56, slot_top + 5, slot_left + 238, slot_top + 123, 0);
                draw_rectangle(slot_left + 258, slot_top + 25, slot_left + 1480, slot_top + 80, 0);

                if (scr_hit(slot_left, slot_top, slot_left + 1526, slot_top + 149)) {
                    debug = "Save:" + string(save[slot_index]) + ", array position:" + string(slot_index) + ", turn:" + string(save_turn[slot_index]);
                }
                draw_sprite(spr_save_data, 0, slot_left, slot_top);
                if (slot_index == 0) {
                    //autosave
                    draw_text_transformed(slot_left + 21, slot_top + 62, string_hash_to_newline("A"), 1.1, 1.1, 0);
                } else {
                    draw_text_transformed(slot_left + 23, slot_top + 62, string_hash_to_newline(slot_index), 1.1, 1.1, 0);
                }
                draw_text_transformed(slot_left + 270, slot_top + 10, string_hash_to_newline("Chapter"), 0.9, 0.9, 0);
                draw_text_transformed(slot_left + 774, slot_top + 10, string_hash_to_newline("Marines"), 0.9, 0.9, 0);
                draw_text_transformed(slot_left + 1024, slot_top + 10, string_hash_to_newline("Turn"), 0.9, 0.9, 0);
                draw_text_transformed(slot_left + 1274, slot_top + 10, string_hash_to_newline("Game Time"), 0.9, 0.9, 0);

                draw_set_color(c_gray);
                if (first_open != slot_index) {
                    draw_text_transformed(slot_left + 270, slot_top + 48, string_hash_to_newline(string(save_chapter[save[slot_index]]) + " (" + string(save_date[save[slot_index]]) + ")"), 0.7, 0.7, 0);
                    draw_text_transformed(slot_left + 774, slot_top + 48, string_hash_to_newline(string(save_marines[save[slot_index]])), 0.7, 0.7, 0);
                    draw_text_transformed(slot_left + 1024, slot_top + 48, string_hash_to_newline(string(save_turn[save[slot_index]])), 0.7, 0.7, 0);
                    var _chapter_icon = scr_load_chapter_icon(save_icon[save[slot_index]]);
                    var _icon_size = 94;
                    draw_sprite_stretched(_chapter_icon, 0, slot_left + 147 - (_icon_size / 2), slot_top + 28, _icon_size, _icon_size);
                    var ohboy, result, tsec, tmin, thour, tday;
                    ohboy = save_time[save[slot_index]];
                    result = "";
                    tsec = 0;
                    tmin = 0;
                    thour = 0;
                    tday = 0;
                    if (ohboy > 0) {
                        tday = floor(ohboy / 86400);
                        if (tday >= 1) {
                            ohboy -= tday * 86400;
                        }
                        thour = floor(ohboy / 3600);
                        if (thour >= 1) {
                            ohboy -= thour * 3600;
                        }
                        tmin = floor(ohboy / 60);
                        if (tmin >= 1) {
                            ohboy -= tmin * 60;
                        }
                        tsec = ohboy;

                        if (tday > 0) {
                            result += string(tday) + "d ";
                        }
                        if (thour == 0) {
                            result += "00:";
                        }
                        if ((thour > 0) && (thour < 10)) {
                            result += "0" + string(thour) + ":";
                        }
                        if (thour >= 10) {
                            result += string(thour) + ":";
                        }
                        if (tmin == 0) {
                            result += "00:";
                        }
                        if ((tmin > 0) && (tmin < 10)) {
                            result += "0" + string(tmin) + ":";
                        }
                        if (tmin >= 10) {
                            result += string(tmin) + ":";
                        }
                        if (tsec == 0) {
                            result += "00";
                        }
                        if ((tsec > 0) && (tsec < 10)) {
                            result += "0" + string(tsec);
                        }
                        if (tsec >= 10) {
                            result += string(tsec);
                        }
                    }
                    draw_text_transformed(slot_left + 1274, slot_top + 48, string_hash_to_newline(string(result)), 0.7, 0.7, 0);
                }
                if ((first_open == slot_index) && (menu == 1)) {
                    draw_text_transformed(slot_left + 270, slot_top + 48, string_hash_to_newline("(EMPTY SAVE SLOT)"), 0.7, 0.7, 0);
                }
            }

            draw_set_font(fnt_40k_30b);
            draw_set_halign(fa_center);

            if (save[slot_index] > 0) {
                //intentionally not allowed to delete the autosave file
                // Delete Data
                draw_set_alpha(1);
                draw_set_color(c_gray);
                draw_rectangle(slot_left + 807, slot_top + 113, slot_left + 951, slot_top + 146, 0);
                draw_set_color(c_black);
                draw_rectangle(slot_left + 807, slot_top + 113, slot_left + 951, slot_top + 146, 1);
                draw_text_transformed(slot_left + 879, slot_top + 117, string_hash_to_newline("Delete Game"), 0.7, 0.7, 0);
                if (scr_hit(slot_left + 807, slot_top + 113, slot_left + 951, slot_top + 146)) {
                    draw_set_alpha(0.1);
                    draw_set_color(c_white);
                    draw_rectangle(slot_left + 807, slot_top + 113, slot_left + 951, slot_top + 146, 0);
                    draw_set_alpha(1);
                    if (mouse_button_clicked(,, true) && !instance_exists(obj_popup)) {
                        // Clear
                        var com;
                        com = instance_create_depth(0, 0, -200010, obj_popup);
                        com.image = "fuklaw";
                        com.title = "Delete Save Game?";
                        com.text = "Are you sure you wish to delete Save " + string(save[slot_index]) + "- " + string(save_chapter[save[slot_index]]) + "?";
                        com.add_option(["Yes", "No"]);
                        com.save = slot_index;
                        com.woopwoopwoop = menu;
                        com.owner = top;
                    }
                }
            }

            if ((menu == 2) && (save[slot_index] >= 0)) {
                // Load
                draw_set_alpha(1);
                draw_set_color(c_gray);
                draw_rectangle(slot_left + 1317, slot_top + 113, slot_left + 1461, slot_top + 146, 0);
                draw_set_color(c_black);
                draw_rectangle(slot_left + 1317, slot_top + 113, slot_left + 1461, slot_top + 146, 1);
                draw_text_transformed(slot_left + 1385, slot_top + 117, string_hash_to_newline("Load Game"), 0.7, 0.7, 0);
                if (scr_hit(slot_left + 1317, slot_top + 113, slot_left + 1461, slot_top + 146)) {
                    draw_set_alpha(0.1);
                    draw_set_color(c_white);
                    draw_rectangle(slot_left + 1317, slot_top + 113, slot_left + 1461, slot_top + 146, 0);
                    draw_set_alpha(1);
                    if (mouse_button_clicked(,, true) && !instance_exists(obj_popup)) {
                        // Load
                        global.load = save[slot_index];
                        menu = 0;
                        load_part = 1;
                        obj_cursor.image_alpha = 0;
                        splash = choose(0, 1, 2, 3, 4);

                        // show_message("loading 'save"+string(save[slot_index])+".json'");

                        if (instance_exists(obj_main_menu)) {
                            with (obj_main_menu) {
                                instance_destroy();
                            }
                        }

                        with (obj_controller) {
                            instance_destroy();
                        }
                        with (obj_creation) {
                            instance_destroy();
                        }
                        with (obj_ini) {
                            instance_destroy();
                        }
                        with (obj_star) {
                            instance_destroy();
                        }
                        with (obj_all_fleet) {
                            instance_destroy();
                        }
                        with (obj_popup) {
                            instance_destroy();
                        }
                        audio_stop_all();

                        room_goto(rm_game);
                    }
                }
            }

            if ((menu == 1) && ((save[slot_index] > 0) || (first_open == slot_index))) {
                // intentionally not allowed to saveover the autosave slot manually
                // Save
                draw_set_alpha(1);
                draw_set_color(c_gray);
                draw_rectangle(slot_left + 1317, slot_top + 113, slot_left + 1461, slot_top + 146, 0);
                draw_set_color(c_black);
                draw_rectangle(slot_left + 1317, slot_top + 113, slot_left + 1461, slot_top + 146, 1);
                draw_text_transformed(slot_left + 1386, slot_top + 117, string_hash_to_newline("Save Game"), 0.7, 0.7, 0);
                if (scr_hit(slot_left + 1317, slot_top + 113, slot_left + 1461, slot_top + 146)) {
                    draw_set_alpha(0.1);
                    draw_set_color(c_white);
                    draw_rectangle(slot_left + 1317, slot_top + 113, slot_left + 1461, slot_top + 146, 0);
                    draw_set_alpha(1);
                    if (mouse_button_clicked(,, true)) {
                        if (instance_exists(obj_main_menu)) {
                            with (obj_main_menu) {
                                part_particles_clear(p_system);
                            }
                        }

                        // If open slot then set the save.ini to the maximum
                        if (!file_exists(string(PATH_SAVE_FILES, save[slot_index])) || (save[slot_index] == 0)) {
                            save_part = 1;
                            menu = 0;
                            save_number = max_ini;
                            obj_cursor.image_alpha = 0;
                            splash = choose(0, 1, 2, 3, 4);
                            with (obj_new_button) {
                                instance_destroy();
                            }
                            with (obj_ingame_menu) {
                                instance_destroy();
                            }
                            // Other here
                            alarm[0] = 1;
                        }
                        // If file exists then overright
                        if (file_exists(string(PATH_SAVE_FILES, save[slot_index]))) {
                            file_delete(string(PATH_SAVE_FILES, save[slot_index]));
                            save_part = 1;
                            menu = 0;
                            save_number = slot_index;
                            obj_cursor.image_alpha = 0;
                            splash = choose(0, 1, 2, 3, 4);
                            with (obj_new_button) {
                                instance_destroy();
                            }
                            with (obj_ingame_menu) {
                                instance_destroy();
                            }
                            // Other here
                            alarm[0] = 1;
                        }
                    }
                }
            }

            slot_index += 1;
            slot_top += 158;
        }

        // 32,166
    }
}
