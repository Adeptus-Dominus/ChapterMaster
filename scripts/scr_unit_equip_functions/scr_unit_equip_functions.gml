// TODO: Merge all update function into one;

/// @description Guard armoury discipline: auxilia infantry may only equip Guard-pattern
/// weapons; every Astartes weapon (Bolters included) is off limits. Heavy Weapons Teams
/// additionally field their crewed heavy weapons. Any role outside the Guard infantry is
/// unrestricted here. This gate also filters start_gear, so every weapon named in the
/// guard unit templates (unit_stats.json) MUST stay on these lists or the unit spawns
/// with an empty slot, the way the Skitarii once arrived empty handed.
/// @param {string} _role    the unit role being equipped
/// @param {string} _weapon  the weapon name being equipped
/// @returns {bool}
function guard_weapon_permitted(_role, _weapon) {
    static _guard_infantry_weapons = ["Lasgun", "Autogun", "Hellgun", "Bayonet", "Guard Chainsword", "Laspistol"];
    // Crewed heavy weapons a Heavy Weapons Team may field. The team's template
    // spawns with a Heavy Bolter; the rest are Guard-pattern crew weapons the
    // armoury may issue. Any weapon named in unit_stats.json guard templates
    // MUST stay on these lists (see the docstring above).
    static _guard_heavy_weapons = ["Heavy Bolter", "Lascannon", "Autocannon", "Missile Launcher"];
    if (_role == "Guardsman" || _role == "Veteran Guard" || _role == "Guard Sergeant") {
        return array_contains(_guard_infantry_weapons, _weapon);
    }
    if (_role == "Heavy Weapons Team") {
        return array_contains(_guard_infantry_weapons, _weapon) || array_contains(_guard_heavy_weapons, _weapon);
    }
    return true;
}

