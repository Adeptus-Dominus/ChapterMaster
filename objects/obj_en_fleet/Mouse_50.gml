/// Imperial Navy fleet clicked: open the Sector Governor's fleet-order audience.
/// Only Imperial Navy fleets (owner IMPERIUM, navy == 1) are commandable this way; clicking
/// any other fleet does nothing here. Guarded to the default map view so it never fires over
/// another menu, a modal, or during load.

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

// Only the Imperial Navy takes suggestions from the Chapter.
if ((owner != eFACTION.IMPERIUM) || (navy != 1)) {
    exit;
}

// Open the Governor's audience in fleet-order mode for THIS fleet. The disposition gate and
// the actual options are handled in the "fleet_orders" dialogue branch.
navy_open_fleet_orders(id);
obj_controller.cooldown = 8;
