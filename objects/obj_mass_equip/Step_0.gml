try {
    if ((obj_controller.settings == 0) || (obj_controller.menu != 23)) {
        instance_destroy();
    }

    var _list_basic_armour = global.list_basic_power_armour;
    var _list_term_armour = global.list_terminator_armour;

    if (engage == true) {
        var _done_squad_sergeants = {};
        for (var co = 0; co <= obj_ini.companies; co++) {
            if (role_number[co] > 0) {
                for (var i = 0; i < array_length(obj_ini.role[co]); i++) {
                    if (obj_ini.role[co][i] == obj_ini.role[100][role]) {
                        var _unit = fetch_unit([co, i]);
                        var _squad = undefined;
                        if (_unit.squad != "none") {
                            _squad = fetch_squad(_unit.squad);
                            if (!_squad.allow_bulk_swap) {
                                continue;
                            }
                        }

                        apply_gear(_unit);

                        // Equip this squad's Sergeant with the same kit, once per squad.
                        // The Sergeant (role slot 18) or Veteran Sergeant (19) carries a
                        // different role than the base role this loop keys on, so leaders
                        // were being skipped: their battle brothers got the mass equip and
                        // they did not. Only runs for bulk-swappable squads, same as above.
                        if (is_struct(_squad) && !variable_struct_exists(_done_squad_sergeants, _unit.squad)) {
                            _done_squad_sergeants[$ _unit.squad] = true;
                            var _sgt_role = obj_ini.role[100][18];
                            var _vet_sgt_role = obj_ini.role[100][19];
                            var _members = _squad.members;
                            for (var _m = 0; _m < array_length(_members); _m++) {
                                var _member = fetch_unit(_members[_m]);
                                if (is_struct(_member) && ((_member.role() == _sgt_role) || (_member.role() == _vet_sgt_role))) {
                                    apply_gear(_member);
                                }
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

        req_armour = obj_ini.armour[100][role];
        req_wep1 = obj_ini.wep1[100][role];
        req_wep2 = obj_ini.wep2[100][role];
        req_gear = obj_ini.gear[100][role];
        req_mobi = obj_ini.mobi[100][role];

        for (var co = 0; co < 11; co++) {
            for (var i = 0; i < array_length(obj_ini.role[co]); i++) {
                if (obj_ini.role[co][i] == obj_ini.role[100][role]) {
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
                            if (array_contains(_list_basic_armour, obj_ini.armour[co][i])) {
                                yes = true;
                            }
                        } else if (req_armour == STR_ANY_TERMINATOR_ARMOUR) {
                            if (array_contains(_list_term_armour, obj_ini.armour[co][i])) {
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

                if (obj_ini.role[co][i] == obj_ini.role[100][role]) {
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
            var _role_name = obj_ini.role[100][role];
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
