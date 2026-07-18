if (instance_number(obj_ncombat) > 1) {
    instance_destroy();
}

set_zoom_to_default();
LOGGER.info("Ground Combat Started");

audio_stop_sound(snd_royal);
audio_play_sound(snd_battle, 0, true);
audio_sound_gain(snd_battle, 1, 5000);

hue = 0;
turn_count = 0;

//limit on the size of the players forces allowed
enter_pressed = 0;
man_size_limit = 0;
man_limit_reached = false;
man_size_count = 0;
fack = 0;
cd = 0;
owner = eFACTION.PLAYER;
click_stall_timer = 0;
formation_set = 0;
on_ship = false;
alpha_strike = 0;
Warlord = noone;
total_battle_exp_gain = 0;
marines_to_recover = 0;
vehicles_to_recover = 0;
end_alive_units = [];
average_battle_exp_gain = 0;
upgraded_librarians = [];

view_x = obj_controller.x;
view_y = obj_controller.y;
obj_controller.x = 0;
obj_controller.y = 0;
if (obj_controller.zoomed == 1) {
    with (obj_controller) {
        scr_zoom();
    }
}
xxx = 200;
instance_activate_object(obj_cursor);
instance_activate_object(obj_ini);
instance_activate_object(obj_img);

var u = noone;
for (var i = 10; i > 0; i--) {
    // This creates the objects to then be filled in
    u = instance_create(i * 10, 240, obj_pnunit);
}

instance_create(0, 0, obj_centerline);

local_forces = 0;
battle_loc = "";
battle_climate = "";
if (instance_exists(obj_star)) {
    /// @type {Id.Instance.obj_star}
    battle_object = instance_nearest(x, y, obj_star);
} else {
    battle_object = noone;
    LOGGER.error("No obj_star instance found for combat; battle_object defaulted to noone");
}
battle_id = 0;
battle_mission = "";
battle_special = "";
battle_data = {};
defeat = 0;
defeat_message = 0;
fugg = 0;
fugg2 = 0;
// Hard-timeout counters for stages 2/4. Unlike fugg/fugg2 these are NOT reset by the 60-frame
// status poll in Step, so they keep accumulating during a stall and the anti-hang cap can fire.
stage_elapsed = 0;
stage_elapsed2 = 0;
battle_over = 0;
done = 0;

captured_gaunt = 0;
ethereal = 0;
hulk_treasure = 0;
four_show = 0;
chaos_angry = 0;

leader = 0;
thirsty = 0;
really_thirsty = 0;
allies = 0;
present_inquisitor = 0;
sorcery_seen = 0;
inquisitor_ship = 0;
guard_total = 0;
guard_effective = 0;
player_starting_dudes = 0;
chapter_master_psyker = 0;
guard_pre_forces = 0;
ally = 0;
ally_forces = 0;
ally_special = 0;

global_perils = 0;
exterminatus = 0;
plasma_bomb = 0;

display_p1 = 0;
display_p1n = "";
display_p2 = 0;
display_p2n = "";

alarm[0] = 2;
alarm[1] = 3;
obj_pnunit.alarm[3] = 1;
alarm[2] = 8;

started = 0;
charged = 0;

fadein = 40;
enemy = undefined;
enem = "Orks";
enem_sing = "Ork";
threat = 0;
fortified = 0;
enemy_fortified = 0;
wall_destroyed = 0;
flank_x = 0;

player_forces = 0;
player_max = 0;
player_defenses = 0;
player_silos = 0;

enemy_forces = 0;
enemy_max = 0;
hulk_forces = 0;

dead_enemies = 0;

units_lost_counts = {};
vehicles_lost_counts = {};

dead_jim = array_create(70, "");
dead_ene = array_create(70, "");
dead_ene_n = array_create(70, 0);
crunch = array_create(70, 0);
mucra = array_create(11, 0);

post_equipment_lost = new EquipmentTracker();
post_equipment_recovered = new EquipmentTracker();

