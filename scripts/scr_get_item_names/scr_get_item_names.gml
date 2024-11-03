/// @description This function returns an array with common empty or wildcard names as needed.
/// @param {bool} with_none - Whether to include "(None)" in the list.
/// @param {bool} with_any - Whether to include "(any)" in the list.
function get_none_or_any_item_names(with_none=false, with_any=false) {
    var item_names = [];
    if (with_none) {
        array_push(item_names, "(None)");
    }
    if (with_any) {
        array_push(item_names, "(any)");
    }
    return item_names;
}

/// @description This function returns the hard-coded list of ranged weapons.
/// @param {array} item_names - The list of ranged weapons to append to.
function push_marine_ranged_weapons_item_names(item_names) {
    array_push(item_names, "Archeotech Laspistol");
    array_push(item_names, "Assault Cannon");
    array_push(item_names, "Bolt Pistol");
    array_push(item_names, "Bolter");
    array_push(item_names, "Stalker Pattern Bolter");
    array_push(item_names, "Combiflamer");
    array_push(item_names, "Flamer");
    array_push(item_names, "Heavy Bolter");
    array_push(item_names, "Heavy Flamer");
    array_push(item_names, "Hellrifle");
    array_push(item_names, "Incinerator");
    array_push(item_names, "Integrated Bolter");
    array_push(item_names, "Lascannon");
    array_push(item_names, "Lascutter");
    array_push(item_names, "Meltagun");
    array_push(item_names, "Missile Launcher");
    array_push(item_names, "Multi-Melta");
    array_push(item_names, "Autocannon");
    array_push(item_names, "Plasma Gun");
    array_push(item_names, "Plasma Pistol");
    array_push(item_names, "Sniper Rifle");
    array_push(item_names, "Storm Bolter");
    array_push(item_names, "Webber");
}

/// @description This function returns the hard-coded list of melee weapons.
/// @param {array} item_names - The list to append to.
function push_marine_melee_weapons_item_names(item_names) {
    array_push(item_names, "Combat Knife");
    array_push(item_names, "Chainsword");
    array_push(item_names, "Chainaxe");
    array_push(item_names, "Eviscerator");
    array_push(item_names, "Power Sword");
    array_push(item_names, "Power Axe");
    array_push(item_names, "Power Fist");
    array_push(item_names, "Chainfist");
    array_push(item_names, "Lightning Claw");
    array_push(item_names, "Force Staff");
    array_push(item_names, "Thunder Hammer");
    array_push(item_names, "Boarding Shield");
    array_push(item_names, "Storm Shield");
    array_push(item_names, "Bolt Pistol");
    array_push(item_names, "Bolter");
}


/// @description This function appends the list of marine armour items to the given list.
/// @param {array} item_names - The list to append to.
function push_marine_armour_item_names(item_names) {
    array_push(item_names, "Scout Armour");
    array_push(item_names, "Power Armour");
    array_push(item_names, "MK3 Iron Armour");
    array_push(item_names, "MK4 Maximus");
    array_push(item_names, "MK5 Heresy");
    array_push(item_names, "MK6 Corvus");
    array_push(item_names, "MK7 Aquila");
    array_push(item_names, "MK8 Errant");
    array_push(item_names, "Artificer Armour");
    array_push(item_names, "Terminator Armour");
    array_push(item_names, "Tartaros");
}

/// @description This function appends the list of marine gear items to the given list.
/// @param {array} item_names - The list to append to.
function push_marine_gear_item_names(item_names) {
    // array_push(item_names, "Bionics");
    array_push(item_names, "Iron Halo");
    array_push(item_names, "Narthecium");
    array_push(item_names, "Psychic Hood");
    array_push(item_names, "Rosarius");
}

/// @description This function appends the list of marine mobility items to the given list.
/// @param {array} item_names - The list to append to.
function push_marine_mobility_item_names(item_names) {
    array_push(item_names, "Bike");
    array_push(item_names, "Jump Pack");
    array_push(item_names, "Servo-arm");
    array_push(item_names, "Servo-harness");
}


