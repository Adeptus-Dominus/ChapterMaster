if (fade > 0) {
    fade += -1;
}
if (goodbye > 0) {
    fadeout += 1;
}

if (fadeout == 1) {
    global.audio_manager.stop_music(2000);
}

if (fadeout == 60) {
    game_restart();
}
