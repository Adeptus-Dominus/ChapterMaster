function scr_bionics_count(argument0, argument1, argument2, argument3) {
    // argument0: "star" or "ship" or "all"
    // argument1: name or all
    // argument2: planet number
    // argument3: "total" or "number" - total or number of marines WITH bionics

    var com, i, count, coom;
    count = 0;
    i = 0;
    com = 0;
    coom = -999;

    repeat (11) {
        i = 0;
        repeat (300) {
            i += 1;
            var _unit = fetch_unit([com, i]);
            if (argument0 == "star") {
                if ((obj_ini.race[com][i] == 1) && (_unit.location_string == argument1) && (_unit.planet_location == argument2)) {
                    if (argument3 == "total") {
                        count += _unit.bionics;
                    }
                    if ((argument3 == "number") && (_unit.bionics > 0)) {
                        count += 1;
                    }
                }
            }
        }
        com += 1;
    }

    return count;

    // temp[36]=scr_role_count("Chaplain","field");
    // temp[37]=scr_role_count("Chaplain","home");
    // temp[37]=scr_role_count("Chaplain","");
}
