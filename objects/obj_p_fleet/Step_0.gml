ii_check -= 1;
if (action == "Lost") {
    exit;
}
if ((action != "") && instance_exists(orbiting)) {
    fleet_unregister_from_star(id);
}

action_spd = calculate_action_speed();

if (ii_check == 0) {
    set_player_fleet_image();
}

if ((global.load >= 0) && (sprite_index != spr_fleet_tiny)) {
    sprite_index = spr_fleet_tiny;
}

if (fix > -1) {
    fix -= 1;
}
if ((fix == 0) && (action == "")) {
    set_fleet_location(instance_nearest(x, y, obj_star).name);
}
