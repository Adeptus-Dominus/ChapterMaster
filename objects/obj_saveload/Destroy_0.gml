scr_image("loading", -666, 0, 0, 0, 0);

if (instance_exists(obj_controller)) {
    global.audio_manager.play_playlist(CONTEXT_SECTOR, 5000);
}
