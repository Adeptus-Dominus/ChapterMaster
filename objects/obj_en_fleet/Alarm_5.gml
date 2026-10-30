if (action_eta > obj_controller.fleet_eta_board) {
    obj_controller.fleet_eta_board = action_eta;
} else {
    action_eta = obj_controller.fleet_eta_board;
}

rep -= 1;

if (rep > 0) {
    alarm[5] = 1;
}

if (rep == 0) {
    action_eta = obj_controller.fleet_eta_board - choose(0, 1);

    rep = 3;
    alarm[5] = -1;
}
