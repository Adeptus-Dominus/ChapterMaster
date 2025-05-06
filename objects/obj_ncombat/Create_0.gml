#macro BATTLELOG_MAX_PER_TURN 40

if (instance_number(obj_ncombat) > 1) {
    instance_destroy();
}

set_zoom_to_default();
var co, i;
co = -1;
co = 0;
i = 0;
hue = 0;

turn_count = 0;
log_message("Ground Combat Started");

audio_stop_sound(snd_royal);
audio_play_sound(snd_battle, 0, true);
audio_sound_gain(snd_battle, 0, 0);
var nope = 0;
if ((obj_controller.master_volume == 0) || (obj_controller.music_volume == 0)) {
    nope = 1;
}
if (nope != 1) {
    audio_sound_gain(snd_battle, 0.25 * obj_controller.master_volume * obj_controller.music_volume, 2000);
}

//limit on the size of the players forces allowed
man_size_limit = 0;
man_limit_reached = false;
man_size_count = 0;
player_formation = 0;
enemy_alpha_strike = 0;
Warlord = 0;
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

// var i, u;
// i = 11;
// repeat (10) {
//     i -= 1; // This creates the objects to then be filled in
//     u = instance_create(i * 10, 240, obj_pnunit);
// }

instance_create(0, 0, obj_centerline);

local_forces = 0;
battle_loc = "";
battle_climate = "";
battle_id = 0;
battle_object = 0;
battle_special = "";
defeat = 0;
battle_ended = false;
battle_over = 0;

lost_to_black_rage = 0;

captured_gaunt = 0;
ethereal = 0;
hulk_treasure = 0;
chaos_angry = 0;

leader = 0;
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

battle_stage = eBATTLE_STAGE.Creation;
charged = 0;

fading_strength = 1;

enemy = 0;
threat = 0;
fortified = 0;
enemy_fortified = 0;
wall_destroyed = 0;
enem = "Orks";
enem_sing = "Ork";
flank_x = 0;

player_forces = 0;
player_max = 0;
player_defenses = 0;
player_silos = 0;

enemy_forces = 0;
enemy_max = 0;
hulk_forces = 0;

messages_shown = 0;

units_lost_counts = {};
vehicles_lost_counts = {};

var _messages_size = 70;
lines = array_create(_messages_size, "");
lines_color = array_create(_messages_size, COL_GREEN);
message = array_create(_messages_size, "");
messages_queue = ds_queue_create();
newline = "";
newline_color = COL_GREEN;
liness = 0;

post_equipment_lost = array_create(_messages_size, "");
post_equipments_lost = array_create(_messages_size, 0);

crunch = array_create(_messages_size, 0);
mucra = array_create(11, 0);

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
vehicles_saved_counts = {};
command_saved = 0;
vehicles_saved_count = 0;
vehicles_saved_counts = {};
final_marine_deaths = 0;
final_command_deaths = 0;
vehicle_deaths = 0;
casualties = 0;
world_size = 0;

turn_phase = eBATTLE_TURN_PHASE.Movement;
turn_side = eBATTLE_ALLEGIANCE.Player;

//

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
en_important_dudes = 0;

//

defending = true; // 1 is defensive
dropping = 0; // 0 is was on ground
attacking = 0; // 1 means attacked from space/local
time = irandom(24);

global_melee = 1;
global_attack = 1;
global_defense = 1;

// Advantage-based modifiers
if (scr_has_adv("Ambushers")) {
    global_attack *= 1.1;
}
if ((scr_has_adv("Enemy: Eldar")) && (enemy == eFACTION.Eldar)) {
    global_attack *= 1.1;
    global_defense *= 1.1;
}
if ((scr_has_adv("Enemy: Fallen")) && (enemy == eFACTION.Heretics)) {
    global_attack *= 1.1;
    global_defense *= 1.1;
}
if ((scr_has_adv("Enemy: Orks")) && (enemy == eFACTION.Ork)) {
    global_attack *= 1.1;
    global_defense *= 1.1;
}
if ((scr_has_adv("Enemy: Tau")) && (enemy == eFACTION.Tau)) {
    global_attack *= 1.1;
    global_defense *= 1.1;
}
if ((scr_has_adv("Enemy: Tyranids")) && (enemy == eFACTION.Tyranids)) {
    global_attack *= 1.1;
    global_defense *= 1.1;
}
if ((scr_has_adv("Enemy: Necrons")) && (enemy == eFACTION.Necrons)) {
    global_attack *= 1.1;
    global_defense *= 1.1;
}
if ((scr_has_adv("Siege Masters")) && (enemy_fortified >= 3) && (!defending)) {
    global_attack *= 1.2;
}
if (scr_has_adv("Devastator Doctrine")) {
    global_attack -= 0.1;
    global_defense += 0.2;
}
if (scr_has_adv("Lightning Warriors")) {
    global_attack += 0.2;
    global_defense -= 0.1;
}
if (scr_has_adv("Assault Doctrine")) {
    global_melee *= 1.15;
}

