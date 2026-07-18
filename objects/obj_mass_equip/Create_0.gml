tab = -1;
role = obj_controller.settings;
refresh = true;
engage = false;

total_role_number = 0;
total_roles = "";

role_number = [];

armour_equip = "";
wep1_equip = "";
wep2_equip = "";
mobi_equip = "";
gear_equip = "";
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

item_name = [];

cancel_button = new UnitButtonObject({
    x1: 1347,
    y1: 721,
    style: "pixel",
    label: "CANCEL",
    font: fnt_40k_14b,
    color: c_gray,
});

//TODO get rid oof this and use weapon tags instead
/// @param {Struct.TTRPG_stats} unit
/// @param {string} weapon_name
can_assign_weapon = function(unit, weapon_name) {
    switch (weapon_name) {
        case "Assault Cannon":
            var _armour = unit.get_armour_data();
            return is_struct(_armour) && _armour.has_tag("terminator");
        default:
            return true;
    }
};

/// @desc Apply the current mass-equip requirement (req_armour/wep1/wep2/gear/mobi) to one
/// unit. Factored out of the engage loop so both a matched marine and its squad's Sergeant
/// can be equipped by the same code. Artifact/non-standard weapons are left alone (the
/// is_string / can_assign_weapon guards), so a Sergeant keeps a special weapon he can't
/// swap while still receiving the same armour and standard kit as his squad.
apply_gear = function(_unit) {
    var _list_basic_armour = global.list_basic_power_armour;
    var _list_term_armour = global.list_terminator_armour;

    // ** Armour **
    var unit_armour = _unit.get_armour_data();
    var has_valid_armour = is_struct(unit_armour);
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
    if (!has_valid_armour) {
        var result = _unit.update_armour(req_armour);
        if (result != "complete" && req_armour == STR_ANY_POWER_ARMOUR) {
            _unit.update_armour(STR_ANY_TERMINATOR_ARMOUR);
        }
        unit_armour = _unit.get_armour_data();
    }

    // ** Weapons **
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

    // ** Gear **
    if (is_string(_unit.gear(true))) {
        _unit.update_gear(req_gear);
    }

    // ** Mobility **
    if (_unit.mobility_item() != req_mobi) {
        var _forbidden_tags = [
            "terminator",
            "dreadnought"
        ];
        if (is_struct(unit_armour) && unit_armour.has_tags(_forbidden_tags)) {
            _unit.update_mobility_item("");
        } else {
            _unit.update_mobility_item(req_mobi);
        }
    }
};
