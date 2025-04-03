hover = 0;
shop = "weapons";
in_forge = false;
click = 0;
click2 = 0;
discount_rogue_trader = 1;
forge_cost_mod = 1;
discount_stc = 0;
construction_started = 0;
eta = 0;
target_comp = obj_controller.new_vehicles;
renegade = false;

slate_panel = new DataSlate();
scroll_point = 0;
tooltip_show = 0;
tooltip = "";
tooltip_stat1 = 0;
tooltip_stat2 = 0;
tooltip_stat3 = 0;
tooltip_stat4 = 0;
tooltip_other = "";
last_item = "";

forge_master = scr_role_count("Forge Master", "", "units");
if (array_length(forge_master) > 0) {
    forge_master = forge_master[0];
} else {
    forge_master = "none";
}

if (instance_number(obj_shop) > 1) {
    var war;
    war = instance_nearest(0, 0, obj_shop);
    shop = war.shop;
    with(war) {
        instance_destroy();
    }
    x = 0;
    y = 0;
}

if (obj_controller.faction_status[eFACTION.Imperium] == "War") {
    renegade = 1;
    with(obj_temp6) {
        instance_destroy();
    }
    with(obj_star) {
        var u;
        u = 0;
        repeat(4) {
            u += 1;
            if ((p_type[u] == "Forge") && (p_owner[u] == 1)) {
                instance_create(x, y, obj_temp6);
            }
        }
    }
    if (instance_exists(obj_temp6)) {
        renegade = 0;
    }
    with(obj_temp6) {
        instance_destroy();
    }
}

tab_buttons = {
    "weapons": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
    "armour": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
    "vehicles": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
    "ships": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3)
};

item_name = array_create(160, "");
x_mod = array_create(160, 0);
item_stocked = array_create(160, 0);
mc_stocked = array_create(160, 0);
buy_cost = array_create(160, 0);
no_buying = array_create(160, false);
forge_cost = array_create(160, 0);
no_forging = array_create(160, false);
sellers = array_create(160, ["Mechanicus"]);
tooltip_override = array_create(160, 0);
forge_type = array_create(160, "normal");
renegade_buy = array_create(160, false);

