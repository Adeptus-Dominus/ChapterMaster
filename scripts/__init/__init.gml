#macro PATH_SAVE_FILES "Save Files/save{0}.json"
#macro PATH_AUTOSAVE_FILE "Save Files/save0.json"
#macro PATH_CUSTOM_ICONS "Custom Files/Custom Icons/"
#macro PATH_CHAPTER_ICONS working_directory + "/images/creation/chapters/icons/"
#macro PATH_INCLUDED_ICONS working_directory + "/images/creation/customicons/"
#macro PATH_LOG_DIRECTORY "Logs/"
#macro LAST_MESSAGES_LOG "last_messages.log"
#macro PATH_LAST_MESSAGES PATH_LOG_DIRECTORY + LAST_MESSAGES_LOG
#macro PATH_HELP_INI "main/help.ini"

/// @desc Called via gml_pragma("global") at startup, before any room.
function __init() {
    global.error_handler = new ErrorHandler();

    global.logger = new Logger();
    global.logger.active_level = (code_is_compiled()) ? eLOG_LEVEL.WARNING : eLOG_LEVEL.DEBUG;

    global.update_checker = new UpdateChecker();

    // Delete leftover files from old versions;
    // Remove these lines after a couple of months;
    // ========================
    if (directory_exists("ErrorLogs")) {
        directory_destroy("ErrorLogs");
    }
    if (file_exists("debug_log.ini")) {
        file_delete("debug_log.ini");
    }
    if (file_exists("message_log.log")) {
        file_delete("message_log.log");
    }
    // ========================

    if (!directory_exists("Logs")) {
        directory_create("Logs");
    }
    if (!directory_exists("Custom Files/Custom Icons")) {
        directory_create("Custom Files/Custom Icons");
    }
    if (!directory_exists("Save Files")) {
        directory_create("Save Files");
    }

    global.chapter_icons_map = ds_map_create();

    var _icon_paths = [
        PATH_CHAPTER_ICONS,
        PATH_INCLUDED_ICONS,
        PATH_CUSTOM_ICONS,
    ];
    for (var i = 0; i < array_length(_icon_paths); i++) {
        var _file_wildcard = _icon_paths[i] + "*.png";
        var _file = file_find_first(_file_wildcard, fa_none);
        while (_file != "") {
            var _file_path = _icon_paths[i] + _file;
            var _sprite = sprite_add(_file_path, 1, false, true, 0, 0);
            var _icon_name = string_delete(_file, string_length(_file) - 3, 4);
            if (ds_map_exists(global.chapter_icons_map, _icon_name)) {
                sprite_delete(global.chapter_icons_map[? _icon_name]);
                LOGGER.info($"A duplicate {_icon_name} icon replaced another existing one with the same name!");
            }
            ds_map_replace(global.chapter_icons_map, _icon_name, _sprite);
            _file = file_find_next();
        }
        file_find_close();
    }

    global.chapter_icons_array = ds_map_keys_to_array(global.chapter_icons_map);
    array_sort(global.chapter_icons_array, true);

    global.chapter_icon = {
        // sprite filename, without the extension
        name: "unknown",
        /// the sprite id once loaded from file
        sprite: global.chapter_icons_map[? "unknown"],
    };

    if (!sprite_exists(global.chapter_icon.sprite)) {
        LOGGER.error("'unknown' chapter icon not found in any icon directory. Chapter icon will not render.");
    }

    global.build_date = "unknown build";
    global.game_version = "unknown version";
    global.commit_hash = "unknown hash";

    var _version_file_path = working_directory + "/main/version.json";
    var _parsed_json = json_to_gamemaker(_version_file_path, json_parse);

    if (_parsed_json != undefined) {
        var _build_date = _parsed_json[$ "build_date"];
        var _version = _parsed_json[$ "version"];
        var _commit_hash = _parsed_json[$ "commit_hash"];

        if (string_char_at(_version, 1) != "v") {
            if (string_count("compile-", _version) > 0 || string_count("release-", _version) > 0) {
                var _format_version = string_delete(_version, 1, 8);
                var _parts = string_split(_format_version, ".");
                _format_version = _parts[0] + "." + _parts[1];
                _version = _format_version;
            }
        } else {
            _version = string_delete(_version, 1, 1);
        }

        global.build_date = _build_date;
        global.game_version = _version;
        global.commit_hash = _commit_hash;
    }

    if (global.game_version != "compiled") {
        global.update_checker.check();
    } else {
        global.update_checker.compiled = true;
    }

    global.weapons = json_to_gamemaker(working_directory + "/data/weapons.json", json_parse);
    global.gear = {
        "armour": json_to_gamemaker(working_directory + "/data/armour.json", json_parse),
        "gear": json_to_gamemaker(working_directory + "/data/gear.json", json_parse),
        "mobility": json_to_gamemaker(working_directory + "/data/mobility.json", json_parse),
    };
    global.vehicles = json_to_gamemaker(working_directory + "/data/vehicles.json", json_parse);
    global.vehicle_gear = json_to_gamemaker(working_directory + "/data/vehicle_gear.json", json_parse);
    global.ships = json_to_gamemaker(working_directory + "/data/ships.json", json_parse);
    global.technologies = json_to_gamemaker(working_directory + "/data/technologies.json", json_parse);

    global.base_stats = json_to_gamemaker(working_directory + "/data/unit_stats.json", json_parse);

    layer_force_draw_depth(true, 0); // force all layers to draw at depth 0
    draw_set_colour(c_black);

    initialize_marine_traits();

    initialize_dialogue();

    var _log_file = file_text_open_write(PATH_LAST_MESSAGES);
    if (_log_file != -1) {
        file_text_write_string(_log_file, $"--- Log Started: {date_datetime_string(date_current_datetime())} ---\n");
        file_text_close(_log_file);
    }

    global.culture_styles = [
        "Greek",
        "Roman",
        "Knightly",
        "Gladiator",
        "Mongol",
        "Feral",
        "Flame Cult",
        "Mechanical Cult",
        "Prussian",
        "Cthonian",
        "Alpha",
        "Ultra",
        "Renaissance",
        "Blood",
        "Angelic",
        "Crusader",
        "Gothic",
        "Wolf Cult",
        "Runic",
    ];

    try {
        load_visual_sets();
    } catch (_exception) {
        global.error_handler.handle_exception(_exception);
    }

    global.chapter_name = "None";
    global.game_seed = 0;
    global.ui_click_lock = false;
    global.name_generator = new NameGenerator();
    global.star_sprites = ds_map_create();
    global.base_component_surface = -1;

    global.force_strength_descriptions = [
        "None",
        "Minimal",
        "Sparse",
        "Moderate",
        "Numerous",
        "Very Numerous",
        "Overwhelming",
    ];

    global.star_name_colors = [
        c_gray,
        c_white, // Player
        #7a7a7a, // Imperium
        #B22222, // Mechanicus
        c_white, // Inquisition
        c_white, // Ecclesiarchy
        #FF8000, // Eldar
        #009500, // Orks
        #FECB01, // Tau
        #AD5272, // Tyranids
        c_dkgray, // Chaos
        c_dkgray, // Heretics
        #AD5272, // why 12 is skipped in general, we will never know
        #80FF00, // Necrons
    ];
}
