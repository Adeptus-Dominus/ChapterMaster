// Player defeat screen
global.logger.info("Player Defeated; Exited to Defeat Screen");

audio_stop_sound(snd_royal);
audio_play_sound(snd_defeat, 0, true);
audio_sound_gain(snd_defeat, 0, 0);

var nope = false;
if ((master_volume == 0) || (music_volume == 0)) {
    nope = true;
}
if (!nope) {
    audio_sound_gain(snd_defeat, 1 * master_volume * music_volume, 2000);
}

if ((obj_controller.marines + obj_controller.command <= 50) && (global.defeat != 2)) {
    global.defeat = 0;
}

room_goto(Defeat);
