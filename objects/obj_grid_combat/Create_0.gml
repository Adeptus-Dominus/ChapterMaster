/// Grid combat prototype controller, launched by the "gridbattle" cheat.
/// Every instance variable is initialized here; this build crashes on
/// uninitialized reads, so nothing may be left implicit.

if (instance_number(obj_grid_combat) > 1) {
    instance_destroy();
    exit;
}

depth = -15000;
boot_done = false;

phase = GRIDPH_DEPLOY;
result = 0;
ticks = 0;
frame_ctr = 0;
paused = false;
speed_mult = 1;
exit_arm = 0;

points = GRIDC_POINTS;
waves_left = GRIDC_WAVES;

squads = [];
formations = [];
form_counters = {};
form_color_idx = 0;

occ = array_create(GRIDC_COLS);
cov = array_create(GRIDC_COLS);
var _c;
for (_c = 0; _c < GRIDC_COLS; _c++) {
    occ[_c] = array_create(GRIDC_ROWS, -1);
    cov[_c] = array_create(GRIDC_ROWS, 0);
}

feed = [];
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
selected_form = -1;
hover_c = -1;
hover_r = -1;

grid_gen_cover(id);
grid_gen_player_pool(id);
grid_spawn_enemy_force(id);

grid_log(id, "Grid Combat Prototype: Uxie redesign, first playable slice.", c_white);
grid_log(id, "Deploy from the left bar into the blue zone, then Begin Battle.", GRIDC_COL_ORDER);
