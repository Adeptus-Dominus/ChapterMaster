if (action_eta > obj_controller.temp[90]) {
    obj_controller.temp[90] = action_eta;
}
if (action_eta < obj_controller.temp[90]) {
    action_eta = obj_controller.temp[90];
}
rep -= 1;

if (rep > 0) {
    alarm[5] = 1;
}

if (rep == 0) {
    // if (id mod 2 == 0) then action_eta=obj_controller.temp[90];
    // else{action_eta=obj_controller.temp[90]-1;}

    action_eta = obj_controller.temp[90] - choose(0, 1);

    rep = 3;
    alarm[5] = -1;
}
