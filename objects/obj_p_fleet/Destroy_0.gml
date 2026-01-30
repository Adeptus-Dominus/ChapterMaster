if ((action == "") && (orbiting != 0)) {
    if (instance_exists(orbiting)) {
        orbiting.present_fleet[1] -= 1;
    }
    orbiting = 0;
}
