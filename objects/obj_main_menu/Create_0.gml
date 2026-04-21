fade_alpha = (global.returned > 0) ? 0 : 1.0;
title_alpha = 0;
cooldown = 0;

audio_stop_all();
global.current_music = audio_play_sound(snd_prologue, 10, true, 0.1);
audio_sound_gain(global.current_music, 1, (global.returned > 0) ? 0 : 5000);

if (instance_exists(obj_cursor)) {
    obj_cursor.image_alpha = (global.returned > 0) ? 1 : 0;
}
