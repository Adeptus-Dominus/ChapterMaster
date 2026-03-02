scr_image("loading", -666, 0, 0, 0, 0);

if ((!audio_is_playing(snd_royal)) && instance_exists(obj_controller)) {
    audio_play_sound(snd_royal, 0, 1);
    audio_sound_gain(snd_royal, 0, 0);

    var nope;
    nope = 0;
    if ((global.settings.master_volume == 0) || (global.settings.music_volume == 0)) {
        nope = 1;
    }
    if (nope != 1) {
        audio_sound_gain(snd_royal, 0.25 * global.settings.master_volume * global.settings.music_volume, 2000);
    }
}
