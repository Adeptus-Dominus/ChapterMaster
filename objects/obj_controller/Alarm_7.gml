// Player defeat screen
LOGGER.info("Player Defeated; Exited to Defeat Screen");

global.audio_manager.play_playlist(CONTEXT_DEFEAT, 5000);

if ((marines + command <= 50) && (global.defeat != 2)) {
    global.defeat = 0;
}

room_goto(rm_defeat);
