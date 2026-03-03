// Player defeat screen
LOGGER.info("Player Defeated; Exited to Defeat Screen");

audio_stop_sound(snd_royal);
audio_play_sound(snd_defeat, 0, true, 0.1);
audio_sound_gain(snd_defeat, 1, 5000);

if ((obj_controller.marines + obj_controller.command <= 50) && (global.defeat != 2)) {
    global.defeat = 0;
}

room_goto(rm_defeat);
