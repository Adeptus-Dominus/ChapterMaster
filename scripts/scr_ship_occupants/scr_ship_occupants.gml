function scr_ship_occupants(target_ship_id) {
    var co, i, oc, ocn, ty, g, good, blur, unit;
    co = -1;
    i = -1;
    ty = 0;
    g = 0;
    good = 0;
    blur = "";

    repeat (200) {
        i += 1;
        oc[i] = "";
        ocn[i] = 0;
    }

    i = 0;
    for (co = 0; co <= 10; co++) {
        i = 0;
        repeat (500) {
            i += 1;
            if (obj_ini.role[co][i] != "") {
                unit = fetch_unit([co, i]);
                if (unit.ship_location != target_ship_id) {
                    good = 0;
                }
                g = 0;
                repeat (100) {
                    g += 1;
                    if (good == 0) {
                        if (oc[g] == unit.role()) {
                            good = 1;
                            ocn[g] += 1;
                            break;
                        }
                    }
                }
                if (good == 0) {
                    ty += 1;
                    oc[ty] = unit.role();
                    ocn[ty] = 1;
                    good = 1;
                }
            }
        }
    }
    i = 0;
    co = -1;
    for (co = 0; co <= 10; co++) {
        i = 0;
        repeat (100) {
            i += 1;
            if ((obj_ini.veh_role[co][i] != "") && (obj_ini.veh_lid[co][i] == target_ship_id)) {
                good = 0;
                g = 0;
                repeat (100) {
                    g += 1;
                    if (good == 0) {
                        if (oc[g] == obj_ini.veh_role[co][i]) {
                            good = 1;
                            ocn[g] += 1;
                        }
                    }
                }
                if (good == 0) {
                    ty += 1;
                    oc[ty] = obj_ini.veh_role[co][i];
                    ocn[ty] = 1;
                    good = 1;
                }
            }
        }
    }

    i = 0;
    good = 1;
    repeat (100) {
        i += 1;
        if (good == 1) {
            if (ocn[i] == 1) {
                blur += string(ocn[i]) + "x " + string(oc[i]);
            }
            if (ocn[i] > 1) {
                blur += string(ocn[i]) + "x " + string(oc[i]) + "s";
            }
            if (ocn[i + 1] > 0) {
                blur += ", ";
            }
            if (ocn[i + 1] == 0) {
                blur += ".";
                good = 0;
            }
        }
    }

    return blur;
}
