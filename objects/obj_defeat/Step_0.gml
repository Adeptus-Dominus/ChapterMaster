action_set_relative(1);
var __b__;
__b__ = action_if_variable(fade, 0, 2);
if __b__
{
fade -= global.frame_timings.t1;
}
__b__ = action_if_variable(goodbye, 0, 2);
if __b__
{
fadeout += global.frame_timings.t1;
}

if (fadeout == 1) {
    audio_sound_gain(snd_defeat,0,2000);
}

if (fadeout == 60) {
    game_restart();
}

action_set_relative(0);
