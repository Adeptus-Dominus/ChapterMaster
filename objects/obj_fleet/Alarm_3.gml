instance_activate_object(obj_p_ship);
instance_activate_object(obj_en_ship);

instance_create(0, 0, obj_fleet_controller);

if (instance_number(obj_en_ship) == 0) {
    combat_end = -1;
    start = 6;
    obj_p_ship.alarm[3] = 1;
    alarm[0] = 10;
}