/// @description This function appends the list of dreadnought ranged weapons to the given list.
/// @param {array} item_names - The list to append to.
function push_dreadnought_ranged_weapons_item_names(item_names) {
    array_push(item_names, "Multi-Melta");
    array_push(item_names, "Twin Linked Heavy Flamer Sponsons");
    array_push(item_names, "Plasma Cannon");
    array_push(item_names, "Assault Cannon");
    array_push(item_names, "Autocannon");
    array_push(item_names, "Missile Launcher");
    array_push(item_names, "Twin Linked Lascannon");
    array_push(item_names, "Twin Linked Assault Cannon Mount");
    array_push(item_names, "Twin Linked Heavy Bolter");
    array_push(item_names, "Heavy Conversion Beam Projector");
}

/// @description This function appends the list of dreadnought melee weapons to the given list.
/// @param {array} item_names - The list to append to.
function push_dreadnought_melee_weapons_item_names(item_names) {
    array_push(item_names, "Close Combat Weapon");
    array_push(item_names, "Dreadnought Power Claw");
    array_push(item_names, "Dreadnought Lightning Claw");
}

/// @description This function appends the list of land raider front weapons to the given list.
/// @param {array} item_names - The list to append to.
function push_land_raider_front_weapons_item_names(item_names) {
    array_push(item_names, "Twin Linked Heavy Bolter Mount");
    array_push(item_names, "Twin Linked Lascannon Mount");
    array_push(item_names, "Twin Linked Assault Cannon Mount");
    array_push(item_names, "Whirlwind Missiles");
}

/// @description This function appends the list of land raider relic front weapons to the given list.
/// @param {array} item_names - The list to append to.
function push_land_raider_relic_front_weapons_item_names(item_names) {
    // array_push(item_names, "Thunderfire Cannon Mount");
    array_push(item_names, "Neutron Blaster Turret");
    array_push(item_names, "Reaper Autocannon Mount");
    // array_push(item_names, "Twin Linked Helfrost Cannon Mount");
    // array_push(item_names, "Graviton Cannon Mount");
}

/// @description This function appends the list of land raider sponson weapons to the given list.
/// @param {array} item_names - The list to append to.
function push_land_raider_regular_sponsons_item_names(item_names) {
    array_push(item_names, "Twin Linked Lascannon Sponsons");
    array_push(item_names, "Hurricane Bolter Sponsons");
    array_push(item_names, "Flamestorm Cannon Sponsons");
}

/// @description This function returns the hard-coded list of land raider relic sponsons.
/// @param {array} item_names - The list to append to.
function push_land_raider_relic_sponsons_item_names(item_names) {
    array_push(item_names, "Quad Linked Heavy Bolter Sponsons");
    array_push(item_names, "Twin Linked Heavy Flamer Sponsons");
    array_push(item_names, "Twin Linked Multi-Melta Sponsons");
    array_push(item_names, "Twin Linked Volkite Culverin Sponsons");
}

/// @description This function appends the list of land raider pintle weapons to the given list.
/// @param {array} item_names - The list to append to.
function push_land_raider_pintle_item_names(item_names) {
    array_push(item_names, "Bolter");
    array_push(item_names, "Combiflamer");
    array_push(item_names, "Twin Linked Bolters");
    array_push(item_names, "Storm Bolter");
    array_push(item_names, "HK Missile");
}

/// @description This function appends the list of rhino weapons to the given list.
/// @param {array} item_names - The list to append to.
function push_rhino_weapons_item_names(item_names) {
    array_push(item_names, "Bolter");
    array_push(item_names, "Combiflamer");
    array_push(item_names, "Twin Linked Bolters");
    array_push(item_names, "Storm Bolter");
    array_push(item_names, "HK Missile");
}

/// @description This function appends the list of predator turret weapons to the given list.
/// @param {array} item_names - The list to append to.
function push_predator_turret_item_names(item_names) {
    array_push(item_names, "Autocannon Turret");
    array_push(item_names, "Twin Linked Lascannon Turret");
    array_push(item_names, "Flamestorm Cannon Turret");
    array_push(item_names, "Twin Linked Assault Cannon Turret");
    array_push(item_names, "Magna-Melta Turret");
    array_push(item_names, "Plasma Destroyer Turret");
    array_push(item_names, "Heavy Conversion Beam Projector");
    array_push(item_names, "Neutron Blaster Turret");
    array_push(item_names, "Volkite Saker Turret");
    // array_push(item_names, "Graviton Cannon Turret");
}

