function scr_add_stc_fragment() {
    var wik, onk;
    onk = -1;
    for (var i = 0; i < 100; i++) {
        wik = choose(1, 2, 3, 4);
        if ((wik == 4) && (onk <= -1)) {
            if ((obj_controller.stc_wargear > obj_controller.stc_vehicles) && (obj_controller.stc_wargear > obj_controller.stc_ships)) {
                wik = 1;
                onk = 0;
            }
            if ((obj_controller.stc_vehicles > obj_controller.stc_wargear) && (obj_controller.stc_vehicles > obj_controller.stc_ships)) {
                wik = 2;
                onk = 0;
            }
            if ((obj_controller.stc_ships > obj_controller.stc_wargear) && (obj_controller.stc_ships > obj_controller.stc_vehicles)) {
                wik = 3;
                onk = 0;
            }
        }

        if ((wik == 1) && (obj_controller.stc_wargear_un + obj_controller.stc_wargear == MAX_STC_PER_SUBCATEGORY)) {
            wik = 2;
        }
        if ((wik == 2) && (obj_controller.stc_vehicles_un + obj_controller.stc_vehicles == MAX_STC_PER_SUBCATEGORY)) {
            wik = 3;
        }
        if ((wik == 3) && (obj_controller.stc_ships_un + obj_controller.stc_ships == MAX_STC_PER_SUBCATEGORY)) {
            wik = 1;
        }

        if (wik == 1) {
            obj_controller.stc_wargear_un += 1;
            break;
        } else if (wik == 2) {
            obj_controller.stc_vehicles_un += 1;
            break;
        } else if (wik == 3) {
            obj_controller.stc_ships_un += 1;
            break;
        }
    }
    obj_controller.stc_un_total += 1; // found_stc+=1;

    scr_recent("stc", "stc", obj_controller.stc_un_total);
}
