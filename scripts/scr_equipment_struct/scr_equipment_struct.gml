global.tag_maintenance_values = {
    "heavy_ranged": 0.5,
    "power": 0.5,
    "ancient": 1.0,
    "plasma": 0.8,
    "melta": 0.8,
    "las": 0.1,
    "bolt": 0.01,
    "chain": 0.01,
    "flame": 0.02,
    "xenos": 1,
    "dreadnought": 0.6,
    "vehicle": 0.4,
    "terminator": 0.6,
};

global.tag_recovery_values = {
    "terminator": 30,
};

function EquipmentStruct(item_data = undefined, core_type = "", quality_request = "none", arti_struct = -1) constructor {
    type = core_type;

    if (is_real(arti_struct) && arti_struct > -1) {
        is_artifact = true;
        artifact_id = arti_struct;
    } else {
        is_artifact = false;
    }
    artifact_id = arti_struct;

    // Struct defaults;
    hp_mod = 0;
    description = "";
    damage_resistance_mod = 0;
    ranged_mod = 0;
    melee_mod = 0;
    armour_value = 0;
    attack = 0;
    melee_hands = 0;
    ranged_hands = 0;
    ammo = 0;
    range = 0;
    spli = 0;
    arp = 0;
    special_description = "";
    special_properties = [];
    abbreviation = "";
    tags = [];
    name = "";
    second_profiles = [];
    req_exp = 0;
    maintenance = 0;
    specials = "";
    recovery_chance = 0;
    quality = quality_request == "none" ? "standard" : quality_request;
    // Struct defaults end;

    // Loop through teh data, to fill the struct;
    if (is_struct(item_data)) {
        var _struct_keys = struct_get_names(item_data);
        for (var i = 0; i < array_length(_struct_keys); i++) {
            var _struct_key = _struct_keys[i];
            // _struct_keys = [];
            self[$ _struct_key] = item_data[$ _struct_key];
            if (is_struct(self[$ _struct_key])) {
                if (struct_exists(self[$ _struct_key], quality)) {
                    self[$ _struct_key] = self[$ _struct_key][$ quality];
                }
            }
        }
    }

    // Placeholder maintenance values;
    if (maintenance == 0) {
        var _maintenance_names = struct_get_names(global.tag_maintenance_values);
        for (var i = 0; i < array_length(_maintenance_names); i++) {
            if (has_tag(_maintenance_names[i])) {
                maintenance += global.tag_maintenance_values[$ _maintenance_names[i]];
            }
        }
    }

    if (recovery_chance == 0) {
        var _recover_values = struct_get_names(global.tag_recovery_values);
        for (var i = 0; i < array_length(_recover_values); i++) {
            if (has_tag(_recover_values[i])) {
                recovery_chance += global.tag_recovery_values[$ _recover_values[i]];
            }
        }
        recovery_chance = clamp(recovery_chance, 0, 100);
    }

    // All methods and functions are bllow;

    static item_tooltip_desc_gen = function() {
        item_desc_tooltip = "";
        var stat_order;
        var item_type = type;
        if (type == "") {
            if (name == "") {
                return "";
            }
            if (struct_exists(global.gear[$ "armour"], name)) {
                item_type = "armour";
            } else if (struct_exists(global.gear[$ "mobility"], name)) {
                item_type = "mobility";
            } else if (struct_exists(global.gear[$ "gear"], name)) {
                item_type = "gear";
            } else if (struct_exists(global.weapons, name)) {
                item_type = "weapon";
            } else {
                item_desc_tooltip = "Error: Item not found!";
                return item_desc_tooltip;
            }
        }
        switch (item_type) {
            default:
                stat_order = [
                    "description",
                    "special_description",
                    "quality",
                    "armour_value",
                    "damage_resistance_mod",
                    "hp_mod",
                    "ranged_mod",
                    "melee_mod",
                    "attack",
                    "spli",
                    "range",
                    "ammo",
                    "melee_hands",
                    "ranged_hands",
                    "maintenance",
                    "special_properties",
                    "req_exp",
                    "tags",
                    "specials",
                ];
                break;
            case "weapon":
                stat_order = [
                    "description",
                    "special_description",
                    "quality",
                    "attack",
                    "spli",
                    "range",
                    "ammo",
                    "ranged_mod",
                    "melee_mod",
                    "armour_value",
                    "hp_mod",
                    "damage_resistance_mod",
                    "melee_hands",
                    "ranged_hands",
                    "maintenance",
                    "special_properties",
                    "req_exp",
                    "tags",
                    "specials",
                ];
                break;
        }

        for (var i = 0; i < array_length(stat_order); i++) {
            var stat = stat_order[i];
            switch (stat) {
                case "description":
                    if (description != "") {
                        item_desc_tooltip += $"{localize(description)}##";
                    }
                    break;
                case "quality":
                    if (quality != "") {
                        item_desc_tooltip += $"{localize("Quality: {0}##", [localize(quality_string_conversion(quality))])}";
                    }
                    break;
                case "armour_value":
                    if (armour_value != 0) {
                        if (item_type == "armour") {
                            item_desc_tooltip += $"{localize("Armour: {0}#", [armour_value])}";
                        } else {
                            item_desc_tooltip += $"{localize("Armour: {0}#", [format_number_with_sign(armour_value)])}";
                        }
                    }
                    break;
                case "hp_mod":
                    if (hp_mod != 0) {
                        item_desc_tooltip += $"{localize("Health Mod: {0}%#", [format_number_with_sign(hp_mod)])}";
                    }
                    break;
                case "damage_resistance_mod":
                    if (damage_resistance_mod != 0) {
                        item_desc_tooltip += $"{localize("Damage Res: {0}%#", [format_number_with_sign(damage_resistance_mod)])}";
                    }
                    break;
                case "attack":
                    if (attack != 0) {
                        item_desc_tooltip += $"{localize("Damage: {0}#", [attack])}";
                    }
                    break;
                case "spli":
                    if (item_type == "weapon") {
                        item_desc_tooltip += $"{localize("Max Kills: {0}#", [max(1, spli)])}";
                    }
                    break;
                case "ranged_mod":
                    if (ranged_mod != 0) {
                        item_desc_tooltip += $"{localize("Ranged Mod: {0}%#", [format_number_with_sign(ranged_mod)])}";
                    }
                    break;
                case "melee_mod":
                    if (melee_mod != 0) {
                        item_desc_tooltip += $"{localize("Melee Mod: {0}%#", [format_number_with_sign(melee_mod)])}";
                    }
                    break;
                case "ammo":
                    if (ammo != 0) {
                        item_desc_tooltip += $"{localize("Ammo: {0}#", [ammo])}";
                    }
                    break;
                case "range":
                    if (range > 1.1) {
                        item_desc_tooltip += $"{localize("Range: {0}#", [range])}";
                    }
                    break;
                case "melee_hands":
                    if (melee_hands != 0) {
                        if (item_type == "weapon") {
                            item_desc_tooltip += $"{localize("Melee Burden: {0}#", [melee_hands])}";
                        } else {
                            item_desc_tooltip += $"{localize("Melee Burden Cap: {0}#", [format_number_with_sign(melee_hands)])}";
                        }
                    }
                    break;
                case "ranged_hands":
                    if (ranged_hands != 0) {
                        if (item_type == "weapon") {
                            item_desc_tooltip += $"{localize("Ranged Burden: {0}#", [ranged_hands])}";
                        } else {
                            item_desc_tooltip += $"{localize("Ranged Burden Cap: {0}#", [format_number_with_sign(ranged_hands)])}";
                        }
                    }
                    break;
                case "special_properties":
                    var special_properties_array = [];
                    if (array_length(special_properties) > 0) {
                        for (var k = 0; k < array_length(special_properties); k++) {
                            array_push(special_properties_array, localize(special_properties[k]));
                        }
                    }
                    if (arp == 4) {
                        array_push(special_properties_array, localize("Anti Vehicle"));
                    } else if (arp == 1) {
                        array_push(special_properties_array, localize("Low Penetration"));
                    } else if (arp == 2) {
                        array_push(special_properties_array, localize("Medium Penetration"));
                    } else if (arp == 3) {
                        array_push(special_properties_array, localize("High Penetration"));
                    }
                    if (array_length(second_profiles) > 0) {
                        for (var h = 0; h < array_length(second_profiles); h++) {
                            if (string_pos("Integrated", second_profiles[h]) == 0) {
                                var integrated_member = localize("Integrated {0}", [localize(second_profiles[h])]);
                                array_push(special_properties_array, integrated_member);
                            } else {
                                array_push(special_properties_array, localize(second_profiles[h]));
                            }
                        }
                    }

                    if (is_struct(specials)) {
                        var _specials_string = "";
                        var _specials = struct_get_names(specials);
                        for (var j = 0; j < array_length(_specials); j++) {
                            var _special = _specials[j];
                            var _special_value = specials[$ _special];
                            _specials_string += localize("{0} ({1})", [localize(format_underscore_string(_special)), _special_value]);
                            array_push(special_properties_array, _specials_string);
                        }
                    }

                    var _array_length = array_length(special_properties_array);
                    if (_array_length > 0) {
                        var special_properties_string = array_to_string_order(special_properties_array, false, false);
                        item_desc_tooltip += $"{localize("#Properties:#{0}#", [special_properties_string])}";
                    }
                    break;
                case "special_description":
                    if (special_description != "") {
                        item_desc_tooltip += $"#{localize(special_description)}#";
                    }
                    break;
                case "req_exp":
                    if (req_exp > 0) {
                        item_desc_tooltip += $"{localize("#Requires {0} EXP#", [req_exp])}";
                    }
                    break;
                case "tags":
                    if (array_length(tags) > 0) {
                        var tagString = "";
                        for (var j = 0; j < array_length(tags); j++) {
                            tagString += localize(tags[j]);
                            if (j < array_length(tags) - 1) {
                                tagString += ", ";
                            }
                        }
                        item_desc_tooltip += $"{localize("#Keywords:#{0}#", [tagString])}";
                    }
                    break;
                case "maintenance":
                    if (maintenance > 0) {
                        item_desc_tooltip += $"{localize("Maintenance: {0}#", [maintenance])}";
                    }
                    break;
            }
        }
        return item_desc_tooltip;
    };

    static special_value = function(special) {
        if (is_struct(specials)) {
            var _specials = struct_get_names(specials);
            for (var j = 0; j < array_length(_specials); j++) {
                var _special = _specials[j];
                if (_special == special) {
                    var _special_value = specials[$ _special];
                    return _special_value;
                }
            }
        }
        return 0;
    };

    static has_tag = function(tag) {
        return array_contains(tags, tag);
    };

    static has_tags = function(search_tags) {
        var satisfied = false;
        var wanted_tags_length = array_length(search_tags);
        for (var i = 0; i < array_length(tags); i++) {
            for (var s = 0; s < wanted_tags_length; s++) {
                if (search_tags[s] == tags[i]) {
                    satisfied = true;
                    break;
                }
            }
            if (satisfied) {
                break;
            }
        }
        return satisfied;
    };

    static has_tags_all = function(search_tags, require_all = false) {
        var satisfied = false;
        var wanted_tags_length = array_length(search_tags);
        for (var i = 0; i < array_length(tags); i++) {
            for (var s = 0; s < wanted_tags_length; s++) {
                if (search_tags[s] == tags[i]) {
                    array_delete(search_tags, s, 1);
                    wanted_tags_length--;
                    s--;
                    if (wanted_tags_length == 0) {
                        satisfied = true;
                        break;
                    }
                }
            }
            if (satisfied) {
                break;
            }
        }
        return satisfied;
    };

    static owner_data = function(owner) {
        //centralization of bonuses originating from weapon improvements e.g STCs
        if (owner == "chapter") {
            if (type == "weapon" && instance_exists(obj_controller)) {
                if (obj_controller.stc_bonus[1] > 0 && obj_controller.stc_bonus[1] < 5) {
                    if (obj_controller.stc_bonus[1] == 2 && has_tag("chain")) {
                        attack *= 1.07;
                    } else if (obj_controller.stc_bonus[1] == 3 && has_tag("flame")) {
                        attack *= 1.1;
                    } else if (obj_controller.stc_bonus[1] == 4 && has_tag("explosive")) {
                        attack *= 1.07;
                    } else if (obj_controller.stc_bonus[1] == 1 && has_tag("bolt")) {
                        attack *= 1.07;
                    }
                }
                if (obj_controller.stc_bonus[2] > 0 && obj_controller.stc_bonus[2] < 3) {
                    if (obj_controller.stc_bonus[2] == 1 && has_tag("fist")) {
                        attack *= 1.1;
                    } else if (obj_controller.stc_bonus[2] == 2 && has_tag("plasma")) {
                        attack *= 1.1;
                    }
                }
            }
        }
    };

    static evaluate = function(evaluation_data) {
        var _valid = true;
        var _eval_count = array_length(struct_get_names(evaluation_data));
        if (struct_exists(evaluation_data, "name")) {
            _eval_count--;
            var _name_check = evaluation_data.name;
            _valid = name == _name_check;
        }

        if (_eval_count == 0) {
            return _valid;
        }
    };
}