/// @description This function appends the list of predator sponson weapons to the given list.
/// @param {array} item_names - The list to append to.
function push_predator_sponsons_item_names(item_names) {
    array_push(item_names, "Heavy Bolter Sponsons");
    array_push(item_names, "Lascannon Sponsons");
    array_push(item_names, "Heavy Flamer Sponsons");
    array_push(item_names, "Volkite Culverin Sponsons");
}

/// @description This function appends the list of predator pintle weapons to the given list.
/// @param {array} item_names - The list to append to.
function push_predator_pintle_item_names(item_names) {
    array_push(item_names, "Bolter");
    array_push(item_names, "Combiflamer");
    array_push(item_names, "Twin Linked Bolters");
    array_push(item_names, "Storm Bolter");
    array_push(item_names, "HK Missile");
}

/// @description This function appends the list of land speeder primary weapons to the given list.
/// @param {array} item_names - The list to append to.
function push_land_speeder_primary_item_names(item_names) {
    array_push(item_names, "Multi-Melta");
    array_push(item_names, "Heavy Bolter");
}

/// @description This function appends the list of land speeder secondary weapons to the given list.
/// @param {array} item_names - The list to append to.
function push_land_speeder_secondary_item_names(item_names) {
    array_push(item_names, "Assault Cannon");
    array_push(item_names, "Heavy Flamer");
}

/// @description This function appends the list of whirlwind missiles to the given list.
/// @param {array} item_names - The list to append to.
function push_whirlwind_missiles_item_names(item_names) {
    array_push(item_names, "Whirlwind Missiles");
}

/// @description This function appends the list of whirlwind pintle weapons to the given list.
/// @param {array} item_names - The list to append to.
function push_whirlwind_pintle_item_names(item_names) {
    array_push(item_names, "Bolter");
    array_push(item_names, "Combiflamer");
    array_push(item_names, "Twin Linked Bolters");
    array_push(item_names, "Storm Bolter");
    array_push(item_names, "HK Missile");
}

/// @description This function appends the list of tank upgrade items to the given list.
/// @param {array} item_names - The list to append to.
/// @param {bool} is_land_raider - Whether the tank is a land raider.
function push_tank_upgrade_item_names(item_names, is_land_raider=false) {
    array_push(item_names, "Armoured Ceramite");
    array_push(item_names, "Artificer Hull");
    array_push(item_names, "Heavy Armour");
    if (is_land_raider) {
        array_push(item_names, "Void Shield");
    }
}

/// @description This function appends the list of tank accessory items to the given list.
/// @param {array} item_names - The list to append to.
/// @param {bool} is_land_raider - Whether the tank is a land raider.
/// @param {bool} is_dreadnought - Whether the 'tank' is a dreadnought.
function push_tank_accessory_item_names(item_names, is_land_raider=false, is_dreadnought=false) {
    if (!is_dreadnought) {
        array_push(item_names, "Dozer Blades");
    }
    array_push(item_names, "Searchlight");
    array_push(item_names, "Smoke Launchers");
    array_push(item_names, "Frag Assault Launchers");
    if (!is_land_raider && !is_dreadnought) {
        array_push(item_names, "Lucifer Pattern Engine");
    }
}

