try {
    if ((obj_controller.settings == 0) || (obj_controller.menu != 23)) {
        instance_destroy();
    }

    if (engage == true) {
        for (var i = 0; i < STANDARD_EQUIP_SLOT_COUNT; i++){
            var _tag = equipment_tag_key_from_value(equipment_set[i]);
            if (_tag != ""){
                equipment_set[i] = new TagSetItems(_tag);
                equipment_set[i].create_item_map();
            }
        }
        for (var i = 0; i < array_length(marines_with_role.units); i++) {
            var _unit = marines_with_role.units[i];
            if (_unit.squad != "none") {
                var _squad = fetch_squad(_unit.squad);
                if (!_squad.allow_bulk_swap) {
                    continue;
                }
            }
            _unit.alter_equipment(equipment_set);
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
            for (var i = 0; i <= obj_ini.companies; i++) {
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
