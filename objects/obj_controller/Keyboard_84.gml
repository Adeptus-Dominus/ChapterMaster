// Fleet movement on turn end
if (action_if_number(obj_saveload, 0, 0) && action_if_number(obj_fleet, 0, 0) && action_if_number(obj_ncombat, 0, 0) && action_if_variable(menu, 0, 0) && action_if_variable(managing, 0, 0)) {
    scr_end_turn();
}
