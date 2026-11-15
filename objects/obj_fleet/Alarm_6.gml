var _total_enemies = array_length(enemy_fleets);
var _total_allies = array_length(allied_fleets);

var _fleet_offset = 1;
var _y2 = room_height / _total_enemies / 2;
for (var i = 0; i < _total_enemies; i++){
    var y1 = _fleet_offset * _y2;

    var _spawner = instance_create(room_width + 200, y1, obj_fleet_spawner);
    _spawner.owner = enemy_fleets[i].owner;
    _spawner.height = _y2;
    _spawner.number = i;
    _spawner.ally = true;
    _spawner.fleet_data = enemy_fleets[i];
    _fleet_offset += 2;    
}

var _fleet_offset = 1;
var _y2 = room_height / _total_allies / 2;
for (var i = 0; i < _total_allies; i++){
    var y1 = _fleet_offset * _y2;

    var _spawner = instance_create(room_width + 200, y1, obj_fleet_spawner);
    _spawner.owner = allied_fleets[i].owner;
    _spawner.height = _y2;
    _spawner.number = i;
    _spawner.fleet_data = allied_fleets[i];
    _fleet_offset += 2;    
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
    global_defense = §global_defense * 1.2;
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

obj_fleet_spawner.alarm[0] = 1;
