if (global.cheat_debug == true && instance_number(obj_turn_end) == 0 && instance_number(obj_ncombat) == 0 && instance_number(obj_fleet) == 0)
{
    if (!menu  && instance_number(obj_star_select) == 0 && popup == 0 && instance_number(obj_fleet_select) == 0 && instance_number(obj_popup) == 0)
    {
        new_system_debug_popup();
    }
}
