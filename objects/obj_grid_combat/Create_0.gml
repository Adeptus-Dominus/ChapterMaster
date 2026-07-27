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

// The game's own combat readout, so the grid reports in the same colours, with
// the same wrapping, drain pacing, scrollback and scrollbar as a vanilla battle.
// Sized to the strip under the battlefield rather than the vanilla side panel.
log = new CombatLog();
log.log_font = fnt_40k_12;
log.log_line_height = 18;
log.log_view_lines = 13;
log.log_max_width = GRIDC_BF_X2 - GRIDC_BF_X1 - 24;

floaters = [];
// Shot marks: tracers, beams and shells in flight. Purely visual, decayed per
// frame like the floaters so pausing the sim does not freeze them mid-air.
shots = [];

// Living, deployed squads per side, rebuilt once a tick by grid_refresh_live.
// Declared here because the deploy phase reads them before any tick has run, and
// an uninitialised read is a crash in this build rather than a zero.
live0 = [];
live1 = [];
// Mean anchor column of each side's formations: where its line currently is.
line0 = -1;
line1 = -1;

agg_ekills = 0;
agg_pkills = 0;
// Outcome tallies behind the periodic exchange line, indexed by GRIDHIT_*.
tally_p = array_create(GRIDHIT_WOUND + 1, 0);
tally_e = array_create(GRIDHIT_WOUND + 1, 0);
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
// Drag placement: where the front rank was started, and whether a drag is live.
place_drag = false;
place_c0 = -1;
place_r0 = -1;

// Control groups 0 to 9, each a list of formation indices.
groups = [];
for (var _gi = 0; _gi <= 9; _gi++) {
    groups[_gi] = [];
}

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
