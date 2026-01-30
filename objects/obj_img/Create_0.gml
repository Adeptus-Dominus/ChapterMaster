// should end up a struct of arrays,
// e.g.
/* 
img_cache: {
    "creation/chapters": [somesprite1, somesprite2, ...];
}
 */
global.logger.debug("obj_img spawned");

image_cache = {};

var i;
i = -1;
repeat (301) {
    i += 1;
    creation[i] = 0;
    creation_exists[i] = -1;
    main[i] = 0;
    main_exists[i] = -1;
    existing[i] = 0;
    existing_exists[i] = -1;
    others[i] = 0;
    others_exists[i] = -1;
    advisor[i] = 0;
    advisor_exists[i] = -1;
    diplomacy_splash[i] = 0;
    diplomacy_splash_exists[i] = -1;
    diplomacy_daemon[i] = 0;
    diplomacy_daemon_exists[i] = -1;
    diplomacy_icon[i] = -1;
    diplomacy_icon_exists[i] = -1;
    menu[i] = 0;
    menu_exists[i] = -1;
    loading[i] = 0;
    loading_exists[i] = -1;
    postbattle[i] = 0;
    postbattle_exists[i] = -1;
    postspace[i] = 0;
    postspace_exists[i] = -1;
    formation[i] = 0;
    formation_exists[i] = -1;
    popup[i] = 0;
    popup_exists[i] = -1;
    commander[i] = 0;
    commander_exists[i] = -1;
    planet_good[i] = 0;
    planet_exists[i] = -1;
    attacked[i] = 0;
    attacked_exists[i] = -1;
    force[i] = 0;
    force_exists[i] = -1;
    purge[i] = 0;
    purge_exists[i] = 0;
    event[i] = 0;
    event_exists[i] = 0;
    title_splash[i] = 0;
    title_splash_exists[i] = 0;

    symbol[i] = 0;
    symbol_exists[i] = 0;
    defeat[i] = 0;
    defeat_exists[i] = 0;
    slate[i] = 0;
    slate_exists[i] = 0;
}

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
