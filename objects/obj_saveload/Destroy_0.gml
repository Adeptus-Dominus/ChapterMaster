scr_image("loading",-666,0,0,0,0);

if (!audio_is_playing(snd_royal)) and (instance_exists(obj_controller)){
    audio_play_sound(snd_royal,0,1);audio_sound_gain(snd_royal,0,0);
    
    var nope;nope=0;
    if (obj_controller.master_volume=0) or (obj_controller.music_volume=0) then nope=1;
    if (nope!=1){audio_sound_gain(snd_royal,0.25*obj_controller.master_volume*obj_controller.music_volume,2000);}
}
