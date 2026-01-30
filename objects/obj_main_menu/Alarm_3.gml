if (global.returned > 0) {
    stage = 3;
    tim3 = 60;
    audio_stop_all();
    global.sound = audio_play_sound(snd_prologue, 0, true);
    audio_sound_gain(global.sound, 0, 0);

    // var nope;nope=0;if (master_volume=0) or (music_volume=0) then nope=1;
    // if (nope!=1){
    audio_sound_gain(global.sound, 0.5 * master_volume * music_volume, 2000);
    // }
}
