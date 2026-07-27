/// @description Grid combat prototype: self contained state, no campaign reads.

if (instance_number(obj_grid_combat) > 1) {
    instance_destroy();
    exit;
}

depth = -15000;
boot_done = false;

// Battle scale. The cheat can override this before the first Step by setting
// pending_width, so "gridbattle large" and "gridbattle 30" both work.
if (!variable_instance_exists(id, "pending_width")) {
    pending_width = 12;
}
// Real battle context, filled in by the launcher between instance_create and
// the first Step. Empty force means the generated test roster is used instead.
if (!variable_instance_exists(id, "pending_force")) {
    pending_force = [];
}
if (!variable_instance_exists(id, "pending_enemy")) {
    pending_enemy = "orks";
}
if (!variable_instance_exists(id, "pending_loc")) {
    pending_loc = "";
}
if (!variable_instance_exists(id, "pending_live")) {
    pending_live = false;
}
// Campaign threat level (1 to 7). It sizes the enemy force, so it has to match
// the number the after-battle pass spends against the planet.
if (!variable_instance_exists(id, "pending_threat")) {
    pending_threat = 3;
}

phase = GRIDPH_DEPLOY;
result = 0;
ticks = 0;
frame_ctr = 0;
paused = false;
speed_mult = 1;
exit_arm = 0;
waves_left = GRIDC_WAVES;

squads = [];
formations = [];
form_counters = {};
form_color_idx = 0;

cols = 0;
rows = 0;
combat_width = 0;
points = 0;
band_r1 = 0;
band_r2 = 0;
occ = [];
cov = [];

view_x = 0;
view_y = 0;
zoom_mode = 0;

feed = [];
floaters = [];

agg_ekills = 0;
agg_pkills = 0;
total_ekills = 0;
total_pkills = 0;
wiped_e = 0;
wiped_p = 0;

popup_open = false;
popup_type = "";
popup_scroll = 0;

placing = false;
placing_list = [];
placing_w = 1;

selected = [];
losses_written = false;
drag_active = false;
drag_x0 = 0;
drag_y0 = 0;

hover_c = -1;
hover_r = -1;

// The field itself is built on the first Step, not here: instance_create runs
// this event immediately, so the cheat has not yet had a chance to set
// pending_width when Create fires.
