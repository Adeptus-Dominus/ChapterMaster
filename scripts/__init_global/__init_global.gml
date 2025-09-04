// This will execute before the first room of the game executes.
gml_pragma("global", "__init_global()");

function __init_global() {
    // set any global defaults
    layer_force_draw_depth(true, 0); // force all layers to draw at depth 0
    draw_set_colour(c_black);

    initialize_marine_traits();

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

    global.chapter_name = "None";
    global.game_seed = 0;
    global.ui_click_lock = false;
    global.name_generator = new NameGenerator();
    global.star_sprites = ds_map_create();
}
