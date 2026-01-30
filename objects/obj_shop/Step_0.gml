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
xx = __view_get(e__VW.XView, 0) + 0;
yy = __view_get(e__VW.YView, 0) + 0;

if (construction_started > 0) {
    construction_started -= 1;
}

/* */
/*  */
