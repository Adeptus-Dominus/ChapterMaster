shop = "weapons";

tab_buttons = {
    /// @type {Struct.MainMenuButton}
    weapons: new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
    armour: new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
    vehicles: new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
    ships: new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
};

in_forge = false;
construction_started = 0;
eta = 0;
target_comp = obj_controller.new_vehicles;

slate_panel = new DataSlate();
page_mod = 0;
tooltip_stat1 = 0;
tooltip_stat2 = 0;
tooltip_stat3 = 0;
tooltip_stat4 = 0;
tooltip_other = "";
item_cost_tooltip_info = "";

forge_cost_mod = 1;
discount_stc = 0;
tech_heretic_modifier = 0;
discount_rogue_trader = 1;

shop_items = {
    weapons: [],
    armour: [],
    gear: [],
    mobility: [],
};

shop_data_lookup = {
    weapons: global.weapons,
    armour: global.gear[$ "armour"],
    gear: global.gear[$ "gear"],
    mobility: global.gear[$ "mobility"],
};

/// @description Sells an item and adds resources to the player
/// @param {Struct.ShopItem} _shop_item The index of the item in the global array
/// @param {Real} sell_count The quantity to sell
/// @param {Real} sell_modifier The value modifier
/// @returns {Bool} Whether the sale was successful
sell_item = function(_shop_item, sell_count, sell_modifier) {
    if (_shop_item.stocked >= sell_count) {
        var sell_price = (_shop_item.buy_cost * sell_modifier) * sell_count;

        scr_add_item(_shop_item.name, (-sell_count), "standard");
        _shop_item.stocked -= sell_count;
        obj_controller.requisition += sell_price;

        return true;
    }

    return false;
};

with (obj_p_fleet) {
    if ((capital_number > 0) && (action == "")) {
        /// @type {Asset.GMObject.obj_star}
        var you = instance_nearest(x, y, obj_star);

        if (you.trader > 0) {
            obj_shop.discount_rogue_trader = 0.8;
        }
    }
}

with (obj_star) {
    if (array_contains(p_owner, 1) && (trader > 0)) {
        obj_shop.discount_rogue_trader = 0.8;
    }
}

if (discount_rogue_trader != 1) {
    item_cost_tooltip_info += $"Near a Rogue Trader: x{discount_rogue_trader}\n";
}

