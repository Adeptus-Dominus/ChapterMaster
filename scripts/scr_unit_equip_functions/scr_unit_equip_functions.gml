// TODO: Merge all update function into one;
/// @self Struct.TTRPG_stats
function scr_update_unit_armour(new_armour, from_armoury = true, to_armoury = true, quality = "any") {
    var is_artifact = !is_string(new_armour);
    var artifact_id = 0;
    var _old_armour = armour();
    var armour_list = [];
    var same_quality = quality == "any" || quality == armour_quality;
    var unequipping = new_armour == "";

    if (is_artifact) {
        artifact_id = new_armour;
        var _arti = fetch_artifact(artifact_id);
        new_armour = _arti.get_type_name();
    }

    if (is_artifact && armour(true) == artifact_id) {
        return "no change";
    }

    if (new_armour == STR_ANY_POWER_ARMOUR) {
        armour_list = global.list_basic_power_armour;
    } else if (new_armour == STR_ANY_TERMINATOR_ARMOUR) {
        armour_list = global.list_terminator_armour;
    }

    if (array_length(armour_list) > 0) {
        if (from_armoury) {
            var armour_found = false;
            for (var pa = 0; pa < array_length(armour_list); pa++) {
                if (scr_item_count(armour_list[pa]) > 0) {
                    new_armour = armour_list[pa];
                    armour_found = true;
                    break;
                }
            }
            if (!armour_found) {
                return "no_items";
            }
        } else {
            new_armour = array_random_element(armour_list);
        }
    }

    var _new_armour_data = gear_weapon_data("armour", new_armour);
    var _old_armour_data = gear_weapon_data("armour", _old_armour);

    if (!is_struct(_new_armour_data) && !is_artifact && !unequipping) {
        return "invalid item";
    }

    if (is_struct(_old_armour_data)) {
        if ((array_contains(global.list_basic_power_armour, _old_armour_data.name) && new_armour == STR_ANY_POWER_ARMOUR) && same_quality) {
            return "no change";
        }

        if ((array_contains(global.list_terminator_armour, _old_armour_data.name) && new_armour == STR_ANY_TERMINATOR_ARMOUR) && same_quality) {
            return "no change";
        }
    }

    if ((_old_armour == new_armour) && same_quality && !is_artifact && is_string(armour(true))) {
        return "no change";
    }

    if (is_struct(_new_armour_data)) {
        var require_carapace = _new_armour_data.has_tag("power_armour") || _new_armour_data.has_tag("terminator");
        if (require_carapace && !get_body_data("black_carapace", "torso")) {
            return "needs_carapace";
        }
    }

    if (from_armoury && !unequipping && !is_artifact && is_struct(_new_armour_data)) {
        if (scr_item_count(new_armour, quality) > 0) {
            if (_new_armour_data.req_exp > experience) {
                return "exp_low";
            }
            quality = scr_add_item(new_armour, -1, quality);
            if (quality == "no_item") {
                return "no_items";
            }
            quality = quality != undefined ? quality : "standard";
        } else {
            return "no_items";
        }
    } else {
        quality = (quality == "any") ? "standard" : quality;
    }

    if (_old_armour != "") {
        if (!is_string(armour(true))) {
            var _old_arti = fetch_artifact(armour(true));
            _old_arti.clear_bearer();
        } else if (to_armoury) {
            scr_add_item(_old_armour, 1, armour_quality);
        }
    }

    var portion = hp_portion();
    armour1 = is_artifact ? artifact_id : new_armour;

    if (is_artifact) {
        var arti_struct = fetch_artifact(artifact_id);
        arti_struct.set_bearer(self);
        armour_quality = "artifact";
    } else {
        armour_quality = quality;
    }
    var new_arm_data = get_armour_data();
    if (is_struct(new_arm_data)) {
        if (new_arm_data.has_tag("terminator")) {
            var _cur_mobility_data = gear_weapon_data("mobility", mobility_item());
            if (is_struct(_cur_mobility_data) && !_cur_mobility_data.has_tag("terminator") && !_cur_mobility_data.has_tag("terminator_only")) {
                update_mobility_item("");
            }
        }

        if (new_arm_data.has_tag("dreadnought")) {
            is_boarder = false;
            remove_from_squad();
            update_role(obj_ini.player_role_data[eROLE.DREADNOUGHT].role);
            update_gear("");
            update_mobility_item("");
        }
    }

    update_health(portion * max_health());
    get_unit_size(); // See if marine’s size changed

    return "complete";
}

