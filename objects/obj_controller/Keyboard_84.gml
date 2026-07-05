// Fleet movement on turn end
if (!instance_exists(obj_saveload) && !instance_exists(obj_fleet) && !instance_exists(obj_ncombat) && menu == eMENU.DEFAULT && managing == 0) {
    scr_end_turn();
}