if (struct_exists(shop_data_lookup, shop)) {
    var _shop_info = shop_data_lookup[$ shop];
    var _item_names = variable_struct_get_names(_shop_info);
    array_sort(_item_names, true);

    for (var i = 0, count = array_length(_item_names); i < count; ++i) {
        var _name = _item_names[i];

        if (!struct_exists(_shop_info, _name)) {
            continue;
        }

        var _shop_data = _shop_info[$ _name];

        if (shop == "weapons") {
            var _tags = _shop_data.tags;
            if (array_contains_ext(_tags, ["turret", "Sponson", "sponson"])) {
                continue;
            }
        }

        /// @type {Struct.ShopItem}
        var _shop_item = new ShopItem(_name);
        _shop_item.area = shop;

        var _equip_data = gear_weapon_data("any", _shop_item.name);
        if (is_struct(_equip_data)) {
            tooltip = $"{_equip_data.item_tooltip_desc_gen()}";
        } else {
            tooltip = "";
        }

        _shop_item.stocked = scr_item_count(_name);
        _shop_item.mc_stocked = scr_item_count(_name, "master_crafted");

        if (struct_exists(_shop_data, "value")) {
            _shop_item.value = _shop_data[$ "value"];
            _shop_item.no_buying = false;
        }

        if (struct_exists(_shop_data, "no_buying")) {
            _shop_item.no_buying = _shop_data[$ "no_buying"];
        }

        _shop_item.update_best_seller(_shop_item.sellers);

        if (in_forge) {
            if (global.cheat_debug) {
                _shop_item.forge_cost = 0;
                _shop_item.no_forging = false;
                array_push(shop_items[$ shop], _shop_item);
            } else {
                if (struct_exists(_shop_data, "requires_to_build")) {
                    var _required_names = _shop_data[$ "requires_to_build"];
                    for (var r = 0, req_count = array_length(_required_names); r < req_count; ++r) {
                        if (!array_contains(obj_controller.technologies_known, _required_names[r])) {
                            _shop_item.no_forging = true;
                            break;
                        }
                    }
                }
    
                if (!_shop_item.no_forging) {
                    var disc = obj_controller.stc_wargear * 5;
                    item_cost_tooltip_info += $"Wargear STC: -{disc}%\n";
                    forge_cost_mod -= disc;
    
                    _shop_item.forge_cost = _shop_item.value * 10;
                    _shop_item.forge_cost *= forge_cost_mod;
                }

                array_push(shop_items[$ shop], _shop_item);
            }
        } else {
            if (global.cheat_debug) {
                _shop_item.buy_cost = 0;
                _shop_item.no_buying = false;
                array_push(shop_items[$ shop], _shop_item);
            } else if (!_shop_item.no_buying || _shop_item.stocked > 0) {
                _shop_item.buy_cost = _shop_item.value * (min(_shop_item.buy_cost_mod, discount_rogue_trader));
                _shop_item.buy_cost = round(_shop_item.buy_cost);
                array_push(shop_items[$ shop], _shop_item);
            }
        }

    }
} else if (shop == "vehicles") {
    var _gear_names = variable_struct_get_names(global.gear[$ "gear"]);
    array_sort(_gear_names, true);
    for (var i = 0; i < array_length(_gear_names); ++i) {
        var _gear_name = _gear_names[i];
        if (!struct_exists(global.gear_shop_data, _gear_name)) {
            continue;
        }

        var _gear_shop_data = global.gear_shop_data[$ _gear_name];
        if (struct_exists(_gear_shop_data, "no_buying")) {
            no_buying[i] = _gear_shop_data[$ "no_buying"];
        }

        item_name[i] = _gear_name;
        tooltip_override[i] = facility_data[$ "description"];
        item_stocked[i] = scr_item_count(_gear_name);
        mc_stocked[i] = scr_item_count(item_name[i], "master_crafted");
        buy_cost[i] = _gear_shop_data[$ "value"];

        if (in_forge) {
            if (struct_exists(_gear_shop_data, "requires_to_build")) {
                var _required_names = _gear_shop_data[$ "requires_to_build"];
                for (var r = 0; r < array_length(_required_names); r++) {
                    var _required_name = _required_names[r];
                    if (!array_contains(obj_controller.technologies_known, _required_name)) {
                        no_forging[i] = true;
                        break;
                    }
                }
            }
            if (!no_forging[i]) {
                forge_cost[i] = buy_cost[i] * 10;
            }
        }
    }

    discount_stc = obj_controller.stc_vehicles * 3;
    var _player_hangers = array_length(obj_controller.player_forge_data.vehicle_hanger);
    var _hangar_discount = _player_hangers * 3;

    item_cost_tooltip_info += $"Vehicle STC: -{discount_stc}%\n";
    item_cost_tooltip_info += $"Hangars: -{_hangar_discount}%\n";
    forge_cost_mod -= discount_stc;
    forge_cost_mod -= _hangar_discount;
} else if (shop == "warships") {
    discount_stc = obj_controller.stc_ships * 5;
    item_cost_tooltip_info += $"Ship STC: -{discount_stc}%\n";
    forge_cost_mod -= discount_stc;
} else if (shop == "production") {
    var technology_names = variable_struct_get_names(global.technology_shop_data);
    array_sort(technology_names, true);
    for (var i = 0, count = array_length(technology_names); i < count; ++i) {
        var facility_name = technology_names[i];
        var facility_data = global.technology_shop_data[$ facility_name];

        if (!struct_exists(facility_data, "cost")) {
            continue;
        }

        item_name[i] = facility_data[$ "name"];
        tooltip_override[i] = facility_data[$ "description"];
        forge_type[i] = "research";
        forge_cost[i] = facility_data[$ "cost"];
        no_forging[i] = false;

        if (struct_exists(facility_data, "requires_to_build")) {
            var _required_names = facility_data[$ "requires_to_build"];
            for (var r = 0, req_count = array_length(_required_names); r < req_count; ++r) {
                if (!array_contains(obj_controller.technologies_known, _required_names[r])) {
                    no_forging[i] = true;
                    break;
                }
            }
        }
    }
}
