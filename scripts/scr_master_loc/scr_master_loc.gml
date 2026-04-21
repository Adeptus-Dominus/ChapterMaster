function scr_master_loc() {
    var lick = "";
    var good = true;
    var co = 0;
    var v = 0;
    var unit;

    for (var i = 0; i < 3600; i++) {
        if (good == true) {
            if (co < 11) {
                v += 1;
                if (v > 300) {
                    co += 1;
                    v = 1; /*show_message("mahreens at the start of company "+string(co)+" is equal to "+string(info_mahreens));*/
                }
                if (co > 10) {
                    good = false;
                }
                if (good == true) {
                    if (obj_ini.name[co][v] == "") {
                        continue;
                    }
                    unit = fetch_unit([co, v]);
                    if (unit.role() == obj_ini.role[100][eROLE.CHAPTERMASTER]) {
                        if ((unit.planet_location > 0) && (unit.ship_location < 0)) {
                            lick = $"{unit.location_string}." + string(unit.planet_location);
                        }
                        if ((unit.planet_location <= 0) && (unit.ship_location > -1)) {
                            lick = string(obj_ini.ship[unit.ship_location]);
                        }
                        if (lick != "") {
                            good = false;
                            return lick;
                        }
                    }
                }
            }
        }
    }
}
