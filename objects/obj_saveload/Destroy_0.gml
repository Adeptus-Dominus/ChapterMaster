scr_image("loading", -666, 0, 0, 0, 0);

if ((!audio_is_playing(snd_royal)) && instance_exists(obj_controller)) {
    audio_play_sound(snd_royal, 0, true);
    audio_sound_gain(snd_royal, 1, 5000);
}