/// @self Struct.TTRPG_stats
/// @description Hot-shot pairing: slot a Power Pack from the armoury into an empty gear
/// slot when a pack-hungry weapon (requires_power_pack) is held, mirroring how Devastator
/// loadouts pair the Heavy Weapons Pack with the heavy weapon. Skitarii need none, an
/// occupied gear slot is respected, and with no stock the trooper simply fires it as a
/// Lasgun until a pack is forged and equipped.
function try_pair_power_pack(_weapon, from_armoury, to_armoury) {
    if (role() == "Skitarii" || gear() != "") {
        return;
    }
    var _pairing_data = gear_weapon_data("weapon", _weapon);
    if (is_struct(_pairing_data) && _pairing_data.has_tag("requires_power_pack")) {
        if (!from_armoury || scr_item_count("Power Pack") > 0) {
            update_gear("Power Pack", from_armoury, to_armoury);
        }
    }
}

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
        new_armour = obj_ini.artifact[artifact_id];
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

    if (_old_armour == new_armour && same_quality) {
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
        if (to_armoury) {
            if (!is_string(armour(true))) {
                obj_ini.artifact_equipped[armour(true)] = false;
            } else {
                scr_add_item(_old_armour, 1, armour_quality);
            }
        } else if (!is_string(armour(true))) {
            delete_artifact(armour(true)); // may trigger feedback loop if not handled with care
        }
    }

    var portion = hp_portion();
    obj_ini.armour[company][marine_number] = new_armour;

    if (is_artifact) {
        obj_ini.artifact_equipped[artifact_id] = true;
        var arti_struct = obj_ini.artifact_struct[artifact_id];
        arti_struct.bearer = [
            company,
            marine_number,
        ];
        armour_quality = obj_ini.artifact_quality[artifact_id];
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
            update_role(obj_ini.role[100][eROLE.DREADNOUGHT]);
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
        new_weapon = obj_ini.artifact[artifact_id];
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
    } else if (change_wep == new_weapon && same_quality) {
        // Re-applying the same pack-hungry weapon still pairs a Power Pack, so a
        // plain Re-equip pass retrofits packs onto already-armed Hellgunners.
        if (!unequipping && !is_artifact) {
            try_pair_power_pack(new_weapon, from_armoury, to_armoury);
        }
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

    // Role-restricted weapon gate: some weapons are limited by role (the Hellgun is
    // Veteran Guard and Skitarii only; Skitarii start_gear ships a Hellgun, so without
    // the exemption a purchased Skitarii is rejected by its own starting weapon and
    // arrives empty handed). Reject and log before any armoury or slot mutation if the
    // unit lacks the role. Skips unequip and artifacts. Mirrors the mobility tag-gate.
    if (!unequipping && !is_artifact) {
        var _wep_restrict_data = gear_weapon_data("weapon", new_weapon);
        if (is_struct(_wep_restrict_data) && _wep_restrict_data.has_tag("veteran_guard_only") && role() != "Veteran Guard" && role() != "Skitarii") {
            LOGGER.error($"Failed to equip {new_weapon} for {name()} - restricted to Veteran Guard and Skitarii.");
            return "restricted";
        }
        // Guard armoury discipline: auxilia infantry equip Guard-pattern weapons only,
        // no Astartes wargear. See guard_weapon_permitted.
        if (!guard_weapon_permitted(role(), new_weapon)) {
            LOGGER.error($"Failed to equip {new_weapon} for {name()} - not Guard-issue.");
            return "restricted";
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
        if (to_armoury) {
            if (!is_string(weapon_one(true))) {
                obj_ini.artifact_equipped[weapon_one(true)] = false;
            } else {
                scr_add_item(change_wep, 1, weapon_one_quality);
            }
        } else if (!is_string(weapon_one(true))) {
            delete_artifact(weapon_one(true));
        }
    }

    obj_ini.wep1[company][marine_number] = new_weapon;

    // Hot-shot pairing: see try_pair_power_pack.
    if (!unequipping && !is_artifact) {
        try_pair_power_pack(new_weapon, from_armoury, to_armoury);
    }

    if (is_artifact) {
        obj_ini.artifact_equipped[artifact_id] = true;
        var arti_struct = obj_ini.artifact_struct[artifact_id];
        arti_struct.bearer = [
            company,
            marine_number,
        ];
        weapon_one_quality = obj_ini.artifact_quality[artifact_id];
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
        new_weapon = obj_ini.artifact[artifact_id];
    }

    var same_quality = quality == "any" || quality == weapon_two_quality;
    if (change_wep == new_weapon && same_quality) {
        return "no change";
    }

    // Guard armoury discipline: the sidearm slot obeys the same Guard-issue whitelist as
    // the primary, so a Bolter (or any other Astartes weapon) cannot slip in as wep2.
    // See guard_weapon_permitted. Skips unequip and artifacts.
    if (!unequipping && !is_artifact && !guard_weapon_permitted(role(), new_weapon)) {
        LOGGER.error($"Failed to equip {new_weapon} for {name()} - not Guard-issue.");
        return "restricted";
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
        if (to_armoury) {
            if (!is_string(weapon_two(true))) {
                obj_ini.artifact_equipped[weapon_two(true)] = false;
            } else {
                scr_add_item(change_wep, 1, weapon_two_quality);
            }
        } else if (!is_string(weapon_two(true))) {
            delete_artifact(weapon_two(true));
        }
    }

    obj_ini.wep2[company][marine_number] = new_weapon;

    if (is_artifact) {
        obj_ini.artifact_equipped[artifact_id] = true;
        weapon_two_quality = obj_ini.artifact_quality[artifact_id];
        var arti_struct = obj_ini.artifact_struct[artifact_id];
        arti_struct.bearer = [
            company,
            marine_number,
        ];
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
        new_gear = obj_ini.artifact[artifact_id];
    }

    var same_quality = quality == "any" || quality == gear_quality;
    if (change_gear == new_gear && same_quality) {
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
        if (to_armoury) {
            if (!is_string(gear(true))) {
                obj_ini.artifact_equipped[gear(true)] = false;
            } else {
                scr_add_item(change_gear, 1, gear_quality);
            }
        } else if (!is_string(gear(true))) {
            delete_artifact(gear(true));
        }
    }

    var portion = hp_portion();
    obj_ini.gear[company][marine_number] = new_gear;

    if (is_artifact) {
        obj_ini.artifact_equipped[artifact_id] = true;
        gear_quality = obj_ini.artifact_quality[artifact_id];
        var arti_struct = obj_ini.artifact_struct[artifact_id];
        arti_struct.bearer = [
            company,
            marine_number,
        ];
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
        new_mobility_item = obj_ini.artifact[artifact_id];
    }

    if (!unequipping) {
        var _mobility_data = gear_weapon_data("mobility", new_mobility_item);
        if (!is_struct(_mobility_data)) {
            LOGGER.error($"Failed to equip {new_mobility_item} for {name()} - can't find the item in the item database!");
            return false;
        }

        var exp_require = _mobility_data.req_exp;
        if (exp_require > experience) {
            LOGGER.error($"Failed to equip {new_mobility_item} for {name()} - not enough EXP! ({experience}<{exp_require})");
            return false;
        }

        var _armour_data = get_armour_data();
        if (is_struct(_armour_data)) {
            if (_armour_data.has_tag("terminator") && !_mobility_data.has_tag("terminator") && !_mobility_data.has_tag("terminator_only")) {
                LOGGER.error($"Failed to equip {new_mobility_item} for {name()} - can't use with terminator armour! (Current: {armour()})");
                return false;
            } else if (!_armour_data.has_tag("terminator") && _mobility_data.has_tag("terminator_only")) {
                LOGGER.error($"Failed to equip {new_mobility_item} for {name()} - requires terminator armour! (Current: {armour()})");
                return false;
            }

            if (_mobility_data.has_tag("power_only") && !_armour_data.has_tag("power_armour")) {
                LOGGER.error($"Failed to equip {new_mobility_item} for {name()} - requires power armour! (Current: {armour()})");
                return false;
            }
        } else {
            if (_mobility_data.has_tag("terminator") || _mobility_data.has_tag("terminator_only")) {
                LOGGER.error($"Failed to equip {new_mobility_item} for {name()} - requires terminator armour!");
                return false;
            }
        }
    }

    var same_quality = quality == "any" || quality == mobility_item_quality;
    if (_old_mobility_item == new_mobility_item && same_quality) {
        return true;
    }

    // Have enough items check;
    if (from_armoury && !is_artifact && !unequipping) {
        if (scr_item_count(new_mobility_item, quality) > 0) {
            quality = scr_add_item(new_mobility_item, -1, quality);
            quality = quality != undefined ? quality : "standard";
        } else {
            LOGGER.error($"Failed to equip {new_mobility_item} for {name()} - not enough items of {quality} quality!");
            return false;
        }
    } else {
        quality = quality == "any" ? "standard" : quality;
    }

    // Return old items to stockpile;
    if (_old_mobility_item != "") {
        if (to_armoury) {
            if (!is_string(mobility_item(true))) {
                obj_ini.artifact_equipped[mobility_item(true)] = false;
            } else {
                scr_add_item(_old_mobility_item, 1, mobility_item_quality);
            }
        } else if (!is_string(mobility_item(true))) {
            delete_artifact(mobility_item(true));
        }
    }

    var portion = hp_portion();
    obj_ini.mobi[company][marine_number] = new_mobility_item;

    if (is_artifact) {
        obj_ini.artifact_equipped[artifact_id] = true;
        mobility_item_quality = obj_ini.artifact_quality[artifact_id];
        var arti_struct = obj_ini.artifact_struct[artifact_id];
        arti_struct.bearer = [
            company,
            marine_number,
        ];
    } else {
        mobility_item_quality = quality;
    }

    update_health(portion * max_health());
    get_unit_size();

    return true;
}

/// @self Struct.TTRPG_stats
function alter_unit_equipment(update_equipment, from_armoury = true, to_armoury = true, quality = "any") {
    var equip_areas = struct_get_names(update_equipment);
    for (var i = 0; i < array_length(equip_areas); i++) {
        switch (equip_areas[i]) {
            case "wep1":
                update_weapon_one(update_equipment[$ equip_areas[i]], from_armoury, to_armoury, quality);
                break;
            case "wep2":
                update_weapon_two(update_equipment[$ equip_areas[i]], from_armoury, to_armoury, quality);
                break;
            case "mobi":
                update_mobility_item(update_equipment[$ equip_areas[i]], from_armoury, to_armoury, quality);
                break;
            case "armour":
                update_armour(update_equipment[$ equip_areas[i]], from_armoury, to_armoury, quality);
                break;
            case "gear":
                update_gear(update_equipment[$ equip_areas[i]], from_armoury, to_armoury, quality);
                break;
        }
    }
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

function UnitEquipment(equipment_set, unit = noone) constructor{
    self.equipment = equipment_set;
    self.unit = unit;
    var _slot_keys = UNIT_EQUIP_SLOTS;
    var _slot, _item;
    for (var i = 0; i < 5; i++){
        _slot = _slot_keys[i];
        _item = equipment[$_slot_keys[i]];
        if (!is_struct(_item)){
            equipment[$_slot_keys[i]] = new EquipmentStruct(noone,"");
        }
    }
    
    items = [equipment.wep1, equipment.wep2, equipment.armour,equipment.gear,equipment.mobi]

    item_names = [equipment.wep1.name, equipment.wep2.name, equipment.armour.name,equipment.gear.name,equipment.mobi.name];

    present_items = [];

    static slot_map = {
        "wep1" : eEQUIPMENT_SLOT.WEAPON_ONE,
        "wep2" : eEQUIPMENT_SLOT.WEAPON_TWO,
        "armour" : eEQUIPMENT_SLOT.ARMOUR,
        "mobi" : eEQUIPMENT_SLOT.MOBILITY,
        "gear" : eEQUIPMENT_SLOT.GEAR
    }

    static map_string_to_enum = function(slot){
        slot = slot_map[$ slot];
        return slot;
    }

    static return_item_enum = function(slot){
        if (is_string(slot)){
            return map_string_to_enum(slot);
        }
        return slot;
    }

    static get_item = function(slot){
        if (is_string(slot)){
            return self.equipment[$ slot]
        } else {
            return items[slot];
        }
    }

    for (var i = 0;i<array_length(UNIT_EQUIP_SLOTS)-1;i++){
        var _item = self.equipment[$UNIT_EQUIP_SLOTS[i]];
        if (_item.name != ""){
            array_push(present_items, UNIT_EQUIP_SLOTS[i]);
        }
    }

    static item_name = function(slot){
        return get_item(slot).name;
    }

    static evaluate_item = function(slot, item){
        return get_item(slot).evaluate(item);
    }

    static equipment_ReactiveString = function(slot){
        var _enum_slot = return_item_enum(slot);
    
        var _display = UNIT_EQUIP_SLOTS_DISPLAY[_enum_slot];
        var _item = items[_enum_slot];
        var _desc = _item.item_tooltip_desc_gen();

        var _quality = _item.quality;

        var _data = {
            tooltip: $"=={_display}==\n{_desc}",
            colour: quality_color(_quality),
            max_width: 187,
        };

        var _text = unit != noone ? unit.equipments_qual_string(slot, true) : _item.name;

        var _string = new ReactiveString(_text, 0, 0, _data);

        _string.slot = _enum_slot;
        _string.item = _item;
        return _string;
    }

    static has_equipped = function (slot = eEQUIPMENT_SLOT.ALL, item){
        if (is_string(slot)){
            slot = map_string_to_enum(slot);
        }
        if (slot > eEQUIPMENT_SLOT.ALL || slot < 0){
            LOGGER.error($"{slot} out of bounds for enum eEQUIPMENT_SLOT");
            return false;
        }
        var _multi_items = (is_array(item));

        if (slot == eEQUIPMENT_SLOT.ALL){
            for (var i = 0; i < array_length(present_items); i++){
                if (has_equipped(present_items[i], item)){
                    return true;
                }
            }
        }
        else {
            if (_multi_items){
                for (var i = 0; i < array_length(item); i++){
                    if (is_struct(item[i])){
                        if (evaluate_item(slot ,  item[i])){
                            return true;
                        }
                    } else{
                        if (item[i] == item_names[slot]){
                            return true;
                        }
                    }
                }
                return array_contains(item, item_names[slot]);
            } else {
                if (is_struct(item)){
                    return evaluate_item(slot, item)
                } else {
                    return item_names[slot] == item;
                }
            }
        }
        return false;
    }

    static has_equipment_set = function (equipment_set){
        var _found = true;
        for (var i = 0; i < array_length(present_items); i++){
            var _slot_key = present_items[i]
            if (!struct_exists(equipment_set, _slot_key)){
                continue;
            }

            var _wanted_data = equipment_set[$ _slot_key];
            if (!is_struct(_wanted_data)){
                _wanted_data = {name : _wanted_data, required : true};
                var _has_item = has_equipped(_slot_key, _wanted_data.name);
                if (!_has_item && _wanted_data.required){
                    return false;
                }
            } else {
                if (!struct_exists(_wanted_data, "required")){
                    _wanted_data.required = true;
                }
                var _has_item = has_equipped(_slot_key, _wanted_data);
                if (!_has_item && _wanted_data.required){
                    return false;
                }                
            }
        }
        return _found;
    }
}