/// @description Returns a list of equipment names filtered by given criteria.
/// @param {string} equip_category - The category of equipment ("weapon", "armour", "gear", "mobility").
/// @param {bool} melee_or_ranged - Whether the equipment is melee or ranged. true for melee, false for ranged.
/// @param {bool} is_master_crafted - Whether to include only master-crafted items.
/// @param {array} required_tags - Tags that the equipment must have.
/// @param {array} excluded_tags - Tags that the equipment must not have.
/// @param {bool} with_none - Include "(None)" in the list.
/// @param {bool} with_any - Include "(any)" in the list.
/// @returns {array} item_names - The filtered list of equipment names.
function get_filtered_equipment_item_names(equip_category, melee_or_ranged, is_master_crafted=false, required_tags=undefined, excluded_tags=undefined, with_none=false, with_any=false) {
    var item_names = [];
    if (with_none) {
        array_push(item_names, "(None)");
    }
    if (with_any) {
        array_push(item_names, "(any)");
    }
    for (var i = 0; i < array_length(obj_ini.equipment); i++) {
        if (is_master_crafted && !array_contains(obj_ini.equipment_quality[i], "master_crafted")) {
            continue;
        }
        var equip_data = gear_weapon_data(equip_category, obj_ini.equipment[i]);
        if (is_struct(equip_data) && obj_ini.equipment_number[i] > 0) {
            if (melee_or_ranged != undefined) {
                if (melee_or_ranged && equip_data.range > 1.1) {
                    continue;
                } else if (!melee_or_ranged && equip_data.range <= 1.1) {
                    continue;
                }
            }
			var valid = true;
            if (required_tags != undefined) {
                for (var i = 0; i < array_length(required_tags); i++) {
                    if (!equip_data.has_tag(required_tags[i])) {
                        valid = false;
                        break;
                    }
                }
            }
            if (excluded_tags != undefined) {
                for (var i = 0; i < array_length(excluded_tags); i++) {
                    if (equip_data.has_tag(excluded_tags[i])) {
                        valid = false;
                        break;
                    }
                }
            }
			if (valid) {
				array_push(item_names, equip_data.name);
			}
        }
    }
    return item_names;
}

enum eEQUIPMENT_TYPE {
    None,
    PrimaryWeapon = 1,  // LeftHand, Turret, Front, Primary
    SecondaryWeapon = 2,  // RightHand, Sponson, Secondary
    Armour = 3,
    GearUpgrade = 4,
    MobilityAccessory = 5
}

enum eEQUIPMENT_SUBTYPE {
    None,
    Ranged = 1, // Regular land raider weapons
    Melee = 2 // Relic land raider weapons
}

enum eUNIT_TYPE {
    None,
    Infantry = 1,
    Dreadnought = 6,
    LandRaider = 50,
    Rhino = 51,
    Predator = 52,
    LandSpeeder = 53,
    Whirlwind = 54
}