slime = 0;
unit_recovery_score = 0;
apothecaries_alive = 0;
techmarines_alive = 0;
vehicle_recovery_score = 0;
injured = 0;
command_injured = 0;
seed_saved = 0;
seed_lost = 0;
seed_harvestable = 0;
units_saved_count = 0;
units_saved_counts = {};
command_saved = 0;
vehicles_saved_count = 0;
vehicles_saved_counts = {};
final_marine_deaths = 0;
final_command_deaths = 0;
vehicle_deaths = 0;
casualties = 0;
dead_jims = 0;

combat_log = new CombatLog(id);
combat_log.log_font = fnt_aldrich_12;

combat_debugger = new CombatDebugger(false);

ctally_target = undefined;
ctally_bounce = [];
ctally_injure = [];

world_size = 0;

timer = 0;
timer_stage = 0;
timer_speed = 0;
timer_maxspeed = 1;
timer_pause = -1;
turns = 1;

scouts = 0;
tacticals = 0;
veterans = 0;
devastators = 0;
assaults = 0;
librarians = 0;
techmarines = 0;
honors = 0;
dreadnoughts = 0;
terminators = 0;
captains = 0;
standard_bearers = 0;
champions = 0;
important_dudes = 0;
chaplains = 0;
apothecaries = 0;
sgts = 0;
vet_sgts = 0;

rhinos = 0;
predators = 0;
land_raiders = 0;
land_speeders = 0;
whirlwinds = 0;

big_mofo = 10;

enemy_dudes = "";

en_scouts = 0;
en_tacticals = 0;
en_sgts = 0;
en_vet_sgts = 0;
en_veterans = 0;
en_devastators = 0;
en_assaults = 0;
en_librarians = 0;
en_techmarines = 0;
en_honors = 0;
en_dreadnoughts = 0;
en_terminators = 0;
en_captains = 0;
en_standard_bearers = 0;
en_important_dudes = 0;
en_chaplains = 0;
en_apothecaries = 0;

en_big_mofo = 10;

defending = true; // 1 is defensive
dropping = false; // 0 is was on ground
attacking = 0; // 1 means attacked from space/local
time = floor(random(24)) + 1;
terrain = "";
weather = "";

global_melee = 1;
global_bolter = 1;
global_attack = 1;
global_defense = 1;

ambushers = scr_has_adv("Ambushers");
bolter_drilling = scr_has_adv("Bolter Drilling");
enemy_eldar = scr_has_adv("Enemy: Eldar");
enemy_fallen = scr_has_adv("Enemy: Fallen");
enemy_orks = scr_has_adv("Enemy: Orks");
enemy_tau = scr_has_adv("Enemy: Tau");
enemy_tyranids = scr_has_adv("Enemy: Tyranids");
enemy_necrons = scr_has_adv("Enemy: Necrons");
lightning = scr_has_adv("Lightning Warriors");
siege = scr_has_adv("Siege Masters");
slow = scr_has_adv("Devastator Doctrine");
melee = scr_has_adv("Assault Doctrine");
black_rage = scr_has_disadv("Black Rage");
red_thirst = scr_has_disadv("Black Rage") ? 1 : 0; // red_thirst is used as a counter Real so it gets the ternary init
shitty_luck = scr_has_disadv("Shitty Luck");
favoured_by_the_warp = scr_has_adv("Favoured By The Warp");

lyman = obj_ini.lyman; // drop pod penalties
omophagea = obj_ini.omophagea; // feast
ossmodula = obj_ini.ossmodula; // small penalty to all
membrane = obj_ini.membrane; // less chance of survival for wounded
betchers = obj_ini.betchers; // slight melee penalty
catalepsean = obj_ini.catalepsean; // minor global attack decrease
occulobe = obj_ini.occulobe; // penalty if morning and susceptible to flash grenades
mucranoid = obj_ini.mucranoid; // chance to short-circuit
