function scr_load_all(select_units) {
    var sell = "", unit;

    // Load / Select All
    if (select_units) {
        man_size = 0;
        // This sets the maximum size of marines in a company to 200 size
        for (var i = 0; i < array_length(display_unit); i++) {
            unit = display_unit[i];
            if (is_struct(unit)) {
                if ((man[i] == "man") && (ma_loc[i] == selecting_location) && (ma_wid[i] == selecting_planet) && (ma_god[i] < 10)) {
                    if (unit.assignment() == "none") {
                        man_sel[i] = 1;
                        man_size += display_unit[i].get_unit_size();
                    }
                }
            } else if (is_array(unit)) {
                //if (i<=200){
                if ((man[i] == "vehicle") && (ma_loc[i] == selecting_location) && (ma_wid[i] == selecting_planet)) {
                    man_sel[i] = 1;
                    if (selecting_location == "") {
                        selecting_location = ma_loc[i];
                        selecting_ship = ma_lid[i];
                        selecting_planet = ma_wid[i];
                    }
                    man_size += scr_unit_size("", ma_role[i], true);
                }
            }
            //}
        }
    }
    // Unload / Unselect All
    if (!select_units) {
        alll = 0;
        man_size = 0;
        for (var i = 0; i < array_length(display_unit); i++) {
            man_sel[i] = 0;
        }
    }
}
