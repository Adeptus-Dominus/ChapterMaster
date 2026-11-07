try {
    if ((obj_controller.settings == 0) || (obj_controller.menu != 23)) {
        instance_destroy();
    }

    var _list_basic_armour = global.list_basic_power_armour;
    var _list_term_armour = global.list_terminator_armour;

    if (engage == true) {
        marines_with_role.for_each(function(_unit){

        });
        for (var co = 0; co <= obj_ini.companies; co++) {
            if (role_number[co] > 0) {
                for (var i = 0; i < array_length(obj_ini.TTRPG[co]); i++) {
                    var _unit = fetch_unit([co, i]);
                    if (!is_struct(_unit)) {
                        continue;
                    }
                    if (!_unit.has_role(role)) {
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

        var _cur_role = obj_ini.player_role_data[role];
        req_armour = _cur_role.armour;
        req_wep1 = _cur_role.wep1;
        req_wep2 = _cur_role.wep2;
        req_gear = _cur_role.gear;
        req_mobi = _cur_role.mobi;

        equipment_set = [req_wep1,req_wep2,req_armour,req_gear,req_mobi];
        var _equip_data = new UnitEquipment(equipment_set);
        all_good = _equip_data.check_set_is_equipable(marines_with_role.number(), marines_with_role.units);


        if (marines_with_role.number() > 0) {
            var _role_name = obj_ini.player_role_data[role].role;
            total_roles = $"You currently have {marines_with_role.number()}x {_role_name} across all companies.";
            for (var i = 0; i < obj_ini.companies; i++) {
                var romanNumerals = scr_roman_numerals();
                var _company_name = i == 0 ? "HQ" : $"{romanNumerals[i - 1]} Company";

                var _marines_in_company = marines_with_role.get_from({company : i})
                if (_marines_in_company.number() > 0) {
                    total_roles += $" {_company_name}: {_marines_in_company.number()};";
                }
            }
        }

        // Add up messages
        _total_role_gear = marines_with_role.tally_equipment();
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

    }
} catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
    obj_controller.menu = 21;
    obj_controller.settings = 0;
    instance_destroy();
}