/// @self Struct.TTRPG_stats
function scr_update_unit_weapon_one(new_weapon, from_armoury = true, to_armoury = true, quality = "any") {
    var is_artifact = !is_string(new_weapon);
    var artifact_id = 0;
    var change_wep = weapon_one();
    var unequipping = new_weapon == "";
    var weapon_list = [];
    var same_quality = quality == "any" || quality == weapon_one_quality;

    if (is_artifact) {
        artifact_id = new_weapon;
        var _arti = fetch_artifact(artifact_id);
        new_weapon = _arti.get_type_name();
    }

    if (is_artifact && weapon_one(true) == artifact_id) {
        return "no change";
    }

    if (new_weapon == "Heavy Ranged") {
        weapon_list = [
            "Multi-Melta",
            "Heavy Bolter",
            "Lascannon",
            "Missile Launcher",
        ];
        if (array_contains(weapon_list, change_wep) && same_quality) {
            return "no change";
        }
    } else if ((change_wep == new_weapon) && same_quality && !is_artifact && is_string(weapon_one(true))) {
        return "no change";
    }

    if (array_length(weapon_list) > 0) {
        var weapon_found = false;
        var _wep_choice;
        while (array_length(weapon_list) > 0) {
            // randomises heavy weapon choice
            _wep_choice = irandom(array_length(weapon_list) - 1);
            if (scr_item_count(weapon_list[_wep_choice]) > 0) {
                weapon_found = true;
                new_weapon = weapon_list[_wep_choice];
                break;
            }
            array_delete(weapon_list, _wep_choice, 1);
        }
        if (!weapon_found) {
            return "no_items";
        }
    }

    if (from_armoury && !unequipping && !is_artifact) {
        var viability = weapon_viable(new_weapon, quality);
        if (viability[0]) {
            quality = viability[1];
        } else {
            return viability[1];
        }
    } else {
        quality = (quality == "any") ? "standard" : quality;
    }

    if (change_wep != "") {
        if (!is_string(weapon_one(true))) {
            var _old_arti = fetch_artifact(weapon_one(true));
            _old_arti.clear_bearer();
        } else if (to_armoury) {
            scr_add_item(change_wep, 1, weapon_one_quality);
        }
    }

    wep1 = is_artifact ? artifact_id : new_weapon;

    if (is_artifact) {
        var arti_struct = fetch_artifact(artifact_id);
        arti_struct.set_bearer(self);
        weapon_one_quality = "artifact";
    } else {
        weapon_one_quality = quality;
    }

    return "complete";
}

/// @self Struct.TTRPG_stats
function scr_update_unit_weapon_two(new_weapon, from_armoury = true, to_armoury = true, quality = "any") {
    var is_artifact = !is_string(new_weapon);
    var change_wep = weapon_two();
    var unequipping = new_weapon == "";
    var artifact_id = 0;

    if (is_artifact) {
        artifact_id = new_weapon;
        var _arti = fetch_artifact(artifact_id);
        new_weapon = _arti.get_type_name();
    }

    if (is_artifact && weapon_two(true) == artifact_id) {
        return "no change";
    }

    var same_quality = quality == "any" || quality == weapon_two_quality;
    if ((change_wep == new_weapon) && same_quality && !is_artifact && is_string(weapon_two(true))) {
        return "no change";
    }

    if (from_armoury && !unequipping && !is_artifact) {
        var viability = weapon_viable(new_weapon, quality);
        if (viability[0]) {
            quality = viability[1];
        } else {
            return viability[1];
        }
    } else {
        quality = (quality == "any") ? "standard" : quality;
    }

    if (change_wep != "") {
        if (!is_string(weapon_two(true))) {
            var _old_arti = fetch_artifact(weapon_two(true));
            _old_arti.clear_bearer();
        } else if (to_armoury) {
            scr_add_item(change_wep, 1, weapon_two_quality);
        }
    }

    wep2 = is_artifact ? artifact_id : new_weapon;

    if (is_artifact) {
        var arti_struct = fetch_artifact(artifact_id);
        arti_struct.set_bearer(self);
        weapon_two_quality = "artifact";
    } else {
        weapon_two_quality = quality;
    }

    return "complete";
}

