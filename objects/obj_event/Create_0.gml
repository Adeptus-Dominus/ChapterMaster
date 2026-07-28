fading = 1;
fade_alpha = 0;
textt = "";
time_min = 0;
lines_acted = 0;
liness = 0;
time_at = 0;
time_min = 0;
time_max = 100;
part2 = "";
part3 = "";
exit_fade = -1;
closing = false;

attendants = 0;
avatars = 0;

var _array_size = 2501;

attend_co = array_create(_array_size, 0);
attend_id = array_create(_array_size, 0);
attend_mood = array_create(_array_size, "");
attend_corrupted = array_create(_array_size, 0);
attend_feasted = array_create(_array_size, 0);
attend_drunk = array_create(_array_size, 0);
attend_high = array_create(_array_size, 0);
attend_confused = array_create(_array_size, 0);
attend_actioned = array_create(_array_size, 0);
attend_corruption = array_create(_array_size, 0);
attend_race = array_create(_array_size, 0);
attend_displayed = array_create(_array_size, 0);

avatar_name = array_create(_array_size, "");
avatar_rank = array_create(_array_size, "");
avatar_image = array_create(_array_size, 0);
avatar_co = array_create(_array_size, 0);
avatar_id = array_create(_array_size, 0);

line = array_create(_array_size, "");

lines = 0;

main_color = obj_ini.main_color;
secondary_color = obj_ini.secondary_color;
main_trim = obj_ini.main_trim;
left_pauldron = obj_ini.left_pauldron;
right_pauldron = obj_ini.right_pauldron;
lens_color = obj_ini.lens_color;
weapon_color = obj_ini.weapon_color;
col_special = obj_ini.col_special;
trim = obj_ini.trim;

stage = 5;
ticks = -120;
ticked = 0;
next_display = 90;
total_displayed = 0;

scr_colors_initialize();
scr_shader_initialize();

if (obj_controller.fest_display > 0) {
    if (obj_ini.artifact_tags[obj_controller.fest_display] != obj_controller.fest_display_tags) {
        obj_controller.fest_display = 0;
        for (var q = 1; q <= 20; q++) {
            if (obj_ini.artifact_tags[q] == obj_controller.fest_display_tags) {
                obj_controller.fest_display = q;
                break;
            }
        }
    }
}
