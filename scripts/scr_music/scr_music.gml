function scr_music(argument0, argument1) {
    // argument0: target sound
    // argument1: wait timer

    if (real(global.sound_playing) != 0) {
        audio_sound_gain(global.sound_playing, 0, 2000);
    }
    if (real(global.sound_playing) == 0) {
        if (audio_is_playing(snd_blood)) {
            audio_sound_gain(snd_blood, 0, 2000);
        }
        if (audio_is_playing(snd_royal)) {
            audio_sound_gain(snd_royal, 0, 2000);
        }
    }

    obj_controller.sound_to = string(argument0);
    obj_controller.sound_in = round(argument1 / 33);
}