/// @self Struct.TTRPG_stats
function scr_update_unit_gear(new_gear, from_armoury = true, to_armoury = true, quality = "any") {
    var is_artifact = !is_string(new_gear);
    var change_gear = gear();
    var unequipping = new_gear == "";

    var artifact_id;
    if (is_artifact) {
        artifact_id = new_gear;
        var _arti = fetch_artifact(artifact_id);
        new_gear = _arti.get_type_name();
    }

    if (is_artifact && gear(true) == artifact_id) {
        return "no change";
    }

    var same_quality = quality == "any" || quality == gear_quality;
    if ((change_gear == new_gear) && same_quality && !is_artifact && is_string(gear(true))) {
        return "no change";
    }

    if (from_armoury && !unequipping && !is_artifact) {
        if (scr_item_count(new_gear, quality) > 0) {
            var exp_require = gear_weapon_data("gear", new_gear, "req_exp", false, quality);
            if (exp_require > experience) {
                return "exp_low";
            }
            quality = scr_add_item(new_gear, -1, quality);
            if (quality == "no_item") {
                return "no_items";
            }
            quality = (quality != undefined) ? quality : "standard";
        } else {
            return "no_items";
        }
    } else {
        quality = (quality == "any") ? "standard" : quality;
    }

    if (change_gear != "") {
        if (!is_string(gear(true))) {
            var _old_arti = fetch_artifact(gear(true));
            _old_arti.clear_bearer();
        } else if (to_armoury) {
            scr_add_item(change_gear, 1, gear_quality);
        }
    }

    var portion = hp_portion();
    gear1 = is_artifact ? artifact_id : new_gear;

    if (is_artifact) {
        var arti_struct = fetch_artifact(artifact_id);
        arti_struct.set_bearer(self);
        gear_quality = "artifact";
    } else {
        gear_quality = quality;
    }

    update_health(portion * max_health());
    return "complete";
}

// TODO: Expand restriction tag checking and error logging to other update functions;
/// @self Struct.TTRPG_stats
function scr_update_unit_mobility_item(new_mobility_item, from_armoury = true, to_armoury = true, quality = "any") {
    var is_artifact = !is_string(new_mobility_item);
    var _old_mobility_item = mobility_item();
    var unequipping = new_mobility_item == "";

    var artifact_id;
    if (is_artifact) {
        artifact_id = new_mobility_item;
        var _arti = fetch_artifact(artifact_id);
        new_mobility_item = _arti.get_type_name();
    }

    if (is_artifact && mobility_item(true) == artifact_id) {
        return "no change";
    }

    if (!unequipping) {
        var _mobility_data = gear_weapon_data("mobility", new_mobility_item);
        if (!is_struct(_mobility_data)) {
            LOGGER.error($"Failed to equip {new_mobility_item} for {name()} - can't find the item in the item database!");
            return "no change";
        }

        var exp_require = _mobility_data.req_exp;
        if (exp_require > experience) {
            LOGGER.error($"Failed to equip {new_mobility_item} for {name()} - not enough EXP! ({experience}<{exp_require})");
            return "no change";
        }

        var _armour_data = get_armour_data();
        if (is_struct(_armour_data)) {
            if (_armour_data.has_tag("terminator") && !_mobility_data.has_tag("terminator") && !_mobility_data.has_tag("terminator_only")) {
                LOGGER.error($"Failed to equip {new_mobility_item} for {name()} - can't use with terminator armour! (Current: {armour()})");
                return "no change";
            } else if (!_armour_data.has_tag("terminator") && _mobility_data.has_tag("terminator_only")) {
                LOGGER.error($"Failed to equip {new_mobility_item} for {name()} - requires terminator armour! (Current: {armour()})");
                return "no change";
            }

            if (_mobility_data.has_tag("power_only") && !_armour_data.has_tag("power_armour")) {
                LOGGER.error($"Failed to equip {new_mobility_item} for {name()} - requires power armour! (Current: {armour()})");
                return "no change";
            }
        } else {
            if (_mobility_data.has_tag("terminator") || _mobility_data.has_tag("terminator_only")) {
                LOGGER.error($"Failed to equip {new_mobility_item} for {name()} - requires terminator armour!");
                return "no change";
            }
        }
    }

    var same_quality = quality == "any" || quality == mobility_item_quality;
    if ((_old_mobility_item == new_mobility_item) && same_quality && !is_artifact && is_string(mobility_item(true))) {
        return "no change";
    }

    // Have enough items check;
    if (from_armoury && !is_artifact && !unequipping) {
        if (scr_item_count(new_mobility_item, quality) > 0) {
            quality = scr_add_item(new_mobility_item, -1, quality);
            quality = quality != undefined ? quality : "standard";
        } else {
            LOGGER.error($"Failed to equip {new_mobility_item} for {name()} - not enough items of {quality} quality!");
            return "no_items";
        }
    } else {
        quality = quality == "any" ? "standard" : quality;
    }

    // Return old items to stockpile;
    if (_old_mobility_item != "") {
        if (!is_string(mobility_item(true))) {
            var _old_arti = fetch_artifact(mobility_item(true));
            _old_arti.clear_bearer();
        } else if (to_armoury) {
            scr_add_item(_old_mobility_item, 1, mobility_item_quality);
        }
    }

    var portion = hp_portion();
    mobi1 = is_artifact ? artifact_id : new_mobility_item;

    if (is_artifact) {
        var arti_struct = fetch_artifact(artifact_id);
        arti_struct.set_bearer(self);
        mobility_item_quality = "artifact";
    } else {
        mobility_item_quality = quality;
    }

    update_health(portion * max_health());
    get_unit_size();

    return "complete";
}

