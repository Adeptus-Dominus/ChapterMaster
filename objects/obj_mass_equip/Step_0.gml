try {
    if ((obj_controller.settings == 0) || (obj_controller.menu != 23)) {
        instance_destroy();
    }

    var _list_basic_armour = global.list_basic_power_armour;
    var _list_term_armour = global.list_terminator_armour;

    if (engage == true) {
        for (var co = 0; co <= obj_ini.companies; co++) {
            if (role_number[co] > 0) {
                for (var i = 0; i < array_length(obj_ini.TTRPG[co]); i++) {
                    var _unit = fetch_unit([co, i]);
                    if (!is_struct(_unit)) {
                        continue;
                    }
                    if (!role_compare(_unit, role)) {
                        continue;
                    }
                    if (_unit.squad != "none") {
                        var _squad = fetch_squad(_unit.squad);
                        if (!_squad.allow_bulk_swap) {
                            continue;
                        }
                    }

                    // ** Start Armour **
                    var unit_armour = _unit.get_armour_data();
                    var has_valid_armour = is_struct(unit_armour);

                    // Check if unit_armour is a struct and evaluate tag-based or name-based compatibility
                    if (has_valid_armour) {
                        switch (req_armour) {
                            case STR_ANY_POWER_ARMOUR:
                                has_valid_armour = array_contains(_list_basic_armour, unit_armour.name);
                                break;
                            case STR_ANY_TERMINATOR_ARMOUR:
                                has_valid_armour = array_contains(_list_term_armour, unit_armour.name);
                                break;
                            default:
                                has_valid_armour = req_armour == unit_armour.name;
                        }
                    }

                    // Attempt to equip if not valid
                    if (!has_valid_armour) {
                        var result = _unit.update_armour(req_armour);

                        // Fallback: If request was for Power Armour but update failed, try Terminator
                        if (result != "complete" && req_armour == STR_ANY_POWER_ARMOUR) {
                            _unit.update_armour(STR_ANY_TERMINATOR_ARMOUR);
                        }

                        // Refresh unit_armour after update
                        unit_armour = _unit.get_armour_data();
                    }
                    // ** End Armour **

                    // ** Start Weapons **
                    if (_unit.weapon_one() != req_wep1) {
                        if (is_string(_unit.weapon_one(true))) {
                            if (can_assign_weapon(_unit, req_wep1)) {
                                _unit.update_weapon_one(req_wep1);
                            }
                        }
                    }
                    if (_unit.weapon_two() != req_wep2) {
                        if (is_string(_unit.weapon_two(true))) {
                            if (can_assign_weapon(_unit, req_wep2)) {
                                _unit.update_weapon_two(req_wep2);
                            }
                        }
                    }
                    // ** Start Gear **
                    if (is_string(_unit.gear(true))) {
                        _unit.update_gear(req_gear);
                    }

                    // ** Start Mobility Items **
                    if (_unit.mobility_item() != req_mobi) {
                        var _forbidden_tags = [
                            "terminator",
                            "dreadnought",
                        ];
                        if (is_struct(unit_armour) && unit_armour.has_tags(_forbidden_tags)) {
                            _unit.update_mobility_item("");
                        } else {
                            _unit.update_mobility_item(req_mobi);
                        }
                    }
                    // ** End role check **
                }
                // ** End this marine **
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

        var _cur_role = obj_ini.player_role_data[role];

        req_armour = _cur_role.armour;
        req_wep1 = _cur_role.wep1;
        req_wep2 = _cur_role.wep2;
        req_gear = _cur_role.gear;
        req_mobi = _cur_role.mobi;

        for (var co = 0; co < 11; co++) {
            for (var i = 0; i < array_length(obj_ini.TTRPG[co]); i++) {
                var _unit = fetch_unit([co, i]);
                if (_unit.role() != _cur_role.role) {
                    continue;
                }
                role_number[co]++;

                var _wep_one_found = false;
                // Weapon1
                var _wep1 = _unit.weapon_one(true);
                if (is_struct(_wep1) || _wep1 == req_wep1) {
                    have_wep1_num++;
                    _wep_one_found = true;
                }

                var _wep2 = _unit.weapon_two(true);
                if (is_struct(_wep2) || _wep2 == req_wep1 && !_wep_one_found) {
                    have_wep1_num++;
                }

                var _wep_two_found = false;
                if (is_struct(_wep1) || _wep1 == req_wep1) {
                    have_wep2_num++;
                    _wep_two_found = true;
                }

                if (is_struct(_wep2) || _wep2 == req_wep1 && !_wep_two_found) {
                    have_wep2_num++;
                }

                var _armour = _unit.armour();
                if (req_armour != "") {
                    var yes = false;

                    if (req_armour == STR_ANY_POWER_ARMOUR) {
                        if (array_contains(_list_basic_armour, _armour)) {
                            yes = true;
                        }
                    } else if (req_armour == STR_ANY_TERMINATOR_ARMOUR) {
                        if (array_contains(_list_term_armour, _armour)) {
                            yes = true;
                        }
                    }

                    if (string_count("&", _armour) > 0) {
                        yes = true;
                    } else if (_armour == req_armour) {
                        yes = true;
                    }

                    if (yes == true) {
                        have_armour_num += 1;
                    }
                }

                var _gear = _unit.gear();
                if (req_gear != "") {
                    if (string_count("&", _gear) == 0) {
                        if (_gear == req_gear) {
                            have_gear_num += 1;
                        }
                    }
                }

                var _mobi = _unit.mobility_item();
                if (req_mobi != "") {
                    if (string_count("&", _mobi) == 0) {
                        if (_mobi == req_mobi) {
                            have_mobi_num += 1;
                        }
                    }
                }

                var _slots = [
                    _unit.weapon_one(),
                    _unit.weapon_two(),
                    _unit.armour(),
                    _unit.gear(),
                    _unit.mobility_item(),
                ];
                for (var s = 0; s < array_length(_slots); s++) {
                    if (!is_real(_slots[s])) {
                        _total_role_gear.add(_slots[s]);
                    }
                }
            }
        }

        have_wep1_num += scr_item_count(req_wep1);
        have_wep2_num += scr_item_count(req_wep2);

        if (req_armour == STR_ANY_POWER_ARMOUR) {
            for (var g = 0; g < array_length(_list_basic_armour); g++) {
                have_armour_num += scr_item_count(_list_basic_armour[g]);
            }
        } else if (req_armour == STR_ANY_TERMINATOR_ARMOUR) {
            for (var g = 0; g < array_length(_list_term_armour); g++) {
                have_armour_num += scr_item_count(_list_term_armour[g]);
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
            var _role_name = obj_ini.player_role_data[role].role;
            total_roles = $"You currently have {total_role_number}x {_role_name} across all companies.";
            for (var i = 0; i < 11; i++) {
                var romanNumerals = scr_roman_numerals();
                var _company_name = i == 0 ? "HQ" : $"{romanNumerals[i - 1]} Company";

                if (role_number[i] > 0) {
                    total_roles += $" {_company_name}: {role_number[i]};";
                }
            }
        }

        // Add up messages
        var _totals_string = _total_role_gear.get_custom_string(function(_key, _count, _i, _keys) {
            return $"{_count}x {_key}{smart_delimeter_sign(_keys, _i, false)}";
        });
        if (_totals_string != "") {
            all_equip = $"In total they are equipped with: {_totals_string}.";
        }

        refresh = false;

        if (tab > -1) {
            item_name = [];
            var is_hand_slot = tab == 0 || tab == 1;
            scr_get_item_names(item_name, obj_controller.settings, tab, is_hand_slot ? eENGAGEMENT.ANY : eENGAGEMENT.NONE, true, false);
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
    ERROR_HANDLER.handle_exception(_exception);
    obj_controller.menu = 21;
    obj_controller.settings = 0;
    instance_destroy();
}
