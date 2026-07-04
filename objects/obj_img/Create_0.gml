// should end up a struct of arrays,
// e.g.
/* 
img_cache: {
    "creation/chapters": [somesprite1, somesprite2, ...];
}
 */
LOGGER.debug("obj_img spawned");

image_cache = {};

var _array_size = 301;

creation = array_create(_array_size, 0);
main = array_create(_array_size, 0);
existing = array_create(_array_size, 0);
others = array_create(_array_size, 0);
advisor = array_create(_array_size, 0);
diplomacy_splash = array_create(_array_size, 0);
diplomacy_daemon = array_create(_array_size, 0);
menu = array_create(_array_size, 0);
loading = array_create(_array_size, 0);
postbattle = array_create(_array_size, 0);
postspace = array_create(_array_size, 0);
formation = array_create(_array_size, 0);
popup = array_create(_array_size, 0);
commander = array_create(_array_size, 0);
planet_good = array_create(_array_size, 0);
attacked = array_create(_array_size, 0);
force = array_create(_array_size, 0);
purge = array_create(_array_size, 0);
purge_exists = array_create(_array_size, 0);
event = array_create(_array_size, 0);
event_exists = array_create(_array_size, 0);
title_splash = array_create(_array_size, 0);
title_splash_exists = array_create(_array_size, 0);
symbol = array_create(_array_size, 0);
symbol_exists = array_create(_array_size, 0);
defeat = array_create(_array_size, 0);
defeat_exists = array_create(_array_size, 0);
slate = array_create(_array_size, 0);
slate_exists = array_create(_array_size, 0);

creation_exists = array_create(_array_size, -1);
main_exists = array_create(_array_size, -1);
existing_exists = array_create(_array_size, -1);
others_exists = array_create(_array_size, -1);
advisor_exists = array_create(_array_size, -1);
diplomacy_splash_exists = array_create(_array_size, -1);
diplomacy_daemon_exists = array_create(_array_size, -1);
diplomacy_icon = array_create(_array_size, -1);
diplomacy_icon_exists = array_create(_array_size, -1);
menu_exists = array_create(_array_size, -1);
loading_exists = array_create(_array_size, -1);
postbattle_exists = array_create(_array_size, -1);
postspace_exists = array_create(_array_size, -1);
formation_exists = array_create(_array_size, -1);
popup_exists = array_create(_array_size, -1);
commander_exists = array_create(_array_size, -1);
planet_exists = array_create(_array_size, -1);
attacked_exists = array_create(_array_size, -1);
force_exists = array_create(_array_size, -1);

creation_good = false;
splash_good = false;
advisor_good = false;
diplomacy_splash_good = false;
diplomacy_daemon_good = false;
diplomacy_icon_good = false;
menu_good = false;
loading_good = false;
postbattle_good = false;
postspace_good = false;
formation_good = false;
popup_good = false;
commander_good = false;
planet_good = false;
attacked_good = false;
force_good = false;
purge_good = false;
event_good = false;
title_splash_good = false;

symbol_good = false;
defeat_good = false;
slate_good = false;

// End Image Replacer
// Start Text Replacer
scr_image("force", -50, 0, 0, 0, 0);
