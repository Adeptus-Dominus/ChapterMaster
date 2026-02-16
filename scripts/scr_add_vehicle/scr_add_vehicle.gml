function scr_add_vehicle(vehicle_type, target_company, otherdata = {}, weapon1 = "standard", weapon2 = "standard", weapon3 = "standard", upgrade = "standard", accessory = "standard") {
    try {
        // That should be sufficient to add stuff in a highly modifiable fashion

        var i = 0;
        var e = 0;
        var good = 0;
        var wep1 = "";
        var wep2 = "";
        var gear = "";
        var arm = "";
        var missing = 0;

        for (var i = 1; i < array_length(obj_ini.veh_role[target_company]); i++) {
            if (good == 0) {
                if (obj_ini.veh_role[target_company][i] == "") {
                    good = i;
                    break;
                }
            }
        }

        if (good != 0) {
            obj_ini.veh_race[target_company][good] = 1;

            if (!struct_exists(otherdata, "loc")) {
                if (obj_ini.fleet_type == ePLAYER_BASE.HOME_WORLD) {
                    obj_ini.veh_loc[target_company][good] = obj_ini.home_name;
                    obj_ini.veh_wid[target_company][good] = obj_ini.home_planet;
                    obj_ini.veh_lid[target_company][good] = -1;
                }

                if (obj_ini.fleet_type != ePLAYER_BASE.HOME_WORLD) {
                    // Need a more elaborate ship_carrying += here for the different types of units
                    var first = -1, backup = -1, i = 0;
                    for (var i = 0; i < array_length(obj_ini.ship_class); i++) {
                        if ((obj_ini.ship_class[i] == "Battle Barge") && (first == -1) && (obj_ini.ship_capacity[i] > obj_ini.ship_carrying[i])) {
                            first = i;
                        }
                        if ((obj_ini.ship_class[i] == "Strike Cruiser") && (backup == -1) && (obj_ini.ship_capacity[i] > obj_ini.ship_carrying[i])) {
                            backup = i;
                        }
                    }
                    if (first != -1) {
                        obj_ini.veh_lid[target_company][good] = first;
                        obj_ini.veh_loc[target_company][good] = obj_ini.ship_location[first];
                        obj_ini.veh_wid[target_company][good] = 0;
                        obj_ini.ship_carrying[first] += 1;
                    } else if ((first == -1) && (backup != -1)) {
                        obj_ini.veh_lid[target_company][good] = backup;
                        obj_ini.veh_loc[target_company][good] = obj_ini.ship_location[backup];
                        obj_ini.veh_wid[target_company][good] = 0;
                        obj_ini.ship_carrying[backup] += 1;
                    } else if ((first == -1) && (backup == -1)) {
                        obj_ini.veh_lid[target_company][good] = -1;
                        obj_ini.veh_loc[target_company][good] = "";
                        obj_ini.veh_wid[target_company][good] = 0;
                        exit;
                    }
                }
            } else {
                obj_ini.veh_loc[target_company][good] = otherdata.loc;
                if (struct_exists(otherdata, "wid")) {
                    obj_ini.veh_wid[target_company][good] = otherdata.wid;
                }
                if (struct_exists(otherdata, "lid")) {
                    obj_ini.veh_lid[target_company][good] = otherdata.lid;
                }
            }

            obj_ini.veh_role[target_company][good] = vehicle_type;

            if (weapon1 != "standard") {
                obj_ini.veh_wep1[target_company][good] = weapon1;
            }
            if (weapon2 != "standard") {
                obj_ini.veh_wep2[target_company][good] = weapon2;
            }
            if (weapon3 != "standard") {
                obj_ini.veh_wep3[target_company][good] = weapon3;
            }
            if (upgrade != "standard") {
                obj_ini.veh_upgrade[target_company][good] = upgrade;
            }
            if (accessory != "standard") {
                obj_ini.veh_acc[target_company][good] = accessory;
            }

            if ((weapon1 == "standard") && (weapon2 == "standard") && (weapon3 == "standard")) {
                if (vehicle_type == "Rhino") {
                    obj_ini.veh_wep1[target_company][good] = "Storm Bolter";
                }
                if (vehicle_type == "Whirlwind") {
                    obj_ini.veh_wep1[target_company][good] = "Whirlwind Missiles";
                }
                if (vehicle_type == "Predator") {
                    var randumb;
                    randumb = choose(1, 2);
                    if (randumb == 1) {
                        obj_ini.veh_wep1[target_company][good] = "Autocannon Turret";
                    }
                    if (randumb == 2) {
                        obj_ini.veh_wep1[target_company][good] = "Twin Linked Lascannon Turret";
                    }
                }
                if (vehicle_type == "Land Raider") {
                    var randumb = choose(1, 1, 2, 3);
                    if (randumb == 1) {
                        obj_ini.veh_wep1[target_company][good] = "Twin Linked Heavy Bolter Mount";
                        obj_ini.veh_wep2[target_company][good] = "Twin Linked Lascannon Sponsons";
                    }
                    if (randumb == 2) {
                        obj_ini.veh_wep1[target_company][good] = "Twin Linked Assault Cannon Mount";
                        obj_ini.veh_wep2[target_company][good] = "Hurricane Bolter Sponsons";
                    }
                    if (randumb == 3) {
                        obj_ini.veh_wep1[target_company][good] = "Twin Linked Assault Cannon Mount";
                        obj_ini.veh_wep2[target_company][good] = "Flamestorm Cannon Sponsons";
                    }
                }
                if (vehicle_type == "Land Speeder") {
                    obj_ini.veh_wep1[target_company][good] = "Heavy Bolter";
                    obj_ini.veh_wep2[target_company][good] = "";
                    obj_ini.veh_upgrade[target_company][good] = "";
                }
            }

            obj_ini.veh_hp[target_company][good] = 100;
            obj_ini.veh_chaos[target_company][good] = 0;
            obj_ini.veh_pilots[target_company][good] = 0;
        }

        return [target_company, good];
    } catch (_exception) {
        handle_exception(_exception);
    }
}

function destroy_vehicle(co, num) {
    try {
        obj_ini.veh_race[co][num] = 0;
        obj_ini.veh_loc[co][num] = "";
        obj_ini.veh_name[co][num] = "";
        obj_ini.veh_role[co][num] = "";
        obj_ini.veh_wep1[co][num] = "";
        obj_ini.veh_wep2[co][num] = "";
        obj_ini.veh_wep3[co][num] = "";
        obj_ini.veh_upgrade[co][num] = "";
        obj_ini.veh_acc[co][num] = "";
        obj_ini.veh_hp[co][num] = 100;
        obj_ini.veh_chaos[co][num] = 0;
        obj_ini.veh_pilots[co][num] = 0;
        obj_ini.veh_lid[co][num] = -1;
        obj_ini.veh_wid[co][num] = 0;
    } catch (_exception) {
        LOGGER.critical($"Company: {co}, Index: {num}");
        handle_exception(_exception);
    }
}
