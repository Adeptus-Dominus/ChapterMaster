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

if (ii_check <= 0) {
    // Refresh the fleet's map sprite size, then rearm the timer. Previously this fired
    // exactly once (ii_check hit 0 then went negative and never reset), so a fleet
    // whose serialized ii_check was already negative never recomputed its size after a
    // load and rendered as a single tiny blip regardless of its real strength. The
    // enemy fleet (obj_en_fleet) already rearms this timer; the player fleet did not.
    // Using <= 0 also lets a loaded fleet with a negative timer heal on the next step.
    set_player_fleet_image();
    ii_check = 10;
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
