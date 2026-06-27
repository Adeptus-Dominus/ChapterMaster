if ((action == "") && (orbiting != noone)) {
    if (instance_exists(orbiting)) {
        orbiting.present_fleet[1] -= 1;
    }
    orbiting = noone;
}
