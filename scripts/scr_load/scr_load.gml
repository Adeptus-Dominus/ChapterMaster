function scr_load(save_part, save_id) {
    var t1 = get_timer();
    var filename = string(PATH_SAVE_FILES, save_id);
    var json_game_save = {};
    if (save_id == 0) {
        filename = string(PATH_AUTOSAVE_FILE);
        LOGGER.info("Loading from Autosave");
    }
    if (file_exists(filename)) {
        var _gamesave_buffer = buffer_load(filename);
        var _gamesave_string = buffer_read(_gamesave_buffer, buffer_string);
        buffer_delete(_gamesave_buffer);
        json_game_save = json_parse(_gamesave_string);
    }

    if (!struct_exists(obj_saveload.GameSave, "Save")) {
        obj_saveload.GameSave = json_game_save;
    }

    if ((save_part == 1) || (save_part == 0)) {
        LOGGER.info("Loading GLOBALS");
        // Globals
        var globals = obj_saveload.GameSave.Save;
        scr_load_chapter_icon(globals.icon_name, true);
        global.chapter_name = globals.chapter_name;
        global.custom = globals.custom;
        global.game_seed = globals.game_seed;
    }

    if ((save_part == 2) || (save_part == 0)) {
        LOGGER.info("Loading STARS");

        // Stars
        var star_array = obj_saveload.GameSave.Stars;
        for (var i = 0; i < array_length(star_array); i++) {
            var star_save_data = star_array[i];
            var star_instance = instance_create(0, 0, obj_star);
            with (star_instance) {
                deserialize(star_save_data);
            }
        }
    }

    if ((save_part == 3) || (save_part == 0)) {
        LOGGER.info("Loading INI");
        // Ini
        var ini_save_data = obj_saveload.GameSave.Ini;
        obj_ini.deserialize(ini_save_data);
        LOGGER.info("INI loaded");

        // Controller
        LOGGER.info("Loading CONTROLLER");
        var save_data = obj_saveload.GameSave.Controller;
        /// for some reason, obj_controller having it's deserialize as part of
        /// the object doesnt want to work
        with (obj_controller) {
            var exclusions = [
                "specialist_point_handler",
                "location_viewer",
                "id",
                "techs",
                "apoths",
                "forge_queue",
                "point_breakdown",
                "apothecary_points",
                "forge_points",
                "chapter_master_data",
            ]; // skip automatic setting of certain vars, handle explicitly later

            // Automatic var setting
            var all_names = struct_get_names(save_data);
            var _len = array_length(all_names);
            for (var i = 0; i < _len; i++) {
                var var_name = all_names[i];
                if (array_contains(exclusions, var_name)) {
                    continue;
                }
                var loaded_value = struct_get(save_data, var_name);
                try {
                    variable_instance_set(obj_controller, var_name, loaded_value);
                } catch (e) {
                    LOGGER.debug(e);
                }
            }
            specialist_point_handler = new SpecialistPointHandler();
            // Transfer properties from save data to handler with null-checking
            var properties = ["forge_queue"];
            for (var i = 0; i < array_length(properties); i++) {
                var prop = properties[i];
                if (struct_exists(save_data, prop)) {
                    variable_struct_set(specialist_point_handler, prop, variable_struct_get(save_data, prop));
                }
            }
            chapter_master = new scr_chapter_master();
            if (struct_exists(save_data, "chapter_master_data")) {
                var _data = variable_struct_get(save_data, "chapter_master_data");
                with (chapter_master) {
                    move_data_to_current_scope(_data, true);
                }
            }

            specialist_point_handler.calculate_research_points();
            location_viewer = new UnitQuickFindPanel();
            scr_colors_initialize();
            scr_shader_initialize();
            armamentarium = new Armamentarium(self);

            global.star_name_colors[1] = make_color_rgb(col_r[main_color], col_g[main_color], col_b[main_color]);
        }
        LOGGER.info("CONTROLLER loaded");
    }

    if ((save_part == 4) || (save_part == 0)) {
        LOGGER.info("Loading PLAYER FLEET OBJECTS"); // PLAYER FLEET OBJECTS
        var p_fleet = obj_saveload.GameSave.PlayerFleet;
        for (var i = 0; i < array_length(p_fleet); i++) {
            var deserialized = p_fleet[i];
            var p_fleet_instance = instance_create(0, 0, obj_p_fleet);
            with (p_fleet_instance) {
                deserialize(deserialized);
            }
        }
        LOGGER.info("PLAYER FLEET OBJECTS loaded");
    }

    if ((save_part == 5) || (save_part == 0)) {
        LOGGER.info("Loading ENEMY FLEET OBJECTS");

        var en_fleet = obj_saveload.GameSave.EnemyFleet;
        for (var i = 0; i < array_length(en_fleet); i++) {
            var deserialized = en_fleet[i];
            var en_fleet_instance = instance_create(0, 0, obj_en_fleet);
            with (en_fleet_instance) {
                deserialize(deserialized);
            }
        }
        LOGGER.info("ENEMY FLEET OBJECTS loaded");

        // All fleets exist now so recalculate star presence for player and enemy fleets together.
        recalculate_fleet_presence();

        LOGGER.info("Loading EVENT LOG");
        if (!instance_exists(obj_event_log)) {
            instance_create(0, 0, obj_event_log);
        }
        instance_activate_object(obj_event_log);
        obj_event_log.event = obj_saveload.GameSave.EventLog;
        LOGGER.info("EVENT LOG Loaded");

        // Sanitize NaN coordinates baked into older saves. A fleet whose x/y went NaN
        // (from the pre-fix action_eta divide-by-zero) keeps re-baking that NaN into
        // obj_controller through the fleet-focus copy, which then crashes the collision
        // grid when obj_cursor is recreated on a room change. Snap any broken instance
        // back to a valid star so the bad value can never reach the controller again.
        var _anchor = instance_nearest(0, 0, obj_star);
        var _ax = instance_exists(_anchor) ? _anchor.x : 0;
        var _ay = instance_exists(_anchor) ? _anchor.y : 0;
        with (obj_p_fleet) {
            if (is_nan(x) || is_nan(y)) {
                x = _ax;
                y = _ay;
            }
        }
        with (obj_en_fleet) {
            if (is_nan(x) || is_nan(y)) {
                x = _ax;
                y = _ay;
            }
        }
        if (is_nan(obj_controller.x) || is_nan(obj_controller.y)) {
            obj_controller.x = _ax;
            obj_controller.y = _ay;
        }

        obj_saveload.alarm[1] = 5;
        obj_controller.invis = false;
        global.load = -1;
        scr_image("force", -50, 0, 0, 0, 0);
        LOGGER.info("Loading completed");
    }

    var t2 = get_timer();
    var diff = (t2 - t1) / 1000000;
    LOGGER.info($"Loading part {save_part} took {diff} seconds!");
}
