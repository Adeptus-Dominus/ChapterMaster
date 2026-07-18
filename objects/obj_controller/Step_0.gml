try {
    // Handles most logic for main menus, audio and checks if cheats are enabled
    // TODO refactor will wait untill squads PR (#76) is merged
    if ((menu == eMENU.DEFAULT || menu == eMENU.TURN_END) && zoomed == 0 && !instances_exist_any([obj_ingame_menu, obj_ncombat])) {
        scr_zoom_keys();
    }
    if (double_click >= 0) {
        double_click -= 1;
    }
    if (text_bar > 0) {
        text_bar += 1;
        if ((menu == eMENU.MANAGE) && (managing > 0)) {
            obj_ini.company_title[managing] = keyboard_string;
        }
        if ((menu == eMENU.FORMATIONS_SETTINGS) && (formating > 0) && (formating > 3)) {
            bat_formation[formating] = keyboard_string;
        }
    }
    if (text_bar > 60) {
        text_bar = 1;
    }
    if (bar_fix) {
        bar_fix = false;
        scr_ui_formation_bars();
    }
    // TODO change this into a constructor which is in a separated script
    if ((fest_scheduled == 0) && (fest_sid + fest_wid > 0) && (menu != eMENU.FESTIVAL)) {
        fest_sid = 0;
        fest_wid = 0;
        fest_planet = 0;
        fest_type = "";
        fest_cost = 0;
        fest_lav = 0;
        fest_locals = 0;
        fest_feature1 = 0;
        fest_feature2 = 0;
        fest_feature3 = 0;
        fest_display = 0;
        fest_repeats = 0;
        fest_honor_co = 0;
        fest_honor_id = 0;
        fest_attend = "";
    }

    if ((menu != eMENU.FORMATIONS_SETTINGS) && (formating > 0)) {
        formating = 0;
    }

    if (instance_exists(obj_formation_bar) && ((menu != eMENU.FORMATIONS_SETTINGS) || (formating <= 0))) {
        with (obj_formation_bar) {
            instance_destroy();
        }
        with (obj_temp8) {
            instance_destroy();
        }
        formating = 0;
    }
    // Sounds
    if (sound_in >= 0) {
        sound_in -= 1;
    }
    if ((sound_in == 0) && (sound_to != "")) {
        audio_stop_all();
        var nope = false;
        if (sound_to == "blood") {
            global.sound_playing = audio_play_sound(snd_blood, 0, true);
            audio_sound_gain(global.sound_playing, 1, 5000);
        }
        if (sound_to == "royal") {
            global.sound_playing = audio_play_sound(snd_royal, 0, true);
            audio_sound_gain(global.sound_playing, 1, 5000);
        }
    }
    // Cheat codes
    if (cheatcode != "") {
        cheatyface = 1;
    }
    if (cheatcode == "req" && !global.cheat_req) {
        global.cheat_req = true;
        tempRequisition = requisition;
        requisition = 51234;
    } else if (cheatcode == "req" && global.cheat_req) {
        global.cheat_req = false;
        requisition = tempRequisition;
    }
    if (cheatcode == "seed" && !global.cheat_gene) {
        global.cheat_gene = true;
        tempGene_seed = gene_seed;
        gene_seed = 9999;
    } else if (cheatcode == "seed" && global.cheat_gene) {
        global.cheat_gene = false;
        gene_seed = tempGene_seed;
    }
    if (cheatcode == "dep") {
        global.cheat_disp = true;
        for (var i = 2; i <= 10; i++) {
            disposition[i] = 100;
        }
    }
    if (cheatcode == "debug" && !global.cheat_debug) {
        global.cheat_debug = true;
    } else if (cheatcode == "debug" && global.cheat_debug) {
        global.cheat_debug = false;
    }
    if (cheatcode == "test") {
        diplomacy = 10.5;
        scr_dialogue("test");
    }
    if (global.cheat_req && requisition != 51234) {
        requisition = 51234;
    }
    cheatcode = "";
    if (!instance_exists(obj_event_log)) {
        instance_activate_object(obj_event_log);
    }
    if (instance_exists(obj_event_log) && menu != eMENU.GAME_HELP) {
        obj_event_log.help = 0;
    }
    if (!instance_exists(obj_ingame_menu)) {
        play_second += 1;
        if (play_second >= 30) {
            play_second = 0;
            play_time += 1;
        }
    }
    // Nope // Cleans up menu
    if ((menu != eMENU.SECRET_LAIR) && instance_exists(obj_temp_build)) {
        if (obj_temp_build.isnew) {
            menu = eMENU.SECRET_LAIR;
        }
        with (obj_managment_panel) {
            instance_destroy();
        }
        with (obj_drop_select) {
            instance_destroy();
        }
        with (obj_star_select) {
            instance_destroy();
        }
        with (obj_fleet_select) {
            instance_destroy();
        }
    }
    // Return to star selection
    if ((menu == eMENU.DEFAULT) && instance_exists(obj_temp_build)) {
        selecting_planet = obj_temp_build.planet;
        // Pass variables to temp[t]=""; here
        instance_create(obj_temp_build.x, obj_temp_build.y, obj_star_select);
        obj_star_select.loading_name = selected.name;
        popup = 3;
        with (obj_temp_build) {
            instance_destroy();
        }
    }
    // REMOVE
    if ((menu != eMENU.SECRET_LAIR) && instance_exists(obj_temp_build)) {
        with (obj_temp_build) {
            instance_destroy();
        }
    }

    if ((text_selected != "") && (text_selected != "none")) {
        text_bar += 1;
    }
    if (text_bar > 60) {
        text_bar = 1;
    }

    if ((disposition[4] <= 20) || (loyalty <= 33) && (demanding == 0)) {
        demanding = 1;
    }
    if ((disposition[4] > 20) && (loyalty > 33) && (demanding == 1)) {
        demanding = 0;
    }

    main_map_move_keys();

    // For testing purposes
    if (is_test_map == true) {
        with (obj_en_fleet) {
            if (owner == eFACTION.IMPERIUM) {
                capital_number = 0;
                frigate_number = 1;
                escort_number = 2;
            }
        }
    }
    // Menu selection screens
    var freq = 150;
    if (l_options > 0) {
        l_options += 1;
    }
    if (l_options > 105) {
        l_options = 0;
    }
    if ((l_options == 0) && (floor(random(freq)) == 3)) {
        l_options = 1;
    }
    if (l_menu > 0) {
        l_menu += 1;
    }
    if (l_menu > 105) {
        l_menu = 0;
    }
    if ((l_menu == 0) && (floor(random(freq)) == 3)) {
        l_menu = 1;
    }

    if (l_manage > 0) {
        l_manage += 1;
    }
    if (l_manage > 141) {
        l_manage = 0;
    }
    if ((l_manage == 0) && (floor(random(freq)) == 3)) {
        l_manage = 1;
    }
    if (l_settings > 0) {
        l_settings += 1;
    }
    if (l_settings > 141) {
        l_settings = 0;
    }
    if ((l_settings == 0) && (floor(random(freq)) == 3)) {
        l_settings = 1;
    }

    if (l_apothecarium > 0) {
        l_apothecarium += 1;
    }
    if (l_apothecarium > 113) {
        l_apothecarium = 0;
    }
    if ((l_apothecarium == 0) && (floor(random(freq)) == 3)) {
        l_apothecarium = 1;
    }
    if (l_reclusium > 0) {
        l_reclusium += 1;
    }
    if (l_reclusium > 113) {
        l_reclusium = 0;
    }
    if ((l_reclusium == 0) && (floor(random(freq)) == 3)) {
        l_reclusium = 1;
    }
    if (l_librarium > 0) {
        l_librarium += 1;
    }
    if (l_librarium > 113) {
        l_librarium = 0;
    }
    if ((l_librarium == 0) && (floor(random(freq)) == 3)) {
        l_librarium = 1;
    }
    if (l_armoury > 0) {
        l_armoury += 1;
    }
    if (l_armoury > 113) {
        l_armoury = 0;
    }
    if ((l_armoury == 0) && (floor(random(freq)) == 3)) {
        l_armoury = 1;
    }
    if (l_recruitment > 0) {
        l_recruitment += 1;
    }
    if (l_recruitment > 113) {
        l_recruitment = 0;
    }
    if ((l_recruitment == 0) && (floor(random(freq)) == 3)) {
        l_recruitment = 1;
    }
    if (l_fleet > 0) {
        l_fleet += 1;
    }
    if (l_fleet > 113) {
        l_fleet = 0;
    }
    if ((l_fleet == 0) && (floor(random(freq)) == 3)) {
        l_fleet = 1;
    }

    if (l_diplomacy > 0) {
        l_diplomacy += 1;
    }
    if (l_diplomacy > 141) {
        l_diplomacy = 0;
    }
    if ((l_diplomacy == 0) && (floor(random(freq)) == 3)) {
        l_diplomacy = 1;
    }
    if (l_log > 0) {
        l_log += 1;
    }
    if (l_log > 141) {
        l_log = 0;
    }
    if ((l_log == 0) && (floor(random(freq)) == 3)) {
        l_log = 1;
    }
    if (l_turn > 0) {
        l_turn += 1;
    }
    if (l_turn > 141) {
        l_turn = 0;
    }
    if ((l_turn == 0) && (floor(random(freq)) == 3)) {
        l_turn = 1;
    }

    if ((new_buttons_hide == 1) && (y_slide < 43)) {
        if (y_slide < 43) {
            y_slide += 2;
        }
        if (new_buttons_frame < 24) {
            new_buttons_frame += 1;
        }
    }
    if ((new_buttons_hide == 0) && (y_slide > 0)) {
        if (y_slide > 0) {
            y_slide -= 2;
        }
        if (new_buttons_frame > 0) {
            new_buttons_frame -= 1;
        }
    }
    if ((new_buttons_hide == 1) && (y_slide < 43)) {
        if (y_slide < 43) {
            y_slide += 2;
        }
        if (new_buttons_frame < 24) {
            new_buttons_frame += 1;
        }
    }
    if ((new_buttons_hide == 0) && (y_slide > 0)) {
        if (y_slide > 0) {
            y_slide -= 2;
        }
        if (new_buttons_frame > 0) {
            new_buttons_frame -= 1;
        }
    }

    if ((new_buttons_hide + hide_banner > 0) && (new_banner_x < 161)) {
        new_banner_x += 161 / 11;
    }
    if ((new_buttons_hide + hide_banner == 0) && (new_banner_x > 0)) {
        new_banner_x -= 161 / 11;
    }

    if (y_slide < 0) {
        y_slide = 0;
    }
    if (new_banner_x < 0) {
        new_banner_x = 0;
    }
    if (y_slide > 0) {
        new_button_highlight = "";
    }
    // Checks which menu was clicked
    var high = "";
    var stop = 0;
    // Which menu is highlighted

    if ((cooldown >= 0) && (cooldown < 9000)) {
        cooldown -= 1;
    }

    if (instance_exists(obj_ingame_menu) || instance_exists(obj_saveload)) {
        exit;
    }
    // Default view

    if (global.load >= 0) {
        exit;
    }
    if (menu == eMENU.DEFAULT) {
        otha = 0;
    }
    // Sound controls
    if (click > 0) {
        click = -1;
        audio_play_sound(snd_click, -80, false);
    }
    if (click2 > 0) {
        click2 = -1;
        audio_play_sound(snd_click_small, -80, 0);
    }
    // Return artifact
    if (qsfx == 1) {
        qsfx = 0;
        scr_quest(0, "artifact_return", 4, turn == 1);
    }
    // Diplomacy options
    if (diplomacy == 0) {
        trading_artifact = 0;
    }

    if ((trading_artifact == 0) && (trading == 0) && (trading_artifact == 0) && (faction_justmet == 1) && (questing == 0) && (trading_demand == 0) && (complex_event == false)) {
        clear_diplo_choices();
    }

    income = income_base + income_home + income_forge + income_agri + income_training + income_fleet + income_trade + income_tribute;

    if ((menu == eMENU.DIPLOMACY) && ((diplomacy > 0) || ((diplomacy < -5) && (diplomacy > -6)))) {
        if (string_length(diplo_txt) < string_length(diplo_text)) {
            diplo_char += 2;
            diplo_txt = string_copy(diplo_text, 0, diplo_char);
        }
        if (diplo_alpha < 1) {
            diplo_alpha += 0.05;
        }
    }
    // Check if fleet is minimized or not
    if (instance_exists(obj_popup)) {
        allow_shortcuts = false;
        if (obj_popup.type == 99) {
            fleet_minimized = 1;
        }
    }
    // Rrepair ships
    if ((menu == eMENU.DEFAULT) && (repair_ships > 0) && (!instance_exists(obj_turn_end)) && (!instance_exists(obj_popup))) {
        repair_ships = 0;

        var pip = instance_create(0, 0, obj_popup);
        pip.title = "Ships Repaired";
        pip.text = "In accordance with the Imperial Repair License, all " + string(obj_ini.chapter_name) + " ships orbiting friendly planets have been repaired. Note that repaired ships, and their fleets, are unable to act further this turn.";
        pip.image = "shipyard";
        pip.cooldown = 15;

        with (obj_p_fleet) {
            if ((capital_health < 100) && (capital_number > 0)) {
                acted = 2;
            }
            if ((frigate_health < 100) && (frigate_number > 0)) {
                acted = 2;
            }
            if ((escort_health < 100) && (escort_number > 0)) {
                acted = 2;
            }
        }
        for (var i = 1; i < array_length(obj_ini.ship); i++) {
            if ((obj_ini.ship_location[i] != "Warp") && (obj_ini.ship_location[i] != "Lost")) {
                obj_ini.ship_hp[i] = obj_ini.ship_maxhp[i];
            }
        }
        // TODO need something here to veryify that the ships are within a friendly star system
    }
    // Unloads units from a ship
    if (unload > 0) {
        cooldown = 8;
        var b = selecting_ship;

        for (var q = 0; q < array_length(display_unit); q++) {
            if ((man[q] == "man") && (ma_loc[q] == selecting_location) && (ma_wid[q] < 1) && (man_sel[q] != 0)) {
                if (b == -1) {
                    b = ma_lid[q];
                }
                var unit = display_unit[q];
                if (!is_struct(unit)) {
                    continue;
                }
                if (unit.name() == "") {
                    continue;
                }
                var unit_id = unit.marine_number;
                var company = unit.company;
                unit.location_string = obj_ini.ship_location[b];
                unit.ship_location = -1;
                unit.planet_location = unload;
                obj_ini.uid[company][unit_id] = 0;

                ma_loc[q] = obj_ini.ship_location[b];
                ma_lid[q] = -1;
                ma_wid[q] = unload;
            } else if ((man[q] == "vehicle") && (ma_loc[q] == selecting_location) && (ma_wid[q] < 1) && (man_sel[q] != 0)) {
                if (b == -1) {
                    b = ma_lid[q];
                }
                var unit_id = display_unit[q][1];
                var company = display_unit[q][0];
                obj_ini.veh_loc[company][unit_id] = obj_ini.ship_location[b];
                obj_ini.veh_lid[company][unit_id] = -1;
                obj_ini.veh_wid[company][unit_id] = unload;
                obj_ini.veh_uid[company][unit_id] = 0;

                ma_loc[q] = obj_ini.ship_location[b];
                ma_lid[q] = -1;
                ma_wid[q] = unload;
            }
        }
        selecting_location = "";
        for (var i = 0; i < array_length(display_unit); i++) {
            man_sel[i] = 0;
        }
        if (b > -1 && b < array_length(obj_ini.ship_carrying)) {
            obj_ini.ship_carrying[b] -= man_size;
        }
        reset_ship_manage_arrays();
        cooldown = 10;
        sel_loading = -1;
        man_size = 0;
        unload = 0;
        with (obj_star_select) {
            instance_destroy();
        }
    }
    // Resets selections
    if ((managing > 0) && (man_size == 0) && ((selecting_location != "") || (selecting_types != "") || instance_exists(selecting_planet) || (selecting_ship != -1))) {
        reset_manage_selections();
    }

    if (menu == eMENU.DEFAULT && !instances_exist_any([obj_ncombat, obj_fleet_controller])) {
        if (!array_contains(obj_ini.role[0], obj_ini.role[100][eROLE.CHAPTERMASTER]) && (alarm[7] == -1)) {
            alarm[7] = 15;
        }
    }
} catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
}
