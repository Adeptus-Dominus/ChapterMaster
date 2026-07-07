ii_check -= 1;
if (action == "Lost") {
    exit;
}
if ((action != "") && (orbiting != noone)) {
    orbiting = instance_nearest(x, y, obj_star);
    orbiting.present_fleet[1] -= 1;
    orbiting = noone;
}

action_spd = calculate_action_speed();

if (ii_check == 0) {
    // Refresh the map icon frame on a fixed 10-step cadence, matching obj_en_fleet.
    // Without this reset the countdown hit 0 only once (roughly 10 steps after the
    // fleet was created), so set_player_fleet_image ran a single time. A fleet loaded
    // from a save has its ship counts populated by the load pass, and any fleet that
    // gains or loses ships in play, so that one early frame calculation went stale and
    // the icon stuck at the tiny frame regardless of real size.
    ii_check = 10;
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