if (shop == "weapons") {
    var _weapon_names = variable_struct_get_names(global.weapons);
    for (var i = 0; i < array_length(_weapon_names); ++i) {
        var _weapon_name = _weapon_names[i];
        if (!struct_exists(global.weapons_shop_data, _weapon_name)) {
            continue;
        }

        var _tags = global.weapons[$ _weapon_name].tags;
        if (array_contains_ext(_tags, ["turret", "Sponson", "sponson"])) {
            continue;
        }

        var _weapon_shop_data = global.weapons_shop_data[$ _weapon_name];
        if (struct_exists(_weapon_shop_data, "no_buy")) {
            no_buying[i] = _weapon_shop_data[$ "no_buy"];
        }

        item_name[i] = _weapon_name;
        item_stocked[i] = scr_item_count(_weapon_name);
        mc_stocked[i] = scr_item_count(item_name[i], "master_crafted");
        buy_cost[i] = _weapon_shop_data[$ "value"];

        if (in_forge) {
            if (struct_exists(_weapon_shop_data, "requires")) {
                var _required_names = _weapon_shop_data[$ "requires"];
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

    var disc = obj_controller.stc_wargear * 5;
    item_cost_tooltip_info += $"Wargear STC: -{disc}%\n";
    forge_cost_mod -= disc;
} else if (shop == "armour") {
    var _armour_names = variable_struct_get_names(global.gear[$ "armour"]);
    for (var i = 0; i < array_length(_armour_names); ++i) {
        var _armour_name = _armour_names[i];
        if (!struct_exists(global.armour_shop_data, _armour_name)) {
            continue;
        }

        var _armour_shop_data = global.armour_shop_data[$ _armour_name];
        if (struct_exists(_armour_shop_data, "no_buy")) {
            no_buying[i] = _armour_shop_data[$ "no_buy"];
        }

        item_name[i] = _armour_name;
        item_stocked[i] = scr_item_count(_armour_name);
        mc_stocked[i] = scr_item_count(_armour_name, "master_crafted");
        buy_cost[i] = _armour_shop_data[$ "value"];

        if (in_forge) {
            if (struct_exists(_armour_shop_data, "requires")) {
                var _required_names = _armour_shop_data[$ "requires"];
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
    var disc = obj_controller.stc_wargear * 5;
    item_cost_tooltip_info += $"Wargear STC: -{disc}%\n";
    forge_cost_mod -= disc;
} else if (shop == "gear") {
    var _gear_names = variable_struct_get_names(global.gear[$ "gear"]);
    for (var i = 0; i < array_length(_gear_names); ++i) {
        var _gear_name = _gear_names[i];
        if (!struct_exists(global.gear_shop_data, _gear_name)) {
            continue;
        }

        var _gear_shop_data = global.gear_shop_data[$ _gear_name];
        if (struct_exists(_gear_shop_data, "no_buy")) {
            no_buying[i] = _gear_shop_data[$ "no_buy"];
        }

        item_name[i] = _gear_name;
        tooltip_override[i] = facility_data[$ "description"];
        item_stocked[i] = scr_item_count(_gear_name);
        mc_stocked[i] = scr_item_count(item_name[i], "master_crafted");
        buy_cost[i] = _gear_shop_data[$ "value"];

        if (in_forge) {
            if (struct_exists(_gear_shop_data, "requires")) {
                var _required_names = _gear_shop_data[$ "requires"];
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
    var disc = obj_controller.stc_wargear * 5;
    item_cost_tooltip_info += $"Wargear STC: -{disc}%\n";
    forge_cost_mod -= disc;
} else if (shop == "vehicles") {
    var _gear_names = variable_struct_get_names(global.gear[$ "gear"]);
    for (var i = 0; i < array_length(_gear_names); ++i) {
        var _gear_name = _gear_names[i];
        if (!struct_exists(global.gear_shop_data, _gear_name)) {
            continue;
        }

        var _gear_shop_data = global.gear_shop_data[$ _gear_name];
        if (struct_exists(_gear_shop_data, "no_buy")) {
            no_buying[i] = _gear_shop_data[$ "no_buy"];
        }

        item_name[i] = _gear_name;
        tooltip_override[i] = facility_data[$ "description"];
        item_stocked[i] = scr_item_count(_gear_name);
        mc_stocked[i] = scr_item_count(item_name[i], "master_crafted");
        buy_cost[i] = _gear_shop_data[$ "value"];

        if (in_forge) {
            if (struct_exists(_gear_shop_data, "requires")) {
                var _required_names = _gear_shop_data[$ "requires"];
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
    var facilities_names = variable_struct_get_names(global.technology_shop_data);
    for (var i = 0; i < array_length(facilities_names); i++) {
        var facility_name = facilities_names[i];
        var facility_data = global.technology_shop_data[$ facility_name];

        if (!struct_exists(facility_data, "cost")) {
            continue;
        }

        if (struct_exists(facility_data, "requires")) {
            var _required_names = facility_data[$ "requires"];
            for (var r = 0; r < array_length(_required_names); r++) {
                var _required_name = _required_names[r];
                if (!array_contains(obj_controller.technologies_known, _required_name)) {
                    no_forging[i] = true;
                    break;
                }
            }
        }

        item_name[i] = facility_data[$ "name"];
        tooltip_override[i] = facility_data[$ "description"];
        forge_type[i] = "research";
        forge_cost[i] = facility_data[$ "cost"];
    }
}

legitimate_items = i;

with(obj_p_fleet) {
    if ((capital_number > 0) && (action == "")) {
        var you = instance_nearest(x, y, obj_star);
        if (you.trader > 0) {
            obj_shop.discount_rogue_trader = 0.8;
        }
    }
}

with(obj_star) {
    if (array_contains(p_owner, 1) && (trader > 0)) {
        obj_shop.discount_rogue_trader = 0.8;
    }
}

item_cost_tooltip_info = "";
if (discount_rogue_trader != 1) {
    item_cost_tooltip_info += $"Near a Rogue Trader: x{discount_rogue_trader}\n";
}

if (forge_master != "none") {
    forge_master_cha_modifier = (((forge_master.charisma - 30) / 200) * -1) + 1;
    forge_master_tec_modifier = (((forge_master.technology - 50) / 200) * -1) + 1;
    if (forge_master.has_trait("flesh_is_weak")) {
        forge_master_tec_modifier -= 0.1;
    }
} else {
    forge_master_tec_modifier = 1.5;
    forge_master_cha_modifier = 1.5;
}
item_cost_tooltip_info += $"Forge Master charisma: x{forge_master_cha_modifier}\n";

if (obj_controller.tech_status == "heretics") {
    var tech_heretic_modifier = 1.5;
    mechanicus_modifier += tech_heretic_modifier;
    item_cost_tooltip_info += $"Tech-Heretics: x{tech_heretic_modifier}\n";
}

imperium_modifier = (((obj_controller.disposition[eFACTION.Imperium] - 50) / 200) * -1) + 1;
mechanicus_modifier = (((obj_controller.disposition[eFACTION.Mechanicus] - 50) / 200) * -1) + 1;
inquisition_modifier = (((obj_controller.disposition[eFACTION.Inquisition] - 50) / 200) * -1) + 1;
ecclesiarchy_modifier = (((obj_controller.disposition[eFACTION.Ecclesiarchy] - 50) / 200) * -1) + 1;
if (renegade == 1) {
    imperium_modifier += 1;
    mechanicus_modifier += 1;
    inquisition_modifier += 1;
    ecclesiarchy_modifier += 1;
}
mechanicus_modifier *= forge_master_tec_modifier;
item_cost_tooltip_info += $"Forge Master technology: x{forge_master_tec_modifier}\n";

var best_modifier = 1;
var best_seller = "Unknown";
for (var i = 0; i < array_length(buy_cost); i++) {
    best_modifier = 1;
    best_seller = "Unknown";

    if (renegade != 1) {
        // Check each sellers
        for (var g = 0; g < array_length(sellers[i]); g++) {
            var current_modifier = 1;
            var current_seller = "Unknown";
            // Determine the modifier for the current sellers
            if (array_contains(sellers[i], "Imperium")) {
                current_modifier = imperium_modifier;
                current_seller = "Imperium";
            } else if (array_contains(sellers[i], "Mechanicus")) {
                current_modifier = mechanicus_modifier;
                current_seller = "Mechanicus";
            } else if (array_contains(sellers[i], "Inquisition")) {
                current_modifier = inquisition_modifier;
                current_seller = "Inquisition";
            } else if (array_contains(sellers[i], "Ecclesiarchy")) {
                current_modifier = ecclesiarchy_modifier;
                current_seller = "Ecclesiarchy";
            } else {
                continue; // Skip this iteration if the sellers is not recognized
            }
            // If the current modifier is better than the best one found so far, update the best modifier and sellers
            if (current_modifier < best_modifier) {
                best_modifier = current_modifier;
                best_seller = current_seller;
            }
        }
        // Now, best_modifier is the best modifier among all sellers, and best_sellers is the sellers with the best modifier
    }

    buy_cost[i] *= min(best_modifier * forge_master_cha_modifier, discount_rogue_trader);
    buy_cost[i] = max(round(buy_cost[i]), 1);

    forge_cost[i] *= forge_cost_mod;
}
