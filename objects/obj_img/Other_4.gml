if (room_get_name(room) == "Creation") {
    if ((creation_good == false) && (splash_good == false)) {
        scr_image("creation", -50, 0, 0, 0, 0);
        scr_image("main_splash", -50, 0, 0, 0, 0);
        scr_image("existing_splash", -50, 0, 0, 0, 0);
        scr_image("other_splash", -50, 0, 0, 0, 0);
    }
}
