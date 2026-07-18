unit = "";
men = 0;
veh = 0;
charge = 0;
engaged = false;
owner = eFACTION.PLAYER;
medi = 0;
attacked_dudes = 0;
dreads = 0;
jetpack_destroy = 0;
defenses = 0;
guard = 0; // OBSOLETE (iteration 1): flag for the dead planetary Guard men-block. Never set to 1 anywhere, so the guard==1 branches in scr_clean and scr_player_combat_weapon_stacks are dead. Live guardsmen are role "Guardsman" unit_struct units.

// Which formation-editor bar this block embodies ("tactical", "rhino", "deathco",
// or "colN" generic fallback). One battle block per type; see formation_block().
formation_type = "";
// Focus-fire order: 0 = nearest enemies (default), 1..3 = focus the Nth enemy line.
fire_target_line = 0;
// One leap per battle for an ordered Assault formation (see move_player_block).
assault_jumped = false;
// Set once a retreating formation reaches the field edge and withdraws.
retreat_departed = false;
// Movement passes spent as the last fighting formation (rear-guard delay).
rearguard_ticks = 0;

unit_count = 0;
unit_count_old = 0;
composition_string = "";

column_size = 0;

// Basic combat orders: "" until seeded from the battle type on the block's first
// Alarm_0 tick, then "advance" or "hold", toggled by clicking the block's bar.
move_order = "";
// True only once the player has clicked this block. Leapfrogging is reserved for
// manually ordered blocks: the seeded auto-advance must keep vanilla stall behavior
// or formations scramble on their own (tester's raid reordered itself with no
// orders given, tacticals vaulting the engaged front line).
order_manual = false;

centerline_offset = 0;
pos = 880;
draw_size = 0;
x1 = pos + (centerline_offset * 2);
y1 = 450 - (draw_size / 2);
x2 = pos + (centerline_offset * 2) + 10;
y2 = 450 + (draw_size / 2);

// x determines column; maybe every 10 or so?
// For fortified locations maybe create a wall unit for the player?

/// @type {Array<Struct.TTRPG_stats}
unit_struct = [];
marine_type = [];
marine_co = [];
marine_id = [];
marine_hp = [];
marine_ac = [];
marine_exp = [];
marine_wep1 = [];
marine_wep2 = [];
marine_armour = [];
marine_gear = [];
marine_mobi = [];
marine_powers = [];
marine_dead = [];
marine_attack = [];
marine_ranged = [];
marine_defense = [];
marine_casting = [];
marine_casting_cooldown = [];
marine_local = [];
ally = [];

//* Psychic power buffs
// this would be set to the turns remaining
// so long as >0 would apply an effect
marine_mshield = [];
marine_quick = [];
marine_might = [];
marine_fiery = [];
marine_fshield = [];
marine_iron = [];
marine_dome = [];
marine_spatial = [];
marine_dementia = [];

var _veh_size = 1500;
veh_co = array_create(_veh_size, 0);
veh_id = array_create(_veh_size, 0);
veh_type = array_create(_veh_size, "");
veh_hp = array_create(_veh_size, 0);
veh_ac = array_create(_veh_size, 0);
veh_wep1 = array_create(_veh_size, "");
veh_wep2 = array_create(_veh_size, "");
veh_wep3 = array_create(_veh_size, "");
veh_upgrade = array_create(_veh_size, "");
veh_acc = array_create(_veh_size, "");
veh_dead = array_create(_veh_size, 0);
veh_hp_multiplier = array_create(_veh_size, 1);
veh_local = array_create(_veh_size, 0);
veh_ally = array_create(_veh_size, false);

var _wep_size = 71;
wep = array_create(_wep_size, "");
wep_num = array_create(_wep_size, 0);
wep_rnum = array_create(_wep_size, 0);
range = array_create(_wep_size, 0);
att = array_create(_wep_size, 0);
apa = array_create(_wep_size, 0);
ammo = array_create(_wep_size, -1);
splash = array_create(_wep_size, 0);
wep_owner = array_create(_wep_size, "");
wep_solo = array_create_advanced(_wep_size, []);
wep_title = array_create(_wep_size, "");

dudes = array_create(_wep_size, "");
dudes_num = array_create(_wep_size, 0);
dudes_vehicle = array_create(_wep_size, 0);

// These arrays are the losses on any one frame.
// Let them resize as required.
// Hardcoded lengths lead to bounds issues when hardcoded values disagree.
lost = [];
lost_num = [];

hostile_shots = 0;
hostile_shooters = 0;
hostile_damage = 0;
hostile_weapon = "";
hostile_unit = "";
hostile_type = 0;
hostile_splash = 0;

alarm[1] = 4;

hit = function() {
    return scr_hit(x1, y1, x2, y2) && obj_ncombat.fadein <= 0;
};

/// @description Assemble an array of weapons that didn't get to shoot and combat log it.
push_held_fire = function(_starting_i = 0) {
    var _skipped_fire = [];
    for (var i = _starting_i; i < array_length(wep); i++) {
        if (wep[i] != "" && wep_num[i] > 0 && range[i] > 1 && ammo[i] != 0) {
            array_push(_skipped_fire, wep[i]);
        }
    }
    report_held_fire(_skipped_fire);
};

/// @description Tick down psychic buff durations for all marines in the calling player column.
tick_psychic_buffs = function() {
    try {
        var _buffs = [
            "marine_mshield",
            "marine_quick",
            "marine_might",
            "marine_fiery",
            "marine_fshield",
            "marine_dome",
            "marine_spatial",
            "marine_iron",
            "marine_dementia",
        ];
        for (var i = 0; i < array_length(unit_struct); i++) {
            for (var b = 0; b < array_length(_buffs); b++) {
                var _name = _buffs[b];
                if (self[$ _name][i] > 0) {
                    self[$ _name][i] -= 1;
                }
            }
        }
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
};