/// @self Struct.TTRPG_stats
function alter_unit_equipment(update_equipment, from_armoury = true, to_armoury = true, quality = "any") {
    var _outcome_desc = "";
    static no_equip = "Not enough equipment:";
    var _missing_items = "";
    var _success = true;
    if (is_array(update_equipment)) {
        update_equipment = convert_equipment_array_into_struct(update_equipment);
    }
    var equip_areas = struct_get_names(update_equipment);
    for (var i = 0; i < array_length(equip_areas); i++) {
        var _item = update_equipment[$ equip_areas[i]];
        var _outcome = "";
        switch (equip_areas[i]) {
            case "wep1":
                _outcome = update_weapon_one(_item, from_armoury, to_armoury, quality);
                break;
            case "wep2":
                _outcome = update_weapon_two(_item, from_armoury, to_armoury, quality);
                break;
            case "mobi":
                _outcome = update_mobility_item(_item, from_armoury, to_armoury, quality);
                break;
            case "armour":
                _outcome = update_armour(_item, from_armoury, to_armoury, quality);
                break;
            case "gear":
                _outcome = update_gear(_item, from_armoury, to_armoury, quality);
                break;
            default:
                continue;
                break;
        }
        if (_outcome == "no_items") {
            _missing_items += $"{_missing_items == "" ? "" : ","} {_item}";
            _success = false;
        }
    }

    if (_missing_items != "") {
        _outcome_desc += no_equip + _missing_items;
    }
    var _final_outcome = {
        success: _success,
        description: _outcome_desc,
    };

    return _final_outcome;
}

/// @self Struct.TTRPG_stats
function unit_has_equipped(check_equippment) {
    var equip_areas = struct_get_names(check_equippment);
    var _has_equipped = true;
    for (var i = 0; i < array_length(equip_areas); i++) {
        switch (equip_areas[i]) {
            case "wep1":
                _has_equipped = weapon_one() == check_equippment.wep1;
                break;
            case "wep2":
                _has_equipped = weapon_two() == check_equippment.wep2;
                break;
            case "mobi":
                _has_equipped = mobility_item() == check_equippment.mobi;
                break;
            case "armour":
                _has_equipped = armour() == check_equippment.armour;
                break;
            case "gear":
                _has_equipped = gear() == check_equippment.gear;
                break;
        }
        if (!_has_equipped) {
            return false;
        }
    }
    return true;
}

