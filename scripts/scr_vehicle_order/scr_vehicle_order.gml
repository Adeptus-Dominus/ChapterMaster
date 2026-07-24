// This sorts and crunches the vehicle variables into order for that company

/// @self Asset.GMObject.obj_ini
function reset_vehicle_variable_arrays(company_number, i) {
    veh_race[company_number][i] = 0;
    veh_loc[company_number][i] = "";
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
    last_ship[company_number][i] = {
        uid: "",
        name: "",
    };
}

/// @self Asset.GMObject.obj_ini
function scr_vehicle_order(company_number) {
    // Once it's actually fucking working it should probably join the scr_company_order script in the Interface folder
    var vehicle_count = 0;
    var temp_race, temp_loc, temp_name, temp_role, temp_wep1, temp_lid, temp_wid, temp_wep2, temp_wep3, temp_upgrade, temp_acc, temp_hp, temp_chaos, temp_uid, temp_last_ship;

    // init arrays
    for (var i = 0; i < array_length(obj_ini.veh_role[company_number]); i++) {
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
        temp_uid[company_number][i] = -1;
        temp_last_ship[company_number][i] = {
            uid: "",
            name: "",
        };
    }

    // Check for vehicles
    for (var i = 0; i < array_length(obj_ini.veh_role[company_number]); i++) {
        var _is_vehicle_role =
            veh_role[company_number][i] == "Rhino" // TODO change to enums/string ids
            || veh_role[company_number][i] == "Predator"
            || veh_role[company_number][i] == "Whirlwind"
            || veh_role[company_number][i] == "Land Speeder"
            || veh_role[company_number][i] == "Land Raider"
            || veh_role[company_number][i] == "Chimera"
            || veh_role[company_number][i] == "Leman Russ"
            || veh_role[company_number][i] == "Basilisk";

        if (_is_vehicle_role) {
            temp_race[company_number][vehicle_count] = veh_race[company_number][i];
            temp_loc[company_number][vehicle_count] = veh_loc[company_number][i];
            temp_role[company_number][vehicle_count] = veh_role[company_number][i];
            temp_lid[company_number][vehicle_count] = veh_lid[company_number][i];
            temp_wid[company_number][vehicle_count] = veh_wid[company_number][i];
            temp_wep1[company_number][vehicle_count] = veh_wep1[company_number][i];
            temp_wep2[company_number][vehicle_count] = veh_wep2[company_number][i];
            temp_wep3[company_number][vehicle_count] = veh_wep3[company_number][i];
            temp_upgrade[company_number][vehicle_count] = veh_upgrade[company_number][i];
            temp_acc[company_number][vehicle_count] = veh_acc[company_number][i];
            temp_hp[company_number][vehicle_count] = veh_hp[company_number][i];
            temp_chaos[company_number][vehicle_count] = veh_chaos[company_number][i];
            temp_uid[company_number][vehicle_count] = veh_uid[company_number][i];
            // Carry the vehicle's last-ship record through the compaction. It was dropped
            // here, so after any battle with vehicle losses every surviving vehicle's
            // Reembark record pointed at the wrong slot (or a cleared one).
            temp_last_ship[company_number][vehicle_count] = ((company_number < array_length(last_ship)) && (i < array_length(last_ship[company_number])))
                ? last_ship[company_number][i]
                : {uid: "", name: ""};
            vehicle_count++;
        }
        reset_vehicle_variable_arrays(company_number, i);
    }

    // do the ordering
    for (var i = 0; i < vehicle_count; i++) {
        veh_race[company_number][i] = temp_race[company_number][i];
        veh_loc[company_number][i] = temp_loc[company_number][i];
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
        last_ship[company_number][i] = temp_last_ship[company_number][i];
    }
}
