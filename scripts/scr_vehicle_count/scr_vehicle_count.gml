// Counts the number of total vehicles for the player
// TODO this should be function defined in Chapter struct, or something similar
function scr_vehicle_count(role, star_system_num) {

    var vehicle_count = 0,
        company_number = 0,
        company_number_derived_from_star_system_num = -999; // TODO refactor star_system_num to actually represent something logical

    switch (star_system_num) {
        case "0":
            company_number_derived_from_star_system_num = 0;
            break;
        case "1":
            company_number_derived_from_star_system_num = 1;
            break;
        case "2":
            company_number_derived_from_star_system_num = 2;
            break;
        case "3":
            company_number_derived_from_star_system_num = 3;
            break;
        case "4":
            company_number_derived_from_star_system_num = 4;
            break;
        case "5":
            company_number_derived_from_star_system_num = 5;
            break;
        case "6":
            company_number_derived_from_star_system_num = 6;
            break;
        case "7":
            company_number_derived_from_star_system_num = 7;
            break;
        case "8":
            company_number_derived_from_star_system_num = 8;
            break;
        case "9":
            company_number_derived_from_star_system_num = 9;
            break;
        case "10":
            company_number_derived_from_star_system_num = 10;
            break;
        default:
            company_number_derived_from_star_system_num = 0; // Assign 0, it avoids crashing the game when nothing is selected
            break;
    }

    if (company_number_derived_from_star_system_num < 0) {
        for (var j = 0; j < 11; j++) {
            for (var i = 1; i <= 100; i++) {
                if (obj_ini.veh_role[company_number, i] == role) and (star_system_num == "") then vehicle_count++;
                if (obj_ini.veh_role[company_number, i] == role) and (obj_ini.veh_loc[company_number, i] == obj_ini.home_name) and (star_system_num == "home") then vehicle_count++;
                if (obj_ini.veh_role[company_number, i] == role) and (star_system_num == "field") and ((obj_ini.loc[company_number, i] != obj_ini.home_name) or (obj_ini.veh_lid[company_number, i] > -1)) then vehicle_count++;

                if (star_system_num != "home") and(star_system_num != "field") {
                    if (obj_ini.veh_role[company_number, i] == role) {
                        var t1 = string(obj_ini.veh_loc[company_number, i]) + "|" + string(obj_ini.veh_wid[company_number, i]) + "|";
                        if (star_system_num == t1) then vehicle_count++;
                    }
                }
            }
            company_number++;
        }
    } else {
        company_number = company_number_derived_from_star_system_num;

        for (var i = 1; i <= 100; i++) {
            if (obj_ini.veh_role[company_number, i] == role) then vehicle_count++;
        }
        company_number++;
    }
    return (vehicle_count);
}
