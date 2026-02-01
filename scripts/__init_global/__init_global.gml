// This will execute before the first room of the game executes.
gml_pragma("global", "__init_global()");

function __init_global() {
    // set any global defaults
    layer_force_draw_depth(true, 0); // force all layers to draw at depth 0
    draw_set_colour(c_black);

    initialize_marine_traits();

    initialize_dialogue();

    var _log_file = file_text_open_write(PATH_last_messages);
    if (_log_file != -1) {
        file_text_write_string(_log_file, $"--- Log Started: {date_datetime_string(date_current_datetime())} ---\n");
        file_text_close(_log_file);
    }

    global.logger = new Logger();
    global.logger.active_level = (code_is_compiled()) ? eLOG_LEVEL.WARNING : eLOG_LEVEL.DEBUG;

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
        "Runic"
    ];

    try {
        load_visual_sets();
    } catch (_exception) {
        handle_exception(_exception);
    }
    global.chapter_name = "None";
    global.game_seed = 0;
    global.ui_click_lock = false;
    global.name_generator = new NameGenerator();
    global.star_sprites = ds_map_create();
    global.base_component_surface = -1;
}
