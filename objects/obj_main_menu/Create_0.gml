fade_alpha = (global.returned > 0) ? 0 : 1.0;
title_alpha = 0;
cooldown = 0;

audio_stop_all();
var target_vol = 0.5 * global.settings.master_volume * global.settings.music_volume;
global.current_music = audio_play_sound(snd_prologue, 10, true, target_vol * 0.4);
audio_sound_gain(global.current_music, target_vol, (global.returned > 0) ? 0 : 1000);

if (instance_exists(obj_cursor)) {
    obj_cursor.image_alpha = (global.returned > 0) ? 1 : 0;
}