// Disadvantage-based modifiers
if (scr_has_disadv("Shitty Luck")) {
    global_defense *= 0.9;
}

// Organ rules
if ((obj_ini.lyman) && (dropping)) {
    global_attack *= 0.85;
    global_defense *= 0.9;
}
if (obj_ini.ossmodula == 1) {
    global_attack *= 0.95;
    global_defense *= 0.95;
}
if (obj_ini.betchers) {
    global_melee *= 0.95;
}
if (obj_ini.catalepsean) {
    global_attack *= 0.95;
}
if (obj_ini.occulobe) {
    if ((time == 5) || (time == 6)) {
        global_attack *= 0.7;
        global_defense *= 0.8;
    }
}

enemy_dudes = "";
global_defense = 2 - global_defense;

enemy_force = new BattleArmy("", false);
enemy_force.allegiance = eBATTLE_ALLEGIANCE.Enemy;
player_force = new BattleArmy(global.chapter_name, false);
player_force.allegiance = eBATTLE_ALLEGIANCE.Player;

queue_force_health = function() {
	var _text = "";

    if (turn_phase == eBATTLE_TURN_PHASE.Movement) {
        if (turn_side == eBATTLE_ALLEGIANCE.Player) {
            if (player_forces > 0) {
                _text = $"The {global.chapter_name} are at {string(round((player_forces / player_max) * 100))}% strength!";
            } else {
                _text = $"The {global.chapter_name} are defeated!";
            }
        } else {
            if (enemy_forces > 0) {
                _text = $"The enemy forces are at {string(max(1, round((enemy_forces / enemy_max) * 100)))}% strength!";
            } else {
                _text = "The enemy forces are defeated!";
            }
        }

        queue_battlelog_message(_text, COL_YELLOW);
    }
}

/// @function queue_battlelog_message
/// @param {string} _message - The message text to add to the battle log
/// @param _message_color - Hexadecimal/CSS colour/constant color.
/// @returns {real} The index of the newly added message
queue_battlelog_message = function(_message, _message_color = COL_GREEN) {
	if (instance_exists(obj_ncombat)) {
		var _message_struct = {
			message: _message,
			color: _message_color
		}

		ds_queue_enqueue(obj_ncombat.messages_queue, _message_struct)
	}
}

display_message_queue = function() {
	while (!ds_queue_empty(messages_queue) && messages_shown < BATTLELOG_MAX_PER_TURN) {
        var _message = ds_queue_dequeue(messages_queue);
        newline = _message.message;
        newline_color = _message.color;
        messages_shown += 1;
        scr_newtext();
    }
	messages_shown = 0;
    ds_queue_clear(messages_queue);
}

battlefield_grid = new BattlefieldGrid(100, 1);

function SimplePanel(_x1, _y1, _x2, _y2) constructor {
    x1 = _x1;
    y1 = _y1;
    x2 = _x2;
    y2 = _y2;
    x3 = (x1 + x2) / 2;
    y3 = (y1 + y2) / 2;
    back_colour = c_black;
    border_colour = COL_GREEN;

    static draw = function() {
        draw_set_color(back_colour);
        draw_rectangle(x1, y1, x2, y2, false);

        draw_set_color(border_colour);
        var _offset_step = 3 / (4 - 1);
        var _alpha_step = 1.0 / (4);
        for (var i = 0; i < 4; i++) {
            var _current_offset = round(i * _offset_step);
            var _current_alpha = 1.0 - (i * _alpha_step);
            _current_alpha = clamp(_current_alpha, 0, 1);

            draw_set_alpha(_current_alpha);

            draw_rectangle(x1 + _current_offset, y1 + _current_offset, x2 - _current_offset, y2 - _current_offset, true);
        }
        draw_set_alpha(1);
        draw_set_color(c_white);
    };
}

message_log = new SimplePanel(22, 22, 800, 878);
battle_view = new SimplePanel(822, 22, 1578, 878);