/*function equipment_has_tag(tag, area){
	var tags = [];
	switch (area){
		case "wep1":
			tags = get_weapon_one_data("tags");
			break;
		case "wep2":
			tags = get_weapon_two_data("tags");
			break;
		case "mobi":
			tags = get_mobility_data("tags");
			break;
		case "armour":
			tags = get_armour_data("tags");
			break;
		case "gear":
			tags = get_gear_data("tags");
		break;
	}
	if (tags == false || !array_length(tags)){
		return false;
	} else {
		return array_contains(tags, tag);
	}
}*/

function scr_get_unit_equipment(as_UnitEquipment = true) {
    var armour_data = get_armour_data();
    var gear_data = get_gear_data();
    var mobility_data = get_mobility_data();
    var weapon_one_data = get_weapon_one_data();
    var weapon_two_data = get_weapon_two_data();
    var equip_data = {
        armour: armour_data,
        gear: gear_data,
        mobi: mobility_data,
        wep1: weapon_one_data,
        wep2: weapon_two_data,
    };
    if (as_UnitEquipment) {
        return new UnitEquipment(equip_data, self);
    } else {
        return equip_data;
    }
}

function convert_equipment_array_into_struct(array) {
    var _equipment = {};
    for (var i = 0; i < STANDARD_EQUIP_SLOT_COUNT; i++) {
        _equipment[$ global.unit_equip_slots[i]] = array[i];
    }
    return _equipment;
}

function convert_equipment_struct_into_array(struct){
    var _equipment = array_create(STANDARD_EQUIP_SLOT_COUNT, "");
    for (var i = 0; i  < STANDARD_EQUIP_SLOT_COUNT; i++){
        var _slot = global.unit_equip_slots[i];
        if (struct_exists(struct, _slot)){
            _equipment[i] = struct[$ _slot];
        }
    }
    return _equipment;
}

