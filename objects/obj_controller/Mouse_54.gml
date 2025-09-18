if (global.cheat_debug == true && instance_number(obj_turn_end) == 0 && instance_number(obj_ncombat) == 0 && instance_number(obj_fleet) == 0)
{
    if (menu == false && instance_number(obj_star_select) == 0 && popup == 0 && instance_number(obj_fleet_select) == 0 && instance_number(obj_popup) == 0)
    {
        var pop = instance_create(mouse_x, mouse_y, obj_popup)
        pop.image = "debug_banshee"
        pop.title = "DEBUG"
        pop.planet = 1
        pop.text = "What would you like to do?"
        pop.add_option(["Enemy invasion","Spawn Fleet","Delete Fleet", "Cancel"]);
    }
}
