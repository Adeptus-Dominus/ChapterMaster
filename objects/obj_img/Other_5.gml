if (room_get_name(room) == "Creation") {
    if ((creation_good == false) && (splash_good == false)) {
        scr_image("creation", -666, 0, 0, 0, 0);
        scr_image("main_splash", -666, 0, 0, 0, 0);
        scr_image("existing_splash", -666, 0, 0, 0, 0);
        scr_image("other_splash", -666, 0, 0, 0, 0);
    }
}

if (room_get_name(room) == "Game") {
    scr_image("all", -666, 0, 0, 0, 0);
}
