if (click > 0) {
    click = -1;
    audio_play_sound(snd_click, -100, 0);
    audio_sound_gain(snd_click, 0.25 * obj_controller.master_volume * obj_controller.effect_volume, 0);
}
if (click2 > 0) {
    click2 = -1;
    audio_play_sound(snd_click, -100, 0);
    audio_sound_gain(snd_click, 0.25 * obj_controller.master_volume * obj_controller.effect_volume, 0);
}

hover = 0;
var i, xx, yy, x2, y2;
i = 0;
xx = camera_get_view_x(view_camera[0]) + 0;
yy = camera_get_view_y(view_camera[0]) + 0;

if (construction_started > 0) {
    construction_started -= 1;
}

/* */
/*  */
