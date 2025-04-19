try {
    if ((obj_controller.settings == 0) || (obj_controller.menu != 23)) {
        instance_destroy();
    }

    var romanNumerals = scr_roman_numerals();
    var unit;
    var unit_armour, complete;

    if (engage == true) {
        for (var co = 0; co <= obj_ini.companies; co++) {
            var i = 0;
            if (role_number[co] > 0) {
                for (i = 0; i < array_length(obj_ini.role[co]); i++) {
                    if (obj_ini.role[co][i] == obj_ini.role[100, role]) {
                        unit = fetch_unit([co, i]);
                        if (unit.squad != "none") {
                            var _squad = fetch_squad(unit.squad);
                            if (!_squad.allow_bulk_swap) {
                                continue;
                            }
                        }

                        // ** Start Armour **
                        var unit_armour = unit.get_armour_data();
                        var has_valid_armour = is_struct(unit_armour);

                        // Check if unit_armour is a struct and evaluate tag-based or name-based compatibility
                        if (has_valid_armour) {
                            switch (req_armour) {
                                case STR_ANY_POWER_ARMOUR:
                                    has_valid_armour = unit_armour.has_tag("power_armour");
                                    break;
                                case STR_ANY_TERMINATOR_ARMOUR:
                                    has_valid_armour = unit_armour.has_tag("terminator");
                                    break;
                                default:
                                    has_valid_armour = req_armour == unit_armour.name;
                            }
                        }

                        // Attempt to equip if not valid
                        if (!has_valid_armour) {
                            var result = unit.update_armour(req_armour);

                            // Fallback: If request was for Power Armour but update failed, try Terminator
                            if (result != "complete" && req_armour == STR_ANY_POWER_ARMOUR) {
                                unit.update_armour(STR_ANY_TERMINATOR_ARMOUR);
                            }

                            // Refresh unit_armour after update
                            unit_armour = unit.get_armour_data();
                        }
                        // ** End Armour **

                        // ** Start Weapons **
                        if (unit.weapon_one() != req_wep1) {
                            if (is_string(unit.weapon_one(true))) {
                                if (can_assign_weapon(unit, req_wep1)) {
                                    unit.update_weapon_two(req_wep1);
                                }
                            }
                        }
                        if (unit.weapon_two() != req_wep2) {
                            if (is_string(unit.weapon_two(true))) {
                                if (can_assign_weapon(unit, req_wep2)) {
                                    unit.update_weapon_two(req_wep2);
                                }
                            }
                        }
                        // ** Start Gear **
                        if (is_string(unit.gear(true))) {
                            unit.update_gear(req_gear);
                        }

                        // ** Start Mobility Items **
                        if (unit.mobility_item() != req_mobi) {
                            var stop_mobi = false;
                            if (unit_armour.has_tags(["terminator", "dreadnought"])) {
                                unit.update_mobility_item("");
                            } else {
                                unit.update_mobility_item(req_mobi);
                            }
                        }
                        // ** End role check **
                    }
                    // ** End this marine **
                }
                // ** End this company **
            }
            // ** End repeat **
        }
        engage = false;
    }

    // ** Refreshing **
    if ((refresh == true) && (obj_controller.settings > 0)) {
        total_role_number = 0;
        total_roles = "";
        for (var i = 0; i < 11; i++) {
            role_number[i] = 0;
        }

        var _total_role_gear = new CountingMap();

        all_equip = "";
        req_armour = "";
        req_armour_num = 0;
        have_armour_num = 0;
        req_wep1 = "";
        req_wep1_num = 0;
        have_wep1_num = 0;
        req_wep2 = "";
        req_wep2_num = 0;
        have_wep2_num = 0;
        req_gear = "";
        req_gear_num = 0;
        have_gear_num = 0;
        req_mobi = "";
        req_mobi_num = 0;
        have_mobi_num = 0;
        good1 = 0;
        good2 = 0;
        good3 = 0;
        good4 = 0;
        good5 = 0;

        req_armour = obj_ini.armour[100, role];
        req_wep1 = obj_ini.wep1[100, role];
        req_wep2 = obj_ini.wep2[100, role];
        req_gear = obj_ini.gear[100, role];
        req_mobi = obj_ini.mobi[100, role];

        for (var co = 0; co < 11; co++) {
            for (var i = 0; i < array_length(obj_ini.role[co]); i++) {
                if (obj_ini.role[co][i] == obj_ini.role[100, role]) {
                    role_number[co] += 1;

                    // Weapon1
                    var onc = 0;
                    if ((string_count("&", obj_ini.wep1[co][i]) > 0) && (onc == 0)) {
                        onc = 1;
                        have_wep1_num += 1;
                    }
                    if ((obj_ini.wep1[co][i] == req_wep1) && (onc == 0)) {
                        have_wep1_num += 1;
                        onc = 1;
                    }
                    if ((obj_ini.wep2[co][i] == req_wep1) && (onc == 0)) {
                        have_wep1_num += 1;
                        onc = 1;
                    }

                    // Weapon2
                    onc = 0;
                    if ((string_count("&", obj_ini.wep2[co][i]) > 0) && (onc == 0)) {
                        onc = 1;
                        have_wep2_num += 1;
                    }
                    if ((obj_ini.wep1[co][i] == req_wep2) && (onc == 0)) {
                        have_wep2_num += 1;
                        onc = 1;
                    }
                    if ((obj_ini.wep2[co][i] == req_wep2) && (onc == 0)) {
                        have_wep2_num += 1;
                        onc = 1;
                    }

                    if (req_armour != "") {
                        var yes = false;

                        if (req_armour == STR_ANY_POWER_ARMOUR) {
                            if (array_contains(ARR_basic_power_armour, obj_ini.armour[co][i])) {
                                yes = true;
                            }
                        } else if (req_armour == STR_ANY_TERMINATOR_ARMOUR) {
                            if (array_contains(ARR_terminator_armour, obj_ini.armour[co][i])) {
                                yes = true;
                            }
                        }

                        if (string_count("&", obj_ini.armour[co][i]) > 0) {
                            yes = true;
                        } else if (obj_ini.armour[co][i] == req_armour) {
                            yes = true;
                        }

                        if (yes == true) {
                            have_armour_num += 1;
                        }
                    }

                    if (req_gear != "") {
                        if (string_count("&", obj_ini.gear[co][i]) == 0) {
                            if (obj_ini.gear[co][i] == req_gear) {
                                have_gear_num += 1;
                            }
                        }
                    }

                    if (req_mobi != "") {
                        if (string_count("&", obj_ini.mobi[co][i]) == 0) {
                            if (obj_ini.mobi[co][i] == req_mobi) {
                                have_mobi_num += 1;
                            }
                        }
                    }
                }

                if (obj_ini.role[co][i] == obj_ini.role[100, role]) {
                    _total_role_gear.add(obj_ini.wep1[co][i]);
                    _total_role_gear.add(obj_ini.wep2[co][i]);
                    _total_role_gear.add(obj_ini.armour[co][i]);
                    _total_role_gear.add(obj_ini.gear[co][i]);
                    _total_role_gear.add(obj_ini.mobi[co][i]);
                }
            }
        }

        have_wep1_num += scr_item_count(req_wep1);
        have_wep2_num += scr_item_count(req_wep2);

        if (req_armour == STR_ANY_POWER_ARMOUR) {
            for (var g = 0; g < array_length(ARR_basic_power_armour); g++) {
                have_armour_num += scr_item_count(ARR_basic_power_armour[g]);
            }
        } else if (req_armour == STR_ANY_TERMINATOR_ARMOUR) {
            for (var g = 0; g < array_length(ARR_terminator_armour); g++) {
                have_armour_num += scr_item_count(ARR_terminator_armour[g]);
            }
        } else {
            have_armour_num += scr_item_count(req_armour);
        }

        have_gear_num += scr_item_count(req_gear);
        have_mobi_num += scr_item_count(req_mobi);

        total_role_number = 0;

        for (var i = 0; i < 11; i++) {
            if (role_number[i] > 0) {
                req_wep1_num += role_number[i];
                req_wep2_num += role_number[i];
                req_armour_num += role_number[i];
                req_gear_num += role_number[i];
                req_mobi_num += role_number[i];
                total_role_number += role_number[i];
            }
        }
        total_roles = "";
        if (total_role_number > 0) {
            total_roles = $"You currently have {total_role_number}x {obj_ini.role[100, role]} across all companies.";
            for (var i = 0; i < 11; i++) {
                var _company_name = i == 0 ? "HQ" : $"{romanNumerals[i - 1]} Company";

                if ((role_number[i] > 0)) {
                    total_roles += $" {_company_name}: {role_number[i]};";
                }
            }
        }

        // Add up messages
        all_equip = $"In total they are equipped with: {_total_role_gear.get_total_string()}.";

        refresh = false;

        if (tab > 0) {
            item_name = [];
            var is_hand_slot = tab == 1 || tab == 2;
            scr_get_item_names(
                item_name,
                obj_controller.settings, // eROLE
                tab, // slot
                is_hand_slot ? eENGAGEMENT.Any : eENGAGEMENT.None,
                true, // include company standard
                false, // show all regardless of inventory

            );
        }

        good1 = 0;
        good2 = 0;
        good3 = 0;
        good4 = 0;
        good5 = 0;

        if ((req_wep1_num <= have_wep1_num) || (req_wep1 == "")) {
            good1 = 1;
        }
        if ((req_wep2_num <= have_wep2_num) || (req_wep2 == "")) {
            good2 = 1;
        }
        if ((req_armour_num <= have_armour_num) || (req_armour == "")) {
            good3 = 1;
        }
        if ((req_gear_num <= have_gear_num) || (req_gear == "")) {
            good4 = 1;
        }
        if ((req_mobi_num <= have_mobi_num) || (req_mobi == "")) {
            good5 = 1;
        }
    }
} catch (_exception) {
    handle_exception(_exception);
    obj_controller.menu = 21;
    obj_controller.settings = 0;
    instance_destroy();
}

function can_assign_weapon(unit, weapon_name) {
    switch (weapon_name) {
        case "Assault Cannon":
            return unit.get_armour_data().has_tag("terminator");
        default:
            return true;
    }
}
