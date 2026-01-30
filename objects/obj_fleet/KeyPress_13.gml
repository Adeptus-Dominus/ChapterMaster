var __b__;
__b__ = action_if_variable(obj_controller.cooldown, 0, 2);
if (!__b__) {
    __b__ = action_if_variable(start, 7, 0);
    if (!__b__) {
        {
            start = 5;
            // show_message(string(ships_max));

            /*en_capital_max=en_capital;
en_frigate_max=en_frigate;
en_escort_max=en_escort;*/

            beg = 1;

            /* */
        }
    }
}
__b__ = action_if_variable(obj_controller.cooldown, 0, 2);
if (!__b__) {
    __b__ = action_if_variable(start, 7, 0);
    if (__b__) {
        // End battle crap here

        instance_activate_all();
        room_speed = 30;
        alarm[7] = 1;

        /* */
    }
}
/*  */
