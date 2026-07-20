/// Imperial Navy fleet clicked: open the Sector Governor's fleet-order audience.
/// Mouse_50 is GameMaker's GLOBAL left-button event, so every enemy fleet receives it whenever
/// LMB is held anywhere. The first two guards turn that global signal into one actual click on
/// this exact fleet instance before any diplomacy code can run.

if (!mouse_check_button_pressed(mb_left)) {
    exit;
}

if (!point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom)) {
    exit;
}

if (obj_controller.menu != eMENU.DEFAULT) {
    exit;
}

if (instances_exist_any([obj_drop_select, obj_saveload, obj_bomb_select])) {
    exit;
}

if ((global.load >= 0) || instance_exists(obj_saveload)) {
    exit;
}

if (obj_controller.cooldown > 0) {
    exit;
}

// Only a genuine Imperial Navy fleet takes suggestions from the Chapter.
// Imperial defence fleets and every non-Imperial fleet fail this guard.
if ((owner != eFACTION.IMPERIUM) || (navy != 1)) {
    exit;
}

// Open the Governor's audience in fleet-order mode for THIS fleet.
navy_open_fleet_orders(id);
obj_controller.cooldown = 8;
