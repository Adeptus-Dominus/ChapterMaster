var _total_enemies = array_length(enemy_fleets);
var _total_allies = array_length(allied_fleets);

var _enemy_y = room_height / max(1, _total_enemies) / 2;
var _enemy_offset = 1;
for (var i = 0; i < _total_enemies; i++) {
    var _enemy_spawn_y = _enemy_offset * _enemy_y;

    var _spawner = instance_create(room_width + 200, _enemy_spawn_y, obj_fleet_spawner);
    _spawner.owner = enemy_fleets[i].owner;
    _spawner.height = _enemy_y;
    _spawner.fleet_data = enemy_fleets[i];
    _enemy_offset += 2;
}

// Player and allies share the left side; the +1 accounts for the player slot in the spacing.
var _ally_y = room_height / (_total_allies + 1) / 2;

var _player_spawner = instance_create(200, _ally_y, obj_fleet_spawner);
_player_spawner.owner = eFACTION.PLAYER;
_player_spawner.fleet_data = player_fleet;

var _ally_offset = 3;
for (var i = 0; i < _total_allies; i++) {
    var _ally_spawn_y = _ally_offset * _ally_y;

    var _spawner = instance_create(200, _ally_spawn_y, obj_fleet_spawner);
    _spawner.owner = allied_fleets[i].owner;
    _spawner.height = _ally_y;
    _spawner.fleet_data = allied_fleets[i];
    _ally_offset += 2;
}

// Buffs here
attack_mode = "offensive";

if ((ambushers == 1) && (ambushers == 999)) {
    global_attack = global_attack * 1.1;
} // Need to finish this
if (bolter_drilling == 1) {
    global_bolter = global_bolter * 1.1;
}
if ((siege == 1) && (siege == 555)) {
    global_attack = global_attack * 1.2;
} // Need to finish this
if (slow == 1) {
    global_attack = global_attack * 0.9;
    global_defense = global_defense * 1.2;
}
if (melee == 1) {
    global_melee = global_melee * 1.15;
}
if (shitty_luck == 1) {
    global_defense = global_defense * 0.9;
}
if (ossmodula == 1) {
    global_attack = global_attack * 0.95;
    global_defense = global_defense * 0.95;
}
if (betchers == 1) {
    global_melee = global_melee * 0.95;
}
if (catalepsean == 1) {
    global_attack = global_attack * 0.95;
}
// More prep for player

capital_max = capital;
frigate_max = frigate;
escort_max = escort;

if (!instance_exists(obj_fleet_spawner)) {
    alarm[4] = 1;
    exit;
}