/// @description This function is used to populate the weapon/equipment selection list in the equipment screen.
/// @param {real} equipment_type - The type of equipment to equip, see eEQUIPMENT_TYPE.
/// @param {real} equipment_subtype - The subtype of equipment to equip, see eEQUIPMENT_SUBTYPE.
/// @param {real} unit_type - The type of unit to equip, see eUNIT_TYPE.
/// @param {bool} include_company_standard - Whether to include the Company Standard in the selection list.
/// @param {bool} show_available_only - Whether to limit the selection to what is in inventory, or show all items.
/// @param {bool} master_crafted_only - Whether to show only master crafted items, or hide them.
/// @returns {array} The list of items to populate the selection list with.
function scr_get_item_names(equipment_type, equipment_subtype, unit_type, include_company_standard=false, show_available_only=false, master_crafted_only=false) {
    var item_names;
    switch(unit_type) {
        case eUNIT_TYPE.Infantry:
            switch (equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon:
                case eEQUIPMENT_TYPE.SecondaryWeapon:
                    if (equipment_subtype == eEQUIPMENT_SUBTYPE.Ranged) {
                        if (show_available_only) {
                            item_names = get_filtered_equipment_item_names(
                                "weapon",
                                false, // ranged
                                master_crafted_only,
                                undefined, // no required tags
                                ["vehicle"], // exclude vehicle weapons
                                true, // with_none
                                true  // with_any
                            );
                        } else {
                            item_names = get_none_or_any_item_names(true, false);
                            push_marine_ranged_weapons_item_names(item_names);
                        }
                    } else if (equipment_subtype == eEQUIPMENT_SUBTYPE.Melee) {
                        if (show_available_only) {
                            item_names = get_filtered_equipment_item_names(
                                "weapon",
                                true, // melee
                                master_crafted_only,
                                undefined, // no required tags
                                ["vehicle"], // exclude vehicle weapons
                                true, // with_none
                                true // with_any
                            );
                            if (include_company_standard) {
                                array_push(item_names, "Company Standard");
                            }
                        } else {
                            item_names = get_none_or_any_item_names(true, false);
                            push_marine_melee_weapons_item_names(item_names);
                        }
                    } else {
                        show_error("scr_get_item_names: Invalid equipment subtype for infantry", true);
                    }
                    break;
                case eEQUIPMENT_TYPE.Armour:
                    if (show_available_only) {
                        item_names = get_filtered_equipment_item_names(
                            "armour",
                            undefined, // no range filter
                            false, // not master crafted
                            undefined, // no required tags
                            ["vehicle"], // exclude vehicle armour
                            true, // with_none
                            true // with_any
                        );
                    } else {
                        item_names = get_none_or_any_item_names(true, false);
                        push_marine_armour_item_names(item_names);
                    }
                    break;
                case eEQUIPMENT_TYPE.GearUpgrade:
                    if (show_available_only) {
                        item_names = get_filtered_equipment_item_names(
                            "gear",
                            undefined, // no range filter
                            false, // not master crafted
                            undefined, // no required tags
                            ["vehicle"], // exclude vehicle gear
                            true, // with_none
                            true // with_any
                        );
                    } else {
                        item_names = get_none_or_any_item_names(true, false);
                        push_marine_gear_item_names(item_names);
                    }
                    break;
                case eEQUIPMENT_TYPE.MobilityAccessory:
                    if (show_available_only) {
                        item_names = get_filtered_equipment_item_names(
                            "mobility",
                            undefined, // no range filter
                            false, // not master crafted
                            undefined, // no required tags
                            ["vehicle"], // exclude vehicle mobility
                            true, // with_none
                            true // with_any
                        );
                    } else {
                        item_names = get_none_or_any_item_names(true, false);
                        push_marine_mobility_item_names(item_names);
                    }
                    break;
                default:
                    show_error("scr_get_item_names: Invalid equipment type for infantry", true);
            }        
            break;
        case eUNIT_TYPE.Dreadnought:
            switch (equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon:
                case eEQUIPMENT_TYPE.SecondaryWeapon:
                    if (equipment_subtype == eEQUIPMENT_SUBTYPE.Ranged) {
                        if (show_available_only) {
                            item_names = get_filtered_equipment_item_names(
                                "weapon",
                                false, // ranged
                                master_crafted_only,
                                ["dreadnought"], // required tags
                                undefined, // no excluded tags
                                true, // with_none
                                true // with_any
                            );
                        } else {
                            item_names = get_none_or_any_item_names(true, false);
                            push_dreadnought_ranged_weapons_item_names(item_names);
                        }
                    } else if (equipment_subtype == eEQUIPMENT_SUBTYPE.Melee) {
                        if (show_available_only) {
                            item_names = get_filtered_equipment_item_names(
                                "weapon",
                                true, // melee
                                master_crafted_only,
                                ["dreadnought"], // required tags
                                undefined, // no excluded tags
                                true, // with_none
                                true // with_any
                            );
                        } else {
                            item_names = get_none_or_any_item_names(true, false);
                            push_dreadnought_melee_weapons_item_names(item_names);
                        }
                    } else {
                        show_error("scr_get_item_names: Invalid equipment subtype for dreadnought", true);
                    }
                    break;
                case eEQUIPMENT_TYPE.MobilityAccessory:
                    item_names = get_none_or_any_item_names(true, false);
                    push_tank_accessory_item_names(item_names, false, true);
                    break;
                case eEQUIPMENT_TYPE.Armour:
                case eEQUIPMENT_TYPE.GearUpgrade:
                    // Dreadnought doesn't have these equipment types, but empty lists are shown in the UI
                    break;
                default:
                    show_error("scr_get_item_names: Invalid equipment type for dreadnought", true);
            }
            break;
        case eUNIT_TYPE.LandRaider:
            item_names = get_none_or_any_item_names(true, false);
            switch (equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon:
                    if (equipment_subtype == eEQUIPMENT_SUBTYPE.Ranged) { // Regular land raider weapons
                        push_land_raider_front_weapons_item_names(item_names);
                    } else if (equipment_subtype == eEQUIPMENT_SUBTYPE.Melee) { // Relic land raider weapons
                        push_land_raider_relic_front_weapons_item_names(item_names);
                    } else {
                        show_error("scr_get_item_names: Invalid equipment subtype for land raider", true);
                    }
                    break;
                case eEQUIPMENT_TYPE.SecondaryWeapon:
                    if (equipment_subtype == eEQUIPMENT_SUBTYPE.Ranged) { // Regular land raider weapons
                        // item_name = push_land_raider_regular_sponsons_item_names(true, false);
                        push_land_raider_regular_sponsons_item_names(item_names);
                    } else if (equipment_subtype == eEQUIPMENT_SUBTYPE.Melee) { // Relic land raider weapons
                        // item_name = push_land_raider_relic_sponsons_item_names(true, false);
                        push_land_raider_relic_sponsons_item_names(item_names);
                    } else {
                        show_error("scr_get_item_names: Invalid equipment subtype for land raider", true);
                    }
                    break;
                case eEQUIPMENT_TYPE.Armour: push_land_raider_pintle_item_names(item_names); break;
                case eEQUIPMENT_TYPE.GearUpgrade: push_tank_upgrade_item_names(item_names, true); break;
                case eEQUIPMENT_TYPE.MobilityAccessory: push_tank_accessory_item_names(item_names, true, false); break;
                default:
                    show_error("scr_get_item_names: Invalid equipment type for land raider", true);
            }
            break;
        case eUNIT_TYPE.Rhino:
            item_names = get_none_or_any_item_names(true, false);
            switch (equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: push_rhino_weapons_item_names(item_names); break;
                case eEQUIPMENT_TYPE.GearUpgrade: push_tank_upgrade_item_names(item_names, false); break;
                case eEQUIPMENT_TYPE.MobilityAccessory: push_tank_accessory_item_names(item_names, false, false); break;
                case eEQUIPMENT_TYPE.SecondaryWeapon:
                case eEQUIPMENT_TYPE.Armour:
                    // Rhino doesn't have these equipment types, but empty lists are shown in the UI
                    break;
                default:
                    show_error("scr_get_item_names: Invalid equipment type for rhino", true);
            }
            break;
        case eUNIT_TYPE.Predator:
            item_names = get_none_or_any_item_names(true, false);
            switch (equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: push_predator_turret_item_names(item_names); break;
                case eEQUIPMENT_TYPE.SecondaryWeapon: push_predator_sponsons_item_names(item_names); break;
                case eEQUIPMENT_TYPE.Armour: push_predator_pintle_item_names(item_names); break;
                case eEQUIPMENT_TYPE.GearUpgrade: push_tank_upgrade_item_names(item_names, false); break;
                case eEQUIPMENT_TYPE.MobilityAccessory: push_tank_accessory_item_names(item_names, false, false); break;
                default:
                    show_error("scr_get_item_names: Invalid equipment type for predator", true);
            }
            break;
        case eUNIT_TYPE.LandSpeeder:
            item_names = get_none_or_any_item_names(true, false);
            switch (equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: push_land_speeder_primary_item_names(item_names); break;
                case eEQUIPMENT_TYPE.SecondaryWeapon: push_land_speeder_secondary_item_names(item_names); break;
                case eEQUIPMENT_TYPE.GearUpgrade:
                case eEQUIPMENT_TYPE.Armour:
                case eEQUIPMENT_TYPE.MobilityAccessory:
                    // Land speeder doesn't have these equipment types, but empty lists are shown in the UI
                    break;
                default:
                    show_error("scr_get_item_names: Invalid equipment type for land speeder", true);
            }
            break;
        case eUNIT_TYPE.Whirlwind:
            item_names = get_none_or_any_item_names(true, false);
            switch (equipment_type) {
                case eEQUIPMENT_TYPE.PrimaryWeapon: push_whirlwind_missiles_item_names(item_names); break;
                case eEQUIPMENT_TYPE.SecondaryWeapon: push_whirlwind_pintle_item_names(item_names); break;
                case eEQUIPMENT_TYPE.GearUpgrade: push_tank_upgrade_item_names(item_names, false); break;
                case eEQUIPMENT_TYPE.MobilityAccessory: push_tank_accessory_item_names(item_names, false, false); break;
                case eEQUIPMENT_TYPE.Armour:
                    // Whirlwind doesn't have this equipment type, but an empty list is shown in the UI
                    break;
                default:
                    show_error("scr_get_item_names: Invalid equipment type for whirlwind", true);
            }
            break;
    }
    return item_names;
}