function UnitEquipment(equipment_set, _unit = noone) constructor {
    if (is_array(equipment_set)) {
        equipment = convert_equipment_array_into_struct(equipment_set);
    } else {
        self.equipment = equipment_set;
    }
    self.equipping_unit = _unit;
    var _slot_keys = global.unit_equip_slots;
    for (var i = 0; i < STANDARD_EQUIP_SLOT_COUNT; i++) {
        var _slot = _slot_keys[i];
        var _item = equipment[$ _slot_keys[i]];
        if (!is_struct(_item)) {
            var _dp = _item != "" ? {name: _item} : undefined;
            equipment[$ _slot] = new EquipmentStruct(_dp, "");
        }
    }

    static update_arrays = function() {
        items = [
            equipment.wep1,
            equipment.wep2,
            equipment.armour,
            equipment.gear,
            equipment.mobi,
        ];

        item_names = [
            equipment.wep1.name,
            equipment.wep2.name,
            equipment.armour.name,
            equipment.gear.name,
            equipment.mobi.name,
        ];
    };

    update_arrays();

    present_items = [];

    static is_present = function(item_key) {
        return array_contains(present_items, item_key);
    };

    static slot_map = {
        "wep1": eEQUIPMENT_SLOT.WEAPON_ONE,
        "wep2": eEQUIPMENT_SLOT.WEAPON_TWO,
        "armour": eEQUIPMENT_SLOT.ARMOUR,
        "mobi": eEQUIPMENT_SLOT.MOBILITY,
        "gear": eEQUIPMENT_SLOT.GEAR,
    };

    static basic_map = function() {
        return {
            "wep1": item_names[eEQUIPMENT_SLOT.WEAPON_ONE],
            "wep2": item_names[eEQUIPMENT_SLOT.WEAPON_TWO],
            "armour": item_names[eEQUIPMENT_SLOT.ARMOUR],
            "mobi": item_names[eEQUIPMENT_SLOT.MOBILITY],
            "gear": item_names[eEQUIPMENT_SLOT.GEAR],
        };
    };

    static map_string_to_enum = function(slot) {
        slot = slot_map[$ slot];
        return slot;
    };

    static return_item_enum = function(slot) {
        if (is_string(slot)) {
            return map_string_to_enum(slot);
        }
        return slot;
    };

    static get_item = function(slot) {
        if (is_string(slot)) {
            return self.equipment[$ slot];
        } else {
            return items[slot];
        }
    };

    for (var i = 0; i < STANDARD_EQUIP_SLOT_COUNT; i++) {
        var _item = self.equipment[$ global.unit_equip_slots[i]];
        if (_item.name != "") {
            array_push(present_items, global.unit_equip_slots[i]);
        }
    }

    static item_name = function(slot) {
        return get_item(slot).name;
    };

    static evaluate_item = function(slot, item) {
        return get_item(slot).evaluate(item);
    };

    static equipment_ReactiveString = function(slot) {
        var _enum_slot = return_item_enum(slot);

        var _display = global.unit_equip_slots_display[_enum_slot];
        var _item = items[_enum_slot];
        var _desc = _item.item_tooltip_desc_gen();

        var _quality = _item.quality;

        var _data = {
            tooltip: $"=={_display}==\n{_desc}",
            colour: quality_color(_quality),
            max_width: 187,
        };

        var _text = equipping_unit != noone ? equipping_unit.equipments_qual_string(slot, true) : _item.name;

        var _string = new ReactiveString(_text, 0, 0, _data);

        _string.slot = _enum_slot;
        _string.item = _item;
        return _string;
    };

    static has_equipped = function(slot = eEQUIPMENT_SLOT.ALL, item) {
        if (is_string(slot)) {
            slot = map_string_to_enum(slot);
        }
        if (slot > eEQUIPMENT_SLOT.ALL || slot < 0) {
            LOGGER.error($"{slot} out of bounds for enum eEQUIPMENT_SLOT");
            return false;
        }
        var _multi_items = is_array(item);

        if (slot == eEQUIPMENT_SLOT.ALL) {
            for (var i = 0; i < array_length(present_items); i++) {
                if (has_equipped(present_items[i], item)) {
                    return true;
                }
            }
        } else {
            if (_multi_items) {
                for (var i = 0; i < array_length(item); i++) {
                    if (is_struct(item[i])) {
                        if (evaluate_item(slot, item[i])) {
                            return true;
                        }
                    } else {
                        if (item[i] == item_names[slot]) {
                            return true;
                        }
                    }
                }
                return array_contains(item, item_names[slot]);
            } else {
                if (is_struct(item)) {
                    return evaluate_item(slot, item);
                } else {
                    return item_names[slot] == item;
                }
            }
        }
        return false;
    };

    static has_equipment_set = function(equipment_set) {
        var _found = true;
        for (var i = 0; i < array_length(present_items); i++) {
            var _slot_key = present_items[i];
            if (!struct_exists(equipment_set, _slot_key)) {
                continue;
            }

            var _wanted_data = equipment_set[$ _slot_key];
            if (!is_struct(_wanted_data)) {
                _wanted_data = {
                    name: _wanted_data,
                    required: true,
                };
                var _has_item = has_equipped(_slot_key, _wanted_data.name);
                if (!_has_item && _wanted_data.required) {
                    return false;
                }
            } else {
                if (!struct_exists(_wanted_data, "required")) {
                    _wanted_data.required = true;
                }
                var _has_item = has_equipped(_slot_key, _wanted_data);
                if (!_has_item && _wanted_data.required) {
                    return false;
                }
            }
        }
        return _found;
    };

    /// @param {Struct.EquipmentStruct} _armour_data
    /// @param {Struct.EquipmentStruct} _mobility_data
    /// @returns {Struct} { valid: bool, warning: string }
    function check_mobility_armour_compatibility() {
        var _result = {
            valid: true,
            warning: "",
        };
        var _armour_data = get_item("armour");
        var _mobility_data = get_item("mobi");
        if (is_present("armour") && is_present("mobi")) {
            if (_armour_data.has_tag("terminator") && !_mobility_data.has_tag("terminator") && !_mobility_data.has_tag("terminator_only")) {
                _result.valid = false;
                _result.warning = "Cannot use this with Terminator Armour.";
            } else if (!_armour_data.has_tag("terminator") && _mobility_data.has_tag("terminator_only")) {
                _result.valid = false;
                _result.warning = "Cannot use this without Terminator Armour.";
            } else if (_armour_data.has_tag("dreadnought") && !_mobility_data.has_tag("dreadnought") && !_mobility_data.has_tag("dreadnought_only")) {
                _result.valid = false;
                _result.warning = "Cannot use this with Dreadnought Armour.";
            } else if (!_armour_data.has_tag("dreadnought") && _mobility_data.has_tag("dreadnought_only")) {
                _result.valid = false;
                _result.warning = "Cannot use this without Dreadnought Armour.";
            }
        } else if (!is_present("armour") && is_present("mobi")) {
            if (_mobility_data.has_tag("terminator") || _mobility_data.has_tag("terminator_only")) {
                _result.valid = false;
                _result.warning = "Cannot use this without Terminator Armour.";
            } else if (_mobility_data.has_tag("dreadnought") || _mobility_data.has_tag("dreadnought_only")) {
                _result.valid = false;
                _result.warning = "Cannot use this without Dreadnought Armour.";
            }
        }

        return _result;
    }

    static check_item_is_equipable = function(slot) {
        var _key = global.unit_equip_slots[slot];
        if (!is_present(_key)) {
            equipment_found_and_valid[slot] = true;
            return;
        }
        var _item_check_array = [];

        var _found = 0;
        var _wanted_item = item_names[slot];
        if (_wanted_item == "Assortment") {
            equipment_found_and_valid[slot] = true;
            return;
        }
        var _item = get_item(slot);
        var _marines_without_exp = 0;
        equipment_found_and_valid[slot] = true;
        if (needed_count > 0){
            switch (_key) {
                case "wep1":
                    _item_check_array = obj_controller.ma_wep1;
                    break;
                case "wep2":
                    _item_check_array = obj_controller.ma_wep2;
                    break;
                case "mobi":
                    _item_check_array = obj_controller.ma_mobi;
                    break;
                case "gear":
                    _item_check_array = obj_controller.ma_gear;
                    break;
                case "armour":
                    _item_check_array = obj_controller.ma_armour;
                    break;
            }
            for (var u = 0; u < array_length(obj_controller.display_unit); u++) {
                if (!obj_controller.man_sel[u]) {
                    continue;
                }
                if (_item_check_array[u] == _wanted_item) {
                    _found += 1;
                }
    
                if (_wanted_item == ITEM_NAME_NONE) {
                    _found += 1;
                }
    
                if (obj_controller.man[u] != "man") {
                    continue;
                }
                var _unit = obj_controller.display_unit[u];
                if (_item.req_exp > 0) {
                    if (_unit.experience < _item.req_exp) {
                        _marines_without_exp++;
                    }
                }
                if (slot == eEQUIPMENT_SLOT.ARMOUR && !get_item("armour").has_tag("dreadnought")) {
                    if (_unit.is_dreadnought()) {
                        equipment_found_and_valid[slot] = false;
                        warning += "Marines may not exit Dreadnoughts.";
                    }
                }
            
            }
            _found += scr_item_count(_wanted_item);
        }

        equipment_found_and_valid[slot] = equipment_found_and_valid[slot] && _found >= needed_count;

        if (!equipment_found_and_valid[slot]) {
            warning += $"Not enough {_wanted_item}; {needed_count - _found} more are required.";
        }
        if (_marines_without_exp > 0) {
            equipment_found_and_valid[slot] = false;
            warning += $"{_marines_without_exp} units don't have exp for {_wanted_item}: {_item.req_exp} required.";
        }

        if (_item.has_tag("terminator_only")) {
            if (!get_item("armour").has_tag("terminator")) {
                equipment_found_and_valid[slot] = false;
                warning = $"Cannot use {_wanted_item} without Terminator/Dreadnought Armour.";
            }
        }

        var _class_locks = [
            "terminator",
            "dreadnought",
        ];
        if (_item.has_tags(_class_locks) && !get_item("armour").has_tags(_class_locks)) {
            var _armour_required = "";
            for (var r = 0; r < array_length(_class_locks); r++) {
                if (_item.has_tag(_class_locks[r])) {
                    _armour_required += " " + _class_locks[r];
                }
            }
            equipment_found_and_valid[slot] = false;
            warning += $"Cannot use {_wanted_item} without {_armour_required} Armour.";
        }
    };

    static check_set_is_equipable = function(needed_count = 1) {
        self.needed_count = needed_count;
        warning = "";
        equipment_found_and_valid = array_create(5, true);
        for (var i = 0; i < STANDARD_EQUIP_SLOT_COUNT; i++) {
            check_item_is_equipable(i);
        }

        var _mobi_check = check_mobility_armour_compatibility();
        if (!_mobi_check.valid) {
            warning += _mobi_check.warning;
            equipment_found_and_valid[eEQUIPMENT_SLOT.ARMOUR] = false;
            equipment_found_and_valid[eEQUIPMENT_SLOT.MOBILITY] = false;
        }

        return {
            warning,
            equipment_found_and_valid,
        };
    };

    static start_allowable_weapons = function(slot) {
        var _allow = true;
        var _item = equipment[$ slot].name;
        var _normal_equipment = [
            "Combat Knife",
            "Chainsword",
            "Chainaxe",
            "Boarding Shield",
            "Bolt Pistol",
            "Bolter",
            "Flamer",
            "Sniper Rifle",
        ];
        _allow = array_contains(_normal_equipment, _item);

        if (veteran_level > 0 && !_allow) {
            var _special_equipment = [
                "Storm Bolter",
                "Meltagun",
                "Power Fist",
                "Power Sword",
                "Power Axe",
            ];
            _allow = array_contains(_special_equipment, _item);
        }

        if (!_allow) {
            final_gear[$ slot] = default_options[$ slot];
        }
        final_gear[$ slot] = _allow ? _item : default_options[$ slot];
    };

    static start_allowable_mobi = function() {
        var _allow = false;
        var _item = equipment.mobi.name;
        if (_item == "Jump Pack" && (veteran_level > 0 || role_id == eROLE.ASSAULT)) {
            if (!array_contains([eROLE.TERMINATOR, eROLE.DREADNOUGHT], role_id)) {
                _allow = true;
            }
        } else if (_item == "Bike" && (veteran_level > 0 || role_id == eROLE.ASSAULT)) {
            if (!array_contains([eROLE.TERMINATOR, eROLE.DREADNOUGHT], role_id)) {
                _allow = true;
            }
        } else if (_item == "Heavy Weapons Pack" && role_id == eROLE.DEVASTATOR) {
            _allow = true;
        }

        final_gear.mobi = _allow ? _item : default_options.mobi;
    };

    static start_allowable_gear = function() {
        var _allow = false;
        var _item = equipment.gear.name;
        if (veteran_level == 5) {
            if (role_id == eROLE.CHAPLAIN && _item == "Rosarius") {
                _allow = true;
            } else if (role_id == eROLE.TECHMARINE) {
                if (array_contains(["Servo-arm", "Servo-harness"], _item)) {
                    _allow = true;
                }
            } else if (role_id == eROLE.LIBRARIAN && _item == "Psychic Hood") {
                _allow = true;
            } else if (role_id == eROLE.APOTHECARY && _item == "Narthecium") {
                _allow = true;
            }
        }

        final_gear.gear = _allow ? _item : default_options.gear;
    };

    static start_allowance = function(role_id) {
        final_gear = {};
        veteran_level = 0;
        default_options = setup_default_gears()[role_id];
        self.role_id = role_id;
        if (role_id == eROLE.DREADNOUGHT) {
            return {};
        }
        if (array_contains([eROLE.SERGEANT, eROLE.VETERAN, eROLE.TERMINATOR], role_id)) {
            veteran_level = 1;
        } else if (array_contains([eROLE.VETERANSERGEANT, eROLE.ANCIENT, eROLE.CAPTAIN, eROLE.HONOURGUARD], role_id)) {
            veteran_level = 2;
        } else if (array_contains([eROLE.CHAPLAIN, eROLE.APOTHECARY, eROLE.LIBRARIAN, eROLE.TECHMARINE], role_id)) {
            veteran_level = 5;
        }

        start_allowable_weapons("wep1");
        start_allowable_weapons("wep2");
        start_allowable_mobi();
        start_allowable_gear();

        return final_gear;
    };
}