/// @param {string} search_area possible values: "any", "weapon", "gear", "armour", "mobility"
function gear_weapon_data(search_area = "any", item, wanted_data = "all", sub_class = false, quality_request = "standard", arti_struct = -1) {
    var item_data_set = false;
    var equip_area = false;
    gear_areas = [
        "gear",
        "armour",
        "mobility",
    ];
    if (search_area == "any") {
        data_found = false;
        for (i = 0; i < 3; i++) {
            if (struct_exists(global.gear[$ gear_areas[i]], item)) {
                equip_area = global.gear;
                item_data_set = global.gear[$ gear_areas[i]][$ item];
                data_found = true;
                search_area = gear_areas[i];
                break;
            }
        }
        if (!data_found) {
            equip_area = global.weapons;
            if (struct_exists(equip_area, item)) {
                item_data_set = equip_area[$ item];
                search_area = "weapon";
            }
        }
    } else {
        if (array_contains(gear_areas, search_area)) {
            equip_area = global.gear;
            if (struct_exists(equip_area[$ search_area], item)) {
                item_data_set = equip_area[$ search_area][$ item];
            }
        } else if (search_area == "weapon") {
            equip_area = global.weapons;
            if (struct_exists(equip_area, item)) {
                item_data_set = equip_area[$ item];
                search_area = "weapon";
            }
        }
    }

    if (is_struct(item_data_set)) {
        if (wanted_data == "all") {
            item_data_set.name = item;
            return new EquipmentStruct(item_data_set, search_area, quality_request, arti_struct);
        }
        if (struct_exists(item_data_set, wanted_data)) {
            if (is_struct(item_data_set[$ wanted_data])) {
                if (struct_exists(item_data_set[$ wanted_data], quality_request)) {
                    return item_data_set[$ wanted_data][$ quality_request];
                } else {
                    if (struct_exists(item_data_set[$ wanted_data], "standard")) {
                        return item_data_set[$ wanted_data][$ "standard"];
                    } else {
                        return 0; //default value
                    }
                }
            } else {
                return item_data_set[$ wanted_data];
            }
        } else {
            return 0; //default value
        }
    }
    return false; //nothing found
}

function quality_string_conversion(quality_request) {
    var quality_conversions = {
        standard: "Normal",
        master_crafted: "Master Crafted",
        artifact: "Artifact",
    };
    if (struct_exists(quality_conversions, quality_request)) {
        return quality_conversions[$ quality_request];
    } else {
        return "";
    }
}

function gen_item_tooltip(item) {
    var _tooltip = "";
    var _equip_data = gear_weapon_data("any", item);

    if (is_struct(_equip_data)) {
        _tooltip = $"{_equip_data.item_tooltip_desc_gen()}";
    }

    return _tooltip;
}

function quality_color(_item_quality) {
    switch (_item_quality) {
        case "standard":
            return draw_get_color();
        case "master_crafted":
            return #bf9340;
        case "artifact":
            return #40bfbf;
    }
}
