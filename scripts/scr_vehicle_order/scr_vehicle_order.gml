// This sorts and crunches the vehicle variables into order for that company

function reset_vehicle_variable_arrays(company_number,i){
    veh_race[company_number][i] = 0;
    veh_loc[company_number][i] = "";
    veh_name[company_number][i] = "";
    veh_role[company_number][i] = "";
    veh_lid[company_number][i] = -1;
    veh_wid[company_number][i] = 0;
    veh_wep1[company_number][i] = "";
    veh_wep2[company_number][i] = "";
    veh_wep3[company_number][i] = "";
    veh_upgrade[company_number][i] = "";
    veh_acc[company_number][i] = "";
    veh_hp[company_number][i] = 100;
    veh_chaos[company_number][i] = 0;
    veh_uid[company_number][i] = -1;
}
function scr_vehicle_order(company_number) {
    // Once it's actually fucking working it should probably join the scr_company_order script in the Interface folder
    var vehicle_count = 0;
    var temp_race, temp_loc, temp_name, temp_role, temp_wep1, temp_lid, temp_wid, temp_wep2, temp_wep3, temp_upgrade, temp_acc, temp_hp, temp_chaos, temp_uid;

    // init arrays
    for (var i = 0; i < 301; i++) { // TODO why 301?
        temp_race[company_number][i] = 0;
        temp_loc[company_number][i] = "";
        temp_name[company_number][i] = "";
        temp_role[company_number][i] = "";
        temp_lid[company_number][i] = -1;
        temp_wid[company_number][i] = 0;
        temp_wep1[company_number][i] = "";
        temp_wep2[company_number][i] = "";
        temp_wep3[company_number][i] = "";
        temp_upgrade[company_number][i] = "";
        temp_acc[company_number][i] = "";
        temp_hp[company_number][i] = 100;
        temp_chaos[company_number][i] = 0;
        temp_uid[company_number][i] = 0;
    }

	// Check for vehicles
    for (var i = 1; i <= 150; i++) { // TODO why 150?
        var _is_vehicle_role =
        	veh_role[company_number][i] = "Rhino" // TODO change to enums/string ids
        	|| veh_role[company_number][i] = "Predator"
        	|| veh_role[company_number][i] = "Whirlwind"
        	|| veh_role[company_number][i] = "Land Speeder"
        	|| veh_role[company_number][i] = "Land Raider";

        if (_is_vehicle_role) {
            vehicle_count++;
            temp_race[company_number, vehicle_count] = veh_race[company_number][i];
            temp_loc[company_number, vehicle_count] = veh_loc[company_number][i];
            temp_name[company_number, vehicle_count] = veh_name[company_number][i];
            temp_role[company_number, vehicle_count] = veh_role[company_number][i];
            temp_lid[company_number, vehicle_count] = veh_lid[company_number][i];
            temp_wid[company_number, vehicle_count] = veh_wid[company_number][i];
            temp_wep1[company_number, vehicle_count] = veh_wep1[company_number][i];
            temp_wep2[company_number, vehicle_count] = veh_wep2[company_number][i];
            temp_wep3[company_number, vehicle_count] = veh_wep3[company_number][i];
            temp_upgrade[company_number, vehicle_count] = veh_upgrade[company_number][i];
            temp_acc[company_number, vehicle_count] = veh_acc[company_number][i];
            temp_hp[company_number, vehicle_count] = veh_hp[company_number][i];
            temp_chaos[company_number, vehicle_count] = veh_chaos[company_number][i];
            temp_uid[company_number, vehicle_count] = veh_uid[company_number][i];

            reset_vehicle_variable_arrays(company_number,i);
        }
    }

    // do the ordering
    for (var i = 1; i <= vehicle_count; i++) { // TODO why 150?
        veh_race[company_number][i] = temp_race[company_number][i];
        veh_loc[company_number][i] = temp_loc[company_number][i];
        veh_name[company_number][i] = temp_name[company_number][i];
        veh_role[company_number][i] = temp_role[company_number][i];
        veh_lid[company_number][i] = temp_lid[company_number][i];
        veh_wid[company_number][i] = temp_wid[company_number][i];
        veh_wep1[company_number][i] = temp_wep1[company_number][i];
        veh_wep2[company_number][i] = temp_wep2[company_number][i];
        veh_wep3[company_number][i] = temp_wep3[company_number][i];
        veh_upgrade[company_number][i] = temp_upgrade[company_number][i];
        veh_acc[company_number][i] = temp_acc[company_number][i];
        veh_hp[company_number][i] = temp_hp[company_number][i];
        veh_chaos[company_number][i] = temp_chaos[company_number][i];
        veh_uid[company_number][i] = temp_uid[company_number][i];
    }
}